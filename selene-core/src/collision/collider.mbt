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
/// Collision detector component for entities in the physics system.
///
/// Collider components define how entities interact with other entities in the
/// collision detection system. Each collider has a collision layer that
/// determines what it is, a collision mask that determines what it can collide
/// with, and an active flag to enable or disable collision detection.
///
/// Fields:
///
/// * `active` : Whether collision detection is enabled for this collider.
/// * `layer` : The collision layer this collider belongs to.
/// * `mask` : The collision mask defining which layers this collider can
///   interact with.
///
/// Example:
///
/// ```notest
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::new([layer])
/// let collider = @collision.Collider::new(layer, mask)
///
/// // Access fields
/// inspect(collider.active, content="true")
/// println("Layer: \{collider.layer}")
/// println("Mask layers: \{collider.mask.inner().length()}")
///
/// // Modify active state
/// collider.active = false
/// ```
///
pub(all) struct Collider {
  mut active : Bool
  mask : CollisionMask
}

///|
/// Creates a new collider with the specified collision layer and mask.
///
/// Parameters:
///
/// * `layer` : The collision layer this collider belongs to, determining what
///   category of collision object this is.
/// * `mask` : The collision mask defining which collision layers this collider
///   can interact with.
///
/// Returns a new `Collider` instance with collision detection enabled by
/// default.
///
/// Example:
///
/// ```notest
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::new([layer])
/// let collider = @collision.Collider::new(layer, mask)
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
/// ```notest
/// // Check if an entity has a collider
/// let entity = @system.Entity::new()
/// if @collision.colliders.contains(entity) {
///   let collider = @collision.colliders.get(entity).unwrap()
///   println("Entity has collider with active status: \{collider.active}")
/// }
/// ```
///
pub let colliders : Map[@system.Entity, Collider] = Map::new()

///|
/// The collision info represents information about a collision event.
/// 
pub struct CollisionInfo {
  entity : @system.Entity
  direction : @math.Vec2D
}

///|
/// `@collision.collision_infos.get(ENTITY)` is an array of `CollisionInfo`
/// objects that represent the collisions of the entity with other entities.
/// Do not manually modify this map; it is managed by the collision system.
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
