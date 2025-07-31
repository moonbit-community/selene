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
    .add_initializer(game_start)
    .add_plugin(@plugins.default_plugin)
    .add_system(@input.input_system)
    .add_system(game_loop)
  app.run()
}

///|
fn game_loop(_ : &@system.Backend) -> Unit {
}

///|
fn game_start(_ : &@system.Backend) -> Unit {
  // Add a background to the game
  let background = @system.Entity::new()
  @sprite.fill_rects.set(background, {
    size: @math.Vec2D::new(1024.0, 256.0),
    tile_path: "/pixel_adventure/Background/Gray.png",
  })
  @position.positions.set(background, @math.Vec2D::new(0, 0))

  // Add a player character
  let player = @system.Entity::new()
  let maskdude = "/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png"
  let animation = @sprite.Animation::new(
    "MaskDudeIdle",
    maskdude,
    max_frame=11,
    height=32.0,
    width=32.0,
  )
  @sprite.animations.set(player, animation)
  @input.controls.set(player, @input.KeyInput::{  })
  @move.velocities.set(player, @math.Vec2D::new(0.0, 0.0))
  @position.positions.set(player, @math.Vec2D::new(0.0, 224.0))
}
