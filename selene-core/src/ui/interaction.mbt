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
pub let pointer_enter_event_bus : @event.Events[UiPointerEnterEvent] = @event.Events::new()

///|
pub let pointer_leave_event_bus : @event.Events[UiPointerLeaveEvent] = @event.Events::new()

///|
pub let pointer_down_event_bus : @event.Events[UiPointerDownEvent] = @event.Events::new()

///|
pub let pointer_up_event_bus : @event.Events[UiPointerUpEvent] = @event.Events::new()

///|
pub let click_event_bus : @event.Events[UiClickEvent] = @event.Events::new()

///|
pub let navigation_event_bus : @event.Events[UiNavigationEvent] = @event.Events::new()

///|
pub let focus_in_event_bus : @event.Events[UiFocusInEvent] = @event.Events::new()

///|
pub let focus_out_event_bus : @event.Events[UiFocusOutEvent] = @event.Events::new()

///|
priv struct UiInteractionRuntime {
  mut hovered_entity : @entity.Entity?
  mut pressed_entity : @entity.Entity?
  mut focused_entity : @entity.Entity?
}

///|
let ui_interaction_runtimes : Map[UInt, UiInteractionRuntime] = Map::new()

///|
fn ui_interaction_runtime() -> UiInteractionRuntime {
  let world_id = @ecs.require_current_world().id()
  ui_interaction_runtimes.get_or_init(world_id, () => {
    hovered_entity: None,
    pressed_entity: None,
    focused_entity: None,
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
fn clear_focus_marker(entity : @entity.Entity) -> Unit {
  focuseds().remove(entity)
}

///|
fn set_focus_marker(entity : @entity.Entity) -> Unit {
  focuseds().set(entity, Focused::new())
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
    @inputs.is_mouse_pressed(@inputs.MouseButton::Left) {
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
  @math.Vec2(
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
      @math.Vec2(
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
fn update_scroll(position : @math.Vec2) -> Unit {
  let delta = @inputs.mouse_wheel.delta
  if delta[X] == 0.0 && delta[Y] == 0.0 {
    return
  }
  let mut target = resolve_pointer_target(position)
  while target is Some(entity) {
    guard nodes().get(entity) is Some(node) else {
      target = entity.get_parent()
      continue
    }
    if node.overflow_x == Scroll || node.overflow_y == Scroll {
      let scroll = scroll_positions().get_or_init(entity, ScrollPosition::zero)
      if node.overflow_x == Scroll {
        scroll.x = @cmp.maximum(0.0, scroll.x + delta[X] * 16.0)
      }
      if node.overflow_y == Scroll {
        scroll.y = @cmp.maximum(0.0, scroll.y + delta[Y] * 16.0)
      }
      return
    }
    target = entity.get_parent()
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
pub fn ui_interaction_system(_delta : Double) -> Unit {
  let runtime = ui_interaction_runtime()
  sanitize_focus()
  let mouse_position = @inputs.mouse.pos
  update_relative_cursor_positions(mouse_position)
  update_scroll(mouse_position)
  let hovered = resolve_pointer_target(mouse_position)
  if runtime.hovered_entity != hovered {
    if runtime.hovered_entity is Some(previous) {
      pointer_leave_event_bus.send({ entity: previous })
    }
    if hovered is Some(current) {
      pointer_enter_event_bus.send({ entity: current })
    }
    runtime.hovered_entity = hovered
  }

  if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
    hovered is Some(target) {
    runtime.pressed_entity = Some(target)
    pointer_down_event_bus.send({
      entity: target,
      button: @inputs.MouseButton::Left,
      position: mouse_position,
    })
    if is_focusable(target) {
      focus(target)
    } else {
      blur()
    }
  }

  if @inputs.is_mouse_just_released(@inputs.MouseButton::Left) &&
    runtime.pressed_entity is Some(pressed) {
    pointer_up_event_bus.send({
      entity: pressed,
      button: @inputs.MouseButton::Left,
      position: mouse_position,
    })
    if hovered is Some(target) && target == pressed && is_interactive(pressed) {
      click_event_bus.send({
        entity: pressed,
        button: @inputs.MouseButton::Left,
      })
    }
    runtime.pressed_entity = None
  }

  if @inputs.is_just_pressed(@inputs.Tab) {
    move_focus_by_tab(@inputs.is_pressed(@inputs.ShiftLeft))
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: if @inputs.is_pressed(@inputs.ShiftLeft) {
        Left
      } else {
        Right
      },
    })
  }
  if @inputs.is_just_pressed(@inputs.ArrowLeft) ||
    @inputs.is_gamepad_button_just_pressed(
      @inputs.Gamepad::new(0),
      @inputs.DPadLeft,
    ) {
    move_focus(Left)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Left,
    })
  }
  if @inputs.is_just_pressed(@inputs.ArrowRight) ||
    @inputs.is_gamepad_button_just_pressed(
      @inputs.Gamepad::new(0),
      @inputs.DPadRight,
    ) {
    move_focus(Right)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Right,
    })
  }
  if @inputs.is_just_pressed(@inputs.ArrowUp) ||
    @inputs.is_gamepad_button_just_pressed(
      @inputs.Gamepad::new(0),
      @inputs.DPadUp,
    ) {
    move_focus(Up)
    navigation_event_bus.send({ entity: runtime.focused_entity, direction: Up })
  }
  if @inputs.is_just_pressed(@inputs.ArrowDown) ||
    @inputs.is_gamepad_button_just_pressed(
      @inputs.Gamepad::new(0),
      @inputs.DPadDown,
    ) {
    move_focus(Down)
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Down,
    })
  }
  if @inputs.is_just_pressed(@inputs.Escape) ||
    @inputs.is_gamepad_button_just_pressed(
      @inputs.Gamepad::new(0),
      @inputs.East,
    ) {
    navigation_event_bus.send({
      entity: runtime.focused_entity,
      direction: Cancel,
    })
  }
  if (
      @inputs.is_just_pressed(@inputs.Enter) ||
      @inputs.is_just_pressed(@inputs.Space) ||
      @inputs.is_gamepad_button_just_pressed(
        @inputs.Gamepad::new(0),
        @inputs.South,
      )
    ) &&
    runtime.focused_entity is Some(target) &&
    is_interactive(target) {
    click_event_bus.send({ entity: target, button: @inputs.MouseButton::Left })
    navigation_event_bus.send({ entity: Some(target), direction: Activate })
  }

  for entity, _button in buttons() {
    if entity.is_alive() {
      interactions().set(entity, interaction_state(entity, hovered))
    }
  }
}
