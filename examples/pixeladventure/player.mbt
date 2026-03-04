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
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::from_animation(player_idle_animation, 10)
  @sprite.sprites.set(game_state.player, player_sprite)
  @physics2d.linear_velocities.set(game_state.player, @math.Vec2D::zero())
  @transform.positions.set(game_state.player, pos)
  @physics2d.shapes.set(
    game_state.player,
    Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
  )
  @physics2d.colliders.set(
    game_state.player,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(player_collision_group, [
        terrain_collision_group, enemy_collision_group, trigger_collision_group,
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
fn entity_rect(entity : @entity.Entity) -> @math.Rect? {
  guard @transform.positions.get(entity) is Some(position) else { return None }
  guard @physics2d.shapes.get(entity) is Some(shape) else { return None }
  match shape {
    Rect(size~, offset~) =>
      Some(@math.Rect::{ position: position.0 + offset, size })
  }
}

///|
fn player_collision_system(_delta : Double) -> Unit {
  if game_state.hurt_timer > 0.0 {
    game_state.hurt_timer -= 1.0
  }
  guard entity_rect(game_state.player) is Some(player_rect) else { return }
  let player_bottom = player_rect.position[Y] + player_rect.size[Y]
  let resolved_vy = @physics2d.resolved_velocities
    .get(game_state.player)
    .map_or(0.0, fn(v) { v.0[Y] })
  for bird_entity, bird in birds {
    guard bird_entity.is_alive() else { continue }
    guard !bird.is_hurt else { continue }
    guard entity_rect(bird_entity) is Some(bird_rect) else { continue }
    if !@math.Rect::intersects(player_rect, bird_rect) {
      continue
    }
    let bird_mid_y = bird_rect.position[Y] + bird_rect.size[Y] * 0.5
    let stomp = resolved_vy > 0.0 && player_bottom <= bird_mid_y
    if stomp {
      bird.is_hurt = true
      guard @physics2d.linear_velocities.get(game_state.player)
        is Some(velocity)
      @physics2d.linear_velocities[game_state.player] = velocity.0.update(
        Y,
        -BUMP_V,
      )
    } else {
      hurt_player()
    }
    break
  }
}

///|
fn player_state_system(delta : Double) -> Unit {
  let velocity = @physics2d.resolved_velocities
    .get(game_state.player)
    .unwrap_or(@math.Vec2D::zero())
  let grounded = @physics2d.is_grounded(game_state.player)
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
      if !grounded && velocity.0[Y] > 0.0 {
        game_state.player_state = PlayerState::Fall
      }
      if @inputs.is_just_pressed(ArrowUp) && grounded {
        new_velocity_y = -JUMP_V
        game_state.player_state = PlayerState::Jump
        if game_state.volume_on {
          play_sfx(jump_sound)
        }
      }
    }
    Fall => {
      @sprite.play_animation(
        game_state.player,
        player_fall_animation,
        transform~,
      )
      if @physics2d.is_grounded(game_state.player) {
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
      if @physics2d.is_grounded(game_state.player) {
        new_velocity_x = 0.0
      }
      if @sprite.is_animation_finished(game_state.player) {
        if @physics2d.is_grounded(game_state.player) {
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
  @physics2d.linear_velocities[game_state.player] = @math.Vec2D(
    new_velocity_x, new_velocity_y,
  )
}
