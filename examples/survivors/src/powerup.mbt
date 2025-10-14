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
enum PowerupType {
  AttackLv1
  AttackLv2
  AttackLv3
  RangeLv1
  RangeLv2
  SpeedLv1
  SpeedLv2
  CooldownLv1
  CooldownLv2
  Bandana
} derive(Eq)

///|
struct Powerup {
  powerup_type : PowerupType
  name : String
  weight_formula : (Int) -> Double // Function that calculates weight based on level
}

///|
fn create_powerup(powerup_type : PowerupType) -> Powerup {
  match powerup_type {
    AttackLv1 => {
      powerup_type: AttackLv1,
      name: "Attack +0.2",
      weight_formula: fn(_level) { 10.0 },
    }
    AttackLv2 => {
      powerup_type: AttackLv2,
      name: "Attack +0.3",
      weight_formula: fn(level) { 1.0 + level.to_double() * 0.2 },
    }
    AttackLv3 => {
      powerup_type: AttackLv3,
      name: "Attack +0.4",
      weight_formula: fn(level) { level.to_double() * 0.1 },
    }
    RangeLv1 => {
      powerup_type: RangeLv1,
      name: "Range +16",
      weight_formula: fn(_level) { 10.0 },
    }
    RangeLv2 => {
      powerup_type: RangeLv2,
      name: "Range +32",
      weight_formula: fn(level) { 5.0 + level.to_double() * 1.0 },
    }
    SpeedLv1 => {
      powerup_type: SpeedLv1,
      name: "Speed +15",
      weight_formula: fn(_level) { 10.0 },
    }
    SpeedLv2 => {
      powerup_type: SpeedLv2,
      name: "Speed +30",
      weight_formula: fn(level) { 5.0 + level.to_double() * 0.5 },
    }
    CooldownLv1 => {
      powerup_type: CooldownLv1,
      name: "Attack Speed +10%",
      weight_formula: fn(_level) { 10.0 },
    }
    CooldownLv2 => {
      powerup_type: CooldownLv2,
      name: "Attack Speed +20%",
      weight_formula: fn(level) { 1.0 + level.to_double() * 0.2 },
    }
    Bandana => {
      powerup_type: Bandana,
      name: "Penetration +1",
      weight_formula: fn(level) { level.to_double() * 0.1 },
    }
  }
}

///|
fn apply_powerup(powerup : Powerup) -> Unit {
  match powerup.powerup_type {
    AttackLv1 => game_state.player_stats.attack += 0.2
    AttackLv2 => game_state.player_stats.attack += 0.3
    AttackLv3 => game_state.player_stats.attack += 0.4
    RangeLv1 => game_state.player_stats.range += 16.0
    RangeLv2 => game_state.player_stats.range += 32.0
    SpeedLv1 => game_state.player_stats.speed += 15.0
    SpeedLv2 => game_state.player_stats.speed += 30.0
    CooldownLv1 => game_state.player_stats.attack_speed += 0.1
    CooldownLv2 => game_state.player_stats.attack_speed += 0.2
    Bandana => game_state.player_stats.penetration += 1
  }
}

///|
fn get_powerup_icon(powerup_type : PowerupType) -> @sprite.Animation {
  match powerup_type {
    AttackLv1 | AttackLv2 | AttackLv3 => powerup_attack_icon
    RangeLv1 | RangeLv2 => powerup_range_icon
    SpeedLv1 | SpeedLv2 => powerup_speed_icon
    CooldownLv1 | CooldownLv2 => powerup_cooldown_icon
    Bandana => powerup_bandana_icon
  }
}
