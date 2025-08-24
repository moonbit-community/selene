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
/// ```notest
/// let key_code = @system.Code::from_string("KeyA")
/// match key_code {
///   Some(KeyA) => println("A key pressed")
///   Some(Space) => println("Space key pressed")
///   Some(ArrowUp) => println("Up arrow pressed")
///   None => println("Unknown key")
/// }
///
/// // Check if a key is currently pressed
/// if @system.is_pressed(KeyW) {
///   println("W key is being held down")
/// }
///
/// // Check if a key was just pressed this frame
/// if @system.is_just_pressed(Space) {
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
/// ```notest
/// let key_a = @system.Code::from_string("KeyA")
/// inspect(key_a, content="Some(KeyA)")
///
/// let space_key = @system.Code::from_string("Space")
/// inspect(space_key, content="Some(Space)")
///
/// let invalid_key = @system.Code::from_string("InvalidKey")
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
pub let pressed_keys : Set[Code] = @set.Set::new()

///|
pub fn is_pressed(code : Code) -> Bool {
  pressed_keys.contains(code)
}

///|
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
/// ```notest
/// // Get movement vector for WASD keys
/// let movement = @system.key_vector(@system.KeyW, @system.KeyS, @system.KeyA, @system.KeyD)
/// println("Movement: \{movement}")
///
/// // Get movement vector for arrow keys
/// let arrow_movement = @system.key_vector(@system.ArrowUp, @system.ArrowDown, @system.ArrowLeft, @system.ArrowRight)
/// println("Arrow movement: \{arrow_movement}")
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
/// Updates the internal state for tracking key press transitions between
/// frames.
///
/// Parameters:
///
/// * `backend` : The backend interface for handling platform-specific
///   operations (currently unused).
///
/// Example:
///
/// ```notest
/// // This system function is typically called automatically by the game framework
/// // during each frame update to maintain accurate key state tracking
/// @system.advanced_key_system(backend)
///
/// // After calling this system, you can use the transition detection functions:
/// if @system.is_just_pressed(@system.KeyA) {
///   // Handle key A being pressed this frame
/// }
/// if @system.is_just_released(@system.KeyB) {
///   // Handle key B being released this frame  
/// }
/// ```
///
pub fn advanced_key_system(_backend : &Backend) -> Unit {
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
/// ```notest
/// // Check if the space key was just pressed this frame
/// if @system.is_just_pressed(@system.Space) {
///   println("Space key was just pressed!")
/// }
///
/// // Check for WASD movement keys
/// if @system.is_just_pressed(@system.KeyW) {
///   println("Moving forward")
/// }
/// if @system.is_just_pressed(@system.KeyA) {
///   println("Moving left")
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
/// ```notest
/// // Check if the space key was just released this frame
/// if @system.is_just_released(@system.Space) {
///   println("Space key was just released!")
/// }
///
/// // Check for WASD movement keys
/// if @system.is_just_released(@system.KeyW) {
///   println("Stopped moving forward")
/// }
/// if @system.is_just_released(@system.KeyA) {
///   println("Stopped moving left")
/// }
/// ```
///
pub fn is_just_released(code : Code) -> Bool {
  just_pressed_keys.contains(code)
}
