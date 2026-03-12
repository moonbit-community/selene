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
priv struct GameState {
  player : @entity.Entity
  mut direction : Direction2
  mut score : Int
  result_box : @entity.Entity
  score_box : @entity.Entity
  health_box : @entity.Entity
  volume_button : @entity.Entity
  mut volume_on : Bool
  mut health : Int
  mut hurt_timer : Double
  mut pending_bounce_velocity_y : Double?
}

///|
enum Direction2 {
  Left
  Right
} derive(Eq)

///|
let game_state : GameState = {
  player: @entity.Entity::new(),
  score: 0,
  result_box: @entity.Entity::new(),
  score_box: @entity.Entity::new(),
  health_box: @entity.Entity::new(),
  volume_button: @entity.Entity::new(),
  direction: Direction2::Right,
  volume_on: true,
  health: 3,
  hurt_timer: 0.0,
  pending_bounce_velocity_y: None,
}

///|
let jump_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/jump.wav",
)

///|
let coin_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/coin.wav",
)

///|
let hurt_sound : @audio.AudioHandle = @asset2.load_audio(
  "assets/pixeladventure/sounds/hurt.wav",
)

///|
fn play_sfx(sound : @audio.AudioHandle) -> Unit {
  @audio.send_audio_event(sound, settings=@audio.PlaybackSettings::remove())
}

///|
fn set_player_state(next : PlayerState) -> Unit {
  let current = player_state_machine.get()
  if current == next {
    return
  }
  @state.set_next_state(player_state_machine.next(), next)
}

///|
fn jump_audio_on_enter_system(_world : @ecs.World) -> Unit {
  if game_state.volume_on {
    play_sfx(jump_sound)
  }
}

///|
priv enum GameResult {
  Win
  GameOver
}

///|
fn set_game_result(result : GameResult) -> Unit {
  match result {
    GameResult::Win => {
      set_ui_text(game_state.result_box, "You Win!")
      set_ui_text_color(game_state.result_box, "green")
    }
    GameResult::GameOver => {
      set_ui_text(game_state.result_box, "Game Over!")
      set_ui_text_color(game_state.result_box, "red")
    }
  }
}

///|
const ATTACK_V : Double = 180.0

///|
fn hurt_player() -> Unit {
  if game_state.hurt_timer <= 0.0 {
    let back_vel = match game_state.direction {
      Left => @math.Vec2D(ATTACK_V, 0.0)
      Right => @math.Vec2D(-ATTACK_V, 0.0)
    }
    @physics2d.linear_velocities()[game_state.player] = back_vel
    set_player_state(PlayerState::Hit)
    game_state.health -= 1
    update_health_display()
    game_state.hurt_timer = 60.0
    if game_state.volume_on {
      play_sfx(hurt_sound)
    }
    if game_state.health <= 0 {
      set_game_result(GameResult::GameOver)
    }
  }
}

///|
fn set_score(score : Int) -> Unit {
  game_state.score = score
  set_ui_text(game_state.score_box, "Score: " + game_state.score.to_string())
}

///|
fn update_health_display() -> Unit {
  set_ui_text(game_state.health_box, "HP: " + game_state.health.to_string())
}
