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
pub fn move_with_collide_system(_backend : &@system.Backend) -> Unit {
  let new_quadtree = QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(GAME_WIDTH, GAME_HEIGHT),
    0,
  )
  for e, collide in collides {
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard @move.velocities.get(e) is Some(velocity) else { continue }
    guard collide.shape is Rect(width~, height~)
    let box = @math.Rect::{
      position: pos.inner(),
      size: @math.Vec2D::new(width, height),
    }
    let (new_pos_x, collide_x) = move_axis(
      e,
      box,
      velocity.inner(),
      X,
      collide.mask,
    )
    let object_x = @math.Rect::{ size: box.size, position: new_pos_x }
    let (new_pos, collide_y) = move_axis(
      e,
      object_x,
      velocity.inner(),
      Y,
      collide.mask,
    )
    let _collide = collide_x || collide_y
    @position.positions.set(e, new_pos)
    new_quadtree.insert(e)
  }
  quadtree.val = new_quadtree
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
) -> (@math.Vec2D, Bool) {
  let new_pos = @math.Vec2D::new(object.position.x, object.position.y)
  new_pos[axis] = new_pos[axis] + velocity[axis]
  let velocity_axis = @math.Vec2D::new(0, 0)
  velocity_axis[axis] = velocity[axis]
  let ray_collision = make_ray_collision(object, velocity_axis, axis)
  let entities = quadtree.val.query(ray_collision)
  for e in entities {
    guard e != entity else { continue }
    guard collides.get(e) is Some(collision) else { continue }
    guard collision.shape is Rect(width~, height~) else { continue }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard mask.contains(collision.layer) else { continue }
    let collision_box = @math.Rect::{
      position: pos.inner(),
      size: @math.Vec2D::new(width, height),
    }
    if @math.Rect::intersects(ray_collision, collision_box) {
      if velocity[axis] > 0 {
        new_pos[axis] = collision_box.position[axis] - object.size[axis]
      } else if velocity[axis] < 0 {
        new_pos[axis] = collision_box.position[axis] + collision_box.size[axis]
      }
      return (new_pos, true)
    }
  }
  return (new_pos, false)
}
