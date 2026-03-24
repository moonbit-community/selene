///|
test "player atlas layout keeps historical frame spacing" {
  let layout = @sprite.texture_atlas_layout(player_idle_right_animation.layout).unwrap()
  inspect(
    layout.rects.map(rect => rect.position[X].to_int()),
    content="[32, 112, 192, 272]",
  )
}
