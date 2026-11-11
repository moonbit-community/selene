///|
pub type RunCondition = (@ecs.World) -> Bool

///|
pub(all) struct RegisteredSystem {
  system : @ecs.System
  schedule : Schedule
  name : String
  in_set : SystemSet?
  before : Array[SystemSet]
  after : Array[SystemSet]
  run_if : RunCondition?
}

///|
pub fn App::add_system(
  self : App,
  schedule : Schedule,
  system : @ecs.System,
  system_name? : String,
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : RunCondition,
) -> App {
  let system_name = system_name.unwrap_or(
    "unnamed_system\{self.systems.length()}",
  )
  let systems = self.systems
  systems.push({
    system,
    schedule,
    name: system_name,
    in_set,
    before,
    after,
    run_if,
  })
  { ..self, systems, }
}

///|
pub fn App::add_systems(
  self : App,
  schedule : Schedule,
  systems_to_add : Array[@ecs.System],
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : RunCondition,
) -> App {
  let systems = self.systems
  for system in systems_to_add {
    let name = "unnamed_system\{systems.length()}"
    systems.push({ system, schedule, name, in_set, before, after, run_if, })
  }
  { ..self, systems, }
}

///|
fn set_key(
  system : RegisteredSystem,
  index : Int32,
  deterministic_ordering : Bool,
) -> String {
  match system.in_set {
    Some(set) => set.name
    None =>
      if deterministic_ordering {
        "__system_\{system.name}_\{index}"
      } else {
        "__system_\{index}"
      }
  }
}

///|
fn sort_systems_by_set(
  systems : Array[RegisteredSystem],
  deterministic_ordering : Bool,
) -> Array[RegisteredSystem] {
  if systems.length() <= 1 {
    return systems
  }

  let group_members : Map[String, Array[RegisteredSystem]] = Map([])
  let group_order : Map[String, Int32] = Map([])
  let group_keys : Array[String] = []

  for index, system in systems {
    let key = set_key(system, index, deterministic_ordering)
    if !group_members.contains(key) {
      group_members.set(key, [])
      group_order.set(key, index)
      group_keys.push(key)
    }
    let members = group_members.get(key).unwrap_or([])
    members.push(system)
    group_members.set(key, members)
  }

  let outgoing : Map[String, @set.Set[String]] = Map([])
  let indegree : Map[String, Int32] = Map([])
  for key in group_keys {
    outgoing.set(key, Set([]))
    indegree.set(key, 0)
  }

  fn add_edge(
    from : String,
    to : String,
    outgoing : Map[String, @set.Set[String]],
    indegree : Map[String, Int32],
  ) -> Unit {
    if from == to {
      return
    }
    if !outgoing.contains(from) || !outgoing.contains(to) {
      return
    }
    guard outgoing.get(from) is Some(edges) else { return }
    if edges.contains(to) {
      return
    }
    edges.add(to)
    indegree.set(to, indegree.get(to).unwrap_or(0) + 1)
  }

  for index, system in systems {
    let current_key = set_key(system, index, deterministic_ordering)
    for target in system.before {
      add_edge(current_key, target.name, outgoing, indegree)
    }
    for source in system.after {
      add_edge(source.name, current_key, outgoing, indegree)
    }
  }

  let sorted_candidates = group_keys.copy()
  if deterministic_ordering {
    sorted_candidates.sort_by(fn(lhs, rhs) {
      if lhs < rhs {
        -1
      } else if lhs > rhs {
        1
      } else {
        0
      }
    })
  } else {
    sorted_candidates.sort_by(fn(lhs, rhs) {
      group_order.get(lhs).unwrap_or(0) - group_order.get(rhs).unwrap_or(0)
    })
  }

  let processed : @set.Set[String] = Set([])
  let sorted_keys : Array[String] = []
  while processed.to_array().length() < group_keys.length() {
    let mut progressed = false
    for key in sorted_candidates {
      if processed.contains(key) {
        continue
      }
      if indegree.get(key).unwrap_or(0) != 0 {
        continue
      }
      progressed = true
      processed.add(key)
      sorted_keys.push(key)
      for target in outgoing.get(key).unwrap_or(Set([])) {
        let degree = indegree.get(target).unwrap_or(0)
        indegree.set(target, @cmp.maximum(0, degree - 1))
      }
    }
    if progressed {
      continue
    }
    for key in sorted_candidates {
      if !processed.contains(key) {
        processed.add(key)
        sorted_keys.push(key)
      }
    }
  }

  let ordered : Array[RegisteredSystem] = []
  for key in sorted_keys {
    let members = group_members.get(key).unwrap_or([])
    if deterministic_ordering {
      members.sort_by(fn(lhs, rhs) {
        if lhs.name < rhs.name {
          -1
        } else if lhs.name > rhs.name {
          1
        } else {
          0
        }
      })
    }
    for system in members {
      ordered.push(system)
    }
  }
  ordered
}

///|
fn collect_systems(
  systems : Array[RegisteredSystem],
  deterministic_ordering : Bool,
  matcher : (Schedule) -> Bool,
) -> Array[RegisteredSystem] {
  let selected : Array[RegisteredSystem] = []
  for system in systems {
    if matcher(system.schedule) {
      selected.push(system)
    }
  }
  sort_systems_by_set(selected, deterministic_ordering)
}

///|
fn should_run(system : RegisteredSystem, world : @ecs.World) -> Bool {
  let schedule_allows = match system.schedule {
    OnEnter(condition) => condition()
    OnExit(condition) => condition()
    _ => true
  }
  if !schedule_allows {
    return false
  }
  match system.run_if {
    Some(condition) => condition(world)
    None => true
  }
}

///|
fn run_stage(systems : Array[RegisteredSystem], world : @ecs.World) -> Unit {
  @ecs.set_current_world(world)
  for system in systems {
    if should_run(system, world) {
      (system.system)(world)
    }
  }
}
