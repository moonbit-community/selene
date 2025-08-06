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
  mut hp : Int
  result_box : @sprite.Text
  score_box : @sprite.Text
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
  hp: 3,
  result_box: @sprite.Text::new("", font="24px ThaleahFat"),
  score_box: @sprite.Text::new(
    "Score: 0",
    font="20px ThaleahFat",
    color="white",
  ),
  direction: Direction2::Right,
}

///|
enum GameResult {
  Win
  Lose
}

///|
fn set_game_result(result : GameResult) -> Unit {
  match result {
    GameResult::Win => {
      game_state.result_box.content = "You Win!"
      game_state.result_box.color = "green"
    }
    GameResult::Lose => {
      game_state.result_box.content = "You Lose!"
      game_state.result_box.color = "red"
    }
  }
}

///|
fn score_up(score : Int) -> Unit {
  game_state.score += score
  game_state.score_box.content = "Score: " + game_state.score.to_string()
}

///|
fn take_damage(damage : Int) -> Unit {
  game_state.hp -= damage
  if game_state.hp <= 0 {
    game_state.hp = 0
    game_state.player_state = PlayerState::Die
    set_game_result(GameResult::Lose)
  }
}

///|
fn add_result_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(
    box,
    @math.Vec2D::new(WORLD_WIDTH / 2.0 - 48, WORLD_HEIGHT / 2.0 - 32),
  )
  let text = @sprite.Sprite::new_text(game_state.result_box, 100)
  @sprite.sprites.set(box, text)
}

///|
fn add_score_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(box, @math.Vec2D::new(WORLD_WIDTH / 2.0 - 48, 80))
  let text = @sprite.Sprite::new_text(game_state.score_box, 100)
  @sprite.sprites.set(box, text)
}
