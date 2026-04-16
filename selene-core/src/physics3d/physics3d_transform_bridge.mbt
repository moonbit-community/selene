///|
fn interaction_groups(
  memberships : Int,
  filters : Int,
) -> @dynamics.InteractionGroups {
  @dynamics.InteractionGroups::new(
    @dynamics.Group::new(memberships),
    @dynamics.Group::new(filters),
    And,
  )
}

///|
fn cleanup_world_components() -> Unit {
  let world = physics3d_world()
  let collider_handles = collider_handles()
  let body_handles = body_handles()
  let impulse_joint_handles = impulse_joint_handles()
  let multibody_joint_handles = multibody_joint_handles()
  let collider_entities_by_key = collider_entities_by_key()
  for pair in collider_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    let missing_component = !colliders().contains(entity)
    if !entity.is_alive() || missing_component {
      world.colliders.remove(handle) |> ignore
      collider_handles.remove(entity)
      collider_entities_by_key.remove(collider_key(handle))
    }
  }

  for pair in body_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    if !entity.is_alive() || !rigid_bodies().contains(entity) {
      world.bodies.remove(handle) |> ignore
      body_handles.remove(entity)
    }
  }

  for pair in impulse_joint_handles.to_array() {
    let entity = pair.0
    if !entity.is_alive() || !impulse_joints().contains(entity) {
      impulse_joint_handles.remove(entity)
    }
  }

  for pair in multibody_joint_handles.to_array() {
    let entity = pair.0
    if !entity.is_alive() || !multibody_joints().contains(entity) {
      multibody_joint_handles.remove(entity)
    }
  }
}

///|
fn collect_events() -> Unit {
  let world = physics3d_world()
  for collision_event in world.event_handler.take_collision_events() {
    let collider1 = collision_event.collider1()
    let collider2 = collision_event.collider2()
    guard resolve_collider_entity(collider1) is Some(entity_a) else { continue }
    guard resolve_collider_entity(collider2) is Some(entity_b) else { continue }
    if collision_event.sensor() {
      sensor_event_bus.send({
        sensor: entity_a,
        other: entity_b,
        entered: collision_event.started(),
      })
    }
    collision_event_bus.send({
      entity_a,
      entity_b,
      started: collision_event.started(),
      stopped: collision_event.stopped(),
      sensor: collision_event.sensor(),
      normal: @math.Vec3::zero(),
    })
  }

  for intersection_event in world.event_handler.take_intersection_events() {
    guard resolve_collider_entity(intersection_event.collider1())
      is Some(sensor_entity) else {
      continue
    }
    guard resolve_collider_entity(intersection_event.collider2())
      is Some(other_entity) else {
      continue
    }
    sensor_event_bus.send({
      sensor: sensor_entity,
      other: other_entity,
      entered: intersection_event.intersecting(),
    })
  }

  for contact_force_event in world.event_handler.take_contact_force_events() {
    guard resolve_collider_entity(contact_force_event.collider1())
      is Some(entity_a) else {
      continue
    }
    guard resolve_collider_entity(contact_force_event.collider2())
      is Some(entity_b) else {
      continue
    }
    contact_force_event_bus.send({
      entity_a,
      entity_b,
      total_force: @math.vec3_from_rapier(contact_force_event.total_force()),
      total_force_magnitude: contact_force_event
      .total_force_magnitude()
      .to_double(),
      max_force_direction: @math.vec3_from_rapier(
        contact_force_event.max_force_direction(),
      ),
      max_force_magnitude: contact_force_event.max_force_magnitude().to_double(),
    })
  }
}

///|
fn fixed_joint_to_rapier(
  joint : FixedJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint3DRealBuilder::new(@dynamics.JointAxesMask3DReal::all())
  .contacts_enabled(contacts_enabled)
  .local_anchor1(joint.local_anchor1.to_rapier())
  .local_anchor2(joint.local_anchor2.to_rapier())
  .local_basis1(joint.local_basis1.to_rapier())
  .local_basis2(joint.local_basis2.to_rapier())
  .build()
}

