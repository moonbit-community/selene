///|
pub(all) struct Anchor(@math.Vec2) derive(Eq, Debug)

///|
pub fn default_anchor() -> Anchor {
  Anchor(@math.Vec2(0.0, 0.0))
}

///|
pub fn Anchor::as_vec(self : Anchor) -> @math.Vec2 {
  match self {
    Anchor(value) => value
  }
}

///|
fn anchor_translation(anchor : Anchor, size : @math.Vec2) -> @math.Vec2 {
  let custom = anchor.as_vec()
  @math.Vec2(-size[X] * (custom[X] + 0.5), -size[Y] * (0.5 - custom[Y]))
}
