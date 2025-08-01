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
struct GameState {
  player : @system.Entity
  mut result : GameResult
  mut score : Int
  mut hp : Int
}

///|
let game_state : GameState = {
  player: @system.Entity::new(),
  result: GameResult::Playing,
  score: 0,
  hp: 3,
}

///|
enum GameResult {
  Win
  Lose
  Playing
}

fn take_damage(damage : Int) -> Unit {
  game_state.hp -= damage
  if game_state.hp <= 0 {
    game_state.hp = 0
    game_state.result = GameResult::Lose
  }
}
