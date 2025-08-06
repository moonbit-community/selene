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
let last_pressed_keys : Set[Code] = @set.Set::new()

///|
let just_pressed_keys : Set[Code] = @set.Set::new()

///|
pub fn advanced_key_system(_backend : &Backend) -> Unit {
  just_pressed_keys.clear()
  for code in pressed_keys {
    if !last_pressed_keys.contains(code) {
      just_pressed_keys.add(code)
    }
  }
  last_pressed_keys.clear()
  for code in pressed_keys {
    last_pressed_keys.add(code)
  }
}

///|
pub fn is_just_pressed(code : Code) -> Bool {
  just_pressed_keys.contains(code)
}

///|
pub fn is_just_released(code : Code) -> Bool {
  just_pressed_keys.contains(code)
}
