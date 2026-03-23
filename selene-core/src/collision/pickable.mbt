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
  point : @math.Vec2D,
  rect_position : @math.Vec2D,
  rect_size : @math.Vec2D,
) -> Bool {
  point[X] >= rect_position[X] &&
  point[X] <= rect_position[X] + rect_size[X] &&
  point[Y] >= rect_position[Y] &&
  point[Y] <= rect_position[Y] + rect_size[Y]
}

///|
fn hit_test_pickable(
  entity : @entity.Entity,
  mouse_screen : @math.Vec2D,
  mouse_world : @math.Vec2D,
  _mouse_virtual : @math.Vec2D,
) -> Bool {
  if @ui.global_ui_nodes().get(entity) is Some(transform) {
    return point_in_rect(
      mouse_screen,
      transform.screen_rect.position,
      transform.screen_rect.size,
    )
  }
  let transform = pickable_entity_global_transform(entity)
  guard shapes().get(entity) is Some(shape) else { return false }
  guard shape is Rect(size~, offset~) else { return false }
  let local_point = match transform.affine.inverse() {
    Some(inverse_transform) =>
      inverse_transform.transform_point3(
        @math.Vec3::new(mouse_world[X], mouse_world[Y], 0.0),
      )
    None => @math.Vec3::new(mouse_world[X], mouse_world[Y], 0.0)
  }
  point_in_rect(@math.Vec2D(local_point.x, local_point.y), offset, size)
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
  let mouse_world = match pickable_active_camera2d_view() {
    Some((camera, camera_transform, projection)) =>
      camera.viewport_to_world_2d(camera_transform, projection, mouse_screen)
    None => @system.unscale_vec2(mouse_screen)
  }
  let mouse_virtual = @system.screen_to_ui_virtual(mouse_screen)
  for entity, pickable in pickables() {
    guard entity.is_alive() else { continue }
    guard pickable.active else { continue }
    if hit_test_pickable(entity, mouse_screen, mouse_world, mouse_virtual) {
      dispatch_pointer_events(entity)
    }
  }
}

///|
fn pickable_entity_global_transform(
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
fn pickable_active_camera2d_view() -> (
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
    let global = pickable_entity_global_transform(entity)
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
