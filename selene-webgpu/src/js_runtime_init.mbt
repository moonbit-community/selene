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
priv type BrowserCanvas

///|
priv type BrowserEvent

///|
extern "js" fn find_canvas() -> @js.Nullable[BrowserCanvas] =
  #| () => {
  #|   const element = document.getElementById('canvas');
  #|   return element instanceof HTMLCanvasElement ? element : null;
  #| }

///|
extern "js" fn BrowserCanvas::add_event_listener(
  canvas : BrowserCanvas,
  event : String,
  callback : (BrowserEvent) -> Unit,
) -> Unit = "(canvas, event, callback) => { canvas.addEventListener(event, callback); }"

///|
extern "js" fn window_add_event_listener(
  event : String,
  callback : (BrowserEvent) -> Unit,
) -> Unit = "(event, callback) => { window.addEventListener(event, callback); }"

///|
extern "js" fn window_request_animation_frame(
  callback : (Double) -> Unit,
) -> Double = "(callback) => window.requestAnimationFrame(callback)"

///|
extern "js" fn window_cancel_animation_frame(id : Double) -> Unit = "(id) => window.cancelAnimationFrame(id)"

///|
extern "js" fn BrowserEvent::code(event : BrowserEvent) -> String = "(event) => event.code"

///|
extern "js" fn BrowserEvent::repeat(event : BrowserEvent) -> Bool = "(event) => event.repeat"

///|
extern "js" fn BrowserEvent::get_offset_x(event : BrowserEvent) -> Double = "(event) => event.offsetX"

///|
extern "js" fn BrowserEvent::get_offset_y(event : BrowserEvent) -> Double = "(event) => event.offsetY"

///|
extern "js" fn BrowserEvent::get_movement_x(event : BrowserEvent) -> Double = "(event) => event.movementX"

///|
extern "js" fn BrowserEvent::get_movement_y(event : BrowserEvent) -> Double = "(event) => event.movementY"

///|
extern "js" fn BrowserEvent::get_button(event : BrowserEvent) -> Int32 = "(event) => event.button"

///|
extern "js" fn BrowserEvent::get_delta_x(event : BrowserEvent) -> Double = "(event) => event.deltaX"

///|
extern "js" fn BrowserEvent::get_delta_y(event : BrowserEvent) -> Double = "(event) => event.deltaY"

///|
extern "js" fn set_viewport_height(
  elem : BrowserCanvas,
  height : Double,
) -> Unit = "(x, y) => { x.height = y; }"

///|
extern "js" fn set_viewport_width(elem : BrowserCanvas, width : Double) -> Unit = "(x, y) => { x.width = y; }"

///|
extern "js" fn request_pointer_lock_if_enabled(
  elem : BrowserCanvas,
  enabled : Bool,
) -> Unit = "(elem, enabled) => { if (enabled && document.pointerLockElement !== elem) { elem.requestPointerLock(); } }"

///|
extern "js" fn is_pointer_locked(canvas : BrowserCanvas) -> Bool = "(canvas) => document.pointerLockElement === canvas"

///|
extern "js" fn exit_pointer_lock() -> Unit = "() => { if (document.exitPointerLock) { document.exitPointerLock(); } }"

///|
extern "js" fn document_add_event_listener(
  event : String,
  callback : (BrowserEvent) -> Unit,
) -> Unit = "(event, callback) => { document.addEventListener(event, callback); }"

///|
extern "js" fn document_hidden() -> Bool = "() => document.hidden"

///|
extern "js" fn prevent_default_event(event : BrowserEvent) -> Unit = "(event) => event.preventDefault()"

///|
extern "js" fn load_font_async(
  font : String,
  path : String,
  accept : () -> Bool,
  installed : () -> Unit,
  failed : (String) -> Unit,
) -> Unit =
  #| (font, path, accept, installed, failed) => {
  #|   const ff = new FontFace(font, 'url(' + path + ')');
  #|   ff.load().then(loadedFont => {
  #|     if (!accept()) return;
  #|     const faces = globalThis.__selene_font_faces ??
  #|       (globalThis.__selene_font_faces = new Map());
  #|     const previous = faces.get(font);
  #|     if (previous) document.fonts.delete(previous);
  #|     document.fonts.add(loadedFont);
  #|     faces.set(font, loadedFont);
  #|     installed();
  #|   }).catch(error => {
  #|     failed(error && error.message ? String(error.message) : String(error));
  #|   });
  #| }
