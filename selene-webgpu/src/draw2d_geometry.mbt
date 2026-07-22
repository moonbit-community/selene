///|
priv struct ImageVertices2D {
  vertices : Array[Double]
  sampler_code : Int
}

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
fn pack_image_vertices2d(
  command : @render2d_types.ImageDrawCommand2D,
  image_width : Double,
  image_height : Double,
) -> ImageVertices2D {
  pack_image_vertices2d_raw(
    command.destination,
    command.transform,
    command.source,
    command.uv_transform,
    command.repeat,
    command.color,
    image_width,
    image_height,
  )
}

///|
fn pack_image_vertices2d_raw(
  destination : @smath.Rect,
  transform : @smath.Transform,
  source : @render2d_types.ImageRegion2D?,
  uv_transform : @smath.Transform,
  repeat : @smath.RepeatMode,
  color : @render.Color,
  image_width : Double,
  image_height : Double,
) -> ImageVertices2D {
  let (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) = rect_points2d(
    destination, transform,
  )
  let mut u0 = 0.0
  let mut v0 = 0.0
  let mut u1 = 1.0
  let mut v1 = 1.0
  let mut sampler_code = 0
  match source {
    Some(source) => {
      u0 = source.position[X] / image_width
      v0 = source.position[Y] / image_height
      u1 = (source.position[X] + source.size[X]) / image_width
      v1 = (source.position[Y] + source.size[Y]) / image_height
    }
    None => {
      let scale_u = destination.size[X] / image_width
      let scale_v = destination.size[Y] / image_height
      match repeat {
        Repeat => {
          u1 = scale_u
          v1 = scale_v
          sampler_code = 3
        }
        RepeatX => {
          u1 = scale_u
          sampler_code = 1
        }
        RepeatY => {
          v1 = scale_v
          sampler_code = 2
        }
        NoRepeat => ()
      }
    }
  }
  let (tu0, tv0) = transform_uv2d(uv_transform, u0, v0)
  let (tu1, tv0b) = transform_uv2d(uv_transform, u1, v0)
  let (tu1b, tv1) = transform_uv2d(uv_transform, u1, v1)
  let (tu0b, tv1b) = transform_uv2d(uv_transform, u0, v1)
  let (r, g, b, a) = color_rgba01(color)
  let vertices : Array[Double] = []
  push_tex_vertex2d(vertices, p0x, p0y, tu0, tv0, r, g, b, a)
  push_tex_vertex2d(vertices, p1x, p1y, tu1, tv0b, r, g, b, a)
  push_tex_vertex2d(vertices, p2x, p2y, tu1b, tv1, r, g, b, a)
  push_tex_vertex2d(vertices, p0x, p0y, tu0, tv0, r, g, b, a)
  push_tex_vertex2d(vertices, p2x, p2y, tu1b, tv1, r, g, b, a)
  push_tex_vertex2d(vertices, p3x, p3y, tu0b, tv1b, r, g, b, a)
  { vertices, sampler_code }
}

///|
fn pack_text_vertices2d(
  command : @render2d_types.TextDrawCommand2D,
  texture_width : Double,
  texture_height : Double,
) -> Array[Double] {
  let mut x = command.position[X]
  let mut y = command.position[Y]
  match command.style.align {
    Center => x = x - texture_width / 2.0
    Right => x = x - texture_width
    Left => ()
  }
  match command.style.baseline {
    Center => y = y - texture_height / 2.0
    Bottom => y = y - texture_height
    Top => ()
  }
  pack_text_vertices2d_raw(
    { position: Vec2(x, y), size: Vec2(texture_width, texture_height) },
    command.transform,
  )
}

///|
fn pack_text_vertices2d_raw(
  rect : @smath.Rect,
  transform : @smath.Transform,
) -> Array[Double] {
  let (p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) = rect_points2d(rect, transform)
  let vertices : Array[Double] = []
  push_tex_vertex2d(vertices, p0x, p0y, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0)
  push_tex_vertex2d(vertices, p1x, p1y, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0)
  push_tex_vertex2d(vertices, p2x, p2y, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
  push_tex_vertex2d(vertices, p0x, p0y, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0)
  push_tex_vertex2d(vertices, p2x, p2y, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
  push_tex_vertex2d(vertices, p3x, p3y, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0)
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
fn transform_uv2d(
  transform : @smath.Transform,
  u : Double,
  v : Double,
) -> (Double, Double) {
  (
    transform.a * u + transform.c * v + transform.tx,
    transform.b * u + transform.d * v + transform.ty,
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

///|
fn push_tex_vertex2d(
  vertices : Array[Double],
  x : Double,
  y : Double,
  u : Double,
  v : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit {
  vertices.push(x)
  vertices.push(y)
  vertices.push(u)
  vertices.push(v)
  vertices.push(r)
  vertices.push(g)
  vertices.push(b)
  vertices.push(a)
}
