///|
test "input velocity and resolved velocity use distinct runtime storage" {
  let world = @ecs.World()
  let input : @ecs.Query[@ecs.Single[@velocity.Velocity]] = world.query()
  let entity = world.spawn1(@velocity.Velocity(Vec2(2.0, 0.0)))
  let resolved = Ref(None)

  @ecs.run_schedule(world, _ => {
    resolved_velocities().set(entity, Vec2(1.0, 0.0))
    resolved.val = resolved_velocity(entity)
  })

  assert_eq(input.get(entity).map(value => value.0), Some(Vec2(2.0, 0.0)))
  assert_eq(resolved.val, Some(Vec2(1.0, 0.0)))
}
