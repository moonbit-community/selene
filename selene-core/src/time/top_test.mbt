///|
test "explicit clock initialization preserves the World's existing time state" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @time.initialize(first)
  @ecs.set_current_world(first)
  assert_eq(@time.elapsed(), 0.0)
  @time.set_scale(0.5)
  @time.begin_frame(2.0)

  @time.initialize(first)
  assert_eq(@time.scale(), 0.5)
  assert_eq(@time.elapsed(), 1.0)

  @time.initialize(second)
  @ecs.set_current_world(second)
  assert_eq(@time.scale(), 1.0)
  assert_eq(@time.elapsed(), 0.0)
}
