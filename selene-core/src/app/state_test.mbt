///|
#derive(Eq, Debug)
enum Phase {
  Menu
  Playing
  Paused
}

///|
let phase_key : @state.StateKey[Phase] = StateKey()

///|
impl @state.StateType for Phase with fn state_key() {
  phase_key
}

///|
#derive(Eq, Debug)
enum Connection {
  Offline
  Online
}

///|
let connection_key : @state.StateKey[Connection] = StateKey()

///|
impl @state.StateType for Connection with fn state_key() {
  connection_key
}

///|
fn phase(world : @ecs.World) -> Phase {
  @state.current(world)
}

///|
fn connection(world : @ecs.World) -> Connection {
  @state.current(world)
}

///|
test "state startup runs after Startup and initial entry is once per World" {
  let world = @ecs.World()
  let trace = []
  let app = @app.App()
    .with_world(world)
    .init_state(Phase::Menu)
    .add_system(Startup, _ => trace.push("startup"))
    .add_on_enter(Phase::Menu, _ => trace.push("menu"))
    .add_on_exit(Phase::Menu, _ => trace.push("exit"))
  app.run_frames(1)
  app.init_state(Phase::Playing).run_frames(1)
  assert_eq(trace, ["startup", "menu", "startup"])
  assert_eq(phase(world), Menu)
}

///|
test "preupdate transitions precede fixed and ordinary updates" {
  let world = @ecs.World()
  let trace = []
  @app.App()
  .with_world(world)
  .init_state(Phase::Menu)
  .add_system(Startup, _ => trace.push("startup"))
  .add_on_enter(Phase::Menu, _ => trace.push("initial"))
  .add_system(First, _ => trace.push("first"))
  .add_system(PreUpdate, world => {
    trace.push("pre")
    @state.set_next(world, Phase::Playing)
    try! assert_eq(phase(world), Menu)
  })
  .add_on_exit(Phase::Menu, world => {
    try! assert_eq(phase(world), Menu)
    trace.push("exit")
  })
  .add_on_enter(Phase::Playing, world => {
    try! assert_eq(phase(world), Playing)
    trace.push("enter")
  })
  .add_system(
    FixedUpdate,
    _ => trace.push("fixed"),
    run_if=@state.in_state(Phase::Playing),
  )
  .add_system(
    Update,
    _ => trace.push("update"),
    run_if=@state.in_state(Phase::Playing),
  )
  .run_frames(1, raw_delta=0.125, fixed_delta_override=Some(0.125))
  assert_eq(trace, [
    "startup", "initial", "first", "pre", "exit", "enter", "fixed", "update",
  ])
}

///|
test "Update requests take effect at the following frame's transition point" {
  let world = @ecs.World()
  let observed = []
  @app.App()
  .with_world(world)
  .init_state(Phase::Menu)
  .add_system(Update, world => {
    observed.push(phase(world))
    @state.set_next(world, Phase::Playing)
  })
  .run_frames(2)
  assert_eq(observed, [Menu, Playing])
}

///|
test "initial enter and enter callbacks cannot recursively apply requests" {
  let world = @ecs.World()
  let observed = []
  @app.App()
  .with_world(world)
  .init_state(Phase::Menu)
  .add_on_enter(Phase::Menu, world => @state.set_next(world, Phase::Playing))
  .add_on_enter(Phase::Playing, world => @state.set_next(world, Phase::Paused))
  .add_system(Update, world => observed.push(phase(world)))
  .run_frames(2)
  assert_eq(observed, [Playing, Paused])
}

///|
test "all exits see old states and all enters see committed states" {
  let world = @ecs.World()
  let trace = []
  let app = @app.App()
    .with_world(world)
    .init_state(Phase::Menu)
    .init_state(Connection::Offline)
    .add_on_exit(Phase::Menu, world => {
      try! assert_eq(connection(world), Offline)
      try! assert_eq(phase(world), Menu)
      trace.push("phase exit")
    })
    .add_on_exit(Connection::Offline, world => {
      try! assert_eq(phase(world), Menu)
      trace.push("connection exit")
    })
    .add_on_enter(Phase::Playing, world => {
      try! assert_eq(connection(world), Online)
      trace.push("phase enter")
    })
    .add_on_enter(Connection::Online, world => {
      try! assert_eq(phase(world), Playing)
      trace.push("connection enter")
    })
  app.run_frames(1)
  @state.set_next(world, Phase::Playing)
  @state.set_next(world, Connection::Online)
  app.run_frames(1)
  assert_eq(trace, [
    "phase exit", "connection exit", "phase enter", "connection enter",
  ])
}

///|
test "exit commands flush before entry and entry commands before Update" {
  let world = @ecs.World()
  let old = world.spawn(())
  let spawned = Ref(None)
  let observed = []
  let app = @app.App()
    .with_world(world)
    .init_state(Phase::Menu)
    .add_on_exit(Phase::Menu, world => {
      @ecs.commands(world).add(_ => ignore(old.delete()))
    })
    .add_on_enter(Phase::Playing, world => {
      try! assert_false(old.is_valid_in(world))
      spawned.val = Some(@ecs.commands(world).spawn(()))
      try! assert_false(spawned.val.unwrap().is_alive())
    })
    .add_system(Update, _ => {
      if spawned.val is Some(entity) {
        observed.push(entity.is_alive())
      }
    })
  app.run_frames(1)
  @state.set_next(world, Phase::Playing)
  app.run_frames(1)
  assert_eq(observed, [true])
}

///|
test "the same condition selects the executing World's state" {
  let first = @ecs.World()
  let second = @ecs.World()
  let condition = @state.in_state(Phase::Playing)
  let observed = []
  let first_app = @app.App()
    .with_world(first)
    .init_state(Phase::Playing)
    .add_system(Update, world => observed.push(world.id()), run_if=condition)
  let second_app = @app.App()
    .with_world(second)
    .init_state(Phase::Menu)
    .add_system(Update, world => observed.push(world.id()), run_if=condition)
  first_app.run_frames(1)
  second_app.run_frames(1)
  assert_eq(observed, [first.id()])
}

///|
test "panic lifecycle registration without state initialization fails" {
  @app.App()
  .with_world(World())
  .add_on_enter(Phase::Playing, _ => ())
  .run_frames(1)
}

///|
test "Startup initialization and requests retain initial entry before transition" {
  let world = @ecs.World()
  let observed = []
  @app.App()
  .with_world(world)
  .add_system(Startup, world => {
    @state.initialize(world, Phase::Menu)
    @state.set_next(world, Phase::Playing)
  })
  .add_on_enter(Phase::Menu, world => observed.push(phase(world)))
  .add_on_enter(Phase::Playing, world => observed.push(phase(world)))
  .run_frames(1)
  assert_eq(observed, [Menu, Playing])
}

///|
test "manual fixed stepping applies transitions before its fixed batch" {
  let world = @ecs.World()
  let observed = []
  let app = @app.App()
    .with_world(world)
    .init_state(Phase::Menu)
    .add_system(FixedUpdate, world => {
      observed.push(phase(world))
      @state.set_next(world, Phase::Paused)
    })
  app.run_frames(1, fixed_delta_override=Some(1.0))
  @state.set_next(world, Phase::Playing)
  app.step_fixed(2)
  assert_eq(observed, [Playing, Playing])
  app.step_fixed(1)
  assert_eq(observed, [Playing, Playing, Paused])
}
