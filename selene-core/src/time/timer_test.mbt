///|
test "timeouts can be cancelled before ticking and within a due batch" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @time.initialize(world)
  let calls = []
  @ecs.set_current_world(world)
  let cancelled = @time.timeout(0.0, () => calls.push(0))
  @ecs.set_current_world(World())
  assert_true(cancelled.cancel())
  assert_false(cancelled.cancel())
  @ecs.set_current_world(world)
  let later : Ref[@time.TimerHandle?] = Ref(None)
  let first = @time.timeout(0.0, () => {
    calls.push(1)
    ignore(later.val.unwrap().cancel())
  })
  later.val = Some(@time.timeout(0.0, () => calls.push(2)))

  try! @ecs.Schedule().add_system(@ecs.args2(@time.timers_system)).run(world)
  assert_eq(calls, [1])
  assert_false(first.cancel())
  assert_false(later.val.unwrap().cancel())
}

///|
test "scaled and realtime timer ticks advance only their own clock" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(world)
  @time.set_scale(0.5)
  @time.begin_frame(2.0)
  let calls = []
  ignore(@time.timeout(1.0, () => calls.push(1)))
  ignore(@time.timeout(2.0, () => calls.push(2), pausible=false))

  try! @ecs.Schedule().add_system(@ecs.args2(@time.timer_system)).run(world)
  assert_eq(calls, [1])
  try! @ecs.Schedule()
  .add_system(@ecs.args2(@time.realtime_timer_system))
  .run(world)
  assert_eq(calls, [1, 2])
}
