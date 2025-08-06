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

pub(all) enum MouseButton {
  Left
  Right
  Middle
} derive(Eq, Show)

///|
pub(all) struct Mouse {
  pos : @math.Vec2D
  mut left_button_pressed : Bool
  mut right_button_pressed : Bool
  mut middle_button_pressed : Bool
}

///|
pub let mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button_pressed: false,
  right_button_pressed: false,
  middle_button_pressed: false,
}

///|
let last_mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button_pressed: false,
  right_button_pressed: false,
  middle_button_pressed: false,
}

///|
pub fn advanced_mouse_system(_backend : &Backend) -> Unit {
  just_mouse.pos.x = mouse.pos.x - last_mouse.pos.x
  just_mouse.pos.y = mouse.pos.y - last_mouse.pos.y
  just_mouse.left_button_pressed = mouse.left_button_pressed &&
    !last_mouse.left_button_pressed
  just_mouse.right_button_pressed = mouse.right_button_pressed &&
    !last_mouse.right_button_pressed
  just_mouse.middle_button_pressed = mouse.middle_button_pressed &&
    !last_mouse.middle_button_pressed
  last_mouse.pos.x = mouse.pos.x
  last_mouse.pos.y = mouse.pos.y
  last_mouse.left_button_pressed = mouse.left_button_pressed
  last_mouse.right_button_pressed = mouse.right_button_pressed
  last_mouse.middle_button_pressed = mouse.middle_button_pressed
}

///|
pub let just_mouse : Mouse = {
  pos: @math.Vec2D::new(0.0, 0.0),
  left_button_pressed: false,
  right_button_pressed: false,
  middle_button_pressed: false,
}

pub fn is_mouse_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => mouse.left_button_pressed
    MouseButton::Right => mouse.right_button_pressed
    MouseButton::Middle => mouse.middle_button_pressed
  }
}

pub fn is_mouse_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => !mouse.left_button_pressed
    MouseButton::Right => !mouse.right_button_pressed
    MouseButton::Middle => !mouse.middle_button_pressed
  }
}

pub fn is_mouse_just_pressed(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => just_mouse.left_button_pressed
    MouseButton::Right => just_mouse.right_button_pressed
    MouseButton::Middle => just_mouse.middle_button_pressed
  }
}

pub fn is_mouse_just_released(button : MouseButton) -> Bool {
  match button {
    MouseButton::Left => !just_mouse.left_button_pressed
    MouseButton::Right => !just_mouse.right_button_pressed
    MouseButton::Middle => !just_mouse.middle_button_pressed
  }
}
