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
pub(all) enum TouchGestureKind {
  Tap
  LongPress
  PanStart
  PanMove
  PanEnd
  PanCancel
  PinchStart
  PinchMove
  PinchEnd
  PinchCancel
} derive(Eq, Debug)

///|
pub(all) struct TouchGestureEvent {
  kind : TouchGestureKind
  primary_id : TouchId?
  secondary_id : TouchId?
  position : @math.Vec2
  delta : @math.Vec2
  scale : Double
  distance : Double
  duration : Double
}

///|
priv struct GestureTouchState {
  id : TouchId
  start_position : @math.Vec2
  mut position : @math.Vec2
  mut duration : Double
  mut pan_active : Bool
  mut long_press_sent : Bool
  mut cancelled : Bool
}

///|
priv struct PinchState {
  first : TouchId
  second : TouchId
  mut previous_center : @math.Vec2
  mut previous_distance : Double
  mut active : Bool
}

///|
const TAP_MAX_DURATION : Double = 0.25

///|
const TAP_MAX_MOVEMENT : Double = 10.0

///|
const LONG_PRESS_DURATION : Double = 0.5

///|
const PAN_THRESHOLD : Double = 8.0

///|
const PINCH_THRESHOLD : Double = 4.0

///|
let touches : Map[TouchId, TouchPoint] = Map([])

///|
let touch_changes : Array[TouchEvent] = []

///|
let gesture_touches : Map[TouchId, GestureTouchState] = Map([])

///|
let touch_gesture_changes : Array[TouchGestureEvent] = []

///|
let pinch_state : Ref[PinchState?] = Ref(None)

///|
pub let touch_event_bus : @event.Events[TouchEvent] = @event.Events()

///|
pub let touch_gesture_event_bus : @event.Events[TouchGestureEvent] = @event.Events()

///|
pub fn active_touches() -> Map[TouchId, TouchPoint] {
  touches
}

///|
pub fn touch_changes_this_frame() -> Array[TouchEvent] {
  touch_changes
}

