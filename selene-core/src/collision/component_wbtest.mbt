///|
test "input velocity and resolved velocity use distinct runtime storage" {
  let world = @ecs.World()
  let input : @ecs.ComponentStore[@velocity.Velocity] = @ecs.components_in(
    world,
  )
  let entity = input.spawn_plan(world).spawn(Vec2(2.0, 0.0))
  let resolved = Ref(None)

  @ecs.run_schedule(world, _ => {
    resolved_velocities().set(entity, Vec2(1.0, 0.0))
    resolved.val = resolved_velocity(entity)
  })

  assert_eq(input.get(entity), Some(Vec2(2.0, 0.0)))
  assert_eq(resolved.val, Some(Vec2(1.0, 0.0)))
}
