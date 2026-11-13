///|
pub(all) struct UiPointerEnterEvent {
  entity : @ecs.Entity
}

///|
pub(all) struct UiPointerLeaveEvent {
  entity : @ecs.Entity
}

///|
pub(all) struct UiPointerDownEvent {
  entity : @ecs.Entity
  button : @inputs.MouseButton
  position : @math.Vec2
}

///|
pub(all) struct UiPointerUpEvent {
  entity : @ecs.Entity
  button : @inputs.MouseButton
  position : @math.Vec2
}

///|
pub(all) struct UiClickEvent {
  entity : @ecs.Entity
  button : @inputs.MouseButton
}

///|
#derive(Eq, Debug)
pub(all) enum UiNavigationDirection {
  Up
  Down
  Left
  Right
  Activate
  Cancel
}

///|
pub extend UiNavigationDirection with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiNavigationDirection with Eq::{not_equal, equal}

///|
pub(all) struct UiNavigationEvent {
  entity : @ecs.Entity?
  direction : UiNavigationDirection
}

///|
pub(all) struct UiFocusInEvent {
  entity : @ecs.Entity
}

///|
pub(all) struct UiFocusOutEvent {
  entity : @ecs.Entity
}

///|
pub let pointer_enter_event_bus : @event.Events[UiPointerEnterEvent] = Events()

///|
pub let pointer_leave_event_bus : @event.Events[UiPointerLeaveEvent] = Events()

///|
pub let pointer_down_event_bus : @event.Events[UiPointerDownEvent] = Events()

///|
pub let pointer_up_event_bus : @event.Events[UiPointerUpEvent] = Events()

///|
pub let click_event_bus : @event.Events[UiClickEvent] = Events()

///|
pub let navigation_event_bus : @event.Events[UiNavigationEvent] = Events()

///|
pub let focus_in_event_bus : @event.Events[UiFocusInEvent] = Events()

///|
pub let focus_out_event_bus : @event.Events[UiFocusOutEvent] = Events()

///|
priv struct UiInteractionRuntime {
  mut hovered_entity : @ecs.Entity?
  mut pressed_entity : @ecs.Entity?
  mut pressed_pointer : @inputs.PointerId?
  mut focused_entity : @ecs.Entity?
  pointer_captures : Map[@inputs.PointerId, @ecs.Entity]
  consumed_pointers : Set[@inputs.PointerId]
}

///|
let ui_interaction_runtime_key : @ecs.ResourceKey[UiInteractionRuntime] = ResourceKey()

