///|
/// Event outputs for the input systems, bound to the executing World.
struct InputEvents {
  keys : @event.EventWriter[KeyInputEvent]
  mouse_buttons : @event.EventWriter[MouseButtonEvent]
  mouse_motion : @event.EventWriter[MouseMotionEvent]
  mouse_wheel : @event.EventWriter[MouseWheelEvent]
  touches : @event.EventWriter[TouchEvent]
  gestures : @event.EventWriter[TouchGestureEvent]
  pointers : @event.EventWriter[PointerEvent]
  gamepad_connections : @event.EventWriter[GamepadConnectionEvent]
  gamepad_buttons : @event.EventWriter[GamepadButtonEvent]
  gamepad_axes : @event.EventWriter[GamepadAxisEvent]
}

///|
pub fn InputEvents::InputEvents(world : @ecs.World) -> InputEvents {
  {
    keys: key_input_event_bus.writer(world~),
    mouse_buttons: mouse_button_event_bus.writer(world~),
    mouse_motion: mouse_motion_event_bus.writer(world~),
    mouse_wheel: mouse_wheel_event_bus.writer(world~),
    touches: touch_event_bus.writer(world~),
    gestures: touch_gesture_event_bus.writer(world~),
    pointers: pointer_event_bus.writer(world~),
    gamepad_connections: gamepad_connection_event_bus.writer(world~),
    gamepad_buttons: gamepad_button_event_bus.writer(world~),
    gamepad_axes: gamepad_axis_event_bus.writer(world~),
  }
}

///|
pub impl @ecs.SystemParam for InputEvents with fn prepare(world) {
  let events = InputEvents(world)
  _ => events
}

///|
pub extend InputEvents with @ecs.SystemParam::{prepare}
