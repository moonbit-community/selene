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
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_movement : @inputs.MouseMovement,
  mouse_wheel : @inputs.MouseWheel,
) -> Unit {
  canvas_backend.mouse_movement.val = Some(mouse_movement)
  window.add_event_listener("mousemove", event => {
    let mouse_event = event.to_mouse_event().unwrap()
    mouse.pos = @smath.Vec2D(
      mouse_event.get_offset_x().to_double(),
      mouse_event.get_offset_y().to_double(),
    )
    mouse_movement.movement = @smath.Vec2D(
      mouse_event.get_movement_x().to_double(),
      mouse_event.get_movement_y().to_double(),
    )
  })
  window.add_event_listener("mousedown", event => {
    let mouse_event = event.to_mouse_event().unwrap()
    match mouse_event.get_button() {
      0 => mouse.left_button = true
      1 => mouse.middle_button = true
      2 => mouse.right_button = true
      _ => ()
    }
  })
  window.add_event_listener("mouseup", event => {
    let mouse_event = event.to_mouse_event().unwrap()
    match mouse_event.get_button() {
      0 => mouse.left_button = false
      1 => mouse.middle_button = false
      2 => mouse.right_button = false
      _ => ()
    }
  })
  window.add_event_listener("wheel", event => {
    let wheel_event = event.to_wheel_event().unwrap()
    mouse_wheel.delta = @smath.Vec2D(
      wheel_event.get_delta_x(),
      wheel_event.get_delta_y(),
    )
  })
}

///|
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  let canvas = require_canvas()
  canvas.add_event_listener("click", fn(_event) {
    request_pointer_lock_if_enabled(canvas, locked.val)
  })
  document_add_event_listener("pointerlockchange", fn(_event) {
    locked.val = is_pointer_locked(canvas)
  })
}

///|
pub fn sync_mouse_lock_state(locked : Bool) -> Bool {
  let canvas = require_canvas()
  if !locked && is_pointer_locked(canvas) {
    exit_pointer_lock()
    return false
  }
  if locked {
    return is_pointer_locked(canvas)
  }
  false
}
