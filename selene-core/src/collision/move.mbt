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
///       2. This system will set real_velocities of entities.
///
pub fn move_system(delta : Double) -> Unit {
  collision_infos.clear()
  let world_index = build_world_rapier_index()
  for e, vel in @velocity.velocities {
    guard e.is_alive() else { continue }
    if colliders.get(e) is Some(collider) && collider.active {
      let new_vel = move_with_collide(
        e,
        collider,
        vel.0.scalar_mul(delta),
        world_index,
      )
      if delta.abs() < 0.000000001 {
        real_velocities.set(e, vel.0)
      } else {
        real_velocities.set(e, new_vel.scalar_div(delta))
      }
    } else {
      move_without_collide(e, vel.0.scalar_mul(delta))
      real_velocities.set(e, vel.0)
    }
  }
}

///|
fn move_without_collide(e : @entity.Entity, velocity : @math.Vec2D) -> Unit {
  guard @position.positions.get(e) is Some(pos)
  let new_pos = @math.Vec2D(pos.0[X] + velocity[X], pos.0[Y] + velocity[Y])
  @position.positions.set(e, new_pos)
}

///|
fn move_with_collide(
  e : @entity.Entity,
  collider : Collider,
  velocity : @math.Vec2D,
  world_index : RapierSpatialIndex,
) -> @math.Vec2D {
  guard @position.positions.get(e) is Some(pos)
  guard shapes.get(e) is Some(shape)
  guard shape is Rect(size=Vec2D(width, height), offset~)
  let object = @math.Rect::{
    position: pos.0 + offset,
    size: @math.Vec2D(width, height),
  }
  let new_x = move_axis(e, object, velocity, X, collider.filter, world_index)
  let object_x = @math.Rect::{ size: object.size, position: new_x.0 }
  let new_y = move_axis(e, object_x, new_x.1, Y, collider.filter, world_index)
  @position.positions.set(e, new_y.0 - offset)
  new_y.1
}

///|
/// Stores the actual velocities of entities after collision resolution.
///
/// This global map tracks the real velocities of entities that have been
/// processed by the collision system. When an entity moves with collision
/// detection enabled, its velocity may be modified due to collisions with other
/// entities. The original velocity from the velocity component represents the
/// intended movement, while this map stores the actual velocity that was
/// applied after accounting for collisions and obstacles.
///
/// The real velocities are calculated by dividing the actual displacement by
/// the delta time, providing the effective velocity that the entity experienced
/// during the frame. This information is useful for other systems that need to
/// know how entities actually moved, rather than how they intended to move.
///
/// The map is automatically populated by the `move_system` function during
/// collision processing and should be considered read-only for other systems.
///
pub let real_velocities : Map[@entity.Entity, @velocity.Velocity] = Map::new()

///|
const RAPIER_CAST_EPSILON = 0.001

///|
fn can_collide_with(mask : CollisionFilter, target : @entity.Entity) -> Bool {
  if colliders.get(target) is Some(collider) {
    collider.active && mask.matches_group(collider.filter.group)
  } else {
    false
  }
}

///|
/// Move object with velocity, returns the destination and updated velocity.
fn move_axis(
  entity : @entity.Entity,
  object : @math.Rect,
  velocity : @math.Vec2D,
  axis : @math.Axis,
  mask : CollisionFilter,
  world_index : RapierSpatialIndex,
) -> (@math.Vec2D, @math.Vec2D) {
  let speed = velocity[axis]
  let mut new_pos = @math.Vec2D(object.position[X], object.position[Y])
  let mut new_velocity = velocity
  if speed.abs() <= 0.000000001 {
    return (new_pos, new_velocity)
  }
  let mut motion = @math.Vec2D::zero()
  motion = motion.update(axis, speed)
  if rapier_cast_rect(world_index, entity, object, motion, fn(target) {
      can_collide_with(mask, target)
    })
    is Some((target, toi)) {
    let safe_toi = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, toi - RAPIER_CAST_EPSILON),
    )
    let moved = speed * safe_toi
    new_pos = new_pos.update(axis, new_pos[axis] + moved)
    new_velocity = new_velocity.update(axis, moved)
    let mut dir = @math.Vec2D::zero()
    dir = dir.update(axis, if speed > 0.0 { 1.0 } else { -1.0 })
    add_collision_info(entity, target, dir)
    return (new_pos, new_velocity)
  }
  new_pos = new_pos.update(axis, new_pos[axis] + speed)
  (new_pos, new_velocity)
}
