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
  @ecs.run_schedule(world, selected => {
    trace.push(0U)
    guard selected.id() == world.id() && query.is_empty() else {
      abort("schedule ran in another World or flushed before its systems")
    }
  })
  assert_eq(@ecs.current_world().map(world => world.id()), None)
  assert_eq(trace, [0U, world.id()])
  assert_eq(query.get(entity), Some(Single(Position(2))))
  @ecs.run_schedule(world, _ => ())
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
    try @ecs.run_schedule(other, _ => trace.push(98)) catch {
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
  @ecs.run_schedule(world, _ => {
    attempt()
    trace.push(1)
  })
  assert_eq(rejected, [true, true])
  assert_eq(trace, [1, 2])
  @ecs.run_schedule(other, _ => trace.push(3))
  assert_eq(trace, [1, 2, 3, 99])
}

///|
test "a query batch rejects public scheduling for every World without applying commands" {
  let world = @ecs.World()
  let other = @ecs.World()
  let entity = @ecs.commands(world).spawn1(Position(1))
  @ecs.run_schedule(world, _ => ())
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let trace = []
  let rejected = []
  @ecs.commands(world).delete(entity)
  @ecs.commands(other).add(_ => trace.push(1))
  query.batches(_ => {
    for target in [world, other] {
      try @ecs.run_schedule(target, _ => trace.push(99)) catch {
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
  @ecs.run_schedule(world, _ => ())
  assert_false(entity.is_valid_in(world))
  @ecs.run_schedule(other, _ => ())
  assert_eq(trace, [1])
}
