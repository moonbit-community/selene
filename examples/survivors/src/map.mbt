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
fn add_background(size : @math.Vec2D) -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::from_picture(
    @sprite.Picture::new(size, background_picture, repeat=Repeat),
    GROUND_ZINDEX,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D(0, 0))
}

///|
fn add_border(size : @math.Vec2D) -> Unit {
  fn add_one_border(pos : @math.Vec2D, size : @math.Vec2D) -> Unit {
    let entity = @system.Entity::new()
    @collision.collision_layers.set(entity, wall_collision_layer)
    let collider = @collision.Collider::new(@collision.CollisionMask::empty())
    @collision.colliders.set(entity, collider)
    @collision.shapes.set(
      entity,
      @collision.CollisionShape::Rect(size~, offset=Vec2D(0.0, 0.0)),
    )
    @position.positions.set(entity, pos)
  }

  add_one_border(Vec2D(-16.0, -16.0), Vec2D(size[X] + 32.0, 16.0))
  add_one_border(Vec2D(-16.0, 0), Vec2D(16.0, size[Y]))
  add_one_border(Vec2D(-16.0, size[Y]), Vec2D(size[X] + 32.0, 16.0))
  add_one_border(Vec2D(size[X], 0), Vec2D(16.0, size[Y]))
}

///|
fn add_grass() -> Unit {
  let density = 0.05
  let rand = @random.Rand::new()
  for x in 0..<(MAP_WIDTH / 16.0).to_int() {
    for y in 0..<(MAP_HEIGHT / 16.0).to_int() {
      if rand.double() < density {
        let grass = @system.Entity::new()
        let sprite = @sprite.Sprite::from_animation(grass_sprite, GRASS_ZINDEX)
        @sprite.sprites.set(grass, sprite)
        @position.positions.set(
          grass,
          Vec2D(x.to_double() * 16.0, y.to_double() * 16.0),
        )
      }
    }
  }
}
