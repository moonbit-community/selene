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
/// Area is a collision area that can be used to detect
/// collisions with entities or mouse clicks.
/// To use areas, you need to add the `area_collide_system`
/// and `area_click_system` to your app:
/// ```notest
/// app.add_system(@collision.area_collide_system)
/// app.add_system(@collision.area_click_system)
/// ```
/// These systems are included in the `@plugins.default_plugin`.
/// Set an area for an entity:
/// ```notest
/// let area = @collision.Area::new(...)
/// @collision.areas.set(ENTITY, area)
/// ```
/// 
/// For the area to work correctly, you need to set the
/// `CollisionLayer` and `CollisionMask` for the area.
/// Please refer to the `CollisionLayer` and `CollisionMask`
/// documentation for more details on how to set them up.
/// 
pub(all) struct Area {
  // FIXME: Area has many similarities with CollisionShape, consider merging them.
  shape : CollisionShape
  layer : CollisionLayer
  mask : CollisionMask
  on_enter_callbacks : Array[(@system.Entity) -> Unit]
  on_exit_callbacks : Array[(@system.Entity) -> Unit]
  on_pressed_callbacks : Array[(@system.MouseButton) -> Unit]
  on_released_callbacks : Array[(@system.MouseButton) -> Unit]
  on_just_pressed_callbacks : Array[(@system.MouseButton) -> Unit]
  on_just_released_callbacks : Array[(@system.MouseButton) -> Unit]
  mut last_contains : Set[@system.Entity]
  mut monitoring_mouse : Bool
}

///|
pub fn Area::new(
  shape : CollisionShape,
  layer : CollisionLayer,
  mask : CollisionMask,
  monitoring_mouse~ : Bool = false,
) -> Area {
  {
    shape,
    layer,
    mask,
    last_contains: Set::new(),
    on_enter_callbacks: [],
    on_exit_callbacks: [],
    on_pressed_callbacks: [],
    on_released_callbacks: [],
    on_just_pressed_callbacks: [],
    on_just_released_callbacks: [],
    monitoring_mouse,
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
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(10.0, 10.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty()
/// )
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
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(10.0, 10.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty()
/// )
/// area.on_exit(fn(entity) { println("Entity \{entity} exited the area!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_exit(self : Area, callback : (@system.Entity) -> Unit) -> Unit {
  self.on_exit_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when a mouse button is being
/// held down while the cursor is over this area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the mouse button as its
///   argument while the button is pressed and the cursor is over the area.
///
/// Example:
///
/// ```notest
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(100.0, 50.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty(),
///   monitoring_mouse=true
/// )
/// area.on_pressed(fn(button) { println("Mouse button \{button} is being pressed!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_pressed(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_pressed_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when a mouse button is released
/// while the cursor is over this area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the mouse button as its
///   argument when the button is released and the cursor is over the area.
///
/// Example:
///
/// ```notest
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(100.0, 50.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty(),
///   monitoring_mouse=true
/// )
/// area.on_released(fn(button) { println("Mouse button \{button} was released!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_released(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_released_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when a mouse button is first
/// pressed while the cursor is over this area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the mouse button as its
///   argument when the button is first pressed and the cursor is over the area.
///
/// Example:
///
/// ```notest
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(100.0, 50.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty(),
///   monitoring_mouse=true
/// )
/// area.on_just_pressed(fn(button) { println("Mouse button \{button} was just pressed!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_just_pressed(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_pressed_callbacks.push(callback)
}

///|
/// Registers a callback function to be executed when a mouse button is released
/// for the first time while the cursor is over this area.
///
/// Parameters:
///
/// * `self` : The area to register the callback on.
/// * `callback` : A function that will be called with the mouse button as its
///   argument when the button is just released and the cursor is over the area.
///
/// Example:
///
/// ```notest
/// let area = @collision.Area::new(
///   @collision.CollisionShape::Rect(size=@math.Vec2D(100.0, 50.0)),
///   @collision.CollisionLayer::new(),
///   @collision.CollisionMask::empty(),
///   monitoring_mouse=true
/// )
/// area.on_just_released(fn(button) { println("Mouse button \{button} was just released!") })
/// @collision.areas.set(my_entity, area)
/// ```
///
pub fn Area::on_just_released(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_released_callbacks.push(callback)
}

///|
/// This system checks for collisions between areas and entities with 
/// a quadtree structure for efficient spatial queries.
pub fn area_collide_system(_ : &@system.Backend) -> Unit {
  for e in @system.all_entities {
    guard areas.get(e) is Some(area) else { continue }
    guard @position.positions.get(e) is Some(position)
    guard area.shape is Rect(size=Vec2D(width, height), offset~)
    let box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    quadtree_root.insert(e, box)
    let new_last_contains = Set::new()
    let entities = quadtree_root.query(box)
    for entity in entities.intersection(@system.all_entities) {
      if areas.get(entity) is Some(other_area) {
        guard other_area.shape
          is Rect(size=Vec2D(other_width, other_height), offset=other_offset)
        guard @position.positions.get(entity) is Some(other_position)
        let other_box = @math.Rect::{
          size: @math.Vec2D(other_width, other_height),
          position: other_position.0 + other_offset,
        }
        guard box.intersects(other_box) else { continue }
        guard area.mask.contains(other_area.layer) else { continue }
      } else if collides.get(entity) is Some(other_body) {
        guard other_body.shape
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

///|
/// This system checks for mouse clicks within areas and executes the
/// corresponding callbacks if the mouse is pressed or released over an area.
pub fn area_click_system(backend : &@system.Backend) -> Unit {
  let zoom = backend.get_zoom()
  let box = @math.Rect::{
    size: @math.Vec2D(1.0, 1.0),
    position: @system.mouse.pos * Vec2D(1 / zoom, 1 / zoom),
  }
  let entities = quadtree_root.query(box)
  for e in entities.intersection(@system.all_entities) {
    guard areas.get(e) is Some(area) else { continue }
    guard area.monitoring_mouse else { continue }
    guard @position.positions.get(e) is Some(position)
    guard area.shape is Rect(size=Vec2D(width, height), offset~)
    let area_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    // If the area is attached to a UI, shift the box by the camera position
    // to ensure the area is checked in the correct position.
    // This is necessary because UI elements are rendered in a different
    // coordinate space than the main game world.
    let box = if @ui.uis.get(e) is Some(_) {
      box
    } else {
      box.shift(@camera.get_position())
    }
    if !box.intersects(area_box) {
      continue
    }
    for button in [@system.MouseButton::Left, Right, Middle] {
      if @system.is_mouse_pressed(button) {
        for callback in area.on_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_released(button) {
        for callback in area.on_released_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_pressed(button) {
        for callback in area.on_just_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_released(button) {
        for callback in area.on_just_released_callbacks {
          callback(button)
        }
      }
    }
  }
}
