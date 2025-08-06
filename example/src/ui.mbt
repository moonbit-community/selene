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

///|
fn add_restart_button() -> Unit {
  let button = @system.Entity::new()
  @position.positions.set(button, @math.Vec2D::new(WORLD_WIDTH - 40, 18))
  let sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D::new(21, 22),
      "pixel_adventure/Menu/Buttons/Restart.png",
    ),
    100,
  )
  @sprite.sprites.set(button, sprite)
}
