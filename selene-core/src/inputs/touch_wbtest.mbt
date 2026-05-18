///|
fn test_touch_point(
  id : TouchId,
  position : @math.Vec2,
  primary : Bool,
) -> TouchPoint {
  {
    id,
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
    phase,
    position,
    previous_position: position,
    delta: @math.Vec2::zero(),
    primary,
  }
}

///|
test "input snapshot carries active touches and changes" {
  apply_input_snapshot(empty_input_snapshot())
  let id = TouchId(7)
  let active : Map[TouchId, TouchPoint] = Map([])
  active.set(id, test_touch_point(id, @math.Vec2(12.0, 24.0), true))
  let changes : Array[TouchEvent] = [
    test_touch_event(id, Started, @math.Vec2(12.0, 24.0), true),
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
  active.set(id, test_touch_point(id, @math.Vec2(30.0, 40.0), true))
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touches: active,
    touch_changes: [test_touch_event(id, Started, @math.Vec2(30.0, 40.0), true)],
  })
  advanced_mouse_system(0.0)
  inspect(mouse.left_button, content="true")
  inspect(is_mouse_just_pressed(Left), content="true")
  apply_input_snapshot({
    ..empty_input_snapshot(),
    touch_changes: [test_touch_event(id, Ended, @math.Vec2(30.0, 40.0), true)],
  })
  advanced_mouse_system(0.0)
  inspect(mouse.left_button, content="false")
  inspect(is_mouse_just_released(Left), content="true")
  apply_input_snapshot(empty_input_snapshot())
  advanced_mouse_system(0.0)
}
