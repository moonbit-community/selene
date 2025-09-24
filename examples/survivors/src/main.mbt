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
  @system.App::new()
  .with_canvas_width(REAL_VIEWPORT_WIDTH)
  .with_canvas_height(REAL_VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(FPS.to_uint())
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(spawn_enemy_system, schedule=Startup)
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
  mut current_wave : Int
  wave_box : @sprite.Text
  mut exp : Int
  exp_box : @sprite.Text
  mut player_level : Int
  level_box : @sprite.Text
  level_up_box : @sprite.Text
  level_up_entity : @system.Entity
  resume_button_entity : @system.Entity
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
  game_timer: 600.0,
  game_over: false,
  timer_box: @sprite.Text::new(
    "Time: 10:00",
    color="white",
    font="24px ThaleahFat",
  ),
  game_over_box: @sprite.Text::new(
    "TIME'S UP! Final Score: 0",
    color="red",
    font="32px ThaleahFat",
  ),
  game_over_displayed: false,
  current_wave: 1,
  wave_box: @sprite.Text::new("Wave: 1", color="orange", font="24px ThaleahFat"),
  exp: 0,
  exp_box: @sprite.Text::new("EXP: 0/16", color="cyan", font="24px ThaleahFat"),
  player_level: 1,
  level_box: @sprite.Text::new(
    "Level: 1",
    color="yellow",
    font="24px ThaleahFat",
  ),
  level_up_box: @sprite.Text::new(
    "LEVEL UP!",
    color="gold",
    font="36px ThaleahFat",
  ),
  level_up_entity: @system.Entity::new(),
  resume_button_entity: @system.Entity::new(),
}

///|
fn set_score(score : Int) -> Unit {
  game_state.score = score
  game_state.score_box.content = "Score: " + game_state.score.to_string()
}

///|
fn xp_required_for_level(n : Int) -> Int {
  n * (2 * n * n + 21 * n + 73) / 6
}

///|
fn get_level_from_xp(xp : Int) -> Int {
  let mut level = 1
  while xp >= xp_required_for_level(level) {
    level += 1
  }
  level
}

///|
fn add_exp(exp_gained : Int) -> Unit {
  let old_level = game_state.player_level
  game_state.exp += exp_gained

  // Calculate new player level using the XP formula
  let new_level = get_level_from_xp(game_state.exp)
  if new_level > old_level {
    game_state.player_level = new_level
    game_state.level_box.content = "Level: " +
      game_state.player_level.to_string()

    level_up()
  }

  // Update EXP display with progress to next level
  let current_level_xp = if game_state.player_level == 1 {
    0
  } else {
    xp_required_for_level(game_state.player_level - 1)
  }
  let next_level_xp = xp_required_for_level(game_state.player_level)
  let progress_xp = game_state.exp - current_level_xp
  let needed_xp = next_level_xp - current_level_xp
  game_state.exp_box.content = "EXP: " +
    progress_xp.to_string() +
    "/" +
    needed_xp.to_string()
}

///|
fn game_start(_delta : Double) -> Unit {
  @camera.set_limits(top=0.0, bottom=MAP_HEIGHT, left=0.0, right=MAP_WIDTH)
  add_player()
  add_border(Vec2D(MAP_WIDTH, MAP_HEIGHT))
  add_background(Vec2D(MAP_WIDTH, MAP_HEIGHT))
  add_grass()
  add_score_box()
  add_timer_box()
  add_wave_box()
  add_level_box()
  add_exp_box()
  setup_level_up_ui()
}

///|
fn game_timer_system(delta : Double) -> Unit {
  if game_state.game_over {
    if not(game_state.game_over_displayed) {
      game_state.game_over_displayed = true
      game_state.game_over_box.content = "TIME'S UP! Final Score: " +
        game_state.score.to_string()
      add_game_over_box()
    }
    return
  }
  game_state.game_timer -= delta
  if game_state.game_timer <= 0.0 {
    game_state.game_timer = 0.0
    game_state.game_over = true
  }

  // Calculate current wave (1-5) based on remaining time
  let elapsed_time = 600.0 - game_state.game_timer
  let mut new_wave = (elapsed_time / 120.0).to_int() + 1
  if new_wave > 5 {
    new_wave = 5
  }

  // Update wave if changed
  if new_wave != game_state.current_wave {
    game_state.current_wave = new_wave
    game_state.wave_box.content = "Wave: " + game_state.current_wave.to_string()
  }

  // Format timer as MM:SS
  let total_seconds = game_state.game_timer.to_int()
  let minutes = total_seconds / 60
  let seconds = total_seconds % 60
  let seconds_str = if seconds < 10 {
    "0" + seconds.to_string()
  } else {
    seconds.to_string()
  }
  game_state.timer_box.content = "Time: " +
    minutes.to_string() +
    ":" +
    seconds_str
}
