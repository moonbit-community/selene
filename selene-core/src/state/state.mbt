///|
/// Supplies one state identity, shared by this type across Worlds.
pub(open) trait StateType: Eq {
  fn state_key() -> StateKey[Self]
  /// Requests a transition in the active World. Applied at its next transition point.
  fn set(Self) -> Unit = _
}

///|
impl StateType with fn set(self) {
  set_next(@ecs.require_current_world(), self)
}

///|
/// A declaration key. State values are stored in each World, not in this key.
struct StateKey[T] {
  storage : @ecs.ResourceKey[StateData[T]]
}

///|
pub fn[T] StateKey::StateKey() -> StateKey[T] {
  { storage: ResourceKey(), }
}

///|
priv struct StateData[T] {
  mut current : T
  mut pending : T?
  mut entered : Bool
  mut transition : (T?, T)?
}

///|
fn[T : StateType] state_data(world : @ecs.World) -> StateData[T] {
  let key : StateKey[T] = StateType::state_key()
  match key.storage.get_in(world) {
    Some(data) => data
    None => abort("State is not initialized for this World.")
  }
}

///|
/// Returns the current state value in this World. Requires initialization.
pub fn[T : StateType] current(world : @ecs.World) -> T {
  let data : StateData[T] = state_data(world)
  data.current
}

///|
/// Requests a transition. The last request before the transition point wins.
pub fn[T : StateType] set_next(world : @ecs.World, value : T) -> Unit {
  let data : StateData[T] = state_data(world)
  data.pending = Some(value)
}

///|
/// Tests the executing World's state, without capturing a World's data.
pub fn[T : StateType] in_state(value : T) -> @ecs.Condition {
  Condition(fn(state : State[T]) { state.get() == value })
}

///|
/// Initializes this state type once per World. Repeated calls preserve its value.
pub fn[T : StateType] initialize(world : @ecs.World, initial : T) -> Unit {
  let key : StateKey[T] = StateType::state_key()
  guard key.storage.get_in(world) is None else { return }
  key.storage.insert_in(world, {
    current: initial,
    pending: None,
    entered: false,
    transition: None,
  })
  @state_runtime.register(world, {
    prepare: (world, initial_only) => {
      let data : StateData[T] = state_data(world)
      if !data.entered {
        data.transition = Some((None, data.current))
        return Initial
      }
      guard !initial_only else { return Unchanged }
      let pending = data.pending
      data.pending = None
      match pending {
        Some(next) if next != data.current => {
          data.transition = Some((Some(data.current), next))
          Changed
        }
        _ => Unchanged
      }
    },
    commit: world => {
      let data : StateData[T] = state_data(world)
      if data.transition is Some((_, next)) {
        data.current = next
        data.entered = true
      }
    },
    finish: world => {
      let data : StateData[T] = state_data(world)
      data.transition = None
    },
  })
}

///|
struct State[T] {
  data : StateData[T]
}

///|
pub fn[T] State::get(self : State[T]) -> T {
  self.data.current
}

///|
pub fn[T : Eq] State::is_entering(self : State[T], value : T) -> Bool {
  match self.data.transition {
    Some((_, next)) => next == value
    None => false
  }
}

///|
pub fn[T : Eq] State::is_exiting(self : State[T], value : T) -> Bool {
  match self.data.transition {
    Some((Some(previous), _)) => previous == value
    _ => false
  }
}

///|
pub impl[T : StateType] @ecs.SystemParam for State[T] with fn prepare(world) {
  let data : StateData[T] = state_data(world)
  _ => { data, }
}

///|
pub extend State with @ecs.SystemParam::{prepare}

///|
struct NextState[T] {
  data : StateData[T]
}

///|
pub fn[T] NextState::set(self : NextState[T], value : T) -> Unit {
  self.data.pending = Some(value)
}

///|
pub impl[T : StateType] @ecs.SystemParam for NextState[T] with fn prepare(world) {
  let data : StateData[T] = state_data(world)
  _ => { data, }
}

///|
pub extend NextState with @ecs.SystemParam::{prepare}
