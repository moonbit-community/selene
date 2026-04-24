///|
fn from_physics_direction(value : @rapier_full.Vec2) -> @math.Vec2 {
  @math.Vec2(value.x.to_double(), value.y.to_double())
}

///|
fn to_physics_rotation(value : Double) -> @rapier_full.Rot2 {
  @rapier_full.Rot2::from_angle(Float::from_double(value))
}

///|
fn from_physics_rotation(value : @rapier_full.Rot2) -> Double {
  value.angle().to_double()
}

///|
fn to_physics_isometry(
  translation : @math.Vec2,
  rotation : Double,
) -> @rapier_full.Isometry2 {
  @rapier_full.Isometry2::new(
    to_physics_vec2(translation),
    to_physics_rotation(rotation),
  )
}

///|
fn rotate_vec2(value : @math.Vec2, rotation : Double) -> @math.Vec2 {
  from_physics_direction(
    to_physics_rotation(rotation).rotate_vec2(to_physics_direction(value)),
  )
}

///|
fn quat_rotation_z(rotation : @math.Quat) -> Double {
  @cmath.atan2(
    2.0 * (rotation.w * rotation.z + rotation.x * rotation.y),
    1.0 - 2.0 * (rotation.y * rotation.y + rotation.z * rotation.z),
  )
}

///|
fn entity_transform(entity : @entity.Entity) -> @transform.Transform? {
  @transform.transforms().get(entity)
}

///|
fn entity_translation(entity : @entity.Entity) -> @math.Vec2? {
  entity_transform(entity).map(fn(transform) {
    @math.Vec2(transform.translation.x, transform.translation.y)
  })
}

///|
fn set_entity_translation(
  entity : @entity.Entity,
  translation : @math.Vec2,
) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3(
      translation[X],
      translation[Y],
      current.translation.z,
    ),
  })
}

///|
fn set_entity_rotation(entity : @entity.Entity, rotation : Double) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    rotation: @math.Quat::from_axis_angle(@math.Vec3::z_axis(), rotation),
  })
}

///|
fn vec2_length_squared(value : @math.Vec2) -> Double {
  value[X] * value[X] + value[Y] * value[Y]
}

///|
fn collider_handle_id(handle : @rapier_collision.ColliderHandle) -> Int {
  let (id, _generation) = handle.into_raw_parts()
  id
}

///|
fn world_entity(entity : @entity.Entity) -> Bool {
  !@ui.nodes().contains(entity)
}

///|
fn entity_collision_shape(entity : @entity.Entity) -> CollisionShape? {
  shapes().get(entity)
}

///|
fn legacy_rigid_body(entity : @entity.Entity) -> RigidBody {
  if @velocity.velocities().contains(entity) {
    RigidBody::kinematic_position_based()
  } else {
    RigidBody::fixed()
  }
}

///|
fn entity_rigid_body(entity : @entity.Entity) -> RigidBody {
  rigid_bodies().get(entity).unwrap_or_else(fn() { legacy_rigid_body(entity) })
}

///|
fn entity_collision_config(entity : @entity.Entity) -> EntityCollisionConfig? {
  if areas().get(entity) is Some(area) {
    Some({
      filter: area.filter,
      sensor: true,
      active: area.active,
      friction: 0.0,
      restitution: 0.0,
    })
  } else if colliders().get(entity) is Some(collider) {
    Some({
      filter: collider.filter,
      sensor: false,
      active: collider.active,
      friction: collider.friction,
      restitution: collider.restitution,
    })
  } else {
    None
  }
}

///|
fn entity_rotation(entity : @entity.Entity) -> Double {
  if pending_body_rotations().get(entity) is Some(rotation) {
    rotation
  } else if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get(handle) is Some(body) {
    from_physics_rotation(body.rotation())
  } else if entity_transform(entity) is Some(transform) {
    quat_rotation_z(transform.rotation)
  } else {
    0.0
  }
}

///|
fn entity_linear_velocity_for_body(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> @math.Vec2? {
  match body_type {
    Dynamic =>
      if pending_body_linear_velocities().get(entity) is Some(velocity) {
        Some(velocity)
      } else if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicVelocityBased =>
      if pending_body_linear_velocities().get(entity) is Some(velocity) {
        Some(velocity)
      } else if @velocity.velocities().get(entity) is Some(velocity) {
        Some(velocity.0)
      } else if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicPositionBased =>
      @velocity.velocities().get(entity).map(fn(velocity) { velocity.0 })
    Fixed => None
  }
}
