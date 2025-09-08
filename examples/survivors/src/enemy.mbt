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
struct EnemyData {
  health : Int
  speed : Double
  points : Int
  spawn_weight : Int
  right_animation : @sprite.Animation
  left_animation : @sprite.Animation
}

///|
let enemy_data : Map[EnemyType, EnemyData] = {
  let data = Map::new()
  data.set(Slime, {
    health: 1,
    speed: 1.0,
    points: 10,
    spawn_weight: 40,
    right_animation: slime_right_animation,
    left_animation: slime_left_animation,
  })
  data.set(Icecream, {
    health: 2,
    speed: 1.0,
    points: 25,
    spawn_weight: 30,
    right_animation: icecream_right_animation,
    left_animation: icecream_left_animation,
  })
  data.set(Orc, {
    health: 3,
    speed: 1.3,
    points: 50,
    spawn_weight: 20,
    right_animation: orc_right_animation,
    left_animation: orc_left_animation,
  })
  data.set(Skull, {
    health: 4,
    speed: 1.5,
    points: 100,
    spawn_weight: 10,
    right_animation: skull_right_animation,
    left_animation: skull_left_animation,
  })
  data
}

///|
let spawners : Array[@math.Vec2D] = [
  Vec2D(16.0, 16.0),
  Vec2D(MAP_WIDTH - 16.0, 16.0),
  Vec2D(16.0, MAP_HEIGHT - 16.0),
  Vec2D(MAP_WIDTH - 16.0, MAP_HEIGHT - 16.0),
]

///|
fn spawn_enemy_system(_ : &@system.Backend) -> Unit {
  if game_state.game_over {
    return
  }
  
  let rand = game_state.rand
  let enemy = @system.Entity::new()
  let pos = spawners[rand.int(limit=spawners.length())]
  @position.positions.set(enemy, pos)
  @velocity.velocities.set(enemy, @math.Vec2D::zero())
  
  // Select enemy type based on weighted random selection
  let enemy_type = select_random_enemy_type(rand)
  let data = get_enemy_data(enemy_type)
  
  // Create sprite and enemy state using data structure
  let sprite = @sprite.Sprite::from_animation(
    data.right_animation,
    ENEMY_ZINDEX,
    offset=Vec2D(-8.0, -8.0),
  )
  let enemy_state = { 
    enemy_type: enemy_type, 
    speed: data.speed, 
    health: data.health 
  }
  
  @sprite.sprites.set(enemy, sprite)
  @collision.shapes.set(
    enemy,
    @collision.CollisionShape::Rect(
      size=Vec2D(16.0, 16.0),
      offset=Vec2D(-8.0, -8.0),
    ),
  )
  @collision.collision_layers.set(enemy, enemy_collision_layer)
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
  Icecream
  Orc
  Skull
} derive(Eq, Hash)

///|
let enemies : Map[@system.Entity, Enemy] = Map::new()

///|
fn get_enemy_data(enemy_type : EnemyType) -> EnemyData {
  match enemy_data.get(enemy_type) {
    Some(data) => data
    None => abort("Enemy data not found")
  }
}

///|
fn select_random_enemy_type(rand : @random.Rand) -> EnemyType {
  // Calculate total weight
  let mut total_weight = 0
  for _, data in enemy_data {
    total_weight += data.spawn_weight
  }
  let rand_val = rand.int(limit=total_weight)
  
  let mut current_weight = 0
  for enemy_type, data in enemy_data {
    current_weight += data.spawn_weight
    if rand_val < current_weight {
      return enemy_type
    }
  }
  
  // Fallback (should never reach here)
  Slime
}

///|
fn enemy_ai_system(_ : &@system.Backend) -> Unit {
  if game_state.game_over {
    return
  }
  
  for e, state in enemies {
    guard e.is_alive() else { continue }
    guard @position.positions.get(game_state.player_entity) is Some(player_position)
    guard @position.positions.get(e) is Some(position)
    
    let data = get_enemy_data(state.enemy_type)
    let dir = player_position.0 - position.0
    let vel = dir.normalize().scalar_mul(state.speed)
    @velocity.velocities.set(e, @velocity.Velocity(vel))
    
    // Use the appropriate animation based on direction
    if vel[X] >= 0.0 {
      @sprite.play_animation(e, data.right_animation)
    } else {
      @sprite.play_animation(e, data.left_animation)
    }
  }
}
