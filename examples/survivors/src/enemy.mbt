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
  health : Double
  speed : Double
  points : Int
  right_animation : @sprite.Animation
  left_animation : @sprite.Animation
}

///|
struct WaveSpawnPlan {
  creeper_count : Int
  icecream_count : Int
  orc_count : Int
  skull_count : Int
  teleman_count : Int
  devil_count : Int
  pirate_count : Int
  spawn_interval : Double // Time in seconds between spawns
}

///|
let wave_spawn_plans : Array[WaveSpawnPlan] = [
  // Wave 1: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 40,
    icecream_count: 20,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 2: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 30,
    icecream_count: 0,
    orc_count: 30,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 3: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 120,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 4: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 60,
    icecream_count: 0,
    orc_count: 0,
    skull_count: 60,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 5: 180 enemies over 60s = 0.333s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 90,
    skull_count: 90,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.333,
  },
  // Wave 6: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 56,
    skull_count: 0,
    teleman_count: 4,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 7: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 60,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 60,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 8: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 40,
    skull_count: 0,
    teleman_count: 40,
    devil_count: 40,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 9: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 20,
    icecream_count: 20,
    orc_count: 20,
    skull_count: 20,
    teleman_count: 20,
    devil_count: 20,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 10: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 59,
    devil_count: 0,
    pirate_count: 1,
    spawn_interval: 1.0,
  },
]

///|
struct WaveState {
  mut creeper_spawned : Int
  mut icecream_spawned : Int
  mut orc_spawned : Int
  mut skull_spawned : Int
  mut teleman_spawned : Int
  mut devil_spawned : Int
  mut pirate_spawned : Int
}

///|
let wave_state : WaveState = {
  creeper_spawned: 0,
  icecream_spawned: 0,
  orc_spawned: 0,
  skull_spawned: 0,
  teleman_spawned: 0,
  devil_spawned: 0,
  pirate_spawned: 0,
}

///|
fn reset_wave_state() -> Unit {
  wave_state.creeper_spawned = 0
  wave_state.icecream_spawned = 0
  wave_state.orc_spawned = 0
  wave_state.skull_spawned = 0
  wave_state.teleman_spawned = 0
  wave_state.devil_spawned = 0
  wave_state.pirate_spawned = 0
}

