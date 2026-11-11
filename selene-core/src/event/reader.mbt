///|
pub(all) struct EventReader[T] {
  last_seen_by_world : Map[UInt32, Int32]
  marker : T?
}

///|
pub fn[T] EventReader::EventReader() -> EventReader[T] {
  { last_seen_by_world: Map([]), marker: None, }
}

///|
pub fn[T] EventReader::read(
  self : EventReader[T],
  events : Events[T],
) -> Array[T] {
  let world_id = current_world_id()
  let last_seen = self.last_seen_by_world.get(world_id).unwrap_or(-1)
  let store = world_store(events)
  let values : Array[T] = []
  let mut latest_id = last_seen
  for record in store.older {
    if record.id > last_seen {
      values.push(record.event)
      latest_id = record.id
    }
  }
  for record in store.newer {
    if record.id > last_seen {
      values.push(record.event)
      latest_id = record.id
    }
  }
  self.last_seen_by_world.set(world_id, latest_id)
  values
}

///|
pub fn[T] read(reader : EventReader[T], events : Events[T]) -> Array[T] {
  reader.read(events)
}
