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
fn cards_app() -> @app.App {
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(ZOOM)
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_exclusive_system(Startup, game_start)
  .add_system(PostUpdate, cards_ui_pointer_system)
  .add_system(Update, game_update_system)
}

///|
pub fn run() -> Unit {
  cards_app().run()
}

///|
/// Game initialization
fn game_start(world : @ecs.World) -> Unit {
  reset_cards_runtime()
  // Load font
  ignore(@asset.load_font("assets/cards/ThaleahFat.ttf", family="ThaleahFat"))
  @ui.set_ui_scale_mode(Viewport)
  ignore(
    spawn_cards_entity(
      (
        @camera.Camera(),
        @camera.Camera2d(),
        @camera.OrthographicProjection(),
        @transform.Spatial(
          @transform.Transform::from_xyz(
            VIEWPORT_WIDTH / 2.0,
            VIEWPORT_HEIGHT / 2.0,
            0.0,
          ),
        ),
      ),
    ),
  )

  // Setup UI
  ignore(game_state())
  let ctx = CardsGame(world)
  setup_ui(ctx~)

  // Start first hand
  start_new_hand(ctx~)
  @ecs.commands(world).add(_ => update_ui(ctx~))
}

///|
/// Main game update system
fn game_update_system(ctx : CardsGame) -> Unit {
  match ctx.game().phase {
    PreFlop | Flop | Turn | River => handle_betting_round(ctx~)
    Showdown => handle_showdown(ctx~)
    GameOver => ()
  }
}
