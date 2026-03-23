///|
pub(all) enum Anchor {
  Center
  BottomLeft
  BottomCenter
  BottomRight
  CenterLeft
  CenterRight
  TopLeft
  TopCenter
  TopRight
  Custom(@math.Vec2D)
} derive(Eq, Show)

///|
pub fn default_anchor() -> Anchor {
  Center
}

///|
fn anchor_custom(anchor : Anchor) -> @math.Vec2D {
  match anchor {
    Center => @math.Vec2D(0.0, 0.0)
    BottomLeft => @math.Vec2D(-0.5, -0.5)
    BottomCenter => @math.Vec2D(0.0, -0.5)
    BottomRight => @math.Vec2D(0.5, -0.5)
    CenterLeft => @math.Vec2D(-0.5, 0.0)
    CenterRight => @math.Vec2D(0.5, 0.0)
    TopLeft => @math.Vec2D(-0.5, 0.5)
    TopCenter => @math.Vec2D(0.0, 0.5)
    TopRight => @math.Vec2D(0.5, 0.5)
    Custom(value) => value
  }
}

///|
fn anchor_translation(anchor : Anchor, size : @math.Vec2D) -> @math.Vec2D {
  let custom = anchor_custom(anchor)
  @math.Vec2D(-size[X] * (custom[X] + 0.5), -size[Y] * (0.5 - custom[Y]))
}
