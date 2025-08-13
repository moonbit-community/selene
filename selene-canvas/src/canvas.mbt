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
  frame_times : Array[Double]
  mut last_frame_time : Double
  mut current_fps : Double
}

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
    frame_times: Array::new(),
    last_frame_time: 0.0,
    current_fps: 0.0
  }
}

///|
pub impl @system.Backend for CanvasBackend with build(
  self,
  initialize,
  game_loop,
  canvas_width,
  canvas_height,
  fps,
) {
  initialize()
  self.viewport_size = @math.Vec2D(canvas_width, canvas_height)
  set_viewport_height(self.canvas, canvas_height)
  set_viewport_width(self.canvas, canvas_width)
  schedule_with_fixed_interval(1000 / fps.to_double(), fn(time) {
    self.update_fps(time)
    self.context.clear_rect(0, 0, canvas_width, canvas_height)
    game_loop()
  })
  |> ignore
  return fn() {  }
}

///|
pub impl @system.Backend for CanvasBackend with get_canvas_size(self) {
  @math.Vec2D(self.viewport_size[X], self.viewport_size[Y])
}

///|
pub impl @system.Backend for CanvasBackend with get_fps(self) {
  self.current_fps
}

///|
fn CanvasBackend::update_fps(self : CanvasBackend, current_time : Double) -> Unit {
  if self.last_frame_time > 0.0 {
    let frame_delta = current_time - self.last_frame_time
    self.frame_times.push(frame_delta)
    
    // Keep only the last 60 frame times for averaging
    while self.frame_times.length() > 60 {
      self.frame_times.drain(0, 1) |> ignore
    }
    
    // Calculate average FPS
    if self.frame_times.length() > 0 {
      let total_time = self.frame_times.fold(init=0.0, fn(acc, time) { acc + time })
      let average_frame_time = total_time / self.frame_times.length().to_double()
      self.current_fps = 1000.0 / average_frame_time
    }
  }
  self.last_frame_time = current_time
}

///|
let window : @dom.Window = @dom.window()

///|
fn schedule_with_fixed_interval(
  interval : Double,
  callback : (Double) -> Unit,
) -> () -> Unit {
  let lastTime = { val: 0.0 }
  let lastId = { val: 0.0 }
  
  fn update(time : Double) -> Unit {
    if lastTime.val == 0.0 {
      lastTime.val = time
    }
    let elapsed = time - lastTime.val
    
    // For 60 FPS (16.67ms interval), use requestAnimationFrame directly
    if interval <= 16.67 {
      callback(time)
      lastTime.val = time
    } else if elapsed >= interval {
      callback(time)
      lastTime.val = time
    }
    
    lastId.val = window.request_animation_frame(update)
  }

  lastId.val = window.request_animation_frame(update)
  () => if lastId.val != 0.0 {
    window.cancel_animation_frame(lastId.val)
  }
}
