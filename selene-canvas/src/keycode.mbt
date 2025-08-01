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
pub impl @system.Backend for CanvasBackend with register_key_events(
  _self,
  pressed_keys : Set[@system.Code],
  keyup_callbacks : Map[@system.Code, Array[() -> Unit]],
  keydown_callbacks : Map[@system.Code, Array[() -> Unit]],
) {
  window.add_event_listener("keyup", event => {
    let keyboardEvent = event.to_keyboard_event().unwrap()
    let keycode = keyboardEvent.code() |> @system.Code::from_string
    if keycode is Some(c) {
      pressed_keys.remove(c)
      if keyup_callbacks.get(c) is Some(callbacks) {
        for callback in callbacks {
          callback()
        }
      }
    }
  })
  window.add_event_listener("keydown", event => {
    let keyboardEvent = event.to_keyboard_event().unwrap()
    let keycode = keyboardEvent.code() |> @system.Code::from_string
    if keycode is Some(c) {
      pressed_keys.add(c)
      if keydown_callbacks.get(c) is Some(callbacks) {
        for callback in callbacks {
          callback()
        }
      }
    }
  })
}
