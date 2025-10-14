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
enum WeaponType {
  Pistol
  Minigun
  SniperRifle
} derive(Eq)

///|
struct WeaponData {
  cooldown_rate : Double // Base cooldown in seconds
  damage_formula : (Double, Double) -> Double // (base_damage, attack) -> damage
  range_formula : (Double, Double) -> Double // (base_range, range_stat) -> range
  bullet_speed : Double
  base_damage : Double
  base_range : Double
  speed_modifier : Double // Speed change when this weapon is added
  attack_speed_modifier : Double // Attack speed change when this weapon is added
  penetration : Int // Number of enemies a bullet can hit
}

///|
fn get_weapon_data(weapon_type : WeaponType) -> WeaponData {
  match weapon_type {
    Pistol =>
      {
        cooldown_rate: 1.5,
        damage_formula: fn(base, atk) { base + atk },
        range_formula: fn(base, rng) { base + rng },
        bullet_speed: 300.0,
        base_damage: 1.0,
        base_range: 128.0,
        speed_modifier: 0.0,
        attack_speed_modifier: 0.0,
        penetration: 1,
      }
    Minigun =>
      {
        cooldown_rate: 0.3,
        damage_formula: fn(base, atk) { base + atk * 0.3 },
        range_formula: fn(base, rng) { base + rng },
        bullet_speed: 600.0,
        base_damage: 0.5,
        base_range: 128.0,
        speed_modifier: -50.0,
        attack_speed_modifier: 0.0,
        penetration: 1,
      }
    SniperRifle =>
      {
        cooldown_rate: 3.0,
        damage_formula: fn(base, atk) { base + atk * 4.0 },
        range_formula: fn(base, rng) { base + rng },
        bullet_speed: 900.0,
        base_damage: 2.0,
        base_range: 192.0,
        speed_modifier: -25.0,
        attack_speed_modifier: -0.2,
        penetration: 4,
      }
  }
}

///|
fn get_weapon_speed_modifier(weapon_type : WeaponType) -> Double {
  let weapon_data = get_weapon_data(weapon_type)
  weapon_data.speed_modifier
}

///|
fn get_weapon_attack_speed_modifier(weapon_type : WeaponType) -> Double {
  let weapon_data = get_weapon_data(weapon_type)
  weapon_data.attack_speed_modifier
}

///|
fn get_weapon_name(weapon_type : WeaponType) -> String {
  match weapon_type {
    Pistol => "Pistol"
    Minigun => "Minigun"
    SniperRifle => "Sniper Rifle"
  }
}

///|
fn get_weapon_icon(weapon_type : WeaponType) -> @sprite.Animation {
  match weapon_type {
    Pistol => weapon_pistol_icon
    Minigun => weapon_minigun_icon
    SniperRifle => weapon_sniperrifle_icon
  }
}

///|
fn calculate_weapon_damage(weapon_data : WeaponData, attack : Double) -> Double {
  (weapon_data.damage_formula)(weapon_data.base_damage, attack)
}

///|
fn calculate_weapon_range(weapon_data : WeaponData, range : Double) -> Double {
  (weapon_data.range_formula)(weapon_data.base_range, range)
}

///|
// Store timers separately - one timer per weapon instance
let weapon_timers : Array[Double] = []

///|
fn update_weapon_timers(
  weapon_instances : Array[WeaponType],
  delta : Double,
  attack_speed : Double,
  player_attack : Double,
  player_range : Double,
  player_penetration : Int,
  player_pos : @math.Vec2D,
) -> Unit {
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
      // Prevent division by zero - if attack_speed is 0, weapon never fires
      if attack_speed <= 0.0 {
        weapon_timers[i] = 999999.0 // Very large number to effectively disable weapon
      } else {
        weapon_timers[i] = weapon_data.cooldown_rate / attack_speed
      }
      let weapon_range = calculate_weapon_range(weapon_data, player_range)
      let nearest_enemy_pos = find_nearest_enemy_in_range(
        player_pos, weapon_range,
      )
      match nearest_enemy_pos {
        Some(enemy_pos) => {
          let weapon_damage = calculate_weapon_damage(
            weapon_data, player_attack,
          )
          let total_penetration = weapon_data.penetration + player_penetration
          shoot_weapon_bullet(
            player_pos, enemy_pos, weapon_data, weapon_damage, total_penetration,
          )
        }
        None => ()
      }
    }
  }
}

///|
fn shoot_weapon_bullet(
  player_pos : @math.Vec2D,
  target_pos : @math.Vec2D,
  weapon_data : WeaponData,
  damage : Double,
  total_penetration : Int,
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
    .scalar_mul(weapon_data.bullet_speed)
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
  let mut penetration_count = 0
  area.on_enter(fn(enemy_entity) {
    guard enemies.get(enemy_entity) is Some(enemy) else {
      // Hit wall
      bullet_alive = false
      bullet_entity.destroy()
      return
    }
    guard bullet_alive else { return }

    // Damage enemy
    enemy.health -= damage
    penetration_count += 1

    // Check if enemy is killed
    if enemy.health <= 0.0 {
      enemy_entity.destroy()
      // Give both points and EXP for killing enemies
      let data = get_enemy_data(enemy.enemy_type)
      set_score(game_state.score + data.points)
      add_exp(data.points)
    }

    // Check if bullet has reached penetration limit (weapon base + player bonus)
    if penetration_count >= total_penetration {
      bullet_alive = false
      bullet_entity.destroy()
    }
  })
  @collision.areas.set(bullet_entity, area)

  // Calculate bullet duration based on weapon range
  let weapon_range = calculate_weapon_range(weapon_data, 0.0)
  let bullet_duration = weapon_range / weapon_data.bullet_speed
  @system.timeout(bullet_duration, fn() {
    bullet_alive = false
    bullet_entity.destroy()
  })
}
