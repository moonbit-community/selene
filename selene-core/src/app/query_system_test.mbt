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
      @ecs_runtime.spawn(
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
  let constructed = []
  let app = @app.App().add_query_system(
    Update,
    fn(
      query : @ecs.Query[(@sprite.Sprite, @transform.Spatial, @sprite.Anchor)],
    ) {
      for _, (_, transform, _) in query {
        observed.push(transform.pose().translation.x)
      }
    },
    filters=world => {
      constructed.push(world.id())
      []
    },
  )
  app.with_world(first).run_frames(1)
  app.with_world(second).run_frames(1)
  app.with_world(first).run_frames(1)
  assert_eq(observed, [1.0, 2.0, 1.0])
  assert_eq(constructed, [first.id(), second.id()])
}

///|
test "single-component query systems honor conditions and system set ordering" {
  let world = @ecs.World()
  ignore(@ecs_runtime.spawn1(world, @sprite.Sprite()))
  let query_set = @app.SystemSet("query")
  let world_set = @app.SystemSet("world")
  let calls = []
  let app = @app.App()
    .add_system(Update, _ => calls.push(2), in_set=world_set)
    .add_query_system(
      Update,
      fn(query : @ecs.Query[@ecs.Single[@sprite.Sprite]]) {
        for _, _ in query {
          calls.push(1)
        }
      },
      in_set=query_set,
      before=[world_set],
      run_if=current => current.id() == world.id(),
    )
  app.with_world(world).run_frames(1)
  assert_eq(calls, [1, 2])
  calls.clear()
  app.with_world(World()).run_frames(1)
  assert_eq(calls, [2])
}
