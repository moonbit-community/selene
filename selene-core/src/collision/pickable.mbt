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
pub(all) struct Pickable {
  mut active : Bool

  fn new() -> Pickable
}

///|
pub fn Pickable::new() -> Pickable {
  { active: true }
}

///|
priv struct PickableWorldStore {
  pickables : Map[@entity.Entity, Pickable]
}

///|
let pickable_world_stores : Map[UInt, PickableWorldStore] = Map::new()

///|
fn pickable_world_store() -> PickableWorldStore {
  let world_id = @ecs.require_current_world().id()
  pickable_world_stores.get_or_init(world_id, () => { pickables: Map::new() })
}

///|
/// All pickable components.
pub fn pickables() -> Map[@entity.Entity, Pickable] {
  pickable_world_store().pickables
}

///|
/// Pointer phase for frame events.
pub(all) enum PointerPhase {
  Pressed
  Released
  JustPressed
  JustReleased
} derive(Eq)

///|
/// Pointer event emitted during the latest update frame.
pub struct PointerEvent {
  entity : @entity.Entity
  button : @inputs.MouseButton
  phase : PointerPhase
}

///|
pub let pointer_event_bus : @event.Events[PointerEvent] = @event.Events::new()

///|
fn push_pointer_event(
  entity : @entity.Entity,
  button : @inputs.MouseButton,
  phase : PointerPhase,
) -> Unit {
  pointer_event_bus.send({ entity, button, phase })
}

///|
pub fn emit_pickable_just_pressed(
  entity : @entity.Entity,
  button? : @inputs.MouseButton = @inputs.MouseButton::Left,
) -> Unit {
  push_pointer_event(entity, button, JustPressed)
}

///|
fn point_in_rect(
  point : @math.Vec2,
  rect_position : @math.Vec2,
  rect_size : @math.Vec2,
) -> Bool {
  point[X] >= rect_position[X] &&
  point[X] <= rect_position[X] + rect_size[X] &&
  point[Y] >= rect_position[Y] &&
  point[Y] <= rect_position[Y] + rect_size[Y]
}

///|
fn point_in_circle(
  point : @math.Vec2,
  center : @math.Vec2,
  radius : Double,
) -> Bool {
  let dx = point[X] - center[X]
  let dy = point[Y] - center[Y]
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
    if (current[Y] > point[Y]) != (last[Y] > point[Y]) {
      let edge_height = last[Y] - current[Y]
      if edge_height.abs() > 0.000001 {
        let edge_x = current[X] +
          (point[Y] - current[Y]) * (last[X] - current[X]) / edge_height
        if point[X] < edge_x {
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
  let dx = end_[X] - start[X]
  let dy = end_[Y] - start[Y]
  let length_sq = dx * dx + dy * dy
  if length_sq <= 0.000001 {
    let px = point[X] - start[X]
    let py = point[Y] - start[Y]
    return px * px + py * py
  }
  let projection = ((point[X] - start[X]) * dx + (point[Y] - start[Y]) * dy) /
    length_sq
  let clamped = @cmp.maximum(0.0, @cmp.minimum(1.0, projection))
  let closest_x = start[X] + dx * clamped
  let closest_y = start[Y] + dy * clamped
  let px = point[X] - closest_x
  let py = point[Y] - closest_y
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
  ) <= tolerance_sq
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
      4.0 * projection_scale / @cmp.maximum(@system.get_zoom(), 0.000001)
    }
    None => 4.0 / @cmp.maximum(@system.get_zoom(), 0.000001)
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
  entity : @entity.Entity,
  camera_view : @camera.Camera2dView?,
) -> Bool {
  if @ui.global_ui_nodes().contains(entity) {
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
      let visible_cameras = @visibility.visible_camera_entity_ids(entity)
      visible_cameras.is_empty() ||
      visible_cameras.contains(camera_view.entity.id())
    }
    None => true
  }
}

///|
fn hit_test_pickable(
  entity : @entity.Entity,
  mouse_screen : @math.Vec2,
  mouse_world : @math.Vec2,
  _mouse_virtual : @math.Vec2,
  camera_view : @camera.Camera2dView?,
) -> Bool {
  if @ui.global_ui_nodes().get(entity) is Some(transform) {
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
  let local_point = match transform.affine.inverse() {
    Some(inverse_transform) =>
      inverse_transform.transform_point3(
        @math.Vec3::new(mouse_world[X], mouse_world[Y], 0.0),
      )
    None => @math.Vec3::new(mouse_world[X], mouse_world[Y], 0.0)
  }
  point_in_collision_shape(
    @math.Vec2(local_point.x, local_point.y),
    shape,
    camera_view,
  )
}

///|
fn dispatch_pointer_events(entity : @entity.Entity) -> Unit {
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
    None => @system.unscale_vec2(mouse_screen)
  }
  let mouse_virtual = @system.screen_to_ui_virtual(mouse_screen)
  for entity, pickable in pickables() {
    guard entity.is_alive() else { continue }
    guard pickable.active else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard pickable_matches_camera_view(entity, camera_view) else { continue }
    if hit_test_pickable(
      entity,
      mouse_screen,
      mouse_world,
      mouse_virtual,
      camera_view,
    ) {
      dispatch_pointer_events(entity)
    }
  }
}

///|
fn pickable_entity_global_transform(
  entity : @entity.Entity,
) -> @transform.GlobalTransform? {
  @transform.compute_global_transform(entity)
}
