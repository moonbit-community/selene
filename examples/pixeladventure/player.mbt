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
  @sprite.frames_from_atlas(
    "assets/Main Characters/Mask Dude/Idle (32x32).png",
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
    "assets/Main Characters/Mask Dude/Run (32x32).png",
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
    "assets/Main Characters/Mask Dude/Fall (32x32).png",
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
    "assets/Main Characters/Mask Dude/Jump (32x32).png",
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
    "assets/Main Characters/Mask Dude/Hit (32x32).png",
    7,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
  fps=12,
)

///|
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::from_animation(player_idle_animation, 10)
  @sprite.sprites.set(game_state.player, player_sprite)
  @velocity.velocities.set(game_state.player, @math.Vec2D::zero())
  @position.positions.set(game_state.player, pos)
  @collision.shapes.set(
    game_state.player,
    Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
  )
  @collision.collision_layers.set(game_state.player, player_collision_layer)
  @collision.colliders.set(
    game_state.player,
    @collision.Collider::new(
      @collision.CollisionMask::new([
        terrain_collision_layer, enemy_collision_layer,
      ]),
    ),
  )
  @camera.attach_entity(game_state.player, @math.Vec2D(16.0, 16.0))
}

///|
enum PlayerState {
  Idle
  Jump
  Fall
  Hit
} derive(Show)

///|
const GRAVITY = 1800.0

///|
const MAX_RUN_V = 240.0

///|
const JUMP_V = 680.0

///|
const MAX_FALL_V = 900.0

///|
const RUN_ACC = 3600.0

///|
const BUMP_V : Double = JUMP_V / 2.0

///|
fn player_collision_system(_delta : Double) -> Unit {
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
        hurt_player()
      }
    }
  }
}

///|
fn player_state_system(delta : Double) -> Unit {
  let velocity = @collision.real_velocities
    .get(game_state.player)
    .unwrap_or(@math.Vec2D::zero())
  let mut new_velocity_x = velocity.0[X]
  let mut new_velocity_y = velocity.0[Y]
  if !(game_state.player_state is Hit) {
    if @inputs.is_pressed(@inputs.ArrowLeft) {
      new_velocity_x -= RUN_ACC * delta
      if new_velocity_x < -MAX_RUN_V {
        new_velocity_x = -MAX_RUN_V
      }
      game_state.direction = Direction2::Left
    } else if @inputs.is_pressed(@inputs.ArrowRight) {
      new_velocity_x += RUN_ACC * delta
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
      if velocity.0[Y] > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
      if @inputs.is_just_pressed(ArrowUp) &&
        @collision.is_on_floor(game_state.player) {
        new_velocity_y = -JUMP_V
        game_state.player_state = PlayerState::Jump
        if game_state.volume_on {
          @audio.play_audio("assets/sounds/jump.wav")
        }
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
  new_velocity_y += GRAVITY * delta
  if new_velocity_y > MAX_FALL_V {
    new_velocity_y = MAX_FALL_V
  }
  @velocity.velocities[game_state.player] = @math.Vec2D(
    new_velocity_x, new_velocity_y,
  )
}
