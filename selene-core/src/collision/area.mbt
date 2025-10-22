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
/// FIXME: replace all callbacks with state access
struct Area {
  mask : CollisionMask
  on_enter_callbacks : Array[(@entity.Entity) -> Unit]
  on_exit_callbacks : Array[(@entity.Entity) -> Unit]
  mut contains : Set[@entity.Entity]
}

///|
/// Creates a new area with the specified collision mask.
///
/// Parameters:
///
/// * `mask` : The collision mask that determines which collision layers this
///   area will interact with.
///
/// Returns a new `Area` instance with an empty set of contained entities and no
/// registered callbacks.
///
/// Example:
///
/// ```moonbit
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(mask)
/// areas[@entity.Entity::new()] = area
/// ```
///
pub fn Area::new(mask : CollisionMask) -> Area {
  { mask, contains: Set::new(), on_enter_callbacks: [], on_exit_callbacks: [] }
}

///|
/// Global map that stores area components for entities in the collision system.
///
/// This map associates entity IDs with their corresponding `Area` components,
/// allowing the collision system to track which entities have area behavior and
/// manage area-specific collision detection and callbacks.
///
/// The map is used internally by the collision system to:
///
/// * Store area components when they are attached to entities
/// * Retrieve area information during collision detection
/// * Manage area enter/exit events and callbacks
///
/// Example:
///
/// ```moonbit
/// // Create an area and attach it to an entity
/// let entity = @entity.Entity::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(mask)
/// @collision.areas.set(entity, area)
///
/// // Later retrieve the area
/// guard @collision.areas.get(entity) is Some(_area)
/// ```
///
pub let areas : Map[@entity.Entity, Area] = Map::new()

///|
/// Retrieves the set of entities currently contained within the specified area
/// entity.
///
/// Parameters:
///
/// * `area` : The entity that has an area component attached to it.
///
/// Returns a `Set[@entity.Entity]` containing all entities currently within the
/// area. If the entity does not have an area component, returns an empty set.
///
/// Example:
///
/// ```moonbit
/// // Create an area entity and get its contained entities
/// let area_entity = @entity.Entity::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(mask)
/// @collision.areas.set(area_entity, area)
///
/// let contained_entities = @collision.get_contains(area_entity)
/// // contained_entities is now a Set of entities within the area
/// ignore(contained_entities)
/// ```
///
pub fn get_contains(area : @entity.Entity) -> Set[@entity.Entity] {
  areas.get(area).map_or(Set::new(), fn(area) { area.contains })
}

///|
/// Registers a callback function to be executed when an entity enters this
/// area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the entering entity as
///   its argument.
///
/// Example:
///
/// ```moonbit
/// let my_entity = @entity.Entity::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(mask)
/// area.on_enter(fn(entity) { println("Entity \{entity} entered the area!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_enter(self : Area, callback : (@entity.Entity) -> Unit) -> Unit {
  self.on_enter_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when an entity exits this area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the exiting entity as its
///   argument.
///
/// Example:
///
/// ```moonbit
/// let my_entity = @entity.Entity::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(mask)
/// area.on_exit(fn(entity) { println("Entity \{entity} left the area!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_exit(self : Area, callback : (@entity.Entity) -> Unit) -> Unit {
  self.on_exit_callbacks.push(callback)
}

///|
/// Processes area collision detection and triggers enter/exit callbacks for all
/// area entities in the collision system.
///
/// This system iterates through all entities with area components, performs
/// collision detection using a spatial quadtree query, and manages entity
/// enter/exit events. For each area entity, it:
///
/// 1. Queries the quadtree for potential colliding entities within the area's
/// bounding box
/// 2. Performs precise collision detection between the area and other entities
/// 3. Filters entities based on the area's collision mask
/// 4. Triggers enter callbacks for newly detected entities
/// 5. Triggers exit callbacks for entities that are no longer in the area
/// 6. Updates the area's contained entities set
///
/// Parameters:
///
/// * `delta` : The time delta since the last frame (currently unused but
///   typically used for time-based calculations in game systems).
///
/// Example:
///
/// ```moonbit
/// let app = @system.App::new()
/// app.add_system(area_collide_system).run()
/// ```
///
pub fn area_collide_system(_delta : Double) -> Unit {
  for e in @entity.iter_entities() {
    guard areas.get(e) is Some(area) else { continue }
    guard @position.positions.get(e) is Some(position)
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    let new_contains = Set::new()
    let entities = quadtree_query(box)
    for entity in entities {
      guard entity.is_alive() else { continue }
      guard collision_layers.get(entity) is Some(other_layer) else { continue }
      guard shapes.get(entity) is Some(other_shape) else { continue }
      guard other_shape
        is Rect(size=Vec2D(other_width, other_height), offset=other_offset)
      guard @position.positions.get(entity) is Some(other_position)
      let other_box = @math.Rect::{
        size: @math.Vec2D(other_width, other_height),
        position: other_position.0 + other_offset,
      }
      guard box.intersects(other_box) else { continue }
      guard area.mask.contains(other_layer) else { continue }
      new_contains.add(entity)
      if area.contains.contains(entity) {
        continue
      }
      for callback in area.on_enter_callbacks {
        callback(entity)
      }
    }
    for entity in area.contains {
      if new_contains.contains(entity) {
        continue
      }
      for callback in area.on_exit_callbacks {
        callback(entity)
      }
    }
    area.contains = new_contains
  }
}
