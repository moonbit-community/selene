///|
pub(all) struct TouchId {
  value : Int
} derive(Eq, Hash, Debug)

///|
pub fn TouchId::TouchId(value : Int) -> TouchId {
  { value, }
}

///|
pub fn TouchId::value(self : TouchId) -> Int {
  self.value
}

///|
pub(all) enum TouchPhase {
  Started
  Moved
  Ended
  Cancelled
} derive(Eq, Debug)

///|
pub(all) struct TouchPoint {
  id : TouchId
  position : @math.Vec2
  previous_position : @math.Vec2
  delta : @math.Vec2
  primary : Bool
}

///|
pub(all) struct TouchEvent {
  id : TouchId
  phase : TouchPhase
  position : @math.Vec2
  previous_position : @math.Vec2
  delta : @math.Vec2
  primary : Bool
}

///|
pub(all) enum PointerSource {
  PointerMouse
  PointerTouch
  PointerPen
} derive(Eq, Hash, Debug)

///|
pub(all) enum PointerPhase {
  Down
  Move
  Up
  Cancel
} derive(Eq, Debug)

///|
pub(all) struct PointerId {
  source : PointerSource
  value : Int
} derive(Eq, Hash, Debug)

///|
pub(all) struct PointerEvent {
  id : PointerId
  source : PointerSource
  phase : PointerPhase
  position : @math.Vec2
  previous_position : @math.Vec2
  delta : @math.Vec2
  primary : Bool
}

///|
let touches : Map[TouchId, TouchPoint] = Map([])

///|
let touch_changes : Array[TouchEvent] = []

///|
pub let touch_event_bus : @event.Events[TouchEvent] = @event.Events()

///|
pub fn active_touches() -> Map[TouchId, TouchPoint] {
  touches
}

///|
pub fn touch_changes_this_frame() -> Array[TouchEvent] {
  touch_changes
}

///|
pub fn touch_point(id : TouchId) -> TouchPoint? {
  touches.get(id)
}

///|
pub fn is_touch_active(id : TouchId) -> Bool {
  touches.contains(id)
}

///|
pub fn primary_touch() -> TouchPoint? {
  for _, touch in touches {
    if touch.primary {
      return Some(touch)
    }
  }
  None
}

///|
pub fn first_touch_change(phase : TouchPhase) -> TouchEvent? {
  for event in touch_changes {
    if event.phase == phase {
      return Some(event)
    }
  }
  None
}

///|
pub fn replace_touch_state(
  active : Map[TouchId, TouchPoint],
  changes : Array[TouchEvent],
) -> Unit {
  touches.clear()
  for id, touch in active {
    touches.set(id, touch)
  }
  touch_changes.clear()
  for event in changes {
    touch_changes.push(event)
  }
}

///|
pub fn clear_touch_state() -> Unit {
  touches.clear()
  touch_changes.clear()
}

///|
fn touch_phase_to_pointer_phase(phase : TouchPhase) -> PointerPhase {
  match phase {
    Started => Down
    Moved => Move
    Ended => Up
    Cancelled => Cancel
  }
}

///|
pub fn pointer_event_from_touch(event : TouchEvent) -> PointerEvent {
  {
    id: { source: PointerTouch, value: event.id.value },
    source: PointerTouch,
    phase: touch_phase_to_pointer_phase(event.phase),
    position: event.position,
    previous_position: event.previous_position,
    delta: event.delta,
    primary: event.primary,
  }
}

///|
pub fn primary_pointer_position() -> @math.Vec2 {
  match primary_touch() {
    Some(touch) => touch.position
    None => mouse.pos
  }
}

///|
pub fn primary_pointer_down() -> Bool {
  match primary_touch() {
    Some(_) => true
    None => mouse.left_button
  }
}

///|
pub fn advanced_touch_system(_delta : Double) -> Unit {
  for event in touch_changes {
    touch_event_bus.send(event)
  }
}
