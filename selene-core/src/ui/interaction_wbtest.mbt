///|
fn with_ui_interaction_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn cleanup_interaction_test_entity(entity : @entity.Entity) -> Unit {
  nodes().remove(entity)
  computed_ui_nodes().remove(entity)
  global_ui_nodes().remove(entity)
  ui_target_cameras().remove(entity)
  calculated_clips().remove(entity)
  layout_configs().remove(entity)
  z_indexes().remove(entity)
  global_zindexes().remove(entity)
  scroll_positions().remove(entity)
  tab_indexes().remove(entity)
  focus_policies().remove(entity)
  focusables().remove(entity)
  focuseds().remove(entity)
  override_clips().remove(entity)
  relative_cursor_positions().remove(entity)
  background_colors().remove(entity)
  border_colors().remove(entity)
  border_radii().remove(entity)
  box_shadows().remove(entity)
  outlines().remove(entity)
  material_nodes().remove(entity)
  ui_images().remove(entity)
  texts().remove(entity)
  text_fonts().remove(entity)
  text_colors().remove(entity)
  text_layouts().remove(entity)
  buttons().remove(entity)
  interactions().remove(entity)
  tree_orders().remove(entity)
  entity.destroy()
}

///|
fn reset_interaction_test_state() -> Unit {
  let runtime = ui_interaction_runtime()
  runtime.hovered_entity = None
  runtime.pressed_entity = None
  runtime.focused_entity = None
  @inputs.apply_input_snapshot(@inputs.empty_input_snapshot())
  @inputs.just_pressed_mouse.left_button = false
  @inputs.just_pressed_mouse.right_button = false
  @inputs.just_pressed_mouse.middle_button = false
  @inputs.just_release_mouse.left_button = false
  @inputs.just_release_mouse.right_button = false
  @inputs.just_release_mouse.middle_button = false
  @inputs.clear_touch_state()
  pointer_down_event_bus.clear()
  pointer_up_event_bus.clear()
  pointer_enter_event_bus.clear()
  pointer_leave_event_bus.clear()
  click_event_bus.clear()
}

///|
fn interaction_test_global_node(rect : @math.Rect) -> GlobalUiNode {
  {
    logical_rect: rect,
    screen_rect: rect,
    logical_content_rect: rect,
    screen_content_rect: rect,
    target_camera: None,
    target_viewport: rect,
  }
}

///|
fn spawn_interaction_test_node(
  rect : @math.Rect,
  interactive? : Bool = true,
  overflow_y? : Overflow = Visible,
) -> @entity.Entity {
  let entity = @entity.Entity()
  nodes().set(entity, Node(overflow_y~))
  global_ui_nodes().set(entity, interaction_test_global_node(rect))
  if interactive {
    buttons().set(entity, Button())
  }
  entity
}

///|
fn touch_point(
  id : @inputs.TouchId,
  position : @math.Vec2,
  previous_position? : @math.Vec2 = position,
) -> @inputs.TouchPoint {
  {
    id,
    position,
    previous_position,
    delta: position - previous_position,
    primary: true,
  }
}

///|
fn touch_event(
  id : @inputs.TouchId,
  phase : @inputs.TouchPhase,
  position : @math.Vec2,
  previous_position? : @math.Vec2 = position,
) -> @inputs.TouchEvent {
  {
    id,
    phase,
    position,
    previous_position,
    delta: position - previous_position,
    primary: true,
  }
}

///|
fn apply_ui_touch_frame(
  active_touch : @inputs.TouchPoint?,
  changes : Array[@inputs.TouchEvent],
) -> Unit {
  let active : Map[@inputs.TouchId, @inputs.TouchPoint] = Map([])
  match active_touch {
    Some(touch) => active.set(touch.id, touch)
    None => ()
  }
  @inputs.apply_input_snapshot({
    ..@inputs.empty_input_snapshot(),
    touches: active,
    touch_changes: changes,
  })
}

///|
test "ui relative cursor positions use centered normalized coordinates" {
  reset_interaction_test_state()
  let entity = @entity.Entity()
  let rect : @math.Rect = {
    position: @math.Vec2(100.0, 50.0),
    size: @math.Vec2(40.0, 20.0),
  }
  nodes().set(entity, Node())
  global_ui_nodes().set(entity, interaction_test_global_node(rect))
  relative_cursor_positions().set(entity, RelativeCursorPosition())
  @inputs.mouse.pos = @math.Vec2(130.0, 60.0)

  ui_interaction_system(0.0)

  let relative = relative_cursor_positions().get(entity).unwrap()
  inspect(relative.mouse_over(), content="true")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized[X] == 0.25, content="true")
  inspect(normalized[Y] == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}

