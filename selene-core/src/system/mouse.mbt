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
pub(all) enum MouseButton {
  Left
  Right
  Middle
} derive(Eq, Show)

///|
pub(all) struct Mouse {
  pos : @math.Vec2D
  mut left_button : Bool
  mut right_button : Bool
  mut middle_button : Bool
}

///|
pub let mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
let last_mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
pub let just_pressed_mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
pub let just_release_mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button: false,
  right_button: false,
  middle_button: false,
}

///|
pub fn advanced_mouse_system(_backend : &Backend) -> Unit {
  // Just pressed
  just_pressed_mouse.left_button = mouse.left_button && !last_mouse.left_button
  just_pressed_mouse.right_button = mouse.right_button && !last_mouse.right_button
  just_pressed_mouse.middle_button = mouse.middle_button && !last_mouse.middle_button

  // Just released
  just_release_mouse.left_button = !mouse.left_button && last_mouse.left_button
  just_release_mouse.right_button = !mouse.right_button && last_mouse.right_button
  just_release_mouse.middle_button = !mouse.middle_button && last_mouse.middle_button

  last_mouse.pos.x = mouse.pos.x
  last_mouse.pos.y = mouse.pos.y
  last_mouse.left_button = mouse.left_button
  last_mouse.right_button = mouse.right_button
  last_mouse.middle_button = mouse.middle_button
}

///|
pub fn is_mouse_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => mouse.left_button
    MouseButton::Right => mouse.right_button
    MouseButton::Middle => mouse.middle_button
  }
}

///|
pub fn is_mouse_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => !mouse.left_button
    MouseButton::Right => !mouse.right_button
    MouseButton::Middle => !mouse.middle_button
  }
}

pub fn is_mouse_just_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_pressed_mouse.left_button
    MouseButton::Right => just_pressed_mouse.right_button
    MouseButton::Middle => just_pressed_mouse.middle_button
  }
}

pub fn is_mouse_just_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_release_mouse.left_button
    MouseButton::Right => just_release_mouse.right_button
    MouseButton::Middle => just_release_mouse.middle_button
  }
}
