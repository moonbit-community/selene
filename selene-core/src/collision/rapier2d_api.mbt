///|
fn pending_body_torques() -> @ecs.EntityTable[Double] {
  physics_world_runtime().pending_body_torques
}

///|
fn pending_body_impulses() -> @ecs.EntityTable[@math.Vec2] {
  physics_world_runtime().pending_body_impulses
}

///|
fn pending_body_impulse_points() -> @ecs.EntityTable[
  Array[(@math.Vec2, @math.Vec2)],
] {
  physics_world_runtime().pending_body_impulse_points
}

///|
fn pending_body_torque_impulses() -> @ecs.EntityTable[Double] {
  physics_world_runtime().pending_body_torque_impulses
}

///|
#derive(Eq)
priv struct EntityJointConfigKey {
  joint : Joint
  body1 : (Int32, Int32)
  body2 : (Int32, Int32)
}

///|
#derive(Eq)
priv struct EntityMultibodyJointConfigKey {
  joint : MultibodyJoint
  parent : (Int32, Int32)
  child : (Int32, Int32)
}

///|
pub fn rigid_body_handle(entity : @ecs.Entity) -> RigidBodyHandle? {
  physics_world().entity_bodies.get(entity)
}

///|
pub fn collider_handle(entity : @ecs.Entity) -> ColliderHandle? {
  physics_world().entity_colliders.get(entity)
}

///|
pub fn joint_handle(entity : @ecs.Entity) -> JointHandle? {
  physics_world().entity_joints.get(entity)
}

///|
pub fn multibody_joint_handle(entity : @ecs.Entity) -> MultibodyJointHandle? {
  physics_world().entity_multibody_joints.get(entity)
}

///|
pub fn multibody_link(entity : @ecs.Entity) -> MultibodyLinkId? {
  guard physics_world().entity_bodies.get(entity) is Some(handle) else {
    return None
  }
  physics_world().multibody_joints.rigid_body_link(handle)
}

///|
pub fn raycast(
  world~ : @ecs.World,
  origin : @math.Vec2,
  direction : @math.Vec2,
  max_toi~ : Double = 1000.0,
  solid~ : Bool = true,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> RaycastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  refresh_query_world(world~)
  let query = make_query_pipeline(query_filter)
  let normalized = direction.normalize_or_zero()
  let ray = @rapier_collision.Ray::Ray(
    to_physics_vec2(origin),
    to_physics_direction(normalized),
  )
  match
    query.cast_ray_and_get_normal(
      physics_world().bodies,
      physics_world().colliders,
      ray,
      Float::from_double(to_physics_scalar(max_toi)),
      solid,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(physics=PhysicsStep2D(world), handle).map(fn(
        entity,
      ) {
        let toi = from_physics_scalar(hit.toi().to_double())
        {
          entity,
          toi,
          point: Vec2(
            origin.x + normalized.x * toi,
            origin.y + normalized.y * toi,
          ),
          normal: from_physics_direction(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn shape_cast(
  world~ : @ecs.World,
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  direction~ : @math.Vec2 = Vec2(0.0, -1.0),
  max_toi~ : Double = 1000.0,
  stop_at_penetration~ : Bool = false,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> ShapeCastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return None
  }
  refresh_query_world(world~)
  let query = make_query_pipeline(query_filter)
  let options = @rapier_collision.ShapeCastOptions::ShapeCastOptions(
    Float::from_double(to_physics_scalar(max_toi)),
    stop_at_penetration,
  )
  match
    query.cast_shape(
      physics_world().bodies,
      physics_world().colliders,
      query_shape_isometry(origin, rotation, translation),
      to_physics_direction(direction.normalize_or_zero()),
      rapier_shape,
      options,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(physics=PhysicsStep2D(world), handle).map(fn(
        entity,
      ) {
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
  world~ : @ecs.World,
  point : @math.Vec2,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  refresh_query_world(world~)
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_point(
      physics_world().bodies,
      physics_world().colliders,
      to_physics_vec2(point),
    ),
  )
}

///|
pub fn intersect_shape(
  world~ : @ecs.World,
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return []
  }
  refresh_query_world(world~)
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_shape(
      physics_world().bodies,
      physics_world().colliders,
      query_shape_isometry(origin, rotation, translation),
      rapier_shape,
    ),
  )
}

///|
pub fn rigid_body_translation(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> @math.Vec2? {
  if physics_world().entity_bodies.get(entity) is Some(handle) &&
    physics_world().bodies.get(handle) is Some(body) {
    Some(from_physics_vec2(body.translation()))
  } else {
    entity_translation(physics=PhysicsStep2D(world), entity)
  }
}

///|
pub fn set_rigid_body_translation(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  translation : @math.Vec2,
) -> Unit {
  set_entity_translation(physics=PhysicsStep2D(world), entity, translation)
  if physics_world().entity_bodies.get(entity) is Some(handle) &&
    physics_world().bodies.get_mut(handle) is Some(body) {
    match entity_rigid_body(physics=PhysicsStep2D(world), entity).body_type {
      KinematicPositionBased => {
        body.set_translation(to_physics_vec2(translation), true) |> ignore
        body.set_next_kinematic_translation(to_physics_vec2(translation))
        |> ignore
      }
      _ => body.set_translation(to_physics_vec2(translation), true) |> ignore
    }
  }
}