///|
let enemy_data : Map[EnemyType, EnemyData] = {
  let data = Map::new()
  data.set(Creeper, {
    health: 1.0,
    speed: 60.0,
    points: 10,
    right_animation: creeper_right_animation,
    left_animation: creeper_left_animation,
  })
  data.set(Icecream, {
    health: 2.0,
    speed: 90.0,
    points: 20,
    right_animation: icecream_right_animation,
    left_animation: icecream_left_animation,
  })
  data.set(Orc, {
    health: 3.0,
    speed: 75,
    points: 30,
    right_animation: orc_right_animation,
    left_animation: orc_left_animation,
  })
  data.set(Skull, {
    health: 5.0,
    speed: 60.0,
    points: 40,
    right_animation: skull_right_animation,
    left_animation: skull_left_animation,
  })
  data.set(Teleman, {
    health: 20.0,
    speed: 60.0,
    points: 80,
    right_animation: teleman_right_animation,
    left_animation: teleman_left_animation,
  })
  data.set(Devil, {
    health: 8.0,
    speed: 90.0,
    points: 50,
    right_animation: devil_right_animation,
    left_animation: devil_left_animation,
  })
  data.set(Pirate, {
    health: 500.0,
    speed: 60.0,
    points: 200,
    right_animation: pirate_right_animation,
    left_animation: pirate_left_animation,
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
fn spawn_enemy_system(_delta : Double) -> Unit {
  fn spawn_enemy() -> Unit {
    if game_state.game_over {
      return
    }
    let rand = game_state.rand

    // Get spawn interval for current wave
    let wave = game_state.current_wave
    let spawn_interval = if wave >= 1 && wave <= 10 {
      wave_spawn_plans[wave - 1].spawn_interval
    } else {
      1.0 // Fallback interval
    }

    // Try to select an enemy type for the current wave
    match select_enemy_type_for_wave(rand) {
      Some(enemy_type) => {
        let enemy = @entity.Entity::new()
        let pos = spawners[rand.int(limit=spawners.length())]
        @position.positions.set(enemy, pos)
        @velocity.velocities.set(enemy, @math.Vec2D::zero())
        let data = get_enemy_data(enemy_type)

        // Create sprite and enemy state using data structure
        let sprite = @sprite.Sprite::from_animation(
          data.right_animation,
          ENEMY_ZINDEX,
          offset=Vec2D(-8.0, -12.0),
        )
        let enemy_state = { enemy_type, speed: data.speed, health: data.health }
        @sprite.sprites.set(enemy, sprite)
        @collision.shapes.set(
          enemy,
          @collision.CollisionShape::Rect(
            size=Vec2D(8.0, 8.0),
            offset=Vec2D(-4.0, -4.0),
          ),
        )
        @collision.collision_layers.set(enemy, enemy_collision_layer)
        @collision.colliders.set(
          enemy,
          @collision.Collider::new(
            @collision.CollisionMask::new([
              enemy_collision_layer, wall_collision_layer,
            ]),
          ),
        )
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
          let penalty = 250 * game_state.current_wave
          let new_score = (game_state.score - penalty).max(0)
          set_score(new_score)
          trigger_damage_effect()
          @system.timeout(INVINCIBLE_TIME, fn() {
            game_state.invincible = false
          })
        })
      }
      None => () // No more enemies to spawn in this wave
    }
    @system.timeout(spawn_interval, spawn_enemy)
  }

  spawn_enemy()
}

///|
struct Enemy {
  enemy_type : EnemyType
  speed : Double
  mut health : Double
}

///|
enum EnemyType {
  Creeper
  Icecream
  Orc
  Skull
  Teleman
  Devil
  Pirate
} derive(Eq, Hash)

///|
let enemies : Map[@entity.Entity, Enemy] = Map::new()

///|
fn get_enemy_data(enemy_type : EnemyType) -> EnemyData {
  match enemy_data.get(enemy_type) {
    Some(data) => data
    None => abort("Enemy data not found")
  }
}

///|
fn select_enemy_type_for_wave(rand : @random.Rand) -> EnemyType? {
  let wave = game_state.current_wave
  if wave < 1 || wave > 10 {
    return None
  }
  let plan = wave_spawn_plans[wave - 1]
  let available_types = []

  // Build list of available enemy types based on what hasn't been fully spawned
  if wave_state.creeper_spawned < plan.creeper_count {
    available_types.push(Creeper)
  }
  if wave_state.icecream_spawned < plan.icecream_count {
    available_types.push(Icecream)
  }
  if wave_state.orc_spawned < plan.orc_count {
    available_types.push(Orc)
  }
  if wave_state.skull_spawned < plan.skull_count {
    available_types.push(Skull)
  }
  if wave_state.teleman_spawned < plan.teleman_count {
    available_types.push(Teleman)
  }
  if wave_state.devil_spawned < plan.devil_count {
    available_types.push(Devil)
  }
  if wave_state.pirate_spawned < plan.pirate_count {
    available_types.push(Pirate)
  }

  // If no enemies left to spawn, return None
  if available_types.length() == 0 {
    return None
  }

  // Randomly select from available types
  let index = rand.int(limit=available_types.length())
  let enemy_type = available_types[index]

  // Increment the counter for the selected type
  match enemy_type {
    Creeper => wave_state.creeper_spawned += 1
    Icecream => wave_state.icecream_spawned += 1
    Orc => wave_state.orc_spawned += 1
    Skull => wave_state.skull_spawned += 1
    Teleman => wave_state.teleman_spawned += 1
    Devil => wave_state.devil_spawned += 1
    Pirate => wave_state.pirate_spawned += 1
  }
  Some(enemy_type)
}

///|
fn enemy_ai_system(_delta : Double) -> Unit {
  if game_state.game_over {
    return
  }
  for e, state in enemies {
    guard e.is_alive() else { continue }
    guard @position.positions.get(game_state.player_entity)
      is Some(player_position)
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
