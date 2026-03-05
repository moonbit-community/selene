///|
pub(all) struct EntityFilter {
  predicate : (@entity.Entity) -> Bool
}

///|
pub(all) struct Query[T] {
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
pub(all) struct Snapshot[T] {
  entities : @set.Set[@entity.Entity]
  entries : Map[@entity.Entity, T]
}

///|
pub(all) struct Added[T] {
  snapshot : Snapshot[T]
  storage : Map[@entity.Entity, T]
}

///|
pub(all) struct Removed[T] {
  snapshot : Snapshot[T]
  storage : Map[@entity.Entity, T]
}

///|
pub(all) struct Changed[T] {
  snapshot : Snapshot[T]
  storage : Map[@entity.Entity, T]
}

///|
pub fn[T] query(storage : Map[@entity.Entity, T]) -> Query[T] {
  { storage, }
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
pub fn[T] snapshot_of(storage : Map[@entity.Entity, T]) -> Snapshot[T] {
  let entities = @set.Set::new()
  for entity, _ in storage {
    entities.add(entity)
  }
  { entities, entries: storage.copy() }
}

///|
pub fn[T] added_since(
  snapshot : Snapshot[T],
  storage : Map[@entity.Entity, T],
) -> Added[T] {
  { snapshot, storage }
}

///|
pub fn[T] removed_since(
  snapshot : Snapshot[T],
  storage : Map[@entity.Entity, T],
) -> Removed[T] {
  { snapshot, storage }
}

///|
pub fn[T] changed_since(
  snapshot : Snapshot[T],
  storage : Map[@entity.Entity, T],
) -> Changed[T] {
  { snapshot, storage }
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
  { predicate: fn(entity) { self.storage.contains(entity) } }
}

///|
pub fn[T] Without::to_filter(self : Without[T]) -> EntityFilter {
  { predicate: fn(entity) { !self.storage.contains(entity) } }
}

///|
pub fn[T] Query::iter(
  self : Query[T],
  require_filters? : Array[EntityFilter] = [],
  reject_filters? : Array[EntityFilter] = [],
) -> Array[(@entity.Entity, T)] {
  let output : Array[(@entity.Entity, T)] = []
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
      output.push((entity, component))
    }
  }
  output
}

///|
pub fn[T] Query::single(
  self : Query[T],
  require_filters? : Array[EntityFilter] = [],
  reject_filters? : Array[EntityFilter] = [],
) -> (@entity.Entity, T)? {
  let matches = self.iter(require_filters~, reject_filters~)
  if matches.length() == 1 {
    Some(matches[0])
  } else {
    None
  }
}

///|
pub fn[T] Added::entities(self : Added[T]) -> Array[@entity.Entity] {
  let output : Array[@entity.Entity] = []
  for entity, _ in self.storage {
    if !self.snapshot.entities.contains(entity) {
      output.push(entity)
    }
  }
  output
}

///|
pub fn[T] Removed::entities(self : Removed[T]) -> Array[@entity.Entity] {
  let output : Array[@entity.Entity] = []
  for entity in self.snapshot.entities {
    if !self.storage.contains(entity) {
      output.push(entity)
    }
  }
  output
}

///|
pub fn[T : Eq] Changed::entities(self : Changed[T]) -> Array[@entity.Entity] {
  let output : Array[@entity.Entity] = []
  for entity, component in self.storage {
    match self.snapshot.entries.get(entity) {
      Some(previous) if previous != component => output.push(entity)
      _ => ()
    }
  }
  output
}
