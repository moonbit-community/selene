///|
/// Initializes a state in the App's World, preserving an existing value.
pub fn[T : @state.StateType] App::init_state(self : App, initial : T) -> App {
  @state.initialize(self.world, initial)
  self
}

///|
/// Registers a system for transitions into this value, including initial entry.
pub fn[T : @state.StateType] App::add_on_enter(
  self : App,
  value : T,
  system : @ecs.System,
) -> App {
  let condition = @state.in_state(value)
  self.state_validations.push(world => ignore(condition(world)))
  self.state_on_enter.push(world => {
    if @state.is_entering(world, value) {
      system(world)
    }
  })
  self
}

///|
/// Registers a system for transitions out of this value.
pub fn[T : @state.StateType] App::add_on_exit(
  self : App,
  value : T,
  system : @ecs.System,
) -> App {
  let condition = @state.in_state(value)
  self.state_validations.push(world => ignore(condition(world)))
  self.state_on_exit.push(world => {
    if @state.is_exiting(world, value) {
      system(world)
    }
  })
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
    on_exit=world => {
      for system in plan.state_on_exit {
        system(world)
      }
    },
    on_enter=world => {
      for system in plan.state_on_enter {
        system(world)
      }
    },
  )
}
