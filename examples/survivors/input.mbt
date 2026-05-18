///|
fn survivors_move_left_action() -> @input_action.InputAction {
  @input_action.InputAction("survivors.move-left")
}

///|
fn survivors_move_right_action() -> @input_action.InputAction {
  @input_action.InputAction("survivors.move-right")
}

///|
fn survivors_move_up_action() -> @input_action.InputAction {
  @input_action.InputAction("survivors.move-up")
}

///|
fn survivors_move_down_action() -> @input_action.InputAction {
  @input_action.InputAction("survivors.move-down")
}

///|
fn configure_survivors_input() -> Unit {
  @input_action.clear_all_action_bindings()
  let move_x = @inputs.VirtualAxis("survivors.move-x")
  let move_y = @inputs.VirtualAxis("survivors.move-y")
  @touch_controls.spawn_twin_stick_controls(move_x, move_y)
  @input_action.bind_action(survivors_move_left_action(), Key(KeyA))
  @input_action.bind_action(
    survivors_move_left_action(),
    VirtualAxis(move_x, dead_zone=0.15, positive=false),
  )
  @input_action.bind_action(survivors_move_right_action(), Key(KeyD))
  @input_action.bind_action(
    survivors_move_right_action(),
    VirtualAxis(move_x, dead_zone=0.15, positive=true),
  )
  @input_action.bind_action(survivors_move_up_action(), Key(KeyW))
  @input_action.bind_action(
    survivors_move_up_action(),
    VirtualAxis(move_y, dead_zone=0.15, positive=false),
  )
  @input_action.bind_action(survivors_move_down_action(), Key(KeyS))
  @input_action.bind_action(
    survivors_move_down_action(),
    VirtualAxis(move_y, dead_zone=0.15, positive=true),
  )
}