///|
fn ui_interaction_runtime(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> UiInteractionRuntime {
  ui_interaction_runtime_key.get_or_insert_with(world, _ => {
    hovered_entity: None,
    pressed_entity: None,
    pressed_pointer: None,
    focused_entity: None,
    pointer_captures: Map([]),
    consumed_pointers: Set([]),
  })
}

///|
pub fn hovered_entity() -> @ecs.Entity? {
  ui_interaction_runtime().hovered_entity
}

///|
pub fn focused_entity() -> @ecs.Entity? {
  ui_interaction_runtime().focused_entity
}

///|
pub fn is_pointer_consumed(id : @inputs.PointerId) -> Bool {
  ui_interaction_runtime().consumed_pointers.contains(id)
}

///|
pub fn consume_pointer(id : @inputs.PointerId) -> Unit {
  ui_interaction_runtime().consumed_pointers.add(id)
}

///|
fn pointer_id_for_touch(id : @inputs.TouchId) -> @inputs.PointerId {
  match @inputs.touch_point(id) {
    Some(touch) => @inputs.pointer_id_from_touch(touch)
    None => {
      for event in @inputs.touch_changes_this_frame() {
        if event.id == id {
          return @inputs.pointer_event_from_touch(event).id
        }
      }
      { source: PointerTouch, value: id.value(), }
    }
  }
}

///|
pub fn is_touch_consumed(id : @inputs.TouchId) -> Bool {
  is_pointer_consumed(pointer_id_for_touch(id))
}

///|
pub fn consume_touch(id : @inputs.TouchId) -> Unit {
  consume_pointer(pointer_id_for_touch(id))
}

///|
pub fn active_unconsumed_touches() -> Array[@inputs.TouchPoint] {
  let touches : Array[@inputs.TouchPoint] = []
  for _, touch in @inputs.active_touches() {
    if !is_pointer_consumed(@inputs.pointer_id_from_touch(touch)) {
      touches.push(touch)
    }
  }
  touches
}

///|
pub fn unconsumed_touch_changes_this_frame() -> Array[@inputs.TouchEvent] {
  let changes : Array[@inputs.TouchEvent] = []
  for event in @inputs.touch_changes_this_frame() {
    if !is_pointer_consumed(@inputs.pointer_event_from_touch(event).id) {
      changes.push(event)
    }
  }
  changes
}

///|
pub fn unconsumed_pointer_changes_this_frame() -> Array[@inputs.PointerEvent] {
  let changes : Array[@inputs.PointerEvent] = []
  for event in @inputs.pointer_changes_this_frame() {
    if !is_pointer_consumed(event.id) {
      changes.push(event)
    }
  }
  changes
}

///|
fn clear_focus_marker(input~ : UiInput, entity : @ecs.Entity) -> Unit {
  ignore(input.model.focuseds.remove(entity))
}

///|
fn set_focus_marker(input~ : UiInput, entity : @ecs.Entity) -> Unit {
  input.model.focuseds.set(entity, Focused())
}

///|
pub fn UiInput::focus(input : UiInput, entity : @ecs.Entity) -> Unit {
  guard input.entities.is_alive(entity) else { return }
  let runtime = input.runtime
  if runtime.focused_entity is Some(current) && current == entity {
    return
  }
  if runtime.focused_entity is Some(current) {
    clear_focus_marker(input~, current)
    input.focus_out.send({ entity: current, })
  }
  runtime.focused_entity = Some(entity)
  set_focus_marker(input~, entity)
  input.focus_in.send({ entity, })
}

///|
pub fn UiInput::blur(input : UiInput) -> Unit {
  let runtime = input.runtime
  if runtime.focused_entity is Some(current) {
    clear_focus_marker(input~, current)
    input.focus_out.send({ entity: current, })
  }
  runtime.focused_entity = None
}

///|
fn is_interactive(input~ : UiInput, entity : @ecs.Entity) -> Bool {
  input.buttons
  .get(entity)
  .map(value => value.0)
  .map(fn(button) { button.enabled })
  .unwrap_or(false)
}

///|
fn is_focusable(input~ : UiInput, entity : @ecs.Entity) -> Bool {
  let query_focusable = input.focusables
  if is_interactive(input~, entity) {
    true
  } else {
    query_focusable.contains(entity)
  }
}

///|
fn button_blocks_pointer(input~ : UiInput, entity : @ecs.Entity) -> Bool {
  input.focus_policies.get(entity).map(value => value.0).unwrap_or(Pass) ==
  Block
}

///|
fn interaction_state(
  input~ : UiInput,
  entity : @ecs.Entity,
  hovered : @ecs.Entity?,
) -> Interaction {
  let runtime = input.runtime
  if runtime.pressed_entity is Some(pressed) &&
    pressed == entity &&
    runtime.pressed_pointer is Some(pointer) &&
    @inputs.is_pointer_active(pointer) {
    Pressed
  } else if hovered is Some(target) && target == entity {
    Hovered
  } else {
    None
  }
}

///|
fn focusable_entities(input~ : UiInput) -> Array[@ecs.Entity] {
  let query_tab_index = input.tab_indices
  let entities : Array[@ecs.Entity] = []
  for entity in input.model.ui_stack_entities {
    if is_focusable(input~, entity) {
      entities.push(entity)
    }
  }
  entities.sort_by(fn(lhs, rhs) {
    let lt = query_tab_index
      .get(lhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    let rt = query_tab_index
      .get(rhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    if lt != rt {
      lt - rt
    } else {
      input.model.tree_orders.get(lhs).unwrap_or(0) -
      input.model.tree_orders.get(rhs).unwrap_or(0)
    }
  })
  entities
}

///|
fn rect_center(rect : @math.Rect) -> @math.Vec2 {
  Vec2(rect.position.x + rect.size.x / 2.0, rect.position.y + rect.size.y / 2.0)
}

///|
fn directional_score(
  current : @math.Vec2,
  candidate : @math.Vec2,
  direction : UiNavigationDirection,
) -> (Double, Double)? {
  let delta = candidate - current
  match direction {
    Left => if delta.x < 0.0 { Some((-delta.x, delta.y.abs())) } else { None }
    Right => if delta.x > 0.0 { Some((delta.x, delta.y.abs())) } else { None }
    Up => if delta.y < 0.0 { Some((-delta.y, delta.x.abs())) } else { None }
    Down => if delta.y > 0.0 { Some((delta.y, delta.x.abs())) } else { None }
    Activate | Cancel => None
  }
}

///|
fn move_focus(input~ : UiInput, direction : UiNavigationDirection) -> Unit {
  let entities = focusable_entities(input~)
  if entities.is_empty() {
    input.blur()
    return
  }
  let runtime = input.runtime
  let current = runtime.focused_entity.unwrap_or(entities[0])
  if !input.model.geometry.contains(current) {
    input.focus(entities[0])
    return
  }
  let current_center = rect_center(
    input.model.geometry.get(current).map(value => value.global).unwrap().screen_rect,
  )
  let mut best_entity : @ecs.Entity? = None
  let mut best_primary = 0.0
  let mut best_secondary = 0.0
  let mut has_best = false
  for entity in entities {
    guard entity != current else { continue }
    guard input.model.geometry.get(entity).map(value => value.global)
      is Some(transform) else {
      continue
    }
    guard directional_score(
        current_center,
        rect_center(transform.screen_rect),
        direction,
      )
      is Some((primary, secondary)) else {
      continue
    }
    if !has_best ||
      primary < best_primary ||
      (primary == best_primary && secondary < best_secondary) {
      has_best = true
      best_entity = Some(entity)
      best_primary = primary
      best_secondary = secondary
    }
  }
  match best_entity {
    Some(entity) => input.focus(entity)
    None => if runtime.focused_entity is None { input.focus(entities[0]) }
  }
}

///|
fn move_focus_by_tab(input~ : UiInput, reverse : Bool) -> Unit {
  let entities = focusable_entities(input~)
  if entities.is_empty() {
    input.blur()
    return
  }
  let runtime = input.runtime
  match runtime.focused_entity {
    Some(current) => {
      let mut index = 0
      for i in 0..<entities.length() {
        if entities[i] == current {
          index = i
          break
        }
      }
      let next = if reverse {
        if index == 0 {
          entities.length() - 1
        } else {
          index - 1
        }
      } else if index + 1 >= entities.length() {
        0
      } else {
        index + 1
      }
      input.focus(entities[next])
    }
    None => input.focus(entities[0])
  }
}

///|
fn point_in_rect(point : @math.Vec2, rect : @math.Rect) -> Bool {
  point.x >= rect.position.x &&
  point.y >= rect.position.y &&
  point.x <= rect.position.x + rect.size.x &&
  point.y <= rect.position.y + rect.size.y
}

///|
fn screen_clip_allows(
  input~ : UiInput,
  entity : @ecs.Entity,
  point : @math.Vec2,
) -> Bool {
  let within_target_viewport = input.model.geometry
    .get(entity)
    .map(value => value.global)
    .map(fn(transform) { point_in_rect(point, transform.target_viewport) })
    .unwrap_or(true)
  if !within_target_viewport {
    return false
  }
  match input.model.calculated_clips.get(entity) {
    Some(clip) => point_in_rect(point, clip.clip)
    None => true
  }
}

///|
fn normalized_cursor_position(
  point : @math.Vec2,
  rect : @math.Rect,
) -> @math.Vec2? {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 {
    None
  } else {
    Some(
      Vec2(
        (point.x - rect.position.x) / rect.size.x - 0.5,
        (point.y - rect.position.y) / rect.size.y - 0.5,
      ),
    )
  }
}

///|
fn update_relative_cursor_positions(
  input~ : UiInput,
  position : @math.Vec2,
) -> Unit {
  let query_node = input.nodes
  let query_relative_cursor_position = input.cursor_positions
  for entity, Single(relative) in query_relative_cursor_position {
    guard input.entities.is_alive(entity) else { continue }
    guard query_node.get(entity).map(value => value.0) is Some(node) else {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    guard input.model.geometry.get(entity).map(value => value.global)
      is Some(transform) else {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    if !node.active ||
      node.display == None ||
      !input.visibility.is_visible(entity) {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    relative.normalized = normalized_cursor_position(
      position,
      transform.screen_rect,
    )
    relative.cursor_over = point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(input~, entity, position)
  }
}

///|
fn resolve_pointer_target(
  input~ : UiInput,
  position : @math.Vec2,
) -> @ecs.Entity? {
  let candidates = input.model.ui_stack_entities
  let mut index = candidates.length() - 1
  while index >= 0 {
    let entity = candidates[index]
    guard input.model.geometry.get(entity).map(value => value.global)
      is Some(transform) else {
      index -= 1
      continue
    }
    if point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(input~, entity, position) {
      if is_interactive(input~, entity) {
        return Some(entity)
      }
      if button_blocks_pointer(input~, entity) {
        return None
      }
    }
    index -= 1
  }
  None
}

///|
fn ui_node_at(input~ : UiInput, position : @math.Vec2) -> @ecs.Entity? {
  let candidates = input.model.ui_stack_entities
  let mut index = candidates.length() - 1
  while index >= 0 {
    let entity = candidates[index]
    guard input.model.geometry.get(entity).map(value => value.global)
      is Some(transform) else {
      index -= 1
      continue
    }
    if point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(input~, entity, position) {
      return Some(entity)
    }
    index -= 1
  }
  None
}

///|
fn scrollable_target_at(
  input~ : UiInput,
  position : @math.Vec2,
) -> @ecs.Entity? {
  let query_node = input.nodes
  let mut target = ui_node_at(input~, position)
  while target is Some(entity) {
    guard query_node.get(entity).map(value => value.0) is Some(node) else {
      target = input.hierarchy.parent(entity)
      continue
    }
    if node.overflow_x == Scroll || node.overflow_y == Scroll {
      return Some(entity)
    }
    target = input.hierarchy.parent(entity)
  }
  None
}

///|
fn blocking_target_at(input~ : UiInput, position : @math.Vec2) -> @ecs.Entity? {
  let mut target = ui_node_at(input~, position)
  while target is Some(entity) {
    if button_blocks_pointer(input~, entity) {
      return Some(entity)
    }
    target = input.hierarchy.parent(entity)
  }
  None
}

///|
fn touch_capture_target_at(
  input~ : UiInput,
  position : @math.Vec2,
) -> @ecs.Entity? {
  match resolve_pointer_target(input~, position) {
    Some(entity) => Some(entity)
    None =>
      match scrollable_target_at(input~, position) {
        Some(entity) => Some(entity)
        None => blocking_target_at(input~, position)
      }
  }
}

///|
fn clear_invalid_pointer_captures(
  input~ : UiInput,
  runtime : UiInteractionRuntime,
) -> Unit {
  let stale : Array[@inputs.PointerId] = []
  for id, entity in runtime.pointer_captures {
    if !input.entities.is_alive(entity) ||
      !input.model.geometry.contains(entity) {
      stale.push(id)
    }
  }
  for id in stale {
    ignore(runtime.pointer_captures.remove(id))
  }
}

///|
fn update_pointer_capture_for_event(
  input~ : UiInput,
  runtime : UiInteractionRuntime,
  event : @inputs.PointerEvent,
) -> Unit {
  match event.phase {
    Down =>
      if touch_capture_target_at(input~, event.position) is Some(entity) {
        runtime.pointer_captures.set(event.id, entity)
        runtime.consumed_pointers.add(event.id)
      }
    Move =>
      if runtime.pointer_captures.contains(event.id) {
        runtime.consumed_pointers.add(event.id)
      }
    Up | Cancel =>
      if runtime.pointer_captures.contains(event.id) {
        runtime.consumed_pointers.add(event.id)
        ignore(runtime.pointer_captures.remove(event.id))
      }
  }
}

///|
pub fn ui_input_capture_system(input : UiInput) -> Unit {
  let runtime = input.runtime
  runtime.consumed_pointers.clear()
  clear_invalid_pointer_captures(input~, runtime)
  for id, _entity in runtime.pointer_captures {
    if @inputs.is_pointer_active(id) {
      runtime.consumed_pointers.add(id)
    }
  }
  for event in @inputs.pointer_changes_this_frame() {
    update_pointer_capture_for_event(input~, runtime, event)
  }
}

///|
fn apply_scroll_delta(
  input~ : UiInput,
  entity : @ecs.Entity,
  delta : @math.Vec2,
) -> Unit {
  guard input.nodes.get(entity).map(value => value.0) is Some(node) else {
    return
  }
  guard input.model.geometry.get(entity).map(value => value.computed)
    is Some(computed) else {
    return
  }
  let scroll = input.model.scroll_positions.get_or_init(
    entity,
    ScrollPosition::zero,
  )
  if node.overflow_x == Scroll {
    scroll.x = @cmp.minimum(
      computed.max_scroll_position.x,
      @cmp.maximum(0.0, scroll.x + delta.x),
    )
  }
  if node.overflow_y == Scroll {
    scroll.y = @cmp.minimum(
      computed.max_scroll_position.y,
      @cmp.maximum(0.0, scroll.y + delta.y),
    )
  }
}

///|
fn update_scroll(input~ : UiInput, position : @math.Vec2) -> Unit {
  let delta = @inputs.mouse_wheel.delta
  if delta.x == 0.0 && delta.y == 0.0 {
    return
  }
  if scrollable_target_at(input~, position) is Some(entity) {
    apply_scroll_delta(input~, entity, Vec2(delta.x * 16.0, delta.y * 16.0))
  }
}

///|
fn update_contact_drag_scroll(input~ : UiInput) -> Unit {
  for event in @inputs.pointer_changes_this_frame() {
    if event.source != PointerMouse && event.primary && event.phase == Move {
      if scrollable_target_at(input~, event.previous_position) is Some(entity) {
        // Dragging content down should move the scroll offset up.
        apply_scroll_delta(input~, entity, Vec2(-event.delta.x, -event.delta.y))
      }
      return
    }
  }
}

///|
fn sanitize_focus(input~ : UiInput) -> Unit {
  match input.runtime.focused_entity {
    Some(entity) =>
      if !input.entities.is_alive(entity) ||
        !input.model.geometry.contains(entity) ||
        !is_focusable(input~, entity) ||
        !input.visibility.is_visible(entity) {
        input.blur()
      }
    None => ()
  }
}

///|
fn active_primary_contact() -> Bool {
  match @inputs.primary_touch() {
    Some(_) => true
    None => false
  }
}

///|
fn primary_pointer_change(
  phase : @inputs.PointerPhase,
) -> @inputs.PointerEvent? {
  for event in @inputs.pointer_changes_this_frame() {
    if event.primary && event.phase == phase {
      return Some(event)
    }
  }
  None
}

///|
fn contact_pointer_changed_this_frame() -> Bool {
  for event in @inputs.pointer_changes_this_frame() {
    if event.source != PointerMouse && event.primary {
      return true
    }
  }
  false
}

///|
fn update_hover_from_mouse(
  input~ : UiInput,
  position : @math.Vec2,
) -> @ecs.Entity? {
  let runtime = input.runtime
  let hovered = resolve_pointer_target(input~, position)
  if runtime.hovered_entity != hovered {
    if runtime.hovered_entity is Some(previous) {
      input.pointer_leave.send({ entity: previous, })
    }
    if hovered is Some(current) {
      input.pointer_enter.send({ entity: current, })
    }
    runtime.hovered_entity = hovered
  }
  hovered
}

///|
fn clear_touch_hover(input~ : UiInput) -> Unit {
  let runtime = input.runtime
  if runtime.hovered_entity is Some(previous) {
    input.pointer_leave.send({ entity: previous, })
  }
  runtime.hovered_entity = None
}

///|
pub fn ui_interaction_system(input : UiInput) -> Unit {
  let query_button = input.buttons
  let runtime = input.runtime
  sanitize_focus(input~)
  let pointer_position = @inputs.primary_pointer_position()
  update_relative_cursor_positions(input~, pointer_position)
  update_scroll(input~, pointer_position)
  update_contact_drag_scroll(input~)
  let contact_active = active_primary_contact() ||
    contact_pointer_changed_this_frame()
  let visual_hover : @ecs.Entity? = if contact_active {
    clear_touch_hover(input~)
    None
  } else {
    update_hover_from_mouse(input~, @inputs.mouse.pos)
  }

  let pointer_down = primary_pointer_change(Down)
  if pointer_down is Some(event) {
    let target_at_press = resolve_pointer_target(input~, event.position)
    if target_at_press is Some(target) {
      runtime.pressed_entity = Some(target)
      runtime.pressed_pointer = Some(event.id)
      input.pointer_down.send({
        entity: target,
        button: Left,
        position: event.position,
      })
      if is_focusable(input~, target) {
        input.focus(target)
      } else {
        input.blur()
      }
    }
  }

  let pointer_up = primary_pointer_change(Up)
  let pointer_cancelled = primary_pointer_change(Cancel)
  let release = match (pointer_up, pointer_cancelled) {
    (Some(event), _) => Some(event)
    (_, Some(event)) => Some(event)
    _ => None
  }
  if release is Some(event) &&
    runtime.pressed_entity is Some(pressed) &&
    runtime.pressed_pointer is Some(pointer) &&
    pointer == event.id {
    let target_at_release = resolve_pointer_target(input~, event.position)
    input.pointer_up.send({
      entity: pressed,
      button: Left,
      position: event.position,
    })
    if event.phase != Cancel &&
      target_at_release is Some(target) &&
      target == pressed &&
      is_interactive(input~, pressed) {
      input.click.send({ entity: pressed, button: Left, })
    }
    runtime.pressed_entity = None
    runtime.pressed_pointer = None
  }

  if @inputs.is_just_pressed(Tab) {
    move_focus_by_tab(input~, @inputs.is_pressed(ShiftLeft))
    input.navigation.send({
      entity: runtime.focused_entity,
      direction: if @inputs.is_pressed(ShiftLeft) {
        Left
      } else {
        Right
      },
    })
  }
  if @inputs.is_just_pressed(ArrowLeft) ||
    input.gamepads.button_just_pressed(Gamepad(0), DPadLeft) {
    move_focus(input~, Left)
    input.navigation.send({ entity: runtime.focused_entity, direction: Left, })
  }
  if @inputs.is_just_pressed(ArrowRight) ||
    input.gamepads.button_just_pressed(Gamepad(0), DPadRight) {
    move_focus(input~, Right)
    input.navigation.send({ entity: runtime.focused_entity, direction: Right, })
  }
  if @inputs.is_just_pressed(ArrowUp) ||
    input.gamepads.button_just_pressed(Gamepad(0), DPadUp) {
    move_focus(input~, Up)
    input.navigation.send({ entity: runtime.focused_entity, direction: Up, })
  }
  if @inputs.is_just_pressed(ArrowDown) ||
    input.gamepads.button_just_pressed(Gamepad(0), DPadDown) {
    move_focus(input~, Down)
    input.navigation.send({ entity: runtime.focused_entity, direction: Down, })
  }
  if @inputs.is_just_pressed(Escape) ||
    input.gamepads.button_just_pressed(Gamepad(0), East) {
    input.navigation.send({ entity: runtime.focused_entity, direction: Cancel, })
  }
  if (
      @inputs.is_just_pressed(Enter) ||
      @inputs.is_just_pressed(Space) ||
      input.gamepads.button_just_pressed(Gamepad(0), South)
    ) &&
    runtime.focused_entity is Some(target) &&
    is_interactive(input~, target) {
    input.click.send({ entity: target, button: Left, })
    input.navigation.send({ entity: Some(target), direction: Activate, })
  }

  for entity, Single(_button) in query_button {
    if input.entities.is_alive(entity) {
      input.model.interactions.set(
        entity,
        interaction_state(input~, entity, visual_hover),
      )
    }
  }
}

///|
struct PointerConsumption {
  consumed : Set[@inputs.PointerId]
}

///|
pub fn PointerConsumption::PointerConsumption(
  world : @ecs.World,
) -> PointerConsumption {
  { consumed: ui_interaction_runtime(world~).consumed_pointers, }
}

///|
pub fn PointerConsumption::consume_touch(
  self : PointerConsumption,
  id : @inputs.TouchId,
) -> Unit {
  self.consumed.add(pointer_id_for_touch(id))
}

///|
pub fn PointerConsumption::unconsumed_touch_changes(
  self : PointerConsumption,
) -> Array[@inputs.TouchEvent] {
  @inputs.touch_changes_this_frame().filter(event => {
    !self.consumed.contains(@inputs.pointer_event_from_touch(event).id)
  })
}

///|
pub impl @ecs.SystemParam for PointerConsumption with fn prepare(world) {
  let consumption = PointerConsumption(world)
  _ => consumption
}

///|
pub extend PointerConsumption with @ecs.SystemParam::{prepare}

///|
/// Retained UI interaction state, component queries, and event outputs.
struct UiInput {
  runtime : UiInteractionRuntime
  gamepads : @inputs.GamepadInput
  model : UiModelWorldStore
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
  visibility : @visibility.VisibilityState
  tab_indices : @ecs.Query[@ecs.Single[TabIndex]]
  nodes : @ecs.Query[@ecs.Single[Node]]
  focusables : @ecs.Query[@ecs.Single[Focusable]]
  cursor_positions : @ecs.Query[@ecs.Single[RelativeCursorPosition]]
  buttons : @ecs.Query[@ecs.Single[Button]]
  focus_policies : @ecs.Query[@ecs.Single[FocusPolicy]]
  pointer_leave : @event.EventWriter[UiPointerLeaveEvent]
  pointer_enter : @event.EventWriter[UiPointerEnterEvent]
  pointer_down : @event.EventWriter[UiPointerDownEvent]
  pointer_up : @event.EventWriter[UiPointerUpEvent]
  click : @event.EventWriter[UiClickEvent]
  navigation : @event.EventWriter[UiNavigationEvent]
  focus_out : @event.EventWriter[UiFocusOutEvent]
  focus_in : @event.EventWriter[UiFocusInEvent]
}

///|
pub fn UiInput::UiInput(world : @ecs.World) -> UiInput {
  {
    runtime: ui_interaction_runtime(world~),
    gamepads: GamepadInput(world),
    model: ui_model_world_store(world~),
    entities: Entities(world),
    hierarchy: Hierarchy(world),
    visibility: VisibilityState(world),
    tab_indices: world.query(),
    nodes: world.query(),
    focusables: world.query(),
    cursor_positions: world.query(),
    buttons: world.query(),
    focus_policies: world.query(),
    pointer_leave: pointer_leave_event_bus.writer(world~),
    pointer_enter: pointer_enter_event_bus.writer(world~),
    pointer_down: pointer_down_event_bus.writer(world~),
    pointer_up: pointer_up_event_bus.writer(world~),
    click: click_event_bus.writer(world~),
    navigation: navigation_event_bus.writer(world~),
    focus_out: focus_out_event_bus.writer(world~),
    focus_in: focus_in_event_bus.writer(world~),
  }
}

///|
pub impl @ecs.SystemParam for UiInput with fn prepare(world) {
  let input = UiInput(world)
  _ => input
}

///|
pub extend UiInput with @ecs.SystemParam::{prepare}

///|
pub fn focus(entity : @ecs.Entity) -> Unit {
  UiInput(@ecs.require_current_world()).focus(entity)
}

///|
pub fn blur() -> Unit {
  UiInput(@ecs.require_current_world()).blur()
}

///|
pub fn UiInput::focused_entity(self : UiInput) -> @ecs.Entity? {
  self.runtime.focused_entity
}
