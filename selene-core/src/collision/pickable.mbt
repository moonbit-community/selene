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
}

///|
pub fn Pickable::new() -> Pickable {
  { active: true }
}

///|
/// All pickable components.
pub let pickables : Map[@entity.Entity, Pickable] = Map::new()

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
fn init {
  pointer_event_bus.register()
}

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
  if @ui.global_ui_nodes.get(entity) is Some(transform) {
    return point_in_rect(
      mouse_screen,
      transform.screen_rect.position,
      transform.screen_rect.size,
    )
  }
  guard @position.positions.get(entity) is Some(position) else { return false }
  guard shapes.get(entity) is Some(shape) else { return false }
  guard shape is Rect(size~, offset~) else { return false }
  let shape_position = position.0 + offset
  let point = mouse_world
  point_in_rect(point, shape_position, size)
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
  let camera_pos = @camera.get_position()
  let mouse_world = @system.screen_to_world(mouse_screen, camera_pos)
  let mouse_virtual = @system.screen_to_ui_virtual(mouse_screen)
  for entity, pickable in pickables {
    guard entity.is_alive() else { continue }
    guard pickable.active else { continue }
    if hit_test_pickable(entity, mouse_screen, mouse_world, mouse_virtual) {
      dispatch_pointer_events(entity)
    }
  }
}
