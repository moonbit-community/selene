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
/// Usage of the camera system:
/// Add the `camera_system` function to your app:
/// ```notest
/// app.add_system(@camera.camera_system)
/// ```
/// This system is included in the `@plugins.default_plugin`.
/// Access the global `camera` variable to manipulate the camera position,
/// limits, and attached entities. The camera system automatically updates the
/// camera position based on the attached entity's position.
///
/// Attach an entity to the camera:
/// ```notest
/// camera.attached_entity = Some(PLAYER_ENTITY)
/// ```
/// Set camera limits:
/// ```notest
/// camera.limit_top = Some(0.0)
/// camera.limit_bottom = Some(500.0)
/// camera.limit_left = Some(0.0)
/// camera.limit_right = Some(650.0)
/// ```
/// The position of the camera is the left-top corner of the viewport. So 
/// if you want the camera to be centered on the attached entity, you can
/// set the camera offset according to the entity's size:
/// ```notest
/// camera.offset = @math.Vec2D(PLAYER_SIZE[X] * 0.5, PLAYER_SIZE[Y] * 0.5)
/// ```
pub(all) struct Camera {
  mut position : @math.Vec2D
  mut limit_top : Double?
  mut limit_bottom : Double?
  mut limit_left : Double?
  mut limit_right : Double?
  mut attached_entity : @system.Entity?
  mut offset : @math.Vec2D
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
  camera.position = pos.inner() -
    viewport_size * @math.Vec2D(0.5, 0.5) +
    camera.offset
  if camera.limit_top is Some(top) && camera.position[Y] < top {
    camera.position = @math.Vec2D(camera.position[X], top)
  }
  if camera.limit_bottom is Some(bottom) &&
    camera.position[Y] > bottom - viewport_size[Y] {
    camera.position = @math.Vec2D(camera.position[X], bottom - viewport_size[Y])
  }
  if camera.limit_left is Some(left) && camera.position[X] < left {
    camera.position = @math.Vec2D(left, camera.position[Y])
  }
  if camera.limit_right is Some(right) &&
    camera.position[X] > right - viewport_size[X] {
    camera.position = @math.Vec2D(right - viewport_size[X], camera.position[Y])
  }
}

///|
pub(all) struct Ui {}

///|
pub fn Ui::new() -> Ui {
  Ui::{  }
}

///|
pub let uis : Map[@system.Entity, Ui] = Map::new()
