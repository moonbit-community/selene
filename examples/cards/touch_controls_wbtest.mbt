///|
test "cards touch action zones map bottom thirds" {
  let screen = @math.Vec2(960.0, 640.0)
  inspect(touch_action_at(Vec2(80.0, 200.0), screen) is None, content="true")
  inspect(
    touch_action_at(Vec2(80.0, 580.0), screen) is Some(TouchFold),
    content="true",
  )
  inspect(
    touch_action_at(Vec2(480.0, 580.0), screen) is Some(TouchCall),
    content="true",
  )
  inspect(
    touch_action_at(Vec2(880.0, 580.0), screen) is Some(TouchRaise),
    content="true",
  )
}
