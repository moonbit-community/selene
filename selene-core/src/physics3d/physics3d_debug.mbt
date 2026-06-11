///|
priv struct ColliderWireSegment3D {
  start : @math.Vec3
  end : @math.Vec3
}

///|
let collider_wire_cache : Map[String, Array[ColliderWireSegment3D]] = Map([])

///|
pub fn debug_colliders_system(_delta : Double) -> Unit {
  for entity, collider in colliders() {
    guard entity.is_alive() else { continue }
    guard @transform.global_transforms().get(entity) is Some(global) else {
      continue
    }
    let color = debug_collider_color(entity)
    for segment in collider_wire_segments(collider) {
      @render3d_pipeline.push_line3d({
        start: global.transform_point(segment.start),
        end: global.transform_point(segment.end),
        color,
      })
    }
  }
}

///|
fn debug_collider_color(entity : @entity.Entity) -> @render.Color {
  if !debug_collider_enabled(entity) {
    debug_disabled_color()
  } else if sensors().contains(entity) {
    debug_sensor_color()
  } else {
    match rigid_bodies().get(entity) {
      Some(Dynamic) => debug_dynamic_color()
      Some(Fixed) => debug_fixed_color()
      Some(KinematicPositionBased) | Some(KinematicVelocityBased) =>
        debug_kinematic_color()
      None => debug_fixed_color()
    }
  }
}

///|
fn debug_collider_enabled(entity : @entity.Entity) -> Bool {
  match collider_handle(entity) {
    Some(handle) =>
      match physics3d_world().colliders.get(handle) {
        Some(collider) => collider.enabled()
        None => true
      }
    None => true
  }
}

///|
fn debug_disabled_color() -> @render.Color {
  { r: 140U, g: 145U, b: 150U, a: 0.75 }
}

///|
fn debug_dynamic_color() -> @render.Color {
  { r: 80U, g: 220U, b: 120U, a: 0.95 }
}

///|
fn debug_fixed_color() -> @render.Color {
  { r: 90U, g: 160U, b: 255U, a: 0.95 }
}

///|
fn debug_kinematic_color() -> @render.Color {
  { r: 255U, g: 210U, b: 80U, a: 0.95 }
}

///|
fn debug_sensor_color() -> @render.Color {
  { r: 210U, g: 120U, b: 255U, a: 0.95 }
}

///|
fn collider_wire_segments(collider : Collider) -> Array[ColliderWireSegment3D] {
  let key = collider_wire_key(collider)
  collider_wire_cache.get_or_init(key, fn() {
    build_collider_wire_segments(collider)
  })
}

///|
fn build_collider_wire_segments(
  collider : Collider,
) -> Array[ColliderWireSegment3D] {
  match collider {
    Cuboid(half_extents) => build_box_wire(-half_extents, half_extents)
    Ball(radius) => {
      let segments : Array[ColliderWireSegment3D] = []
      append_circle_wire(segments, @math.Vec3::zero(), 0, radius)
      append_circle_wire(segments, @math.Vec3::zero(), 1, radius)
      append_circle_wire(segments, @math.Vec3::zero(), 2, radius)
      segments
    }
    CapsuleX(half_height, radius) => build_capsule_wire(0, half_height, radius)
    CapsuleY(half_height, radius) => build_capsule_wire(1, half_height, radius)
    CapsuleZ(half_height, radius) => build_capsule_wire(2, half_height, radius)
    Cylinder(half_height, radius) => build_cylinder_wire(1, half_height, radius)
    Cone(half_height, radius) => build_cone_wire(half_height, radius)
    RoundCylinder(half_height, radius, border_radius) =>
      build_capsule_wire(1, half_height, radius + border_radius)
    Halfspace(normal) => build_halfspace_wire(normal)
    ConvexHull(points) => build_convex_hull_wire(points)
    TriMesh(vertices, indices) => build_trimesh_wire(vertices, indices)
    Heightfield(heights, nrows, ncols, scale) =>
      build_heightfield_wire(heights, nrows, ncols, scale)
  }
}

