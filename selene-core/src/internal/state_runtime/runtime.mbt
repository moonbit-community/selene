///|
/// Executes state transitions only at the application's scheduling points.
pub fn advance(
  world : @ecs.World,
  on_exit~ : @ecs.System,
  on_enter~ : @ecs.System,
  initial_only~ : Bool = false,
) -> Unit raise @ecs.ScheduleError {
  @state.runtime_advance(
    @ecs_access.acquire(),
    world,
    on_exit~,
    on_enter~,
    initial_only~,
  )
}
