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
fn phase(world : @ecs.World) -> Phase {
  @state.current(world)
}

///|
fn advance(world : @ecs.World) -> Unit raise @ecs.ScheduleError {
  @state.advance(world, on_exit=_ => (), on_enter=_ => ())
}

///|
test "state identity is shared while values and requests are World-local" {
  let first = @ecs.World()
  let second = @ecs.World()
  let playing = @state.in_state(Phase::Playing)
  @state.initialize(first, Phase::Menu)
  @state.initialize(second, Phase::Paused)
  advance(first)
  advance(second)
  @state.set_next(first, Phase::Playing)
  @state.initialize(first, Phase::Paused)
  assert_eq(phase(first), Menu)
  advance(second)
  assert_eq(phase(first), Menu)
  assert_eq(phase(second), Paused)
  assert_false(playing(first))
  advance(first)
  assert_true(playing(first))
  assert_false(playing(second))
}

///|
test "initial entry retains pending requests and identical requests do not reenter" {
  let world = @ecs.World()
  let entries = []
  let exits = []
  @state.initialize(world, Phase::Menu)
  @state.set_next(world, Phase::Playing)
  @state.advance(
    world,
    initial_only=true,
    on_exit=world => exits.push(phase(world)),
    on_enter=world => entries.push(phase(world)),
  )
  assert_eq(entries, [Menu])
  assert_true(exits.is_empty())
  @state.advance(world, on_exit=world => exits.push(phase(world)), on_enter=world => {
    entries.push(phase(world))
  })
  assert_eq(exits, [Menu])
  assert_eq(entries, [Menu, Playing])
  @state.set_next(world, Phase::Playing)
  @state.advance(world, on_exit=_ => abort("same-value request exited"), on_enter=_ => {
    abort("same-value request entered")
  })
  assert_false(@state.is_entering(world, Phase::Playing))
  assert_false(@state.is_exiting(world, Phase::Menu))
}

///|
test "last request wins and lifecycle requests wait for another advance" {
  let world = @ecs.World()
  @state.initialize(world, Phase::Menu)
  advance(world)
  @state.set_next(world, Phase::Paused)
  @state.set_next(world, Phase::Playing)
  @state.advance(
    world,
    on_exit=world => {
      try! assert_eq(phase(world), Menu)
      @state.set_next(world, Phase::Menu)
    },
    on_enter=world => {
      try! assert_eq(phase(world), Playing)
      @state.set_next(world, Phase::Paused)
    },
  )
  assert_eq(phase(world), Playing)
  advance(world)
  assert_eq(phase(world), Paused)
}

///|
test "exit command requests survive commit and apply at the next transition" {
  let world = @ecs.World()
  @state.initialize(world, Phase::Menu)
  advance(world)
  @state.set_next(world, Phase::Playing)
  @state.advance(
    world,
    on_exit=world => {
      @ecs.commands(world).add(world => @state.set_next(world, Phase::Paused))
    },
    on_enter=_ => (),
  )
  assert_eq(phase(world), Playing)
  advance(world)
  assert_eq(phase(world), Paused)
}

///|
test "transition execution rejects reentry and query-time execution" {
  let world = @ecs.World()
  @state.initialize(world, Phase::Menu)
  let rejected = Ref(false)
  @state.advance(world, on_exit=_ => (), on_enter=world => {
    @state.set_next(world, Phase::Playing)
    try advance(world) catch {
      ReentrantSchedule => rejected.val = true
      _ => abort("wrong reentry error")
    } noraise {
      _ => abort("nested transition succeeded")
    }
  })
  assert_true(rejected.val)
  let store : @ecs.ComponentStore[Int32] = ComponentStore(world)
  ignore(store.spawn_plan(world).spawn(1))
  @ecs.query(world, store).for_each((_, _) => {
    try advance(world) catch {
      ActiveQuery => ()
      _ => abort("wrong query-time error")
    } noraise {
      _ => abort("transition ran during a query")
    }
  })
  assert_eq(phase(world), Menu)
  advance(world)
  assert_eq(phase(world), Playing)
}

///|
test "panic reading an uninitialized state fails" {
  ignore(phase(World()))
}

///|
test "panic requesting an uninitialized state fails" {
  @state.set_next(World(), Phase::Playing)
}

///|
test "panic testing an uninitialized state fails" {
  ignore(@state.in_state(Phase::Playing)(World()))
}
