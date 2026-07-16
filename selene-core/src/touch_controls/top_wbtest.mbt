///|
fn with_touch_controls_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn touch_point(
  id : @inputs.TouchId,
  position : @math.Vec2,
  previous_position? : @math.Vec2 = position,
) -> @inputs.TouchPoint {
  {
    id,
    source: PointerTouch,
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
    source: PointerTouch,
    phase,
    position,
    previous_position,
    delta: position - previous_position,
    primary: true,
  }
}

///|
fn apply_touch_frame(
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
  @ui.ui_input_capture_system(0.0)
}

///|
test "floating stick writes virtual axes and consumes its touch" {
  with_touch_controls_test_world(fn() raise {
    clear_controls()
    @inputs.clear_virtual_controls()
    @system.configure_display(400.0, 300.0, 1.0)
    let axis_x = @inputs.VirtualAxis("move-x")
    let axis_y = @inputs.VirtualAxis("move-y")
    add_virtual_stick_control(
      VirtualStick(
        "move",
        axis_x,
        axis_y,
        placement=Anchor(0.25, 0.75, @math.Vec2::zero()),
        radius=50.0,
        dead_zone=5.0,
        mode=Floating,
      ),
    )
    let id = @inputs.TouchId(7)
    let start = @math.Vec2(100.0, 225.0)
    apply_touch_frame(Some(touch_point(id, start)), [
      touch_event(id, Started, start),
    ])
    touch_controls_system(0.0)
    inspect(@ui.is_touch_consumed(id), content="true")
    inspect(@inputs.virtual_axis_value(axis_x), content="0")
    let moved = @math.Vec2(150.0, 225.0)
    apply_touch_frame(Some(touch_point(id, moved, previous_position=start)), [
      touch_event(id, Moved, moved, previous_position=start),
    ])
    touch_controls_system(0.0)
    inspect(@inputs.virtual_axis_value(axis_x), content="1")
    inspect(@inputs.virtual_axis_value(axis_y), content="0")
    apply_touch_frame(None, [touch_event(id, Ended, moved)])
    touch_controls_system(0.0)
    inspect(@inputs.virtual_axis_value(axis_x), content="0")
    clear_controls()
    @inputs.clear_virtual_controls()
  })
}

///|
test "button control writes virtual button only for unconsumed touches" {
  with_touch_controls_test_world(fn() raise {
    clear_controls()
    @inputs.clear_virtual_controls()
    @system.configure_display(400.0, 300.0, 1.0)
    let button = @inputs.VirtualButton("jump")
    add_virtual_button_control(
      VirtualButtonControl(
        "jump",
        button,
        placement=Anchor(0.8, 0.8, @math.Vec2::zero()),
        radius=40.0,
      ),
    )
    let id = @inputs.TouchId(9)
    let start = @math.Vec2(320.0, 240.0)
    apply_touch_frame(Some(touch_point(id, start)), [
      touch_event(id, Started, start),
    ])
    touch_controls_system(0.0)
    inspect(@inputs.is_virtual_button_pressed(button), content="true")
    apply_touch_frame(None, [touch_event(id, Ended, start)])
    touch_controls_system(0.0)
    inspect(@inputs.is_virtual_button_pressed(button), content="false")
    clear_controls()
    @inputs.clear_virtual_controls()
  })
}
