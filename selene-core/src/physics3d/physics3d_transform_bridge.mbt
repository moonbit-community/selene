///|
fn vec3_to_rapier(value : @math.Vec3) -> @core.Vec3 {
  Vec3(
    Float::from_double(value.x),
    Float::from_double(value.y),
    Float::from_double(value.z),
  )
}

///|
fn vec3_from_rapier(value : @core.Vec3) -> @math.Vec3 {
  Vec3(value.x.to_double(), value.y.to_double(), value.z.to_double())
}

///|
fn rotation_to_rapier(rotation : @math.Rotation3) -> @core.Quat {
  let self = rotation.to_quat()
  Quat(
    Float::from_double(self.x),
    Float::from_double(self.y),
    Float::from_double(self.z),
    Float::from_double(self.w),
  )
}

///|
fn rotation_from_rapier(value : @core.Quat) -> @math.Rotation3 {
  @math.Rotation3::try_from_quat(
    Quat(
      value.x.to_double(),
      value.y.to_double(),
      value.z.to_double(),
      value.w.to_double(),
    ),
  ).unwrap_or_default()
}

///|
fn interaction_groups(
  memberships : Int32,
  filters : Int32,
) -> @dynamics.InteractionGroups {
  InteractionGroups(Group(memberships), Group(filters), And)
}

///|
fn cleanup_world_components(physics~ : PhysicsStep3D) -> Unit {
  let query_collider = physics.collider
  let query_rigid_body = physics.rigid_body
  let query_impulse_joint = physics.impulse_joint
  let query_multibody_joint = physics.multibody_joint
  let physics_world = physics.runtime.world
  let collider_handles = physics.runtime.collider_handles
  let body_handles = physics.runtime.body_handles
  let impulse_joint_handles = physics.runtime.impulse_joint_handles
  let multibody_joint_handles = physics.runtime.multibody_joint_handles
  let collider_entities_by_key = physics.runtime.collider_entities_by_key
  collider_handles.retain((entity, handle) => {
    if physics.entities.is_alive(entity) &&
      query_collider.contains(entity) &&
      collider_transform(
        physics~,
        entity,
        attached_rigid_body_entity(physics~, entity),
      )
      is Some(_) {
      return true
    }
    ignore(physics_world.colliders.remove(handle))
    collider_entities_by_key.remove(collider_key(handle))
    false
  })
  body_handles.retain((entity, handle) => {
    if physics.entities.is_alive(entity) &&
      query_rigid_body.contains(entity) &&
      current_world_transform(physics~, entity) is Some(_) {
      return true
    }
    ignore(physics_world.bodies.remove(handle))
    false
  })

  impulse_joint_handles.retain((entity, _) => {
    physics.entities.is_alive(entity) && query_impulse_joint.contains(entity)
  })

  multibody_joint_handles.retain((entity, _) => {
    physics.entities.is_alive(entity) && query_multibody_joint.contains(entity)
  })
}

///|
fn collect_events(physics~ : PhysicsStep3D) -> Unit {
  let physics_world = physics.runtime.world
  for collision_event in physics_world.event_handler.take_collision_events() {
    let collider1 = collision_event.collider1()
    let collider2 = collision_event.collider2()
    guard resolve_collider_entity(physics~, collider1) is Some(entity_a) else {
      continue
    }
    guard resolve_collider_entity(physics~, collider2) is Some(entity_b) else {
      continue
    }
    if collision_event.sensor() {
      physics.sensor_event_bus.send({
        sensor: entity_a,
        other: entity_b,
        entered: collision_event.started(),
      })
    }
    physics.collision_event_bus.send({
      entity_a,
      entity_b,
      started: collision_event.started(),
      stopped: collision_event.stopped(),
      sensor: collision_event.sensor(),
      normal: @math.Vec3::zero(),
    })
  }

  for
    intersection_event in physics_world.event_handler.take_intersection_events() {
    guard resolve_collider_entity(physics~, intersection_event.collider1())
      is Some(sensor_entity) else {
      continue
    }
    guard resolve_collider_entity(physics~, intersection_event.collider2())
      is Some(other_entity) else {
      continue
    }
    physics.sensor_event_bus.send({
      sensor: sensor_entity,
      other: other_entity,
      entered: intersection_event.intersecting(),
    })
  }

  for
    contact_force_event in physics_world.event_handler.take_contact_force_events() {
    guard resolve_collider_entity(physics~, contact_force_event.collider1())
      is Some(entity_a) else {
      continue
    }
    guard resolve_collider_entity(physics~, contact_force_event.collider2())
      is Some(entity_b) else {
      continue
    }
    physics.contact_force_event_bus.send({
      entity_a,
      entity_b,
      total_force: vec3_from_rapier(contact_force_event.total_force()),
      total_force_magnitude: contact_force_event
      .total_force_magnitude()
      .to_double(),
      max_force_direction: vec3_from_rapier(
        contact_force_event.max_force_direction(),
      ),
      max_force_magnitude: contact_force_event.max_force_magnitude().to_double(),
    })
  }
}

