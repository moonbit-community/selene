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
fn rgba(r : UInt32, g : UInt32, b : UInt32, a : Double) -> @render.Color {
  { r, g, b, a, }
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
pub fn debug_collide_system(
  frame : @render2d.Frame2D,
  scene : CollisionQueries,
) -> Unit {
  let query_collider = scene.colliders
  let query_collision_shape = scene.shapes
  let query_area = scene.areas
  let query_pickable = scene.pickables
  let cameras = scene.view.camera_views()
  let camera_view = cameras.get(cameras.length() - 1)
  for e, Single(collide) in query_collider {
    guard scene.view.is_alive(e) else { continue }
    guard collide.active else { continue }
    guard! query_collision_shape.get(e).map(value => value.0) is Some(shape)
    guard! shape is Rect(size~, offset~)
    guard debug_entity_global_transform(scene~, e) is Some(global) else {
      continue
    }
    let rect = to_screen_rect(scene~, e, global, offset, size, camera_view)
    frame.push_world_command(
      0.0,
      None,
      Rect({
        rect,
        transform: @math.Affine2::identity(),
        alpha_mode: Blend,
        blend_mode: Alpha,
        fill_color: rgba(255U, 0U, 0U, 0.5),
        stroke_color: None,
      }),
    )
  }
  for e, Single(area) in query_area {
    guard scene.view.is_alive(e) else { continue }
    guard area.active else { continue }
    guard query_collision_shape.get(e).map(value => value.0) is Some(shape) else {
      continue
    }
    guard! shape is Rect(size~, offset~)
    guard debug_entity_global_transform(scene~, e) is Some(global) else {
      continue
    }
    let rect = to_screen_rect(scene~, e, global, offset, size, camera_view)
    frame.push_world_command(
      0.0,
      None,
      Rect({
        rect,
        transform: @math.Affine2::identity(),
        alpha_mode: Blend,
        blend_mode: Alpha,
        fill_color: rgba(0U, 0U, 255U, 0.5),
        stroke_color: None,
      }),
    )
  }
  for e, Single(_pickable) in query_pickable {
    guard scene.view.is_alive(e) else { continue }
    guard query_collision_shape.get(e).map(value => value.0) is Some(shape) else {
      continue
    }
    guard! shape is Rect(size~, offset~)
    guard debug_entity_global_transform(scene~, e) is Some(global) else {
      continue
    }
    let rect = to_screen_rect(scene~, e, global, offset, size, camera_view)
    frame.push_world_command(
      0.0,
      None,
      Rect({
        rect,
        transform: @math.Affine2::identity(),
        alpha_mode: Blend,
        blend_mode: Alpha,
        fill_color: rgba(0U, 255U, 0U, 0.5),
        stroke_color: None,
      }),
    )
  }
}

///|
fn to_screen_rect(
  scene~ : CollisionQueries,
  entity : @ecs.Entity,
  global_transform : @transform.GlobalTransform,
  local_position : @math.Vec2,
  size : @math.Vec2,
  camera_view : @camera.Camera2dView?,
) -> @math.Rect {
  if scene.geometry.global_node(entity) is Some(transform) {
    transform.screen_rect
  } else {
    let p0 = screen_point(
      scene~,
      global_transform.transform_point(
        Vec3(local_position.x, local_position.y, 0.0),
      ),
      camera_view,
    )
    let p1 = screen_point(
      scene~,
      global_transform.transform_point(
        Vec3(local_position.x + size.x, local_position.y, 0.0),
      ),
      camera_view,
    )
    let p2 = screen_point(
      scene~,
      global_transform.transform_point(
        Vec3(local_position.x, local_position.y + size.y, 0.0),
      ),
      camera_view,
    )
    let p3 = screen_point(
      scene~,
      global_transform.transform_point(
        Vec3(local_position.x + size.x, local_position.y + size.y, 0.0),
      ),
      camera_view,
    )
    let min_x = [p0.x, p1.x, p2.x, p3.x].fold(init=p0.x, fn(acc, value) {
      if value < acc {
        value
      } else {
        acc
      }
    })
    let min_y = [p0.y, p1.y, p2.y, p3.y].fold(init=p0.y, fn(acc, value) {
      if value < acc {
        value
      } else {
        acc
      }
    })
    let max_x = [p0.x, p1.x, p2.x, p3.x].fold(init=p0.x, fn(acc, value) {
      if value > acc {
        value
      } else {
        acc
      }
    })
    let max_y = [p0.y, p1.y, p2.y, p3.y].fold(init=p0.y, fn(acc, value) {
      if value > acc {
        value
      } else {
        acc
      }
    })
    { position: Vec2(min_x, min_y), size: Vec2(max_x - min_x, max_y - min_y), }
  }
}

///|
fn screen_point(
  scene~ : CollisionQueries,
  world_point : @math.Vec3,
  camera_view : @camera.Camera2dView?,
) -> @math.Vec2 {
  let world_point_2d = @math.Vec2(world_point.x, world_point.y)
  match camera_view {
    Some(camera_view) => camera_view.world_to_viewport(world_point_2d)
    None => world_point_2d.scalar_mul(scene.display.zoom())
  }
}

///|
fn debug_entity_global_transform(
  scene~ : CollisionQueries,
  entity : @ecs.Entity,
) -> @transform.GlobalTransform? {
  scene.transforms.global_transform(entity)
}
