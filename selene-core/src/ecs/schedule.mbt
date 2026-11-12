///|
pub(all) suberror ScheduleError {
  ReentrantSchedule
  ActiveQuery
}

///|
let running_schedule : Ref[Bool] = Ref(false)

///|
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
/// Checks whether execution can start without changing the active World or queues.
pub fn check_schedule_idle() -> Unit raise ScheduleError {
  guard query_depth.val == 0 else { raise ActiveQuery }
  guard !running_schedule.val else { raise ReentrantSchedule }
}

///|
/// Runs one complete schedule and applies one frozen batch of its deferred commands.
/// Commands queued while applying that batch wait for the next schedule.
/// Nested execution, including execution for another World, is rejected.
fn run_schedule(
  world : World,
  run : (World) -> Unit,
) -> Unit raise ScheduleError {
  check_schedule_idle()
  let previous = current_world()
  running_schedule.val = true
  set_current_world(world)
  defer {
    running_schedule.val = false
    match previous {
      Some(world) => set_current_world(world)
      None => clear_current_world()
    }
  }
  run(world)
  flush_commands(world)
  flush_entity_lifecycle(world)
}
