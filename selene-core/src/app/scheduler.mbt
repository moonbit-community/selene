///|
priv struct RegisteredSystem {
  stage : Stage
  execution : @ecs.Schedule
}

///|
fn App::register(
  self : App,
  stage : Stage,
  system : @ecs.System,
  system_name? : String,
  in_set? : @ecs.SystemSet,
  before~ : Array[@ecs.SystemSet] = [],
  after~ : Array[@ecs.SystemSet] = [],
  run_if? : @ecs.Condition,
) -> App {
  let execution = @ecs.Schedule().add(
    system,
    system_name=system_name.unwrap_or("unnamed_system\{self.systems.length()}"),
    in_set?,
    before~,
    after~,
    run_if?,
  )
  self.systems.push({ stage, execution, })
  self
}

///|
pub fn[P : @ecs.SystemParam] App::add_system(
  self : App,
  stage : Stage,
  run : (P) -> Unit,
  system_name? : String,
  in_set? : @ecs.SystemSet,
  before~ : Array[@ecs.SystemSet] = [],
  after~ : Array[@ecs.SystemSet] = [],
  run_if? : @ecs.Condition,
) -> App {
  self.register(
    stage,
    System(run),
    system_name?,
    in_set?,
    before~,
    after~,
    run_if?,
  )
}

///|
pub fn App::add_exclusive_system(
  self : App,
  stage : Stage,
  run : (@ecs.World) -> Unit,
  system_name? : String,
  in_set? : @ecs.SystemSet,
  before~ : Array[@ecs.SystemSet] = [],
  after~ : Array[@ecs.SystemSet] = [],
  run_if? : @ecs.Condition,
) -> App {
  self.register(
    stage,
    @ecs.System::exclusive(run),
    system_name?,
    in_set?,
    before~,
    after~,
    run_if?,
  )
}

///|
pub fn App::add_systems(
  self : App,
  stage : Stage,
  systems : Array[@ecs.System],
  in_set? : @ecs.SystemSet,
  before~ : Array[@ecs.SystemSet] = [],
  after~ : Array[@ecs.SystemSet] = [],
  run_if? : @ecs.Condition,
) -> App {
  for system in systems {
    ignore(self.register(stage, system, in_set?, before~, after~, run_if?))
  }
  self
}

///|
fn collect_systems(
  systems : Array[RegisteredSystem],
  deterministic_ordering : Bool,
  matcher : (Stage) -> Bool,
) -> @ecs.Schedule {
  let selected = []
  for system in systems {
    if matcher(system.stage) {
      selected.push(system.execution)
    }
  }
  @ecs.Schedule::merge(selected, deterministic_ordering~)
}
