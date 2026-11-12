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
extend Phase with @state.StateType::{set}

///|
fn phase(world : @ecs.World) -> Phase {
  @state.current(world)
}

///|
fn advance(world : @ecs.World) -> Unit raise @ecs.ScheduleError {
  @state_runtime.advance(world, on_exit=Schedule(), on_enter=Schedule())
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
  assert_false(condition_matches(playing, first))
  advance(first)
  assert_true(condition_matches(playing, first))
  assert_false(condition_matches(playing, second))
}

///|
test "static setters request changes only in the scheduled World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let outer = @ecs.World()
  @ecs.set_current_world(outer)
  @state.initialize(first, Phase::Menu)
  @state.initialize(second, Phase::Menu)
  advance(first)
  advance(second)

  @ecs.Schedule().add_exclusive_system(_ => Phase::set(Playing)).run(first)
  @ecs.Schedule().add_exclusive_system(_ => Phase::set(Paused)).run(second)
  assert_eq(@ecs.require_current_world().id(), outer.id())
  assert_eq(phase(first), Menu)
  assert_eq(phase(second), Menu)

  advance(first)
  assert_eq(phase(first), Playing)
  assert_eq(phase(second), Menu)
  advance(second)
  assert_eq(phase(first), Playing)
  assert_eq(phase(second), Paused)
}

///|
test "panic static setter requires an active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  @ecs.clear_current_world()
  Phase::set(Playing)
}

///|
test "initial entry retains pending requests and identical requests do not reenter" {
  let world = @ecs.World()
  let entries = []
  let exits = []
  @state.initialize(world, Phase::Menu)
  @state.set_next(world, Phase::Playing)
  @state_runtime.advance(
    world,
    initial_only=true,
    on_exit=@ecs.Schedule().add_exclusive_system(world => {
      exits.push(phase(world))
    }),
    on_enter=@ecs.Schedule().add_exclusive_system(world => {
      entries.push(phase(world))
    }),
  )
  assert_eq(entries, [Menu])
  assert_true(exits.is_empty())
  @state_runtime.advance(
    world,
    on_exit=@ecs.Schedule().add_exclusive_system(world => {
      exits.push(phase(world))
    }),
    on_enter=@ecs.Schedule().add_exclusive_system(world => {
      entries.push(phase(world))
    }),
  )
  assert_eq(exits, [Menu])
  assert_eq(entries, [Menu, Playing])
  @state.set_next(world, Phase::Playing)
  @state_runtime.advance(
    world,
    on_exit=@ecs.Schedule().add_exclusive_system(_ => {
      abort("same-value request exited")
    }),
    on_enter=@ecs.Schedule().add_exclusive_system(_ => {
      abort("same-value request entered")
    }),
  )
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
  @state_runtime.advance(
    world,
    on_exit=@ecs.Schedule().add_exclusive_system(world => {
      try! assert_eq(phase(world), Menu)
      @state.set_next(world, Phase::Menu)
    }),
    on_enter=@ecs.Schedule().add_exclusive_system(world => {
      try! assert_eq(phase(world), Playing)
      @state.set_next(world, Phase::Paused)
    }),
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
  @state_runtime.advance(
    world,
    on_exit=@ecs.Schedule().add_exclusive_system(world => {
      @ecs.commands(world).add(world => @state.set_next(world, Phase::Paused))
    }),
    on_enter=Schedule(),
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
  @state_runtime.advance(
    world,
    on_exit=Schedule(),
    on_enter=@ecs.Schedule().add_exclusive_system(world => {
      @state.set_next(world, Phase::Playing)
      try advance(world) catch {
        ReentrantSchedule => rejected.val = true
        _ => abort("wrong reentry error")
      } noraise {
        _ => abort("nested transition succeeded")
      }
    }),
  )
  assert_true(rejected.val)
  let store : @ecs.Query[@ecs.Single[QueryMarker]] = world.query()
  ignore(@ecs_test.spawn1(world, QueryMarker::{ }))
  store.batches(_ => {
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
struct QueryMarker {}

///|
let marker_key : @ecs.ComponentKey[QueryMarker] = ComponentKey()

///|
impl @ecs.Component for QueryMarker with fn component_key() {
  marker_key
}

///|
fn condition_matches(
  condition : @ecs.Condition,
  world : @ecs.World,
) -> Bool raise @ecs.ScheduleError {
  let matched = Ref(false)
  @ecs.Schedule()
  .add_system(fn(_ : Unit) { matched.val = true }, run_if=condition)
  .run(world)
  matched.val
}
