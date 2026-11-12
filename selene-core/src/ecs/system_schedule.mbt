///|
priv struct RegisteredSystem {
  run : (World) -> Unit
  name : String
  in_set : SystemSet?
  before : Array[SystemSet]
  after : Array[SystemSet]
  conditions : Array[(World) -> Bool]
}

///|
priv struct ScheduleGroup {
  systems : Array[RegisteredSystem]
  deterministic_ordering : Bool
  mut ordered : Array[RegisteredSystem]?
}

///|
/// A reusable execution plan. Only run applies deferred structural changes.
struct Schedule {
  groups : Array[ScheduleGroup]
}

///|
pub fn Schedule::Schedule(deterministic_ordering~ : Bool = false) -> Schedule {
  { groups: [{ systems: [], deterministic_ordering, ordered: None, }], }
}

///|
/// Takes a configuration snapshot, preserving each registration's parameter state.
/// Groups run in order without intermediate command application.
pub fn Schedule::chain(schedules : Array[Schedule]) -> Schedule {
  let groups = []
  for schedule in schedules {
    for group in schedule.groups {
      groups.push({
        systems: group.systems.copy(),
        deterministic_ordering: group.deterministic_ordering,
        ordered: group.ordered,
      })
    }
  }
  { groups, }
}

///|
pub fn Schedule::add(
  self : Schedule,
  system : System,
  system_name? : String,
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : Condition,
) -> Schedule {
  if self.groups.is_empty() {
    self.groups.push({
      systems: [],
      deterministic_ordering: false,
      ordered: None,
    })
  }
  let group = self.groups[self.groups.length() - 1]
  group.systems.push({
    name: system_name.unwrap_or("unnamed_system\{group.systems.length()}"),
    in_set,
    before: before.copy(),
    after: after.copy(),
    run: (system.bind)(),
    conditions: run_if.map_or([], condition => [(condition.bind)()]),
  })
  group.ordered = None
  self
}

///|
pub fn[P : SystemParam] Schedule::add_system(
  self : Schedule,
  run : (P) -> Unit,
  system_name? : String,
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : Condition,
) -> Schedule {
  self.add(System(run), system_name?, in_set?, before~, after~, run_if?)
}

///|
pub fn Schedule::add_exclusive_system(
  self : Schedule,
  run : (World) -> Unit,
  system_name? : String,
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : Condition,
) -> Schedule {
  self.add(
    System::exclusive(run),
    system_name?,
    in_set?,
    before~,
    after~,
    run_if?,
  )
}

///|
pub fn Schedule::add_systems(
  self : Schedule,
  systems : Array[System],
  in_set? : SystemSet,
  before~ : Array[SystemSet] = [],
  after~ : Array[SystemSet] = [],
  run_if? : Condition,
) -> Schedule {
  for system in systems {
    ignore(self.add(system, in_set?, before~, after~, run_if?))
  }
  self
}

///|
pub fn Schedule::run(
  self : Schedule,
  world : World,
) -> Unit raise ScheduleError {
  run_schedule(world, world => {
    for group in self.groups {
      let ordered = match group.ordered {
        Some(ordered) => ordered
        None => {
          let ordered = sort_systems_by_set(
            group.systems,
            group.deterministic_ordering,
          )
          group.ordered = Some(ordered)
          ordered
        }
      }
      for system in ordered {
        set_current_world(world)
        let mut enabled = true
        for condition in system.conditions {
          set_current_world(world)
          let matches = condition(world)
          if !matches {
            enabled = false
            break
          }
        }
        if !enabled {
          continue
        }
        set_current_world(world)
        (system.run)(world)
      }
    }
  })
}

///|
/// Combines registrations into one ordering group while preserving their state.
pub fn Schedule::merge(
  schedules : Array[Schedule],
  deterministic_ordering~ : Bool = false,
) -> Schedule {
  let systems = []
  for schedule in schedules {
    for group in schedule.groups {
      systems.append(group.systems[:])
    }
  }
  { groups: [{ systems, deterministic_ordering, ordered: None, }], }
}

///|
/// Adds a condition to each registration without recreating its parameter state.
pub fn Schedule::with_run_if(
  self : Schedule,
  condition : Condition,
) -> Schedule {
  let groups = []
  for group in self.groups {
    let systems = group.systems.map(system => {
      let conditions = [(condition.bind)()]
      conditions.append(system.conditions[:])
      { ..system, conditions, }
    })
    groups.push({
      systems,
      deterministic_ordering: group.deterministic_ordering,
      ordered: None,
    })
  }
  { groups, }
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
    return systems.copy()
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
  while processed.length() < group_keys.length() {
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
        indegree.set(target, degree - 1)
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
