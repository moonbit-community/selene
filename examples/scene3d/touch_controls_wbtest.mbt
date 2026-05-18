///|
test "scene3d touch controls feed movement actions" {
  configure_scene3d_input()
  @inputs.set_virtual_axis_value(@inputs.VirtualAxis("scene3d.move-x"), 1.0)
  @inputs.set_virtual_axis_value(@inputs.VirtualAxis("scene3d.move-y"), -0.75)
  @input_action.input_action_system(0.0)
  inspect(@input_action.action_value(scene3d_move_right_action()), content="1")
  inspect(@input_action.action_value(scene3d_move_left_action()), content="0")
  inspect(
    @input_action.action_value(scene3d_move_forward_action()),
    content="0.75",
  )
  inspect(@input_action.action_value(scene3d_move_back_action()), content="0")
  @touch_controls.clear_controls()
  @inputs.clear_virtual_controls()
  @input_action.clear_all_action_bindings()
}
