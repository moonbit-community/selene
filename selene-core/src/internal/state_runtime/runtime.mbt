///|
pub(all) enum TransitionKind {
  Unchanged
  Initial
  Changed
}

///|
pub(all) struct StateEntry {
  prepare : (@ecs.World, Bool) -> TransitionKind
  commit : (@ecs.World) -> Unit
  finish : (@ecs.World) -> Unit
}

///|
priv struct StateRegistry {
  entries : Array[StateEntry]
  mut transitioning : Bool
}

///|
let registry_key : @ecs.ResourceKey[StateRegistry] = ResourceKey()

///|
pub fn register(world : @ecs.World, entry : StateEntry) -> Unit {
  let registry = registry_key.get_or_insert_with(world, _ => {
    entries: [],
    transitioning: false,
  })
  registry.entries.push(entry)
}

///|
/// Applies one frozen batch: exits and command flush, commit, then enters and
/// command flush. Requests made by callbacks wait for the next batch.
/// With initial_only, only initial entries are dispatched; requests are retained.
pub fn advance(
  world : @ecs.World,
  on_exit~ : @ecs.Schedule,
  on_enter~ : @ecs.Schedule,
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
  let prepare = @ecs.Schedule().add_exclusive_system(world => {
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
  })
  @ecs.Schedule::chain([
    prepare,
    on_exit.with_run_if(@ecs.Condition::exclusive(_ => exiting.val)),
  ]).run(world)
  guard changed.val else { return }
  for entry in entries {
    (entry.commit)(world)
  }
  on_enter.run(world)
}
