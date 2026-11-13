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

///|
test "injected clock and timer queues remain isolated and retain their state" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let first_time = @time.Time(first)
  let second_time = @time.Time(second)
  first_time.set_scale(0.5)
  first_time.begin_frame(2.0)
  second_time.begin_frame(0.25)
  let fired = []
  let first_timers = @time.Timers(first)
  ignore(first_timers.timeout(1.0, () => fired.push(1)))
  ignore(@time.Timers(second).timeout(1.0, () => fired.push(2)))
  let deltas = []
  let schedule = @ecs.Schedule()
    .add_system(fn(time : @time.Time) { deltas.push(time.delta()) })
    .add_system(@ecs.args2(@time.timers_system))
  @ecs.set_current_world(second)
  schedule.run(first)
  assert_eq(deltas, [1.0])
  assert_eq(fired, [1])
  assert_eq(@ecs.require_current_world().id(), second.id())
  schedule.run(second)
  assert_eq(deltas, [1.0, 0.25])
  assert_eq(fired, [1])
  assert_eq(@time.Time(first).elapsed(), 1.0)
  assert_eq(@time.Time(first).scale(), 0.5)
}
