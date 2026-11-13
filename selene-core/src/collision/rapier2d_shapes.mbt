///|
fn from_physics_direction(value : @rapier_full.Vec2) -> @math.Vec2 {
  Vec2(value.x.to_double(), value.y.to_double())
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
  Isometry2(to_physics_vec2(translation), to_physics_rotation(rotation))
}

///|
fn rotate_vec2(value : @math.Vec2, rotation : Double) -> @math.Vec2 {
  from_physics_direction(
    to_physics_rotation(rotation).rotate_vec2(to_physics_direction(value)),
  )
}

///|
fn quat_rotation_z(value : @math.Rotation3) -> Double {
  let rotation = value.to_quat()
  @cmath.atan2(
    2.0 * (rotation.w * rotation.z + rotation.x * rotation.y),
    1.0 - 2.0 * (rotation.y * rotation.y + rotation.z * rotation.z),
  )
}

///|
fn entity_transform(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> @transform.Transform? {
  physics.transforms.local_transform(entity)
}

///|
fn entity_translation(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> @math.Vec2? {
  entity_transform(physics~, entity).map(fn(transform) {
    Vec2(transform.translation.x, transform.translation.y)
  })
}

///|
fn set_entity_translation(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  translation : @math.Vec2,
) -> Unit {
  guard physics.transforms.local_transform(entity) is Some(current) else {
    return
  }
  physics.transforms.set_local(entity, {
    ..current,
    translation: Vec3(translation.x, translation.y, current.translation.z),
  })
}

///|
fn set_entity_rotation(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  rotation : Double,
) -> Unit {
  guard physics.transforms.local_transform(entity) is Some(current) else {
    return
  }
  physics.transforms.set_local(entity, {
    ..current,
    rotation: @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), rotation),
  })
}

///|
fn vec2_length_squared(value : @math.Vec2) -> Double {
  value.x * value.x + value.y * value.y
}

///|
fn collider_handle_key(
  handle : @rapier_collision.ColliderHandle,
) -> (Int32, Int32) {
  handle.into_raw_parts()
}

///|
fn world_entity(physics~ : PhysicsStep2D, entity : @ecs.Entity) -> Bool {
  let query_node = physics.node
  !query_node.contains(entity)
}

///|
fn entity_collision_shape(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> CollisionShape? {
  physics.collision_shape.get(entity).map(value => value.0)
}

///|
fn legacy_rigid_body(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> RigidBody {
  let query_velocity = physics.velocity
  if query_velocity.contains(entity) {
    RigidBody::kinematic_position_based()
  } else {
    RigidBody::fixed()
  }
}

///|
fn entity_rigid_body(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> RigidBody {
  physics.rigid_body
  .get(entity)
  .map(value => value.0)
  .unwrap_or_else(fn() { legacy_rigid_body(physics~, entity) })
}

///|
fn entity_collision_config(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> EntityCollisionConfig? {
  if physics.area.get(entity).map(value => value.0) is Some(area) {
    Some({
      filter: area.filter,
      sensor: true,
      active: area.active,
      friction: 0.0,
      restitution: 0.0,
    })
  } else if physics.collider.get(entity).map(value => value.0) is Some(collider) {
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
fn entity_rotation(physics~ : PhysicsStep2D, entity : @ecs.Entity) -> Double {
  if physics.runtime.pending_body_rotations.get(entity) is Some(rotation) {
    rotation
  } else if physics.runtime.world.entity_bodies.get(entity) is Some(handle) &&
    physics.runtime.world.bodies.get(handle) is Some(body) {
    from_physics_rotation(body.rotation())
  } else if entity_transform(physics~, entity) is Some(transform) {
    quat_rotation_z(transform.rotation)
  } else {
    0.0
  }
}

///|
fn entity_linear_velocity_for_body(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  body_type : RigidBodyType,
) -> @math.Vec2? {
  let query_velocity = physics.velocity
  match body_type {
    Dynamic =>
      if physics.runtime.pending_body_linear_velocities.get(entity)
        is Some(velocity) {
        Some(velocity)
      } else if physics.runtime.world.entity_bodies.get(entity) is Some(handle) &&
        physics.runtime.world.bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicVelocityBased =>
      if physics.runtime.pending_body_linear_velocities.get(entity)
        is Some(velocity) {
        Some(velocity)
      } else if query_velocity.get(entity).map(value => value.0)
        is Some(velocity) {
        Some(velocity.0)
      } else if physics.runtime.world.entity_bodies.get(entity) is Some(handle) &&
        physics.runtime.world.bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicPositionBased =>
      query_velocity
      .get(entity)
      .map(value => value.0)
      .map(fn(velocity) { velocity.0 })
    Fixed => None
  }
}
