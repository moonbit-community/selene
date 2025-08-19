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
pub extern "js" fn set_viewport_height(
  elem : @dom.HTMLCanvasElement,
  height : Double,
) -> Unit = "(x, y) => { x.height = y; }"

///|
pub extern "js" fn set_viewport_width(
  elem : @dom.HTMLCanvasElement,
  width : Double,
) -> Unit = "(x, y) => { x.width = y; }"

///|
pub extern "js" fn time_now() -> Double = "() => performance.now()"

///|
pub extern "js" fn request_pointer_lock(elem : @dom.HTMLCanvasElement) -> Unit = "(elem) => elem.requestPointerLock();"

///|
pub extern "js" fn is_pointer_locked(canvas : @dom.HTMLCanvasElement) -> Bool = "(canvas) => document.pointerLockElement === canvas"

///|
pub extern "js" fn document_add_event_listener(
  event : String,
  callback : (@dom.Event) -> Unit,
) -> Unit = "(event, callback) => { document.addEventListener(event, callback); }"

///|
pub extern "js" fn set_image_smoothing_enabled(
  ctx : @dom.CanvasRenderingContext2D,
  value : Bool,
) -> Unit = "(ctx, value) => ctx.imageSmoothingEnabled = value;"
