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
const MAP_HEIGHT : Double = 640.0

///|
const MAP_WIDTH : Double = 640.0

///|
const FPS : Double = 60

///|
pub fn run() -> Unit {
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(FPS.to_uint())
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_systems(Startup, [game_start, spawn_enemy_system])
  .add_systems(Update, [
    player_update_system, player_shooting_system, enemy_ai_system, enemy_collision_system,
    devil_shooting_system, player_bullet_trigger_system, check_victory_system, game_timer_system,
    score_blink_system,
  ])
  .add_system(Update, survivors_camera_follow_system)
  .add_system(PostUpdate, survivors_ui_pointer_system)
  .run()
}

///|
priv struct GameState {
  player_entity : @ecs.Entity
  camera_entity : @ecs.Entity
  mut player_direction : Dir4
  rand : @random.Rand
  mut score : Int32
  score_box : @ecs.Entity
  mut invincible : Bool
  mut game_timer : Double
  mut game_over : Bool
  timer_box : @ecs.Entity
  game_over_box : @ecs.Entity
  mut game_over_displayed : Bool
  mut current_wave : Int32
  wave_box : @ecs.Entity
  mut exp : Int32
  exp_box : @ecs.Entity
  mut player_level : Int32
  level_box : @ecs.Entity
  player_stats : PlayerStats
  level_up_panel : LevelUpPanel
  pending_level_ups : Array[Int32] // Queue of pending level-ups
  mut score_blink_timer : Double // Timer for blinking effect
  mut score_is_red : Bool // Track current color state
  game_over_panel : GameOverPanel
}

///|
priv enum Dir4 {
  Up
  Down
  Left
  Right
}

///|
priv enum LevelUpSelection {
  PowerupSelection(Powerup)
  WeaponSelection(WeaponType)
}

///|
priv struct PlayerStats {
  mut attack : Double
  mut range : Double
  mut speed : Double
  mut attack_speed : Double
  mut penetration : Int32
  weapon_instances : Array[WeaponType] // Can have multiple of same type
}

///|
priv struct LevelUpPanel {
  panel_entity : @ecs.Entity
  mut available_selections : Array[LevelUpSelection]
  // Child entities will be created dynamically with spawn_child
}

///|
priv struct GameOverPanel {
  panel_entity : @ecs.Entity
}

///|
fn create_level_up_panel_entity() -> @ecs.Entity {
  let panel = spawn_survivors_entity()
  @ui.nodes().set(
    panel,
    @ui.Node::absolute(
      Vec2(VIEWPORT_WIDTH / 2.0 - 80.0, VIEWPORT_HEIGHT / 2.0 - 120.0),
      size=Vec2(160.0, 250.0),
    ),
  )
  @ui.z_indexes().set(panel, ZIndex(HUD_ZINDEX + 10))
  @ui.background_colors().set(
    panel,
    @ui.BackgroundColor::from_css("rgba(13, 170, 26, 1)"),
  )
  @ui.border_colors().set(panel, @ui.BorderColor::from_css("black"))
  panel
}

///|
fn create_game_over_panel_entity() -> @ecs.Entity {
  let panel = spawn_survivors_entity()
  @ui.nodes().set(
    panel,
    @ui.Node::absolute(
      Vec2(VIEWPORT_WIDTH / 2.0 - 100.0, VIEWPORT_HEIGHT / 2.0 - 60.0),
      size=Vec2(200.0, 120.0),
    ),
  )
  @ui.z_indexes().set(panel, ZIndex(HUD_ZINDEX + 10))
  @ui.background_colors().set(
    panel,
    @ui.BackgroundColor::from_css("rgba(0, 0, 0, 0.8)"),
  )
  @ui.border_colors().set(panel, @ui.BorderColor::from_css("white"))
  panel
}

///|
#selene.resource
priv struct SurvivorsRuntime {
  entities : Array[@ecs.Entity]
  mut game : GameState?
  weapon_timers : Array[Double]
  enemy_bullets : Set[@ecs.Entity]
  ui_click_reader : @event.EventReader[@ui.UiClickEvent]
  enemy_contact_event_reader : @event.EventReader[@physics2d.ContactEvent]
  enemy_trigger_event_reader : @event.EventReader[@physics2d.TriggerEvent]
  player_bullet_trigger_event_reader : @event.EventReader[
    @physics2d.TriggerEvent,
  ]
  levelup_buttons : Array[@ecs.Entity]
  levelup_button_icons : Array[@ecs.Entity]
  mut levelup_title : @ecs.Entity?
  mut game_over_title : @ecs.Entity?
  mut restart_button : @ecs.Entity?
  timers : Map[Int32, @system.TimerHandle]
  mut next_timer : Int32
}

