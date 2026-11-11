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
      world.spawn(
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
  let system = @ecs.query_system(
    world => {
      constructed.push(world.id())
      @ecs.Query3(
        @ecs.components_in(world),
        @ecs.components_in(world),
        @ecs.components_in(world),
      )
    },
    fn(
      query : @ecs.Query3[@sprite.Sprite, @transform.Spatial, @sprite.Anchor],
    ) {
      query.for_each((_, _, transform, _) => {
        observed.push(transform.pose().translation.x)
      })
    },
  )

  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  @app.App().with_world(second).add_system(Update, system).run_frames(1)
  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  assert_eq(observed, [1.0, 2.0, 1.0])
  assert_eq(constructed, [first.id(), second.id()])
}
