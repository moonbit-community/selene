///|
test "survivors touch joystick clamps movement vector" {
  let screen = @math.Vec2(960.0, 640.0)
  let center = touch_joystick_center(screen)
  inspect(touch_joystick_vector(center, screen).distance(), content="0")
  let far_right = touch_joystick_vector(center + @math.Vec2(200.0, 0.0), screen)
  inspect(far_right[X], content="1")
  inspect(far_right[Y], content="0")
  let diagonal = touch_joystick_vector(center + @math.Vec2(-72.0, 72.0), screen)
  inspect(diagonal[X], content="-1")
  inspect(diagonal[Y], content="1")
}
