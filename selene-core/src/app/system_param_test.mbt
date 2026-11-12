///|
test "a three-component query is constructed once per World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(second)
  for (world, x) in [(first, 1.0), (second, 2.0)] {
    ignore(
      @ecs_test.spawn(
        world,
        (
          @sprite.Sprite(),
          @transform.Spatial(@transform.Transform::from_xyz(x, 0.0, 0.0)),
          @sprite.default_anchor(),
        ),
      ),
    )
  }
  let observed = []
  query_constructions.clear()
  let app = @app.App().add_system(Update, fn(params : TrackedQuery) {
    for _, (_, transform, _) in params.query {
      observed.push(transform.pose().translation.x)
    }
  })
  app.with_world(first).run_frames(1)
  app.with_world(second).run_frames(1)
  app.with_world(first).run_frames(1)
  assert_eq(observed, [1.0, 2.0, 1.0])
  assert_eq(query_constructions, [first.id(), second.id()])
}

///|
test "single-component query systems honor conditions and system set ordering" {
  let world = @ecs.World()
  ignore(@ecs_test.spawn1(world, @sprite.Sprite()))
  let query_set = @ecs.SystemSet("query")
  let world_set = @ecs.SystemSet("world")
  let calls = []
  let app = @app.App()
    .add_system(Update, fn(_ : Unit) { calls.push(2) }, in_set=world_set)
    .add_system(
      Update,
      fn(query : @ecs.Query[@ecs.Single[@sprite.Sprite]]) {
        for _, _ in query {
          calls.push(1)
        }
      },
      in_set=query_set,
      before=[world_set],
      run_if=@ecs.Condition::exclusive(current => current.id() == world.id()),
    )
  app.with_world(world).run_frames(1)
  assert_eq(calls, [1, 2])
  calls.clear()
  app.with_world(World()).run_frames(1)
  assert_eq(calls, [2])
}

///|
let query_constructions : Array[UInt32] = []

///|
priv struct TrackedQuery {
  query : @ecs.Query[(@sprite.Sprite, @transform.Spatial, @sprite.Anchor)]
}

///|
impl @ecs.SystemParam for TrackedQuery with fn prepare(world) {
  query_constructions.push(world.id())
  let query : @ecs.Query[(@sprite.Sprite, @transform.Spatial, @sprite.Anchor)] = world.query()
  _ => { query, }
}

///|
test "injected clocks use the executing World's selected fixed and frame delta" {
  let first = @ecs.World()
  let second = @ecs.World()
  let fixed = []
  let frames = []
  let app = @app.App()
    .add_system(FixedUpdate, fn(time : @time.Time) { fixed.push(time.delta()) })
    .add_system(Update, fn(time : @time.Time) { frames.push(time.delta()) })
  app
  .with_world(first)
  .run_frames(1, raw_delta=0.125, fixed_delta_override=Some(0.0625))
  app
  .with_world(second)
  .run_frames(1, raw_delta=0.25, fixed_delta_override=Some(0.125))
  app
  .with_world(first)
  .run_frames(1, raw_delta=0.5, fixed_delta_override=Some(0.25))
  assert_eq(fixed, [0.0625, 0.0625, 0.125, 0.125, 0.25, 0.25])
  assert_eq(frames, [0.125, 0.25, 0.5])
}
