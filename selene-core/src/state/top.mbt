///|
let transition_callbacks : Array[() -> Unit] = []

///|
let frame_serial : Ref[UInt] = Ref::new(0)

///|
pub(all) struct State[T] {
  current : Ref[T]
  next : Ref[T?]
  previous : Ref[T?]
  changed_serial : Ref[UInt]
}

///|
pub(all) struct NextState[T] {
  state : State[T]
}

///|
pub fn[T] State::new(initial : T) -> State[T] {
  let state : State[T] = {
    current: Ref::new(initial),
    next: Ref::new(None),
    previous: Ref::new(None),
    changed_serial: Ref::new(0),
  }
  transition_callbacks.push(fn() {
    match state.next.val {
      Some(next) => {
        state.previous.val = Some(state.current.val)
        state.current.val = next
        state.next.val = None
        state.changed_serial.val = frame_serial.val
      }
      None => ()
    }
  })
  state
}

///|
pub fn[T] State::get(self : State[T]) -> T {
  self.current.val
}

///|
pub fn[T] State::next(self : State[T]) -> NextState[T] {
  { state: self }
}

///|
pub fn[T] set_next_state(next_state : NextState[T], next : T) -> Unit {
  next_state.state.next.val = Some(next)
}

///|
pub fn[T] NextState::set(self : NextState[T], next : T) -> Unit {
  self.state.next.val = Some(next)
}

///|
pub fn[T] in_state(state : State[T], predicate : (T) -> Bool) -> () -> Bool {
  fn() { predicate(state.current.val) }
}

///|
pub fn[T : Eq] in_state_eq(state : State[T], value : T) -> () -> Bool {
  in_state(state, fn(current) { current == value })
}

///|
pub fn[T] on_enter(state : State[T], predicate : (T) -> Bool) -> () -> Bool {
  fn() {
    state.changed_serial.val == frame_serial.val && predicate(state.current.val)
  }
}

///|
pub fn[T : Eq] on_enter_eq(state : State[T], value : T) -> () -> Bool {
  on_enter(state, fn(current) { current == value })
}

///|
pub fn[T] on_exit(state : State[T], predicate : (T) -> Bool) -> () -> Bool {
  fn() {
    if state.changed_serial.val != frame_serial.val {
      return false
    }
    match state.previous.val {
      Some(previous) => predicate(previous)
      None => false
    }
  }
}

///|
pub fn[T : Eq] on_exit_eq(state : State[T], value : T) -> () -> Bool {
  on_exit(state, fn(previous) { previous == value })
}

///|
pub fn[T] transitioned_this_frame(state : State[T]) -> Bool {
  state.changed_serial.val == frame_serial.val
}

///|
pub fn state_transition_system(_delta : Double) -> Unit {
  frame_serial.val += 1
  for callback in transition_callbacks {
    callback()
  }
}
