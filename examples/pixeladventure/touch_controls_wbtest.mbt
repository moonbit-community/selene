///|
test "pixeladventure touch controls feed platformer actions" {
  configure_pixeladventure_input()
  @inputs.set_virtual_button_pressed(pixel_move_right_button(), true)
  @inputs.set_virtual_button_pressed(pixel_jump_button(), true)
  @input_action.input_action_system(0.0)
  inspect(
    @input_action.action_pressed(pixel_move_right_action()),
    content="true",
  )
  inspect(
    @input_action.action_pressed(pixel_move_left_action()),
    content="false",
  )
  inspect(
    @input_action.action_just_pressed(pixel_jump_action()),
    content="true",
  )
  @touch_controls.clear_controls()
  @inputs.clear_virtual_controls()
  @input_action.clear_all_action_bindings()
}
