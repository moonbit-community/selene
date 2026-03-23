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
  let camera_view = debug_active_camera2d_view()
  for e, collide in colliders() {
    guard e.is_alive() else { continue }
    guard collide.active else { continue }
    guard shapes().get(e) is Some(shape)
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      debug_entity_global_transform(e),
      offset,
      @math.Vec2D(width, height),
      camera_view,
    )
    @render2d.push_rect({
      rect,
      transform: @math.Transform::identity(),
      fill_color: rgba(255U, 0U, 0U, 0.5),
      stroke_color: None,
    })
  }
  for e, area in areas() {
    guard e.is_alive() else { continue }
    guard area.active else { continue }
    guard shapes().get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      debug_entity_global_transform(e),
      offset,
      @math.Vec2D(width, height),
      camera_view,
    )
    @render2d.push_rect({
      rect,
      transform: @math.Transform::identity(),
      fill_color: rgba(0U, 0U, 255U, 0.5),
      stroke_color: None,
    })
  }
  for e, _pickable in pickables() {
    guard e.is_alive() else { continue }
    guard shapes().get(e) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let rect = to_screen_rect(
      e,
      debug_entity_global_transform(e),
      offset,
      @math.Vec2D(width, height),
      camera_view,
    )
    @render2d.push_rect({
      rect,
      transform: @math.Transform::identity(),
      fill_color: rgba(0U, 255U, 0U, 0.5),
      stroke_color: None,
    })
  }
}

///|
fn to_screen_rect(
  entity : @entity.Entity,
  global_transform : @transform.GlobalTransform,
  local_position : @math.Vec2D,
  size : @math.Vec2D,
  camera_view : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
  )?,
) -> @math.Rect {
  if @ui.global_ui_nodes().get(entity) is Some(transform) {
    transform.screen_rect
  } else {
    let p0 = screen_point(
      global_transform.transform_point(
        @math.Vec3::new(local_position[X], local_position[Y], 0.0),
      ),
      camera_view,
    )
    let p1 = screen_point(
      global_transform.transform_point(
        @math.Vec3::new(local_position[X] + size[X], local_position[Y], 0.0),
      ),
      camera_view,
    )
    let p2 = screen_point(
      global_transform.transform_point(
        @math.Vec3::new(local_position[X], local_position[Y] + size[Y], 0.0),
      ),
      camera_view,
    )
    let p3 = screen_point(
      global_transform.transform_point(
        @math.Vec3::new(
          local_position[X] + size[X],
          local_position[Y] + size[Y],
          0.0,
        ),
      ),
      camera_view,
    )
    let min_x = [p0[X], p1[X], p2[X], p3[X]].fold(init=p0[X], fn(acc, value) {
      if value < acc {
        value
      } else {
        acc
      }
    })
    let min_y = [p0[Y], p1[Y], p2[Y], p3[Y]].fold(init=p0[Y], fn(acc, value) {
      if value < acc {
        value
      } else {
        acc
      }
    })
    let max_x = [p0[X], p1[X], p2[X], p3[X]].fold(init=p0[X], fn(acc, value) {
      if value > acc {
        value
      } else {
        acc
      }
    })
    let max_y = [p0[Y], p1[Y], p2[Y], p3[Y]].fold(init=p0[Y], fn(acc, value) {
      if value > acc {
        value
      } else {
        acc
      }
    })
    @math.Rect::{
      position: @math.Vec2D(min_x, min_y),
      size: @math.Vec2D(max_x - min_x, max_y - min_y),
    }
  }
}

///|
fn screen_point(
  world_point : @math.Vec3,
  camera_view : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
  )?,
) -> @math.Vec2D {
  let world_point_2d = @math.Vec2D(world_point.x, world_point.y)
  match camera_view {
    Some((camera, camera_transform, projection)) =>
      camera.world_to_viewport(camera_transform, projection, world_point_2d)
    None => @system.scale_vec2(world_point_2d)
  }
}

///|
fn debug_entity_global_transform(
  entity : @entity.Entity,
) -> @transform.GlobalTransform {
  if @transform.global_transforms().get(entity) is Some(global) {
    global
  } else {
    @transform.GlobalTransform::from_transform(
      @transform.transforms().get(entity).unwrap_or_default(),
    )
  }
}

///|
fn debug_active_camera2d_view() -> (
  @camera.Camera,
  @transform.GlobalTransform,
  @camera.OrthographicProjection,
)? {
  let mut selected : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
    Int,
  )? = None
  for entity, camera in @camera.cameras() {
    guard entity.is_alive() else { continue }
    guard camera.is_active else { continue }
    guard @camera.camera2ds().contains(entity) else { continue }
    let projection = @camera.orthographic_projections()
      .get(entity)
      .unwrap_or_default()
    let global = debug_entity_global_transform(entity)
    match selected {
      Some((_, _, _, order)) if order >= camera.order => ()
      _ => selected = Some((camera, global, projection, camera.order))
    }
  }
  match selected {
    Some((camera, global, projection, _)) => Some((camera, global, projection))
    None => None
  }
}
