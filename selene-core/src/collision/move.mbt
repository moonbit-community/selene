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
/// Move all entities with velocity, modify positions and handle collisions.
/// Note: 1. This system should be run after any acceleration system.
///       2. This system will query a quadtree to find collisions.
///       3. This system will update velocities of entities when they collide.
/// 
pub fn move_system(_backend : &@system.Backend) -> Unit {
  collision_infos.clear()
  for e, vel in @velocity.velocities {
    guard e.is_alive() else { continue }
    if collides.get(e) is Some(collide) {
      move_with_collide(e, collide, vel.0)
    } else {
      move_without_collide(e, vel.0)
    }
  }
}

///| 
fn move_without_collide(e : @system.Entity, velocity : @math.Vec2D) -> Unit {
  guard @position.positions.get(e) is Some(pos)
  let new_pos = @math.Vec2D(pos.0[X] + velocity[X], pos.0[Y] + velocity[Y])
  @position.positions.set(e, new_pos)
}

///|
fn move_with_collide(
  e : @system.Entity,
  collide : Collider,
  velocity : @math.Vec2D,
) -> Unit {
  guard @position.positions.get(e) is Some(pos)
  guard shapes.get(e) is Some(shape)
  guard shape is Rect(size=Vec2D(width, height), offset~)
  let box = @math.Rect::{
    position: pos.0 + offset,
    size: @math.Vec2D(width, height),
  }
  let new_x = move_axis(e, box, velocity, X, collide.mask)
  let object_x = @math.Rect::{ size: box.size, position: new_x.0 }
  let new_y = move_axis(e, object_x, new_x.1, Y, collide.mask)
  @position.positions.set(e, new_y.0 - offset)
  real_velocities.set(e, new_y.1)
}

///|
pub let real_velocities : Map[@system.Entity, @velocity.Velocity] = Map::new()

///|
fn make_ray_collision(
  object : @math.Rect,
  speed : Double,
  axis : @math.Axis,
) -> @math.Rect {
  let pos = @math.Vec2D(object.position[X], object.position[Y])
  let size = @math.Vec2D(object.size[X], object.size[Y])
  if speed >= 0 {
    { position: pos, size: size.update(axis, size[axis] + speed) }
  } else {
    {
      position: pos.update(axis, pos[axis] + speed),
      size: size.update(axis, size[axis] - speed),
    }
  }
}

///| Move object with velocity, returns the destination and updated velocity.
fn move_axis(
  entity : @system.Entity,
  object : @math.Rect,
  velocity : @math.Vec2D,
  axis : @math.Axis,
  mask : CollisionMask,
) -> (@math.Vec2D, @math.Vec2D) {
  let ray_collision = make_ray_collision(object, velocity[axis], axis)
  let mut new_pos = @math.Vec2D(object.position[X], object.position[Y])
  new_pos = new_pos.update(axis, new_pos[axis] + velocity[axis])
  let mut new_velocity = velocity
  let entities = quadtree_query(ray_collision)
  for e in entities {
    guard e.is_alive() else { continue }
    guard e != entity else { continue }
    guard collides.get(e) is Some(collision) else { continue }
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~) else { continue }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard collision.active else { continue }
    guard mask.contains(collision.layer) else { continue }
    let collision_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: pos.0 + offset,
    }
    if object.intersects(collision_box) {
      let movement = aabb_resolve(object, collision_box)
      new_pos = new_pos + movement
      let dir = @math.Vec2D::zero().update(
        axis,
        if movement[axis] > 0.0 {
          1.0
        } else {
          -1.0
        },
      )
      add_collision_info(entity, e, dir)
      return (new_pos, movement)
    }
    if @math.Rect::intersects(ray_collision, collision_box) {
      let mut dir = @math.Vec2D(0, 0)
      if new_velocity[axis] > 0 {
        new_pos = new_pos.update(
          axis,
          collision_box.position[axis] - object.size[axis],
        )
        new_velocity = new_velocity.update(
          axis,
          new_pos[axis] - object.position[axis],
        )
        dir = dir.update(axis, 1.0)
      } else if new_velocity[axis] < 0 {
        new_pos = new_pos.update(
          axis,
          collision_box.position[axis] + collision_box.size[axis],
        )
        new_velocity = new_velocity.update(
          axis,
          new_pos[axis] - object.position[axis],
        )
        dir = dir.update(axis, -1.0)
      }
      add_collision_info(entity, e, dir)
    }
  }
  return (new_pos, new_velocity)
}

///|
fn aabb_resolve(a : @math.Rect, b : @math.Rect) -> @math.Vec2D {
  let a_center = a.position + a.size.mul_scalar(0.5)
  let b_center = b.position + b.size.mul_scalar(0.5)
  let a_half = a.size.mul_scalar(0.5)
  let b_half = b.size.mul_scalar(0.5)
  let delta = b_center - a_center
  let intersect = @math.Vec2D(
    delta[X].abs() - (b_half[X] + a_half[X]),
    delta[Y].abs() - (b_half[Y] + a_half[Y]),
  )
  if intersect[X] > intersect[Y] {
    if delta[X] > 0 {
      @math.Vec2D(intersect[X], 0.0)
    } else {
      @math.Vec2D(-intersect[X], 0.0)
    }
  } else if delta[Y] > 0 {
    @math.Vec2D(0.0, intersect[Y])
  } else {
    @math.Vec2D(0.0, -intersect[Y])
  }
}

///|
test "AABB resolve" {
  let a = @math.Rect::{ position: @math.Vec2D(0, 0), size: @math.Vec2D(32, 32) }
  let b = @math.Rect::{
    position: @math.Vec2D(16, 16),
    size: @math.Vec2D(32, 32),
  }
  let movement = aabb_resolve(a, b)
  inspect(movement, content="Vec2D(0, -16)")
}
