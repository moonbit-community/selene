///|
priv enum TransitionKind {
  Unchanged
  Initial
  Changed
}

///|
priv struct StateEntry {
  prepare : (@ecs.World, Bool) -> TransitionKind
  commit : @ecs.System
  finish : @ecs.System
}

///|
priv struct StateRegistry {
  entries : Array[StateEntry]
  mut transitioning : Bool
}

///|
let registry_key : @ecs.ResourceKey[StateRegistry] = ResourceKey()

///|
/// Used by application lifecycle registration during an active transition.
pub fn[T : StateType] is_entering(world : @ecs.World, value : T) -> Bool {
  let data : StateData[T] = state_data(world)
  match data.transition {
    Some((_, next)) => next == value
    None => false
  }
}

///|
/// Used by application lifecycle registration during an active transition.
pub fn[T : StateType] is_exiting(world : @ecs.World, value : T) -> Bool {
  let data : StateData[T] = state_data(world)
  match data.transition {
    Some((Some(previous), _)) => previous == value
    _ => false
  }
}

///|
/// Applies one frozen batch: exits and command flush, commit, then enters and
/// command flush. Requests made by callbacks wait for the next batch.
/// With initial_only, only initial entries are dispatched; requests are retained.
#doc(hidden)
pub fn runtime_advance(
  _access : @ecs_access.Access,
  world : @ecs.World,
  on_exit~ : @ecs.System,
  on_enter~ : @ecs.System,
  initial_only~ : Bool = false,
) -> Unit raise @ecs.ScheduleError {
  guard registry_key.get_in(world) is Some(registry) else { return }
  guard !registry.transitioning else { raise ReentrantSchedule }
  registry.transitioning = true
  // Initialization during callbacks is deferred to the next transition point.
  let entries = registry.entries.copy()
  defer {
    for entry in entries {
      (entry.finish)(world)
    }
    registry.transitioning = false
  }
  let changed = Ref(false)
  let exiting = Ref(false)
  @ecs_runtime.run_schedule(world, world => {
    for entry in entries {
      match (entry.prepare)(world, initial_only) {
        Unchanged => ()
        Initial => changed.val = true
        Changed => {
          changed.val = true
          exiting.val = true
        }
      }
    }
    if exiting.val {
      on_exit(world)
    }
  })
  guard changed.val else { return }
  for entry in entries {
    (entry.commit)(world)
  }
  @ecs_runtime.run_schedule(world, on_enter)
}
