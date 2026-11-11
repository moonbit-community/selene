///|
fn current_world() -> @ecs.World {
  @ecs.require_current_world()
}

///|
fn current_world_id() -> UInt32 {
  current_world().id()
}
