///|
test "3D physics synchronizes the injected World with no active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let moving = @ecs.commands(first).spawn(
    (
      (KinematicVelocityBased : @physics3d.RigidBody),
      (
        { linvel: Vec3(10.0, 0.0, 0.0), angvel: @math.Vec3::zero(), } :
        @physics3d.Velocity),
      @transform.Spatial(@transform.Transform::identity()),
    ),
  )
  let stationary = @ecs.commands(second).spawn1(
    @transform.Spatial(@transform.Transform::identity()),
  )
  @ecs.Schedule().run(first)
  @ecs.Schedule().run(second)
  let time = @time.Time(first)
  time.set_delta(0.1)
  @ecs.set_current_world(second)
  @physics3d.physics_step_system(PhysicsStep3D(first), time)
  assert_true(
    @transform.local_transform(world=first, moving).unwrap().translation.x > 0.9,
  )
  assert_eq(
    @transform.local_transform(world=second, stationary).unwrap().translation.x,
    0.0,
  )
  @ecs.clear_current_world()
  @physics3d.physics_step_system(PhysicsStep3D(first), time)
  assert_true(
    @transform.local_transform(world=first, moving).unwrap().translation.x > 1.9,
  )
}
