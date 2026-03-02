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
/// Keyboard key code representing a specific key on the keyboard.
///
/// Example:
///
/// ```moonbit nocheck
/// let key_code = @inputs.Code::from_string("KeyA")
/// inspect(key_code, content="Some(KeyA)")
///
/// // Check if a key is currently pressed
/// if @inputs.is_pressed(KeyW) {
///   println("W key is being held down")
/// }
///
/// // Check if a key was just pressed this frame
/// if @inputs.is_just_pressed(Space) {
///   println("Space was just pressed")
/// }
/// ```
///
pub(all) enum Code {
  KeyA
  KeyB
  KeyC
  KeyD
  KeyE
  KeyF
  KeyG
  KeyH
  KeyI
  KeyJ
  KeyK
  KeyL
  KeyM
  KeyN
  KeyO
  KeyP
  KeyQ
  KeyR
  KeyS
  KeyT
  KeyU
  KeyV
  KeyW
  KeyX
  KeyY
  KeyZ
  ArrowUp
  ArrowDown
  ArrowLeft
  ArrowRight
  Space
  Enter
  Escape
} derive(Eq, Show, Hash)

///|
let all_codes : @set.Set[Code] = @set.Set::from_array([
  KeyA,
  KeyB,
  KeyC,
  KeyD,
  KeyE,
  KeyF,
  KeyG,
  KeyH,
  KeyI,
  KeyJ,
  KeyK,
  KeyL,
  KeyM,
  KeyN,
  KeyO,
  KeyP,
  KeyQ,
  KeyR,
  KeyS,
  KeyT,
  KeyU,
  KeyV,
  KeyW,
  KeyX,
  KeyY,
  KeyZ,
  ArrowUp,
  ArrowDown,
  ArrowLeft,
  ArrowRight,
  Space,
  Enter,
  Escape,
])

///|
/// Converts a string representation of a keyboard key into its corresponding
/// `Code` enum variant.
///
/// Parameters:
///
/// * `code` : The string representation of the keyboard key (e.g., "KeyA",
///   "Space", "ArrowUp").
///
/// Returns `Some(Code)` if the string matches a valid key code, or `None` if
/// the string is not recognized.
///
/// Example:
///
/// ```moonbit nocheck
/// let key_a = @inputs.Code::from_string("KeyA")
/// inspect(key_a, content="Some(KeyA)")
///
/// let space_key = @inputs.Code::from_string("Space")
/// inspect(space_key, content="Some(Space)")
///
/// let invalid_key = @inputs.Code::from_string("InvalidKey")
/// inspect(invalid_key, content="None")
/// ```
///
pub fn Code::from_string(code : String) -> Code? {
  match code {
    "KeyA" => Some(KeyA)
    "KeyB" => Some(KeyB)
    "KeyC" => Some(KeyC)
    "KeyD" => Some(KeyD)
    "KeyE" => Some(KeyE)
    "KeyF" => Some(KeyF)
    "KeyG" => Some(KeyG)
    "KeyH" => Some(KeyH)
    "KeyI" => Some(KeyI)
    "KeyJ" => Some(KeyJ)
    "KeyK" => Some(KeyK)
    "KeyL" => Some(KeyL)
    "KeyM" => Some(KeyM)
    "KeyN" => Some(KeyN)
    "KeyO" => Some(KeyO)
    "KeyP" => Some(KeyP)
    "KeyQ" => Some(KeyQ)
    "KeyR" => Some(KeyR)
    "KeyS" => Some(KeyS)
    "KeyT" => Some(KeyT)
    "KeyU" => Some(KeyU)
    "KeyV" => Some(KeyV)
    "KeyW" => Some(KeyW)
    "KeyX" => Some(KeyX)
    "KeyY" => Some(KeyY)
    "ArrowUp" => Some(ArrowUp)
    "ArrowDown" => Some(ArrowDown)
    "ArrowLeft" => Some(ArrowLeft)
    "ArrowRight" => Some(ArrowRight)
    "Space" => Some(Space)
    "Enter" => Some(Enter)
    "Escape" => Some(Escape)
    _ => None
  }
}

///|
/// A mutable set containing all keyboard keys that are currently being pressed.
///
/// This set is automatically updated by the input system to track the real-time
/// state of keyboard input. Keys are added to this set when they are pressed
/// down and removed when they are released. The set can be queried using
/// functions like `is_pressed()` and `is_released()` to check the current state
/// of specific keys.
///
/// Example:
///
/// ```moonbit nocheck
/// // Check if a specific key is currently pressed
/// if @inputs.pressed_keys.contains(@inputs.KeyW) {
///   println("W key is being held down")
/// }
///
/// // Get all currently pressed keys
/// let current_keys = @inputs.pressed_keys.to_array()
/// inspect(current_keys, content="[]")
/// ```
///
pub let pressed_keys : Set[Code] = @set.Set::new()

///|
/// Checks if a keyboard key is currently being pressed.
///
/// Parameters:
///
/// * `code` : The keyboard key code to check for press status.
///
/// Returns `true` if the specified key is currently being held down, `false`
/// otherwise.
///
/// Example:
///
/// ```moonbit nocheck
/// // Check if the W key is currently pressed
/// if @inputs.is_pressed(@inputs.KeyW) {
///   println("W key is being held down")
/// }
///
/// // Check multiple keys
/// if @inputs.is_pressed(@inputs.Space) {
///   println("Space is pressed")
/// }
///
/// if @inputs.is_pressed(@inputs.ArrowUp) {
///   println("Up arrow is pressed")
/// }
/// ```
///
pub fn is_pressed(code : Code) -> Bool {
  pressed_keys.contains(code)
}

