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
pub(all) struct Camera {
  position : @math.Vec2D
  mut limit_top : Double?
  mut limit_bottom : Double?
  mut limit_left : Double?
  mut limit_right : Double?
  mut attached_entity : @system.Entity?
  offset : @math.Vec2D
}

///|
pub let camera : Camera = {
  position: @math.Vec2D::zero(),
  limit_bottom: None,
  limit_left: None,
  limit_top: None,
  limit_right: None,
  attached_entity: None,
  offset: @math.Vec2D::zero(),
}

///|
pub fn camera_system(backend : &@system.Backend) -> Unit {
  guard camera.attached_entity is Some(e) else { return }
  guard @position.positions.get(e) is Some(pos) else { return }
  let viewport_size = backend.get_canvas_size()
  camera.position.x = pos.x - viewport_size.x / 2.0 + camera.offset.x
  camera.position.y = pos.y - viewport_size.y / 2.0 + camera.offset.y
  if camera.limit_top is Some(top) && camera.position.y < top {
    camera.position.y = top
  }
  if camera.limit_bottom is Some(bottom) && camera.position.y > bottom - viewport_size.y {
    camera.position.y = bottom - viewport_size.y
  }
  if camera.limit_left is Some(left) && camera.position.x < left {
    camera.position.x = left
  }
  if camera.limit_right is Some(right) && camera.position.x > right - viewport_size.x {
    camera.position.x = right - viewport_size.x
  }
}

///|
pub(all) struct Ui {}

///|
pub let uis : Map[@system.Entity, Ui] = Map::new()
