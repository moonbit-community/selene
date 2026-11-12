///|
/// Initializes a state in the App's World, preserving an existing value.
pub fn[T : @state.StateType] App::init_state(self : App, initial : T) -> App {
  @state.initialize(self.world, initial)
  self
}

///|
/// Registers a typed system for entry, including the initial entry.
pub fn[T : @state.StateType, P : @ecs.SystemParam] App::add_on_enter(
  self : App,
  value : T,
  run : (P) -> Unit,
) -> App {
  self.state_validations.push(world => ignore(@state.is_entering(world, value)))
  let condition = @ecs.Condition(fn(state : @state.State[T]) {
    state.is_entering(value)
  })
  ignore(self.state_on_enter.add_system(run, run_if=condition))
  self
}

///|
/// Registers a typed system for transitions out of this value.
pub fn[T : @state.StateType, P : @ecs.SystemParam] App::add_on_exit(
  self : App,
  value : T,
  run : (P) -> Unit,
) -> App {
  self.state_validations.push(world => ignore(@state.is_exiting(world, value)))
  let condition = @ecs.Condition(fn(state : @state.State[T]) {
    state.is_exiting(value)
  })
  ignore(self.state_on_exit.add_system(run, run_if=condition))
  self
}

///|
fn run_state_transitions(
  plan : RuntimePlan,
  initial_only~ : Bool = false,
) -> Unit {
  try! @state_runtime.advance(
    plan.world,
    initial_only~,
    on_exit=plan.state_on_exit,
    on_enter=plan.state_on_enter,
  )
}

///|
pub fn[T : @state.StateType] App::add_exclusive_on_enter(
  self : App,
  value : T,
  run : (@ecs.World) -> Unit,
) -> App {
  self.state_validations.push(world => ignore(@state.is_entering(world, value)))
  let condition = @ecs.Condition(fn(state : @state.State[T]) {
    state.is_entering(value)
  })
  ignore(self.state_on_enter.add_exclusive_system(run, run_if=condition))
  self
}

///|
pub fn[T : @state.StateType] App::add_exclusive_on_exit(
  self : App,
  value : T,
  run : (@ecs.World) -> Unit,
) -> App {
  self.state_validations.push(world => ignore(@state.is_exiting(world, value)))
  let condition = @ecs.Condition(fn(state : @state.State[T]) {
    state.is_exiting(value)
  })
  ignore(self.state_on_exit.add_exclusive_system(run, run_if=condition))
  self
}
