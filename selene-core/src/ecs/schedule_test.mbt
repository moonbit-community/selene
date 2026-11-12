///|
test "public schedules apply one World-local FIFO batch and restore no active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  let other = @ecs.World()
  let queue = @ecs.commands(world)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let entity = queue.spawn1(Position(1))
  let trace = []
  queue.add(world => {
    trace.push(world.id())
    world.set_component(entity, Position(2))
    queue.add(_ => trace.push(3U))
  })
  @ecs.commands(other).add(_ => trace.push(99U))
  @ecs.clear_current_world()
  @ecs.check_schedule_idle()
  assert_true(query.is_empty())
  @ecs.Schedule()
  .add_exclusive_system(selected => {
    trace.push(0U)
    guard selected.id() == world.id() && query.is_empty() else {
      abort("schedule ran in another World or flushed before its systems")
    }
  })
  .run(world)
  assert_eq(@ecs.current_world().map(world => world.id()), None)
  assert_eq(trace, [0U, world.id()])
  assert_eq(query.get(entity), Some(Single(Position(2))))
  @ecs.Schedule().run(world)
  assert_eq(trace, [0U, world.id(), 3U])
  assert_true(@ecs.has_pending_commands(other))
}

///|
test "public schedule rejects cross-World reentry from systems and queued commands" {
  let world = @ecs.World()
  let other = @ecs.World()
  let trace = []
  let rejected = []
  @ecs.commands(other).add(_ => trace.push(99))
  fn attempt() {
    try
      @ecs.Schedule().add_exclusive_system(_ => trace.push(98)).run(other)
    catch {
      ReentrantSchedule => rejected.push(true)
      _ => rejected.push(false)
    } noraise {
      _ => rejected.push(false)
    }
  }
  @ecs.commands(world).add(_ => {
    attempt()
    trace.push(2)
  })
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    attempt()
    trace.push(1)
  })
  .run(world)
  assert_eq(rejected, [true, true])
  assert_eq(trace, [1, 2])
  @ecs.Schedule().add_exclusive_system(_ => trace.push(3)).run(other)
  assert_eq(trace, [1, 2, 3, 99])
}

///|
test "a query batch rejects public scheduling for every World without applying commands" {
  let world = @ecs.World()
  let other = @ecs.World()
  let entity = @ecs.commands(world).spawn1(Position(1))
  @ecs.Schedule().run(world)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let trace = []
  let rejected = []
  @ecs.commands(world).delete(entity)
  @ecs.commands(other).add(_ => trace.push(1))
  query.batches(_ => {
    for target in [world, other] {
      try
        @ecs.Schedule().add_exclusive_system(_ => trace.push(99)).run(target)
      catch {
        ActiveQuery => rejected.push(true)
        _ => rejected.push(false)
      } noraise {
        _ => rejected.push(false)
      }
    }
  })
  assert_eq(rejected, [true, true])
  assert_true(trace.is_empty())
  assert_true(query.contains(entity))
  @ecs.Schedule().run(world)
  assert_false(entity.is_valid_in(world))
  @ecs.Schedule().run(other)
  assert_eq(trace, [1])
}
