///|
fn entity_angular_velocity_for_body(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Double? {
  match body_type {
    Dynamic | KinematicVelocityBased =>
      if pending_body_angular_velocities().get(entity) is Some(angular_velocity) {
        Some(angular_velocity)
      } else if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get(handle) is Some(body) {
        Some(body.angvel().to_double())
      } else {
        None
      }
    _ => None
  }
}

///|
fn entity_has_command_rotation(entity : @entity.Entity) -> Bool {
  pending_body_rotations().contains(entity)
}

///|
fn entity_has_command_linear_velocity(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Bool {
  match body_type {
    Dynamic => pending_body_linear_velocities().contains(entity)
    KinematicVelocityBased =>
      pending_body_linear_velocities().contains(entity) ||
      @velocity.velocities().contains(entity)
    KinematicPositionBased => @velocity.velocities().contains(entity)
    Fixed => false
  }
}

///|
fn entity_has_command_angular_velocity(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Bool {
  match body_type {
    Dynamic | KinematicVelocityBased =>
      pending_body_angular_velocities().contains(entity)
    _ => false
  }
}

///|
fn entity_physics_snapshot(entity : @entity.Entity) -> EntityPhysicsSnapshot? {
  guard entity_translation(entity) is Some(position) else { return None }
  guard entity_collision_shape(entity) is Some(shape) else { return None }
  guard entity_collision_config(entity) is Some(collision) else { return None }
  let body = entity_rigid_body(entity)
  Some({
    position,
    rotation: entity_rotation(entity),
    shape,
    collision,
    body,
    linear_velocity: entity_linear_velocity_for_body(entity, body.body_type),
    angular_velocity: entity_angular_velocity_for_body(entity, body.body_type),
  })
}

///|
fn entity_physics_config_key(
  entity : @entity.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> EntityPhysicsConfigKey {
  let translation = match snapshot.body.body_type {
    Fixed | KinematicPositionBased => Some(snapshot.position)
    _ => None
  }
  let rotation = if entity_has_command_rotation(entity) {
    Some(snapshot.rotation)
  } else {
    None
  }
  {
    translation,
    rotation,
    shape: snapshot.shape,
    collision: snapshot.collision,
    body: snapshot.body,
    linear_velocity: if entity_has_command_linear_velocity(
        entity,
        snapshot.body.body_type,
      ) {
      snapshot.linear_velocity
    } else {
      None
    },
    angular_velocity: if entity_has_command_angular_velocity(
        entity,
        snapshot.body.body_type,
      ) {
      snapshot.angular_velocity
    } else {
      None
    },
  }
}

///|
fn should_have_physics(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  entity_physics_snapshot(entity) is Some(_)
}

///|
fn group_from_index(index : Int) -> @rapier_dynamics.Group {
  match index {
    0 => @rapier_dynamics.Group::group_1()
    1 => @rapier_dynamics.Group::group_2()
    2 => @rapier_dynamics.Group::group_3()
    3 => @rapier_dynamics.Group::group_4()
    4 => @rapier_dynamics.Group::group_5()
    5 => @rapier_dynamics.Group::group_6()
    6 => @rapier_dynamics.Group::group_7()
    7 => @rapier_dynamics.Group::group_8()
    8 => @rapier_dynamics.Group::group_9()
    9 => @rapier_dynamics.Group::group_10()
    10 => @rapier_dynamics.Group::group_11()
    11 => @rapier_dynamics.Group::group_12()
    12 => @rapier_dynamics.Group::group_13()
    13 => @rapier_dynamics.Group::group_14()
    14 => @rapier_dynamics.Group::group_15()
    15 => @rapier_dynamics.Group::group_16()
    16 => @rapier_dynamics.Group::group_17()
    17 => @rapier_dynamics.Group::group_18()
    18 => @rapier_dynamics.Group::group_19()
    19 => @rapier_dynamics.Group::group_20()
    20 => @rapier_dynamics.Group::group_21()
    21 => @rapier_dynamics.Group::group_22()
    22 => @rapier_dynamics.Group::group_23()
    23 => @rapier_dynamics.Group::group_24()
    24 => @rapier_dynamics.Group::group_25()
    25 => @rapier_dynamics.Group::group_26()
    26 => @rapier_dynamics.Group::group_27()
    27 => @rapier_dynamics.Group::group_28()
    28 => @rapier_dynamics.Group::group_29()
    29 => @rapier_dynamics.Group::group_30()
    30 => @rapier_dynamics.Group::group_31()
    _ => @rapier_dynamics.Group::group_32()
  }
}

///|
fn group_from_collision(group : CollisionGroup) -> @rapier_dynamics.Group {
  group_from_index(group.value.reinterpret_as_int() % 32)
}

///|
fn groups_from_mask(mask : Array[CollisionGroup]) -> @rapier_dynamics.Group {
  let mut result = @rapier_dynamics.Group::none()
  for group in mask {
    result = result.or(group_from_collision(group))
  }
  result
}

///|
fn to_rapier_groups(
  filter : CollisionFilter,
) -> @rapier_dynamics.InteractionGroups {
  @rapier_dynamics.InteractionGroups::new(
    group_from_collision(filter.group),
    if filter.match_all {
      @rapier_dynamics.Group::all()
    } else {
      groups_from_mask(filter.mask)
    },
    // Selene collision filters are configured as "opt-in on either side":
    // if A allows B or B allows A, they should interact.
    @rapier_dynamics.InteractionTestMode::Or,
  )
}

///|
fn active_events() -> @rapier_collision.ActiveEvents {
  @rapier_collision.ActiveEvents::collision_events().union(
    @rapier_collision.ActiveEvents::intersection_events(),
  )
}

///|
fn collision_shape_to_rapier_shape(
  shape : CollisionShape,
) -> (@rapier_collision.Shape, @math.Vec2)? {
  match shape {
    Rect(size~, offset~) =>
      if size[X] <= 0.0 || size[Y] <= 0.0 {
        None
      } else {
        Some(
          (
            @rapier_collision.Shape::Cuboid(
              Float::from_double(to_physics_scalar(size[X] * 0.5)),
              Float::from_double(to_physics_scalar(size[Y] * 0.5)),
            ),
            offset + size.scalar_mul(0.5),
          ),
        )
      }
    Ball(radius~, offset~) =>
      if radius <= 0.0 {
        None
      } else {
        Some(
          (
            @rapier_collision.Shape::Ball(
              Float::from_double(to_physics_scalar(radius)),
            ),
            offset,
          ),
        )
      }
    Polygon(points~, offset~) =>
      collision_polygon_to_rapier_shape(points, offset)
    Polyline(points~, offset~, closed~) =>
      collision_polyline_to_rapier_shape(points, offset, closed)
  }
}

///|
fn collision_polygon_to_rapier_shape(
  points : Array[@math.Vec2],
  offset : @math.Vec2,
) -> (@rapier_collision.Shape, @math.Vec2)? {
  let vertices = collision_shape_vertices(points, offset, true)
  if vertices.length() < 3 {
    return None
  }
  let triangles = triangulate_collision_polygon(vertices)
  if triangles.length() == 0 {
    return None
  }
  Some(
    (
      @rapier_collision.Shape::TriMesh(
        collision_shape_to_rapier_points(vertices),
        triangles,
      ),
      @math.Vec2::zero(),
    ),
  )
}

///|
fn collision_polyline_to_rapier_shape(
  points : Array[@math.Vec2],
  offset : @math.Vec2,
  closed : Bool,
) -> (@rapier_collision.Shape, @math.Vec2)? {
  let vertices = collision_shape_vertices(points, offset, false)
  if vertices.length() < 2 {
    return None
  }
  let segments : Array[(Int, Int)] = []
  for index in 0..<(vertices.length() - 1) {
    segments.push((index, index + 1))
  }
  if closed && vertices.length() > 2 {
    segments.push((vertices.length() - 1, 0))
  }
  if segments.length() == 0 {
    return None
  }
  Some(
    (
      @rapier_collision.Shape::Polyline(
        collision_shape_to_rapier_points(vertices),
        Some(segments),
      ),
      @math.Vec2::zero(),
    ),
  )
}

///|
fn collision_shape_vertices(
  points : Array[@math.Vec2],
  offset : @math.Vec2,
  closed : Bool,
) -> Array[@math.Vec2] {
  let vertices : Array[@math.Vec2] = []
  for point in points {
    vertices.push(point + offset)
  }
  if closed &&
    vertices.length() > 1 &&
    collision_points_equal(vertices[0], vertices[vertices.length() - 1]) {
    ignore(vertices.pop())
  }
  vertices
}

///|
fn collision_shape_to_rapier_points(
  points : Array[@math.Vec2],
) -> Array[@rapier_full.Vec2] {
  points.map(point => to_physics_vec2(point))
}

///|
fn triangulate_collision_polygon(
  points : Array[@math.Vec2],
) -> Array[(Int, Int, Int)] {
  if points.length() < 3 {
    return []
  }
  let winding = if collision_polygon_signed_area(points) >= 0.0 {
    1.0
  } else {
    -1.0
  }
  let remaining : Array[Int] = []
  for index in 0..<points.length() {
    remaining.push(index)
  }
  let triangles : Array[(Int, Int, Int)] = []
  let mut guard_counter = 0
  while remaining.length() > 3 &&
        guard_counter < points.length() * points.length() {
    let mut ear_found = false
    for current_index in 0..<remaining.length() {
      let previous_index = if current_index == 0 {
        remaining.length() - 1
      } else {
        current_index - 1
      }
      let next_index = if current_index + 1 == remaining.length() {
        0
      } else {
        current_index + 1
      }
      let a_index = remaining[previous_index]
      let b_index = remaining[current_index]
      let c_index = remaining[next_index]
      if !collision_is_ear(
          points, remaining, a_index, b_index, c_index, winding,
        ) {
        continue
      }
      triangles.push((a_index, b_index, c_index))
      let next_remaining : Array[Int] = []
      for index, value in remaining {
        if index != current_index {
          next_remaining.push(value)
        }
      }
      remaining.clear()
      for value in next_remaining {
        remaining.push(value)
      }
      ear_found = true
      break
    }
    if !ear_found {
      return []
    }
    guard_counter += 1
  }
  if remaining.length() == 3 {
    triangles.push((remaining[0], remaining[1], remaining[2]))
  }
  triangles
}

///|
fn collision_is_ear(
  points : Array[@math.Vec2],
  remaining : Array[Int],
  a_index : Int,
  b_index : Int,
  c_index : Int,
  winding : Double,
) -> Bool {
  let a = points[a_index]
  let b = points[b_index]
  let c = points[c_index]
  let area = collision_triangle_area(a, b, c)
  if winding * area <= EPSILON {
    return false
  }
  for index in remaining {
    if index == a_index || index == b_index || index == c_index {
      continue
    }
    if collision_point_in_triangle(points[index], a, b, c) {
      return false
    }
  }
  true
}
