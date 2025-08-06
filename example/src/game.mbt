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
  mut player_state : PlayerState
  mut direction : Direction2
  mut score : Int
  result_box : @sprite.Text
  score_box : @sprite.Text
  mut volume_on : Bool
}

///|
enum Direction2 {
  Left
  Right
}

///|
let game_state : GameState = {
  player: @system.Entity::new(),
  player_state: PlayerState::Idle,
  score: 0,
  result_box: @sprite.Text::new("", font="24px ThaleahFat"),
  score_box: @sprite.Text::new(
    "Score: 0",
    font="20px ThaleahFat",
    color="white",
  ),
  direction: Direction2::Right,
  volume_on: true,
}

///|
enum GameResult {
  Win
}

///|
fn set_game_result(result : GameResult) -> Unit {
  match result {
    GameResult::Win => {
      game_state.result_box.content = "You Win!"
      game_state.result_box.color = "green"
    }
  }
}

///|
fn set_score(score : Int) -> Unit {
  game_state.score = score
  game_state.score_box.content = "Score: " + game_state.score.to_string()
}
