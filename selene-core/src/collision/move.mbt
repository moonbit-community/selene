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

///| Move all entities with velocity, and handle collisions.
/// Note: 1. This system should be run after any acceleration system.
///       2. This system will query a quadtree to find collisions.
///       3. This system will update velocities of entities when they collide.
pub fn move_system(_backend : &@system.Backend) -> Unit {
  for e in @system.all_entities {
    guard collides.get(e) is Some(collide) else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard collide.shape is Rect(size={ x: width, y: height }, offset~)
    let box = @math.Rect::{
      position: pos.inner() + offset,
      size: @math.Vec2D::new(width, height),
    }
    quadtree_root.insert(e, box)
  }
  collision_infos.clear()
  for e in @system.all_entities {
    guard @velocity.velocities.get(e) is Some(vel) else { continue }
    if collides.get(e) is Some(collide) {
      move_with_collide(e, collide, vel.inner())
    } else {
      move_without_collide(e, vel.inner())
    }
  }
}

///|
fn move_without_collide(e : @system.Entity, velocity : @math.Vec2D) -> Unit {
  guard @position.positions.get(e) is Some(pos)
  let new_pos = @math.Vec2D::new(pos.x + velocity.x, pos.y + velocity.y)
  @position.positions.set(e, new_pos)
  if areas.get(e) is Some(area) {
    guard area.shape is Rect(size={ x: width, y: height }, offset~)
    let box = @math.Rect::{
      position: new_pos + offset,
      size: @math.Vec2D::new(width, height),
    }
    let old_box = @math.Rect::{
      position: pos.inner(),
      size: @math.Vec2D::new(width, height),
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
  guard collide.shape is Rect(size={ x: width, y: height }, offset~)
  let box = @math.Rect::{
    position: pos.inner() + offset,
    size: @math.Vec2D::new(width, height),
  }
  let new_pos_x = move_axis(e, box, velocity, X, collide.mask)
  let object_x = @math.Rect::{ size: box.size, position: new_pos_x }
  let new_pos = move_axis(e, object_x, velocity, Y, collide.mask)
  @position.positions.set(e, new_pos)
  let new_box = @math.Rect::{ size: box.size, position: new_pos }
  quadtree_root.remove(e, box)
  quadtree_root.insert(e, new_box)
}

///|
fn make_ray_collision(
  object : @math.Rect,
  velocity : @math.Vec2D,
  axis : @math.Axis,
) -> @math.Rect {
  let pos : @math.Vec2D = { x: object.position.x, y: object.position.y }
  let size : @math.Vec2D = { x: object.size.x, y: object.size.y }
  if velocity[axis] >= 0 {
    size[axis] = size[axis] + velocity[axis]
  } else {
    pos[axis] = pos[axis] + velocity[axis]
    size[axis] = size[axis] - velocity[axis]
  }
  { position: pos, size }
}

///| Move object with velocity, returns the destination and whether collided
fn move_axis(
  entity : @system.Entity,
  object : @math.Rect,
  velocity : @math.Vec2D,
  axis : @math.Axis,
  mask : CollisionMask,
) -> @math.Vec2D {
  let new_pos = @math.Vec2D::new(object.position.x, object.position.y)
  new_pos[axis] = new_pos[axis] + velocity[axis]
  let velocity_axis = @math.Vec2D::new(0, 0)
  velocity_axis[axis] = velocity[axis]
  let ray_collision = make_ray_collision(object, velocity_axis, axis)
  let entities = quadtree_root.query(ray_collision)
  for e in entities.intersection(@system.all_entities) {
    guard e != entity else { continue }
    guard collides.get(e) is Some(collision) else { continue }
    guard collision.shape is Rect(size={ x: width, y: height }, offset~) else {
      continue
    }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard mask.contains(collision.layer) else { continue }
    let collision_box = @math.Rect::{
      size: @math.Vec2D::new(width, height),
      position: pos.inner() + offset,
    }
    if @math.Rect::intersects(ray_collision, collision_box) {
      let dir = @math.Vec2D::new(0, 0)
      if velocity[axis] > 0 {
        new_pos[axis] = collision_box.position[axis] - object.size[axis]
        velocity[axis] = new_pos[axis] - object.position[axis]
        dir[axis] = 1
      } else if velocity[axis] < 0 {
        new_pos[axis] = collision_box.position[axis] + collision_box.size[axis]
        velocity[axis] = new_pos[axis] - object.position[axis]
        dir[axis] = -1
      }
      add_collision_info(entity, e, dir)
    }
  }
  return new_pos
}