///|
/// Checks if a keyboard key is currently not being pressed.
///
/// Parameters:
///
/// * `code` : The keyboard key code to check for release status.
///
/// Returns `true` if the specified key is currently not being held down,
/// `false` if it is being pressed.
///
/// Example:
///
/// ```moonbit nocheck
/// // Check if the W key is currently released
/// inspect(@inputs.is_released(KeyW), content="true")
/// ```
///
pub fn is_released(code : Code) -> Bool {
  !pressed_keys.contains(code)
}

///|
/// Creates a directional vector based on the current state of four directional
/// keys.
///
/// Parameters:
///
/// * `up` : The keyboard key code for upward movement.
/// * `down` : The keyboard key code for downward movement.
/// * `left` : The keyboard key code for leftward movement.
/// * `right` : The keyboard key code for rightward movement.
///
/// Returns a 2D vector representing the combined directional input, where
/// x-component ranges from -1.0 (left) to 1.0 (right) and y-component ranges
/// from -1.0 (up) to 1.0 (down).
///
/// Example:
///
/// ```moonbit nocheck
/// // Get movement vector for WASD keys
/// let movement = @inputs.key_vector(KeyW, KeyS, KeyA, KeyD)
/// inspect(movement, content="Vec2D(0, 0)")
///
/// // Get movement vector for arrow keys
/// let arrow_movement = @inputs.key_vector(ArrowUp, ArrowDown, ArrowLeft, ArrowRight)
/// inspect(arrow_movement, content="Vec2D(0, 0)")
/// ```
///
pub fn key_vector(
  up : Code,
  down : Code,
  left : Code,
  right : Code,
) -> @math.Vec2D {
  let x = if is_pressed(left) {
    -1.0
  } else if is_pressed(right) {
    1.0
  } else {
    0.0
  }
  let y = if is_pressed(up) {
    -1.0
  } else if is_pressed(down) {
    1.0
  } else {
    0.0
  }
  @math.Vec2D(x, y)
}

///|
let last_pressed_keys : Set[Code] = @set.Set::new()

///|
let just_pressed_keys : Set[Code] = @set.Set::new()

///|
let just_release_keys : Set[Code] = @set.Set::new()

///|
/// Updates the keyboard input state to track which keys were just pressed or
/// released during the current frame.
///
/// Parameters:
///
/// * `delta` : The time elapsed since the last frame update (currently unused
///   but reserved for future timing-based features).
///
/// Example:
///
/// ```moonbit nocheck
/// // This function is typically called once per frame by the game engine
/// @inputs.advanced_key_system(0.016) // 60 FPS = ~16ms per frame
///
/// // After calling advanced_key_system, you can check for just-pressed keys
/// if @inputs.is_just_pressed(@inputs.KeyW) {
///   println("W was just pressed this frame")
/// }
///
/// if @inputs.is_just_released(@inputs.Space) {
///   println("Space was just released this frame")
/// }
/// ```
///
pub fn advanced_key_system(_delta : Double) -> Unit {
  just_pressed_keys.clear()
  for code in pressed_keys.difference(last_pressed_keys) {
    just_pressed_keys.add(code)
  }
  just_release_keys.clear()
  for code in all_codes.difference(pressed_keys).union(last_pressed_keys) {
    just_release_keys.add(code)
  }
  last_pressed_keys.clear()
  for code in pressed_keys {
    last_pressed_keys.add(code)
  }
}

///|
/// Checks if a keyboard key was just pressed during the current frame.
///
/// Parameters:
///
/// * `code` : The keyboard key code to check for recent press activity.
///
/// Returns `true` if the specified key was pressed this frame (transition from
/// released to pressed state), `false` otherwise.
///
/// Example:
///
/// ```moonbit nocheck
/// // Check if the space key was just pressed this frame
/// if @inputs.is_just_pressed(Space) {
///   println("Space key was just pressed!")
/// }
///
/// // Check for WASD movement keys
/// if @inputs.is_just_pressed(KeyW) {
///   println("Started moving forward")
/// }
/// if @inputs.is_just_pressed(KeyA) {
///   println("Started moving left")
/// }
/// ```
///
pub fn is_just_pressed(code : Code) -> Bool {
  just_pressed_keys.contains(code)
}

///|
/// Checks if a keyboard key was just released during the current frame.
///
/// Parameters:
///
/// * `code` : The keyboard key code to check for recent release activity.
///
/// Returns `true` if the specified key was released this frame (transition from
/// pressed to released state), `false` otherwise.
///
/// Example:
///
/// ```moonbit nocheck
/// // Check if the space key was just released this frame
/// if @inputs.is_just_released(Space) {
///   println("Space key was just released!")
/// }
///
/// // Check for WASD movement keys
/// if @inputs.is_just_released(KeyW) {
///   println("Stopped moving forward")
/// }
/// if @inputs.is_just_released(KeyA) {
///   println("Stopped moving left")
/// }
/// ```
///
pub fn is_just_released(code : Code) -> Bool {
  just_pressed_keys.contains(code)
}
