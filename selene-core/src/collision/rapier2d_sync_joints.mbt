///|
fn collision_polygon_signed_area(points : Array[@math.Vec2]) -> Double {
  let mut area = 0.0
  for index in 0..<points.length() {
    let next_index = if index + 1 == points.length() { 0 } else { index + 1 }
    area += points[index][X] * points[next_index][Y] -
      points[next_index][X] * points[index][Y]
  }
  area * 0.5
}

///|
fn collision_triangle_area(
  a : @math.Vec2,
  b : @math.Vec2,
  c : @math.Vec2,
) -> Double {
  (b[X] - a[X]) * (c[Y] - a[Y]) - (b[Y] - a[Y]) * (c[X] - a[X])
}

///|
fn collision_point_in_triangle(
  point : @math.Vec2,
  a : @math.Vec2,
  b : @math.Vec2,
  c : @math.Vec2,
) -> Bool {
  let ab = collision_triangle_area(a, b, point)
  let bc = collision_triangle_area(b, c, point)
  let ca = collision_triangle_area(c, a, point)
  let has_negative = ab < -EPSILON || bc < -EPSILON || ca < -EPSILON
  let has_positive = ab > EPSILON || bc > EPSILON || ca > EPSILON
  !(has_negative && has_positive)
}

///|
fn collision_points_equal(left : @math.Vec2, right : @math.Vec2) -> Bool {
  (left[X] - right[X]).abs() <= EPSILON && (left[Y] - right[Y]).abs() <= EPSILON
}

///|
fn query_shape_isometry(
  origin : @math.Vec2,
  rotation : Double,
  translation : @math.Vec2,
) -> @rapier_full.Isometry2 {
  let rotated_translation = rotate_vec2(translation, rotation)
  to_physics_isometry(origin + rotated_translation, rotation)
}

///|
fn to_rapier_query_filter(
  query_filter : SpatialQueryFilter,
) -> @rapier_collision.QueryFilter {
  let mut filter = @rapier_collision.QueryFilter::new()
  if query_filter.groups is Some(groups) {
    filter = filter.groups(to_rapier_groups(groups))
  }
  if query_filter.exclude_sensors {
    filter = filter.exclude_sensors()
  }
  if query_filter.exclude_solids {
    filter = filter.exclude_solids()
  }
  filter = match query_filter.body_filter {
    All => filter
    Dynamic => filter.exclude_fixed().exclude_kinematic()
    Fixed => filter.exclude_dynamic().exclude_kinematic()
    Kinematic => filter.exclude_dynamic().exclude_fixed()
  }
  if query_filter.exclude_entity is Some(entity) {
    if world().entity_colliders.get(entity) is Some(handle) {
      filter = filter.exclude_collider(handle)
    } else if world().entity_bodies.get(entity) is Some(handle) {
      filter = filter.exclude_rigid_body(handle)
    }
  }
  filter
}

///|
fn make_query_pipeline(
  query_filter : SpatialQueryFilter,
) -> @rapier_collision.QueryPipeline {
  @rapier_collision.QueryPipeline::new(
    to_rapier_query_filter(query_filter),
    world().bodies,
    world().colliders,
  )
}

///|
fn intersecting_entities(
  handles : Array[@rapier_collision.ColliderHandle],
) -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  for handle in handles {
    guard entity_from_collider_handle(handle) is Some(entity) else { continue }
    if !entities.contains(entity) {
      entities.push(entity)
    }
  }
  entities
}

///|
fn refresh_query_world() -> Unit {
  sync_world_entities()
  world().bodies.propagate_modified_body_positions_to_colliders()
}

///|
fn accumulate_pending_vec2(
  pending : Map[@entity.Entity, @math.Vec2],
  entity : @entity.Entity,
  value : @math.Vec2,
) -> Unit {
  pending.set(entity, pending.get(entity).unwrap_or(@math.Vec2::zero()) + value)
}

///|
fn accumulate_pending_scalar(
  pending : Map[@entity.Entity, Double],
  entity : @entity.Entity,
  value : Double,
) -> Unit {
  pending.set(entity, pending.get(entity).unwrap_or(0.0) + value)
}

///|
fn push_pending_force_point(
  pending : Map[@entity.Entity, Array[(@math.Vec2, @math.Vec2)]],
  entity : @entity.Entity,
  value : (@math.Vec2, @math.Vec2),
) -> Unit {
  let values = pending.get(entity).unwrap_or([])
  values.push(value)
  pending.set(entity, values)
}

///|
fn apply_force_now(
  entity : @entity.Entity,
  force : @math.Vec2,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.add_force(to_physics_vec2(force), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_force_at_point_now(
  entity : @entity.Entity,
  force : @math.Vec2,
  point : @math.Vec2,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.add_force_at_point(
      to_physics_vec2(force),
      to_physics_vec2(point),
      wake_up,
    )
    |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_torque_now(
  entity : @entity.Entity,
  torque : Double,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.add_torque(Float::from_double(torque), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_impulse_now(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.apply_impulse(to_physics_vec2(impulse), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_impulse_at_point_now(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  point : @math.Vec2,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.apply_impulse_at_point(
      to_physics_vec2(impulse),
      to_physics_vec2(point),
      wake_up,
    )
    |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_torque_impulse_now(
  entity : @entity.Entity,
  impulse : Double,
  wake_up : Bool,
) -> Bool {
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.apply_torque_impulse(Float::from_double(impulse), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn has_pending_body_actions(entity : @entity.Entity) -> Bool {
  pending_body_forces().contains(entity) ||
  pending_body_force_points().contains(entity) ||
  pending_body_torques().contains(entity) ||
  pending_body_impulses().contains(entity) ||
  pending_body_impulse_points().contains(entity) ||
  pending_body_torque_impulses().contains(entity)
}
