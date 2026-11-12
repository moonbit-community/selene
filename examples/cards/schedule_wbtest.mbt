///|
fn run_test_system(world : @ecs.World, run : (@ecs.World) -> Unit) -> Unit {
  @app.App().with_world(world).add_exclusive_system(Startup, run).run_frames(1)
}
