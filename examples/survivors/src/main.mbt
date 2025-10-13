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
  player_entity : @entity.Entity
  mut player_direction : Dir4
  rand : @random.Rand
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
  player_stats : PlayerStats
  level_up_panel : LevelUpPanel
}

///|
enum Dir4 {
  Up
  Down
  Left
  Right
}

///|
enum PowerupType {
  Attack
  Range
  Speed
  Cooldown
} derive(Eq)

///|
struct PlayerStats {
  mut attack : Double
  mut range : Double
  mut speed : Double
  mut attack_speed : Double
  mut unlocked_weapons : Array[WeaponType]
}

///|
struct Powerup {
  powerup_type : PowerupType
  name : String
}

///|
struct LevelUpPanel {
  panel_entity : @entity.Entity
  mut available_powerups : Array[Powerup]
  // Child entities will be created dynamically with spawn_child
}

///|
let game_state : GameState = {
  player_entity: @entity.Entity::new(),
  player_direction: Down,
  rand: @random.Rand::new(),
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
  player_stats: {
    attack: 1.0,
    range: 0.0,  // Base range, weapons add to this
    speed: PLAYER_SPEED,
    attack_speed: 1.0,
    unlocked_weapons: [Pistol],  // Start with only Pistol
  },
  level_up_panel: {
    panel_entity: @style.add_widget(
      @style.screen_root,
      h_offset=VIEWPORT_WIDTH / 2.0 - 80,
      v_offset=VIEWPORT_HEIGHT / 2.0 - 120,
      flex=Vertical,
      v_padding=20.0,
      sprite=zindex => @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(
          Vec2D(160.0, 250.0),
          "rgba(13, 170, 26, 1)",
          stroke_color="black",
        ),
        zindex,
      ),
    ),
    available_powerups: [],
  },
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

    // Check for weapon unlocks every 5 levels
    check_weapon_unlocks(new_level)

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
fn check_weapon_unlocks(level : Int) -> Unit {
  // Unlock Minigun at level 6 (every 5 levels after level 1)
  if level == 6 && not(game_state.player_stats.unlocked_weapons.contains(Minigun)) {
    game_state.player_stats.unlocked_weapons = [Pistol, Minigun]
    // TODO: Show weapon unlock notification
  }
}

///|
fn create_powerup(powerup_type : PowerupType) -> Powerup {
  match powerup_type {
    Attack => { powerup_type: Attack, name: "Attack +0.2" }
    Range => { powerup_type: Range, name: "Range +16" }
    Speed => { powerup_type: Speed, name: "Speed +15" }
    Cooldown => { powerup_type: Cooldown, name: "Attack Speed +10%" }
  }
}

///|
fn generate_random_powerups() -> Array[Powerup] {
  let all_types = [Attack, Range, Speed, Cooldown]
  let selected = []
  let available_types = []

  // Copy all types to available list
  for powerup_type in all_types {
    available_types.push(powerup_type)
  }

  // Select 3 unique random powerups
  for _i = 0; _i < 3; _i = _i + 1 {
    if available_types.length() == 0 {
      break
    }
    let rand_index = game_state.rand.int(limit=available_types.length())
    let powerup_type = available_types[rand_index]
    selected.push(create_powerup(powerup_type))
    // Remove the selected type to avoid duplicates
    available_types.remove(rand_index) |> ignore
  }
  selected
}

///|
fn apply_powerup(powerup : Powerup) -> Unit {
  match powerup.powerup_type {
    Attack => game_state.player_stats.attack += 0.2
    Range => game_state.player_stats.range += 16.0
    Speed => game_state.player_stats.speed += 15.0
    Cooldown => game_state.player_stats.attack_speed += 0.1
  }
}

///|
fn get_powerup_icon(powerup_type : PowerupType) -> @sprite.Animation {
  match powerup_type {
    Attack => powerup_attack_icon
    Range => powerup_range_icon
    Speed => powerup_speed_icon
    Cooldown => powerup_cooldown_icon
  }
}

///|
fn game_start(_delta : Double) -> Unit {
  @backend.load_font("ThaleahFat", "assets/fonts/ThaleahFat.ttf")
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
///powerup_cooldown_icon
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
