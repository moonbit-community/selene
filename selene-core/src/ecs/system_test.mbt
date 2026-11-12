///|
struct SystemSettings(Int32)

///|
let system_settings_key : @ecs.ResourceKey[SystemSettings] = ResourceKey()

///|
impl @ecs.Resource for SystemSettings with fn resource_key() {
  system_settings_key
}

///|
let param_preparations : Array[UInt32] = []

///|
priv struct Invocation {
  world_id : UInt32
  count : Int32
}

///|
impl @ecs.SystemParam for Invocation with fn prepare(world) {
  let world_id = world.id()
  param_preparations.push(world_id)
  let count = Ref(0)
  _ => {
    count.val += 1
    { world_id, count: count.val, }
  }
}

///|
test "system registrations prepare independently per World and survive schedule composition" {
  param_preparations.clear()
  let first = @ecs.World()
  let second = @ecs.World()
  let observed = []
  let system = @ecs.System(fn(value : Invocation) {
    observed.push((value.world_id, value.count))
  })
  let one = @ecs.Schedule().add(system)
  let two = @ecs.Schedule().add(system)
  let merged = @ecs.Schedule::merge([one, two])
  let chain = @ecs.Schedule::chain([merged])
  chain.run(first)
  chain.run(second)
  one.run(first)
  merged.run(first)
  assert_eq(param_preparations, [
    first.id(),
    first.id(),
    second.id(),
    second.id(),
  ])
  assert_eq(observed, [
    (first.id(), 1),
    (first.id(), 1),
    (second.id(), 1),
    (second.id(), 1),
    (first.id(), 2),
    (first.id(), 3),
    (first.id(), 2),
  ])
}

///|
test "injected queries commands and optional resources refresh at execution" {
  let world = @ecs.World()
  let other = @ecs.World()
  let optional_values = []
  let visible = []
  let schedule = @ecs.Schedule().add_system(
    @ecs.args3(fn(
      query : @ecs.Query[@ecs.Single[Position]],
      commands : @ecs.Commands,
      settings : @ecs.Res[SystemSettings]?,
    ) {
      optional_values.push(settings.map(value => value.get().0))
      visible.push(query.length())
      ignore(
        commands.spawn1(Position(settings.map_or(0, value => value.get().0))),
      )
    }),
  )
  schedule.run(world)
  world.insert_resource(SystemSettings(7))
  schedule.run(world)
  world.insert_resource(SystemSettings(9))
  schedule.run(world)
  schedule.run(other)
  assert_eq(optional_values, [None, Some(7), Some(9), None])
  assert_eq(visible, [0, 1, 2, 0])
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  assert_eq(query.length(), 3)
  assert_eq((other.query1() : @ecs.Query[@ecs.Single[Position]]).length(), 1)
}

///|
test "conditions fetch before system parameters and cached resources observe replacement" {
  let world = @ecs.World()
  let values = []
  let condition = @ecs.Condition(
    @ecs.args2(fn(settings : @ecs.Res[SystemSettings]?, _ : Unit) {
      settings is Some(_)
    }),
  )
  let schedule = @ecs.Schedule().add_system(
    fn(settings : @ecs.Res[SystemSettings]) {
      values.push(settings.get().0)
      settings.set(SystemSettings(settings.get().0 + 1))
    },
    run_if=condition,
  )
  schedule.run(world)
  world.insert_resource(SystemSettings(3))
  schedule.run(world)
  schedule.run(world)
  world.insert_resource(SystemSettings(8))
  schedule.run(world)
  assert_eq(values, [3, 4, 8])
  assert_eq((world.resource() : SystemSettings).0, 9)
}

///|
test "chained stages defer one frozen command batch until the final stage" {
  let world = @ecs.World()
  let trace = []
  let visible = []
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let first = @ecs.Schedule().add_system(fn(commands : @ecs.Commands) {
    ignore(commands.spawn1(Position(1)))
    commands.add(_ => {
      trace.push(1)
      commands.add(_ => trace.push(3))
    })
  })
  let second = @ecs.Schedule().add_system(fn(commands : @ecs.Commands) {
    visible.push(query.length())
    commands.add(_ => trace.push(2))
  })
  @ecs.Schedule::chain([first, second]).run(world)
  assert_eq(visible, [0])
  assert_eq(query.length(), 1)
  assert_eq(trace, [1, 2])
  @ecs.Schedule().run(world)
  assert_eq(trace, [1, 2, 3])
}

