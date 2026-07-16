///|
fn test_touch_point(
  id : TouchId,
  position : @math.Vec2,
  primary : Bool,
) -> TouchPoint {
  {
    id,
    source: PointerTouch,
    position,
    previous_position: position,
    delta: @math.Vec2::zero(),
    primary,
  }
}

///|
fn test_touch_event(
  id : TouchId,
  phase : TouchPhase,
  position : @math.Vec2,
  primary : Bool,
) -> TouchEvent {
  {
    id,
    source: PointerTouch,
    phase,
    position,
    previous_position: position,
    delta: @math.Vec2::zero(),
    primary,
  }
}

///|
fn test_touch_event_from_to(
  id : TouchId,
  phase : TouchPhase,
  previous_position : @math.Vec2,
  position : @math.Vec2,
  primary : Bool,
) -> TouchEvent {
  {
    id,
    source: PointerTouch,
    phase,
    position,
    previous_position,
    delta: position - previous_position,
    primary,
  }
}

///|
fn active_touch_map(points : Array[TouchPoint]) -> Map[TouchId, TouchPoint] {
  let active : Map[TouchId, TouchPoint] = Map([])
  for point in points {
    active.set(point.id, point)
  }
  active
}

///|
fn apply_touch_frame(
  points : Array[TouchPoint],
  changes : Array[TouchEvent],
  delta : Double,
) -> Unit {
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touches: active_touch_map(points),
    touch_changes: changes,
  })
  advanced_touch_system(delta)
}

///|
fn gesture_kind_name_at(index : Int) -> String {
  match touch_gesture_changes_this_frame().get(index) {
    Some(event) =>
      match event.kind {
        Tap => "Tap"
        LongPress => "LongPress"
        PanStart => "PanStart"
        PanMove => "PanMove"
        PanEnd => "PanEnd"
        PanCancel => "PanCancel"
        PinchStart => "PinchStart"
        PinchMove => "PinchMove"
        PinchEnd => "PinchEnd"
        PinchCancel => "PinchCancel"
      }
    None => "None"
  }
}

///|
test "input snapshot carries active touches and changes" {
  apply_input_snapshot(empty_input_snapshot())
  let id = TouchId(7)
  let active : Map[TouchId, TouchPoint] = Map([])
  active.set(id, test_touch_point(id, Vec2(12.0, 24.0), true))
  let changes : Array[TouchEvent] = [
    test_touch_event(id, Started, Vec2(12.0, 24.0), true),
  ]
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touches: active,
    touch_changes: changes,
  })
  inspect(is_touch_active(id), content="true")
  inspect(touch_changes_this_frame().length(), content="1")
  let primary_id = match primary_touch() {
    Some(touch) => touch.id.value
    None => -1
  }
  inspect(primary_id, content="7")
  apply_input_snapshot(empty_input_snapshot())
}

///|
test "primary touch mirrors mouse left button for compatibility" {
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
  let id = TouchId(9)
  let active : Map[TouchId, TouchPoint] = Map([])
  active.set(id, test_touch_point(id, Vec2(30.0, 40.0), true))
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touches: active,
    touch_changes: [test_touch_event(id, Started, Vec2(30.0, 40.0), true)],
  })
  advanced_mouse_system(0.0)
  inspect(mouse.left_button, content="true")
  inspect(is_mouse_just_pressed(Left), content="true")
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touch_changes: [test_touch_event(id, Ended, Vec2(30.0, 40.0), true)],
  })
  advanced_mouse_system(0.0)
  inspect(mouse.left_button, content="false")
  inspect(is_mouse_just_released(Left), content="true")
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
}

///|
test "pen contacts preserve their pointer source without mirrored mouse events" {
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
  clear_touch_state()
  let id = TouchId(12)
  let position = @math.Vec2(15.0, 25.0)
  let point : TouchPoint = {
    id,
    source: PointerPen,
    position,
    previous_position: position,
    delta: @math.Vec2::zero(),
    primary: true,
  }
  let event : TouchEvent = {
    id,
    source: PointerPen,
    phase: Started,
    position,
    previous_position: position,
    delta: @math.Vec2::zero(),
    primary: true,
  }
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touches: active_touch_map([point]),
    touch_changes: [event],
  })
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
  inspect(pointer_changes_this_frame().length(), content="1")
  inspect(pointer_changes_this_frame()[0].source == PointerPen, content="true")
  inspect(
    pointer_changes_this_frame()[0].id.source == PointerPen,
    content="true",
  )
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
  clear_touch_state()
}

