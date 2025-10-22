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
/// Mouse input state containing position and button states.
///
/// Fields:
///
/// * `pos` : Current mouse cursor position as a 2D vector.
/// * `left_button` : Whether the left mouse button is currently pressed.
/// * `right_button` : Whether the right mouse button is currently pressed.
/// * `middle_button` : Whether the middle mouse button is currently pressed.
///
/// Example:
///
/// ```moonbit
/// // Access the global mouse state
/// inspect(@inputs.mouse.pos, content="Vec2D(0, 0)")
/// inspect(@inputs.mouse.left_button, content="false")
/// ```
///
pub(all) struct Mouse {
  mut pos : @math.Vec2D
  mut left_button : Bool
  mut right_button : Bool
  mut middle_button : Bool
}

///|
/// Global mouse input state instance that tracks the current mouse position and
/// button states.
///
/// This is the primary interface for accessing mouse input in the application.
/// The mouse state is automatically updated by the input system and provides
/// real-time information about the cursor position and button press states.
///
/// Fields:
///
/// * `pos` : Current mouse cursor position as a 2D vector with coordinates
///   (0.0, 0.0) by default.
/// * `left_button` : Whether the left mouse button is currently pressed (false
///   by default).
/// * `right_button` : Whether the right mouse button is currently pressed
///   (false by default).
/// * `middle_button` : Whether the middle mouse button is currently pressed
///   (false by default).
///
/// Example:
///
/// ```moonbit
/// // Access the global mouse state
/// inspect(@inputs.mouse.pos, content="Vec2D(0, 0)")
/// inspect(@inputs.mouse.left_button, content="false")
/// ```
///
pub let mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
/// Mouse movement delta tracking container.
///
/// Fields:
///
/// * `movement` : The movement vector representing the change in mouse position
///   since the last frame.
///
/// Example:
///
/// ```moonbit
/// // Access the global mouse movement
/// inspect(@inputs.mouse_movement.movement, content="Vec2D(0, 0)")
///
/// // Update movement vector
/// @inputs.mouse_movement.movement = @math.Vec2D(10.0, -5.0)
/// ```
///
pub(all) struct MouseMovement {
  mut movement : @math.Vec2D
}

///|
/// Global mouse movement delta tracking instance that stores the change in
/// mouse position since the last frame.
///
/// This is the primary interface for accessing mouse movement information in
/// the application. The mouse movement state is automatically updated by the
/// input system and provides real-time information about how much the cursor
/// has moved between frames.
///
/// Fields:
///
/// * `movement` : The movement vector representing the change in mouse position
///   since the last frame, initialized to (0.0, 0.0) by default.
///
/// Example:
///
/// ```moonbit
/// // Access the global mouse movement
/// inspect(@inputs.mouse_movement.movement, content="Vec2D(10, -5)")
///
/// // Update movement vector
/// @inputs.mouse_movement.movement = @math.Vec2D(10.0, -5.0)
/// ```
///
pub let mouse_movement : MouseMovement = { movement: @math.Vec2D(0.0, 0.0) }

///|
let last_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
/// Global mouse input state instance that tracks mouse button states for
/// just-pressed detection.
///
/// This instance maintains the state of mouse buttons that were pressed in the
/// current frame (transitioned from released to pressed). It is automatically
/// updated by the input system through the `advanced_mouse_system` function and
/// provides real-time information about button press transitions.
///
/// Fields:
///
/// * `pos` : Mouse cursor position, initialized to (0.0, 0.0) by default.
/// * `left_button` : Whether the left mouse button was just pressed in the
///   current frame (false by default).
/// * `right_button` : Whether the right mouse button was just pressed in the
///   current frame (false by default).
/// * `middle_button` : Whether the middle mouse button was just pressed in the
///   current frame (false by default).
///
/// Example:
///
/// ```moonbit
/// // Check if left mouse button was just pressed
/// if @inputs.just_pressed_mouse.left_button {
///   println("Left mouse button was just clicked!")
/// }
///
/// // Access the state directly
/// inspect(@inputs.just_pressed_mouse.left_button, content="false")
/// inspect(@inputs.just_pressed_mouse.right_button, content="false")
/// ```
///
pub let just_pressed_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
/// Global mouse input state instance that tracks mouse button states for
/// just-released detection.
///
/// This instance maintains the state of mouse buttons that were released in the
/// current frame (transitioned from pressed to released). It is automatically
/// updated by the input system through the `advanced_mouse_system` function and
/// provides real-time information about button release transitions.
///
/// Fields:
///
/// * `pos` : Mouse cursor position, initialized to (0.0, 0.0) by default.
/// * `left_button` : Whether the left mouse button was just released in the
///   current frame (false by default).
/// * `right_button` : Whether the right mouse button was just released in the
///   current frame (false by default).
/// * `middle_button` : Whether the middle mouse button was just released in the
///   current frame (false by default).
///
/// Example:
///
/// ```moonbit
/// // Check if left mouse button was just released
/// if @inputs.just_release_mouse.left_button {
///   println("Left mouse button was just released!")
/// }
///
/// // Access the state directly
/// inspect(@inputs.just_release_mouse.left_button, content="false")
/// inspect(@inputs.just_release_mouse.right_button, content="false")
/// ```
///
pub let just_release_mouse : Mouse = {
  pos: @math.Vec2D(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
/// Updates the mouse input system's state tracking for button press and release
/// detection.
///
/// Parameters:
///
/// * `delta` : The time elapsed since the last frame update (currently unused
///   but reserved for future timing-based functionality).
///
/// Example:
///
/// ```moonbit
/// inspect(@inputs.is_mouse_just_pressed(Left), content="false") 
/// inspect(@inputs.is_mouse_pressed(Right), content="false") 
/// ```
///
pub fn advanced_mouse_system(_delta : Double) -> Unit {
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
/// * `button` : The mouse button to check the press state of.
///
/// Returns `true` if the specified mouse button is currently pressed, `false`
/// if it is released.
///
/// Example:
///
/// ```moonbit
/// inspect(@inputs.is_mouse_pressed(MouseButton::Left), content="false")
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
/// ```moonbit
/// inspect(@inputs.is_mouse_released(Left), content="true")
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
/// ```moonbit
/// inspect(@inputs.is_mouse_just_pressed(MouseButton::Left), content="false")
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
/// ```moonbit
/// inspect(@inputs.is_mouse_just_released(MouseButton::Left), content="false")
/// ```
///
pub fn is_mouse_just_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_release_mouse.left_button
    MouseButton::Right => just_release_mouse.right_button
    MouseButton::Middle => just_release_mouse.middle_button
  }
}
