///|
fn with_ui_interaction_test_world(
  action : (@ecs.World) -> Unit raise,
) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action(world)
  @ecs.set_current_world(previous)
}

///|
fn cleanup_interaction_test_entity(entity : @ecs.Entity) -> Unit {
  ignore(entity.delete())
}

///|
fn reset_interaction_test_state() -> Unit {
  let runtime = ui_interaction_runtime()
  runtime.hovered_entity = None
  runtime.pressed_entity = None
  runtime.pressed_pointer = None
  runtime.focused_entity = None
  runtime.pointer_captures.clear()
  runtime.consumed_pointers.clear()
  @inputs.apply_input_snapshot(InputSnapshot())
  @inputs.just_pressed_mouse.left_button = false
  @inputs.just_pressed_mouse.right_button = false
  @inputs.just_pressed_mouse.middle_button = false
  @inputs.just_release_mouse.left_button = false
  @inputs.just_release_mouse.right_button = false
  @inputs.just_release_mouse.middle_button = false
  @inputs.clear_touch_state()
  @inputs.advanced_mouse_system(0.0)
  @inputs.advanced_pointer_system(0.0)
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
  world~ : @ecs.World,
  rect : @math.Rect,
  interactive~ : Bool = true,
  parent? : @ecs.Entity,
  overflow_y~ : Overflow = Visible,
  zindex~ : Int32 = 0,
) -> @ecs.Entity {
  let node = Node(overflow_y~)
  let entity = if interactive {
    world.spawn((node, Button(), ZIndex(zindex)), parent?)
  } else {
    world.spawn((node, ZIndex(zindex)), parent?)
  }
  set_test_ui_geometry(entity, interaction_test_global_node(rect))
  rebuild_ui_stack(world~)
  entity
}

///|
fn touch_point(
  id : @inputs.TouchId,
  position : @math.Vec2,
  previous_position~ : @math.Vec2 = position,
  source~ : @inputs.PointerSource = PointerTouch,
) -> @inputs.TouchPoint {
  {
    id,
    source,
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
  previous_position~ : @math.Vec2 = position,
  source~ : @inputs.PointerSource = PointerTouch,
) -> @inputs.TouchEvent {
  {
    id,
    source,
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
    ..InputSnapshot(),
    touches: active,
    touch_changes: changes,
  })
  @inputs.advanced_mouse_system(0.0)
  @inputs.advanced_pointer_system(0.0)
}

///|
fn apply_ui_mouse_frame(position : @math.Vec2, down : Bool) -> Unit {
  @inputs.apply_input_snapshot({
    ..InputSnapshot(),
    mouse: {
      pos: position,
      left_button: down,
      right_button: false,
      middle_button: false,
    },
  })
  @inputs.advanced_mouse_system(0.0)
  @inputs.advanced_pointer_system(0.0)
}

///|
test "ui relative cursor positions use centered normalized coordinates" {
  let world = @ecs.require_current_world()
  reset_interaction_test_state()
  let entity = @ecs.require_current_world().spawn(
    (Node(), RelativeCursorPosition()),
  )
  let rect : @math.Rect = {
    position: Vec2(100.0, 50.0),
    size: Vec2(40.0, 20.0),
  }
  set_test_ui_geometry(entity, interaction_test_global_node(rect))
  @inputs.mouse.pos = Vec2(130.0, 60.0)

  ui_interaction_system(world~, 0.0)

  let relative = (
      world.query() : @ecs.Query[@ecs.Single[RelativeCursorPosition]])
    .get(entity)
    .map(value => value.0)
    .unwrap()
  inspect(relative.mouse_over(), content="true")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized.x == 0.25, content="true")
  inspect(normalized.y == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}

///|
test "ui pointer picks the pause menu dimmer above the HUD" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let rect : @math.Rect = {
      position: Vec2(0.0, 0.0),
      size: Vec2(100.0, 100.0),
    }
    let root = spawn_interaction_test_node(world~, rect, interactive=false)
    let hud = spawn_interaction_test_node(
      world~,
      rect,
      interactive=false,
      parent=root,
    )
    let minimap = spawn_interaction_test_node(
      world~,
      rect,
      parent=hud,
      zindex=10,
    )
    let pause_menu = spawn_interaction_test_node(
      world~,
      rect,
      interactive=false,
      parent=root,
      zindex=1,
    )
    let dimmer = spawn_interaction_test_node(world~, rect, parent=pause_menu)
    let entities = [root, hud, minimap, pause_menu, dimmer]
    for index, entity in entities {
      tree_orders().set(entity, index + 1)
    }
    rebuild_ui_stack(world~)

    assert_eq(resolve_pointer_target(world~, Vec2(20.0, 20.0)), Some(dimmer))

    for entity in entities.rev() {
      cleanup_interaction_test_entity(entity)
    }
    reset_interaction_test_state()
  })
}

