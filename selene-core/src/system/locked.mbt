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
let mouse_lock_enabled : Ref[Bool] = Ref::new(false)

///|
let mouse_locked : Ref[Bool] = Ref::new(false)

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
  mouse_locked.val = @platform_input.set_mouse_lock(mouse_locked.val)
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
  mouse_locked.val
}

///|
pub fn sync_mouse_lock_system(_delta : Double) -> Unit {
  if !mouse_lock_enabled.val {
    mouse_locked.val = @platform_input.set_mouse_lock(false)
    return
  }
  if mouse_locked.val && @inputs.is_just_pressed(@inputs.Escape) {
    mouse_locked.val = false
  } else if !mouse_locked.val &&
    @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) {
    mouse_locked.val = true
  }
  mouse_locked.val = @platform_input.set_mouse_lock(mouse_locked.val)
}
