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
fn main {
  let app = @system.App::new(@canvas.CanvasBackend::new())
    .with_canvas_width(512.0)
    .with_canvas_height(256.0)
    .with_fps(120)
    .with_physical_fps(120)
    .add_plugin(@plugins.default_plugin)
    .add_initializer(game_start)
    // .add_system(@input.simple_input_system)
    // .add_system(@acceleration.accelerate_system, priority=60)
    .add_system(player_state_system, priority=150)
    .add_render_pipe(@collision.quadtree_render_system)
    .add_render_pipe(show_result_pipe, priority=0)
  app.run()
}

///|
fn game_start(_ : &@system.Backend) -> Unit {
  add_background()
  add_player()
  add_rocks()
  add_abyss()
  add_flag()
}

///|
fn add_background() -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D::new(1024.0, 256.0),
      "/pixel_adventure/Background/Gray.png",
      repeat=true,
    ),
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D::new(0, 0))
}
