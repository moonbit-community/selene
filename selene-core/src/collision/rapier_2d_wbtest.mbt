///|
fn collision_test_filter() -> CollisionFilter {
  CollisionFilter::all(CollisionGroup::new())
}

///|
fn collision_test_shape() -> CollisionShape {
  Rect(size=@math.Vec2D(16.0, 16.0), offset=@math.Vec2D::zero())
}

///|
fn collision_test_cleanup(entities : Array[@entity.Entity]) -> Unit {
  for entity in entities {
    colliders.remove(entity)
    areas.remove(entity)
    shapes.remove(entity)
    rigid_bodies.remove(entity)
    joints.remove(entity)
    multibody_joints.remove(entity)
    @velocity.velocities.remove(entity)
    resolved_velocities.remove(entity)
    grounded_entities.remove(entity)
    @position.positions.remove(entity)
    entity.destroy()
  }
  rapier_fixed_step(0.016)
  @entity.entity_flush_system(0.0)
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
}

///|
fn collision_test_close(left : Double, right : Double) -> Bool {
  (left - right).abs() <= 0.0001
}

///|
test "explicit rigid body syncs material and rapier handles" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=4,
  )
  let entity = @entity.Entity::new()
  defer collision_test_cleanup([entity])

  @position.positions.set(entity, @math.Vec2D::zero())
  shapes.set(entity, collision_test_shape())
  colliders.set(
    entity,
    Collider::with_material(
      collision_test_filter(),
      friction=0.2,
      restitution=0.75,
    ),
  )
  rigid_bodies.set(entity, {
    ..RigidBody::dynamic(),
    gravity_scale: 2.0,
    linear_damping: 1.5,
    angular_damping: 0.25,
    ccd_enabled: true,
    lock_rotation: false,
  })

  rapier_fixed_step(0.016)

  inspect(rigid_body_handle(entity) is Some(_), content="true")
  inspect(collider_handle(entity) is Some(_), content="true")
  guard rigid_body_handle(entity) is Some(body_handle) else {
    inspect("missing", content="true")
    return
  }
  guard collider_handle(entity) is Some(collider_handle) else {
    inspect("missing", content="true")
    return
  }
  guard world.bodies.get(body_handle) is Some(body) else {
    inspect("missing", content="true")
    return
  }
  guard world.colliders.get(collider_handle) is Some(collider) else {
    inspect("missing", content="true")
    return
  }

  inspect(
    body.body_type() is @rapier_dynamics.RigidBodyType::Dynamic,
    content="true",
  )
  inspect(
    collision_test_close(body.gravity_scale().to_double(), 2.0),
    content="true",
  )
  inspect(
    collision_test_close(body.linear_damping().to_double(), 1.5),
    content="true",
  )
  inspect(
    collision_test_close(body.angular_damping().to_double(), 0.25),
    content="true",
  )
  inspect(body.is_ccd_enabled(), content="true")
  inspect(body.locked_rotations(), content="false")
  inspect(
    collision_test_close(collider.friction().to_double(), 0.2),
    content="true",
  )
  inspect(
    collision_test_close(collider.restitution().to_double(), 0.75),
    content="true",
  )
}

