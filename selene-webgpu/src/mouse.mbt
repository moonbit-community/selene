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
extern "js" fn configure_canvas_touch_input(
  canvas : @dom.HTMLCanvasElement,
) -> Unit =
  #| (canvas) => {
  #|   if (canvas && canvas.style) {
  #|     canvas.style.touchAction = 'none';
  #|     canvas.style.userSelect = 'none';
  #|     canvas.style.webkitUserSelect = 'none';
  #|     canvas.style.webkitTouchCallout = 'none';
  #|     canvas.style.webkitTapHighlightColor = 'transparent';
  #|   }
  #|   canvas?.addEventListener?.('contextmenu', event => event.preventDefault());
  #| }

///|
extern "js" fn pointer_event_id(event : @dom.Event) -> Int =
  #| (event) => Number(event.pointerId ?? 0) | 0

///|
extern "js" fn pointer_event_type(event : @dom.Event) -> String =
  #| (event) => String(event.pointerType ?? '')

///|
extern "js" fn pointer_event_offset_x(event : @dom.Event) -> Double =
  #| (event) => {
  #|   if (Number.isFinite(event.offsetX)) return Number(event.offsetX);
  #|   const rect = event.currentTarget?.getBoundingClientRect?.();
  #|   if (!rect) return 0;
  #|   return Number(event.clientX ?? 0) - rect.left;
  #| }

///|
extern "js" fn pointer_event_offset_y(event : @dom.Event) -> Double =
  #| (event) => {
  #|   if (Number.isFinite(event.offsetY)) return Number(event.offsetY);
  #|   const rect = event.currentTarget?.getBoundingClientRect?.();
  #|   if (!rect) return 0;
  #|   return Number(event.clientY ?? 0) - rect.top;
  #| }

///|
extern "js" fn pointer_event_is_primary(event : @dom.Event) -> Bool =
  #| (event) => Boolean(event.isPrimary ?? true)

///|
extern "js" fn prevent_pointer_default(event : @dom.Event) -> Unit =
  #| (event) => event.preventDefault?.()

///|
extern "js" fn capture_pointer(
  canvas : @dom.HTMLCanvasElement,
  pointer_id : Int,
) -> Unit =
  #| (canvas, pointerId) => {
  #|   try { canvas.setPointerCapture?.(pointerId); } catch (_err) {}
  #| }

///|
extern "js" fn release_pointer(
  canvas : @dom.HTMLCanvasElement,
  pointer_id : Int,
) -> Unit =
  #| (canvas, pointerId) => {
  #|   try { canvas.releasePointerCapture?.(pointerId); } catch (_err) {}
  #| }

///|
let touch_handlers_registered : Ref[Bool] = Ref(false)

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_relative_delta : Ref[@smath.Vec2?],
  mouse_wheel : @inputs.MouseWheel,
) -> Unit {
  window.add_event_listener("mousemove", event => {
    let mouse_event = event.to_mouse_event().unwrap()
    mouse.pos = @smath.Vec2(
      mouse_event.get_offset_x().to_double(),
      mouse_event.get_offset_y().to_double(),
    )
    mouse_relative_delta.val = Some(
      @smath.Vec2(
        mouse_event.get_movement_x().to_double(),
        mouse_event.get_movement_y().to_double(),
      ),
    )
  })
  window.add_event_listener("mousedown", event => {
    note_audio_user_activation()
    let mouse_event = event.to_mouse_event().unwrap()
    match mouse_event.get_button() {
      0 => mouse.left_button = true
      1 => mouse.middle_button = true
      2 => mouse.right_button = true
      _ => ()
    }
  })
  window.add_event_listener("touchstart", _event => note_audio_user_activation())
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
    mouse_wheel.delta = @smath.Vec2(
      wheel_event.get_delta_x(),
      wheel_event.get_delta_y(),
    )
  })
}

///|
fn is_touch_pointer_type(kind : String) -> Bool {
  kind == "touch" || kind == "pen"
}

///|
fn touch_position_from_pointer_event(event : @dom.Event) -> @smath.Vec2 {
  @smath.Vec2(pointer_event_offset_x(event), pointer_event_offset_y(event))
}

