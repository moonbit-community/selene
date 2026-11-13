///|
struct EventWriter[T] {
  store : EventWorldStore[T]
}

///|
pub fn[T] EventWriter::EventWriter(
  events : Events[T],
  world~ : @ecs.World = @ecs.require_current_world(),
) -> EventWriter[T] {
  { store: world_store(events, world~), }
}

///|
pub fn[T] EventWriter::send(self : EventWriter[T], event : T) -> Unit {
  let store = self.store
  let id = store.next_event_id
  store.next_event_id += 1
  store.newer.push({ id, event, })
}

///|
pub fn[T] EventWriter::trigger(
  self : EventWriter[T],
  event : T,
  target? : @ecs.Entity?,
) -> Unit {
  self.send(event)
  self.store.observer_queue.push({ event, target: target.unwrap_or(None), })
}

///|
pub fn[T] send(events : Events[T], event : T) -> Unit {
  events.send(event)
}

///|
pub fn[T] trigger(
  events : Events[T],
  event : T,
  target? : @ecs.Entity?,
) -> Unit {
  events.trigger(event, target.unwrap_or(None))
}
