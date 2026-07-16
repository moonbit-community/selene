///|
pub(all) struct UiPointerEnterEvent {
  entity : @entity.Entity
}

///|
pub(all) struct UiPointerLeaveEvent {
  entity : @entity.Entity
}

///|
pub(all) struct UiPointerDownEvent {
  entity : @entity.Entity
  button : @inputs.MouseButton
  position : @math.Vec2
}

///|
pub(all) struct UiPointerUpEvent {
  entity : @entity.Entity
  button : @inputs.MouseButton
  position : @math.Vec2
}

///|
pub(all) struct UiClickEvent {
  entity : @entity.Entity
  button : @inputs.MouseButton
}

///|
pub(all) enum UiNavigationDirection {
  Up
  Down
  Left
  Right
  Activate
  Cancel
} derive(Eq, Debug)

///|
pub(all) struct UiNavigationEvent {
  entity : @entity.Entity?
  direction : UiNavigationDirection
}

///|
pub(all) struct UiFocusInEvent {
  entity : @entity.Entity
}

///|
pub(all) struct UiFocusOutEvent {
  entity : @entity.Entity
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
  mut hovered_entity : @entity.Entity?
  mut pressed_entity : @entity.Entity?
  mut pressed_pointer : @inputs.PointerId?
  mut focused_entity : @entity.Entity?
  pointer_captures : Map[@inputs.PointerId, @entity.Entity]
  consumed_pointers : Set[@inputs.PointerId]
}

///|
let ui_interaction_runtimes : Map[UInt, UiInteractionRuntime] = Map([])

///|
fn ui_interaction_runtime() -> UiInteractionRuntime {
  let world_id = @ecs.require_current_world().id()
  ui_interaction_runtimes.get_or_init(world_id, () => {
    hovered_entity: None,
    pressed_entity: None,
    pressed_pointer: None,
    focused_entity: None,
    pointer_captures: Map([]),
    consumed_pointers: Set([]),
  })
}

///|
pub fn hovered_entity() -> @entity.Entity? {
  ui_interaction_runtime().hovered_entity
}

///|
pub fn focused_entity() -> @entity.Entity? {
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
      { source: PointerTouch, value: id.value() }
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
fn clear_focus_marker(entity : @entity.Entity) -> Unit {
  focuseds().remove(entity)
}

///|
fn set_focus_marker(entity : @entity.Entity) -> Unit {
  focuseds().set(entity, Focused())
}

///|
pub fn focus(entity : @entity.Entity) -> Unit {
  let runtime = ui_interaction_runtime()
  if runtime.focused_entity is Some(current) && current == entity {
    return
  }
  if runtime.focused_entity is Some(current) {
    clear_focus_marker(current)
    focus_out_event_bus.send({ entity: current })
  }
  runtime.focused_entity = Some(entity)
  set_focus_marker(entity)
  focus_in_event_bus.send({ entity, })
}

///|
pub fn blur() -> Unit {
  let runtime = ui_interaction_runtime()
  if runtime.focused_entity is Some(current) {
    clear_focus_marker(current)
    focus_out_event_bus.send({ entity: current })
  }
  runtime.focused_entity = None
}

///|
fn is_interactive(entity : @entity.Entity) -> Bool {
  buttons().get(entity).map(fn(button) { button.enabled }).unwrap_or(false)
}

///|
fn is_focusable(entity : @entity.Entity) -> Bool {
  if is_interactive(entity) {
    true
  } else {
    focusables().contains(entity)
  }
}

///|
fn button_blocks_pointer(entity : @entity.Entity) -> Bool {
  focus_policies().get(entity).unwrap_or(Pass) == Block
}

///|
fn interaction_state(
  entity : @entity.Entity,
  hovered : @entity.Entity?,
) -> Interaction {
  let runtime = ui_interaction_runtime()
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
fn sorted_ui_entities() -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  for entity, node in nodes() {
    if entity.is_alive() &&
      node.active &&
      node.display != None &&
      @visibility.is_visible(entity) &&
      global_ui_nodes().contains(entity) {
      entities.push(entity)
    }
  }
  entities.sort_by(compare_ui_stacking)
  entities
}

///|
fn focusable_entities() -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  for entity in sorted_ui_entities() {
    if is_focusable(entity) {
      entities.push(entity)
    }
  }
  entities.sort_by(fn(lhs, rhs) {
    let lt = tab_indexes().get(lhs).map(fn(value) { value.value }).unwrap_or(0)
    let rt = tab_indexes().get(rhs).map(fn(value) { value.value }).unwrap_or(0)
    if lt != rt {
      lt - rt
    } else {
      tree_orders().get(lhs).unwrap_or(0) - tree_orders().get(rhs).unwrap_or(0)
    }
  })
  entities
}

