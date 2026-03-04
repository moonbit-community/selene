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
pub fn register_gamepad_events(
  gamepads : Set[@inputs.Gamepad],
  buttons : Set[@inputs.GamepadButtonInput],
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  canvas_backend.gamepads = Some(gamepads)
  canvas_backend.gamepad_buttons = Some(buttons)
  canvas_backend.gamepad_axes = Some(axes)
  sync_gamepad_events()
}

///|
fn sync_gamepad_events() -> Unit {
  guard canvas_backend.gamepads is Some(gamepads) else { return }
  guard canvas_backend.gamepad_buttons is Some(buttons) else { return }
  guard canvas_backend.gamepad_axes is Some(axes) else { return }

  gamepads.clear()
  buttons.clear()
  axes.clear()

  let count = webgpu_gamepad_count()
  for id in 0..<count {
    if !webgpu_gamepad_connected(id) {
      continue
    }
    let gamepad = @inputs.Gamepad::new(id)
    gamepads.add(gamepad)
    sync_buttons(id, gamepad, buttons)
    sync_axes(id, gamepad, axes)
  }
}

///|
fn sync_buttons(
  id : Int,
  gamepad : @inputs.Gamepad,
  buttons : Set[@inputs.GamepadButtonInput],
) -> Unit {
  let mappings : Array[(Int, @inputs.GamepadButton)] = [
    (0, South),
    (1, East),
    (2, West),
    (3, North),
    (4, LeftTrigger),
    (5, RightTrigger),
    (6, LeftTrigger2),
    (7, RightTrigger2),
    (8, Select),
    (9, Start),
    (10, LeftThumb),
    (11, RightThumb),
    (12, DPadUp),
    (13, DPadDown),
    (14, DPadLeft),
    (15, DPadRight),
    (16, Mode),
  ]
  for mapping in mappings {
    if webgpu_gamepad_button_pressed(id, mapping.0) {
      buttons.add(@inputs.GamepadButtonInput::new(gamepad, mapping.1))
    }
  }
}

///|
fn sync_axes(
  id : Int,
  gamepad : @inputs.Gamepad,
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, LeftStickX),
    webgpu_gamepad_axis_value(id, 0),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, LeftStickY),
    webgpu_gamepad_axis_value(id, 1),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, RightStickX),
    webgpu_gamepad_axis_value(id, 2),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, RightStickY),
    webgpu_gamepad_axis_value(id, 3),
  )

  // Trigger axes prefer analog button value, fallback to axis slots when provided.
  let left_trigger = max_abs(
    webgpu_gamepad_button_value(id, 6),
    normalize_signed_axis(webgpu_gamepad_axis_value(id, 4)),
  )
  let right_trigger = max_abs(
    webgpu_gamepad_button_value(id, 7),
    normalize_signed_axis(webgpu_gamepad_axis_value(id, 5)),
  )
  axes.set(@inputs.GamepadAxisInput::new(gamepad, LeftZ), left_trigger)
  axes.set(@inputs.GamepadAxisInput::new(gamepad, RightZ), right_trigger)
}

///|
fn normalize_signed_axis(value : Double) -> Double {
  let normalized = (value + 1.0) * 0.5
  if normalized < 0.0 {
    0.0
  } else if normalized > 1.0 {
    1.0
  } else {
    normalized
  }
}

///|
fn max_abs(a : Double, b : Double) -> Double {
  if a.abs() >= b.abs() {
    a
  } else {
    b
  }
}
