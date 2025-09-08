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
  .add_system(game_timer_system)
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
  mut game_timer : Double
  mut game_over : Bool
  timer_box : @sprite.Text
  game_over_box : @sprite.Text
  mut game_over_displayed : Bool
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
  game_timer: 60.0,
  game_over: false,
  timer_box: @sprite.Text::new(
    "Time: 60",
    color="white",
    font="24px ThaleahFat",
  ),
  game_over_box: @sprite.Text::new(
    "TIME'S UP! Final Score: 0",
    color="red",
    font="32px ThaleahFat",
  ),
  game_over_displayed: false,
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
  add_timer_box()
}

///|
fn game_timer_system(_backend : &@system.Backend) -> Unit {
  if game_state.game_over {
    if not(game_state.game_over_displayed) {
      game_state.game_over_displayed = true
      game_state.game_over_box.content = "TIME'S UP! Final Score: " +
        game_state.score.to_string()
      add_game_over_box()
    }
    return
  }
  game_state.game_timer -= 1.0 / FPS
  if game_state.game_timer <= 0.0 {
    game_state.game_timer = 0.0
    game_state.game_over = true
  }
  let seconds = game_state.game_timer.to_int()
  game_state.timer_box.content = "Time: " + seconds.to_string()
}

///|
fn add_timer_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.timer_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH - 120, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_game_over_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(
    game_state.game_over_box,
    UI_ZINDEX + 1,
  )
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 160, VIEWPORT_HEIGHT / 2.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}