///|
fn rect_center(rect : @math.Rect) -> @math.Vec2 {
  Vec2(
    rect.position[X] + rect.size[X] / 2.0,
    rect.position[Y] + rect.size[Y] / 2.0,
  )
}

///|
fn directional_score(
  current : @math.Vec2,
  candidate : @math.Vec2,
  direction : UiNavigationDirection,
) -> (Double, Double)? {
  let delta = candidate - current
  match direction {
    Left =>
      if delta[X] < 0.0 {
        Some((-delta[X], delta[Y].abs()))
      } else {
        None
      }
    Right =>
      if delta[X] > 0.0 {
        Some((delta[X], delta[Y].abs()))
      } else {
        None
      }
    Up => if delta[Y] < 0.0 { Some((-delta[Y], delta[X].abs())) } else { None }
    Down => if delta[Y] > 0.0 { Some((delta[Y], delta[X].abs())) } else { None }
    Activate | Cancel => None
  }
}

///|
fn move_focus(direction : UiNavigationDirection) -> Unit {
  let entities = focusable_entities()
  if entities.is_empty() {
    blur()
    return
  }
  let runtime = ui_interaction_runtime()
  let current = runtime.focused_entity.unwrap_or(entities[0])
  if !global_ui_nodes().contains(current) {
    focus(entities[0])
    return
  }
  let current_center = rect_center(
    global_ui_nodes().get(current).unwrap().screen_rect,
  )
  let mut best_entity : @entity.Entity? = None
  let mut best_primary = 0.0
  let mut best_secondary = 0.0
  let mut has_best = false
  for entity in entities {
    guard entity != current else { continue }
    guard global_ui_nodes().get(entity) is Some(transform) else { continue }
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
    Some(entity) => focus(entity)
    None => if runtime.focused_entity is None { focus(entities[0]) }
  }
}

///|
fn move_focus_by_tab(reverse : Bool) -> Unit {
  let entities = focusable_entities()
  if entities.is_empty() {
    blur()
    return
  }
  let runtime = ui_interaction_runtime()
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
      focus(entities[next])
    }
    None => focus(entities[0])
  }
}

///|
fn point_in_rect(point : @math.Vec2, rect : @math.Rect) -> Bool {
  point[X] >= rect.position[X] &&
  point[Y] >= rect.position[Y] &&
  point[X] <= rect.position[X] + rect.size[X] &&
  point[Y] <= rect.position[Y] + rect.size[Y]
}

///|
fn screen_clip_allows(entity : @entity.Entity, point : @math.Vec2) -> Bool {
  let within_target_viewport = global_ui_nodes()
    .get(entity)
    .map(fn(transform) { point_in_rect(point, transform.target_viewport) })
    .unwrap_or(true)
  if !within_target_viewport {
    return false
  }
  match calculated_clips().get(entity) {
    Some(clip) => point_in_rect(point, clip.clip)
    None => true
  }
}

///|
fn normalized_cursor_position(
  point : @math.Vec2,
  rect : @math.Rect,
) -> @math.Vec2? {
  if rect.size[X] <= 0.0 || rect.size[Y] <= 0.0 {
    None
  } else {
    Some(
      Vec2(
        (point[X] - rect.position[X]) / rect.size[X] - 0.5,
        (point[Y] - rect.position[Y]) / rect.size[Y] - 0.5,
      ),
    )
  }
}

