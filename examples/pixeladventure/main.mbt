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
fn pixeladventure_app() -> @app.App {
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .add_plugin(@plugins.default_plugin)
  .add_exclusive_system(Startup, game_start)
  .add_system(Update, @ecs.args2(player_input_system))
  .add_system(FixedPreUpdate, @ecs.args6(player_controller_system))
  .add_system(Update, @ecs.args6(trigger_system))
  .add_system(Update, @ecs.args2(pixeladventure_camera_follow_system))
  .add_system(FixedPostUpdate, @ecs.args7(player_bird_contact_system))
  .add_system(FixedPostUpdate, @ecs.args6(bird_patrol_system))
  .add_system(PostUpdate, @ecs.args2(volume_button_system))
  .add_system(PostUpdate, @ecs.args4(hud_sync_system))
}

///|
pub fn run() -> Unit {
  pixeladventure_app().run()
}
