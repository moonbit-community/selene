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
pub fn run() -> Unit {
  @app.App::new()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(ZOOM)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(Startup, game_start)
  .add_system(PostUpdate, cards_ui_pointer_system)
  .add_system(Update, game_update_system)
  .run()
}

///|
/// Game initialization
fn game_start(_world : @ecs.World) -> Unit {
  // Load font
  ignore(@asset.load_font("assets/cards/ThaleahFat.ttf", family="ThaleahFat"))
  @ui.set_ui_scale_mode(@ui.UiScaleMode::Viewport)
  let camera_entity = @entity.Entity::new()
  @camera.cameras().set(camera_entity, @camera.Camera::new())
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @camera.orthographic_projections().set(
    camera_entity,
    @camera.OrthographicProjection::new(),
  )
  @transform.transforms().set(
    camera_entity,
    @transform.Transform::from_xyz(
      VIEWPORT_WIDTH / 2.0,
      VIEWPORT_HEIGHT / 2.0,
      0.0,
    ),
  )

  // Setup UI
  setup_ui()

  // Start first hand
  start_new_hand()
}

///|
/// Main game update system
fn game_update_system(_world : @ecs.World) -> Unit {
  match game_state.phase {
    PreFlop | Flop | Turn | River => handle_betting_round()
    Showdown => handle_showdown()
    GameOver => ()
  }
}
