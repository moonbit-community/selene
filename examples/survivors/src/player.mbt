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
const PLAYER_SIZE : Double = 16.0

///|
const PLAYER_SPEED : Double = 2.5

///|
const INVINCIBLE_TIME : Double = 1.0 * FPS

///|
fn add_player() -> Unit {
  let entity = game_state.player_entity
  @sprite.sprites.set(
    entity,
    @sprite.Sprite::from_animation(
      player_idle_right_animation,
      PLAYER_ZINDEX,
      offset=Vec2D(-PLAYER_SIZE / 2.0, -PLAYER_SIZE / 2.0),
    ),
  )
  @position.positions.set(entity, Vec2D(MAP_WIDTH / 2.0, MAP_HEIGHT / 2.0))
  @velocity.velocities.set(entity, Vec2D(0.0, 0.0))
  @camera.attach_entity(entity, Vec2D(PLAYER_SIZE / 2.0, PLAYER_SIZE / 2.0))
  @collision.collision_layers.set(entity, player_collision_layer)
  @collision.colliders.set(
    entity,
    @collision.Collider::new(
      @collision.CollisionMask::new([wall_collision_layer]),
    ),
  )
  @collision.shapes.set(
    entity,
    @collision.CollisionShape::Rect(
      size=Vec2D(PLAYER_SIZE, PLAYER_SIZE),
      offset=Vec2D(-PLAYER_SIZE / 2.0, -PLAYER_SIZE / 2.0),
    ),
  )
}

///|
fn player_update_system(_ : &@system.Backend) -> Unit {
  if game_state.game_over {
    return
  }

  let entity = game_state.player_entity
  let vel = @system.key_vector(KeyW, KeyS, KeyA, KeyD)
    .normalize()
    .scalar_mul(PLAYER_SPEED)
  @velocity.velocities.set(entity, vel)
  if vel[X] > 0.0 {
    game_state.player_direction = Right
  } else if vel[X] < 0.0 {
    game_state.player_direction = Left
  } else if vel[Y] > 0.0 {
    game_state.player_direction = Down
  } else if vel[Y] < 0.0 {
    game_state.player_direction = Up
  }
  match (vel == @math.Vec2D::zero(), game_state.player_direction) {
    (true, Left) => @sprite.play_animation(entity, player_idle_left_animation)
    (true, Right) => @sprite.play_animation(entity, player_idle_right_animation)
    (true, Up) => @sprite.play_animation(entity, player_idle_up_animation)
    (true, Down) => @sprite.play_animation(entity, player_idle_down_animation)
    (false, Left) => @sprite.play_animation(entity, player_run_left_animation)
    (false, Right) => @sprite.play_animation(entity, player_run_right_animation)
    (false, Up) => @sprite.play_animation(entity, player_run_up_animation)
    (false, Down) => @sprite.play_animation(entity, player_run_down_animation)
  }
}

///|
const WEAPON_COOLDOWN : Double = 1.5 * FPS

///|
fn player_shooting_system(_ : &@system.Backend) -> Unit {
  if game_state.game_over {
    return
  }
  if game_state.shoot_timer > 0.0 {
    game_state.shoot_timer -= 1.0
  }
  if game_state.shoot_timer <= 0 {
    game_state.shoot_timer = WEAPON_COOLDOWN
    guard @position.positions.get(game_state.player_entity) is Some(player_pos)
    let nearest_enemy_pos = find_nearest_enemy_position(player_pos.0)
    match nearest_enemy_pos {
      Some(enemy_pos) => shoot_bullet(player_pos.0, enemy_pos)
      None => ()
    }
  }
}

///|
const SHOOTING_RANGE : Double = 192.0

///|
fn find_nearest_enemy_position(player_pos : @math.Vec2D) -> @math.Vec2D? {
  let mut min = SHOOTING_RANGE
  let mut res : @math.Vec2D? = None
  for e, _enemy in enemies {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(enemy_pos)
    let dist = player_pos.distance_to(enemy_pos.0)
    if dist < min {
      min = dist
      res = Some(enemy_pos.0)
    }
  }
  res
}
