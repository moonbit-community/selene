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
let spawners : Array[@math.Vec2D] = [
  Vec2D(16.0, 16.0),
  Vec2D(MAP_WIDTH - 16.0, 16.0),
  Vec2D(16.0, MAP_HEIGHT - 16.0),
  Vec2D(MAP_WIDTH - 16.0, MAP_HEIGHT - 16.0),
]

///|
fn spawn_enemy_system(_ : &@system.Backend) -> Unit {
  let rand = game_state.rand
  let enemy = @system.Entity::new()
  let pos = spawners[rand.int(limit=spawners.length())]
  @position.positions.set(enemy, pos)
  @velocity.velocities.set(enemy, @math.Vec2D::zero())
  let sprite = @sprite.Sprite::from_animation(
    slime_right_animation,
    ENEMY_ZINDEX,
    offset=Vec2D(-8.0, -8.0),
  )
  @sprite.sprites.set(enemy, sprite)
  @collision.shapes.set(
    enemy,
    @collision.CollisionShape::Rect(
      size=Vec2D(16.0, 16.0),
      offset=Vec2D(-8.0, -8.0),
    ),
  )
  @collision.collision_layers.set(enemy, enemy_collision_layer)
  let enemy_state = { enemy_type: Slime, speed: 1.0, health: 1 }
  enemies.set(enemy, enemy_state)
  let area = @collision.Area::new(
    @collision.CollisionMask::new([player_collision_layer]),
  )
  @collision.areas.set(enemy, area)
  area.on_enter(fn(e) {
    guard e.is_alive() else { return }
    guard e == game_state.player_entity else { return }
    if game_state.invincible {
      return
    }
    game_state.invincible = true
    set_score(game_state.score / 2)
    @system.timeout_with_frames(INVINCIBLE_TIME.to_int(), fn() {
      game_state.invincible = false
    })
    enemy.destroy()
  })
}

///|
struct Enemy {
  enemy_type : EnemyType
  speed : Double
  mut health : Int
}

///|
enum EnemyType {
  Slime
}

///|
let enemies : Map[@system.Entity, Enemy] = Map::new()

///|
fn enemy_ai_system(_ : &@system.Backend) -> Unit {
  for e, state in enemies {
    guard e.is_alive() else { continue }
    match state.enemy_type {
      EnemyType::Slime => {
        guard @position.positions.get(game_state.player_entity)
          is Some(player_position)
        guard @position.positions.get(e) is Some(position)
        let dir = player_position.0 - position.0
        let vel = dir.normalize().scalar_mul(state.speed)
        @velocity.velocities.set(e, @velocity.Velocity(vel))
        if vel[X] >= 0.0 {
          @sprite.play_animation(e, slime_right_animation)
        } else {
          @sprite.play_animation(e, slime_left_animation)
        }
      }
    }
  }
}
