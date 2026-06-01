///|
fn pack_rect_fill_vertices2d(
  rect : @smath.Rect,
  transform : @smath.Transform,
  color : @render.Color,
) -> Array[Double] {
  let (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) = rect_points2d(rect, transform)
  let vertices : Array[Double] = []
  let (r, g, b, a) = color_rgba01(color)
  push_color_vertex2d(vertices, p0x, p0y, r, g, b, a)
  push_color_vertex2d(vertices, p1x, p1y, r, g, b, a)
  push_color_vertex2d(vertices, p2x, p2y, r, g, b, a)
  push_color_vertex2d(vertices, p0x, p0y, r, g, b, a)
  push_color_vertex2d(vertices, p2x, p2y, r, g, b, a)
  push_color_vertex2d(vertices, p3x, p3y, r, g, b, a)
  vertices
}

///|
fn pack_rect_stroke_vertices2d(
  rect : @smath.Rect,
  transform : @smath.Transform,
  color : @render.Color,
) -> Array[Double] {
  let (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) = rect_points2d(rect, transform)
  let vertices : Array[Double] = []
  let (r, g, b, a) = color_rgba01(color)
  push_color_vertex2d(vertices, p0x, p0y, r, g, b, a)
  push_color_vertex2d(vertices, p1x, p1y, r, g, b, a)
  push_color_vertex2d(vertices, p1x, p1y, r, g, b, a)
  push_color_vertex2d(vertices, p2x, p2y, r, g, b, a)
  push_color_vertex2d(vertices, p2x, p2y, r, g, b, a)
  push_color_vertex2d(vertices, p3x, p3y, r, g, b, a)
  push_color_vertex2d(vertices, p3x, p3y, r, g, b, a)
  push_color_vertex2d(vertices, p0x, p0y, r, g, b, a)
  vertices
}

///|
fn pack_gradient_rect_vertices2d(
  rect : @smath.Rect,
  transform : @smath.Transform,
  color_start : @render.Color,
  color_end : @render.Color,
) -> Array[Double] {
  let (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) = rect_points2d(rect, transform)
  let (r0, g0, b0, a0) = color_rgba01(color_start)
  let (r1, g1, b1, a1) = color_rgba01(color_end)
  let rm = (r0 + r1) * 0.5
  let gm = (g0 + g1) * 0.5
  let bm = (b0 + b1) * 0.5
  let am = (a0 + a1) * 0.5
  let vertices : Array[Double] = []
  push_color_vertex2d(vertices, p0x, p0y, r0, g0, b0, a0)
  push_color_vertex2d(vertices, p1x, p1y, rm, gm, bm, am)
  push_color_vertex2d(vertices, p2x, p2y, r1, g1, b1, a1)
  push_color_vertex2d(vertices, p0x, p0y, r0, g0, b0, a0)
  push_color_vertex2d(vertices, p2x, p2y, r1, g1, b1, a1)
  push_color_vertex2d(vertices, p3x, p3y, rm, gm, bm, am)
  vertices
}

///|
fn pack_circle_fill_vertices2d(
  center : @smath.Vec2,
  radius : Double,
  transform : @smath.Transform,
  color : @render.Color,
) -> Array[Double] {
  let vertices : Array[Double] = []
  let (r, g, b, a) = color_rgba01(color)
  let center_x = center[X] + transform.tx
  let center_y = center[Y] + transform.ty
  for index in 0..<40 {
    let angle0 = index.to_double() / 40.0 * @math.PI * 2.0
    let angle1 = (index + 1).to_double() / 40.0 * @math.PI * 2.0
    let (x0, y0) = transformed_local_point2d(
      center,
      transform,
      @math.cos(angle0) * radius,
      @math.sin(angle0) * radius,
    )
    let (x1, y1) = transformed_local_point2d(
      center,
      transform,
      @math.cos(angle1) * radius,
      @math.sin(angle1) * radius,
    )
    push_color_vertex2d(vertices, center_x, center_y, r, g, b, a)
    push_color_vertex2d(vertices, x0, y0, r, g, b, a)
    push_color_vertex2d(vertices, x1, y1, r, g, b, a)
  }
  vertices
}

///|
fn pack_circle_stroke_vertices2d(
  center : @smath.Vec2,
  radius : Double,
  transform : @smath.Transform,
  color : @render.Color,
) -> Array[Double] {
  let vertices : Array[Double] = []
  let (r, g, b, a) = color_rgba01(color)
  for index in 0..<40 {
    let angle0 = index.to_double() / 40.0 * @math.PI * 2.0
    let angle1 = (index + 1).to_double() / 40.0 * @math.PI * 2.0
    let (x0, y0) = transformed_local_point2d(
      center,
      transform,
      @math.cos(angle0) * radius,
      @math.sin(angle0) * radius,
    )
    let (x1, y1) = transformed_local_point2d(
      center,
      transform,
      @math.cos(angle1) * radius,
      @math.sin(angle1) * radius,
    )
    push_color_vertex2d(vertices, x0, y0, r, g, b, a)
    push_color_vertex2d(vertices, x1, y1, r, g, b, a)
  }
  vertices
}

///|
fn rect_points2d(
  rect : @smath.Rect,
  transform : @smath.Transform,
) -> (Double, Double, Double, Double, Double, Double, Double, Double) {
  let origin = rect.position
  let width = rect.size[X]
  let height = rect.size[Y]
  let (p0x, p0y) = transformed_local_point2d(origin, transform, 0.0, 0.0)
  let (p1x, p1y) = transformed_local_point2d(origin, transform, width, 0.0)
  let (p2x, p2y) = transformed_local_point2d(origin, transform, width, height)
  let (p3x, p3y) = transformed_local_point2d(origin, transform, 0.0, height)
  (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y)
}

///|
fn transformed_local_point2d(
  origin : @smath.Vec2,
  transform : @smath.Transform,
  local_x : Double,
  local_y : Double,
) -> (Double, Double) {
  (
    transform.a * local_x + transform.c * local_y + transform.tx + origin[X],
    transform.b * local_x + transform.d * local_y + transform.ty + origin[Y],
  )
}

///|
fn color_rgba01(color : @render.Color) -> (Double, Double, Double, Double) {
  (
    color.r.reinterpret_as_int().to_double() / 255.0,
    color.g.reinterpret_as_int().to_double() / 255.0,
    color.b.reinterpret_as_int().to_double() / 255.0,
    color.a,
  )
}

///|
fn push_color_vertex2d(
  vertices : Array[Double],
  x : Double,
  y : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit {
  vertices.push(x)
  vertices.push(y)
  vertices.push(r)
  vertices.push(g)
  vertices.push(b)
  vertices.push(a)
}
