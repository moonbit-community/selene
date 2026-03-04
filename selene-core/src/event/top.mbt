///|
pub(all) enum EventDomain {
  Frame
  Fixed
  Render
} derive(Eq, Show)

///|
pub(all) struct EventReader[T] {
  mut last_seen_id : Int
  marker : T?
}

///|
pub(all) struct EventWriter[T] {
  events : Events[T]
}

///|
pub(all) struct ObserverHandle(Int) derive(Eq, Show, Hash)

///|
pub(all) struct Trigger[T] {
  event : T
  target : @entity.Entity?
}

///|
struct EventRecord[T] {
  id : Int
  event : T
}

///|
struct ObserverEntry[T] {
  target : @entity.Entity?
  callback : (Trigger[T]) -> Unit
}

///|
pub struct Events[T] {
  mut next_event_id : Int
  mut next_observer_id : Int
  domain : EventDomain
  mut older : Array[EventRecord[T]]
  mut newer : Array[EventRecord[T]]
  observers : Map[ObserverHandle, ObserverEntry[T]]
  observer_queue : Array[Trigger[T]]
  marker : T?
}

///|
priv struct RegisteredBus {
  domain : EventDomain
  update : () -> Unit
  dispatch : () -> Unit
}

///|
let registered_buses : Array[RegisteredBus] = []

///|
pub fn[T] EventReader::new() -> EventReader[T] {
  { last_seen_id: -1, marker: None }
}

///|
pub fn[T] EventReader::read(
  self : EventReader[T],
  events : Events[T],
) -> Array[T] {
  let values : Array[T] = []
  let mut latest_id = self.last_seen_id
  for record in events.older {
    if record.id > self.last_seen_id {
      values.push(record.event)
      latest_id = record.id
    }
  }
  for record in events.newer {
    if record.id > self.last_seen_id {
      values.push(record.event)
      latest_id = record.id
    }
  }
  self.last_seen_id = latest_id
  values
}

///|
pub fn[T] EventWriter::new(events : Events[T]) -> EventWriter[T] {
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
  target? : @entity.Entity?,
) -> Unit {
  self.events.trigger(event, target.unwrap_or(None))
}

///|
pub fn[T] Events::new(domain? : EventDomain = EventDomain::Frame) -> Events[T] {
  {
    next_event_id: 0,
    next_observer_id: 0,
    domain,
    older: [],
    newer: [],
    observers: Map::new(),
    observer_queue: [],
    marker: None,
  }
}

///|
pub fn[T] Events::register(self : Events[T]) -> Unit {
  let bus = {
    domain: self.domain,
    update: fn() { self.update() },
    dispatch: fn() { self.dispatch_observers() },
  }
  registered_buses.push(bus)
}

///|
pub fn[T] Events::writer(self : Events[T]) -> EventWriter[T] {
  EventWriter::new(self)
}

///|
pub fn[T] Events::read(self : Events[T], reader : EventReader[T]) -> Array[T] {
  reader.read(self)
}

///|
pub fn[T] Events::send(self : Events[T], event : T) -> Unit {
  let id = self.next_event_id
  self.next_event_id += 1
  self.newer.push({ id, event })
}

///|
pub fn[T] Events::trigger(
  self : Events[T],
  event : T,
  target : @entity.Entity?,
) -> Unit {
  self.send(event)
  self.observer_queue.push({ event, target })
}

///|
pub fn[T] Events::observe_global(
  self : Events[T],
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  let handle = ObserverHandle(self.next_observer_id)
  self.next_observer_id += 1
  self.observers.set(handle, { target: None, callback })
  handle
}

///|
pub fn[T] Events::observe_entity(
  self : Events[T],
  entity : @entity.Entity,
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  let handle = ObserverHandle(self.next_observer_id)
  self.next_observer_id += 1
  self.observers.set(handle, { target: Some(entity), callback })
  handle
}

///|
pub fn[T] Events::unobserve(self : Events[T], handle : ObserverHandle) -> Unit {
  self.observers.remove(handle)
}

///|
pub fn[T] Events::clear(self : Events[T]) -> Unit {
  self.older.clear()
  self.newer.clear()
  self.observer_queue.clear()
}

///|
pub fn[T] Events::update(self : Events[T]) -> Unit {
  self.older = self.newer
  self.newer = []
}

///|
pub fn[T] Events::dispatch_observers(self : Events[T]) -> Unit {
  for item in self.observer_queue {
    for _handle, observer in self.observers {
      let deliver = match observer.target {
        None => true
        Some(entity) =>
          match item.target {
            Some(target) => target == entity
            None => false
          }
      }
      if deliver {
        (observer.callback)(item)
      }
    }
  }
  self.observer_queue.clear()
}

///|
pub fn[T] read(reader : EventReader[T], events : Events[T]) -> Array[T] {
  reader.read(events)
}

///|
pub fn[T] send(events : Events[T], event : T) -> Unit {
  events.send(event)
}

///|
pub fn[T] trigger(
  events : Events[T],
  event : T,
  target? : @entity.Entity?,
) -> Unit {
  events.trigger(event, target.unwrap_or(None))
}

///|
pub fn[T] observe_global(
  events : Events[T],
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  events.observe_global(callback)
}

///|
pub fn[T] observe_entity(
  events : Events[T],
  entity : @entity.Entity,
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  events.observe_entity(entity, callback)
}

///|
pub fn[T] unobserve(events : Events[T], handle : ObserverHandle) -> Unit {
  events.unobserve(handle)
}

///|
fn update_domain(domain : EventDomain) -> Unit {
  for bus in registered_buses {
    if bus.domain == domain {
      (bus.update)()
    }
  }
}

///|
pub fn event_frame_update_system(_delta : Double) -> Unit {
  update_domain(EventDomain::Frame)
}

///|
pub fn event_fixed_update_system(_delta : Double) -> Unit {
  update_domain(EventDomain::Fixed)
}

///|
pub fn event_render_update_system(_delta : Double) -> Unit {
  update_domain(EventDomain::Render)
}

///|
pub fn event_observer_dispatch_system(_delta : Double) -> Unit {
  for bus in registered_buses {
    (bus.dispatch)()
  }
}
