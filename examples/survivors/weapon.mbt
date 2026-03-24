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
  Sword
} derive(Eq)

///|
priv struct WeaponData {
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
        speed_modifier: -15.0,
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
    Sword =>
      {
        cooldown_rate: 2.0,
        damage_formula: fn(base, atk) { base + atk * 4.0 },
        range_formula: fn(base, rng) { base + rng * 0.5 },
        bullet_speed: 150.0,
        base_damage: 2.0,
        base_range: 24.0,
        speed_modifier: -15.0,
        attack_speed_modifier: 0.0,
        penetration: 99,
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
    Sword => "Sword"
  }
}

///|
fn get_weapon_weight(weapon_type : WeaponType, level : Int) -> Double {
  match weapon_type {
    Pistol => 10.0 + level.to_double() * 0.5
    Minigun => level.to_double() * 0.2
    SniperRifle => level.to_double() * 0.5
    Sword => 10.0 + level.to_double() * 0.5
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
priv struct PlayerBulletState {
  mut alive : Bool
  mut penetration_count : Int
  damage : Double
  penetration_limit : Int
}

///|
let player_bullets : Map[@entity.Entity, PlayerBulletState] = Map::new()

///|
let player_bullet_trigger_event_reader : @event.EventReader[
  @physics2d.TriggerEvent,
] = @event.EventReader::new()

///|
let player_bullet_visual : @sprite.Sprite = @sprite.Sprite::new(
  image=Some(@asset.load_image("assets/survivors/icon/bullet.png")),
  custom_size=Some(Vec2D(12.0, 12.0)),
)

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
  let bullet_hitbox_size = 6.0
  let direction = target_pos - player_pos
  let dir = if direction.distance() <= 0.0000001 {
    @math.Vec2D(1.0, 0.0)
  } else {
    direction.normalize()
  }
  let bullet_spawn_pos = player_pos + dir.scalar_mul(14.0)
  let bullet_entity = @entity.Entity::new()
  @sprite.sprites().set(bullet_entity, player_bullet_visual)
  @transform.transforms().set(
    bullet_entity,
    @transform.Transform::from_xyz(
      bullet_spawn_pos[X],
      bullet_spawn_pos[Y],
      BULLET_ZINDEX.to_double(),
    ),
  )
  let vel = dir.scalar_mul(weapon_data.bullet_speed)
  @physics2d.linear_velocities().set(bullet_entity, vel)
  @physics2d.shapes().set(
    bullet_entity,
    @physics2d.CollisionShape::Rect(
      size=@math.Vec2D(bullet_hitbox_size, bullet_hitbox_size),
      offset=@math.Vec2D(-bullet_hitbox_size / 2.0, -bullet_hitbox_size / 2.0),
    ),
  )
  let area = @physics2d.Area::new(
    @physics2d.CollisionFilter::new(bullet_collision_group, [
      enemy_collision_group, wall_collision_group,
    ]),
  )
  @physics2d.areas().set(bullet_entity, area)
  player_bullets.set(bullet_entity, {
    alive: true,
    penetration_count: 0,
    damage,
    penetration_limit: total_penetration,
  })

  // Calculate bullet duration based on weapon range
  let weapon_range = calculate_weapon_range(weapon_data, 0.0)
  let bullet_duration = weapon_range / weapon_data.bullet_speed
  @system.timeout(bullet_duration, fn() {
    bullet_entity.destroy()
    player_bullets.remove(bullet_entity)
  })
}

///|
fn start_bullet_despawn(bullet_entity : @entity.Entity) -> Unit {
  guard player_bullets.get(bullet_entity) is Some(bullet) else { return }
  if !bullet.alive {
    return
  }
  bullet.alive = false
  @physics2d.linear_velocities().remove(bullet_entity)
  @physics2d.areas().remove(bullet_entity)
  bullet_entity.destroy()
  player_bullets.remove(bullet_entity)
}

///|
fn player_bullet_trigger_system(_world : @ecs.World) -> Unit {
  for
    event in @physics2d.trigger_event_bus.read(
      player_bullet_trigger_event_reader,
    ) {
    guard event.entered else { continue }
    guard player_bullets.get(event.area) is Some(bullet) else { continue }
    guard bullet.alive else { continue }
    if enemies.get(event.other) is Some(enemy) {
      enemy.health -= bullet.damage
      bullet.penetration_count += 1
      if enemy.health <= 0.0 {
        event.other.destroy()
        let data = get_enemy_data(enemy.enemy_type)
        set_score(game_state.score + data.points)
        add_exp(data.points)
      }
      if bullet.penetration_count >= bullet.penetration_limit {
        start_bullet_despawn(event.area)
      }
    } else {
      start_bullet_despawn(event.area)
    }
  }
}
