///|
test "scheduler flushes commands in FIFO batches after startup and frames" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let calls = []
  let observed = []
  let app = @app.App()
    .with_world(world)
    .add_system(Startup, fn(_ : Unit) {
      commands.add(_ => {
        calls.push(1)
        commands.add(_ => calls.push(3))
      })
      commands.add(_ => calls.push(2))
    })
    .add_system(PreUpdate, fn(_ : Unit) { observed.push(calls.copy()) })
    .add_system(Update, fn(_ : Unit) { observed.push(calls.copy()) })
    .add_system(RenderExtract, fn(_ : Unit) { observed.push(calls.copy()) })

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
      @ecs.Schedule().add_exclusive_system(_ => calls.push(99)).run(world)
      false
    } catch {
      ReentrantSchedule => true
      _ => false
    }
    calls.push(1)
  })

  @ecs.Schedule().run(world)
  assert_true(rejected.val)
  assert_eq(calls, [1])
  @ecs.Schedule().run(world)
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
    try
      @ecs.Schedule().add_exclusive_system(_ => calls.push(99)).run(world)
    catch {
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
    try
      @ecs.Schedule().add_exclusive_system(_ => calls.push(99)).run(world)
    catch {
      ActiveQuery => rejected.push(true)
      _ => rejected.push(false)
    } noraise {
      _ => rejected.push(false)
    }
  })
  assert_eq(rejected, [true, true])
  assert_true(calls.is_empty())
  @ecs.Schedule().run(world)
  assert_eq(calls, [1])
}

///|
test "scheduler ticks only the active World's timeouts" {
  let first = @ecs.World()
  let second = @ecs.World()
  let calls = []
  let first_app = @app.App()
    .with_world(first)
    .add_system(Startup, fn(_ : Unit) {
      ignore(
        @time.timeout(0.25, () => calls.push(@ecs.require_current_world().id())),
      )
    })
    .add_system(PostUpdate, @ecs.args2(@time.timers_system))
  let second_app = @app.App()
    .with_world(second)
    .add_system(Startup, fn(_ : Unit) {
      ignore(
        @time.timeout(
          0.125,
          () => calls.push(@ecs.require_current_world().id()),
          pausible=false,
        ),
      )
    })
    .add_system(PostUpdate, @ecs.args2(@time.timers_system))

  first_app.run_frames(1, raw_delta=0.125)
  second_app.run_frames(3, raw_delta=0.125)
  assert_eq(calls, [second.id()])

  @app.App()
  .with_world(first)
  .add_system(PostUpdate, @ecs.args2(@time.timers_system))
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
  .add_system(Startup, fn(_ : Unit) {
    ignore(
      @time.timeout(0.0, () => {
        calls.push(1)
        ignore(@time.timeout(0.0, () => calls.push(3)))
        ignore(@time.timeout(0.0, () => calls.push(4), pausible=false))
      }),
    )
    ignore(@time.timeout(0.0, () => calls.push(2), pausible=false))
  })
  .add_system(
    PostUpdate,
    @ecs.args2(fn(timers : @time.Timers, time : @time.Time) {
      @time.timers_system(timers, time)
      after_tick.push(calls.copy())
    }),
  )
  .run_frames(3)
  assert_eq(after_tick, [[1, 2], [1, 2, 3, 4], [1, 2, 3, 4]])
}

///|
test "scaled and unscaled timeouts respect the World's time scale" {
  let world = @ecs.World()
  let calls = []
  @app.App()
  .with_world(world)
  .add_system(Startup, fn(time : @time.Time) {
    time.set_scale(0.0)
    ignore(@time.timeout(0.125, () => calls.push(2)))
    ignore(@time.timeout(0.125, () => calls.push(1), pausible=false))
  })
  .add_system(Update, fn(time : @time.Time) { time.set_scale(1.0) })
  .add_system(PostUpdate, @ecs.args2(@time.timers_system))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1])

  @app.App()
  .with_world(world)
  .add_system(PostUpdate, @ecs.args2(@time.timers_system))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1, 2])
}

///|
test "entities reserved during a command batch go live with the next batch" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let storage : @ecs.Query[@ecs.Single[CommandValue]] = world.query()
  let bundle : @ecs.SpawnPlan[@ecs.Single[CommandValue]] = @ecs.commands(world).prepare_spawn()
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
  .add_system(PreUpdate, fn(_ : Unit) {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push(
      (
        empty.is_alive(),
        bundled.is_alive(),
        storage.get(bundled).map(value => value.0),
      ),
    )
  })
  .add_system(Update, fn(_ : Unit) {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push(
      (
        empty.is_alive(),
        bundled.is_alive(),
        storage.get(bundled).map(value => value.0),
      ),
    )
  })
  .add_system(RenderExtract, fn(_ : Unit) {
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

///|
test "render stages flush once after cleanup and leave nested commands for the next schedule" {
  let world = @ecs.World()
  let trace = []
  let visible = []
  let app = @app.App()
    .with_world(world)
    .add_system(RenderExtract, fn(commands : @ecs.Commands) {
      ignore(commands.spawn1(CommandValue(7)))
      commands.add(_ => {
        trace.push(1)
        commands.add(_ => trace.push(3))
      })
    })
    .add_system(RenderPrepare, fn(
      query : @ecs.Query[@ecs.Single[CommandValue]],
    ) {
      visible.push(query.length())
    })
    .add_system(Render, fn(query : @ecs.Query[@ecs.Single[CommandValue]]) {
      visible.push(query.length())
    })
    .add_system(
      RenderCleanup,
      @ecs.args2(fn(
        query : @ecs.Query[@ecs.Single[CommandValue]],
        commands : @ecs.Commands,
      ) {
        visible.push(query.length())
        commands.add(_ => trace.push(2))
      }),
    )
  app.run_frames(1)
  assert_eq(visible, [0, 0, 0])
  assert_eq(trace, [1, 2])
  let query : @ecs.Query[@ecs.Single[CommandValue]] = world.query1()
  assert_eq(query.length(), 1)
  assert_true(@ecs.has_pending_commands(world))
  @ecs.Schedule().run(world)
  assert_eq(trace, [1, 2, 3])
}
