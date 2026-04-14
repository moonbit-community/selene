///|
pub(all) struct InputSnapshot {
  pressed_keys : Set[Code]
  mouse : Mouse
  mouse_movement : MouseMovement
  mouse_wheel : MouseWheel
  connected_gamepads : Set[Gamepad]
  pressed_gamepad_buttons : Set[GamepadButtonInput]
  gamepad_axis_values : Map[GamepadAxisInput, Double]
}

///|
pub fn empty_input_snapshot() -> InputSnapshot {
  {
    pressed_keys: Set::new(),
    mouse: {
      pos: @math.Vec2::zero(),
      left_button: false,
      right_button: false,
      middle_button: false,
    },
    mouse_movement: { movement: @math.Vec2::zero() },
    mouse_wheel: { delta: @math.Vec2::zero() },
    connected_gamepads: Set::new(),
    pressed_gamepad_buttons: Set::new(),
    gamepad_axis_values: Map::new(),
  }
}

///|
pub fn apply_input_snapshot(snapshot : InputSnapshot) -> Unit {
  pressed_keys.clear()
  for key in snapshot.pressed_keys {
    pressed_keys.add(key)
  }

  mouse.pos = snapshot.mouse.pos
  mouse.left_button = snapshot.mouse.left_button
  mouse.right_button = snapshot.mouse.right_button
  mouse.middle_button = snapshot.mouse.middle_button

  mouse_movement.movement = snapshot.mouse_movement.movement
  mouse_wheel.delta = snapshot.mouse_wheel.delta

  connected_gamepads().clear()
  for gamepad in snapshot.connected_gamepads {
    connected_gamepads().add(gamepad)
  }

  pressed_gamepad_buttons().clear()
  for button in snapshot.pressed_gamepad_buttons {
    pressed_gamepad_buttons().add(button)
  }

  gamepad_axis_values().clear()
  for axis, value in snapshot.gamepad_axis_values {
    gamepad_axis_values().set(axis, value)
  }
}
