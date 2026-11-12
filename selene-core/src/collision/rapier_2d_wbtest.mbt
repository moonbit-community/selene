///|
fn collision_test_filter() -> CollisionFilter {
  CollisionFilter::all(CollisionGroup())
}

///|
fn collision_test_shape() -> CollisionShape {
  Rect(size=Vec2(16.0, 16.0), offset=@math.Vec2::zero())
}

///|
fn test_spatial(position : @math.Vec2) -> @transform.Spatial {
  Spatial(@transform.Transform::from_xyz(position.x, position.y, 0.0))
}

///|
fn spawn_test_body(
  body : RigidBody,
  position~ : @math.Vec2 = @math.Vec2::zero(),
  shape~ : CollisionShape = collision_test_shape(),
  collider~ : Collider = Collider(collision_test_filter()),
) -> @ecs.Entity {
  @ecs_test.spawn(
    @ecs.require_current_world(),
    (test_spatial(position), shape, collider, body),
  )
}

///|
fn test_translation(world~ : @ecs.World, entity : @ecs.Entity) -> @math.Vec2 {
  let transform = @transform.local_transform(world~, entity).unwrap_or_default()
  Vec2(transform.translation.x, transform.translation.y)
}

///|
fn collision_test_cleanup(
  world~ : @ecs.World,
  entities : Array[@ecs.Entity],
) -> Unit {
  for entity in entities {
    ignore(@ecs_test.delete(entity))
  }
  rapier_fixed_step(world~, 0.016)
  try! @ecs.Schedule().run(@ecs.require_current_world())
  configure_physics(
    gravity=@math.Vec2::zero(),
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
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=4,
  )
  let entity = spawn_test_body(
    {
      ..RigidBody::dynamic(),
      gravity_scale: 2.0,
      linear_damping: 1.5,
      angular_damping: 0.25,
      ccd_enabled: true,
      lock_rotation: false,
    },
    collider=Collider::with_material(
      collision_test_filter(),
      friction=0.2,
      restitution=0.75,
    ),
  )
  defer collision_test_cleanup(world~, [entity])

  rapier_fixed_step(world~, 0.016)

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
  guard physics_world().bodies.get(body_handle) is Some(body) else {
    inspect("missing", content="true")
    return
  }
  guard physics_world().colliders.get(collider_handle) is Some(collider) else {
    inspect("missing", content="true")
    return
  }

  inspect(body.body_type() is Dynamic, content="true")
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
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=Vec2(0.0, 400.0),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = spawn_test_body(RigidBody::dynamic())
  defer collision_test_cleanup(world~, [entity])

  rapier_fixed_step(world~, 0.1)

  inspect(test_translation(world~, entity).y > 0.0, content="true")
  inspect(
    resolved_velocities()
    .get(entity)
    .map_or(false, fn(velocity) { velocity.0.y > 0.0 }),
    content="true",
  )
}

///|
test "explicit body type overrides legacy velocity heuristic" {
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let world = @ecs.require_current_world()
  let spatial = () => test_spatial(@math.Vec2::zero())
  let shape = collision_test_shape()
  let collider = Collider(collision_test_filter())
  let velocity = @velocity.Velocity(Vec2(120.0, 0.0))
  let fixed_entity = @ecs_test.spawn(
    world,
    (spatial(), shape, collider, velocity, RigidBody::fixed()),
  )
  let kinematic_entity = @ecs_test.spawn(
    world,
    (
      spatial(),
      shape,
      collider,
      velocity,
      RigidBody::kinematic_velocity_based(),
    ),
  )
  defer collision_test_cleanup(world~, [fixed_entity, kinematic_entity])

  rapier_fixed_step(world~, 0.25)

  inspect(
    test_translation(world~, fixed_entity).x.abs() <= 0.001,
    content="true",
  )
  inspect(test_translation(world~, kinematic_entity).x > 20.0, content="true")
  inspect(
    resolved_velocities()
    .get(kinematic_entity)
    .map_or(false, fn(velocity) { velocity.0.x > 20.0 }),
    content="true",
  )
}

