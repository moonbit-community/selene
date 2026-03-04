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
pub fn run() -> Unit {
  @system.App::new()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(player_state_system)
  .add_system(player_collision_system)
  .add_system(bird_ai_system)
  .add_system(map_trigger_system)
  .add_system(volume_button_input_system, schedule=PostUpdate)
  .run()
}

///|
fn game_start(_delta : Double) -> Unit {
  ignore(
    @asset.load_font(
      "assets/pixeladventure/Fonts/ThaleahFat.ttf",
      family="ThaleahFat",
    ),
  )
  generate_map()
  add_result_box()
  add_score_box()
  add_health_box()
  add_volume_button()
}
