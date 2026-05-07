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
pub(all) struct Gamepad {
  id : Int
} derive(Eq, Debug, Hash)

///|
pub fn Gamepad::Gamepad(id : Int) -> Gamepad {
  { id, }
}

///|
pub fn Gamepad::id(self : Gamepad) -> Int {
  self.id
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
} derive(Eq, Debug, Hash)

///|
/// Logical gamepad axis layout aligned with Bevy conventions.
pub(all) enum GamepadAxis {
  LeftStickX
  LeftStickY
  RightStickX
  RightStickY
  LeftZ
  RightZ
} derive(Eq, Debug, Hash)

///|
pub(all) enum GamepadButtonInputState {
  Pressed
  Released
} derive(Eq, Debug)

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
} derive(Eq, Debug, Hash)

///|
pub fn GamepadButtonInput::GamepadButtonInput(
  gamepad : Gamepad,
  button : GamepadButton,
) -> GamepadButtonInput {
  { gamepad, button }
}

///|
pub(all) struct GamepadAxisInput {
  gamepad : Gamepad
  axis : GamepadAxis
} derive(Eq, Debug, Hash)

///|
pub fn GamepadAxisInput::GamepadAxisInput(
  gamepad : Gamepad,
  axis : GamepadAxis,
) -> GamepadAxisInput {
  { gamepad, axis }
}

///|
priv struct GamepadWorldStore {
  connected_gamepads : Set[Gamepad]
  pressed_gamepad_buttons : Set[GamepadButtonInput]
  gamepad_axis_values : Map[GamepadAxisInput, Double]
  just_connected_gamepads : Set[Gamepad]
  just_disconnected_gamepads : Set[Gamepad]
  just_pressed_gamepad_buttons : Set[GamepadButtonInput]
  just_released_gamepad_buttons : Set[GamepadButtonInput]
  last_connected_gamepads : Set[Gamepad]
  last_pressed_gamepad_buttons : Set[GamepadButtonInput]
  last_gamepad_axis_values : Map[GamepadAxisInput, Double]
}

///|
let gamepad_world_stores : Map[UInt, GamepadWorldStore] = Map::of([])

///|
fn gamepad_world_store() -> GamepadWorldStore {
  let world_id = @ecs.require_current_world().id()
  gamepad_world_stores.get_or_init(world_id, () => {
    connected_gamepads: Set::from_iter(Iter::empty()),
    pressed_gamepad_buttons: Set::from_iter(Iter::empty()),
    gamepad_axis_values: Map::of([]),
    just_connected_gamepads: Set::from_iter(Iter::empty()),
    just_disconnected_gamepads: Set::from_iter(Iter::empty()),
    just_pressed_gamepad_buttons: Set::from_iter(Iter::empty()),
    just_released_gamepad_buttons: Set::from_iter(Iter::empty()),
    last_connected_gamepads: Set::from_iter(Iter::empty()),
    last_pressed_gamepad_buttons: Set::from_iter(Iter::empty()),
    last_gamepad_axis_values: Map::of([]),
  })
}

///|
/// Connected gamepads in the current frame.
pub fn connected_gamepads() -> Set[Gamepad] {
  gamepad_world_store().connected_gamepads
}

///|
/// Buttons currently pressed in the current frame.
pub fn pressed_gamepad_buttons() -> Set[GamepadButtonInput] {
  gamepad_world_store().pressed_gamepad_buttons
}

///|
/// Current axis values in the current frame.
pub fn gamepad_axis_values() -> Map[GamepadAxisInput, Double] {
  gamepad_world_store().gamepad_axis_values
}

///|
/// Gamepads that became connected in this frame.
pub fn just_connected_gamepads() -> Set[Gamepad] {
  gamepad_world_store().just_connected_gamepads
}

///|
/// Gamepads that became disconnected in this frame.
pub fn just_disconnected_gamepads() -> Set[Gamepad] {
  gamepad_world_store().just_disconnected_gamepads
}

///|
/// Buttons that transitioned to pressed in this frame.
pub fn just_pressed_gamepad_buttons() -> Set[GamepadButtonInput] {
  gamepad_world_store().just_pressed_gamepad_buttons
}

///|
/// Buttons that transitioned to released in this frame.
pub fn just_released_gamepad_buttons() -> Set[GamepadButtonInput] {
  gamepad_world_store().just_released_gamepad_buttons
}

///|
fn last_connected_gamepads() -> Set[Gamepad] {
  gamepad_world_store().last_connected_gamepads
}

///|
fn last_pressed_gamepad_buttons() -> Set[GamepadButtonInput] {
  gamepad_world_store().last_pressed_gamepad_buttons
}

