///|
fn[T : Bundle] World::spawn(
  self : World,
  values : T,
  parent? : Entity,
) -> Entity {
  self.runtime_spawn(@ecs_access.acquire(), values, parent?)
}

///|
fn run_schedule(world : World, run : System) -> Unit raise ScheduleError {
  @ecs_runtime.run_schedule(world, run)
}
