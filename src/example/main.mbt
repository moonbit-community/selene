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
    .add_plugin(@plugins.default_plugin)
    .add_initializer(game_start)
    .add_system(@input.simple_input_system)
    .add_system(game_loop)
    .add_render_pipe(@collision.quadtree_render_system, priority=0)
  app.run()
}

///|
fn game_loop(_ : &@system.Backend) -> Unit {

}

///|
fn game_start(_ : &@system.Backend) -> Unit {
  add_background()
  add_player()
  add_rock(@math.Vec2D::new(96.0, 240.0))
  add_rock(@math.Vec2D::new(112.0, 240.0))
}

///|
fn add_background() -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    {
      size: @math.Vec2D::new(1024.0, 256.0),
      tile_path: "/pixel_adventure/Background/Gray.png",
      repeat: true,
    },
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D::new(0, 0))
}

///|
fn add_player() -> Unit {
  let player = @system.Entity::new()
  let maskdude = "/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png"
  let animation = @sprite.Animation::new(
    maskdude,
    max_frame=11,
    height=32.0,
    width=32.0,
  )
  let player_sprite = @sprite.Sprite::new_animation(animation, 10)
  @sprite.sprites.set(player, player_sprite)
  @input.controls.set(player, @input.KeyInput::{  })
  @velocity.velocities.set(player, @math.Vec2D::new(0.0, 0.0))
  @position.positions.set(player, @math.Vec2D::new(0.0, 224.0))
  @collision.collides.set(player, @collision.Collide::{
    shape: Rect(width=32.0, height=32.0),
    layer: player_collision_layer,
    mask: player_collision_mask,
  })
}

///|
fn add_rock(pos : @math.Vec2D) -> Unit {
  let rock_sprite = "pixel_adventure/Terrain/Terrain (16x16).png"
  let rock = @system.Entity::new()
  let animation = @sprite.Animation::new(
    rock_sprite,
    max_frame=1,
    height=16.0,
    width=16.0,
    offset=@math.Vec2D::new(208.0, 16.0),
  )
  let rock_sprite = @sprite.Sprite::new_animation(animation, 20)
  @sprite.sprites.set(rock, rock_sprite)
  @position.positions.set(rock, pos)
  @collision.collides.set(rock, @collision.Collide::{
    shape: Rect(width=16.0, height=16.0),
    layer: terrain_collision_layer,
    mask: @collision.CollisionMask::empty(),
  })
}
