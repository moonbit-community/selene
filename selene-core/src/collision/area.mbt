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

///| FIXME: Area has many similarities with CollisionShape, consider merging them.
pub(all) struct Area {
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
pub fn Area::on_enter(self : Area, callback : (@system.Entity) -> Unit) -> Unit {
  self.on_enter_callbacks.push(callback)
}

///|
pub fn Area::on_exit(self : Area, callback : (@system.Entity) -> Unit) -> Unit {
  self.on_exit_callbacks.push(callback)
}

///|
pub fn Area::on_pressed(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_pressed_callbacks.push(callback)
}

///|
pub fn Area::on_released(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_released_callbacks.push(callback)
}

///|
pub fn Area::on_just_pressed(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_pressed_callbacks.push(callback)
}

///|
pub fn Area::on_just_released(
  self : Area,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_released_callbacks.push(callback)
}

///|
pub fn area_collide_system(_ : &@system.Backend) -> Unit {
  for e in @system.all_entities {
    guard areas.get(e) is Some(area) else { continue }
    guard @position.positions.get(e) is Some(position)
    guard area.shape is Rect(size={ x: width, y: height }, offset~)
    let box = @math.Rect::{
      size: @math.Vec2D::new(width, height),
      position: position.inner() + offset,
    }
    quadtree_root.insert(e, box)
    let new_last_contains = Set::new()
    let entities = quadtree_root.query(box)
    for entity in entities.intersection(@system.all_entities) {
      if areas.get(entity) is Some(other_area) {
        guard other_area.shape
          is Rect(size={ x: other_width, y: other_height }, offset=other_offset)
        guard @position.positions.get(entity) is Some(other_position)
        let other_box = @math.Rect::{
          size: @math.Vec2D::new(other_width, other_height),
          position: other_position.inner() + other_offset,
        }
        guard box.intersects(other_box) else { continue }
        guard area.mask.contains(other_area.layer) else { continue }
      } else if collides.get(entity) is Some(other_body) {
        guard other_body.shape
          is Rect(size={ x: other_width, y: other_height }, offset=other_offset)
        guard @position.positions.get(entity) is Some(other_position)
        let other_box = @math.Rect::{
          size: @math.Vec2D::new(other_width, other_height),
          position: other_position.inner() + other_offset,
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
pub fn area_click_system(_ : &@system.Backend) -> Unit {
  let box = @math.Rect::{
    size: @math.Vec2D::new(1.0, 1.0),
    position: @system.mouse.pos,
  }
  let entities = quadtree_root.query(box)
  for e in entities.intersection(@system.all_entities) {
    guard areas.get(e) is Some(area) else { continue }
    guard area.monitoring_mouse else { continue }
    guard @position.positions.get(e) is Some(position)
    guard area.shape is Rect(size={ x: width, y: height }, offset~)
    let area_box = @math.Rect::{
      size: @math.Vec2D::new(width, height),
      position: position.inner() + offset,
    }
    let box = if @camera.uis.get(e) is Some(_) {
      box 
    } else {
      box.shift(@camera.camera.position)
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
