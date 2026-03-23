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
  let background = @entity.Entity::new()
  let background_sprite = @sprite.Sprite::from_picture(
    @sprite.Picture::new(size, background_picture, repeat=Repeat),
  )
  @sprite.sprites().set(background, background_sprite)
  @transform.transforms().set(
    background,
    @transform.Transform::from_xyz(0.0, 0.0, GROUND_ZINDEX.to_double()),
  )
}

///|
fn add_border(size : @math.Vec2D) -> Unit {
  fn add_one_border(pos : @math.Vec2D, size : @math.Vec2D) -> Unit {
    let entity = @entity.Entity::new()
    let collider = @physics2d.Collider::new(
      @physics2d.CollisionFilter::empty(wall_collision_group),
    )
    @physics2d.colliders().set(entity, collider)
    @physics2d.shapes().set(
      entity,
      @physics2d.CollisionShape::Rect(size~, offset=Vec2D(0.0, 0.0)),
    )
    @transform.transforms().set(
      entity,
      @transform.Transform::from_xyz(pos[X], pos[Y], 0.0),
    )
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
        let grass = @entity.Entity::new()
        let sprite = @sprite.Sprite::from_animation(grass_sprite)
        @sprite.sprites().set(grass, sprite)
        ignore(install_sprite_animation_player(grass, grass_sprite))
        @transform.transforms().set(
          grass,
          @transform.Transform::from_xyz(
            x.to_double() * 16.0,
            y.to_double() * 16.0,
            GRASS_ZINDEX.to_double(),
          ),
        )
      }
    }
  }
}
