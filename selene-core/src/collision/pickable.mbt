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
struct Pickable {
  on_pressed_callbacks : Array[(@system.MouseButton) -> Unit]
  on_released_callbacks : Array[(@system.MouseButton) -> Unit]
  on_just_pressed_callbacks : Array[(@system.MouseButton) -> Unit]
  on_just_released_callbacks : Array[(@system.MouseButton) -> Unit]
}

///|
pub let pickables : Map[@system.Entity, Pickable] = Map::new()

///|
pub fn Pickable::new() -> Pickable {
  {
    on_pressed_callbacks: [],
    on_released_callbacks: [],
    on_just_pressed_callbacks: [],
    on_just_released_callbacks: [],
  }
}

///|
pub fn Pickable::on_pressed(
  self : Pickable,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_pressed_callbacks.push(callback)
}

///|
pub fn Pickable::on_released(
  self : Pickable,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_released_callbacks.push(callback)
}

///|
pub fn Pickable::on_just_pressed(
  self : Pickable,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_pressed_callbacks.push(callback)
}

///|
pub fn Pickable::on_just_released(
  self : Pickable,
  callback : (@system.MouseButton) -> Unit,
) -> Unit {
  self.on_just_released_callbacks.push(callback)
}

///|
pub fn pickable_click_system(backend : &@system.Backend) -> Unit {
  let zoom = backend.get_zoom()
  let box = @math.Rect::{
    size: @math.Vec2D(1.0, 1.0),
    position: @system.mouse.pos * Vec2D(1 / zoom, 1 / zoom),
  }
  for e, _ui in @ui.uis {
    guard e.is_alive() else { continue }
    guard pickables.get(e) is Some(pick) else { continue }
    guard @position.positions.get(e) is Some(position)
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let area_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    if !box.intersects(area_box) {
      continue
    }
    for button in [@system.MouseButton::Left, Right, Middle] {
      if @system.is_mouse_pressed(button) {
        for callback in pick.on_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_released(button) {
        for callback in pick.on_released_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_pressed(button) {
        for callback in pick.on_just_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_released(button) {
        for callback in pick.on_just_released_callbacks {
          callback(button)
        }
      }
    }
  }
  let entities = quadtree_query(box)
  for e in entities {
    guard e.is_alive() else { continue }
    guard pickables.get(e) is Some(pick) else { continue }
    guard @position.positions.get(e) is Some(position)
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let area_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    if !box.shift(@camera.get_position()).intersects(area_box) {
      continue
    }
    for button in [@system.MouseButton::Left, Right, Middle] {
      if @system.is_mouse_pressed(button) {
        for callback in pick.on_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_released(button) {
        for callback in pick.on_released_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_pressed(button) {
        for callback in pick.on_just_pressed_callbacks {
          callback(button)
        }
      }
      if @system.is_mouse_just_released(button) {
        for callback in pick.on_just_released_callbacks {
          callback(button)
        }
      }
    }
  }
}
