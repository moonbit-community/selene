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
/// Marker component for pointer-interactive entities.
#selene.component
pub(all) struct Pickable {
  mut active : Bool
}

///|
pub fn Pickable::Pickable() -> Pickable {
  { active: true, }
}

///|
/// All pickable components.
pub fn pickables() -> @ecs.ComponentStore[Pickable] {
  @ecs.components()
}

///|
/// Pointer phase for frame events.
#derive(Eq)
pub(all) enum PointerPhase {
  Pressed
  Released
  JustPressed
  JustReleased
}

///|
pub extend PointerPhase with Eq::{not_equal, equal}

///|
/// Pointer event emitted during the latest update frame.
pub struct PointerEvent {
  entity : @ecs.Entity
  button : @inputs.MouseButton
  phase : PointerPhase
}

///|
pub let pointer_event_bus : @event.Events[PointerEvent] = Events()

///|
fn push_pointer_event(
  entity : @ecs.Entity,
  button : @inputs.MouseButton,
  phase : PointerPhase,
) -> Unit {
  pointer_event_bus.send({ entity, button, phase, })
}

///|
pub fn emit_pickable_just_pressed(
  entity : @ecs.Entity,
  button~ : @inputs.MouseButton = Left,
) -> Unit {
  push_pointer_event(entity, button, JustPressed)
}

///|
fn point_in_rect(
  point : @math.Vec2,
  rect_position : @math.Vec2,
  rect_size : @math.Vec2,
) -> Bool {
  point.x >= rect_position.x &&
  point.x <= rect_position.x + rect_size.x &&
  point.y >= rect_position.y &&
  point.y <= rect_position.y + rect_size.y
}

///|
fn point_in_circle(
  point : @math.Vec2,
  center : @math.Vec2,
  radius : Double,
) -> Bool {
  let dx = point.x - center.x
  let dy = point.y - center.y
  dx * dx + dy * dy <= radius * radius
}

///|
fn point_in_polygon(
  point : @math.Vec2,
  points : Array[@math.Vec2],
  offset : @math.Vec2,
) -> Bool {
  if points.length() < 3 {
    return false
  }
  let mut inside = false
  let mut last = points[points.length() - 1] + offset
  for point_on_edge in points {
    let current = point_on_edge + offset
    if (current.y > point.y) != (last.y > point.y) {
      let edge_height = last.y - current.y
      if edge_height.abs() > 0.000001 {
        let edge_x = current.x +
          (point.y - current.y) * (last.x - current.x) / edge_height
        if point.x < edge_x {
          inside = !inside
        }
      }
    }
    last = current
  }
  inside
}

///|
fn point_segment_distance_sq(
  point : @math.Vec2,
  start : @math.Vec2,
  end_ : @math.Vec2,
) -> Double {
  let dx = end_.x - start.x
  let dy = end_.y - start.y
  let length_sq = dx * dx + dy * dy
  if length_sq <= 0.000001 {
    let px = point.x - start.x
    let py = point.y - start.y
    return px * px + py * py
  }
  let projection = ((point.x - start.x) * dx + (point.y - start.y) * dy) /
    length_sq
  let clamped = @cmp.maximum(0.0, @cmp.minimum(1.0, projection))
  let closest_x = start.x + dx * clamped
  let closest_y = start.y + dy * clamped
  let px = point.x - closest_x
  let py = point.y - closest_y
  px * px + py * py
}

///|
fn point_on_polyline(
  point : @math.Vec2,
  points : Array[@math.Vec2],
  offset : @math.Vec2,
  closed : Bool,
  tolerance : Double,
) -> Bool {
  if points.length() < 2 {
    return false
  }
  let tolerance_sq = tolerance * tolerance
  let mut previous = points[0] + offset
  for index, local_point in points {
    if index == 0 {
      continue
    }
    let current = local_point + offset
    if point_segment_distance_sq(point, previous, current) <= tolerance_sq {
      return true
    }
    previous = current
  }
  closed &&
  point_segment_distance_sq(
    point,
    points[points.length() - 1] + offset,
    points[0] + offset,
  ) <=
  tolerance_sq
}

