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
    "assets/pixeladventure/Enemies/BlueBird/Flying (32x32).png",
    9,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let bird_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
    5,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
  fps=12,
)

///|
const BIRD_SPEED = 90.0

///|
priv struct Bird {
  mut direction : Direction2
  mut is_hurt : Bool
}

///|
let birds : Map[@entity.Entity, Bird] = Map::new()

///|
fn add_bird(pos : @math.Vec2D) -> Unit {
  let entity = @entity.Entity::new()
  let bird_sprite = @sprite.Sprite::from_animation(bird_fly_animation, 10)
  @sprite.sprites.set(entity, bird_sprite)
  @velocity.velocities.set(entity, @math.Vec2D(BIRD_SPEED, 0.0))
  @position.positions.set(entity, pos)
  @collision.shapes.set(
    entity,
    Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
  )
  @collision.colliders.set(
    entity,
    @collision.Collider::new(
      @collision.CollisionFilter::new(enemy_collision_group, [
        terrain_collision_group,
      ]),
    ),
  )
  birds[entity] = Bird::{ direction: Right, is_hurt: false }
}

///|
fn bird_ai_system(_ : Double) -> Unit {
  for e, bird in birds {
    guard e.is_alive() else { continue }
    guard @velocity.velocities.get(e) is Some(_velocity)
    let resolved_x = @collision.resolved_velocities
      .get(e)
      .map_or(0.0, fn(v) { v.0[X] })
    if @sprite.is_animation_finished(e) {
      e.destroy()
      continue
    }
    if bird.is_hurt {
      @velocity.velocities[e] = @math.Vec2D::zero()
      if @collision.colliders.get(e) is Some(collider) {
        collider.active = false
      }
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
    let hit_wall = @collision.contact_events()
      .iter()
      .any(fn(event) {
        event.entity == e &&
        event.started &&
        (
          (event.direction[X] > 0.0 && bird.direction is Right) ||
          (event.direction[X] < 0.0 && bird.direction is Left)
        )
      })
    // For merged/static terrain colliders, contact direction can be noisy.
    // Use resolved X movement as a robust "blocked" signal.
    let blocked = match bird.direction {
      Left => resolved_x > -BIRD_SPEED * 0.5
      Right => resolved_x < BIRD_SPEED * 0.5
    }
    if hit_wall || blocked {
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