///|
fn build_box_wire(
  min : @math.Vec3,
  max : @math.Vec3,
) -> Array[ColliderWireSegment3D] {
  let p000 = @math.Vec3(min.x, min.y, min.z)
  let p001 = @math.Vec3(min.x, min.y, max.z)
  let p010 = @math.Vec3(min.x, max.y, min.z)
  let p011 = @math.Vec3(min.x, max.y, max.z)
  let p100 = @math.Vec3(max.x, min.y, min.z)
  let p101 = @math.Vec3(max.x, min.y, max.z)
  let p110 = @math.Vec3(max.x, max.y, min.z)
  let p111 = @math.Vec3(max.x, max.y, max.z)
  [
    wire_segment(p000, p001),
    wire_segment(p001, p101),
    wire_segment(p101, p100),
    wire_segment(p100, p000),
    wire_segment(p010, p011),
    wire_segment(p011, p111),
    wire_segment(p111, p110),
    wire_segment(p110, p010),
    wire_segment(p000, p010),
    wire_segment(p001, p011),
    wire_segment(p101, p111),
    wire_segment(p100, p110),
  ]
}

///|
fn build_capsule_wire(
  axis : Int,
  half_height : Double,
  radius : Double,
) -> Array[ColliderWireSegment3D] {
  let segments : Array[ColliderWireSegment3D] = []
  let negative = axis_point(axis, -half_height)
  let positive = axis_point(axis, half_height)
  append_circle_wire(segments, negative, axis, radius)
  append_circle_wire(segments, positive, axis, radius)
  let perpendicular_a = perpendicular_axis(axis, 0)
  let perpendicular_b = perpendicular_axis(axis, 1)
  for sign_a in [-1.0, 1.0] {
    let offset = axis_point(perpendicular_a, radius * sign_a)
    segments.push(wire_segment(negative + offset, positive + offset))
    append_capsule_arc(
      segments, axis, perpendicular_a, negative, false, sign_a, radius,
    )
    append_capsule_arc(
      segments, axis, perpendicular_a, positive, true, sign_a, radius,
    )
  }
  for sign_b in [-1.0, 1.0] {
    let offset = axis_point(perpendicular_b, radius * sign_b)
    segments.push(wire_segment(negative + offset, positive + offset))
    append_capsule_arc(
      segments, axis, perpendicular_b, negative, false, sign_b, radius,
    )
    append_capsule_arc(
      segments, axis, perpendicular_b, positive, true, sign_b, radius,
    )
  }
  segments
}

///|
fn build_cylinder_wire(
  axis : Int,
  half_height : Double,
  radius : Double,
) -> Array[ColliderWireSegment3D] {
  let segments : Array[ColliderWireSegment3D] = []
  let negative = axis_point(axis, -half_height)
  let positive = axis_point(axis, half_height)
  append_circle_wire(segments, negative, axis, radius)
  append_circle_wire(segments, positive, axis, radius)
  let perpendicular_a = perpendicular_axis(axis, 0)
  let perpendicular_b = perpendicular_axis(axis, 1)
  for sign in [-1.0, 1.0] {
    let offset_a = axis_point(perpendicular_a, radius * sign)
    let offset_b = axis_point(perpendicular_b, radius * sign)
    segments.push(wire_segment(negative + offset_a, positive + offset_a))
    segments.push(wire_segment(negative + offset_b, positive + offset_b))
  }
  segments
}

///|
fn build_cone_wire(
  half_height : Double,
  radius : Double,
) -> Array[ColliderWireSegment3D] {
  let segments : Array[ColliderWireSegment3D] = []
  let base_center = @math.Vec3(0.0, -half_height, 0.0)
  let apex = @math.Vec3(0.0, half_height, 0.0)
  append_circle_wire(segments, base_center, 1, radius)
  for angle in [0.0, @cmath.PI / 2.0, @cmath.PI, @cmath.PI * 1.5] {
    let base = @math.Vec3(
      @cmath.cos(angle) * radius,
      -half_height,
      @cmath.sin(angle) * radius,
    )
    segments.push(wire_segment(base, apex))
  }
  segments
}

///|
fn build_halfspace_wire(normal : @math.Vec3) -> Array[ColliderWireSegment3D] {
  let n = if normal.length_squared() <= 0.0000001 {
    @math.Vec3::y_axis()
  } else {
    normal.normalize()
  }
  let tangent_seed = if n.y.abs() < 0.9 {
    @math.Vec3::y_axis()
  } else {
    @math.Vec3::x_axis()
  }
  let tangent = n.cross(tangent_seed).normalize()
  let bitangent = n.cross(tangent).normalize()
  let size = 5.0
  let a = tangent.scalar_mul(size) + bitangent.scalar_mul(size)
  let b = tangent.scalar_mul(size) - bitangent.scalar_mul(size)
  let c = -tangent.scalar_mul(size) - bitangent.scalar_mul(size)
  let d = -tangent.scalar_mul(size) + bitangent.scalar_mul(size)
  [
    wire_segment(a, b),
    wire_segment(b, c),
    wire_segment(c, d),
    wire_segment(d, a),
  ]
}

