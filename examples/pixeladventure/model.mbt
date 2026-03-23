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
const FONT_FAMILY : String = "ThaleahFat"

///|
const FONT_PATH : String = "assets/pixeladventure/Fonts/ThaleahFat.ttf"

///|
const HUD_ZINDEX : Int = 100

///|
const BUTTON_ZINDEX : Int = 110

///|
const PLAYFIELD_LEFT_INSET : Double = 48.0

///|
const PLAYER_Z : Double = 10.0

///|
const ITEM_Z : Double = 20.0

///|
const ATTACK_V : Double = 180.0

///|
const BIRD_SPEED : Double = 90.0

///|
const GRAVITY : Double = 1800.0

///|
const MAX_RUN_V : Double = 240.0

///|
const JUMP_V : Double = 680.0

///|
const MAX_FALL_V : Double = 900.0

///|
const RUN_ACC : Double = 3600.0

///|
const BUMP_V : Double = JUMP_V / 2.0

///|
const HURT_COOLDOWN : Double = 1.0

///|
priv enum Direction2 {
  Left
  Right
}

///|
priv enum PlayerState {
  Idle
  Jump
  Fall
  Hit
}

///|
priv enum GameResult {
  Win
  GameOver
}

///|
priv struct GameSession {
  player : @entity.Entity
  camera : @entity.Entity
  result_box : @entity.Entity
  score_box : @entity.Entity
  health_box : @entity.Entity
  volume_button : @entity.Entity
  mut score : Int
  mut health : Int
  mut volume_on : Bool
  mut result : GameResult?
  world_size : @math.Vec2D
}

///|
priv struct PlayerController {
  mut facing : Direction2
  mut state : PlayerState
  mut hurt_cooldown : Double
  mut pending_bounce_velocity_y : Double?
}

///|
priv struct BirdController {
  mut direction : Direction2
  mut is_hurt : Bool
}

///|
priv struct PixelAdventureWorldStore {
  sessions : Map[@entity.Entity, GameSession]
  players : Map[@entity.Entity, PlayerController]
  birds : Map[@entity.Entity, BirdController]
  apples : Map[@entity.Entity, Unit]
  flags : Map[@entity.Entity, Unit]
  ui_click_reader : @event.EventReader[@ui.UiClickEvent]
}

///|
let pixeladventure_world_stores : Map[UInt, PixelAdventureWorldStore] = Map::new()

///|
fn pixeladventure_world_store() -> PixelAdventureWorldStore {
  let world_id = @ecs.require_current_world().id()
  pixeladventure_world_stores.get_or_init(world_id, () => {
    sessions: Map::new(),
    players: Map::new(),
    birds: Map::new(),
    apples: Map::new(),
    flags: Map::new(),
    ui_click_reader: @event.EventReader::new(),
  })
}

///|
fn reset_pixeladventure_world_store() -> Unit {
  let world_id = @ecs.require_current_world().id()
  pixeladventure_world_stores.remove(world_id)
}

///|
fn sessions() -> Map[@entity.Entity, GameSession] {
  pixeladventure_world_store().sessions
}

///|
fn players() -> Map[@entity.Entity, PlayerController] {
  pixeladventure_world_store().players
}

///|
fn birds() -> Map[@entity.Entity, BirdController] {
  pixeladventure_world_store().birds
}

///|
fn apples() -> Map[@entity.Entity, Unit] {
  pixeladventure_world_store().apples
}

///|
fn flags() -> Map[@entity.Entity, Unit] {
  pixeladventure_world_store().flags
}

///|
fn ui_click_reader() -> @event.EventReader[@ui.UiClickEvent] {
  pixeladventure_world_store().ui_click_reader
}

///|
fn active_session_entity() -> @entity.Entity? {
  for entity, _ in sessions() {
    if entity.is_alive() {
      return Some(entity)
    }
  }
  None
}

///|
fn player_visual_transform(facing : Direction2) -> @math.Transform {
  match facing {
    Left => @math.Transform::flip_x(32.0)
    Right => @math.Transform::new()
  }
}

///|
let jump_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/jump.wav",
)

///|
let coin_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/coin.wav",
)

///|
let hurt_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/hurt.wav",
)

///|
let player_idle_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png",
    11,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_run_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Run (32x32).png",
    12,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_fall_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_jump_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Jump (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Hit (32x32).png",
    7,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
  fps=12,
)

///|
let bird_fly_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Enemies/BlueBird/Flying (32x32).png",
    9,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let bird_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
    5,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
  fps=12,
)

///|
let player_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let terrain_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let enemy_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let trigger_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()
