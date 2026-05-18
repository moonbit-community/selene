///|
test "survivors touch controls feed movement actions" {
  configure_survivors_input()
  @inputs.set_virtual_axis_value(@inputs.VirtualAxis("survivors.move-x"), 0.75)
  @inputs.set_virtual_axis_value(@inputs.VirtualAxis("survivors.move-y"), -0.5)
  @input_action.input_action_system(0.0)
  inspect(
    @input_action.action_value(survivors_move_right_action()),
    content="0.75",
  )
  inspect(@input_action.action_value(survivors_move_left_action()), content="0")
  inspect(@input_action.action_value(survivors_move_up_action()), content="0.5")
  inspect(@input_action.action_value(survivors_move_down_action()), content="0")
  @touch_controls.clear_controls()
  @inputs.clear_virtual_controls()
  @input_action.clear_all_action_bindings()
}
