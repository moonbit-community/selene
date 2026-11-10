///|
test "input velocity and resolved velocity use distinct component stores" {
  let world = @ecs.World()
  let input : @ecs.ComponentStore[@velocity.Velocity] = @ecs.components_in(
    world,
  )
  let entity = input.spawn_plan(world).spawn(Vec2(2.0, 0.0))
  let resolved = Ref(None)

  @ecs.run_schedule(world, _ => {
    @collision.resolved_velocities().set(entity, Vec2(1.0, 0.0))
    resolved.val = @collision.resolved_velocities().get(entity)
  })

  assert_eq(input.get(entity), Some(Vec2(2.0, 0.0)))
  assert_eq(resolved.val, Some(Vec2(1.0, 0.0)))
}
