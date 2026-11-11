///|
pub(all) struct EventReader[T] {
  last_seen_key : @ecs.ResourceKey[Int32]
  marker : T?
}

///|
pub fn[T] EventReader::EventReader() -> EventReader[T] {
  { last_seen_key: ResourceKey(), marker: None, }
}

///|
pub fn[T] EventReader::read(
  self : EventReader[T],
  events : Events[T],
) -> Array[T] {
  let world = @ecs.require_current_world()
  let last_seen = self.last_seen_key.get_in(world).unwrap_or(-1)
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
  self.last_seen_key.insert_in(world, latest_id)
  values
}

///|
pub fn[T] read(reader : EventReader[T], events : Events[T]) -> Array[T] {
  reader.read(events)
}
