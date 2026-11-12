///|
pub(all) struct EntityFilter {
  predicate : (Entity) -> Bool
}

///|
// Retain the columns rather than the World, so caching a Query in its World
// does not create an owning reference cycle.
struct Query[T] {
  storage : ComponentStore[T]
}

///|
struct With[T] {
  storage : ComponentStore[T]
}

///|
struct Without[T] {
  storage : ComponentStore[T]
}

///|
struct QueryReader[T] {
  mut world_id : UInt32?
  // Historical values for change detection, separate from live components.
  entries : Map[Entity, T]
}

///|
pub(all) struct QueryDelta[T] {
  added : Array[(Entity, T)]
  removed : Array[Entity]
  changed : Array[(Entity, T)]
}

///|
pub fn[T : Component] World::query(self : World) -> Query[T] {
  { storage: components_in(self), }
}

///|
pub fn[T] QueryReader::QueryReader() -> QueryReader[T] {
  { world_id: None, entries: Map([]), }
}

///|
pub fn[T] QueryReader::reset(self : QueryReader[T]) -> Unit {
  self.world_id = None
  self.entries.clear()
}

///|
pub fn[T] QueryDelta::empty() -> QueryDelta[T] {
  { added: [], removed: [], changed: [], }
}

///|
/// Reads changes for one World. Switching Worlds starts a fresh snapshot.
pub fn[T : Eq] QueryReader::read(
  self : QueryReader[T],
  query : Query[T],
) -> QueryDelta[T] {
  let storage = query.storage
  if self.world_id != Some(storage.world_id) {
    self.reset()
    self.world_id = Some(storage.world_id)
  }
  let added = []
  let removed = []
  let changed = []

  for entity, component in storage {
    match self.entries.get(entity) {
      None => {
        self.entries.set(entity, component)
        added.push((entity, component))
      }
      Some(previous) if previous != component => {
        self.entries.set(entity, component)
        changed.push((entity, component))
      }
      Some(_) => ()
    }
  }

  for entity in self.entries.keys().collect() {
    if !storage.contains(entity) {
      self.entries.remove(entity)
      removed.push(entity)
    }
  }
  { added, removed, changed, }
}

///|
pub fn[T : Component] With::With(world : World) -> With[T] {
  { storage: components_in(world), }
}

///|
pub fn[T : Component] Without::Without(world : World) -> Without[T] {
  { storage: components_in(world), }
}

///|
pub fn EntityFilter::passes(self : EntityFilter, entity : Entity) -> Bool {
  (self.predicate)(entity)
}

///|
pub fn[T] With::to_filter(self : With[T]) -> EntityFilter {
  { predicate: fn(entity) { self.storage.contains(entity) }, }
}

///|
pub fn[T] Without::to_filter(self : Without[T]) -> EntityFilter {
  {
    predicate: fn(entity) {
      self.storage.world_id == entity.world_id && !self.storage.contains(entity)
    },
  }
}

///|
/// Visits matching entries in storage order without collecting a result array.
/// Queue structural changes for the next flush when visiting entries.
pub fn[T] Query::for_each(
  self : Query[T],
  visit : (Entity, T) -> Unit,
  require_filters~ : Array[EntityFilter] = [],
  reject_filters~ : Array[EntityFilter] = [],
) -> Unit {
  enter_query()
  self.storage.storage.active_queries += 1
  defer {
    self.storage.storage.active_queries -= 1
    leave_query()
  }
  for entity, component in self.storage {
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
) -> Array[(Entity, T)] {
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
) -> (Entity, T)? {
  let matches = self.iter(require_filters~, reject_filters~)
  if matches.length() == 1 {
    Some(matches[0])
  } else {
    None
  }
}

///|
pub fn[T] Query::get(self : Query[T], entity : Entity) -> T? {
  self.storage.get(entity)
}

///|
pub fn[T] Query::contains(self : Query[T], entity : Entity) -> Bool {
  self.storage.contains(entity)
}

///|
pub fn[T] Query::length(self : Query[T]) -> Int32 {
  self.storage.length()
}

///|
pub fn[T] Query::is_empty(self : Query[T]) -> Bool {
  self.storage.is_empty()
}

///|
/// Iterates in insertion order. Keep structural changes deferred until traversal ends.
pub fn[T] Query::iter2(self : Query[T]) -> Iter2[Entity, T] {
  self.storage.iter2()
}

///|
pub fn[T] Query::keys(self : Query[T]) -> Iter[Entity] {
  self.storage.keys()
}

///|
pub fn[T] Query::values(self : Query[T]) -> Iter[T] {
  self.storage.values()
}

///|
pub fn[T] Query::to_array(self : Query[T]) -> Array[(Entity, T)] {
  self.storage.to_array()
}

///|
pub fn[T] Query::insertion_order(self : Query[T], entity : Entity) -> Int32 {
  self.storage.insertion_order(entity)
}

///|
pub fn[T] Query::order_span(self : Query[T]) -> Int32 {
  self.storage.order_span()
}
