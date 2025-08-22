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
let bird_fly_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "pixel_adventure/Enemies/BlueBird/Flying (32x32).png",
    9,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
)

///|
let bird_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "pixel_adventure/Enemies/BlueBird/Hit (32x32).png",
    5,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
)

///|
const BIRD_SPEED = 1.5

///|
struct Bird {
  mut direction : Direction2
  mut is_hurt : Bool
}

///|
let birds : Map[@system.Entity, Bird] = Map::new()

///|
fn add_bird(pos : @math.Vec2D) -> Unit {
  let entity = @system.Entity::new()
  let bird_sprite = @sprite.Sprite::new_animation(bird_fly_animation, 10)
  @sprite.sprites.set(entity, bird_sprite)
  @velocity.velocities.set(entity, @math.Vec2D(BIRD_SPEED, 0.0))
  @position.positions.set(entity, pos)
  @collision.shapes.set(
    entity,
    Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
  )
  @collision.collides.set(
    entity,
    @collision.Collider::new(enemy_collision_layer, enemy_collision_mask),
  )
  birds[entity] = Bird::{ direction: Right, is_hurt: false }
}

///|
fn bird_ai_system(_backend : &@system.Backend) -> Unit {
  for e, bird in birds {
    guard e.is_alive() else { continue }
    guard @velocity.velocities.get(e) is Some(_velocity)
    if @sprite.is_animation_finished(e) {
      e.destroy()
      continue
    }
    if bird.is_hurt {
      @velocity.velocities[e] = @math.Vec2D::zero()
      guard @collision.collides.get(e) is Some(collider)
      collider.active = false
      match bird.direction {
        Left =>
          @sprite.play_animation(
            e,
            bird_hit_animation,
            transform=@math.Transform::new(),
          )
        Right =>
          @sprite.play_animation(
            e,
            bird_hit_animation,
            transform=@math.Transform::flip_x(32.0),
          )
      }
      continue
    }
    let collision_infos = @collision.get_collision_infos(e)
    let hit_wall = collision_infos
      .iter()
      .any(fn(info) {
        (info.direction[X] > 0.0 && bird.direction is Right) ||
        (info.direction[X] < 0.0 && bird.direction is Left)
      })
    if hit_wall {
      bird.direction = match bird.direction {
        Left => Right
        Right => Left
      }
    }
    match bird.direction {
      Left => {
        @velocity.velocities[e] = @math.Vec2D(-BIRD_SPEED, 0.0)
        @sprite.play_animation(
          e,
          bird_fly_animation,
          transform=@math.Transform::new(),
        )
      }
      Right => {
        @velocity.velocities[e] = @math.Vec2D(BIRD_SPEED, 0.0)
        @sprite.play_animation(
          e,
          bird_fly_animation,
          transform=@math.Transform::flip_x(32.0),
        )
      }
    }
  }
}
