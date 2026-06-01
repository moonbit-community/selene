///|
fn reset_mouse_wbtest_state() -> Unit {
  mouse.pos = @math.Vec2::zero()
  mouse.left_button = false
  mouse.right_button = false
  mouse.middle_button = false
  last_mouse.pos = @math.Vec2::zero()
  last_mouse.left_button = false
  last_mouse.right_button = false
  last_mouse.middle_button = false
  mouse_movement.movement = @math.Vec2::zero()
  pending_mouse_relative_delta.val = None
  mouse_wheel.delta = @math.Vec2::zero()
}

///|
test "advanced mouse system falls back to position delta" {
  reset_mouse_wbtest_state()
  last_mouse.pos = @math.Vec2(2.0, 3.0)
  mouse.pos = @math.Vec2(5.0, 7.0)
  advanced_mouse_system(0.0)
  inspect(mouse_movement.movement[X], content="3")
  inspect(mouse_movement.movement[Y], content="4")
  reset_mouse_wbtest_state()
}

///|
test "advanced mouse system preserves platform relative movement" {
  reset_mouse_wbtest_state()
  last_mouse.pos = @math.Vec2(100.0, 200.0)
  mouse.pos = @math.Vec2(100.0, 200.0)
  pending_mouse_relative_delta.val = Some(@math.Vec2(12.0, -5.0))
  advanced_mouse_system(0.0)
  inspect(mouse_movement.movement[X], content="12")
  inspect(mouse_movement.movement[Y], content="-5")
  reset_mouse_wbtest_state()
}
