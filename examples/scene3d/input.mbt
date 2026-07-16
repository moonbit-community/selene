///|
fn scene3d_move_left_action() -> @input_action.InputAction {
  InputAction("scene3d.move-left")
}

///|
fn scene3d_move_right_action() -> @input_action.InputAction {
  InputAction("scene3d.move-right")
}

///|
fn scene3d_move_forward_action() -> @input_action.InputAction {
  InputAction("scene3d.move-forward")
}

///|
fn scene3d_move_back_action() -> @input_action.InputAction {
  InputAction("scene3d.move-back")
}

///|
fn configure_scene3d_input() -> Unit {
  @input_action.clear_all_action_bindings()
  let move_x = @inputs.VirtualAxis("scene3d.move-x")
  let move_y = @inputs.VirtualAxis("scene3d.move-y")
  @touch_controls.spawn_twin_stick_controls(move_x, move_y)
  @input_action.bind_action(scene3d_move_left_action(), Key(KeyA))
  @input_action.bind_action(
    scene3d_move_left_action(),
    VirtualAxis(move_x, dead_zone=0.15, positive=false),
  )
  @input_action.bind_action(scene3d_move_right_action(), Key(KeyD))
  @input_action.bind_action(
    scene3d_move_right_action(),
    VirtualAxis(move_x, dead_zone=0.15, positive=true),
  )
  @input_action.bind_action(scene3d_move_forward_action(), Key(KeyW))
  @input_action.bind_action(
    scene3d_move_forward_action(),
    VirtualAxis(move_y, dead_zone=0.15, positive=false),
  )
  @input_action.bind_action(scene3d_move_back_action(), Key(KeyS))
  @input_action.bind_action(
    scene3d_move_back_action(),
    VirtualAxis(move_y, dead_zone=0.15, positive=true),
  )
}
