///|
pub(all) struct EntityFilter {
  predicate : (@entity.Entity) -> Bool
}

///|
pub(all) struct Query[T] {
  world : @ecs.World
  storage : Map[@entity.Entity, T]
}

///|
pub(all) struct With[T] {
  storage : Map[@entity.Entity, T]
}

///|
pub(all) struct Without[T] {
  storage : Map[@entity.Entity, T]
}

///|
pub(all) struct QueryReader[T] {
  mut world_id : UInt32?
  mut entities : @set.Set[@entity.Entity]
  mut entries : Map[@entity.Entity, T]
  mut initialized : Bool
}

///|
pub(all) struct QueryDelta[T] {
  added : Array[(@entity.Entity, T)]
  removed : Array[@entity.Entity]
  changed : Array[(@entity.Entity, T)]
}

///|
pub fn[T] query(
  world : @ecs.World,
  storage : Map[@entity.Entity, T],
) -> Query[T] {
  { world, storage, }
}

///|
pub fn[T] QueryReader::QueryReader() -> QueryReader[T] {
  { world_id: None, entities: Set([]), entries: Map([]), initialized: false, }
}

///|
pub fn[T] QueryReader::reset(self : QueryReader[T]) -> Unit {
  self.world_id = None
  self.entities.clear()
  self.entries.clear()
  self.initialized = false
}

///|
pub fn[T] QueryDelta::empty() -> QueryDelta[T] {
  { added: [], removed: [], changed: [], }
}

///|
/// Reads changes for one World. Switching Worlds starts a fresh snapshot.
pub fn[T : Eq] QueryReader::read(
  self : QueryReader[T],
  world : @ecs.World,
  storage : Map[@entity.Entity, T],
) -> QueryDelta[T] {
  if self.world_id != Some(world.id()) {
    self.reset()
    self.world_id = Some(world.id())
  }
  if !self.initialized {
    self.initialized = true
    let added : Array[(@entity.Entity, T)] = []
    for entity, component in storage {
      guard entity.belongs_to(world) else { continue }
      self.entities.add(entity)
      self.entries.set(entity, component)
      added.push((entity, component))
    }
    return { ..QueryDelta::empty(), added, }
  }

  let added : Array[(@entity.Entity, T)] = []
  let removed : Array[@entity.Entity] = []
  let changed : Array[(@entity.Entity, T)] = []

  for entity, component in storage {
    guard entity.belongs_to(world) else { continue }
    if !self.entities.contains(entity) {
      self.entities.add(entity)
      self.entries.set(entity, component)
      added.push((entity, component))
      continue
    }
    if self.entries.get(entity) is Some(previous) && previous != component {
      self.entries.set(entity, component)
      changed.push((entity, component))
    }
  }

  for entity in self.entities.to_array() {
    if !storage.contains(entity) {
      self.entities.remove(entity)
      self.entries.remove(entity)
      removed.push(entity)
    }
  }

  { added, removed, changed, }
}

///|
pub fn[T] with_component(storage : Map[@entity.Entity, T]) -> With[T] {
  { storage, }
}

///|
pub fn[T] without_component(storage : Map[@entity.Entity, T]) -> Without[T] {
  { storage, }
}

///|
pub fn EntityFilter::passes(
  self : EntityFilter,
  entity : @entity.Entity,
) -> Bool {
  (self.predicate)(entity)
}

///|
pub fn[T] With::to_filter(self : With[T]) -> EntityFilter {
  { predicate: fn(entity) { self.storage.contains(entity) }, }
}

///|
pub fn[T] Without::to_filter(self : Without[T]) -> EntityFilter {
  { predicate: fn(entity) { !self.storage.contains(entity) }, }
}

///|
/// Visits matching entries in storage order without collecting a result array.
/// Queue structural changes for the next flush when visiting entries.
pub fn[T] Query::for_each(
  self : Query[T],
  visit : (@entity.Entity, T) -> Unit,
  require_filters~ : Array[EntityFilter] = [],
  reject_filters~ : Array[EntityFilter] = [],
) -> Unit {
  for entity, component in self.storage {
    guard entity.belongs_to(self.world) else { continue }
    let mut accepted = true
    for filter in require_filters {
      if !filter.passes(entity) {
        accepted = false
        break
      }
    }
    if !accepted {
      continue
    }
    for filter in reject_filters {
      if filter.passes(entity) {
        accepted = false
        break
      }
    }
    if accepted {
      visit(entity, component)
    }
  }
}

///|
pub fn[T] Query::iter(
  self : Query[T],
  require_filters~ : Array[EntityFilter] = [],
  reject_filters~ : Array[EntityFilter] = [],
) -> Array[(@entity.Entity, T)] {
  let output = []
  self.for_each(
    (entity, component) => output.push((entity, component)),
    require_filters~,
    reject_filters~,
  )
  output
}

///|
pub fn[T] Query::single(
  self : Query[T],
  require_filters~ : Array[EntityFilter] = [],
  reject_filters~ : Array[EntityFilter] = [],
) -> (@entity.Entity, T)? {
  let matches = self.iter(require_filters~, reject_filters~)
  if matches.length() == 1 {
    Some(matches[0])
  } else {
    None
  }
}