///|
fn push_touch_change(
  changes : Array[@inputs.TouchEvent],
  id : @inputs.TouchId,
  phase : @inputs.TouchPhase,
  position : @smath.Vec2,
  previous_position : @smath.Vec2,
  primary : Bool,
) -> Unit {
  changes.push({
    id,
    phase,
    position,
    previous_position,
    delta: position - previous_position,
    primary,
  })
}

///|
pub fn register_touch_events(
  touches : Map[@inputs.TouchId, @inputs.TouchPoint],
  changes : Array[@inputs.TouchEvent],
) -> Unit {
  if touch_handlers_registered.val {
    return
  }
  touch_handlers_registered.val = true
  let canvas = require_canvas()
  configure_canvas_touch_input(canvas)
  canvas.add_event_listener("pointerdown", event => {
    let kind = pointer_event_type(event)
    if !is_touch_pointer_type(kind) {
      return
    }
    prevent_pointer_default(event)
    note_audio_user_activation()
    let id = @inputs.TouchId(pointer_event_id(event))
    let position = touch_position_from_pointer_event(event)
    let primary = pointer_event_is_primary(event)
    touches.set(id, {
      id,
      position,
      previous_position: position,
      delta: @smath.Vec2::zero(),
      primary,
    })
    push_touch_change(changes, id, Started, position, position, primary)
    capture_pointer(canvas, id.value)
  })
  canvas.add_event_listener("pointermove", event => {
    let kind = pointer_event_type(event)
    if !is_touch_pointer_type(kind) {
      return
    }
    prevent_pointer_default(event)
    let id = @inputs.TouchId(pointer_event_id(event))
    guard touches.get(id) is Some(previous_touch) else { return }
    let position = touch_position_from_pointer_event(event)
    let previous_position = previous_touch.position
    let primary = previous_touch.primary
    let delta = position - previous_position
    touches.set(id, { id, position, previous_position, delta, primary })
    if delta[X] != 0.0 || delta[Y] != 0.0 {
      push_touch_change(
        changes,
        id,
        Moved,
        position,
        previous_position,
        primary,
      )
    }
  })
  canvas.add_event_listener("pointerup", event => {
    let kind = pointer_event_type(event)
    if !is_touch_pointer_type(kind) {
      return
    }
    prevent_pointer_default(event)
    let id = @inputs.TouchId(pointer_event_id(event))
    let position = touch_position_from_pointer_event(event)
    let previous_position = touches
      .get(id)
      .map_or(position, fn(touch) { touch.position })
    let primary = touches
      .get(id)
      .map_or(pointer_event_is_primary(event), fn(touch) { touch.primary })
    push_touch_change(changes, id, Ended, position, previous_position, primary)
    ignore(touches.remove(id))
    release_pointer(canvas, id.value)
  })
  canvas.add_event_listener("pointercancel", event => {
    let kind = pointer_event_type(event)
    if !is_touch_pointer_type(kind) {
      return
    }
    prevent_pointer_default(event)
    let id = @inputs.TouchId(pointer_event_id(event))
    let position = touch_position_from_pointer_event(event)
    let previous_position = touches
      .get(id)
      .map_or(position, fn(touch) { touch.position })
    let primary = touches
      .get(id)
      .map_or(pointer_event_is_primary(event), fn(touch) { touch.primary })
    push_touch_change(
      changes,
      id,
      Cancelled,
      position,
      previous_position,
      primary,
    )
    ignore(touches.remove(id))
    release_pointer(canvas, id.value)
  })
}

///|
pub fn lock_mouse(requested_lock_ref : Ref[Bool]) -> Unit {
  let canvas = require_canvas()
  canvas.add_event_listener("click", fn(_event) {
    note_audio_user_activation()
    request_pointer_lock_if_enabled(canvas, requested_lock_ref.val)
  })
}

///|
pub fn sync_mouse_lock_state(lock_requested : Bool) -> Bool {
  let canvas = require_canvas()
  let lock_active = is_pointer_locked(canvas)
  if !lock_requested && lock_active {
    exit_pointer_lock()
    return false
  }
  lock_active
}