///|
test "dynamic rigid body moves under gravity without legacy velocity component" {
  configure_physics(
    gravity=@math.Vec2D(0.0, 400.0),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = @entity.Entity::new()
  defer collision_test_cleanup([entity])

  @position.positions.set(entity, @math.Vec2D::zero())
  shapes.set(entity, collision_test_shape())
  colliders.set(entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(entity, RigidBody::dynamic())

  rapier_fixed_step(0.1)

  inspect(@position.positions.get(entity).unwrap().0[Y] > 0.0, content="true")
  inspect(
    resolved_velocities
    .get(entity)
    .map_or(false, fn(velocity) { velocity.0[Y] > 0.0 }),
    content="true",
  )
}

///|
test "explicit body type overrides legacy velocity heuristic" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let fixed_entity = @entity.Entity::new()
  let kinematic_entity = @entity.Entity::new()
  defer collision_test_cleanup([fixed_entity, kinematic_entity])

  for entity in [fixed_entity, kinematic_entity] {
    @position.positions.set(entity, @math.Vec2D::zero())
    shapes.set(entity, collision_test_shape())
    colliders.set(entity, Collider::new(collision_test_filter()))
    @velocity.velocities.set(entity, @math.Vec2D(120.0, 0.0))
  }
  rigid_bodies.set(fixed_entity, RigidBody::fixed())
  rigid_bodies.set(kinematic_entity, RigidBody::kinematic_velocity_based())

  rapier_fixed_step(0.25)

  inspect(
    @position.positions.get(fixed_entity).unwrap().0[X].abs() <= 0.001,
    content="true",
  )
  inspect(
    @position.positions.get(kinematic_entity).unwrap().0[X] > 20.0,
    content="true",
  )
  inspect(
    resolved_velocities
    .get(kinematic_entity)
    .map_or(false, fn(velocity) { velocity.0[X] > 20.0 }),
    content="true",
  )
}

///|
test "spatial queries resolve hits, overlaps, and body filters" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let fixed_entity = @entity.Entity::new()
  let dynamic_entity = @entity.Entity::new()
  let kinematic_entity = @entity.Entity::new()
  defer collision_test_cleanup([fixed_entity, dynamic_entity, kinematic_entity])

  @position.positions.set(fixed_entity, @math.Vec2D(120.0, 80.0))
  shapes.set(
    fixed_entity,
    Rect(size=@math.Vec2D(40.0, 40.0), offset=@math.Vec2D::zero()),
  )
  colliders.set(fixed_entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(fixed_entity, RigidBody::fixed())

  @position.positions.set(dynamic_entity, @math.Vec2D(220.0, 80.0))
  shapes.set(
    dynamic_entity,
    Rect(size=@math.Vec2D(40.0, 40.0), offset=@math.Vec2D::zero()),
  )
  colliders.set(dynamic_entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(dynamic_entity, RigidBody::dynamic())

  @position.positions.set(kinematic_entity, @math.Vec2D(320.0, 80.0))
  shapes.set(
    kinematic_entity,
    Rect(size=@math.Vec2D(40.0, 40.0), offset=@math.Vec2D::zero()),
  )
  colliders.set(kinematic_entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(kinematic_entity, RigidBody::kinematic_position_based())

  rapier_fixed_step(0.016)

  inspect(
    raycast(
      @math.Vec2D::zero() + @math.Vec2D(0.0, 100.0),
      @math.Vec2D(1.0, 0.0),
    ).map_or(false, fn(hit) { hit.entity == fixed_entity && hit.toi > 100.0 }),
    content="true",
  )
  inspect(
    intersect_point(@math.Vec2D(140.0, 100.0)).contains(fixed_entity),
    content="true",
  )
  inspect(
    intersect_shape(
      Ball(radius=8.0, offset=@math.Vec2D::zero()),
      @math.Vec2D(140.0, 100.0),
    ).contains(fixed_entity),
    content="true",
  )
  inspect(
    shape_cast(
      Ball(radius=8.0, offset=@math.Vec2D::zero()),
      @math.Vec2D(0.0, 100.0),
      direction=@math.Vec2D(1.0, 0.0),
    ).map_or(false, fn(hit) { hit.entity == fixed_entity }),
    content="true",
  )

  let dynamic_filter = {
    ..SpatialQueryFilter::default(),
    body_filter: SpatialQueryBodyFilter::Dynamic,
  }
  let fixed_filter = {
    ..SpatialQueryFilter::default(),
    body_filter: SpatialQueryBodyFilter::Fixed,
  }
  let kinematic_filter = {
    ..SpatialQueryFilter::default(),
    body_filter: SpatialQueryBodyFilter::Kinematic,
  }
  inspect(
    intersect_point(@math.Vec2D(240.0, 100.0), query_filter=dynamic_filter).contains(
      dynamic_entity,
    ),
    content="true",
  )
  inspect(
    intersect_point(@math.Vec2D(140.0, 100.0), query_filter=fixed_filter).contains(
      fixed_entity,
    ),
    content="true",
  )
  inspect(
    intersect_point(@math.Vec2D(340.0, 100.0), query_filter=kinematic_filter).contains(
      kinematic_entity,
    ),
    content="true",
  )
  inspect(
    raycast(@math.Vec2D(180.0, 100.0), @math.Vec2D(1.0, 0.0), query_filter={
      ..SpatialQueryFilter::default(),
      exclude_entity: Some(dynamic_entity),
    }).map_or(false, fn(hit) { hit.entity == kinematic_entity }),
    content="true",
  )
}

///|
test "rigid body setters and getters work before insertion" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = @entity.Entity::new()
  defer collision_test_cleanup([entity])

  @position.positions.set(entity, @math.Vec2D::zero())
  shapes.set(entity, collision_test_shape())
  colliders.set(entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(entity, { ..RigidBody::dynamic(), lock_rotation: false })

  set_rigid_body_translation(entity, @math.Vec2D(32.0, 12.0))
  set_rigid_body_rotation(entity, 0.25)
  set_rigid_body_linear_velocity(entity, @math.Vec2D(120.0, 0.0))
  set_rigid_body_angular_velocity(entity, 2.0)

  inspect(
    rigid_body_translation(entity).map_or(false, fn(value) {
      collision_test_close(value[X], 32.0) &&
      collision_test_close(value[Y], 12.0)
    }),
    content="true",
  )
  inspect(
    rigid_body_rotation(entity).map_or(false, fn(value) {
      collision_test_close(value, 0.25)
    }),
    content="true",
  )
  inspect(
    rigid_body_linear_velocity(entity).map_or(false, fn(value) {
      collision_test_close(value[X], 120.0)
    }),
    content="true",
  )
  inspect(
    rigid_body_angular_velocity(entity).map_or(false, fn(value) {
      collision_test_close(value, 2.0)
    }),
    content="true",
  )

  rapier_fixed_step(0.1)

  inspect(
    rigid_body_translation(entity).map_or(false, fn(value) { value[X] > 40.0 }),
    content="true",
  )
  inspect(
    rigid_body_rotation(entity).map_or(false, fn(value) { value > 0.3 }),
    content="true",
  )
}

///|
test "force and impulse helpers apply before and after body creation" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = @entity.Entity::new()
  defer collision_test_cleanup([entity])

  @position.positions.set(entity, @math.Vec2D::zero())
  shapes.set(entity, collision_test_shape())
  colliders.set(entity, Collider::new(collision_test_filter()))
  rigid_bodies.set(entity, { ..RigidBody::dynamic(), lock_rotation: false })

  apply_impulse(entity, @math.Vec2D(200.0, 0.0))
  apply_torque_impulse(entity, 1.0)

  rapier_fixed_step(0.05)
  let first_x = rigid_body_translation(entity).unwrap_or(@math.Vec2D::zero())[X]

  inspect(first_x > 0.0, content="true")
  inspect(
    rigid_body_angular_velocity(entity).map_or(false, fn(value) { value > 0.0 }),
    content="true",
  )

  add_force(entity, @math.Vec2D(80.0, 0.0))
  add_force_at_point(entity, @math.Vec2D(0.0, 120.0), @math.Vec2D(8.0, 8.0))

  rapier_fixed_step(0.05)

  inspect(
    rigid_body_translation(entity).map_or(false, fn(value) {
      value[X] > first_x
    }),
    content="true",
  )
  inspect(
    rigid_body_angular_velocity(entity).map_or(false, fn(value) {
      value.abs() > 0.0
    }),
    content="true",
  )
}

///|
test "impulse joints insert and accept all supported joint kinds" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let body_a = @entity.Entity::new()
  let body_b = @entity.Entity::new()
  let joint_entity = @entity.Entity::new()
  defer collision_test_cleanup([body_a, body_b, joint_entity])

  @position.positions.set(body_a, @math.Vec2D::zero())
  shapes.set(body_a, collision_test_shape())
  colliders.set(body_a, Collider::new(collision_test_filter()))
  rigid_bodies.set(body_a, RigidBody::fixed())

  @position.positions.set(body_b, @math.Vec2D(32.0, 0.0))
  shapes.set(body_b, collision_test_shape())
  colliders.set(body_b, Collider::new(collision_test_filter()))
  rigid_bodies.set(body_b, { ..RigidBody::dynamic(), lock_rotation: false })

  joints.set(joint_entity, Joint::fixed(body_a, body_b))
  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  inspect(world.impulse_joints.len() == 1, content="true")

  joints.set(
    joint_entity,
    Joint::revolute(
      body_a,
      body_b,
      limits=JointLimits::new(-0.5, 0.5),
      motor=JointMotor::position(0.25, 5.0, 0.5, max_force=3.0),
      softness=JointSoftness::new(0.7, 6.0),
    ),
  )
  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  inspect(world.impulse_joints.len() == 1, content="true")

  joints.set(
    joint_entity,
    Joint::prismatic(
      body_a,
      body_b,
      @math.Vec2D(1.0, 0.0),
      limits=JointLimits::new(-24.0, 24.0),
    ),
  )
  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  joints.set(joint_entity, Joint::rope(body_a, body_b, 48.0))
  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  joints.set(
    joint_entity,
    Joint::spring(
      body_a,
      body_b,
      24.0,
      8.0,
      0.8,
      model=JointMotorModel::force_based(),
      active=false,
      contacts_enabled=true,
    ),
  )
  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  guard joint_handle(joint_entity) is Some(handle) else {
    inspect("missing", content="true")
    return
  }
  inspect(
    world.impulse_joints
    .get(handle)
    .map_or(false, fn(joint) { !joint.is_enabled() }),
    content="true",
  )
}

///|
test "impulse joints are removed when endpoints disappear" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let body_a = @entity.Entity::new()
  let body_b = @entity.Entity::new()
  let joint_entity = @entity.Entity::new()
  defer collision_test_cleanup([body_a, body_b, joint_entity])

  for entry in [(body_a, @math.Vec2D::zero()), (body_b, @math.Vec2D(32.0, 0.0))] {
    @position.positions.set(entry.0, entry.1)
    shapes.set(entry.0, collision_test_shape())
    colliders.set(entry.0, Collider::new(collision_test_filter()))
    rigid_bodies.set(entry.0, RigidBody::dynamic())
  }
  joints.set(joint_entity, Joint::fixed(body_a, body_b))

  rapier_fixed_step(0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  colliders.remove(body_b)
  shapes.remove(body_b)
  rigid_bodies.remove(body_b)
  @position.positions.remove(body_b)

  rapier_fixed_step(0.016)

  inspect(joint_handle(joint_entity) is None, content="true")
  inspect(world.impulse_joints.len() == 0, content="true")
}

///|
test "multibody joints insert, expose handles, and rebuild chains" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let parent = @entity.Entity::new()
  let child = @entity.Entity::new()
  let grandchild = @entity.Entity::new()
  defer collision_test_cleanup([parent, child, grandchild])

  for
    entry in [
      (parent, @math.Vec2D::zero()),
      (child, @math.Vec2D(32.0, 0.0)),
      (grandchild, @math.Vec2D(64.0, 0.0)),
    ] {
    @position.positions.set(entry.0, entry.1)
    shapes.set(entry.0, collision_test_shape())
    colliders.set(entry.0, Collider::new(collision_test_filter()))
    rigid_bodies.set(entry.0, { ..RigidBody::dynamic(), lock_rotation: false })
  }

  multibody_joints.set(
    child,
    MultibodyJoint::revolute(
      parent,
      local_anchor1=@math.Vec2D(8.0, 0.0),
      local_anchor2=@math.Vec2D(-8.0, 0.0),
      limits=JointLimits::new(-0.5, 0.5),
      motor=JointMotor::position(0.25, 4.0, 0.75, max_force=2.0),
      softness=JointSoftness::new(0.8, 6.0),
    ),
  )
  multibody_joints.set(
    grandchild,
    MultibodyJoint::revolute(
      child,
      local_anchor1=@math.Vec2D(8.0, 0.0),
      local_anchor2=@math.Vec2D(-8.0, 0.0),
    ),
  )

  rapier_fixed_step(0.016)

  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(multibody_joint_handle(grandchild) is Some(_), content="true")
  inspect(multibody_link(child) is Some(_), content="true")
  inspect(
    world.multibody_joints.revolute_joint_descriptors().length() == 2,
    content="true",
  )

  guard rigid_body_handle(parent) is Some(parent_handle) else {
    inspect("missing", content="true")
    return
  }
  guard rigid_body_handle(child) is Some(child_handle) else {
    inspect("missing", content="true")
    return
  }
  guard rigid_body_handle(grandchild) is Some(grandchild_handle) else {
    inspect("missing", content="true")
    return
  }
  let parent_key = body_handle_parts(parent_handle)
  let child_key = body_handle_parts(child_handle)
  let grandchild_key = body_handle_parts(grandchild_handle)
  let mut found_child_joint = false
  let mut found_grandchild_joint = false
  for descriptor in world.multibody_joints.revolute_joint_descriptors() {
    if body_handle_parts(descriptor.parent) == parent_key &&
      body_handle_parts(descriptor.child) == child_key {
      found_child_joint = descriptor.joint
        .limits()
        .map_or(false, fn(limits) {
          collision_test_close(limits.min().to_double(), -0.5) &&
          collision_test_close(limits.max().to_double(), 0.5)
        }) &&
        descriptor.joint
        .motor()
        .map_or(false, fn(motor) {
          collision_test_close(motor.target_pos.to_double(), 0.25) &&
          collision_test_close(motor.stiffness.to_double(), 4.0) &&
          collision_test_close(motor.damping.to_double(), 0.75) &&
          collision_test_close(motor.max_force.to_double(), 2.0)
        }) &&
        collision_test_close(
          descriptor.joint.softness().damping_ratio.to_double(),
          0.8,
        ) &&
        collision_test_close(
          descriptor.joint.softness().natural_frequency.to_double(),
          6.0,
        )
    } else if body_handle_parts(descriptor.parent) == child_key &&
      body_handle_parts(descriptor.child) == grandchild_key {
      found_grandchild_joint = true
    }
  }
  inspect(found_child_joint, content="true")
  inspect(found_grandchild_joint, content="true")

  multibody_joints.set(child, MultibodyJoint::revolute(parent, active=false))
  rapier_fixed_step(0.016)
  inspect(multibody_joint_handle(child) is None, content="true")
  inspect(
    world.multibody_joints.revolute_joint_descriptors().length() == 1,
    content="true",
  )

  multibody_joints.set(
    child,
    MultibodyJoint::revolute(
      parent,
      limits=JointLimits::new(-0.25, 0.25),
      motor=JointMotor::velocity(1.5, 0.5, max_force=1.0),
    ),
  )
  rapier_fixed_step(0.016)
  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(
    world.multibody_joints.revolute_joint_descriptors().length() == 2,
    content="true",
  )
}

///|
test "multibody joints are removed when endpoints disappear" {
  configure_physics(
    gravity=@math.Vec2D::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let parent = @entity.Entity::new()
  let child = @entity.Entity::new()
  defer collision_test_cleanup([parent, child])

  for entry in [(parent, @math.Vec2D::zero()), (child, @math.Vec2D(32.0, 0.0))] {
    @position.positions.set(entry.0, entry.1)
    shapes.set(entry.0, collision_test_shape())
    colliders.set(entry.0, Collider::new(collision_test_filter()))
    rigid_bodies.set(entry.0, RigidBody::dynamic())
  }
  multibody_joints.set(child, MultibodyJoint::revolute(parent))

  rapier_fixed_step(0.016)
  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(
    world.multibody_joints.revolute_joint_descriptors().length() == 1,
    content="true",
  )

  colliders.remove(parent)
  shapes.remove(parent)
  rigid_bodies.remove(parent)
  @position.positions.remove(parent)

  rapier_fixed_step(0.016)

  inspect(multibody_joint_handle(child) is None, content="true")
  inspect(
    world.multibody_joints.revolute_joint_descriptors().length() == 0,
    content="true",
  )
}
