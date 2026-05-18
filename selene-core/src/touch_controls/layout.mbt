///|
fn rgba(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

///|
fn clamp(value : Double, min : Double, max : Double) -> Double {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
fn clamp_vec2_length(value : @math.Vec2, radius : Double) -> @math.Vec2 {
  let length = value.distance()
  if radius <= 0.0 || length <= radius || length <= 0.000001 {
    value
  } else {
    value.scalar_mul(radius / length)
  }
}

///|
fn resolved_placement(
  placement : TouchPlacement,
  screen : @math.Vec2,
  radius : Double,
) -> @math.Vec2 {
  let margin = @cmp.maximum(16.0, radius * 0.65)
  match placement {
    BottomLeft => @math.Vec2(margin + radius, screen[Y] - margin - radius)
    BottomRight =>
      @math.Vec2(screen[X] - margin - radius, screen[Y] - margin - radius)
    TopLeft => @math.Vec2(margin + radius, margin + radius)
    TopRight => @math.Vec2(screen[X] - margin - radius, margin + radius)
    Anchor(x, y, offset) => @math.Vec2(screen[X] * x, screen[Y] * y) + offset
  }
}

///|
fn point_distance(lhs : @math.Vec2, rhs : @math.Vec2) -> Double {
  (lhs - rhs).distance()
}

///|
fn hit_radius(radius : Double) -> Double {
  @cmp.maximum(radius, radius * 1.35)
}

///|
fn point_in_circle(
  point : @math.Vec2,
  center : @math.Vec2,
  radius : Double,
) -> Bool {
  point_distance(point, center) <= radius
}