///|
fn new_survivors_runtime() -> SurvivorsRuntime {
  {
    entities: [],
    game: None,
    weapon_timers: [],
    enemy_bullets: Set([]),
    ui_click_reader: EventReader(),
    enemy_contact_event_reader: EventReader(),
    enemy_trigger_event_reader: EventReader(),
    player_bullet_trigger_event_reader: EventReader(),
    levelup_buttons: [],
    levelup_button_icons: [],
    levelup_title: None,
    game_over_title: None,
    restart_button: None,
    timers: Map([]),
    next_timer: 0,
  }
}

///|
fn survivors_runtime() -> SurvivorsRuntime {
  @ecs.require_current_world().resource()
}

///|
fn spawn_survivors_entity() -> @ecs.Entity {
  let entity = @ecs.Entity()
  survivors_runtime().entities.push(entity)
  entity
}

///|
fn survivors_timeout(delay : Double, callback : () -> Unit) -> Unit {
  let runtime = survivors_runtime()
  let id = runtime.next_timer
  runtime.next_timer += 1
  runtime.timers.set(
    id,
    @system.timeout(delay, () => {
      runtime.timers.remove(id)
      callback()
    }),
  )
}

///|
fn reset_survivors_runtime() -> Unit {
  let world = @ecs.require_current_world()
  let previous : SurvivorsRuntime? = world.get_resource()
  if previous is Some(runtime) {
    for _, timer in runtime.timers {
      ignore(timer.cancel())
    }
    for entity in runtime.entities {
      ignore(entity.delete())
    }
  }
  world.insert_resource(new_survivors_runtime())
  reset_wave_state()
}

///|
fn game_state() -> GameState {
  let runtime = survivors_runtime()
  if runtime.game is Some(state) {
    return state
  }
  let state = new_game_state()
  runtime.game = Some(state)
  state
}

///|
fn new_game_state() -> GameState {
  {
    player_entity: spawn_survivors_entity(),
    camera_entity: spawn_survivors_entity(),
    player_direction: Down,
    rand: Rand(),
    score: 0,
    score_box: spawn_survivors_entity(),
    invincible: false,
    game_timer: 600.0,
    game_over: false,
    timer_box: spawn_survivors_entity(),
    game_over_box: spawn_survivors_entity(),
    game_over_displayed: false,
    current_wave: 1,
    wave_box: spawn_survivors_entity(),
    exp: 0,
    exp_box: spawn_survivors_entity(),
    player_level: 1,
    level_box: spawn_survivors_entity(),
    player_stats: {
      attack: 0.0,
      range: 0.0, // Base range, weapons add to this
      speed: PLAYER_SPEED,
      attack_speed: 1.0,
      penetration: 0,
      weapon_instances: [Pistol], // Start with one Pistol
    },
    level_up_panel: {
      panel_entity: create_level_up_panel_entity(),
      available_selections: [],
    },
    pending_level_ups: [],
    score_blink_timer: 0.0,
    score_is_red: false,
    game_over_panel: { panel_entity: create_game_over_panel_entity(), },
  }
}

///|
fn set_score(score : Int32) -> Unit {
  let game = game_state()
  game.score = score
  set_ui_text(game.score_box, "Score: " + game.score.to_string())
}

///|
fn xp_required_for_level(n : Int32) -> Int32 {
  n * (2 * n * n + 21 * n + 73) / 6
}

///|
fn get_level_from_xp(xp : Int32) -> Int32 {
  let mut level = 1
  while xp >= xp_required_for_level(level) {
    level += 1
  }
  level
}

///|
fn add_exp(exp_gained : Int32) -> Unit {
  let game = game_state()
  let old_level = game.player_level
  game.exp += exp_gained

  // Calculate new player level using the XP formula
  let new_level = get_level_from_xp(game.exp)
  if new_level > old_level {
    // Queue all levels from new_level down to old_level+1 (reverse order for pop())
    let mut level = new_level
    while level > old_level {
      game.pending_level_ups.push(level)
      level -= 1
    }

    // Update player level immediately
    game.player_level = new_level
    set_ui_text(game.level_box, "Level: " + game.player_level.to_string())

    // Process the first level-up in the queue
    process_next_level_up()
  }

  // Update EXP display with progress to next level
  let current_level_xp = if game.player_level == 1 {
    0
  } else {
    xp_required_for_level(game.player_level - 1)
  }
  let next_level_xp = xp_required_for_level(game.player_level)
  let progress_xp = game.exp - current_level_xp
  let needed_xp = next_level_xp - current_level_xp
  set_ui_text(
    game.exp_box,
    "EXP: " + progress_xp.to_string() + "/" + needed_xp.to_string(),
  )
}

