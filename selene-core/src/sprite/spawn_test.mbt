///|
test "typed spawn binds the layout to the explicit World" {
  let world = @ecs.World()
  let other = @ecs.World()
  let sprite = @sprite.Sprite()
  let transform = @transform.Transform::from_xyz(3.0, 4.0, 0.0)
  let sprites : @ecs.ComponentStore[@sprite.Sprite] = @ecs.components_in(world)
  let transforms : @ecs.ComponentStore[@transform.Transform] = @ecs.components_in(
    world,
  )
  let foreign : @ecs.ComponentStore[@sprite.Sprite] = @ecs.components_in(other)
  let empty = world.spawn(())
  let single = world.spawn(@ecs.Single(sprite))
  let plan : @ecs.SpawnPlan[(@sprite.Sprite, @transform.Transform)] = world.prepare_spawn()
  let prepared = plan.spawn((sprite, transform))
  let reversed = world.spawn((transform, sprite))
  assert_true(empty.belongs_to(world))
  assert_false(sprites.contains(empty))
  assert_true(sprites.contains(single))
  assert_false(transforms.contains(single))
  let pending = @ecs.commands(world).spawn(@ecs.Single(sprite))
  assert_false(sprites.contains(pending))
  @ecs.run_schedule(world, _ => ())
  assert_true(sprites.contains(pending))
  for entity in [prepared, reversed] {
    assert_true(@ecs.alive_in_world(world)(entity))
    assert_true(sprites.contains(entity))
    assert_eq(transforms.get(entity), Some(transform))
    assert_false(foreign.contains(entity))
  }
}

///|
test "typed spawn can queue an entity from a query" {
  let world = @ecs.World()
  let first = world.spawn(@ecs.Single(@sprite.Sprite()))
  let sprites : @ecs.ComponentStore[@sprite.Sprite] = @ecs.components_in(world)
  let transforms : @ecs.ComponentStore[@transform.Transform] = @ecs.components_in(
    world,
  )
  let commands = @ecs.commands(world)
  let query = @ecs.query(world, sprites)
  let transform = @transform.Transform::from_xyz(3.0, 4.0, 0.0)
  let later = @transform.Transform::from_xyz(5.0, 6.0, 0.0)
  let spawned = []
  @ecs.run_schedule(world, _ => {
    query.for_each((entity, sprite) => {
      if entity == first {
        let pending = commands.spawn((sprite, transform))
        commands.insert_component(transforms, pending, later)
        spawned.push(pending)
      }
    })
    guard spawned is [pending] else { abort("expected one pending entity") }
    guard !@ecs.alive_in_world(world)(pending) else {
      abort("entity is already alive")
    }
    guard !sprites.contains(pending) else { abort("bundle is already visible") }
  })
  guard spawned is [entity] else { fail("expected one spawned entity") }
  assert_true(@ecs.alive_in_world(world)(entity))
  assert_true(sprites.contains(entity))
  assert_eq(transforms.get(entity), Some(later))
}

///|
test "panic typed spawn rejects duplicate component columns" {
  let world = @ecs.World()
  let sprite = @sprite.Sprite()
  ignore(world.spawn((sprite, sprite)))
}
