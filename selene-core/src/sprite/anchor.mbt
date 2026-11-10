///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Anchor(@math.Vec2)

///|
pub fn default_anchor() -> Anchor {
  Anchor(Vec2(0.0, 0.0))
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
  Vec2(-size.x * (custom.x + 0.5), -size.y * (0.5 - custom.y))
}
