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
fn add_rock(pos : @math.Vec2D) -> Unit {
  let rock_sprite = "/pixel_adventure/Terrain/Terrain (16x16).png"
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

///|
fn add_rocks() -> Unit {
  for i in 0..<16 {
    let pos = @math.Vec2D::new(16.0 * i.to_double(), 240.0)
    add_rock(pos)
  }
}
