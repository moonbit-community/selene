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
const HUD_ZINDEX : Int32 = 100

///|
const BUTTON_ZINDEX : Int32 = 110

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
#derive(Eq)
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
}

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
#derive(Eq)
priv enum BirdAnimationKey {
  FlyLeft
  FlyRight
  HitLeft
  HitRight
}

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
  size : @math.Vec2
  anchor : @sprite.Anchor
  flip_x : Bool
  flip_y : Bool
}

///|
#selene.resource
priv struct GameSession {
  player : @ecs.Entity
  camera : @ecs.Entity
  result_box : @ecs.Entity
  score_box : @ecs.Entity
  health_box : @ecs.Entity
  volume_button : @ecs.Entity
  mut score : Int32
  mut health : Int32
  mut volume_on : Bool
  mut result : GameResult?
  world_size : @math.Vec2
}

///|
#selene.component
priv struct PlayerController {
  mut facing : Direction2
  mut state : PlayerState
  mut hurt_cooldown : Double
  mut pending_bounce_velocity_y : Double?
  mut move_direction : Direction2?
  mut jump_requested : Bool
  animations : PlayerAnimationNodes
  mut active_animation : PlayerAnimationKey?
}

///|
#selene.component
priv struct BirdController {
  mut direction : Direction2
  mut is_hurt : Bool
  animations : BirdAnimationNodes
  mut active_animation : BirdAnimationKey?
}

///|
#selene.component
priv struct AppleTag {}

///|
#selene.component
priv struct FlagTag {}

///|
#selene.resource
priv struct PixelAdventureWorldState {
  entities : Array[@ecs.Entity]
  click_reader : @event.EventReader[@ui.UiClickEvent]
}

///|
fn PixelAdventureWorldState::PixelAdventureWorldState() -> PixelAdventureWorldState {
  { entities: [], click_reader: EventReader(), }
}

///|
fn pixeladventure_world_state() -> PixelAdventureWorldState {
  @ecs.require_current_world().resource()
}

///|
fn[T : @ecs.Bundle] spawn_game_entity(values : T) -> @ecs.Entity {
  let entity = @ecs.commands(@ecs.require_current_world()).spawn(values)
  pixeladventure_world_state().entities.push(entity)
  entity
}

///|
fn reset_pixeladventure_world_store() -> Unit {
  let world = @ecs.require_current_world()
  let previous : PixelAdventureWorldState? = world.get_resource()
  if previous is Some(state) {
    for entity in state.entities {
      @ecs.commands(@ecs.require_current_world()).delete(entity)
    }
  }
  world.insert_resource(PixelAdventureWorldState())
}

///|
fn SpriteAnimationDef::SpriteAnimationDef(
  image : @asset.ImageHandle,
  frame_count : Int32,
  loop_~ : Bool = true,
  fps~ : Double = 12.0,
  flip_x~ : Bool = false,
  size~ : @math.Vec2 = Vec2(32.0, 32.0),
  anchor~ : @sprite.Anchor = Anchor(Vec2(-0.5, 0.5)),
) -> SpriteAnimationDef {
  {
    name: "sprite-\{image.id()}",
    image,
    layout: @sprite.register_texture_atlas_layout(
      @sprite.TextureAtlasLayout::from_grid(size, frame_count, 1),
    ),
    fps,
    loop_,
    size,
    anchor,
    flip_x,
    flip_y: false,
  }
}

///|
fn sprite_animation_sprite(animation : SpriteAnimationDef) -> @sprite.Sprite {
  Sprite(
    image=Some(animation.image),
    texture_atlas=Some(TextureAtlas(animation.layout)),
    custom_size=Some(animation.size),
    anchor=animation.anchor,
    flip_x=animation.flip_x,
    flip_y=animation.flip_y,
  )
}

///|
fn volume_on_ui_image() -> @ui.UiImage {
  @ui.UiImage::from_image(Vec2(21.0, 22.0), volume_on_image, fit=Contain)
}

///|
fn volume_off_ui_image() -> @ui.UiImage {
  @ui.UiImage::from_image(Vec2(21.0, 22.0), volumeoff_image, fit=Contain)
}

///|
let player_idle_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_idle_image, 11,
)

///|
let player_idle_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_idle_image,
  11,
  flip_x=true,
)

///|
let player_run_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_run_image, 12,
)

///|
let player_run_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_run_image,
  12,
  flip_x=true,
)

///|
let player_fall_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_fall_image, 1,
)

///|
let player_fall_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_fall_image,
  1,
  flip_x=true,
)

///|
let player_jump_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_jump_image, 1,
)

///|
let player_jump_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_jump_image,
  1,
  flip_x=true,
)

///|
let player_hit_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_hit_image,
  7,
  loop_=false,
)

///|
let player_hit_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  player_hit_image,
  7,
  loop_=false,
  flip_x=true,
)

///|
let bird_fly_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  bird_flying_image,
  9,
  flip_x=true,
)

///|
let bird_fly_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  bird_flying_image, 9,
)

///|
let bird_hit_right_animation : SpriteAnimationDef = SpriteAnimationDef(
  bird_hit_image,
  5,
  loop_=false,
  flip_x=true,
)

///|
let bird_hit_left_animation : SpriteAnimationDef = SpriteAnimationDef(
  bird_hit_image,
  5,
  loop_=false,
)

///|
let apple_spin_animation : SpriteAnimationDef = SpriteAnimationDef(
  apple_image, 17,
)

///|
let flag_idle_animation : SpriteAnimationDef = SpriteAnimationDef(
  flag_idle_image,
  10,
  size=Vec2(64.0, 64.0),
)

///|
let player_collision_group : @physics2d.CollisionGroup = CollisionGroup()

///|
let terrain_collision_group : @physics2d.CollisionGroup = CollisionGroup()

///|
let enemy_collision_group : @physics2d.CollisionGroup = CollisionGroup()

///|
let trigger_collision_group : @physics2d.CollisionGroup = CollisionGroup()

///|
priv struct UiClicks {
  events : @event.EventReaderView[@ui.UiClickEvent]
}

///|
impl @ecs.SystemParam for UiClicks with fn prepare(_world) {
  world => {
    let runtime : PixelAdventureWorldState = world.resource()
    { events: runtime.click_reader.bind(world, @ui.click_event_bus), }
  }
}
