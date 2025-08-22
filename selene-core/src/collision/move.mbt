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
  for e, collide in collides {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard collide.shape is Rect(size=Vec2D(width, height), offset~)
    let box = @math.Rect::{
      position: pos.0 + offset,
      size: @math.Vec2D(width, height),
    }
    quadtree_root.insert(e, box)
  }
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
  if areas.get(e) is Some(area) {
    guard area.shape is Rect(size=Vec2D(width, height), offset~)
    let box = @math.Rect::{
      position: new_pos + offset,
      size: @math.Vec2D(width, height),
    }
    let old_box = @math.Rect::{
      position: pos.0,
      size: @math.Vec2D(width, height),
    }
    quadtree_root.remove(e, old_box)
    quadtree_root.insert(e, box)
  }
}

///|
fn move_with_collide(
  e : @system.Entity,
  collide : Collide,
  velocity : @math.Vec2D,
) -> Unit {
  guard @position.positions.get(e) is Some(pos)
  guard collide.shape is Rect(size=Vec2D(width, height), offset~)
  let box = @math.Rect::{
    position: pos.0 + offset,
    size: @math.Vec2D(width, height),
  }
  let new_x = move_axis(e, box, velocity, X, collide.mask)
  let object_x = @math.Rect::{ size: box.size, position: new_x.0 }
  let new_y = move_axis(e, object_x, new_x.1, Y, collide.mask)
  @position.positions.set(e, new_y.0 - offset)
  @velocity.velocities.set(e, new_y.1)
  let new_box = @math.Rect::{ size: box.size, position: new_y.0 }
  quadtree_root.remove(e, box)
  quadtree_root.insert(e, new_box)
}

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
  let entities = quadtree_root.query(ray_collision)
  for e in entities {
    guard e.is_alive() else { continue }
    guard e != entity else { continue }
    guard collides.get(e) is Some(collision) else { continue }
    guard collision.shape is Rect(size=Vec2D(width, height), offset~) else {
      continue
    }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard mask.contains(collision.layer) else { continue }
    let collision_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: pos.0 + offset,
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
