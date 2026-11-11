///|
fn rgba(r : UInt32, g : UInt32, b : UInt32, a : Double) -> @render.Color {
  { r, g, b, a, }
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
  let length = value.length()
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
    BottomLeft => Vec2(margin + radius, screen.y - margin - radius)
    BottomRight => Vec2(screen.x - margin - radius, screen.y - margin - radius)
    TopLeft => Vec2(margin + radius, margin + radius)
    TopRight => Vec2(screen.x - margin - radius, margin + radius)
    Anchor(x, y, offset) => Vec2(screen.x * x, screen.y * y) + offset
  }
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
  radius >= 0.0 && point.distance_squared(center) <= radius * radius
}