///|
pub fn touch_gesture_changes_this_frame() -> Array[TouchGestureEvent] {
  touch_gesture_changes
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
  gesture_touches.clear()
  touch_gesture_changes.clear()
  pinch_state.val = None
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
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn distance_between(a : @math.Vec2, b : @math.Vec2) -> Double {
  (a - b).distance()
}

///|
fn midpoint(a : @math.Vec2, b : @math.Vec2) -> @math.Vec2 {
  (a + b).scalar_mul(0.5)
}

///|
fn push_gesture(
  kind : TouchGestureKind,
  primary_id? : TouchId,
  secondary_id? : TouchId,
  position~ : @math.Vec2,
  delta? : @math.Vec2 = @math.Vec2::zero(),
  scale? : Double = 1.0,
  distance? : Double = 0.0,
  duration? : Double = 0.0,
) -> Unit {
  touch_gesture_changes.push({
    kind,
    primary_id,
    secondary_id,
    position,
    delta,
    scale,
    distance,
    duration,
  })
}

///|
fn make_gesture_touch_state(event : TouchEvent) -> GestureTouchState {
  {
    id: event.id,
    start_position: event.position,
    position: event.position,
    duration: 0.0,
    pan_active: false,
    long_press_sent: false,
    cancelled: false,
  }
}

///|
fn update_long_press(delta : Double) -> Unit {
  for _, state in gesture_touches {
    state.duration += delta
    let movement = distance_between(state.start_position, state.position)
    if !state.long_press_sent &&
      !state.pan_active &&
      !state.cancelled &&
      movement <= TAP_MAX_MOVEMENT &&
      state.duration >= LONG_PRESS_DURATION {
      state.long_press_sent = true
      push_gesture(
        LongPress,
        primary_id=state.id,
        position=state.position,
        duration=state.duration,
      )
    }
  }
}

///|
fn process_started_touch(event : TouchEvent) -> Unit {
  gesture_touches.set(event.id, make_gesture_touch_state(event))
}

///|
fn active_touch_count() -> Int {
  let mut count = 0
  for _, _ in touches {
    count += 1
  }
  count
}

///|
fn process_moved_touch(event : TouchEvent) -> Unit {
  guard gesture_touches.get(event.id) is Some(state) else { return }
  state.position = event.position
  if active_touch_count() > 1 {
    return
  }
  let movement = distance_between(state.start_position, state.position)
  if !state.pan_active && movement >= PAN_THRESHOLD {
    state.pan_active = true
    push_gesture(
      PanStart,
      primary_id=event.id,
      position=event.position,
      delta=event.delta,
      distance=movement,
      duration=state.duration,
    )
  } else if state.pan_active {
    push_gesture(
      PanMove,
      primary_id=event.id,
      position=event.position,
      delta=event.delta,
      distance=movement,
      duration=state.duration,
    )
  }
}

///|
fn process_ended_touch(event : TouchEvent) -> Unit {
  guard gesture_touches.get(event.id) is Some(state) else { return }
  state.position = event.position
  let movement = distance_between(state.start_position, state.position)
  if state.pan_active {
    push_gesture(
      PanEnd,
      primary_id=event.id,
      position=event.position,
      delta=event.delta,
      distance=movement,
      duration=state.duration,
    )
  } else if !state.long_press_sent &&
    state.duration <= TAP_MAX_DURATION &&
    movement <= TAP_MAX_MOVEMENT {
    push_gesture(
      Tap,
      primary_id=event.id,
      position=event.position,
      distance=movement,
      duration=state.duration,
    )
  }
  ignore(gesture_touches.remove(event.id))
}

///|
fn process_cancelled_touch(event : TouchEvent) -> Unit {
  guard gesture_touches.get(event.id) is Some(state) else { return }
  state.cancelled = true
  if state.pan_active {
    push_gesture(
      PanCancel,
      primary_id=event.id,
      position=event.position,
      delta=event.delta,
      duration=state.duration,
    )
  }
  ignore(gesture_touches.remove(event.id))
}

///|
fn process_touch_changes_for_gestures() -> Unit {
  for event in touch_changes {
    match event.phase {
      Started => process_started_touch(event)
      Moved => process_moved_touch(event)
      Ended => process_ended_touch(event)
      Cancelled => process_cancelled_touch(event)
    }
  }
}

///|
fn first_two_gesture_touches() -> (GestureTouchState, GestureTouchState)? {
  let active : Array[GestureTouchState] = []
  for id, state in gesture_touches {
    if touches.contains(id) && !state.cancelled {
      active.push(state)
    }
  }
  if active.length() < 2 {
    return None
  }
  active.sort_by(fn(lhs, rhs) { lhs.id.value.compare(rhs.id.value) })
  guard active.get(0) is Some(first) else { return None }
  guard active.get(1) is Some(second) else { return None }
  Some((first, second))
}

///|
fn same_pinch_pair(
  state : PinchState,
  first : TouchId,
  second : TouchId,
) -> Bool {
  (state.first == first && state.second == second) ||
  (state.first == second && state.second == first)
}

///|
fn end_current_pinch(cancelled~ : Bool) -> Unit {
  match pinch_state.val {
    Some(state) => {
      if state.active {
        push_gesture(
          if cancelled {
            PinchCancel
          } else {
            PinchEnd
          },
          primary_id=state.first,
          secondary_id=state.second,
          position=state.previous_center,
          distance=state.previous_distance,
        )
      }
      pinch_state.val = None
    }
    None => ()
  }
}

///|
fn update_pinch(cancelled : Bool) -> Unit {
  match first_two_gesture_touches() {
    Some((first, second)) => {
      let center = midpoint(first.position, second.position)
      let distance = distance_between(first.position, second.position)
      match pinch_state.val {
        Some(state) => {
          if !same_pinch_pair(state, first.id, second.id) {
            end_current_pinch(cancelled=false)
            pinch_state.val = Some({
              first: first.id,
              second: second.id,
              previous_center: center,
              previous_distance: distance,
              active: false,
            })
            return
          }
          let delta_distance = distance - state.previous_distance
          let center_delta = center - state.previous_center
          let scale = if state.previous_distance <= 0.000001 {
            1.0
          } else {
            distance / state.previous_distance
          }
          if !state.active && abs_double(delta_distance) >= PINCH_THRESHOLD {
            state.active = true
            push_gesture(
              PinchStart,
              primary_id=first.id,
              secondary_id=second.id,
              position=center,
              delta=center_delta,
              scale~,
              distance~,
            )
          } else if state.active &&
            (
              abs_double(delta_distance) > 0.000001 ||
              center_delta[X] != 0.0 ||
              center_delta[Y] != 0.0
            ) {
            push_gesture(
              PinchMove,
              primary_id=first.id,
              secondary_id=second.id,
              position=center,
              delta=center_delta,
              scale~,
              distance~,
            )
          }
          state.previous_center = center
          state.previous_distance = distance
        }
        None =>
          pinch_state.val = Some({
            first: first.id,
            second: second.id,
            previous_center: center,
            previous_distance: distance,
            active: false,
          })
      }
    }
    None => end_current_pinch(cancelled~)
  }
}

///|
pub fn advanced_touch_system(_delta : Double) -> Unit {
  touch_gesture_changes.clear()
  update_long_press(_delta)
  let mut cancelled = false
  for event in touch_changes {
    if event.phase == Cancelled {
      cancelled = true
    }
    touch_event_bus.send(event)
  }
  process_touch_changes_for_gestures()
  update_pinch(cancelled)
  for event in touch_gesture_changes {
    touch_gesture_event_bus.send(event)
  }
}
