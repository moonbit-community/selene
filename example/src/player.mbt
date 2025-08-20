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
  @sprite.frames_from_altas(
    "pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
    11,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
)

///|
let player_run_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_altas(
    "pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
    12,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
)

///|
let player_fall_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_altas(
    "pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
)

///|
let player_jump_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_altas(
    "pixel_adventure/Main Characters/Mask Dude/Jump (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
)

///|
let player_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_altas(
    "pixel_adventure/Main Characters/Mask Dude/Hit (32x32).png",
    7,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
)

///|
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::new_animation(player_idle_animation, 10)
  @sprite.sprites.set(game_state.player, player_sprite)
  @velocity.velocities.set(game_state.player, @math.Vec2D::zero())
  @position.positions.set(game_state.player, pos)
  @collision.collides.set(game_state.player, @collision.Collide::{
    shape: Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
    layer: player_collision_layer,
    mask: player_collision_mask,
  })
  @camera.camera.attached_entity = Some(game_state.player)
  @camera.camera.offset = @math.Vec2D(16.0, 16.0)
}

///|
enum PlayerState {
  Idle
  Jump
  Fall
  Hit
} derive(Show)

///|
const GRAVITY = 0.5

///|
const MAX_RUN_V = 4.0

///|
const JUMP_V = 11.5

///|
const MAX_FALL_V = 15.5

///|
const RUN_ACC = 1.0

///|
const BUMP_V : Double = JUMP_V / 2.0

///|
fn player_collision_system(backend : &@system.Backend) -> Unit {
  if game_state.hurt_timer > 0.0 {
    game_state.hurt_timer -= 1.0
  }
  let player_collisions = @collision.get_collision_infos(game_state.player)
  for collision in player_collisions {
    if birds.get(collision.entity) is Some(bird) {
      if collision.direction[Y] > 0.0 {
        bird.is_hurt = true
        guard @velocity.velocities.get(game_state.player) is Some(velocity)
        @velocity.velocities[game_state.player] = velocity.0.update(Y, -BUMP_V)
      } else {
        hurt_player(backend)
      }
    }
  }
}

///|
fn player_state_system(backend : &@system.Backend) -> Unit {
  guard @velocity.velocities.get(game_state.player) is Some(velocity)
  let mut new_velocity_x = velocity.0[X]
  let mut new_velocity_y = velocity.0[Y]
  if !(game_state.player_state is Hit) {
    if @system.is_pressed(@system.ArrowLeft) {
      new_velocity_x -= RUN_ACC
      if new_velocity_x < -MAX_RUN_V {
        new_velocity_x = -MAX_RUN_V
      }
      game_state.direction = Direction2::Left
    } else if @system.is_pressed(@system.ArrowRight) {
      new_velocity_x += RUN_ACC
      if new_velocity_x > MAX_RUN_V {
        new_velocity_x = MAX_RUN_V
      }
      game_state.direction = Direction2::Right
    } else {
      new_velocity_x = 0.0
    }
  }
  let transform = match game_state.direction {
    Direction2::Left => @math.Transform::flip_x(32.0)
    Direction2::Right => @math.Transform::new()
  }
  match game_state.player_state {
    Idle => {
      if velocity.0[X] == 0.0 {
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
        @collision.is_on_floor(game_state.player) {
        new_velocity_y = -JUMP_V
        game_state.player_state = PlayerState::Jump
        if game_state.volume_on {
          @audio.play_audio(backend, "sounds/jump.wav")
        }
      }
      if velocity.0[Y] > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
    }
    Fall => {
      @sprite.play_animation(
        game_state.player,
        player_fall_animation,
        transform~,
      )
      if @collision.is_on_floor(game_state.player) {
        game_state.player_state = PlayerState::Idle
      }
    }
    Jump => {
      @sprite.play_animation(
        game_state.player,
        player_jump_animation,
        transform~,
      )
      if velocity.0[Y] > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
    }
    Hit => {
      @sprite.play_animation(
        game_state.player,
        player_hit_animation,
        transform~,
      )
      if @collision.is_on_floor(game_state.player) {
        new_velocity_x = 0.0
      }
      if @sprite.is_animation_finished(game_state.player) {
        if @collision.is_on_floor(game_state.player) {
          game_state.player_state = PlayerState::Idle
        } else if velocity.0[Y] < 0.0 {
          game_state.player_state = PlayerState::Fall
        } else {
          game_state.player_state = PlayerState::Jump
        }
      }
    }
  }
  new_velocity_y += GRAVITY
  if new_velocity_y > MAX_FALL_V {
    new_velocity_y = MAX_FALL_V
  }
  @velocity.velocities[game_state.player] = @math.Vec2D(
    new_velocity_x, new_velocity_y,
  )
}
