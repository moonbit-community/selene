///|
test "a generated component query resolves and caches separately for each World" {
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
    let sprites : @entity.ComponentStore[@sprite.Sprite] = @entity.components_in(
      world,
    )
    let transforms : @entity.ComponentStore[@transform.Transform] = @entity.components_in(
      world,
    )
    ignore(
      sprites
      .spawn_bundle()
      .combine(transforms.spawn_bundle())
      .spawn(
        world,
        (@sprite.Sprite(), @transform.Transform::from_xyz(x, 0.0, 0.0)),
      ),
    )
  }
  let observed = []
  let system = @app.query_system(fn(
    query : @query.Query2[@sprite.Sprite, @transform.Transform],
  ) {
    query.for_each((_, _, transform) => observed.push(transform.translation.x))
  })

  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  @app.App().with_world(second).add_system(Update, system).run_frames(1)
  @app.App().with_world(first).add_system(Update, system).run_frames(1)
  assert_eq(observed, [1.0, 2.0, 1.0])
}
