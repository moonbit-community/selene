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
/// Renders debug visualization for collision system components by drawing
/// colored rectangles over colliders and areas.
///
/// This system draws semi-transparent red rectangles (50% opacity) over all
/// active colliders and semi-transparent blue rectangles (50% opacity) over all
/// areas. The rectangles are positioned according to each entity's world
/// position, with UI entities using screen coordinates and non-UI entities
/// using world coordinates adjusted by the camera position.
///
/// Parameters:
///
/// * `backend` : The rendering backend used to draw the debug visualization
///   rectangles.
///
/// Panics if an entity has a position component but lacks a collision shape, or
/// if the collision shape is not a rectangle.
///
pub fn debug_collide_system(_delta : Double) -> Unit {
  for e, collide in colliders {
    guard e.is_alive() else { continue }
    guard collide.active else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard shapes.get(e) is Some(shape)
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let pos = if @ui.uis.get(e) is Some(_) {
      pos.0 + offset
    } else {
      pos.0 + offset - @camera.get_position()
    }
    @backend.draw_color_rect(
      x=pos[X],
      y=pos[Y],
      width~,
      height~,
      color="rgba(255, 0, 0, 0.5)",
    )
  }
  for e, _area in areas {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let pos = if @ui.uis.get(e) is Some(_) {
      pos.0 + offset
    } else {
      pos.0 + offset - @camera.get_position()
    }
    @backend.draw_color_rect(
      x=pos[X],
      y=pos[Y],
      width~,
      height~,
      color="rgba(0, 0, 255, 0.5)",
    )
  }
}