///|
test "ui focus candidates only include nodes in the layout stack" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let root = world.spawn1(Node(width=Val::px(100.0), height=Val::px(100.0)))
    let visible = world.spawn(
      (Node(width=Val::px(50.0), height=Val::px(50.0)), Focusable()),
      parent=root,
    )
    let hidden = world.spawn((Node(display=None), Focusable()), parent=root)

    ui_layout_system(world~, 0.0)
    let candidates = focusable_entities(world~)

    assert_eq(candidates.length(), 1)
    assert_eq(candidates[0], visible)

    for entity in [hidden, visible, root] {
      cleanup_interaction_test_entity(entity)
    }
    reset_interaction_test_state()
  })
}

///|
test "ui mouse click uses the unified pointer event stream" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let position = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = EventReader()

    apply_ui_mouse_frame(position, true)
    ui_interaction_system(world~, 0.0)
    inspect(interaction(entity) == Pressed, content="true")

    apply_ui_mouse_frame(position, false)
    ui_interaction_system(world~, 0.0)
    inspect(click_event_bus.read(click_reader).length(), content="1")
    inspect(interaction(entity) == Hovered, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui pen tap follows contact semantics without hover" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(20)
    let position = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = EventReader()
    let enter_reader : @event.EventReader[UiPointerEnterEvent] = EventReader()

    apply_ui_touch_frame(Some(touch_point(id, position, source=PointerPen)), [
      touch_event(id, Started, position, source=PointerPen),
    ])
    ui_interaction_system(world~, 0.0)
    apply_ui_touch_frame(None, [
      touch_event(id, Ended, position, source=PointerPen),
    ])
    ui_interaction_system(world~, 0.0)

    inspect(click_event_bus.read(click_reader).length(), content="1")
    inspect(pointer_enter_event_bus.read(enter_reader).length(), content="0")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui touch tap clicks interactive button without sticky hover" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(1)
    let press = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = EventReader()
    let down_reader : @event.EventReader[UiPointerDownEvent] = EventReader()
    let up_reader : @event.EventReader[UiPointerUpEvent] = EventReader()
    let enter_reader : @event.EventReader[UiPointerEnterEvent] = EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(world~, 0.0)
    inspect(interaction(entity) == Pressed, content="true")

    apply_ui_touch_frame(None, [touch_event(id, Ended, press)])
    ui_interaction_system(world~, 0.0)

    inspect(pointer_down_event_bus.read(down_reader).length(), content="1")
    inspect(pointer_up_event_bus.read(up_reader).length(), content="1")
    inspect(click_event_bus.read(click_reader).length(), content="1")
    inspect(pointer_enter_event_bus.read(enter_reader).length(), content="0")
    inspect(interaction(entity) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui cancelled touch clears pressed state without click" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(2)
    let press = @math.Vec2(120.0, 70.0)
    let click_reader : @event.EventReader[UiClickEvent] = EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(world~, 0.0)
    apply_ui_touch_frame(None, [touch_event(id, Cancelled, press)])
    ui_interaction_system(world~, 0.0)

    inspect(click_event_bus.read(click_reader).length(), content="0")
    inspect(interaction(entity) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui touch release outside pressed target does not click" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(3)
    let press = @math.Vec2(120.0, 70.0)
    let outside = @math.Vec2(20.0, 20.0)
    let click_reader : @event.EventReader[UiClickEvent] = EventReader()
    let up_reader : @event.EventReader[UiPointerUpEvent] = EventReader()

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_interaction_system(world~, 0.0)
    apply_ui_touch_frame(None, [
      touch_event(id, Ended, outside, previous_position=press),
    ])
    ui_interaction_system(world~, 0.0)

    inspect(pointer_up_event_bus.read(up_reader).length(), content="1")
    inspect(click_event_bus.read(click_reader).length(), content="0")
    inspect(interaction(entity) == None, content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui touch drag scrolls non-button scrollable panels" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = @ecs.require_current_world().spawn1(
      Node::absolute(Vec2(0.0, 0.0), size=Vec2(100.0, 100.0), overflow_y=Scroll),
    )
    let child = @ecs.require_current_world().spawn1(
      Node(width=Val::px(100.0), height=Val::px(200.0), flex_shrink=0.0),
      parent=entity,
    )
    ui_layout_system(world~, 0.0)
    let id = @inputs.TouchId(4)
    let previous = @math.Vec2(20.0, 50.0)
    let current = @math.Vec2(20.0, 30.0)

    apply_ui_touch_frame(
      Some(touch_point(id, current, previous_position=previous)),
      [touch_event(id, Moved, current, previous_position=previous)],
    )
    ui_interaction_system(world~, 0.0)

    let scroll = scroll_position(entity).unwrap()
    inspect(scroll.y, content="20")

    cleanup_interaction_test_entity(child)
    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui scroll deltas stop at the computed content bounds" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = @ecs.require_current_world().spawn1(
      Node::absolute(Vec2(0.0, 0.0), size=Vec2(100.0, 100.0), overflow_y=Scroll),
    )
    let child = @ecs.require_current_world().spawn1(
      Node(width=Val::px(100.0), height=Val::px(220.0), flex_shrink=0.0),
      parent=entity,
    )
    ui_layout_system(world~, 0.0)

    apply_scroll_delta(world~, entity, Vec2(0.0, 1000.0))
    debug_inspect(
      [
        computed_ui_node(entity).unwrap().max_scroll_position.y,
        scroll_position(entity).unwrap().y,
      ],
      content="[120, 120]",
    )

    apply_scroll_delta(world~, entity, Vec2(0.0, -1000.0))
    inspect(scroll_position(entity).unwrap().y, content="0")

    cleanup_interaction_test_entity(child)
    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui input capture consumes touch started over button before interaction" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(5)
    let press = @math.Vec2(120.0, 70.0)

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_input_capture_system(world~, 0.0)

    inspect(is_touch_consumed(id), content="true")
    inspect(active_unconsumed_touches().length(), content="0")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui input capture preserves pen identity" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(21)
    let pointer : @inputs.PointerId = { source: PointerPen, value: id.value(), }
    let press = @math.Vec2(120.0, 70.0)

    apply_ui_touch_frame(Some(touch_point(id, press, source=PointerPen)), [
      touch_event(id, Started, press, source=PointerPen),
    ])
    ui_input_capture_system(world~, 0.0)

    inspect(is_pointer_consumed(pointer), content="true")
    inspect(is_touch_consumed(id), content="true")
    inspect(unconsumed_pointer_changes_this_frame().length(), content="0")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui input capture holds touch until release" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(6)
    let press = @math.Vec2(120.0, 70.0)
    let outside = @math.Vec2(20.0, 20.0)

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_input_capture_system(world~, 0.0)
    apply_ui_touch_frame(
      Some(touch_point(id, outside, previous_position=press)),
      [touch_event(id, Moved, outside, previous_position=press)],
    )
    ui_input_capture_system(world~, 0.0)
    inspect(is_touch_consumed(id), content="true")
    inspect(active_unconsumed_touches().length(), content="0")

    apply_ui_touch_frame(None, [
      touch_event(id, Ended, outside, previous_position=outside),
    ])
    ui_input_capture_system(world~, 0.0)
    inspect(is_touch_consumed(id), content="true")
    apply_ui_touch_frame(None, [])
    ui_input_capture_system(world~, 0.0)
    inspect(is_touch_consumed(id), content="false")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui input capture consumes non-button scroll panels" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(
      world~,
      { position: Vec2(0.0, 0.0), size: Vec2(100.0, 100.0), },
      interactive=false,
      overflow_y=Scroll,
    )
    let id = @inputs.TouchId(7)
    let press = @math.Vec2(20.0, 40.0)

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_input_capture_system(world~, 0.0)

    inspect(is_touch_consumed(id), content="true")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui input capture leaves gameplay touches unconsumed" {
  with_ui_interaction_test_world(fn(world) raise {
    reset_interaction_test_state()
    let entity = spawn_interaction_test_node(world~, {
      position: Vec2(100.0, 50.0),
      size: Vec2(80.0, 40.0),
    })
    let id = @inputs.TouchId(8)
    let press = @math.Vec2(20.0, 20.0)

    apply_ui_touch_frame(Some(touch_point(id, press)), [
      touch_event(id, Started, press),
    ])
    ui_input_capture_system(world~, 0.0)

    inspect(is_touch_consumed(id), content="false")
    inspect(active_unconsumed_touches().length(), content="1")

    cleanup_interaction_test_entity(entity)
    reset_interaction_test_state()
  })
}

///|
test "ui relative cursor positions keep normalized values outside calculated clip" {
  let world = @ecs.require_current_world()
  reset_interaction_test_state()
  let entity = @ecs.require_current_world().spawn(
    (Node(), RelativeCursorPosition()),
  )
  let rect : @math.Rect = {
    position: Vec2(100.0, 50.0),
    size: Vec2(40.0, 20.0),
  }
  set_test_ui_geometry(entity, interaction_test_global_node(rect))
  calculated_clips().set(
    entity,
    CalculatedClip({ position: Vec2(100.0, 50.0), size: Vec2(10.0, 20.0), }),
  )
  @inputs.mouse.pos = Vec2(130.0, 60.0)

  ui_interaction_system(world~, 0.0)

  let relative = (
      world.query() : @ecs.Query[@ecs.Single[RelativeCursorPosition]])
    .get(entity)
    .map(value => value.0)
    .unwrap()
  inspect(relative.mouse_over(), content="false")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized.x == 0.25, content="true")
  inspect(normalized.y == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}
