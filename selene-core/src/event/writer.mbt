///|
pub(all) struct EventWriter[T] {
  events : Events[T]
}

///|
pub fn[T] EventWriter::EventWriter(events : Events[T]) -> EventWriter[T] {
  { events, }
}

///|
pub fn[T] EventWriter::send(self : EventWriter[T], event : T) -> Unit {
  self.events.send(event)
}

///|
pub fn[T] EventWriter::trigger(
  self : EventWriter[T],
  event : T,
  target? : @ecs.Entity?,
) -> Unit {
  self.events.trigger(event, target.unwrap_or(None))
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
