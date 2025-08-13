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
let fps_box : @sprite.Text = @sprite.Text::new(
  "FPS: 0",
  color="green",
  font="16px monospace",
)

///|
pub fn debug_initializer(_backend : &@system.Backend) -> Unit {
  // Create FPS text entity
  let entity = @system.Entity::new()
  @position.positions.set(entity, @position.Position(@math.Vec2D(10.0, 25.0)))
  let sprite = @sprite.Sprite::new_text(fps_box, @ui.UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)

  // Add to UI entities so it's not affected by camera movement
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
pub fn fps_display_system(backend : &@system.Backend) -> Unit {
  let fps = backend.get_fps()
  let fps_text = "FPS: " + fps.to_uint().to_string()
  fps_box.content = fps_text
}
