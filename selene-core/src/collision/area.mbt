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
struct Area {
  mask : CollisionMask
  on_enter_callbacks : Array[(@system.Entity) -> Unit]
  on_exit_callbacks : Array[(@system.Entity) -> Unit]
  mut contains : Set[@system.Entity]
}

///|
/// Creates a new collision area with the specified layer and collision mask.
///
/// Parameters:
///
/// * `layer` : The collision layer that this area belongs to.
/// * `mask` : The collision mask that determines which collision layers this
///   area can interact with.
///
/// Returns a new `Area` instance with empty callback lists and no previously
/// contained entities.
///
/// Example:
///
/// ```notest
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(layer, mask)
/// ```
///
pub fn Area::new(mask : CollisionMask) -> Area {
  { mask, contains: Set::new(), on_enter_callbacks: [], on_exit_callbacks: [] }
}

///|
pub let areas : Map[@system.Entity, Area] = Map::new()

///|
/// Retrieves the set of entities currently contained within the specified area
/// entity.
///
/// Parameters:
///
/// * `area` : The entity that has an area component whose contained entities
///   should be retrieved.
///
/// Returns a `Set[@system.Entity]` containing all entities currently within the
/// area. If the specified entity does not have an area component, returns an
/// empty set.
///
/// Example:
///
/// ```notest
/// // Create an area entity
/// let area_entity = @system.Entity::new()
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(layer, mask)
/// @collision.areas.set(area_entity, area)
///
/// // Get entities contained in the area
/// let contained_entities = @collision.get_contains(area_entity)
/// println("Area contains \{contained_entities.length()} entities")
/// ```
///
pub fn get_contains(area : @system.Entity) -> Set[@system.Entity] {
  areas.get(area).map_or(Set::new(), fn(area) { area.contains })
}

///|
/// Registers a callback function to be executed when another entity enters this
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
/// ```notest
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::empty()
/// let shape = @collision.CollisionShape::Rect(size=@math.Vec2D(100.0, 100.0), offset=@math.Vec2D(0.0, 0.0))
/// let area = @collision.Area::new(shape, layer, mask)
/// area.on_enter(fn(entity) { println("Entity \{entity} entered the area!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_enter(self : Area, callback : (@system.Entity) -> Unit) -> Unit {
  self.on_enter_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when another entity exits this
/// area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the exiting entity as its
///   argument.
///
/// Example:
///
/// ```notest
/// let layer = @collision.CollisionLayer::new()
/// let mask = @collision.CollisionMask::empty()
/// let area = @collision.Area::new(layer, mask)
/// area.on_exit(fn(entity) { println("Entity \{entity} exited the area!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_exit(self : Area, callback : (@system.Entity) -> Unit) -> Unit {
  self.on_exit_callbacks.push(callback)
}

///|
/// Processes collision detection between area entities and other entities in
/// the game world using spatial partitioning for efficient queries.
///
/// Parameters:
///
/// * `backend` : The system backend instance (unused in the current
///   implementation).
///
/// Panics if an entity has an area component but lacks a position component, or
/// if an entity has an area component but lacks a collision shape component.
///
/// Example:
///
/// ```notest
/// // Set up entities with area and collide components
/// let entity1 = @system.Entity::new()
/// let entity2 = @system.Entity::new()
///
/// // Create area for entity1
/// let layer1 = @collision.CollisionLayer::new()
/// let mask1 = @collision.CollisionMask::new([layer1])
/// let area1 = @collision.Area::new(layer1, mask1)
/// area1.on_enter(fn(entity) { println("Entity entered area!") })
/// @collision.areas.set(entity1, area1)
///
/// // Create collide component for entity2
/// let layer2 = @collision.CollisionLayer::new()
/// let mask2 = @collision.CollisionMask::new([layer2])
/// let collide2 = @collision.Collide::{ shape: @collision.CollisionShape::Rect(size=@math.Vec2D(50.0, 50.0), offset=@math.Vec2D(0.0, 0.0)), layer: layer2, mask: mask2 }
/// @collision.collides.set(entity2, collide2)
///
/// // Run the collision system
/// @collision.area_collide_system(backend)
/// ```
///
pub fn area_collide_system(_ : &@system.Backend) -> Unit {
  for e in @system.iter_entities() {
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