///|
fn last_gamepad_axis_values() -> Map[GamepadAxisInput, Double] {
  gamepad_world_store().last_gamepad_axis_values
}

///|
pub let gamepad_connection_event_bus : @event.Events[GamepadConnectionEvent] = @event.Events()

///|
pub let gamepad_button_event_bus : @event.Events[GamepadButtonEvent] = @event.Events()

///|
pub let gamepad_axis_event_bus : @event.Events[GamepadAxisEvent] = @event.Events()

///|
pub fn is_gamepad_connected(gamepad : Gamepad) -> Bool {
  connected_gamepads().contains(gamepad)
}

///|
pub fn is_gamepad_just_connected(gamepad : Gamepad) -> Bool {
  just_connected_gamepads().contains(gamepad)
}

///|
pub fn is_gamepad_just_disconnected(gamepad : Gamepad) -> Bool {
  just_disconnected_gamepads().contains(gamepad)
}

///|
pub fn is_gamepad_button_pressed(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  pressed_gamepad_buttons().contains(GamepadButtonInput(gamepad, button))
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
  just_pressed_gamepad_buttons().contains(GamepadButtonInput(gamepad, button))
}

///|
pub fn is_gamepad_button_just_released(
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  just_released_gamepad_buttons().contains(GamepadButtonInput(gamepad, button))
}

///|
pub fn gamepad_axis_value(gamepad : Gamepad, axis : GamepadAxis) -> Double {
  gamepad_axis_values().get(GamepadAxisInput(gamepad, axis)).unwrap_or(0.0)
}

///|
pub fn gamepad_left_stick(gamepad : Gamepad) -> @math.Vec2 {
  @math.Vec2(
    gamepad_axis_value(gamepad, LeftStickX),
    gamepad_axis_value(gamepad, LeftStickY),
  )
}

///|
pub fn gamepad_right_stick(gamepad : Gamepad) -> @math.Vec2 {
  @math.Vec2(
    gamepad_axis_value(gamepad, RightStickX),
    gamepad_axis_value(gamepad, RightStickY),
  )
}

///|
pub fn gamepad_triggers(gamepad : Gamepad) -> @math.Vec2 {
  @math.Vec2(
    gamepad_axis_value(gamepad, LeftZ),
    gamepad_axis_value(gamepad, RightZ),
  )
}

///|
pub fn advanced_gamepad_system(_delta : Double) -> Unit {
  just_connected_gamepads().clear()
  for gamepad in connected_gamepads().difference(last_connected_gamepads()) {
    just_connected_gamepads().add(gamepad)
    gamepad_connection_event_bus.send({ gamepad, connected: true })
  }

  just_disconnected_gamepads().clear()
  for gamepad in last_connected_gamepads().difference(connected_gamepads()) {
    just_disconnected_gamepads().add(gamepad)
    gamepad_connection_event_bus.send({ gamepad, connected: false })
  }

  just_pressed_gamepad_buttons().clear()
  for
    input in pressed_gamepad_buttons().difference(
      last_pressed_gamepad_buttons(),
    ) {
    just_pressed_gamepad_buttons().add(input)
    gamepad_button_event_bus.send({ input, state: Pressed })
  }

  just_released_gamepad_buttons().clear()
  for
    input in last_pressed_gamepad_buttons().difference(
      pressed_gamepad_buttons(),
    ) {
    just_released_gamepad_buttons().add(input)
    gamepad_button_event_bus.send({ input, state: Released })
  }

  let stale_axes : Array[GamepadAxisInput] = []
  for axis_input, _value in gamepad_axis_values() {
    if !connected_gamepads().contains(axis_input.gamepad) {
      stale_axes.push(axis_input)
    }
  }
  for axis_input in stale_axes {
    gamepad_axis_values().remove(axis_input)
    last_gamepad_axis_values().remove(axis_input)
  }

  for axis_input, value in gamepad_axis_values() {
    let previous = last_gamepad_axis_values().get(axis_input).unwrap_or(0.0)
    let delta = value - previous
    if delta.abs() > 0.00001 {
      gamepad_axis_event_bus.send({ input: axis_input, value, delta })
    }
    last_gamepad_axis_values().set(axis_input, value)
  }

  last_connected_gamepads().clear()
  for gamepad in connected_gamepads() {
    last_connected_gamepads().add(gamepad)
  }

  last_pressed_gamepad_buttons().clear()
  for input in pressed_gamepad_buttons() {
    last_pressed_gamepad_buttons().add(input)
  }
}
