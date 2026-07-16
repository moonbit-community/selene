///|
fn pixel_move_left_action() -> @input_action.InputAction {
  InputAction("pixeladventure.move-left")
}

///|
fn pixel_move_right_action() -> @input_action.InputAction {
  InputAction("pixeladventure.move-right")
}

///|
fn pixel_jump_action() -> @input_action.InputAction {
  InputAction("pixeladventure.jump")
}

///|
fn pixel_move_left_button() -> @inputs.VirtualButton {
  VirtualButton("pixeladventure.move-left")
}

///|
fn pixel_move_right_button() -> @inputs.VirtualButton {
  VirtualButton("pixeladventure.move-right")
}

///|
fn pixel_jump_button() -> @inputs.VirtualButton {
  VirtualButton("pixeladventure.jump")
}

///|
fn configure_pixeladventure_input() -> Unit {
  @input_action.clear_all_action_bindings()
  @touch_controls.spawn_mobile_platformer_controls(
    pixel_move_left_button(),
    pixel_move_right_button(),
    pixel_jump_button(),
    left_label="L",
    right_label="R",
    jump_label="JUMP",
  )
  @input_action.bind_action(pixel_move_left_action(), Key(ArrowLeft))
  @input_action.bind_action(
    pixel_move_left_action(),
    VirtualButton(pixel_move_left_button()),
  )
  @input_action.bind_action(pixel_move_right_action(), Key(ArrowRight))
  @input_action.bind_action(
    pixel_move_right_action(),
    VirtualButton(pixel_move_right_button()),
  )
  @input_action.bind_action(pixel_jump_action(), Key(ArrowUp))
  @input_action.bind_action(
    pixel_jump_action(),
    VirtualButton(pixel_jump_button()),
  )
}