///|
fn process_next_level_up() -> Unit {
  if game_state().pending_level_ups.pop() is Some(level) {
    level_up(level)
  }
}

///|
fn add_weapon(weapon_type : WeaponType) -> Unit {
  let game = game_state()
  // Add weapon instance (allows duplicates)
  game.player_stats.weapon_instances.push(weapon_type)

  // Apply weapon's speed modifier
  let speed_modifier = get_weapon_speed_modifier(weapon_type)
  game.player_stats.speed += speed_modifier

  // Apply weapon's attack speed modifier
  let attack_speed_modifier = get_weapon_attack_speed_modifier(weapon_type)
  game.player_stats.attack_speed += attack_speed_modifier
}

///|
fn[T] weighted_random_selection(
  items : Array[T],
  weights : Array[Double],
) -> T? {
  if items.length() == 0 || items.length() != weights.length() {
    return None
  }

  // Calculate total weight
  let mut total_weight = 0.0
  for weight in weights {
    total_weight += weight
  }
  if total_weight <= 0.0 {
    return None
  }

  // Generate random value
  let random_value = game_state().rand.double() * total_weight

  // Select item based on weight
  let mut cumulative = 0.0
  for i in 0..<items.length() {
    cumulative += weights[i]
    if random_value <= cumulative {
      return Some(items[i])
    }
  }

  // Fallback (should not reach here)
  Some(items[items.length() - 1])
}

///|
fn generate_level_up_selections(level : Int32) -> Array[LevelUpSelection] {
  // For levels 5, 10, 15, etc., offer 2 powerups + 1 weapon
  if level % 5 == 0 {
    return generate_mixed_selections(level)
  } else {
    return generate_powerup_selections(level)
  }
}

///|
fn generate_mixed_selections(level : Int32) -> Array[LevelUpSelection] {
  let selected = []

  // Add 2 weighted random powerups
  for _i in 0..<2 {
    match select_weighted_powerup(level, selected) {
      Some(powerup) => selected.push(PowerupSelection(powerup))
      None => ()
    }
  }

  // Add 1 weighted random weapon
  match select_weighted_weapon(level) {
    Some(weapon) => selected.push(WeaponSelection(weapon))
    None => ()
  }
  selected
}

///|
fn generate_powerup_selections(level : Int32) -> Array[LevelUpSelection] {
  let selected = []

  // Add 3 weighted random powerups
  for _i in 0..<3 {
    match select_weighted_powerup(level, selected) {
      Some(powerup) => selected.push(PowerupSelection(powerup))
      None => ()
    }
  }
  selected
}

///|
fn select_weighted_powerup(
  level : Int32,
  already_selected : Array[LevelUpSelection],
) -> Powerup? {
  let all_powerup_types = [
    AttackLv1,
    AttackLv2,
    AttackLv3,
    RangeLv1,
    RangeLv2,
    SpeedLv1,
    SpeedLv2,
    CooldownLv1,
    CooldownLv2,
    Bandana,
  ]

  // Filter out already selected powerup types
  let selected_types = []
  for selection in already_selected {
    match selection {
      PowerupSelection(powerup) => selected_types.push(powerup.powerup_type)
      _ => ()
    }
  }
  let available_types = []
  let available_weights = []
  for powerup_type in all_powerup_types {
    // Check if not already selected
    let mut already_has = false
    for selected_type in selected_types {
      if powerup_type == selected_type {
        already_has = true
        break
      }
    }
    if !already_has {
      let powerup = create_powerup(powerup_type)
      let weight = (powerup.weight_formula)(level)
      if weight > 0.0 {
        available_types.push(powerup_type)
        available_weights.push(weight)
      }
    }
  }

  // Weighted random selection
  match weighted_random_selection(available_types, available_weights) {
    Some(powerup_type) => Some(create_powerup(powerup_type))
    None => None
  }
}

///|
fn select_weighted_weapon(level : Int32) -> WeaponType? {
  let all_weapons = [Pistol, Minigun, SniperRifle, Sword]
  let weights = []
  for weapon_type in all_weapons {
    weights.push(get_weapon_weight(weapon_type, level))
  }
  weighted_random_selection(all_weapons, weights)
}

///|
fn apply_selection(selection : LevelUpSelection) -> Unit {
  match selection {
    PowerupSelection(powerup) => apply_powerup(powerup)
    WeaponSelection(weapon_type) => add_weapon(weapon_type)
  }
}