///|
test "spatial queries resolve hits, overlaps, and body filters" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let shape : CollisionShape = Rect(
    size=Vec2(40.0, 40.0),
    offset=@math.Vec2::zero(),
  )
  let fixed_entity = spawn_test_body(
    RigidBody::fixed(),
    position=Vec2(120.0, 80.0),
    shape~,
  )
  let dynamic_entity = spawn_test_body(
    RigidBody::dynamic(),
    position=Vec2(220.0, 80.0),
    shape~,
  )
  let kinematic_entity = spawn_test_body(
    RigidBody::kinematic_position_based(),
    position=Vec2(320.0, 80.0),
    shape~,
  )
  defer collision_test_cleanup(world~, [
    fixed_entity, dynamic_entity, kinematic_entity,
  ])

  rapier_fixed_step(world~, 0.016)

  inspect(
    raycast(world~, @math.Vec2::zero() + Vec2(0.0, 100.0), Vec2(1.0, 0.0)).map_or(
      false,
      fn(hit) { hit.entity == fixed_entity && hit.toi > 100.0 },
    ),
    content="true",
  )
  inspect(
    intersect_point(world~, Vec2(140.0, 100.0)).contains(fixed_entity),
    content="true",
  )
  inspect(
    intersect_shape(
      world~,
      Ball(radius=8.0, offset=@math.Vec2::zero()),
      Vec2(140.0, 100.0),
    ).contains(fixed_entity),
    content="true",
  )
  inspect(
    shape_cast(
      world~,
      Ball(radius=8.0, offset=@math.Vec2::zero()),
      Vec2(0.0, 100.0),
      direction=Vec2(1.0, 0.0),
    ).map_or(false, fn(hit) { hit.entity == fixed_entity }),
    content="true",
  )

  let dynamic_filter = { ..SpatialQueryFilter(), body_filter: Dynamic, }
  let fixed_filter = { ..SpatialQueryFilter(), body_filter: Fixed, }
  let kinematic_filter = { ..SpatialQueryFilter(), body_filter: Kinematic, }
  inspect(
    intersect_point(world~, Vec2(240.0, 100.0), query_filter=dynamic_filter).contains(
      dynamic_entity,
    ),
    content="true",
  )
  inspect(
    intersect_point(world~, Vec2(140.0, 100.0), query_filter=fixed_filter).contains(
      fixed_entity,
    ),
    content="true",
  )
  inspect(
    intersect_point(world~, Vec2(340.0, 100.0), query_filter=kinematic_filter).contains(
      kinematic_entity,
    ),
    content="true",
  )
  inspect(
    raycast(world~, Vec2(180.0, 100.0), Vec2(1.0, 0.0), query_filter={
      ..SpatialQueryFilter(),
      exclude_entity: Some(dynamic_entity),
    }).map_or(false, fn(hit) { hit.entity == kinematic_entity }),
    content="true",
  )
}

///|
test "rigid body setters and getters work before insertion" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = spawn_test_body({ ..RigidBody::dynamic(), lock_rotation: false, })
  defer collision_test_cleanup(world~, [entity])

  set_rigid_body_translation(world~, entity, Vec2(32.0, 12.0))
  set_rigid_body_rotation(world~, entity, 0.25)
  set_rigid_body_linear_velocity(world~, entity, Vec2(120.0, 0.0))
  set_rigid_body_angular_velocity(world~, entity, 2.0)

  inspect(
    rigid_body_translation(world~, entity).map_or(false, fn(value) {
      collision_test_close(value.x, 32.0) && collision_test_close(value.y, 12.0)
    }),
    content="true",
  )
  inspect(
    rigid_body_rotation(world~, entity).map_or(false, fn(value) {
      collision_test_close(value, 0.25)
    }),
    content="true",
  )
  inspect(
    rigid_body_linear_velocity(world~, entity).map_or(false, fn(value) {
      collision_test_close(value.x, 120.0)
    }),
    content="true",
  )
  inspect(
    rigid_body_angular_velocity(world~, entity).map_or(false, fn(value) {
      collision_test_close(value, 2.0)
    }),
    content="true",
  )

  rapier_fixed_step(world~, 0.1)

  inspect(
    rigid_body_translation(world~, entity).map_or(false, fn(value) {
      value.x > 40.0
    }),
    content="true",
  )
  inspect(
    rigid_body_rotation(world~, entity).map_or(false, fn(value) { value > 0.3 }),
    content="true",
  )
}

