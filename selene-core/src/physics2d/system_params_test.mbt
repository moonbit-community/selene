///|
test "2D physics updates its injected World while another World is active" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let moving = @ecs.commands(first).spawn(
    (
      @transform.Spatial(@transform.Transform::identity()),
      (Vec2(10.0, 0.0) : @physics2d.LinearVelocity),
    ),
  )
  let stationary = @ecs.commands(second).spawn1(
    @transform.Spatial(@transform.Transform::identity()),
  )
  @ecs.Schedule().run(first)
  @ecs.Schedule().run(second)
  let first_time = @time.Time(first)
  first_time.set_delta(0.1)
  @ecs.set_current_world(second)
  @physics2d.physics_step_system(PhysicsStep2D(first), first_time)
  assert_eq(
    @transform.local_transform(world=first, moving).unwrap().translation.x,
    1.0,
  )
  assert_eq(
    @transform.local_transform(world=second, stationary).unwrap().translation.x,
    0.0,
  )
  @ecs.clear_current_world()
  first_time.set_delta(0.2)
  @physics2d.physics_step_system(PhysicsStep2D(first), first_time)
  assert_eq(
    @transform.local_transform(world=first, moving).unwrap().translation.x,
    3.0,
  )
}