///|
test "ui touch tap clicks interactive button without sticky hover" {
  with_ui_interaction_test_world(fn() raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node({
      position: @math.Vec2(100.0, 50.0),
      size: @math.Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(1)
    let press = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = @event.EventReader()
    let down_reader : @event.EventReader[UiPointerDownEvent] = @event.EventReader()
    let up_reader : @event.EventReader[UiPointerUpEvent] = @event.EventReader()
    let enter_reader : @event.EventReader[UiPointerEnterEvent] = @event.EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(0.0)
    inspect(
      interactions().get(entity).unwrap_or(None) == Pressed,
      content="true",
    )

    apply_ui_touch_frame(None, [touch_event(id, Ended, press)])
    ui_interaction_system(0.0)

    inspect(pointer_down_event_bus.read(down_reader).length(), content="1")
    inspect(pointer_up_event_bus.read(up_reader).length(), content="1")
    inspect(click_event_bus.read(click_reader).length(), content="1")
    inspect(pointer_enter_event_bus.read(enter_reader).length(), content="0")
    inspect(interactions().get(entity).unwrap_or(None) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui cancelled touch clears pressed state without click" {
  with_ui_interaction_test_world(fn() raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node({
      position: @math.Vec2(100.0, 50.0),
      size: @math.Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(2)
    let press = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = @event.EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(0.0)
    apply_ui_touch_frame(None, [touch_event(id, Cancelled, press)])
    ui_interaction_system(0.0)

    inspect(click_event_bus.read(click_reader).length(), content="0")
    inspect(interactions().get(entity).unwrap_or(None) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui touch release outside pressed target does not click" {
  with_ui_interaction_test_world(fn() raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node({
      position: @math.Vec2(100.0, 50.0),
      size: @math.Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(3)
    let press = @math.Vec2(120.0, 70.0)
    let outside = @math.Vec2(20.0, 20.0)
    let click_reader : @event.EventReader[UiClickEvent] = @event.EventReader()
    let up_reader : @event.EventReader[UiPointerUpEvent] = @event.EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(0.0)
    apply_ui_touch_frame(None, [
      touch_event(id, Ended, outside, previous_position=press),
    ])
    ui_interaction_system(0.0)

    inspect(pointer_up_event_bus.read(up_reader).length(), content="1")
    inspect(click_event_bus.read(click_reader).length(), content="0")
    inspect(interactions().get(entity).unwrap_or(None) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui touch drag scrolls non-button scrollable panels" {
  with_ui_interaction_test_world(fn() raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(
      { position: @math.Vec2(0.0, 0.0), size: @math.Vec2(100.0, 100.0) },
      interactive=false,
      overflow_y=Scroll,
    )
    let id = @inputs.TouchId(4)
    let previous = @math.Vec2(20.0, 50.0)
    let current = @math.Vec2(20.0, 30.0)

    apply_ui_touch_frame(
      Some(touch_point(id, current, previous_position=previous)),
      [touch_event(id, Moved, current, previous_position=previous)],
    )
    ui_interaction_system(0.0)

    let scroll = scroll_positions().get(entity).unwrap()
    inspect(scroll.y, content="20")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui relative cursor positions keep normalized values outside calculated clip" {
  reset_interaction_test_state()
  let entity = @entity.Entity()
  let rect : @math.Rect = {
    position: @math.Vec2(100.0, 50.0),
    size: @math.Vec2(40.0, 20.0),
  }
  nodes().set(entity, Node())
  global_ui_nodes().set(entity, interaction_test_global_node(rect))
  calculated_clips().set(
    entity,
    CalculatedClip({
      position: @math.Vec2(100.0, 50.0),
      size: @math.Vec2(10.0, 20.0),
    }),
  )
  relative_cursor_positions().set(entity, RelativeCursorPosition())
  @inputs.mouse.pos = @math.Vec2(130.0, 60.0)

  ui_interaction_system(0.0)

  let relative = relative_cursor_positions().get(entity).unwrap()
  inspect(relative.mouse_over(), content="false")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized[X] == 0.25, content="true")
  inspect(normalized[Y] == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}
