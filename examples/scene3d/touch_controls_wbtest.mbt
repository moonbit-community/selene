///|
test "scene3d touch controller clamps movement vector" {
  let screen = @math.Vec2(960.0, 640.0)
  let center = touch_controller_center(screen)
  inspect(touch_controller_vector(center, screen).distance(), content="0")
  let forward = touch_controller_vector(
    center + @math.Vec2(0.0, -200.0),
    screen,
  )
  inspect(forward[X], content="0")
  inspect(forward[Y], content="-1")
  let strafe_right = touch_controller_vector(
    center + @math.Vec2(200.0, 0.0),
    screen,
  )
  inspect(strafe_right[X], content="1")
  inspect(strafe_right[Y], content="0")
}