///|
fn revolute_joint_to_rapier(
  joint : RevoluteJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  revolute_joint_to_generic(joint, contacts_enabled~).to_3d_real()
}

///|
fn revolute_joint_to_generic(
  joint : RevoluteJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint {
  let locked = @dynamics.JointAxesMask3DReal::lin_axes()
    .or(@dynamics.JointAxesMask3DReal::ang_y())
    .or(@dynamics.JointAxesMask3DReal::ang_z())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(locked)
    .contacts_enabled(contacts_enabled)
    .local_axis1(joint.axis.to_rapier())
    .local_axis2(joint.axis.to_rapier())
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      JointAxis::AngX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      JointAxis::AngX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      JointAxis::AngX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(
      JointAxis::AngX,
      Float::from_double(max_force),
    )
  }
  let mut generic = builder
    .build()
    .to_generic_joint()
    .set_motor_model(@dynamics.JointAxis::AngX, joint.motor_model)
  if joint.softness is Some(softness) {
    generic = generic.set_softness(softness)
  }
  generic
}

///|
fn prismatic_joint_to_rapier(
  joint : PrismaticJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let locked = @dynamics.JointAxesMask3DReal::lin_y()
    .or(@dynamics.JointAxesMask3DReal::lin_z())
    .or(@dynamics.JointAxesMask3DReal::ang_axes())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(locked)
    .contacts_enabled(contacts_enabled)
    .local_axis1(joint.axis.to_rapier())
    .local_axis2(joint.axis.to_rapier())
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      JointAxis::LinX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      JointAxis::LinX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      JointAxis::LinX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(
      JointAxis::LinX,
      Float::from_double(max_force),
    )
  }
  builder.build()
}

///|
fn spherical_joint_to_rapier(
  joint : SphericalJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(
    @dynamics.JointAxesMask3DReal::lin_axes(),
  ).contacts_enabled(contacts_enabled)
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  builder.build()
}

///|
fn rope_joint_to_rapier(
  joint : RopeJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint::from_rope(
    @dynamics.RopeJointBuilder3::new(Float::from_double(joint.max_distance))
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
    .build(),
  )
  .set_contacts_enabled(contacts_enabled)
  .to_3d_real()
}

