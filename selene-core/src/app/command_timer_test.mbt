///|
test "scheduler flushes commands in FIFO batches after startup and frames" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let calls = []
  let observed = []
  let app = @app.App()
    .with_world(world)
    .add_system(Startup, _ => {
      commands.add(_ => {
        calls.push(1)
        commands.add(_ => calls.push(3))
      })
      commands.add(_ => calls.push(2))
    })
    .add_system(PreUpdate, _ => observed.push(calls.copy()))
    .add_system(Update, _ => observed.push(calls.copy()))
    .add_system(RenderExtract, _ => observed.push(calls.copy()))

  app.run_frames(1, raw_delta=0.125, fixed_delta_override=Some(1.0))
  assert_eq(observed, [[1, 2], [1, 2, 3], [1, 2, 3]])
  assert_false(@ecs.has_pending_commands(world))
}

///|
test "schedule rejects reentry and leaves the nested batch queued" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let calls = []
  let rejected = Ref(false)
  commands.add(_ => {
    commands.add(_ => calls.push(2))
    rejected.val = try {
      @ecs.run_schedule(world, _ => calls.push(99))
      false
    } catch {
      ReentrantSchedule => true
      _ => false
    }
    calls.push(1)
  })

  @ecs.run_schedule(world, _ => ())
  assert_true(rejected.val)
  assert_eq(calls, [1])
  @ecs.run_schedule(world, _ => ())
  assert_eq(calls, [1, 2])
}

///|
test "schedule rejects query batch callbacks" {
  let world = @ecs.World()
  let storage : @ecs.Query[@ecs.Single[CommandValue]] = world.query()
  ignore(@ecs_test.spawn1(world, CommandValue(42)))
  let commands = @ecs.commands(world)
  let calls = []
  let rejected = []
  commands.add(_ => calls.push(1))

  storage.batches(_ => {
    try @ecs.run_schedule(world, _ => calls.push(99)) catch {
      ActiveQuery => rejected.push(true)
      _ => rejected.push(false)
    } noraise {
      _ => rejected.push(false)
    }
  })
  (
    world.query() :
    @ecs.Query[
      (CommandValue, CommandValue, CommandValue, CommandValue, CommandValue),
    ]).batches(_ => {
    try @ecs.run_schedule(world, _ => calls.push(99)) catch {
      ActiveQuery => rejected.push(true)
      _ => rejected.push(false)
    } noraise {
      _ => rejected.push(false)
    }
  })
  assert_eq(rejected, [true, true])
  assert_true(calls.is_empty())
  @ecs.run_schedule(world, _ => ())
  assert_eq(calls, [1])
}

///|
test "scheduler ticks only the active World's timeouts" {
  let first = @ecs.World()
  let second = @ecs.World()
  let calls = []
  let first_app = @app.App()
    .with_world(first)
    .add_system(Startup, _ => {
      ignore(
        @time.timeout(0.25, () => calls.push(@ecs.require_current_world().id())),
      )
    })
    .add_system(PostUpdate, _ => @time.timers_system(@time.delta()))
  let second_app = @app.App()
    .with_world(second)
    .add_system(Startup, _ => {
      ignore(
        @time.timeout(
          0.125,
          () => calls.push(@ecs.require_current_world().id()),
          pausible=false,
        ),
      )
    })
    .add_system(PostUpdate, _ => @time.timers_system(@time.delta()))

  first_app.run_frames(1, raw_delta=0.125)
  second_app.run_frames(3, raw_delta=0.125)
  assert_eq(calls, [second.id()])

  @app.App()
  .with_world(first)
  .add_system(PostUpdate, _ => @time.timers_system(@time.delta()))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [second.id(), first.id()])
}

///|
test "zero-delay timeouts scheduled by callbacks run on the next tick" {
  let world = @ecs.World()
  let calls = []
  let after_tick = []
  @app.App()
  .with_world(world)
  .add_system(Startup, _ => {
    ignore(
      @time.timeout(0.0, () => {
        calls.push(1)
        ignore(@time.timeout(0.0, () => calls.push(3)))
        ignore(@time.timeout(0.0, () => calls.push(4), pausible=false))
      }),
    )
    ignore(@time.timeout(0.0, () => calls.push(2), pausible=false))
  })
  .add_system(PostUpdate, _ => {
    @time.timers_system(@time.delta())
    after_tick.push(calls.copy())
  })
  .run_frames(3)
  assert_eq(after_tick, [[1, 2], [1, 2, 3, 4], [1, 2, 3, 4]])
}

///|
test "scaled and unscaled timeouts respect the World's time scale" {
  let world = @ecs.World()
  let calls = []
  @app.App()
  .with_world(world)
  .add_system(Startup, _ => {
    @time.set_scale(0.0)
    ignore(@time.timeout(0.125, () => calls.push(2)))
    ignore(@time.timeout(0.125, () => calls.push(1), pausible=false))
  })
  .add_system(Update, _ => @time.set_scale(1.0))
  .add_system(PostUpdate, _ => @time.timers_system(@time.delta()))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1])

  @app.App()
  .with_world(world)
  .add_system(PostUpdate, _ => @time.timers_system(@time.delta()))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1, 2])
}

///|
test "entities reserved during a command batch go live with the next batch" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let storage : @ecs.Query[@ecs.Single[CommandValue]] = world.query()
  let bundle : @ecs.SpawnPlan[@ecs.Single[CommandValue]] = world.prepare_spawn()
  let spawned : Ref[(@ecs.Entity, @ecs.Entity)?] = Ref(None)
  let observed = []
  commands.add(_ => {
    spawned.val = Some(
      (
        commands.spawn(()),
        commands.spawn_prepared(bundle, Single(CommandValue(42))),
      ),
    )
  })

  @app.App()
  .with_world(world)
  .add_system(PreUpdate, _ => {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push(
      (
        empty.is_alive(),
        bundled.is_alive(),
        storage.get(bundled).map(value => value.0),
      ),
    )
  })
  .add_system(Update, _ => {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push(
      (
        empty.is_alive(),
        bundled.is_alive(),
        storage.get(bundled).map(value => value.0),
      ),
    )
  })
  .add_system(RenderExtract, _ => {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push(
      (
        empty.is_alive(),
        bundled.is_alive(),
        storage.get(bundled).map(value => value.0),
      ),
    )
  })
  .run_frames(1, raw_delta=0.125, fixed_delta_override=Some(1.0))
  assert_eq(observed, [
    (false, false, None),
    (true, true, Some(CommandValue(42))),
    (true, true, Some(CommandValue(42))),
  ])
}

///|
#derive(Eq, Debug)
struct CommandValue(Int32)

///|
let command_value_key : @ecs.ComponentKey[CommandValue] = ComponentKey()

///|
impl @ecs.Component for CommandValue with fn component_key() {
  command_value_key
}