///|
fn update_relative_cursor_positions(position : @math.Vec2) -> Unit {
  for entity, relative in relative_cursor_positions() {
    guard entity.is_alive() else { continue }
    guard nodes().get(entity) is Some(node) else {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    guard global_ui_nodes().get(entity) is Some(transform) else {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    if !node.active || node.display == None || !@visibility.is_visible(entity) {
      relative.normalized = None
      relative.cursor_over = false
      continue
    }
    relative.normalized = normalized_cursor_position(
      position,
      transform.screen_rect,
    )
    relative.cursor_over = point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(entity, position)
  }
}

///|
fn resolve_pointer_target(position : @math.Vec2) -> @entity.Entity? {
  let candidates = sorted_ui_entities()
  let mut index = candidates.length() - 1
  while index >= 0 {
    let entity = candidates[index]
    guard global_ui_nodes().get(entity) is Some(transform) else {
      index -= 1
      continue
    }
    if point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(entity, position) {
      if is_interactive(entity) {
        return Some(entity)
      }
      if button_blocks_pointer(entity) {
        return None
      }
    }
    index -= 1
  }
  None
}

///|
fn ui_node_at(position : @math.Vec2) -> @entity.Entity? {
  let candidates = sorted_ui_entities()
  let mut index = candidates.length() - 1
  while index >= 0 {
    let entity = candidates[index]
    guard global_ui_nodes().get(entity) is Some(transform) else {
      index -= 1
      continue
    }
    if point_in_rect(position, transform.screen_rect) &&
      screen_clip_allows(entity, position) {
      return Some(entity)
    }
    index -= 1
  }
  None
}

///|
fn scrollable_target_at(position : @math.Vec2) -> @entity.Entity? {
  let mut target = ui_node_at(position)
  while target is Some(entity) {
    guard nodes().get(entity) is Some(node) else {
      target = entity.get_parent()
      continue
    }
    if node.overflow_x == Scroll || node.overflow_y == Scroll {
      return Some(entity)
    }
    target = entity.get_parent()
  }
  None
}

///|
fn blocking_target_at(position : @math.Vec2) -> @entity.Entity? {
  let mut target = ui_node_at(position)
  while target is Some(entity) {
    if button_blocks_pointer(entity) {
      return Some(entity)
    }
    target = entity.get_parent()
  }
  None
}

///|
fn touch_capture_target_at(position : @math.Vec2) -> @entity.Entity? {
  match resolve_pointer_target(position) {
    Some(entity) => Some(entity)
    None =>
      match scrollable_target_at(position) {
        Some(entity) => Some(entity)
        None => blocking_target_at(position)
      }
  }
}

///|
fn clear_invalid_pointer_captures(runtime : UiInteractionRuntime) -> Unit {
  let stale : Array[@inputs.PointerId] = []
  for id, entity in runtime.pointer_captures {
    if !entity.is_alive() || !global_ui_nodes().contains(entity) {
      stale.push(id)
    }
  }
  for id in stale {
    ignore(runtime.pointer_captures.remove(id))
  }
}

///|
fn update_pointer_capture_for_event(
  runtime : UiInteractionRuntime,
  event : @inputs.PointerEvent,
) -> Unit {
  match event.phase {
    Down =>
      if touch_capture_target_at(event.position) is Some(entity) {
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
pub fn ui_input_capture_system(_delta : Double) -> Unit {
  let runtime = ui_interaction_runtime()
  runtime.consumed_pointers.clear()
  clear_invalid_pointer_captures(runtime)
  for id, _entity in runtime.pointer_captures {
    if @inputs.is_pointer_active(id) {
      runtime.consumed_pointers.add(id)
    }
  }
  for event in @inputs.pointer_changes_this_frame() {
    update_pointer_capture_for_event(runtime, event)
  }
}

///|
fn apply_scroll_delta(entity : @entity.Entity, delta : @math.Vec2) -> Unit {
  guard nodes().get(entity) is Some(node) else { return }
  let scroll = scroll_positions().get_or_init(entity, ScrollPosition::zero)
  if node.overflow_x == Scroll {
    scroll.x = @cmp.maximum(0.0, scroll.x + delta[X])
  }
  if node.overflow_y == Scroll {
    scroll.y = @cmp.maximum(0.0, scroll.y + delta[Y])
  }
}

///|
fn update_scroll(position : @math.Vec2) -> Unit {
  let delta = @inputs.mouse_wheel.delta
  if delta[X] == 0.0 && delta[Y] == 0.0 {
    return
  }
  if scrollable_target_at(position) is Some(entity) {
    apply_scroll_delta(entity, Vec2(delta[X] * 16.0, delta[Y] * 16.0))
  }
}

///|
fn update_contact_drag_scroll() -> Unit {
  for event in @inputs.pointer_changes_this_frame() {
    if event.source != PointerMouse && event.primary && event.phase == Move {
      if scrollable_target_at(event.previous_position) is Some(entity) {
        // Dragging content down should move the scroll offset up.
        apply_scroll_delta(entity, Vec2(-event.delta[X], -event.delta[Y]))
      }
      return
    }
  }
}

///|
fn sanitize_focus() -> Unit {
  match ui_interaction_runtime().focused_entity {
    Some(entity) =>
      if !entity.is_alive() ||
        !global_ui_nodes().contains(entity) ||
        !is_focusable(entity) ||
        !@visibility.is_visible(entity) {
        blur()
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
fn update_hover_from_mouse(position : @math.Vec2) -> @entity.Entity? {
  let runtime = ui_interaction_runtime()
  let hovered = resolve_pointer_target(position)
  if runtime.hovered_entity != hovered {
    if runtime.hovered_entity is Some(previous) {
      pointer_leave_event_bus.send({ entity: previous })
    }
    if hovered is Some(current) {
      pointer_enter_event_bus.send({ entity: current })
    }
    runtime.hovered_entity = hovered
  }
  hovered
}

///|
fn clear_touch_hover() -> Unit {
  let runtime = ui_interaction_runtime()
  if runtime.hovered_entity is Some(previous) {
    pointer_leave_event_bus.send({ entity: previous })
  }
  runtime.hovered_entity = None
}

///|
pub fn ui_interaction_system(_delta : Double) -> Unit {
  let runtime = ui_interaction_runtime()
  sanitize_focus()
  let pointer_position = @inputs.primary_pointer_position()
  update_relative_cursor_positions(pointer_position)
  update_scroll(pointer_position)
  update_contact_drag_scroll()
  let contact_active = active_primary_contact() ||
    contact_pointer_changed_this_frame()
  let visual_hover : @entity.Entity? = if contact_active {
    clear_touch_hover()
    None
  } else {
    update_hover_from_mouse(@inputs.mouse.pos)
  }

  let pointer_down = primary_pointer_change(Down)
  if pointer_down is Some(event) {
    let target_at_press = resolve_pointer_target(event.position)
    if target_at_press is Some(target) {
      runtime.pressed_entity = Some(target)
      runtime.pressed_pointer = Some(event.id)
      pointer_down_event_bus.send({
        entity: target,
        button: Left,
        position: event.position,
      })
      if is_focusable(target) {
        focus(target)
      } else {
        blur()
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
    let target_at_release = resolve_pointer_target(event.position)
    pointer_up_event_bus.send({
      entity: pressed,
      button: Left,
      position: event.position,
    })
    if event.phase != Cancel &&
      target_at_release is Some(target) &&
      target == pressed &&
      is_interactive(pressed) {
      click_event_bus.send({ entity: pressed, button: Left })
    }
    runtime.pressed_entity = None
    runtime.pressed_pointer = None
  }

  if @inputs.is_just_pressed(Tab) {
    move_focus_by_tab(@inputs.is_pressed(ShiftLeft))
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: if @inputs.is_pressed(ShiftLeft) {
        Left
      } else {
        Right
      },
    })
  }
  if @inputs.is_just_pressed(ArrowLeft) ||
    @inputs.is_gamepad_button_just_pressed(Gamepad(0), DPadLeft) {
    move_focus(Left)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Left,
    })
  }
  if @inputs.is_just_pressed(ArrowRight) ||
    @inputs.is_gamepad_button_just_pressed(
      Gamepad(0),
      DPadRight,
    ) {
    move_focus(Right)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Right,
    })
  }
  if @inputs.is_just_pressed(ArrowUp) ||
    @inputs.is_gamepad_button_just_pressed(Gamepad(0), DPadUp) {
    move_focus(Up)
    navigation_event_bus.send({ entity: runtime.focused_entity, direction: Up })
  }
  if @inputs.is_just_pressed(ArrowDown) ||
    @inputs.is_gamepad_button_just_pressed(Gamepad(0), DPadDown) {
    move_focus(Down)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Down,
    })
  }
  if @inputs.is_just_pressed(Escape) ||
    @inputs.is_gamepad_button_just_pressed(Gamepad(0), East) {
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Cancel,
    })
  }
  if (
      @inputs.is_just_pressed(Enter) ||
      @inputs.is_just_pressed(Space) ||
      @inputs.is_gamepad_button_just_pressed(Gamepad(0), South)
    ) &&
    runtime.focused_entity is Some(target) &&
    is_interactive(target) {
    click_event_bus.send({ entity: target, button: Left })
    navigation_event_bus.send({ entity: Some(target), direction: Activate })
  }

  for entity, _button in buttons() {
    if entity.is_alive() {
      interactions().set(entity, interaction_state(entity, visual_hover))
    }
  }
}