///|
fn spring_joint_to_rapier(
  joint : SpringJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint::from_rope(
    @dynamics.RopeJointBuilder3::new(Float::from_double(joint.rest_length))
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
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
  contacts_enabled? : Bool = true,
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
      let mut builder = @dynamics.GenericJoint3DRealBuilder::new(
          @dynamics.JointAxesMask3DReal::lin_axes(),
        )
        .contacts_enabled(contacts_enabled)
        .local_anchor1(spherical_joint.local_anchor1.to_rapier())
        .local_anchor2(spherical_joint.local_anchor2.to_rapier())
      if spherical_joint.motor_target is Some((target, stiffness, damping)) {
        let axis = target.to_rapier().to_scaled_axis()
        builder = builder
          .motor_position(
            JointAxis::AngX,
            axis.x,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .motor_position(
            JointAxis::AngY,
            axis.y,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .motor_position(
            JointAxis::AngZ,
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
  @control.KinematicCharacterController3DReal::new()
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
  .with_up(controller.up.to_rapier())
}

///|
fn apply_character_controller_translation(
  entity : @entity.Entity,
  translation : @math.Vec3,
  delta : Double,
) -> Unit {
  if translation.length_squared() <= 0.000000001 {
    return
  }
  let transform = current_world_transform(entity).unwrap_or_default()
  let target = transform.translation + translation
  let target_world_transform = { ..transform, translation: target }
  set_entity_world_transform(entity, target_world_transform)
  match rigid_bodies().get(entity) {
    Some(KinematicPositionBased) =>
      match body_handles().get(entity) {
        Some(handle) =>
          match physics3d_world().bodies.get_mut(handle) {
            Some(body) =>
              body.set_next_kinematic_translation(target.to_rapier())
            None => ()
          }
        None => ()
      }
    Some(KinematicVelocityBased) =>
      if delta > 0.0 {
        let velocity = @math.Vec3::new(
          translation.x / delta,
          translation.y / delta,
          translation.z / delta,
        )
        velocities().set(entity, {
          ..velocities().get(entity).unwrap_or(Velocity::zero()),
          linvel: velocity,
        })
      }
    _ => ()
  }
}

///|
fn make_query_pipeline(
  query_filter? : QueryFilter = QueryFilter::all(),
) -> @collision.QueryPipeline3DReal {
  let world = physics3d_world()
  @collision.QueryPipeline3DReal::new(
    to_query_filter(query_filter),
    world.bodies,
    world.colliders,
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
      @collision.Shape3D::halfspace(normal.normalize().to_rapier())
    ConvexHull(points) =>
      @collision.Shape3D::ConvexHull(
        points.map(point => point.to_rapier()),
        0.0,
      )
    TriMesh(vertices, indices) =>
      @collision.Shape3D::TriMesh(
        vertices.map(point => point.to_rapier()),
        indices,
      )
    Heightfield(heights, nrows, ncols, scale) =>
      @collision.ColliderBuilder3D::heightfield(
        heights.map(Float::from_double),
        nrows,
        ncols,
        scale.to_rapier(),
      )
      .map(builder => builder.build().shape())
      .unwrap_or(@collision.Shape3D::ball(0.0))
  }
}

///|
fn to_query_shape_with_rotation(
  shape : Collider,
  rotation : @math.Quat,
) -> (@collision.Shape3D, @math.Quat) {
  match shape {
    CapsuleX(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Quat::from_axis_angle(@math.Vec3::z_axis(), -1.5707963267948966),
      )
    CapsuleZ(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Quat::from_axis_angle(@math.Vec3::x_axis(), 1.5707963267948966),
      )
    _ => (to_query_shape(shape), rotation)
  }
}

///|
fn to_query_filter(query_filter : QueryFilter) -> @collision.QueryFilter3DReal {
  let mut filter = match query_filter.body_filter {
    All => @collision.QueryFilter3DReal::new()
    Dynamic => @collision.QueryFilter3DReal::only_dynamic()
    Fixed => @collision.QueryFilter3DReal::only_fixed()
    Kinematic => @collision.QueryFilter3DReal::only_kinematic()
  }
  if query_filter.groups is Some(groups) {
    filter = filter.groups(
      @dynamics.InteractionGroups::new(
        @dynamics.Group::new(groups.memberships),
        @dynamics.Group::new(groups.filters),
        And,
      ),
    )
  }
  if query_filter.exclude_collider is Some(collider_handle) {
    filter = filter.exclude_collider(collider_handle)
  }
  if query_filter.exclude_rigid_body is Some(body_handle) {
    filter = filter.exclude_rigid_body(body_handle)
  }
  if query_filter.exclude_entity is Some(entity) {
    if collider_handles().get(entity) is Some(collider_handle) {
      filter = filter.exclude_collider(collider_handle)
    }
    if body_handles().get(entity) is Some(body_handle) {
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
  rotation : @math.Quat,
) -> @core.Aabb3 {
  let local_aabb = shape.local_aabb()
  let mins = local_aabb.mins
  let maxs = local_aabb.maxs
  let corners = [
    @math.Vec3::new(mins.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
  ]
  let world_points = corners.map(point => {
    rotation.rotate_vec3(point) + translation
  })
  let mut min_point = world_points[0]
  let mut max_point = world_points[0]
  for point in world_points {
    min_point = @math.Vec3::new(
      Double::min(min_point.x, point.x),
      Double::min(min_point.y, point.y),
      Double::min(min_point.z, point.z),
    )
    max_point = @math.Vec3::new(
      Double::max(max_point.x, point.x),
      Double::max(max_point.y, point.y),
      Double::max(max_point.z, point.z),
    )
  }
  @core.Aabb3::from_points(min_point.to_rapier(), max_point.to_rapier())
}
