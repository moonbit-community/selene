///|
priv struct StateWorldRuntime {
  mut frame_serial : UInt
  transition_callbacks : Array[() -> Unit]
}

///|
let state_world_runtimes : Map[UInt, StateWorldRuntime] = Map::new()

///|
fn state_runtime(world_id : UInt) -> StateWorldRuntime {
  state_world_runtimes.get_or_init(world_id, () => {
    frame_serial: 0U,
    transition_callbacks: [],
  })
}

///|
fn current_state_runtime() -> StateWorldRuntime {
  let world = @ecs.require_current_world()
  state_runtime(world.id())
}

///|
pub(all) struct State[T] {
  world_id : UInt
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
  let world = @ecs.require_current_world()
  let runtime = state_runtime(world.id())
  let state : State[T] = {
    world_id: world.id(),
    current: Ref::new(initial),
    next: Ref::new(None),
    previous: Ref::new(None),
    changed_serial: Ref::new(0),
  }
  runtime.transition_callbacks.push(fn() {
    match state.next.val {
      Some(next) => {
        state.previous.val = Some(state.current.val)
        state.current.val = next
        state.next.val = None
        state.changed_serial.val = runtime.frame_serial
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
    let runtime = state_runtime(state.world_id)
    state.changed_serial.val == runtime.frame_serial &&
    predicate(state.current.val)
  }
}

///|
pub fn[T : Eq] on_enter_eq(state : State[T], value : T) -> () -> Bool {
  on_enter(state, fn(current) { current == value })
}

///|
pub fn[T] on_exit(state : State[T], predicate : (T) -> Bool) -> () -> Bool {
  fn() {
    let runtime = state_runtime(state.world_id)
    if state.changed_serial.val != runtime.frame_serial {
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
  let runtime = state_runtime(state.world_id)
  state.changed_serial.val == runtime.frame_serial
}

///|
pub fn state_transition_system(_delta : Double) -> Unit {
  let runtime = current_state_runtime()
  runtime.frame_serial += 1U
  for callback in runtime.transition_callbacks {
    callback()
  }
}
