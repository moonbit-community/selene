///|
pub(all) struct EventReader[T] {
  last_seen_key : @ecs.ResourceKey[Ref[Int32]]
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
  self.bind(@ecs.require_current_world(), events).read()
}

///|
/// A reader cursor and event queue bound to one World.
struct EventReaderView[T] {
  cursor : Ref[Int32]
  store : EventWorldStore[T]
}

///|
pub fn[T] EventReader::bind(
  self : EventReader[T],
  world : @ecs.World,
  events : Events[T],
) -> EventReaderView[T] {
  {
    cursor: self.last_seen_key.get_or_insert_with(world, _ => Ref(-1)),
    store: world_store(events, world~),
  }
}

///|
pub fn[T] EventReaderView::read(self : EventReaderView[T]) -> Array[T] {
  let last_seen = self.cursor.val
  let store = self.store
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
  self.cursor.val = latest_id
  values
}

///|
pub fn[T] read(reader : EventReader[T], events : Events[T]) -> Array[T] {
  reader.read(events)
}
