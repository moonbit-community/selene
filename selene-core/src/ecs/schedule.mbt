///|
pub type System = (World) -> Unit

///|
pub(all) suberror ScheduleError {
  ReentrantSchedule
  ActiveQuery
}

///|
#doc(hidden)
pub fn runtime_flush(_access : @ecs_access.Access, world : World) -> Unit {
  flush_commands(world)
  flush_entity_lifecycle(world)
}