///|
fn pickable_line_tolerance(camera_view : @camera.Camera2dView?) -> Double {
  match camera_view {
    Some(camera_view) => {
      let projection_scale = if camera_view.projection.scale <= 0.0 {
        1.0
      } else {
        camera_view.projection.scale
      }
      4.0 * projection_scale / @cmp.maximum(@window.get_zoom(), 0.000001)
    }
    None => 4.0 / @cmp.maximum(@window.get_zoom(), 0.000001)
  }
}

///|
fn point_in_collision_shape(
  point : @math.Vec2,
  shape : CollisionShape,
  camera_view : @camera.Camera2dView?,
) -> Bool {
  match shape {
    Rect(size~, offset~) => point_in_rect(point, offset, size)
    Ball(radius~, offset~) => point_in_circle(point, offset, radius)
    Polygon(points~, offset~) => point_in_polygon(point, points, offset)
    Polyline(points~, offset~, closed~) =>
      point_on_polyline(
        point,
        points,
        offset,
        closed,
        pickable_line_tolerance(camera_view),
      )
  }
}

///|
fn pickable_matches_camera_view(
  entity : @ecs.Entity,
  camera_view : @camera.Camera2dView?,
) -> Bool {
  if @ui.global_ui_node(entity) is Some(_) {
    return true
  }
  match camera_view {
    Some(camera_view) => {
      if !@visibility.matches(
          @visibility.entity_render_layers(entity),
          @visibility.entity_render_layers(camera_view.entity),
        ) {
        return false
      }
      true
    }
    None => true
  }
}

///|
fn hit_test_pickable(
  entity : @ecs.Entity,
  mouse_screen : @math.Vec2,
  mouse_world : @math.Vec2,
  _mouse_virtual : @math.Vec2,
  camera_view : @camera.Camera2dView?,
) -> Bool {
  if @ui.global_ui_node(entity) is Some(transform) {
    return point_in_rect(
      mouse_screen,
      transform.screen_rect.position,
      transform.screen_rect.size,
    )
  }
  guard pickable_entity_global_transform(entity) is Some(transform) else {
    return false
  }
  guard shapes().get(entity) is Some(shape) else { return false }
  guard transform.affine.project_xy().inverse() is Some(inverse) else {
    return false
  }
  point_in_collision_shape(
    inverse.transform_point(mouse_world),
    shape,
    camera_view,
  )
}

///|
fn dispatch_pointer_events(entity : @ecs.Entity) -> Unit {
  for button in [@inputs.MouseButton::Left, Right, Middle] {
    if @inputs.is_mouse_pressed(button) {
      push_pointer_event(entity, button, Pressed)
    }
    if @inputs.is_mouse_released(button) {
      push_pointer_event(entity, button, Released)
    }
    if @inputs.is_mouse_just_pressed(button) {
      push_pointer_event(entity, button, JustPressed)
    }
    if @inputs.is_mouse_just_released(button) {
      push_pointer_event(entity, button, JustReleased)
    }
  }
}

///|
pub fn pickable_click_system(_delta : Double) -> Unit {
  let mouse_screen = @inputs.mouse.pos
  let camera_view = @camera.camera2d_view_for_screen_point(mouse_screen)
  let mouse_world = match camera_view {
    Some(camera_view) => camera_view.viewport_to_world_2d(mouse_screen)
    None => @window.unscale_vec2(mouse_screen)
  }
  let mouse_virtual = @window.screen_to_ui_virtual(mouse_screen)
  for entity, pickable in pickables() {
    guard entity.is_alive() else { continue }
    guard pickable.active else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard pickable_matches_camera_view(entity, camera_view) else { continue }
    if hit_test_pickable(
        entity, mouse_screen, mouse_world, mouse_virtual, camera_view,
      ) {
      dispatch_pointer_events(entity)
    }
  }
}

///|
fn pickable_entity_global_transform(
  entity : @ecs.Entity,
) -> @transform.GlobalTransform? {
  @transform.compute_global_transform(entity)
}
