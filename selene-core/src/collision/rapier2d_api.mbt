///|
fn pending_body_torques() -> Map[@entity.Entity, Double] {
  physics_world_runtime().pending_body_torques
}

///|
fn pending_body_impulses() -> Map[@entity.Entity, @math.Vec2] {
  physics_world_runtime().pending_body_impulses
}

///|
fn pending_body_impulse_points() -> Map[
  @entity.Entity,
  Array[(@math.Vec2, @math.Vec2)],
] {
  physics_world_runtime().pending_body_impulse_points
}

///|
fn pending_body_torque_impulses() -> Map[@entity.Entity, Double] {
  physics_world_runtime().pending_body_torque_impulses
}

///|
priv struct EntityJointConfigKey {
  joint : Joint
  body1 : (Int, Int)
  body2 : (Int, Int)
} derive(Eq)

///|
fn entity_joint_config_keys() -> Map[@entity.Entity, EntityJointConfigKey] {
  physics_world_runtime().entity_joint_config_keys
}

///|
priv struct EntityMultibodyJointConfigKey {
  joint : MultibodyJoint
  parent : (Int, Int)
  child : (Int, Int)
} derive(Eq)

///|
fn entity_multibody_joint_config_keys() -> Map[
  @entity.Entity,
  EntityMultibodyJointConfigKey,
] {
  physics_world_runtime().entity_multibody_joint_config_keys
}

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> RigidBodyHandle? {
  world().entity_bodies.get(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> ColliderHandle? {
  world().entity_colliders.get(entity)
}

///|
pub fn joint_handle(entity : @entity.Entity) -> JointHandle? {
  world().entity_joints.get(entity)
}

///|
pub fn multibody_joint_handle(entity : @entity.Entity) -> MultibodyJointHandle? {
  world().entity_multibody_joints.get(entity)
}

///|
pub fn multibody_link(entity : @entity.Entity) -> MultibodyLinkId? {
  guard world().entity_bodies.get(entity) is Some(handle) else { return None }
  world().multibody_joints.rigid_body_link(handle)
}

///|
pub fn raycast(
  origin : @math.Vec2,
  direction : @math.Vec2,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> RaycastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  let normalized = direction.normalize()
  let ray = @rapier_collision.Ray::new(
    to_physics_vec2(origin),
    to_physics_direction(normalized),
  )
  match
    query.cast_ray_and_get_normal(
      world().bodies,
      world().colliders,
      ray,
      Float::from_double(to_physics_scalar(max_toi)),
      solid,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(handle).map(fn(entity) {
        let toi = from_physics_scalar(hit.toi().to_double())
        {
          entity,
          toi,
          point: @math.Vec2(
            origin[X] + normalized[X] * toi,
            origin[Y] + normalized[Y] * toi,
          ),
          normal: from_physics_direction(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn shape_cast(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation? : Double = 0.0,
  direction? : @math.Vec2 = @math.Vec2(0.0, -1.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> ShapeCastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return None
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  let options = @rapier_collision.ShapeCastOptions::new(
    Float::from_double(to_physics_scalar(max_toi)),
    stop_at_penetration,
  )
  match
    query.cast_shape(
      world().bodies,
      world().colliders,
      query_shape_isometry(origin, rotation, translation),
      to_physics_direction(direction.normalize()),
      rapier_shape,
      options,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(handle).map(fn(entity) {
        {
          entity,
          toi: from_physics_scalar(hit.toi().to_double()),
          point: from_physics_vec2(hit.point()),
          normal: from_physics_direction(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn intersect_point(
  point : @math.Vec2,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_point(
      world().bodies,
      world().colliders,
      to_physics_vec2(point),
    ),
  )
}

///|
pub fn intersect_shape(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation? : Double = 0.0,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return []
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_shape(
      world().bodies,
      world().colliders,
      query_shape_isometry(origin, rotation, translation),
      rapier_shape,
    ),
  )
}

///|
pub fn rigid_body_translation(entity : @entity.Entity) -> @math.Vec2? {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get(handle) is Some(body) {
    Some(from_physics_vec2(body.translation()))
  } else {
    entity_translation(entity)
  }
}

///|
pub fn set_rigid_body_translation(
  entity : @entity.Entity,
  translation : @math.Vec2,
) -> Unit {
  set_entity_translation(entity, translation)
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    match entity_rigid_body(entity).body_type {
      KinematicPositionBased => {
        body.set_translation(to_physics_vec2(translation), true) |> ignore
        body.set_next_kinematic_translation(to_physics_vec2(translation))
        |> ignore
      }
      _ => body.set_translation(to_physics_vec2(translation), true) |> ignore
    }
  }
}
