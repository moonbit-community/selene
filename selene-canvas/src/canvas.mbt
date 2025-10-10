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
struct CanvasBackend {
  canvas : @dom.HTMLCanvasElement
  context : @dom.CanvasRenderingContext2D
  mut viewport_size : @math.Vec2D
  mut zoom : Double
  mut time_scale : Double
  mouse_movement : Ref[@inputs.MouseMovement?]
}

///|
pub fn CanvasBackend::new() -> CanvasBackend {
  let canvas = @dom.document()
    .get_element_by_id("canvas")
    .unwrap()
    .to_html_canvas_element()
    .unwrap()
  let context = canvas.get_context("2d").to0().unwrap()
  {
    context,
    canvas,
    viewport_size: @math.Vec2D::zero(),
    time_scale: 1.0,
    mouse_movement: Ref::new(None),
    zoom: 1.0,
  }
}

///|
let canvas_backend : CanvasBackend = CanvasBackend::new()

///|
pub fn set_time_scale(time_scale : Double) -> Unit {
  canvas_backend.time_scale = time_scale
}

///|
let realtime_delta : Ref[Double] = Ref::new(0.0)

///|
pub fn initialize(
  startup~ : () -> Unit,
  render_loop~ : (Double) -> Unit,
  game_loop~ : (Double) -> Unit,
  canvas_width~ : Double,
  canvas_height~ : Double,
  fps~ : UInt,
  image_smooth~ : Bool,
  zoom~ : Double,
) -> () -> Unit {
  if fps > 60 {
    println(
      "Warning: FPS is set above 60. The browser's window only support up to 60 FPS.",
    )
  }
  canvas_backend.viewport_size = @math.Vec2D(canvas_width, canvas_height)
  set_viewport_height(canvas_backend.canvas, canvas_height)
  set_viewport_width(canvas_backend.canvas, canvas_width)
  set_image_smoothing_enabled(canvas_backend.context, image_smooth)
  canvas_backend.context.scale(zoom, zoom)
  canvas_backend.zoom = zoom
  startup()
  schedule_with_fixed_interval(1000 / fps.to_double(), fn(delta) {
    let delta = delta / 1000.0
    // canvas_backend.current_fps = 1.0 / delta
    canvas_backend.context.clear_rect(0, 0, canvas_width, canvas_height)
    realtime_delta.val = delta
    render_loop(delta * canvas_backend.time_scale)
    game_loop(delta * canvas_backend.time_scale)
    if canvas_backend.mouse_movement.val is Some(mouse_movement) {
      mouse_movement.movement = @math.Vec2D(0.0, 0.0)
    }
  })
  |> ignore
  return fn() {  }
}

///|
pub fn get_canvas_size() -> @math.Vec2D {
  canvas_backend.viewport_size
}

///|
pub fn get_zoom() -> Double {
  canvas_backend.zoom
}

///|
pub fn get_realtime_delta() -> Double {
  realtime_delta.val
}

///|
let window : @dom.Window = @dom.window()

///|
fn schedule_with_fixed_interval(
  interval : Double,
  callback : (Double) -> Unit,
) -> () -> Unit {
  let lastTime = { val: 0.0 }
  let accumulator = { val: 0.0 }
  let lastId = { val: 0.0 }
  fn update(time : Double) -> Unit {
    if lastTime.val == 0.0 {
      lastTime.val = time
    }
    let delta = time - lastTime.val
    lastTime.val = time
    accumulator.val = accumulator.val + delta

    // Run callback for each complete interval
    while accumulator.val >= interval {
      callback(delta)
      accumulator.val = accumulator.val - interval
    }
    lastId.val = window.request_animation_frame(update)
  }

  lastId.val = window.request_animation_frame(update)
  () => if lastId.val != 0.0 { window.cancel_animation_frame(lastId.val) }
}

///|
pub fn load_font(font : String, path : String) -> Unit {
  load_font_async(font, path)
}
