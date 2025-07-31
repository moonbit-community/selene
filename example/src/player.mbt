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
let player : @system.Entity = @system.Entity::new()

///|
let player_idle_animation : @sprite.Animation = @sprite.Animation::new(
  "/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
  max_frame=11,
  height=32.0,
  width=32.0,
)

///|
let player_run_animation : @sprite.Animation = @sprite.Animation::new(
  "/pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
  max_frame=12,
  height=32.0,
  width=32.0,
)

///|
let player_fall_animation : @sprite.Animation = @sprite.Animation::new(
  "/pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png",
  max_frame=1,
  height=32.0,
  width=32.0,
)

///|
fn add_player() -> Unit {
  let player_sprite = @sprite.Sprite::new_animation(player_idle_animation, 10)
  @sprite.sprites.set(player, player_sprite)
  @input.controls.set(player, @input.KeyInput::{  })
  @velocity.velocities.set(player, @math.Vec2D::new(0.0, 0.0))
  @position.positions.set(player, @math.Vec2D::new(0.0, 208.0))
  @collision.collides.set(player, @collision.Collide::{
    shape: Rect(width=32.0, height=32.0),
    layer: player_collision_layer,
    mask: player_collision_mask,
  })
  // @acceleration.add_gravity(player, gravity=1.0)
}

///|
enum PlayerState {
  Idle
  Jump
  Fall
  Die
} derive(Show)

///|
let player_state : Ref[PlayerState] = { val: PlayerState::Idle }

///|
const GRAVITY = 0.5

///|
const RUN_V = 4.0

///|
const JUMP_V = 10.0

///|
fn player_state_system(_ : &@system.Backend) -> Unit {
  guard @velocity.velocities.get(player) is Some(velocity)
  if player_state.val is PlayerState::Die {
    return
  }
  let mut new_velocity_x = velocity.x
  let mut new_velocity_y = velocity.y
  if @system.is_pressed(@system.ArrowLeft) {
    new_velocity_x = -RUN_V
  } else if @system.is_pressed(@system.ArrowRight) {
    new_velocity_x = RUN_V
  } else {
    new_velocity_x = 0.0
  }
  match player_state.val {
    Idle => {
      if velocity.x == 0.0 {
        @sprite.play_animation(player, player_idle_animation)
      } else {
        @sprite.play_animation(player, player_run_animation)
      }
      if @system.is_pressed(@system.ArrowUp) &&
        @collision.is_on_the_floor(player) {
        new_velocity_y = -JUMP_V
        player_state.val = PlayerState::Jump
      }
      if velocity.y > 0.0 {
        player_state.val = PlayerState::Fall
      }
    }
    Fall => {
      @sprite.play_animation(player, player_fall_animation)
      if @collision.is_on_the_floor(player) {
        player_state.val = PlayerState::Idle
      }
    }
    Jump => if velocity.y > 0.0 { player_state.val = PlayerState::Fall }
    Die => ()
  }
  new_velocity_y += GRAVITY // Gravity
  @velocity.velocities[player] = @math.Vec2D::new(
    new_velocity_x, new_velocity_y,
  )
}

///|
// fn player_state_system() -> Unit {
// guard @velocity.velocities.get(player) is Some(velocity)
// if player_state.val is PlayerState::Die {
//   return
// }
// let mut new_velocity_x = velocity.x
// let mut new_velocity_y = velocity.y
// if @system.is_pressed(ArrowLeft) {
//   new_velocity_x = -5.0
// } else if @system.is_pressed(ArrowRight) {
//   new_velocity_x = 5.0
// } else {
//   new_velocity_x = 0.0
// }
// match player_state.val {
//   Idle => ...
//   Fall => ...
//   Jump => ...
//   Die => ...
// }
// if @system.is_pressed(ArrowUp) {
//   new_velocity_y = -5.0
// } else if @system.is_pressed(ArrowDown) {
//   new_velocity_y = 5.0
// } else {
//   new_velocity_y = 0.0
// }
//   @velocity.velocities.set(
//     player,
//     @math.Vec2D::new(new_velocity_x, new_velocity_y),
//   )
// }
