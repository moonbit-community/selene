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
/// The `Collide` struct represents a collision object in the game world.
pub(all) struct Collide {
  shape : CollisionShape
  layer : CollisionLayer
  mask : CollisionMask
}

///|
pub let collides : Map[@system.Entity, Collide] = Map::new()

///|
/// The collision info represents information about a collision event.
pub struct CollisionInfo {
  entity : @system.Entity
  direction : @math.Vec2D
}

///| 
/// `@collision.collision_infos[ENTITY]` is an array of `CollisionInfo`
/// objects that represent the collisions of the entity with other entities.
/// Do not manually modify this map, it is managed by the collision system.
/// 
let collision_infos : Map[@system.Entity, Array[CollisionInfo]] = Map::new()

///|
fn add_collision_info(
  entity : @system.Entity,
  target : @system.Entity,
  direction : @math.Vec2D,
) -> Unit {
  if collision_infos.get(entity) is None {
    collision_infos.set(entity, Array::new())
  }
  collision_infos.get(entity).unwrap().push({ entity: target, direction })
}

///|
/// Get all collision infos for a specific entity.
/// This function returns an empty array if there are no collision infos for the entity.
///
pub fn get_collision_infos(entity : @system.Entity) -> Array[CollisionInfo] {
  collision_infos.get(entity).unwrap_or_default()
}

///|
/// Checks if the entity is on the floor. 
/// Returns `true` if the entity is colliding with the floor,
/// which is defined as having a collision direction with a positive Y component.
/// 
pub fn is_on_floor(entity : @system.Entity) -> Bool {
  let infos = get_collision_infos(entity)
  for info in infos {
    if info.direction[Y] > 0 {
      return true
    }
  }
  return false
}