///|
test "force and impulse helpers apply before and after body creation" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let entity = spawn_test_body({ ..RigidBody::dynamic(), lock_rotation: false, })
  defer collision_test_cleanup(world~, [entity])

  apply_impulse(entity, Vec2(200.0, 0.0))
  apply_torque_impulse(entity, 1.0)

  rapier_fixed_step(world~, 0.05)
  let first_x = rigid_body_translation(world~, entity).unwrap_or(
      @math.Vec2::zero(),
    ).x

  inspect(first_x > 0.0, content="true")
  inspect(
    rigid_body_angular_velocity(world~, entity).map_or(false, fn(value) {
      value > 0.0
    }),
    content="true",
  )

  add_force(entity, Vec2(80.0, 0.0))
  add_force_at_point(entity, Vec2(0.0, 120.0), Vec2(8.0, 8.0))

  rapier_fixed_step(world~, 0.05)

  inspect(
    rigid_body_translation(world~, entity).map_or(false, fn(value) {
      value.x > first_x
    }),
    content="true",
  )
  inspect(
    rigid_body_angular_velocity(world~, entity).map_or(false, fn(value) {
      value.abs() > 0.0
    }),
    content="true",
  )
}

///|
test "impulse joints insert and accept all supported joint kinds" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let body_a = spawn_test_body(RigidBody::fixed())
  let body_b = spawn_test_body(
    { ..RigidBody::dynamic(), lock_rotation: false, },
    position=Vec2(32.0, 0.0),
  )
  let joint_entity = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Joint::fixed(body_a, body_b),
  )
  defer collision_test_cleanup(world~, [body_a, body_b, joint_entity])

  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  inspect(physics_world().impulse_joints.len() == 1, content="true")

  world.set_component(
    joint_entity,
    (
      Joint::revolute(
        body_a,
        body_b,
        limits=JointLimits(-0.5, 0.5),
        motor=JointMotor::position(0.25, 5.0, 0.5, max_force=3.0),
        softness=JointSoftness(0.7, 6.0),
      ) : Joint),
  )
  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  inspect(physics_world().impulse_joints.len() == 1, content="true")

  world.set_component(
    joint_entity,
    (
      Joint::prismatic(
        body_a,
        body_b,
        Vec2(1.0, 0.0),
        limits=JointLimits(-24.0, 24.0),
      ) : Joint),
  )
  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  world.set_component(joint_entity, (Joint::rope(body_a, body_b, 48.0) : Joint))
  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  world.set_component(
    joint_entity,
    (
      Joint::spring(
        body_a,
        body_b,
        24.0,
        8.0,
        0.8,
        model=JointMotorModel::force_based(),
        active=false,
        contacts_enabled=true,
      ) : Joint),
  )
  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")
  guard joint_handle(joint_entity) is Some(handle) else {
    inspect("missing", content="true")
    return
  }
  inspect(
    physics_world().impulse_joints
    .get(handle)
    .map_or(false, fn(joint) { !joint.is_enabled() }),
    content="true",
  )
}

///|
test "impulse joints are removed when endpoints disappear" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let body_a = spawn_test_body(RigidBody::dynamic())
  let body_b = spawn_test_body(RigidBody::dynamic(), position=Vec2(32.0, 0.0))
  let joint_entity = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Joint::fixed(body_a, body_b),
  )
  defer collision_test_cleanup(world~, [body_a, body_b, joint_entity])

  rapier_fixed_step(world~, 0.016)
  inspect(joint_handle(joint_entity) is Some(_), content="true")

  ignore(@ecs_test.delete(body_b))

  rapier_fixed_step(world~, 0.016)

  inspect(joint_handle(joint_entity) is None, content="true")
  inspect(physics_world().impulse_joints.len() == 0, content="true")
}

