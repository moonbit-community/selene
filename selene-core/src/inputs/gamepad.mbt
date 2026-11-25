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
#derive(Eq, Debug, Hash)
pub(all) struct Gamepad {
  id : Int32
}

///|
pub extend Gamepad with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Gamepad with Eq::{not_equal, equal}

///|
pub extend Gamepad with Hash::{hash, hash_combine}

///|
pub fn Gamepad::Gamepad(id : Int32) -> Gamepad {
  { id, }
}

///|
pub fn Gamepad::id(self : Gamepad) -> Int32 {
  self.id
}

///|
/// Logical gamepad button layout aligned with Bevy conventions.
#derive(Eq, Debug, Hash)
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
}

///|
pub extend GamepadButton with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GamepadButton with Eq::{not_equal, equal}

///|
pub extend GamepadButton with Hash::{hash, hash_combine}

///|
/// Logical gamepad axis layout aligned with Bevy conventions.
#derive(Eq, Debug, Hash)
pub(all) enum GamepadAxis {
  LeftStickX
  LeftStickY
  RightStickX
  RightStickY
  LeftZ
  RightZ
}

///|
pub extend GamepadAxis with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GamepadAxis with Eq::{not_equal, equal}

///|
pub extend GamepadAxis with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
pub(all) enum GamepadButtonInputState {
  Pressed
  Released
}

///|
pub extend GamepadButtonInputState with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GamepadButtonInputState with Eq::{not_equal, equal}

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
#derive(Eq, Debug, Hash)
pub(all) struct GamepadButtonInput {
  gamepad : Gamepad
  button : GamepadButton
}

///|
pub extend GamepadButtonInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GamepadButtonInput with Eq::{not_equal, equal}

///|
pub extend GamepadButtonInput with Hash::{hash, hash_combine}

///|
pub fn GamepadButtonInput::GamepadButtonInput(
  gamepad : Gamepad,
  button : GamepadButton,
) -> GamepadButtonInput {
  { gamepad, button, }
}

///|
#derive(Eq, Debug, Hash)
pub(all) struct GamepadAxisInput {
  gamepad : Gamepad
  axis : GamepadAxis
}

///|
pub extend GamepadAxisInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GamepadAxisInput with Eq::{not_equal, equal}

///|
pub extend GamepadAxisInput with Hash::{hash, hash_combine}

///|
pub fn GamepadAxisInput::GamepadAxisInput(
  gamepad : Gamepad,
  axis : GamepadAxis,
) -> GamepadAxisInput {
  { gamepad, axis, }
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
let gamepad_world_store_key : @ecs.ResourceKey[GamepadWorldStore] = ResourceKey()

///|
fn gamepad_world_store(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> GamepadWorldStore {
  gamepad_world_store_key.get_or_insert_with(world, _ => {
    connected_gamepads: Set([]),
    pressed_gamepad_buttons: Set([]),
    gamepad_axis_values: Map([]),
    just_connected_gamepads: Set([]),
    just_disconnected_gamepads: Set([]),
    just_pressed_gamepad_buttons: Set([]),
    just_released_gamepad_buttons: Set([]),
    last_connected_gamepads: Set([]),
    last_pressed_gamepad_buttons: Set([]),
    last_gamepad_axis_values: Map([]),
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
pub let gamepad_connection_event_bus : @event.Events[GamepadConnectionEvent] = Events()

///|
pub let gamepad_button_event_bus : @event.Events[GamepadButtonEvent] = Events()

///|
pub let gamepad_axis_event_bus : @event.Events[GamepadAxisEvent] = Events()

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
  Vec2(
    gamepad_axis_value(gamepad, LeftStickX),
    gamepad_axis_value(gamepad, LeftStickY),
  )
}

///|
pub fn gamepad_right_stick(gamepad : Gamepad) -> @math.Vec2 {
  Vec2(
    gamepad_axis_value(gamepad, RightStickX),
    gamepad_axis_value(gamepad, RightStickY),
  )
}

///|
pub fn gamepad_triggers(gamepad : Gamepad) -> @math.Vec2 {
  Vec2(gamepad_axis_value(gamepad, LeftZ), gamepad_axis_value(gamepad, RightZ))
}

///|
pub fn advanced_gamepad_system(
  input : GamepadInput,
  events : InputEvents,
) -> Unit {
  let state = input.state
  state.just_connected_gamepads.clear()
  for
    gamepad in state.connected_gamepads.difference(
      state.last_connected_gamepads,
    ) {
    state.just_connected_gamepads.add(gamepad)
    events.gamepad_connections.send({ gamepad, connected: true, })
  }

  state.just_disconnected_gamepads.clear()
  for
    gamepad in state.last_connected_gamepads.difference(
      state.connected_gamepads,
    ) {
    state.just_disconnected_gamepads.add(gamepad)
    events.gamepad_connections.send({ gamepad, connected: false, })
  }

  state.just_pressed_gamepad_buttons.clear()
  for
    input in state.pressed_gamepad_buttons.difference(
      state.last_pressed_gamepad_buttons,
    ) {
    state.just_pressed_gamepad_buttons.add(input)
    events.gamepad_buttons.send({ input, state: Pressed, })
  }

  state.just_released_gamepad_buttons.clear()
  for
    input in state.last_pressed_gamepad_buttons.difference(
      state.pressed_gamepad_buttons,
    ) {
    state.just_released_gamepad_buttons.add(input)
    events.gamepad_buttons.send({ input, state: Released, })
  }

  let stale_axes : Array[GamepadAxisInput] = []
  for axis_input, _value in state.gamepad_axis_values {
    if !state.connected_gamepads.contains(axis_input.gamepad) {
      stale_axes.push(axis_input)
    }
  }
  for axis_input in stale_axes {
    state.gamepad_axis_values.remove(axis_input)
    state.last_gamepad_axis_values.remove(axis_input)
  }

  for axis_input, value in state.gamepad_axis_values {
    let previous = state.last_gamepad_axis_values.get(axis_input).unwrap_or(0.0)
    let delta = value - previous
    if delta.abs() > 0.00001 {
      events.gamepad_axes.send({ input: axis_input, value, delta, })
    }
    state.last_gamepad_axis_values.set(axis_input, value)
  }

  state.last_connected_gamepads.clear()
  for gamepad in state.connected_gamepads {
    state.last_connected_gamepads.add(gamepad)
  }

  state.last_pressed_gamepad_buttons.clear()
  for input in state.pressed_gamepad_buttons {
    state.last_pressed_gamepad_buttons.add(input)
  }
}

///|
struct GamepadInput {
  state : GamepadWorldStore
}

///|
pub fn GamepadInput::GamepadInput(world : @ecs.World) -> GamepadInput {
  { state: gamepad_world_store(world~), }
}

///|
pub impl @ecs.SystemParam for GamepadInput with fn prepare(world) {
  let value = GamepadInput(world)
  _ => value
}

///|
pub extend GamepadInput with @ecs.SystemParam::{prepare}

///|
pub fn GamepadInput::button_pressed(
  self : GamepadInput,
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  self.state.pressed_gamepad_buttons.contains({ gamepad, button, })
}

///|
pub fn GamepadInput::button_just_pressed(
  self : GamepadInput,
  gamepad : Gamepad,
  button : GamepadButton,
) -> Bool {
  self.state.just_pressed_gamepad_buttons.contains({ gamepad, button, })
}

///|
pub fn GamepadInput::axis_value(
  self : GamepadInput,
  gamepad : Gamepad,
  axis : GamepadAxis,
) -> Double {
  self.state.gamepad_axis_values.get({ gamepad, axis, }).unwrap_or(0.0)
}
