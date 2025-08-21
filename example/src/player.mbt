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
let player_idle_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
  loop_=true,
  max_frame=11,
  height=32.0,
  width=32.0,
)

///|
let player_run_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
  loop_=true,
  max_frame=12,
  height=32.0,
  width=32.0,
)

///|
let player_fall_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png",
  loop_=true,
  max_frame=1,
  height=32.0,
  width=32.0,
)

///|
let player_jump_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Jump (32x32).png",
  loop_=true,
  max_frame=1,
  height=32.0,
  width=32.0,
)

///|
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::new_animation(player_idle_animation, 10)
  @sprite.sprites.set(game_state.player, player_sprite)
  @velocity.velocities.set(game_state.player, @math.Vec2D::zero())
  @position.positions.set(game_state.player, pos)
  @collision.collides.set(game_state.player, @collision.Collide::{
    shape: Rect(size=@math.Vec2D::new(32.0, 32.0), offset=@math.Vec2D::zero()),
    layer: player_collision_layer,
    mask: player_collision_mask,
  })
  @camera.camera.attached_entity = Some(game_state.player)
  @camera.camera.offset.x = 16.0
  @camera.camera.offset.y = 16.0
}

///|
enum PlayerState {
  Idle
  Jump
  Fall
} derive(Show)

///|
const GRAVITY = 0.5

///|
const RUN_V = 4.0

///|
const JUMP_V = 11.5

///|
const MAX_FALL_V = 15.5

///|
fn player_state_system(backend : &@system.Backend) -> Unit {
  guard @velocity.velocities.get(game_state.player) is Some(velocity)
  let mut new_velocity_x = velocity.x
  let mut new_velocity_y = velocity.y
  if @system.is_pressed(@system.ArrowLeft) {
    new_velocity_x = -RUN_V
    game_state.direction = Direction2::Left
  } else if @system.is_pressed(@system.ArrowRight) {
    new_velocity_x = RUN_V
    game_state.direction = Direction2::Right
  } else {
    new_velocity_x = 0.0
  }
  let transform = Some(
    match game_state.direction {
      Direction2::Left => @math.Transform::flip_x(32.0)
      Direction2::Right => @math.Transform::new()
    },
  )
  match game_state.player_state {
    Idle => {
      if velocity.x == 0.0 {
        @sprite.play_animation(
          game_state.player,
          player_idle_animation,
          transform~,
        )
      } else {
        @sprite.play_animation(
          game_state.player,
          player_run_animation,
          transform~,
        )
      }
      if @system.is_just_pressed(@system.ArrowUp) &&
        @collision.is_on_the_floor(game_state.player) {
        new_velocity_y = -JUMP_V
        game_state.player_state = PlayerState::Jump
        if game_state.volume_on {
          @audio.play_audio(backend, "sounds/jump.wav")
        }
      }
      if velocity.y > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
    }
    Fall => {
      @sprite.play_animation(
        game_state.player,
        player_fall_animation,
        transform~,
      )
      if @collision.is_on_the_floor(game_state.player) {
        game_state.player_state = PlayerState::Idle
      }
    }
    Jump => {
      @sprite.play_animation(
        game_state.player,
        player_jump_animation,
        transform~,
      )
      if velocity.y > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
    }
  }
  new_velocity_y += GRAVITY
  if new_velocity_y > MAX_FALL_V {
    new_velocity_y = MAX_FALL_V
  }
  @velocity.velocities[game_state.player] = @math.Vec2D::new(
    new_velocity_x, new_velocity_y,
  )
}
