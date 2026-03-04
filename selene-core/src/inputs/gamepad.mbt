// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Stable gamepad identifier.
pub(all) struct Gamepad(Int) derive(Eq, Show, Hash)

///|
pub fn Gamepad::new(id : Int) -> Gamepad {
  Gamepad(id)
}

///|
pub fn Gamepad::id(self : Gamepad) -> Int {
  self.0
}

///|
/// Logical gamepad button layout aligned with Bevy conventions.
pub(all) enum GamepadButton {
  South
  East
  North
  West
  C
  Z
  LeftTrigger
  LeftTrigger2
  RightTrigger
  RightTrigger2
  Select
  Start
  Mode
  LeftThumb
  RightThumb
  DPadUp
  DPadDown
  DPadLeft
  DPadRight
} derive(Eq, Show, Hash)

///|
/// Logical gamepad axis layout aligned with Bevy conventions.
pub(all) enum GamepadAxis {
  LeftStickX
  LeftStickY
  RightStickX
  RightStickY
  LeftZ
  RightZ
} derive(Eq, Show, Hash)

///|
pub(all) enum GamepadButtonInputState {
  Pressed
  Released
} derive(Eq, Show)

///|
pub struct GamepadConnectionEvent {
  gamepad : Gamepad
  connected : Bool
}

///|
pub struct GamepadButtonEvent {
  input : GamepadButtonInput
  state : GamepadButtonInputState
}

///|
pub struct GamepadAxisEvent {
  input : GamepadAxisInput
  value : Double
  delta : Double
}

///|
pub(all) struct GamepadButtonInput {
  gamepad : Gamepad
  button : GamepadButton
} derive(Eq, Show, Hash)

///|
pub fn GamepadButtonInput::new(
  gamepad : Gamepad,
  button : GamepadButton,
) -> GamepadButtonInput {
  { gamepad, button }
}

///|
pub(all) struct GamepadAxisInput {
  gamepad : Gamepad
  axis : GamepadAxis
} derive(Eq, Show, Hash)

///|
pub fn GamepadAxisInput::new(
  gamepad : Gamepad,
  axis : GamepadAxis,
) -> GamepadAxisInput {
  { gamepad, axis }
}

///|
/// Connected gamepads in the current frame.
pub let connected_gamepads : Set[Gamepad] = Set::new()

///|
/// Buttons currently pressed in the current frame.
pub let pressed_gamepad_buttons : Set[GamepadButtonInput] = Set::new()

///|
/// Current axis values in the current frame.
pub let gamepad_axis_values : Map[GamepadAxisInput, Double] = Map::new()

///|
/// Gamepads that became connected in this frame.
pub let just_connected_gamepads : Set[Gamepad] = Set::new()

///|
/// Gamepads that became disconnected in this frame.
pub let just_disconnected_gamepads : Set[Gamepad] = Set::new()

///|
/// Buttons that transitioned to pressed in this frame.
pub let just_pressed_gamepad_buttons : Set[GamepadButtonInput] = Set::new()

///|
/// Buttons that transitioned to released in this frame.
pub let just_released_gamepad_buttons : Set[GamepadButtonInput] = Set::new()

///|
let last_connected_gamepads : Set[Gamepad] = Set::new()

///|
let last_pressed_gamepad_buttons : Set[GamepadButtonInput] = Set::new()

///|
let last_gamepad_axis_values : Map[GamepadAxisInput, Double] = Map::new()

///|
pub let gamepad_connection_event_bus : @event.Events[GamepadConnectionEvent] = @event.Events::new()

///|
pub let gamepad_button_event_bus : @event.Events[GamepadButtonEvent] = @event.Events::new()

///|
pub let gamepad_axis_event_bus : @event.Events[GamepadAxisEvent] = @event.Events::new()

///|
fn init {
  gamepad_connection_event_bus.register()
  gamepad_button_event_bus.register()
  gamepad_axis_event_bus.register()
}

///|
pub fn is_gamepad_connected(gamepad : Gamepad) -> Bool {
  connected_gamepads.contains(gamepad)
}