///|
test "a gated schedule preserves registration state while skipping parameter fetches" {
  param_preparations.clear()
  let world = @ecs.World()
  let enabled = Ref(false)
  let counts = []
  let schedule = @ecs.Schedule().add_system(fn(value : Invocation) {
    counts.push(value.count)
  })
  let gated = schedule.with_run_if(Condition(@ecs.args0(() => enabled.val)))
  gated.run(world)
  assert_true(param_preparations.is_empty())
  enabled.val = true
  gated.run(world)
  schedule.run(world)
  enabled.val = false
  gated.run(world)
  assert_eq(counts, [1, 2])
  assert_eq(param_preparations, [world.id()])
}

///|
test "args adapters inject zero through eight ordinary function parameters" {
  let world = @ecs.World()
  world.insert_resource(SystemSettings(2))
  let values = []
  let schedule = @ecs.Schedule().add_system(@ecs.args0(() => values.push(0)))
  ignore(
    schedule.add_system(
      @ecs.args2(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
      ) {
        values.push(v0.get().0 + v1.get().0)
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args3(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
      ) {
        values.push(v0.get().0 + v1.get().0 + v2.get().0)
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args4(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
        v3 : @ecs.Res[SystemSettings],
      ) {
        values.push(v0.get().0 + v1.get().0 + v2.get().0 + v3.get().0)
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args5(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
        v3 : @ecs.Res[SystemSettings],
        v4 : @ecs.Res[SystemSettings],
      ) {
        values.push(
          v0.get().0 + v1.get().0 + v2.get().0 + v3.get().0 + v4.get().0,
        )
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args6(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
        v3 : @ecs.Res[SystemSettings],
        v4 : @ecs.Res[SystemSettings],
        v5 : @ecs.Res[SystemSettings],
      ) {
        values.push(
          v0.get().0 +
          v1.get().0 +
          v2.get().0 +
          v3.get().0 +
          v4.get().0 +
          v5.get().0,
        )
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args7(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
        v3 : @ecs.Res[SystemSettings],
        v4 : @ecs.Res[SystemSettings],
        v5 : @ecs.Res[SystemSettings],
        v6 : @ecs.Res[SystemSettings],
      ) {
        values.push(
          v0.get().0 +
          v1.get().0 +
          v2.get().0 +
          v3.get().0 +
          v4.get().0 +
          v5.get().0 +
          v6.get().0,
        )
      }),
    ),
  )
  ignore(
    schedule.add_system(
      @ecs.args8(fn(
        v0 : @ecs.Res[SystemSettings],
        v1 : @ecs.Res[SystemSettings],
        v2 : @ecs.Res[SystemSettings],
        v3 : @ecs.Res[SystemSettings],
        v4 : @ecs.Res[SystemSettings],
        v5 : @ecs.Res[SystemSettings],
        v6 : @ecs.Res[SystemSettings],
        v7 : @ecs.Res[SystemSettings],
      ) {
        values.push(
          v0.get().0 +
          v1.get().0 +
          v2.get().0 +
          v3.get().0 +
          v4.get().0 +
          v5.get().0 +
          v6.get().0 +
          v7.get().0,
        )
      }),
    ),
  )
  schedule.run(world)
  world.insert_resource(SystemSettings(3))
  schedule.run(world)
  assert_eq(values, [0, 4, 6, 8, 10, 12, 14, 16, 0, 6, 9, 12, 15, 18, 21, 24])
}

///|
priv struct FastPositions {
  query : @ecs.Query[@ecs.Single[Position]]
}

///|
impl @ecs.SystemParam for FastPositions with fn prepare(world) {
  let with_speed : @ecs.With[Speed] = With(world)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1(filters=[
    with_speed.to_filter(),
  ])
  _ => { query, }
}

///|
test "custom filtered parameters remain World-local and discover later archetypes" {
  let first = @ecs.World()
  let second = @ecs.World()
  ignore(@ecs.commands(first).spawn1(Position(1)))
  @ecs.Schedule().run(first)
  let counts = []
  let schedule = @ecs.Schedule().add_system(fn(positions : FastPositions) {
    counts.push(positions.query.length())
  })
  schedule.run(first)
  ignore(@ecs.commands(first).spawn((Position(2), Speed(3))))
  ignore(@ecs.commands(second).spawn((Position(4), Speed(5))))
  @ecs.Schedule().run(first)
  @ecs.Schedule().run(second)
  schedule.run(second)
  schedule.run(first)
  assert_eq(counts, [0, 1, 1])
}

///|
test "conditions cannot redirect the following system's active World" {
  let world = @ecs.World()
  let other = @ecs.World()
  let observed = []
  let schedule = @ecs.Schedule().add_system(
    @ecs.args0(() => observed.push(@ecs.require_current_world().id())),
    run_if=@ecs.Condition::exclusive(_ => {
      @ecs.set_current_world(other)
      true
    }),
  )
  schedule.run(world)
  assert_eq(observed, [world.id()])
}