///|
fn fixed_joint_to_rapier(
  joint : FixedJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint3DRealBuilder::GenericJoint3DRealBuilder(
    @dynamics.JointAxesMask3DReal::all(),
  )
  .contacts_enabled(contacts_enabled)
  .local_anchor1(vec3_to_rapier(joint.local_anchor1))
  .local_anchor2(vec3_to_rapier(joint.local_anchor2))
  .local_basis1(rotation_to_rapier(joint.local_basis1))
  .local_basis2(rotation_to_rapier(joint.local_basis2))
  .build()
}

///|
fn revolute_joint_to_rapier(
  joint : RevoluteJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  revolute_joint_to_generic(joint, contacts_enabled~).to_3d_real()
}

///|
fn revolute_joint_to_generic(
  joint : RevoluteJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint {
  let locked = @dynamics.JointAxesMask3DReal::lin_axes()
    .or(@dynamics.JointAxesMask3DReal::ang_y())
    .or(@dynamics.JointAxesMask3DReal::ang_z())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::GenericJoint3DRealBuilder(
      locked,
    )
    .contacts_enabled(contacts_enabled)
    .local_axis1(vec3_to_rapier(joint.axis))
    .local_axis2(vec3_to_rapier(joint.axis))
  builder = builder
    .local_anchor1(vec3_to_rapier(joint.local_anchor1))
    .local_anchor2(vec3_to_rapier(joint.local_anchor2))
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      AngX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      AngX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      AngX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(AngX, Float::from_double(max_force))
  }
  let mut generic = builder
    .build()
    .to_generic_joint()
    .set_motor_model(AngX, joint.motor_model)
  if joint.softness is Some(softness) {
    generic = generic.set_softness(softness)
  }
  generic
}

///|
fn prismatic_joint_to_rapier(
  joint : PrismaticJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let locked = @dynamics.JointAxesMask3DReal::lin_y()
    .or(@dynamics.JointAxesMask3DReal::lin_z())
    .or(@dynamics.JointAxesMask3DReal::ang_axes())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::GenericJoint3DRealBuilder(
      locked,
    )
    .contacts_enabled(contacts_enabled)
    .local_axis1(vec3_to_rapier(joint.axis))
    .local_axis2(vec3_to_rapier(joint.axis))
  builder = builder
    .local_anchor1(vec3_to_rapier(joint.local_anchor1))
    .local_anchor2(vec3_to_rapier(joint.local_anchor2))
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      LinX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      LinX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      LinX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(LinX, Float::from_double(max_force))
  }
  builder.build()
}

///|
fn spherical_joint_to_rapier(
  joint : SphericalJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let mut builder = @dynamics.GenericJoint3DRealBuilder::GenericJoint3DRealBuilder(
    @dynamics.JointAxesMask3DReal::lin_axes(),
  ).contacts_enabled(contacts_enabled)
  builder = builder
    .local_anchor1(vec3_to_rapier(joint.local_anchor1))
    .local_anchor2(vec3_to_rapier(joint.local_anchor2))
  builder.build()
}

///|
fn rope_joint_to_rapier(
  joint : RopeJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint::from_rope(
    @dynamics.RopeJointBuilder3::RopeJointBuilder3(
      Float::from_double(joint.max_distance),
    )
    .local_anchor1(vec3_to_rapier(joint.local_anchor1))
    .local_anchor2(vec3_to_rapier(joint.local_anchor2))
    .build(),
  )
  .set_contacts_enabled(contacts_enabled)
  .to_3d_real()
}

///|
fn spring_joint_to_rapier(
  joint : SpringJoint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint::from_rope(
    @dynamics.RopeJointBuilder3::RopeJointBuilder3(
      Float::from_double(joint.rest_length),
    )
    .local_anchor1(vec3_to_rapier(joint.local_anchor1))
    .local_anchor2(vec3_to_rapier(joint.local_anchor2))
    .motor_position(
      Float::from_double(joint.rest_length),
      Float::from_double(joint.stiffness),
      Float::from_double(joint.damping),
    )
    .build(),
  )
  .set_contacts_enabled(contacts_enabled)
  .to_3d_real()
}

