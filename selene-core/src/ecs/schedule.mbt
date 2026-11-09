///|
pub type System = (World) -> Unit

///|
pub(all) suberror ScheduleError {
  ReentrantSchedule
  ActiveQuery
}

///|
let running_schedule : Ref[Bool] = Ref(false)

///|
// Query traversal and command application both run synchronously.
let query_depth : Ref[Int32] = Ref(0)

///|
fn enter_query() -> Unit {
  query_depth.val += 1
}

///|
fn leave_query() -> Unit {
  query_depth.val -= 1
}

///|
/// Runs an ECS schedule, then applies one batch of commands and entity lifecycle changes.
/// A command queued during application is left for the next schedule.
pub fn run_schedule(world : World, run : System) -> Unit raise ScheduleError {
  guard query_depth.val == 0 else { raise ActiveQuery }
  guard !running_schedule.val else { raise ReentrantSchedule }
  let previous_world = current_world()
  running_schedule.val = true
  set_current_world(world)
  defer {
    running_schedule.val = false
    match previous_world {
      Some(previous) => set_current_world(previous)
      None => clear_current_world()
    }
  }
  run(world)
  flush_commands(world)
  flush_entity_lifecycle(world)
}