///|
test "mouse produces unified pointer down move and up events" {
  apply_input_snapshot(empty_input_snapshot())
  last_mouse.pos = @math.Vec2::zero()
  last_mouse.left_button = false
  mouse.pos = Vec2(10.0, 20.0)
  mouse.left_button = true
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
  inspect(pointer_changes_this_frame().length(), content="2")
  inspect(pointer_changes_this_frame()[0].phase == Down, content="true")
  inspect(
    pointer_changes_this_frame()[0].source == PointerMouse,
    content="true",
  )
  inspect(pointer_changes_this_frame()[1].phase == Move, content="true")

  mouse.pos = Vec2(14.0, 23.0)
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
  inspect(pointer_changes_this_frame().length(), content="1")
  inspect(pointer_changes_this_frame()[0].phase == Move, content="true")
  inspect(pointer_changes_this_frame()[0].delta[X], content="4")
  inspect(pointer_changes_this_frame()[0].delta[Y], content="3")

  mouse.left_button = false
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
  inspect(pointer_changes_this_frame().length(), content="1")
  inspect(pointer_changes_this_frame()[0].phase == Up, content="true")
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
  advanced_pointer_system(0.0)
}

///|
test "touch gestures recognize tap" {
  clear_touch_state()
  let id = TouchId(1)
  let position = @math.Vec2(10.0, 10.0)
  apply_touch_frame(
    [test_touch_point(id, position, true)],
    [test_touch_event(id, Started, position, true)],
    0.0,
  )
  inspect(touch_gesture_changes_this_frame().length(), content="0")
  apply_touch_frame([], [test_touch_event(id, Ended, position, true)], 0.1)
  inspect(touch_gesture_changes_this_frame().length(), content="1")
  inspect(gesture_kind_name_at(0), content="Tap")
  clear_touch_state()
}

///|
test "touch gestures recognize long press" {
  clear_touch_state()
  let id = TouchId(2)
  let position = @math.Vec2(5.0, 5.0)
  apply_touch_frame(
    [test_touch_point(id, position, true)],
    [test_touch_event(id, Started, position, true)],
    0.0,
  )
  apply_touch_frame([test_touch_point(id, position, true)], [], 0.51)
  inspect(touch_gesture_changes_this_frame().length(), content="1")
  inspect(gesture_kind_name_at(0), content="LongPress")
  clear_touch_state()
}

///|
test "touch gestures recognize pan lifecycle" {
  clear_touch_state()
  let id = TouchId(3)
  let start = @math.Vec2(0.0, 0.0)
  let moved = @math.Vec2(12.0, 0.0)
  let moved_again = @math.Vec2(18.0, 0.0)
  apply_touch_frame(
    [test_touch_point(id, start, true)],
    [test_touch_event(id, Started, start, true)],
    0.0,
  )
  apply_touch_frame(
    [test_touch_point(id, moved, true)],
    [test_touch_event_from_to(id, Moved, start, moved, true)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PanStart")
  apply_touch_frame(
    [test_touch_point(id, moved_again, true)],
    [test_touch_event_from_to(id, Moved, moved, moved_again, true)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PanMove")
  apply_touch_frame(
    [],
    [test_touch_event_from_to(id, Ended, moved_again, moved_again, true)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PanEnd")
  clear_touch_state()
}

///|
test "touch gestures recognize pinch lifecycle" {
  clear_touch_state()
  let a = TouchId(10)
  let b = TouchId(11)
  let a_pos = @math.Vec2(0.0, 0.0)
  let b_pos = @math.Vec2(10.0, 0.0)
  let b_far = @math.Vec2(20.0, 0.0)
  let b_farther = @math.Vec2(25.0, 0.0)
  apply_touch_frame(
    [test_touch_point(a, a_pos, true), test_touch_point(b, b_pos, false)],
    [
      test_touch_event(a, Started, a_pos, true),
      test_touch_event(b, Started, b_pos, false),
    ],
    0.0,
  )
  apply_touch_frame(
    [test_touch_point(a, a_pos, true), test_touch_point(b, b_far, false)],
    [test_touch_event_from_to(b, Moved, b_pos, b_far, false)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PinchStart")
  apply_touch_frame(
    [test_touch_point(a, a_pos, true), test_touch_point(b, b_farther, false)],
    [test_touch_event_from_to(b, Moved, b_far, b_farther, false)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PinchMove")
  apply_touch_frame(
    [test_touch_point(a, a_pos, true)],
    [test_touch_event_from_to(b, Ended, b_farther, b_farther, false)],
    0.016,
  )
  inspect(gesture_kind_name_at(0), content="PinchEnd")
  clear_touch_state()
}
