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
/// Component that determines whether an entity can participate in collision
/// detection and which other entities it can collide with.
///
/// Fields:
///
/// * `active` : Whether collision detection is enabled for this collider. When
///   `false`, the entity will not participate in collision detection.
/// * `mask` : Collision mask defining which collision layers this collider can
///   interact with during collision detection.
///
/// Example:
///
/// ```moonbit
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::new([layer])
/// let collider = @collision.Collider::new(mask)
/// inspect(collider.active, content="true")
/// collider.active = false
/// inspect(collider.active, content="false")
/// ```
///
pub(all) struct Collider {
  mut active : Bool
  mask : CollisionMask
}

///|
/// Creates a new collider with the specified collision mask.
///
/// Parameters:
///
/// * `mask` : The collision mask that defines which collision layers this
///   collider can interact with during collision detection.
///
/// Returns a new `Collider` instance with collision detection enabled by
/// default.
///
/// Example:
///
/// ```moonbit
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::new([layer])
/// let collider = @collision.Collider::new(mask)
/// inspect(collider.active, content="true")
/// ```
///
pub fn Collider::new(mask : CollisionMask) -> Collider {
  { active: true, mask }
}

///|
/// Global storage for all collider components in the collision system.
///
/// This map stores the association between entities and their collider
/// components. Each entity that participates in collision detection must have
/// an entry in this map. The collision system uses this map to determine which
/// entities can collide with each other based on their collision masks and
/// layers.
///
/// Do not manually modify this map directly. Instead, use the collision
/// system's APIs to add, remove, or modify colliders for entities. The
/// collision detection systems automatically query this map during collision
/// processing.
///
/// Example:
///
/// ```moonbit
/// // Check if an entity has a collider
/// let entity = @entity.Entity::new()
/// defer entity.destroy()
/// if @collision.colliders.contains(entity) {
///   let collider = @collision.colliders.get(entity).unwrap()
///   inspect(collider.active)
/// }
/// ```
///
pub let colliders : Map[@entity.Entity, Collider] = Map::new()

///|
/// The collision info represents information about a collision event.
/// 
pub struct CollisionInfo {
  entity : @entity.Entity
  direction : @math.Vec2D
}

///|
/// `@collision.collision_infos.get(ENTITY)` is an array of `CollisionInfo`
/// objects that represent the collisions of the entity with other entities.
/// Do not manually modify this map; it is managed by the collision system.
/// 
let collision_infos : Map[@entity.Entity, Array[CollisionInfo]] = Map::new()

///|
fn add_collision_info(
  entity : @entity.Entity,
  target : @entity.Entity,
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
pub fn get_collision_infos(entity : @entity.Entity) -> Array[CollisionInfo] {
  collision_infos.get(entity).unwrap_or_default()
}

///|
/// Checks if the entity is on the floor. 
/// Returns `true` if the entity is colliding with the floor,
/// which is defined as having a collision direction with a positive Y component.
/// 
pub fn is_on_floor(entity : @entity.Entity) -> Bool {
  let infos = get_collision_infos(entity)
  for info in infos {
    if info.direction[Y] > 0 {
      return true
    }
  }
  return false
}
