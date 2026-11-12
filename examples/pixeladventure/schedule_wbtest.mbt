///|
fn run_test_system(world : @ecs.World, run : (@ecs.World) -> Unit) -> Unit {
  @app.App().with_world(world).add_exclusive_system(Startup, run).run_frames(1)
}

///|
fn flush_test_commands(world : @ecs.World) -> Unit {
  run_test_system(world, _ => ())
}

///|
fn[P : @ecs.SystemParam] test_params(world : @ecs.World) -> P {
  let fetch : (@ecs.World) -> P = @ecs.SystemParam::prepare(world)
  fetch(world)
}
