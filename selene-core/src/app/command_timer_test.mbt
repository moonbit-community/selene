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
    .add_system(Update, _ => observed.push(calls.copy()))
    .add_system(RenderExtract, _ => observed.push(calls.copy()))

  app.run_frames(1, raw_delta=0.125, fixed_delta_override=Some(1.0))
  assert_eq(observed, [[1, 2], [1, 2, 3]])
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
test "schedule rejects streaming and archetype batch queries" {
  let world = @ecs.World()
  let storage : @ecs.ComponentStore[Int32] = ComponentStore(world)
  ignore(storage.spawn_plan(world).spawn(42))
  let commands = @ecs.commands(world)
  let calls = []
  let rejected = []
  commands.add(_ => calls.push(1))

  @ecs.query(world, storage).for_each((_, _) => {
    try @ecs.run_schedule(world, _ => calls.push(99)) catch {
      ActiveQuery => rejected.push(true)
      _ => rejected.push(false)
    } noraise {
      _ => rejected.push(false)
    }
  })
  @ecs.Query5(storage, storage, storage, storage, storage).for_each_batch((
    _,
    _,
    _,
    _,
    _,
    _,
  ) => {
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
        @system.timeout(0.25, () => {
          calls.push(@ecs.require_current_world().id())
        }),
      )
    })
    .add_system(PostUpdate, _ => @system.timers_system(@time.delta()))
  let second_app = @app.App()
    .with_world(second)
    .add_system(Startup, _ => {
      ignore(
        @system.timeout(
          0.125,
          () => calls.push(@ecs.require_current_world().id()),
          pausible=false,
        ),
      )
    })
    .add_system(PostUpdate, _ => @system.timers_system(@time.delta()))

  first_app.run_frames(1, raw_delta=0.125)
  second_app.run_frames(3, raw_delta=0.125)
  assert_eq(calls, [second.id()])

  @app.App()
  .with_world(first)
  .add_system(PostUpdate, _ => @system.timers_system(@time.delta()))
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
      @system.timeout(0.0, () => {
        calls.push(1)
        ignore(@system.timeout(0.0, () => calls.push(3)))
        ignore(@system.timeout(0.0, () => calls.push(4), pausible=false))
      }),
    )
    ignore(@system.timeout(0.0, () => calls.push(2), pausible=false))
  })
  .add_system(PostUpdate, _ => {
    @system.timers_system(@time.delta())
    after_tick.push(calls.copy())
  })
  .run_frames(3)
  assert_eq(after_tick, [[1, 2], [1, 2, 3, 4], [1, 2, 3, 4]])
}

///|
test "timeouts can be cancelled before ticking and within a due batch" {
  let world = @ecs.World()
  @time.initialize(world)
  let calls = []
  @ecs.set_current_world(world)
  let cancelled = @system.timeout(0.0, () => calls.push(0))
  @ecs.set_current_world(World())
  assert_true(cancelled.cancel())
  assert_false(cancelled.cancel())
  @ecs.set_current_world(world)
  let later : Ref[@system.TimerHandle?] = Ref(None)
  let first = @system.timeout(0.0, () => {
    calls.push(1)
    ignore(later.val.unwrap().cancel())
  })
  later.val = Some(@system.timeout(0.0, () => calls.push(2)))

  @system.timers_system(0.0)
  assert_eq(calls, [1])
  assert_false(first.cancel())
  assert_false(later.val.unwrap().cancel())
}

///|
test "scaled and unscaled timeouts respect the World's time scale" {
  let world = @ecs.World()
  let calls = []
  @app.App()
  .with_world(world)
  .add_system(Startup, _ => {
    @time.set_scale(0.0)
    ignore(@system.timeout(0.125, () => calls.push(2)))
    ignore(@system.timeout(0.125, () => calls.push(1), pausible=false))
  })
  .add_system(Update, _ => @time.set_scale(1.0))
  .add_system(PostUpdate, _ => @system.timers_system(@time.delta()))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1])

  @app.App()
  .with_world(world)
  .add_system(PostUpdate, _ => @system.timers_system(@time.delta()))
  .run_frames(1, raw_delta=0.125)
  assert_eq(calls, [1, 2])
}

///|
test "entities reserved during a command batch go live with the next batch" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let storage : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let bundle = storage.spawn_plan(world)
  let spawned : Ref[(@ecs.Entity, @ecs.Entity)?] = Ref(None)
  let observed = []
  commands.add(_ => {
    spawned.val = Some(
      (commands.spawn(()), commands.spawn_prepared(bundle, 42)),
    )
  })

  @app.App()
  .with_world(world)
  .add_system(Update, _ => {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push((empty.is_alive(), bundled.is_alive(), storage.get(bundled)))
  })
  .add_system(RenderExtract, _ => {
    let (empty, bundled) = spawned.val.unwrap()
    observed.push((empty.is_alive(), bundled.is_alive(), storage.get(bundled)))
  })
  .run_frames(1, raw_delta=0.125, fixed_delta_override=Some(1.0))
  assert_eq(observed, [(false, false, None), (true, true, Some(42))])
}
