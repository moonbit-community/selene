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
const PLAYER_SPEED : Double = 150

///|
const INVINCIBLE_TIME : Double = 1.0

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
fn player_update_system(delta : Double) -> Unit {
  if game_state.game_over || delta == 0 {
    return
  }
  let entity = game_state.player_entity
  let vel = @inputs.key_vector(KeyW, KeyS, KeyA, KeyD)
    .normalize()
    .scalar_mul(game_state.player_stats.speed)
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

///|
enum WeaponType {
  Pistol
  Minigun
} derive(Eq)

///|
struct Weapon {
  weapon_type : WeaponType
  cooldown_rate : Double // Base cooldown in seconds
  damage_formula : (Double, Double) -> Double // (base_damage, attack) -> damage
  range_formula : (Double, Double) -> Double // (base_range, range_stat) -> range
  bullet_speed : Double
}

///|
fn get_weapon_data(weapon_type : WeaponType) -> Weapon {
  match weapon_type {
    Pistol =>
      {
        weapon_type: Pistol,
        cooldown_rate: 1.5,
        damage_formula: fn(base, atk) { base + atk },
        range_formula: fn(base, rng) { base + rng },
        bullet_speed: 300.0,
      }
    Minigun =>
      {
        weapon_type: Minigun,
        cooldown_rate: 0.3,
        damage_formula: fn(base, atk) { base + atk * 0.5 },
        range_formula: fn(base, rng) { base + rng },
        bullet_speed: 600.0,
      }
  }
}

///|
// Store timers separately - one timer per weapon instance
let weapon_timers : Array[Double] = []

///|
fn player_shooting_system(delta : Double) -> Unit {
  if game_state.game_over {
    return
  }
  guard @position.positions.get(game_state.player_entity) is Some(player_pos)
  let weapon_instances = game_state.player_stats.weapon_instances

  // Initialize timers array if needed
  while weapon_timers.length() < weapon_instances.length() {
    weapon_timers.push(0.0)
  }

  // Update timers and fire each weapon instance independently
  for i in 0..<weapon_instances.length() {
    let weapon_type = weapon_instances[i]
    let weapon_data = get_weapon_data(weapon_type)
    if weapon_timers[i] > 0.0 {
      weapon_timers[i] = weapon_timers[i] - delta
    }
    if weapon_timers[i] <= 0.0 {
      weapon_timers[i] = weapon_data.cooldown_rate /
        game_state.player_stats.attack_speed
      let weapon_range = match weapon_type {
        Pistol =>
          (weapon_data.range_formula)(128.0, game_state.player_stats.range)
        Minigun =>
          (weapon_data.range_formula)(192.0, game_state.player_stats.range)
      }
      let nearest_enemy_pos = find_nearest_enemy_in_range(
        player_pos.0,
        weapon_range,
      )
      match nearest_enemy_pos {
        Some(enemy_pos) => {
          let weapon_damage = match weapon_type {
            Pistol =>
              (weapon_data.damage_formula)(1.0, game_state.player_stats.attack)
            Minigun =>
              (weapon_data.damage_formula)(0.2, game_state.player_stats.attack)
          }
          shoot_weapon_bullet(
            player_pos.0,
            enemy_pos,
            weapon_data,
            weapon_damage,
          )
        }
        None => ()
      }
    }
  }
}

///|

///|
fn find_nearest_enemy_in_range(
  player_pos : @math.Vec2D,
  weapon_range : Double,
) -> @math.Vec2D? {
  let mut min = weapon_range
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

///|
fn shoot_weapon_bullet(
  player_pos : @math.Vec2D,
  target_pos : @math.Vec2D,
  weapon : Weapon,
  damage : Double,
) -> Unit {
  let bullet_entity = @entity.Entity::new()
  @sprite.sprites.set(
    bullet_entity,
    @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(Vec2D(4.0, 4.0), "white"),
      BULLET_ZINDEX,
    ),
  )
  @position.positions.set(bullet_entity, player_pos)
  let vel = (target_pos - player_pos)
    .normalize()
    .scalar_mul(weapon.bullet_speed)
  @velocity.velocities.set(bullet_entity, vel)
  @collision.collision_layers.set(bullet_entity, bullet_collision_layer)
  @collision.shapes.set(
    bullet_entity,
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(4.0, 4.0),
      offset=@math.Vec2D(-2.0, -2.0),
    ),
  )
  let area = @collision.Area::new(
    @collision.CollisionMask::new([enemy_collision_layer, wall_collision_layer]),
  )
  let mut bullet_alive = true
  area.on_enter(fn(enemy_entity) {
    guard enemies.get(enemy_entity) is Some(enemy) else {
      bullet_alive = false
      bullet_entity.destroy()
    }
    guard bullet_alive else { return }
    enemy.health -= damage
    bullet_entity.destroy()
    if enemy.health <= 0.0 {
      bullet_alive = false
      enemy_entity.destroy()
      // Give both points and EXP for killing enemies
      let data = get_enemy_data(enemy.enemy_type)
      set_score(game_state.score + data.points)
      add_exp(data.points)
    }
  })
  @collision.areas.set(bullet_entity, area)

  // Calculate bullet duration based on weapon range
  let weapon_range = match weapon.weapon_type {
    Pistol => (weapon.range_formula)(128.0, game_state.player_stats.range)
    Minigun => (weapon.range_formula)(192.0, game_state.player_stats.range)
  }
  let bullet_duration = weapon_range / weapon.bullet_speed
  @system.timeout(bullet_duration, fn() {
    bullet_alive = false
    bullet_entity.destroy()
  })
}
