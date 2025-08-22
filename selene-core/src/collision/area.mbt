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
  layer : CollisionLayer
  mask : CollisionMask
  on_enter_callbacks : Array[(@system.Entity) -> Unit]
  on_exit_callbacks : Array[(@system.Entity) -> Unit]
  mut last_contains : Set[@system.Entity]
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
pub fn Area::new(layer : CollisionLayer, mask : CollisionMask) -> Area {
  {
    layer,
    mask,
    last_contains: Set::new(),
    on_enter_callbacks: [],
    on_exit_callbacks: [],
  }
}

///|
pub let areas : Map[@system.Entity, Area] = Map::new()

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
/// ```moonbit
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
/// This system checks for collisions between areas and entities with 
/// a quadtree structure for efficient spatial queries.
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
    let new_last_contains = Set::new()
    let entities = quadtree_query(box)
    for entity in entities {
      guard entity.is_alive() else { continue }
      if areas.get(entity) is Some(other_area) {
        guard shapes.get(entity) is Some(other_shape) else { continue }
        guard other_shape
          is Rect(size=Vec2D(other_width, other_height), offset=other_offset)
        guard @position.positions.get(entity) is Some(other_position)
        let other_box = @math.Rect::{
          size: @math.Vec2D(other_width, other_height),
          position: other_position.0 + other_offset,
        }
        guard box.intersects(other_box) else { continue }
        guard area.mask.contains(other_area.layer) else { continue }
      } else if collides.get(entity) is Some(other_body) {
        guard shapes.get(entity) is Some(other_shape) else { continue }
        guard other_shape
          is Rect(size=Vec2D(other_width, other_height), offset=other_offset)
        guard @position.positions.get(entity) is Some(other_position)
        let other_box = @math.Rect::{
          size: @math.Vec2D(other_width, other_height),
          position: other_position.0 + other_offset,
        }
        guard box.intersects(other_box) else { continue }
        guard area.mask.contains(other_body.layer) else { continue }
      }
      new_last_contains.add(entity)
      if area.last_contains.contains(entity) {
        continue
      }
      for callback in area.on_enter_callbacks {
        callback(entity)
      }
    }
    for entity in area.last_contains {
      if new_last_contains.contains(entity) {
        continue
      }
      for callback in area.on_exit_callbacks {
        callback(entity)
      }
    }
    area.last_contains = new_last_contains
  }
}
