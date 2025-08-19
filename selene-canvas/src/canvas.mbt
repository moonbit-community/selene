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
  mut frame_counter : UInt64
  mut current_fps : Double
  mut zoom : Double
  execution_time : Map[String, Double]
  mouse_movement : Ref[@system.MouseMovement?]
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
    current_fps: 0.0,
    frame_counter: 0,
    execution_time: {},
    mouse_movement: Ref::new(None),
    zoom: 1.0,
  }
}

///|
pub impl @system.Backend for CanvasBackend with build(
  self,
  systems,
  canvas_width,
  canvas_height,
  fps,
  image_smooth,
  zoom,
) {
  if fps > 60 {
    println(
      "Warning: FPS is set above 60. The browser's window only support up to 60 FPS.",
    )
  }
  for system in systems {
    if system.1 is Startup {
      (system.0)(self)
    }
  }
  self.viewport_size = @math.Vec2D(canvas_width, canvas_height)
  set_viewport_height(self.canvas, canvas_height)
  set_viewport_width(self.canvas, canvas_width)
  set_image_smoothing_enabled(self.context, image_smooth)
  self.context.scale(zoom, zoom)
  self.zoom = zoom
  schedule_with_fixed_interval(1000 / fps.to_double(), fn(delta) {
    self.current_fps = 1000.0 / delta
    self.context.clear_rect(0, 0, canvas_width, canvas_height)
    let renders = []
    for system in systems {
      let start_time = time_now()
      match system.1 {
        UpdateFrame(frame_period) if self.frame_counter %
          frame_period.to_uint64() ==
          0 => {
          (system.0)(self)
          self.execution_time[system.2] = time_now() - start_time
        }
        Render(priority) => renders.push((system.0, priority))
        Update => {
          (system.0)(self)
          self.execution_time[system.2] = time_now() - start_time
        }
        UpdateTime(period) if self.frame_counter %
          (fps.to_double() * period).to_uint64() ==
          0 => {
          (system.0)(self)
          self.execution_time[system.2] = time_now() - start_time
        }
        _ => ()
      }
    }
    renders.sort_by_key(fn(system) { -system.1 })
    for render in renders {
      (render.0)(self)
    }
    if self.mouse_movement.val is Some(mouse_movement) {
      mouse_movement.movement = @math.Vec2D(0.0, 0.0)
    }
    self.frame_counter += 1
  })
  |> ignore
  return fn() {  }
}

///|
pub impl @system.Backend for CanvasBackend with get_canvas_size(self) {
  @math.Vec2D(self.viewport_size[X], self.viewport_size[Y])
}

///|
pub impl @system.Backend for CanvasBackend with get_debug_info(self) {
  { system_execution_time: self.execution_time, fps: self.current_fps }
}

///|
pub impl @system.Backend for CanvasBackend with get_zoom(self) {
  self.zoom
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
