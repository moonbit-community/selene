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
fn rgba(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

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
  let camera_pos = @camera.get_position()
  for e, collide in colliders {
    guard e.is_alive() else { continue }
    guard collide.active else { continue }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard shapes.get(e) is Some(shape)
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      pos.0 + offset,
      @math.Vec2D(width, height),
      camera_pos,
    )
    @render2d.push_rect({
      rect,
      fill_color: rgba(255U, 0U, 0U, 0.5),
      stroke_color: None,
    })
  }
  for e, area in areas {
    guard e.is_alive() else { continue }
    guard area.active else { continue }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      pos.0 + offset,
      @math.Vec2D(width, height),
      camera_pos,
    )
    @render2d.push_rect({
      rect,
      fill_color: rgba(0U, 0U, 255U, 0.5),
      stroke_color: None,
    })
  }
  for e, _pickable in pickables {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(pos) else { continue }
    guard shapes.get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      pos.0 + offset,
      @math.Vec2D(width, height),
      camera_pos,
    )
    @render2d.push_rect({
      rect,
      fill_color: rgba(0U, 255U, 0U, 0.5),
      stroke_color: None,
    })
  }
}

///|
fn to_screen_rect(
  entity : @entity.Entity,
  world_or_ui_pos : @math.Vec2D,
  size : @math.Vec2D,
  camera_pos : @math.Vec2D,
) -> @math.Rect {
  if @ui.global_ui_nodes.get(entity) is Some(transform) {
    transform.screen_rect
  } else {
    @math.Rect::{
      position: @system.world_to_screen(world_or_ui_pos, camera_pos),
      size: @system.scale_vec2(size),
    }
  }
}
