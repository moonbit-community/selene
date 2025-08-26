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
const MAP_HEIGHT : Double = 640.0

///|
const MAP_WIDTH : Double = 640.0

///|
const FPS : Double = 60

///|
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(REAL_VIEWPORT_WIDTH)
  .with_canvas_height(REAL_VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(FPS.to_uint())
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(spawn_enemy_system, schedule=UpdateTime(1.0))
  .add_system(player_update_system)
  .add_system(player_shooting_system)
  .add_system(enemy_ai_system)
  .run()
}

///|
struct GameState {
  player_entity : @system.Entity
  mut player_direction : Dir4
  rand : @random.Rand
  mut shoot_timer : Double
  mut score : Int
  score_box : @sprite.Text
  mut invincible : Bool
}

///|
enum Dir4 {
  Up
  Down
  Left
  Right
}

///|
let game_state : GameState = {
  player_entity: @system.Entity::new(),
  player_direction: Down,
  rand: @random.Rand::new(),
  shoot_timer: 0.0,
  score: 0,
  score_box: @sprite.Text::new(
    "Score: 0",
    color="white",
    font="24px ThaleahFat",
  ),
  invincible: false,
}

///|
fn set_score(score : Int) -> Unit {
  game_state.score = score
  game_state.score_box.content = "Score: " + game_state.score.to_string()
}

///|
fn game_start(_backend : &@system.Backend) -> Unit {
  @camera.set_limits(top=0.0, bottom=MAP_HEIGHT, left=0.0, right=MAP_WIDTH)
  add_player()
  add_border(Vec2D(MAP_WIDTH, MAP_HEIGHT))
  add_background(Vec2D(MAP_WIDTH, MAP_HEIGHT))
  add_grass()
  add_score_box()
}