///|
fn multibody_joint_to_rapier(
  joint : Joint,
  contacts_enabled~ : Bool = true,
) -> @dynamics.GenericJoint3DReal? {
  match joint {
    Fixed(fixed_joint) =>
      Some(fixed_joint_to_rapier(fixed_joint, contacts_enabled~))
    Revolute(revolute_joint) =>
      Some(revolute_joint_to_rapier(revolute_joint, contacts_enabled~))
    Prismatic(prismatic_joint) =>
      Some(prismatic_joint_to_rapier(prismatic_joint, contacts_enabled~))
    Rope(rope_joint) =>
      Some(rope_joint_to_rapier(rope_joint, contacts_enabled~))
    Spherical(spherical_joint) => {
      let mut builder = @dynamics.GenericJoint3DRealBuilder::GenericJoint3DRealBuilder(
          @dynamics.JointAxesMask3DReal::lin_axes(),
        )
        .contacts_enabled(contacts_enabled)
        .local_anchor1(vec3_to_rapier(spherical_joint.local_anchor1))
        .local_anchor2(vec3_to_rapier(spherical_joint.local_anchor2))
      if spherical_joint.motor_target is Some((target, stiffness, damping)) {
        let axis = rotation_to_rapier(target).to_scaled_axis()
        builder = builder
          .motor_position(
            AngX,
            axis.x,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .motor_position(
            AngY,
            axis.y,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .motor_position(
            AngZ,
            axis.z,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
      }
      Some(builder.build())
    }
    Spring(spring_joint) =>
      Some(spring_joint_to_rapier(spring_joint, contacts_enabled~))
  }
}

///|
fn controller_to_rapier(
  controller : KinematicCharacterController,
) -> @control.KinematicCharacterController3DReal {
  @control.KinematicCharacterController3DReal::KinematicCharacterController3DReal()
  .with_offset(controller.offset)
  .with_slide(controller.slide)
  .with_autostep(controller.autostep)
  .with_max_slope_climb_angle(
    Float::from_double(controller.max_slope_climb_angle),
  )
  .with_min_slope_slide_angle(
    Float::from_double(controller.min_slope_slide_angle),
  )
  .with_snap_to_ground(controller.snap_to_ground)
  .with_normal_nudge_factor(Float::from_double(controller.normal_nudge_factor))
  .with_up(vec3_to_rapier(controller.up))
}

///|
fn apply_character_controller_translation(
  physics~ : PhysicsStep3D,
  entity : @ecs.Entity,
  translation : @math.Vec3,
  delta : Double,
) -> Unit {
  if translation.length_squared() <= 0.000000001 {
    return
  }
  guard current_world_transform(physics~, entity) is Some(transform) else {
    return
  }
  let target = transform.translation + translation
  let target_world_transform = { ..transform, translation: target, }
  guard set_entity_world_transform(physics~, entity, target_world_transform) else {
    return
  }
  match physics.rigid_body.get(entity).map(value => value.0) {
    Some(KinematicPositionBased) =>
      match physics.runtime.body_handles.get(entity) {
        Some(handle) =>
          match physics.runtime.world.bodies.get_mut(handle) {
            Some(body) =>
              body.set_next_kinematic_translation(vec3_to_rapier(target))
            None => ()
          }
        None => ()
      }
    Some(KinematicVelocityBased) =>
      if delta > 0.0 {
        let velocity = @math.Vec3(
          translation.x / delta,
          translation.y / delta,
          translation.z / delta,
        )
        if physics.velocity.get(entity).map(value => value.0) is Some(current) {
          physics.velocity.set(
            entity,
            Single(({ ..current, linvel: velocity, } : Velocity)),
          )
        } else if physics.runtime.body_handles.get(entity) is Some(handle) &&
          physics.runtime.world.bodies.get_mut(handle) is Some(body) {
          body.set_linvel(vec3_to_rapier(velocity))
        }
      }
    _ => ()
  }
}

///|
fn make_query_pipeline(
  physics~ : PhysicsStep3D,
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> @collision.QueryPipeline3DReal {
  let physics_world = physics.runtime.world
  QueryPipeline3DReal(
    to_query_filter(physics~, query_filter),
    physics_world.bodies,
    physics_world.colliders,
  )
}

///|
fn to_query_shape(shape : Collider) -> @collision.Shape3D {
  match shape {
    Cuboid(half_extents) =>
      @collision.Shape3D::cuboid(
        Float::from_double(half_extents.x),
        Float::from_double(half_extents.y),
        Float::from_double(half_extents.z),
      )
    Ball(radius) => @collision.Shape3D::ball(Float::from_double(radius))
    CapsuleX(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleY(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleZ(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.Shape3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cone(half_height, radius) =>
      @collision.Shape3D::cone(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    RoundCylinder(half_height, radius, border_radius) =>
      @collision.Shape3D::round_cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
        Float::from_double(border_radius),
      )
    Halfspace(normal) =>
      @collision.Shape3D::halfspace(vec3_to_rapier(normal.normalize_or_zero()))
    ConvexHull(points) =>
      ConvexHull(points.map(point => vec3_to_rapier(point)), 0.0)
    TriMesh(vertices, indices) =>
      TriMesh(vertices.map(point => vec3_to_rapier(point)), indices)
    Heightfield(heights, nrows, ncols, scale) =>
      @collision.ColliderBuilder3D::heightfield(
        heights.map(Float::from_double),
        nrows,
        ncols,
        vec3_to_rapier(scale),
      )
      .map(builder => builder.build().shape())
      .unwrap_or(@collision.Shape3D::ball(0.0))
  }
}

///|
fn to_query_shape_with_rotation(
  shape : Collider,
  rotation : @math.Rotation3,
) -> (@collision.Shape3D, @math.Rotation3) {
  match shape {
    CapsuleX(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Rotation3::from_axis_angle(
          @math.Vec3::z_axis(),
          -1.5707963267948966,
        ),
      )
    CapsuleZ(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Rotation3::from_axis_angle(
          @math.Vec3::x_axis(),
          1.5707963267948966,
        ),
      )
    _ => (to_query_shape(shape), rotation)
  }
}

///|
fn to_query_filter(
  physics~ : PhysicsStep3D,
  query_filter : QueryFilter,
) -> @collision.QueryFilter3DReal {
  let mut filter = match query_filter.body_filter {
    All => @collision.QueryFilter3DReal::QueryFilter3DReal()
    Dynamic => @collision.QueryFilter3DReal::only_dynamic()
    Fixed => @collision.QueryFilter3DReal::only_fixed()
    Kinematic => @collision.QueryFilter3DReal::only_kinematic()
  }
  if query_filter.groups is Some(groups) {
    filter = filter.groups(
      InteractionGroups(Group(groups.memberships), Group(groups.filters), And),
    )
  }
  if query_filter.exclude_collider is Some(collider_handle) {
    filter = filter.exclude_collider(collider_handle)
  }
  if query_filter.exclude_rigid_body is Some(body_handle) {
    filter = filter.exclude_rigid_body(body_handle)
  }
  if query_filter.exclude_entity is Some(entity) {
    if physics.runtime.collider_handles.get(entity) is Some(collider_handle) {
      filter = filter.exclude_collider(collider_handle)
    }
    if physics.runtime.body_handles.get(entity) is Some(body_handle) {
      filter = filter.exclude_rigid_body(body_handle)
    }
  }
  if query_filter.exclude_sensors {
    filter = filter.exclude_sensors()
  }
  if query_filter.exclude_solids {
    filter = filter.exclude_solids()
  }
  filter
}

///|
fn shape_world_aabb(
  shape : @collision.Shape3D,
  translation : @math.Vec3,
  rotation : @math.Rotation3,
) -> @core.Aabb3 {
  let local_aabb = shape.local_aabb()
  let mins = local_aabb.mins
  let maxs = local_aabb.maxs
  let corners = [
    @math.Vec3(mins.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    Vec3(mins.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    Vec3(mins.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    Vec3(mins.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
    Vec3(maxs.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    Vec3(maxs.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    Vec3(maxs.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    Vec3(maxs.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
  ]
  let world_points = corners.map(point => {
    rotation.rotate_vec3(point) + translation
  })
  let mut min_point = world_points[0]
  let mut max_point = world_points[0]
  for point in world_points {
    min_point = Vec3(
      Double::min(min_point.x, point.x),
      Double::min(min_point.y, point.y),
      Double::min(min_point.z, point.z),
    )
    max_point = Vec3(
      Double::max(max_point.x, point.x),
      Double::max(max_point.y, point.y),
      Double::max(max_point.z, point.z),
    )
  }
  @core.Aabb3::from_points(vec3_to_rapier(min_point), vec3_to_rapier(max_point))
}