///|
fn game_start(_world : @ecs.World) -> Unit {
  reset_survivors_runtime()
  @time.initialize(@ecs.require_current_world())
  @time.set_scale(1.0)
  ignore(
    @asset.load_font(
      "assets/survivors/fonts/ThaleahFat.ttf",
      family="ThaleahFat",
    ),
  )
  @ui.set_ui_scale_mode(Viewport)
  configure_survivors_input()
  add_player()
  setup_survivors_camera()
  add_border(Vec2(MAP_WIDTH, MAP_HEIGHT))
  add_background(Vec2(MAP_WIDTH, MAP_HEIGHT))
  add_grass()
  add_score_box()
  add_timer_box()
  add_wave_box()
  add_level_box()
  add_exp_box()
  setup_level_up_ui()
  setup_game_over_ui()
}

///|
fn setup_survivors_camera() -> Unit {
  let game = game_state()
  @camera.cameras().set(game.camera_entity, Camera())
  @camera.camera2ds().set(game.camera_entity, Camera2d())
  @camera.orthographic_projections().set(
    game.camera_entity,
    OrthographicProjection(),
  )
  survivors_camera_follow_system(@ecs.require_current_world())
}

///|
fn survivors_camera_follow_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  guard @transform.transforms().get(game.player_entity)
    is Some(player_transform) else {
    return
  }
  let half_width = VIEWPORT_WIDTH * 0.5
  let half_height = VIEWPORT_HEIGHT * 0.5
  let target_x = player_transform.translation.x
  let target_y = player_transform.translation.y
  let center_x = if MAP_WIDTH <= VIEWPORT_WIDTH {
    MAP_WIDTH * 0.5
  } else if target_x < half_width {
    half_width
  } else if target_x > MAP_WIDTH - half_width {
    MAP_WIDTH - half_width
  } else {
    target_x
  }
  let center_y = if MAP_HEIGHT <= VIEWPORT_HEIGHT {
    MAP_HEIGHT * 0.5
  } else if target_y < half_height {
    half_height
  } else if target_y > MAP_HEIGHT - half_height {
    MAP_HEIGHT - half_height
  } else {
    target_y
  }
  @transform.transforms().set(
    game.camera_entity,
    @transform.Transform::from_xyz(center_x, center_y, 0.0),
  )
}

///|
///powerup_cooldown_icon
fn game_timer_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  let delta = @time.delta()
  if game.game_over {
    if !game.game_over_displayed {
      game.game_over_displayed = true
      set_ui_text(game.game_over_box, "Final Score: " + game.score.to_string())
      add_game_over_box()
    }
    return
  }

  // Continue counting down timer, but don't end game when it reaches 0
  if game.game_timer > 0.0 {
    game.game_timer -= delta
    if game.game_timer < 0.0 {
      game.game_timer = 0.0
    }
  }

  // Calculate current wave (1-10) based on remaining time
  let elapsed_time = 600.0 - game.game_timer
  let mut new_wave = (elapsed_time / 60.0).to_int() + 1
  if new_wave > 10 {
    new_wave = 10
  }

  // Update wave if changed
  if new_wave != game.current_wave {
    game.current_wave = new_wave
    set_ui_text(game.wave_box, "Wave: " + game.current_wave.to_string())
    reset_wave_state() // Reset spawn counters for new wave
  }

  // Format timer as MM:SS
  let total_seconds = game.game_timer.to_int()
  let minutes = total_seconds / 60
  let seconds = total_seconds % 60
  let seconds_str = if seconds < 10 {
    "0" + seconds.to_string()
  } else {
    seconds.to_string()
  }
  set_ui_text(
    game.timer_box,
    "Time: " + minutes.to_string() + ":" + seconds_str,
  )
}

///|
fn score_blink_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  let delta = @time.delta()
  if game.score_blink_timer > 0.0 {
    game.score_blink_timer -= delta

    // Toggle color every 0.1 seconds (100ms)
    let blink_interval = 0.1
    let elapsed = 1.0 - game.score_blink_timer
    let should_be_red = (elapsed / blink_interval).to_int() % 2 == 0
    if should_be_red != game.score_is_red {
      game.score_is_red = should_be_red
      set_ui_text_color(
        game.score_box,
        if should_be_red {
          "red"
        } else {
          "white"
        },
      )
    }

    // Reset to white when timer expires
    if game.score_blink_timer <= 0.0 {
      game.score_blink_timer = 0.0
      game.score_is_red = false
      set_ui_text_color(game.score_box, "white")
    }
  }
}

///|
fn trigger_damage_effect() -> Unit {
  let game = game_state()
  game.score_blink_timer = 1.0
  game.score_is_red = true
  set_ui_text_color(game.score_box, "red")
}

///|
fn restart_game() -> Unit {
  let world = @ecs.require_current_world()
  game_start(world)
  spawn_enemy_system(world)
}
