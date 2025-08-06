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

const WORLD_WIDTH : Double = 560.0
const WORLD_HEIGHT : Double = 432.0

///|
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(WORLD_WIDTH)
  .with_canvas_height(WORLD_HEIGHT)
  .with_fps(120)
  .add_plugin(@plugins.default_plugin)
  .add_initializer(game_start)
  // .add_system(@input.simple_input_system)
  // .add_system(@acceleration.accelerate_system, priority=60)
  .add_system(player_state_system, priority=150)
  // .add_system(@collision.quadtree_render_system, priority=-10)
  .run()
}

///|
fn game_start(_ : &@system.Backend) -> Unit {
  add_background(@math.Vec2D::new(WORLD_WIDTH, WORLD_HEIGHT))
  generate_map()
  // add_abyss()
  add_result_box()
  add_score_box()
}

///|
fn add_background(size : @math.Vec2D) -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      size,
      "pixel_adventure/Background/Gray.png",
      repeat=true,
    ),
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D::new(0, 0))
}
