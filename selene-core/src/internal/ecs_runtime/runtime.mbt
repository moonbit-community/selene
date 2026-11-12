///|
let access : @ecs_access.Access = @ecs_access.acquire()

///|
pub fn run_schedule(
  world : @ecs.World,
  run : @ecs.System,
) -> Unit raise @ecs.ScheduleError {
  require_idle()
  let previous = @ecs.current_world()
  @ecs_access.set_schedule_running(true)
  @ecs.set_current_world(world)
  defer {
    @ecs_access.set_schedule_running(false)
    match previous {
      Some(world) => @ecs.set_current_world(world)
      None => @ecs.clear_current_world()
    }
  }
  run(world)
  @ecs.runtime_flush(access, world)
}

///|
pub fn[T : @ecs.Bundle] spawn(
  world : @ecs.World,
  values : T,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  world.runtime_spawn(access, values, parent?)
}

///|
pub fn[T : @ecs.Component] spawn1(
  world : @ecs.World,
  value : T,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  world.runtime_spawn1(access, value, parent?)
}

///|
pub fn[T] spawn_prepared(
  plan : @ecs.SpawnPlan[T],
  values : T,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  plan.runtime_spawn(access, values, parent?)
}

///|
pub fn spawn_draft(
  draft : @ecs.SpawnDraft,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  draft.runtime_spawn(access, parent?)
}

///|
pub fn delete(entity : @ecs.Entity) -> Bool {
  entity.runtime_delete(access)
}

///|
pub fn destroy(entity : @ecs.Entity) -> Unit {
  entity.runtime_destroy(access)
}

///|
pub fn respawn(entity : @ecs.Entity) -> Unit {
  entity.runtime_respawn(access)
}

///|
/// Checks before an App driver changes the active World or platform state.
pub fn require_idle() -> Unit raise @ecs.ScheduleError {
  guard !@ecs_access.query_active() else { raise ActiveQuery }
  guard !@ecs_access.schedule_running() else { raise ReentrantSchedule }
}
