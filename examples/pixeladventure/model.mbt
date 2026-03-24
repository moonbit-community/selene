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
  Run
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
priv enum PlayerAnimationKey {
  IdleLeft
  IdleRight
  RunLeft
  RunRight
  FallLeft
  FallRight
  JumpLeft
  JumpRight
  HitLeft
  HitRight
} derive(Eq)

///|
priv struct PlayerAnimationNodes {
  idle_left : @animation.AnimationNodeIndex
  idle_right : @animation.AnimationNodeIndex
  run_left : @animation.AnimationNodeIndex
  run_right : @animation.AnimationNodeIndex
  fall_left : @animation.AnimationNodeIndex
  fall_right : @animation.AnimationNodeIndex
  jump_left : @animation.AnimationNodeIndex
  jump_right : @animation.AnimationNodeIndex
  hit_left : @animation.AnimationNodeIndex
  hit_right : @animation.AnimationNodeIndex
}

///|
priv enum BirdAnimationKey {
  FlyLeft
  FlyRight
  HitLeft
  HitRight
} derive(Eq)

///|
priv struct BirdAnimationNodes {
  fly_left : @animation.AnimationNodeIndex
  fly_right : @animation.AnimationNodeIndex
  hit_left : @animation.AnimationNodeIndex
  hit_right : @animation.AnimationNodeIndex
}

///|
priv struct SpriteAnimationDef {
  name : String
  image : @asset.ImageHandle
  layout : @sprite.TextureAtlasLayoutHandle
  fps : Double
  loop_ : Bool
  size : @math.Vec2D
  anchor : @sprite.Anchor
  flip_x : Bool
  flip_y : Bool
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
  animations : PlayerAnimationNodes
  mut active_animation : PlayerAnimationKey?
}

///|
priv struct BirdController {
  mut direction : Direction2
  mut is_hurt : Bool
  animations : BirdAnimationNodes
  mut active_animation : BirdAnimationKey?
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
fn sprite_clip(
  path : String,
  frame_count : Int,
  loop_? : Bool = true,
  fps? : Double = 12.0,
  flip_x? : Bool = false,
) -> SpriteAnimationDef {
  let size = @math.Vec2D(32.0, 32.0)
  {
    name: path,
    image: @asset2.load_image(path),
    layout: @sprite.register_texture_atlas_layout(
      @sprite.TextureAtlasLayout::from_grid(size, frame_count, 1),
    ),
    fps,
    loop_,
    size,
    anchor: @sprite.Anchor(@math.Vec2D(-0.5, 0.5)),
    flip_x,
    flip_y: false,
  }
}

///|
fn sprite_animation_sprite(animation : SpriteAnimationDef) -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(animation.image),
    texture_atlas=Some(@sprite.TextureAtlas::new(animation.layout)),
    custom_size=Some(animation.size),
    anchor=animation.anchor,
    flip_x=animation.flip_x,
    flip_y=animation.flip_y,
  )
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
let volume_on_ui_image : @ui.UiImage = @ui.UiImage::new(
  @math.Vec2D(21.0, 22.0),
  "assets/pixeladventure/Menu/Buttons/Volume.png",
  fit=@ui.ImageFit::Contain,
)

///|
let volume_off_ui_image : @ui.UiImage = @ui.UiImage::new(
  @math.Vec2D(21.0, 22.0),
  "assets/pixeladventure/Menu/Buttons/VolumeOff.png",
  fit=@ui.ImageFit::Contain,
)

///|
let player_idle_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png", 11,
)

///|
let player_idle_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png",
  11,
  flip_x=true,
)

///|
let player_run_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Run (32x32).png", 12,
)

///|
let player_run_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Run (32x32).png",
  12,
  flip_x=true,
)

///|
let player_fall_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png", 1,
)

///|
let player_fall_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
  1,
  flip_x=true,
)

///|
let player_jump_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Jump (32x32).png", 1,
)

///|
let player_jump_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Jump (32x32).png",
  1,
  flip_x=true,
)

///|
let player_hit_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Hit (32x32).png",
  7,
  loop_=false,
)

///|
let player_hit_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Main Characters/Mask Dude/Hit (32x32).png",
  7,
  loop_=false,
  flip_x=true,
)

///|
let bird_fly_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Enemies/BlueBird/Flying (32x32).png",
  9,
  flip_x=true,
)

///|
let bird_fly_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Enemies/BlueBird/Flying (32x32).png", 9,
)

///|
let bird_hit_right_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
  5,
  loop_=false,
  flip_x=true,
)

///|
let bird_hit_left_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
  5,
  loop_=false,
)

///|
let apple_spin_animation : SpriteAnimationDef = sprite_clip(
  "assets/pixeladventure/Items/Fruits/Apple.png", 17,
)

///|
let player_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let terrain_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let enemy_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
let trigger_collision_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()
