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
  Attack
  Range
  Speed
  Cooldown
  Bandana
} derive(Eq)

///|
struct Powerup {
  powerup_type : PowerupType
  name : String
}

///|
fn create_powerup(powerup_type : PowerupType) -> Powerup {
  match powerup_type {
    Attack => { powerup_type: Attack, name: "Attack +0.2" }
    Range => { powerup_type: Range, name: "Range +16" }
    Speed => { powerup_type: Speed, name: "Speed +15" }
    Cooldown => { powerup_type: Cooldown, name: "Attack Speed +10%" }
    Bandana => { powerup_type: Bandana, name: "Penetration +1" }
  }
}

///|
fn apply_powerup(powerup : Powerup) -> Unit {
  match powerup.powerup_type {
    Attack => game_state.player_stats.attack += 0.2
    Range => game_state.player_stats.range += 16.0
    Speed => game_state.player_stats.speed += 15.0
    Cooldown => game_state.player_stats.attack_speed += 0.1
    Bandana => game_state.player_stats.penetration += 1
  }
}

///|
fn get_powerup_icon(powerup_type : PowerupType) -> @sprite.Animation {
  match powerup_type {
    Attack => powerup_attack_icon
    Range => powerup_range_icon
    Speed => powerup_speed_icon
    Cooldown => powerup_cooldown_icon
    Bandana => powerup_bandana_icon
  }
}
