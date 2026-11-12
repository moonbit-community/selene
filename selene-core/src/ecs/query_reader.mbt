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
  if self.world_id != Some(query.world_id) {
    self.reset()
    self.world_id = Some(query.world_id)
  }
  let added = []
  let removed = []
  let changed = []

  for entity, component in query {
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
    if !query.contains(entity) {
      self.entries.remove(entity)
      removed.push(entity)
    }
  }
  { added, removed, changed, }
}
