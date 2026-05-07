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
let mouse_lock_enabled : Ref[Bool] = Ref(false)

///|
let mouse_lock_requested : Ref[Bool] = Ref(false)

///|
let mouse_lock_active : Ref[Bool] = Ref(false)

///|
fn next_mouse_lock_request(
  enabled : Bool,
  requested : Bool,
  active : Bool,
  escape_pressed : Bool,
  left_mouse_pressed : Bool,
) -> Bool {
  if !enabled {
    return false
  }
  if active && escape_pressed {
    return false
  }
  if !active && left_mouse_pressed {
    return true
  }
  requested
}

///|
/// Enables mouse capture mode for the application window.
///
/// This function opts the application into mouse capture mode, which is commonly used in
/// first-person games, 3D applications, or other interactive software where
/// continuous mouse movement input is needed without the cursor hitting screen
/// boundaries. Capture does not start immediately: the cursor remains free until
/// the user clicks inside the game window, and pressing `Escape` releases the
/// capture again.
///
/// Example:
///
/// ```moonbit nocheck
/// @system.lock_mouse()
/// ```
///
pub fn lock_mouse() -> Unit {
  mouse_lock_enabled.val = true
  mouse_lock_requested.val = true
  mouse_lock_active.val = @platform_input.set_mouse_lock(
    mouse_lock_requested.val,
  )
}

///|
/// Checks whether the mouse cursor is currently locked to the application
/// window.
///
/// Returns `true` if the mouse is locked, `false` otherwise.
///
/// Example:
///
/// ```moonbit nocheck
/// inspect(@system.is_mouse_locked(), content="false")
/// ```
///
pub fn is_mouse_locked() -> Bool {
  mouse_lock_active.val
}

///|
pub fn sync_mouse_lock_system(_delta : Double) -> Unit {
  mouse_lock_requested.val = next_mouse_lock_request(
    mouse_lock_enabled.val,
    mouse_lock_requested.val,
    mouse_lock_active.val,
    @inputs.is_just_pressed(@inputs.Escape),
    @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left),
  )
  mouse_lock_active.val = @platform_input.set_mouse_lock(
    mouse_lock_requested.val,
  )
}

///|
test "mouse lock request stays pending until capture becomes active" {
  inspect(
    next_mouse_lock_request(true, true, false, false, false),
    content="true",
  )
}

///|
test "mouse lock request clears when capture mode is disabled" {
  inspect(
    next_mouse_lock_request(false, true, false, false, false),
    content="false",
  )
}

///|
test "mouse lock request clears on escape while already locked" {
  inspect(
    next_mouse_lock_request(true, true, true, true, false),
    content="false",
  )
}

///|
test "mouse lock request re-arms on click while unlocked" {
  inspect(
    next_mouse_lock_request(true, false, false, false, true),
    content="true",
  )
}