///|
fn build_convex_hull_wire(
  points : Array[@math.Vec3],
) -> Array[ColliderWireSegment3D] {
  guard points.length() > 0 else { return [] }
  let mut min = points[0]
  let mut max = points[0]
  for point in points {
    min = vec3_min(min, point)
    max = vec3_max(max, point)
  }
  build_box_wire(min, max)
}

///|
fn build_trimesh_wire(
  vertices : Array[@math.Vec3],
  indices : Array[(Int, Int, Int)],
) -> Array[ColliderWireSegment3D] {
  let segments : Array[ColliderWireSegment3D] = []
  for triangle in indices {
    let a = triangle.0
    let b = triangle.1
    let c = triangle.2
    if valid_vertex_index(vertices, a) &&
      valid_vertex_index(vertices, b) &&
      valid_vertex_index(vertices, c) {
      segments.push(wire_segment(vertices[a], vertices[b]))
      segments.push(wire_segment(vertices[b], vertices[c]))
      segments.push(wire_segment(vertices[c], vertices[a]))
    }
  }
  segments
}

///|
fn build_heightfield_wire(
  heights : Array[Double],
  nrows : Int,
  ncols : Int,
  scale : @math.Vec3,
) -> Array[ColliderWireSegment3D] {
  guard nrows > 0 && ncols > 0 else { return [] }
  let segments : Array[ColliderWireSegment3D] = []
  for row in 0..<nrows {
    for col in 0..<ncols {
      let point = heightfield_point(heights, nrows, ncols, scale, row, col)
      if col + 1 < ncols {
        segments.push(
          wire_segment(
            point,
            heightfield_point(heights, nrows, ncols, scale, row, col + 1),
          ),
        )
      }
      if row + 1 < nrows {
        segments.push(
          wire_segment(
            point,
            heightfield_point(heights, nrows, ncols, scale, row + 1, col),
          ),
        )
      }
    }
  }
  segments
}

///|
fn heightfield_point(
  heights : Array[Double],
  nrows : Int,
  ncols : Int,
  scale : @math.Vec3,
  row : Int,
  col : Int,
) -> @math.Vec3 {
  let x = if ncols <= 1 {
    0.0
  } else {
    (col.to_double() / (ncols - 1).to_double() - 0.5) * scale.x
  }
  let z = if nrows <= 1 {
    0.0
  } else {
    (row.to_double() / (nrows - 1).to_double() - 0.5) * scale.z
  }
  let index = row * ncols + col
  let y = if index >= 0 && index < heights.length() {
    heights[index] * scale.y
  } else {
    0.0
  }
  @math.Vec3(x, y, z)
}

///|
fn append_circle_wire(
  segments : Array[ColliderWireSegment3D],
  center : @math.Vec3,
  axis : Int,
  radius : Double,
) -> Unit {
  let steps = 32
  for index in 0..<steps {
    let a = @cmath.PI * 2.0 * index.to_double() / steps.to_double()
    let b = @cmath.PI * 2.0 * (index + 1).to_double() / steps.to_double()
    segments.push(
      wire_segment(
        center + circle_point(axis, radius, a),
        center + circle_point(axis, radius, b),
      ),
    )
  }
}

///|
fn append_capsule_arc(
  segments : Array[ColliderWireSegment3D],
  axis : Int,
  radial_axis : Int,
  center : @math.Vec3,
  positive_axis : Bool,
  radial_sign : Double,
  radius : Double,
) -> Unit {
  let steps = 8
  let axis_sign = if positive_axis { 1.0 } else { -1.0 }
  for index in 0..<steps {
    let a = index.to_double() / steps.to_double() * (@cmath.PI / 2.0)
    let b = (index + 1).to_double() / steps.to_double() * (@cmath.PI / 2.0)
    let pa = center +
      axis_point(axis, @cmath.sin(a) * radius * axis_sign) +
      axis_point(radial_axis, @cmath.cos(a) * radius * radial_sign)
    let pb = center +
      axis_point(axis, @cmath.sin(b) * radius * axis_sign) +
      axis_point(radial_axis, @cmath.cos(b) * radius * radial_sign)
    segments.push(wire_segment(pa, pb))
  }
}

