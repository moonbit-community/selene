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
const ZOOM : Double = 2.0

///|
const VIEWPORT_WIDTH : Double = 480.0

///|
const VIEWPORT_HEIGHT : Double = 320.0

///|
const REAL_VIEWPORT_WIDTH : Double = VIEWPORT_WIDTH * ZOOM

///|
const REAL_VIEWPORT_HEIGHT : Double = VIEWPORT_HEIGHT * ZOOM

///|
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(REAL_VIEWPORT_WIDTH)
  .with_canvas_height(REAL_VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(player_state_system)
  .run()
}

///|
fn game_start(backend : &@system.Backend) -> Unit {
  generate_map(backend)
  add_result_box()
  add_score_box()
  add_volume_button()
}
