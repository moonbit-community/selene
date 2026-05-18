///|
test "pixeladventure touch controls use bottom screen zones" {
  let screen = @math.Vec2(960.0, 640.0)
  inspect(
    touch_in_bottom_controls(@math.Vec2(100.0, 100.0), screen),
    content="false",
  )
  inspect(
    touch_in_bottom_controls(@math.Vec2(100.0, 500.0), screen),
    content="true",
  )
}
