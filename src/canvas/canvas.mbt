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
  context : @dom.CanvasRenderingContext2D
}

///|
pub fn CanvasBackend::new() -> CanvasBackend {
  let canvas = @dom.document()
    .get_element_by_id("canvas")
    .unwrap()
    .to_html_canvas_element()
    .unwrap()
  let context = canvas.get_context("2d").to0().unwrap()
  { context, }
}

///|
pub impl @selene.Backend for CanvasBackend with build(
  self,
  initialize,
  game_loop,
  physical_fps,
  render_loop,
  canvas_width,
  canvas_height,
  fps,
) {
  initialize()
  schedule_with_fixed_interval(1000 / fps.to_double(), () => {
    self.context.clear_rect(0, 0, canvas_width, canvas_height)
    render_loop()
  })
  |> ignore
  schedule_with_fixed_interval(1000 / physical_fps.to_double(), game_loop)
  |> ignore
}

///|
let window : @dom.Window = @dom.window()

///|
fn schedule_with_fixed_interval(
  interval : Double,
  callback : () -> Unit,
) -> () -> Unit {
  let lastTime = { val: 0.0 }
  let lastId = { val: 0.0 }
  fn update(time : Double) -> Unit {
    if lastTime.val == 0.0 {
      lastTime.val = time
    }
    let elapsed = time - lastTime.val
    if elapsed >= interval {
      callback()
      lastTime.val = time
      lastId.val = window.request_animation_frame(update)
    } else {
      lastId.val = window.request_animation_frame(update)
    }
  }

  lastId.val = window.request_animation_frame(update)
  () => if lastId.val != 0.0 {
    // Cancel the scheduled animation frame
    window.cancel_animation_frame(lastId.val)
  }
}
