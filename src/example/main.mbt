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
  let app = @selene.App::new(@canvas.CanvasBackend::new())
    .with_canvas_width(512.0)
    .with_canvas_height(256.0)
    .add_initializer(game_start)
    .add_plugin(@selene.default_plugin)
    .add_system(game_loop)
  app.run()
}

///|
fn game_loop(_ : &@selene.Backend) -> Unit {

}

///|
fn game_start(_ : &@selene.Backend) -> Unit {
  // Add a background to the game
  let background = @selene.Entity::new()
  @selene.fill_rects.set(background, {
    size: @selene.Vec2D::new(1024.0, 256.0),
    tile_path: "/pixel_adventure/Background/Gray.png",
  })
  @selene.positions.set(background, @selene.Vec2D::new(0, 0))

  // Add a player character
  let player = @selene.Entity::new()
  let maskdude = "/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png"
  let animation = @selene.Animation::new(
    "MaskDudeIdle",
    maskdude,
    max_frame=11,
    height=32.0,
    width=32.0,
  )
  @selene.animations.set(player, animation)
  @selene.controls.set(player, @selene.Control::{  })
  @selene.velocities.set(player, @selene.Vec2D::new(0.0, 0.0))
  @selene.positions.set(player, @selene.Vec2D::new(0.0, 224.0))
}
