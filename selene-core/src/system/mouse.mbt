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
/// Mouse button identifier for input handling.
///
/// Constructors:
///
/// * `Left` : The left mouse button
/// * `Right` : The right mouse button
/// * `Middle` : The middle mouse button (scroll wheel button)
///
pub(all) enum MouseButton {
  Left
  Right
  Middle
} derive(Eq, Show)

///|
pub(all) struct Mouse {
  mut pos : @math.Vec2D
  mut left_button : Bool
  mut right_button : Bool
  mut middle_button : Bool
}

///|
pub let mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
let last_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
pub let just_pressed_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
pub let just_release_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
/// Updates the mouse input state tracking for the current frame.
///
/// This system function processes mouse button state changes by comparing the
/// current mouse state with the previous frame's state to determine which
/// buttons were just pressed or just released. It updates the global mouse
/// state variables that are used by the mouse input query functions.
///
/// Parameters:
///
/// * `backend` : The backend instance (unused in this implementation).
///
/// Example:
///
/// ```notest
/// // This function is typically called automatically by the game engine
/// // as part of the input system update cycle
/// advanced_mouse_system(backend)
///
/// // After the system runs, you can query mouse states:
/// if is_mouse_just_pressed(MouseButton::Left) {
///   println("Left mouse button was just pressed!")
/// }
/// ```
///
pub fn advanced_mouse_system(_backend : &Backend) -> Unit {
  // Just pressed
  just_pressed_mouse.left_button = mouse.left_button && !last_mouse.left_button
  just_pressed_mouse.right_button = mouse.right_button &&
    !last_mouse.right_button
  just_pressed_mouse.middle_button = mouse.middle_button &&
    !last_mouse.middle_button

  // Just released
  just_release_mouse.left_button = !mouse.left_button && last_mouse.left_button
  just_release_mouse.right_button = !mouse.right_button &&
    last_mouse.right_button
  just_release_mouse.middle_button = !mouse.middle_button &&
    last_mouse.middle_button
  last_mouse.pos = mouse.pos
  last_mouse.left_button = mouse.left_button
  last_mouse.right_button = mouse.right_button
  last_mouse.middle_button = mouse.middle_button
}

///|
/// Checks if the specified mouse button is currently being pressed.
///
/// Parameters:
///
/// * `button` : The mouse button to check the state of.
///
/// Returns `true` if the specified mouse button is currently pressed, `false`
/// otherwise.
///
/// Example:
///
/// ```notest
/// if is_mouse_pressed(MouseButton::Left) {
///   println("Left mouse button is being held down")
/// }
///
/// if is_mouse_pressed(MouseButton::Right) {
///   println("Right mouse button is being held down")
/// }
/// ```
///
pub fn is_mouse_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => mouse.left_button
    MouseButton::Right => mouse.right_button
    MouseButton::Middle => mouse.middle_button
  }
}

///|
/// Checks if the specified mouse button is currently not being pressed (i.e.,
/// released).
///
/// Parameters:
///
/// * `button` : The mouse button to check the release state of.
///
/// Returns `true` if the specified mouse button is currently released (not
/// pressed), `false` if it is being pressed.
///
/// Example:
///
/// ```notest
/// if is_mouse_released(MouseButton::Left) {
///   println("Left mouse button is not being pressed")
/// }
///
/// if is_mouse_released(MouseButton::Right) {
///   println("Right mouse button is released")
/// }
/// ```
///
pub fn is_mouse_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => !mouse.left_button
    MouseButton::Right => !mouse.right_button
    MouseButton::Middle => !mouse.middle_button
  }
}

///|
/// Checks if the specified mouse button was just pressed in the current frame.
///
/// Parameters:
///
/// * `button` : The mouse button to check for just-pressed state.
///
/// Returns `true` if the specified mouse button was just pressed (transitioned
/// from released to pressed) in the current frame, `false` otherwise.
///
/// Example:
///
/// ```notest
/// if is_mouse_just_pressed(MouseButton::Left) {
///   println("Left mouse button was just clicked!")
/// }
///
/// if is_mouse_just_pressed(MouseButton::Right) {
///   println("Right mouse button was just clicked!")
/// }
/// ```
///
pub fn is_mouse_just_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_pressed_mouse.left_button
    MouseButton::Right => just_pressed_mouse.right_button
    MouseButton::Middle => just_pressed_mouse.middle_button
  }
}

///|
/// Checks if the specified mouse button was just released in the current frame.
///
/// Parameters:
///
/// * `button` : The mouse button to check for just-released state.
///
/// Returns `true` if the specified mouse button was just released (transitioned
/// from pressed to released) in the current frame, `false` otherwise.
///
/// Example:
///
/// ```notest
/// if is_mouse_just_released(MouseButton::Left) {
///   println("Left mouse button was just released!")
/// }
///
/// if is_mouse_just_released(MouseButton::Right) {
///   println("Right mouse button was just released!")
/// }
/// ```
///
pub fn is_mouse_just_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_release_mouse.left_button
    MouseButton::Right => just_release_mouse.right_button
    MouseButton::Middle => just_release_mouse.middle_button
  }
}
