///|
test "player atlas layout keeps historical frame spacing" {
  let layout = @sprite.texture_atlas_layout(player_idle_right_animation.layout).unwrap()
  let frame_xs = layout.rects.map(rect => rect.position[X].to_int())
  inspect(frame_xs.length(), content="4")
  inspect(frame_xs[0], content="32")
  inspect(frame_xs[1], content="112")
  inspect(frame_xs[2], content="192")
  inspect(frame_xs[3], content="272")
}
