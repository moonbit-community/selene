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
  for pair in [(first, 1.0), (second, 2.0)] {
    let (world, x) = pair
    let sprites : @ecs.ComponentStore[@sprite.Sprite] = @ecs.components_in(
      world,
    )
    let transforms : @ecs.ComponentStore[@transform.Transform] = @ecs.components_in(
      world,
    )
    let globals : @ecs.ComponentStore[@transform.GlobalTransform] = @ecs.components_in(
      world,
    )
    ignore(
      sprites
      .spawn_bundle()
      .combine(transforms.spawn_bundle())
      .combine(globals.spawn_bundle())
      .spawn(
        world,
        (
          (@sprite.Sprite(), @transform.Transform::from_xyz(x, 0.0, 0.0)),
          @transform.GlobalTransform::identity(),
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
      query : @ecs.Query3[
        @sprite.Sprite,
        @transform.Transform,
        @transform.GlobalTransform,
      ],
    ) {
      query.for_each((_, _, transform, _) => {
        observed.push(transform.translation.x)
      })
    },
  )

  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  @app.App().with_world(second).add_system(Update, system).run_frames(1)
  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  assert_eq(observed, [1.0, 2.0, 1.0])
  assert_eq(constructed, [first.id(), second.id()])
}