///|
pub fn is_gamepad_just_connected(gamepad : Gamepad) -> Bool {
  just_connected_gamepads.contains(gamepad)
}

///|
pub fn is_gamepad_just_disconnected(gamepad : Gamepad) -> Bool {
  just_disconnected_gamepads.contains(gamepad)
}

///|
pub fn is_gamepad_button_pressed(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  pressed_gamepad_buttons.contains(GamepadButtonInput::new(gamepad, button))
}

///|
pub fn is_gamepad_button_released(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  !is_gamepad_button_pressed(gamepad, button)
}

///|
pub fn is_gamepad_button_just_pressed(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  just_pressed_gamepad_buttons.contains(
    GamepadButtonInput::new(gamepad, button),
  )
}

///|
pub fn is_gamepad_button_just_released(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  just_released_gamepad_buttons.contains(
    GamepadButtonInput::new(gamepad, button),
  )
}

///|
pub fn gamepad_axis_value(gamepad : Gamepad, axis : GamepadAxis) -> Double {
  gamepad_axis_values.get(GamepadAxisInput::new(gamepad, axis)).unwrap_or(0.0)
}

///|
pub fn gamepad_left_stick(gamepad : Gamepad) -> @math.Vec2D {
  @math.Vec2D(
    gamepad_axis_value(gamepad, LeftStickX),
    gamepad_axis_value(gamepad, LeftStickY),
  )
}

///|
pub fn gamepad_right_stick(gamepad : Gamepad) -> @math.Vec2D {
  @math.Vec2D(
    gamepad_axis_value(gamepad, RightStickX),
    gamepad_axis_value(gamepad, RightStickY),
  )
}

///|
pub fn gamepad_triggers(gamepad : Gamepad) -> @math.Vec2D {
  @math.Vec2D(
    gamepad_axis_value(gamepad, LeftZ),
    gamepad_axis_value(gamepad, RightZ),
  )
}

///|
pub fn advanced_gamepad_system(_delta : Double) -> Unit {
  just_connected_gamepads.clear()
  for gamepad in connected_gamepads.difference(last_connected_gamepads) {
    just_connected_gamepads.add(gamepad)
    gamepad_connection_event_bus.send({ gamepad, connected: true })
  }

  just_disconnected_gamepads.clear()
  for gamepad in last_connected_gamepads.difference(connected_gamepads) {
    just_disconnected_gamepads.add(gamepad)
    gamepad_connection_event_bus.send({ gamepad, connected: false })
  }

  just_pressed_gamepad_buttons.clear()
  for input in pressed_gamepad_buttons.difference(last_pressed_gamepad_buttons) {
    just_pressed_gamepad_buttons.add(input)
    gamepad_button_event_bus.send({ input, state: Pressed })
  }

  just_released_gamepad_buttons.clear()
  for input in last_pressed_gamepad_buttons.difference(pressed_gamepad_buttons) {
    just_released_gamepad_buttons.add(input)
    gamepad_button_event_bus.send({ input, state: Released })
  }

  let stale_axes : Array[GamepadAxisInput] = []
  for axis_input, _value in gamepad_axis_values {
    if !connected_gamepads.contains(axis_input.gamepad) {
      stale_axes.push(axis_input)
    }
  }
  for axis_input in stale_axes {
    gamepad_axis_values.remove(axis_input)
    last_gamepad_axis_values.remove(axis_input)
  }

  for axis_input, value in gamepad_axis_values {
    let previous = last_gamepad_axis_values.get(axis_input).unwrap_or(0.0)
    let delta = value - previous
    if delta.abs() > 0.00001 {
      gamepad_axis_event_bus.send({ input: axis_input, value, delta })
    }
    last_gamepad_axis_values.set(axis_input, value)
  }

  last_connected_gamepads.clear()
  for gamepad in connected_gamepads {
    last_connected_gamepads.add(gamepad)
  }

  last_pressed_gamepad_buttons.clear()
  for input in pressed_gamepad_buttons {
    last_pressed_gamepad_buttons.add(input)
  }
}