///|
test "multibody joints insert, expose handles, and rebuild chains" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let ecs_world = @ecs.require_current_world()
  let body = { ..RigidBody::dynamic(), lock_rotation: false, }
  let parent = spawn_test_body(body)
  let shape = collision_test_shape()
  let collider = Collider(collision_test_filter())
  let child = @ecs_test.spawn(
    ecs_world,
    (
      test_spatial(Vec2(32.0, 0.0)),
      shape,
      collider,
      body,
      MultibodyJoint::revolute(
        parent,
        local_anchor1=Vec2(8.0, 0.0),
        local_anchor2=Vec2(-8.0, 0.0),
        limits=JointLimits(-0.5, 0.5),
        motor=JointMotor::position(0.25, 4.0, 0.75, max_force=2.0),
        softness=JointSoftness(0.8, 6.0),
      ),
    ),
  )
  let grandchild = @ecs_test.spawn(
    ecs_world,
    (
      test_spatial(Vec2(64.0, 0.0)),
      shape,
      collider,
      body,
      MultibodyJoint::revolute(
        child,
        local_anchor1=Vec2(8.0, 0.0),
        local_anchor2=Vec2(-8.0, 0.0),
      ),
    ),
  )
  defer collision_test_cleanup(world~, [parent, child, grandchild])

  rapier_fixed_step(world~, 0.016)

  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(multibody_joint_handle(grandchild) is Some(_), content="true")
  inspect(multibody_link(child) is Some(_), content="true")
  inspect(
    physics_world().multibody_joints.revolute_joint_descriptors().length() == 2,
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
  for
    descriptor in physics_world().multibody_joints.revolute_joint_descriptors() {
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

  world.set_component(
    child,
    (MultibodyJoint::revolute(parent, active=false) : MultibodyJoint),
  )
  rapier_fixed_step(world~, 0.016)
  inspect(multibody_joint_handle(child) is None, content="true")
  inspect(
    physics_world().multibody_joints.revolute_joint_descriptors().length() == 1,
    content="true",
  )

  world.set_component(
    child,
    (
      MultibodyJoint::revolute(
        parent,
        limits=JointLimits(-0.25, 0.25),
        motor=JointMotor::velocity(1.5, 0.5, max_force=1.0),
      ) : MultibodyJoint),
  )
  rapier_fixed_step(world~, 0.016)
  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(
    physics_world().multibody_joints.revolute_joint_descriptors().length() == 2,
    content="true",
  )
}

///|
test "multibody joints are removed when endpoints disappear" {
  let world = @ecs.require_current_world()
  configure_physics(
    gravity=@math.Vec2::zero(),
    pixels_per_meter=100.0,
    max_ccd_substeps=1,
  )
  let parent = spawn_test_body(RigidBody::dynamic())
  let child = @ecs_test.spawn(
    @ecs.require_current_world(),
    (
      test_spatial(Vec2(32.0, 0.0)),
      collision_test_shape(),
      Collider(collision_test_filter()),
      RigidBody::dynamic(),
      MultibodyJoint::revolute(parent),
    ),
  )
  defer collision_test_cleanup(world~, [parent, child])

  rapier_fixed_step(world~, 0.016)
  inspect(multibody_joint_handle(child) is Some(_), content="true")
  inspect(
    physics_world().multibody_joints.revolute_joint_descriptors().length() == 1,
    content="true",
  )

  ignore(@ecs_test.delete(parent))

  rapier_fixed_step(world~, 0.016)

  inspect(multibody_joint_handle(child) is None, content="true")
  inspect(
    physics_world().multibody_joints.revolute_joint_descriptors().length() == 0,
    content="true",
  )
}
