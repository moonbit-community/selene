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
fn add_score_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.score_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}
