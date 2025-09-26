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
let mouse_locked : Ref[Bool] = Ref::new(false)

///|
/// Locks the mouse cursor to prevent it from leaving the application window.
///
/// This function enables mouse lock mode, which is commonly used in
/// first-person games, 3D applications, or other interactive software where
/// continuous mouse movement input is needed without the cursor hitting screen
/// boundaries. When locked, mouse movement events continue to be generated even
/// though the cursor position remains fixed.
///
/// Example:
///
/// ```moonbit
/// @system.lock_mouse()
/// ```
///
pub fn lock_mouse() -> Unit {
  @backend.lock_mouse(mouse_locked)
}

///|
/// Checks whether the mouse cursor is currently locked to the application
/// window.
///
/// Returns `true` if the mouse is locked, `false` otherwise.
///
/// Example:
///
/// ```moonbit
/// inspect(@system.is_mouse_locked(), content="false")
/// ```
///
pub fn is_mouse_locked() -> Bool {
  mouse_locked.val
}
