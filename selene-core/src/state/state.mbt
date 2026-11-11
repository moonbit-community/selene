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
pub fn[T : StateType] in_state(value : T) -> (@ecs.World) -> Bool {
  world => current(world) == value
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
  let registry = registry_key.get_or_insert_with(world, _ => {
    entries: [],
    transitioning: false,
  })
  registry.entries.push({
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
