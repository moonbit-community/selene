///|
fn run_test_system(world : @ecs.World, run : @ecs.System) -> Unit {
  @app.App().with_world(world).add_system(Startup, run).run_frames(1)
}

///|
fn flush_test_commands(world : @ecs.World) -> Unit {
  run_test_system(world, _ => ())
}