///|
fn circle_point(axis : Int, radius : Double, angle : Double) -> @math.Vec3 {
  let a = perpendicular_axis(axis, 0)
  let b = perpendicular_axis(axis, 1)
  axis_point(a, @cmath.cos(angle) * radius) +
  axis_point(b, @cmath.sin(angle) * radius)
}

///|
fn perpendicular_axis(axis : Int, slot : Int) -> Int {
  match axis {
    0 => if slot == 0 { 1 } else { 2 }
    1 => if slot == 0 { 0 } else { 2 }
    _ => if slot == 0 { 0 } else { 1 }
  }
}

///|
fn axis_point(axis : Int, value : Double) -> @math.Vec3 {
  match axis {
    0 => @math.Vec3(value, 0.0, 0.0)
    1 => @math.Vec3(0.0, value, 0.0)
    _ => @math.Vec3(0.0, 0.0, value)
  }
}

///|
fn wire_segment(start : @math.Vec3, end : @math.Vec3) -> ColliderWireSegment3D {
  { start, end }
}

///|
fn valid_vertex_index(vertices : Array[@math.Vec3], index : Int) -> Bool {
  index >= 0 && index < vertices.length()
}

///|
fn vec3_min(a : @math.Vec3, b : @math.Vec3) -> @math.Vec3 {
  @math.Vec3(min_double(a.x, b.x), min_double(a.y, b.y), min_double(a.z, b.z))
}

///|
fn vec3_max(a : @math.Vec3, b : @math.Vec3) -> @math.Vec3 {
  @math.Vec3(max_double(a.x, b.x), max_double(a.y, b.y), max_double(a.z, b.z))
}

///|
fn min_double(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
fn max_double(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
fn collider_wire_key(collider : Collider) -> String {
  match collider {
    Cuboid(half_extents) => "cuboid:" + vec3_key(half_extents)
    Ball(radius) => "ball:" + radius.to_string()
    CapsuleX(half_height, radius) =>
      "capsule_x:" + half_height.to_string() + ":" + radius.to_string()
    CapsuleY(half_height, radius) =>
      "capsule_y:" + half_height.to_string() + ":" + radius.to_string()
    CapsuleZ(half_height, radius) =>
      "capsule_z:" + half_height.to_string() + ":" + radius.to_string()
    Cylinder(half_height, radius) =>
      "cylinder:" + half_height.to_string() + ":" + radius.to_string()
    Cone(half_height, radius) =>
      "cone:" + half_height.to_string() + ":" + radius.to_string()
    RoundCylinder(half_height, radius, border_radius) =>
      "round_cylinder:" +
      half_height.to_string() +
      ":" +
      radius.to_string() +
      ":" +
      border_radius.to_string()
    Halfspace(normal) => "halfspace:" + vec3_key(normal)
    ConvexHull(points) => "convex_hull:" + points_key(points)
    TriMesh(vertices, indices) =>
      "trimesh:" + points_key(vertices) + ":" + indices_key(indices)
    Heightfield(heights, nrows, ncols, scale) =>
      "heightfield:" +
      nrows.to_string() +
      ":" +
      ncols.to_string() +
      ":" +
      vec3_key(scale) +
      ":" +
      doubles_key(heights)
  }
}

///|
fn vec3_key(value : @math.Vec3) -> String {
  value.x.to_string() + "," + value.y.to_string() + "," + value.z.to_string()
}

///|
fn points_key(points : Array[@math.Vec3]) -> String {
  let mut key = points.length().to_string()
  for point in points {
    key = key + ";" + vec3_key(point)
  }
  key
}

///|
fn indices_key(indices : Array[(Int, Int, Int)]) -> String {
  let mut key = indices.length().to_string()
  for triangle in indices {
    let a = triangle.0
    let b = triangle.1
    let c = triangle.2
    key = key + ";" + a.to_string() + "," + b.to_string() + "," + c.to_string()
  }
  key
}

///|
fn doubles_key(values : Array[Double]) -> String {
  let mut key = values.length().to_string()
  for value in values {
    key = key + ";" + value.to_string()
  }
  key
}
