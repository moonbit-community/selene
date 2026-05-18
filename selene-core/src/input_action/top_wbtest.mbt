///|
test "virtual button binding drives action edges" {
  clear_all_action_bindings()
  @inputs.clear_virtual_controls()
  let action = InputAction("jump")
  let button = @inputs.VirtualButton("jump-button")
  bind_action(action, VirtualButton(button))
  input_action_system(0.0)
  inspect(action_pressed(action), content="false")
  @inputs.set_virtual_button_pressed(button, true)
  input_action_system(0.0)
  inspect(action_pressed(action), content="true")
  inspect(action_just_pressed(action), content="true")
  @inputs.set_virtual_button_pressed(button, false)
  input_action_system(0.0)
  inspect(action_pressed(action), content="false")
  inspect(action_just_released(action), content="true")
  clear_all_action_bindings()
  @inputs.clear_virtual_controls()
}

///|
test "virtual axis binding applies dead zone and direction" {
  clear_all_action_bindings()
  @inputs.clear_virtual_controls()
  let positive_action = InputAction("move-right")
  let negative_action = InputAction("move-left")
  let axis = @inputs.VirtualAxis("move-x")
  bind_action(positive_action, VirtualAxis(axis, dead_zone=0.2, positive=true))
  bind_action(negative_action, VirtualAxis(axis, dead_zone=0.2, positive=false))
  @inputs.set_virtual_axis_value(axis, 0.1)
  input_action_system(0.0)
  inspect(action_value(positive_action), content="0")
  @inputs.set_virtual_axis_value(axis, 0.75)
  input_action_system(0.0)
  inspect(action_value(positive_action), content="0.75")
  inspect(action_value(negative_action), content="0")
  @inputs.set_virtual_axis_value(axis, -0.5)
  input_action_system(0.0)
  inspect(action_value(positive_action), content="0")
  inspect(action_value(negative_action), content="0.5")
  clear_all_action_bindings()
  @inputs.clear_virtual_controls()
}

///|
test "pointer primary binding follows primary pointer state" {
  clear_all_action_bindings()
  @inputs.apply_input_snapshot(@inputs.empty_input_snapshot())
  let action = InputAction("primary")
  bind_action(action, PointerPrimary)
  @inputs.mouse.left_button = true
  input_action_system(0.0)
  inspect(action_pressed(action), content="true")
  clear_all_action_bindings()
  @inputs.apply_input_snapshot(@inputs.empty_input_snapshot())
}
