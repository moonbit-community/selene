///|
#derive(Eq, Debug, Hash)
pub(all) struct ObserverHandle(Int32)

///|
pub extend ObserverHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ObserverHandle with Eq::{not_equal, equal}

///|
pub extend ObserverHandle with Hash::{hash, hash_combine}

///|
pub(all) struct Trigger[T] {
  event : T
  target : @ecs.Entity?
}

///|
priv struct EventRecord[T] {
  id : Int32
  event : T
}

///|
priv struct ObserverEntry[T] {
  target : @ecs.Entity?
  callback : (Trigger[T]) -> Unit
}

///|
struct EventWorldStore[T] {
  mut next_event_id : Int32
  mut next_observer_id : Int32
  mut older : Array[EventRecord[T]]
  mut newer : Array[EventRecord[T]]
  observers : Map[ObserverHandle, ObserverEntry[T]]
  observer_queue : Array[Trigger[T]]
}

///|
pub struct Events[T] {
  id : UInt32
  domain : EventDomain
  store_key : @ecs.ResourceKey[EventWorldStore[T]]
  marker : T?
}

///|
fn[T] world_store(
  events : Events[T],
  world~ : @ecs.World = @ecs.require_current_world(),
) -> EventWorldStore[T] {
  events.store_key.get_or_insert_with(world, _ => {
    next_event_id: 0,
    next_observer_id: 0,
    older: [],
    newer: [],
    observers: Map([]),
    observer_queue: [],
  })
}

///|
pub fn[T] Events::Events(domain~ : EventDomain = Frame) -> Events[T] {
  {
    id: allocate_event_bus_id(),
    domain,
    store_key: ResourceKey(),
    marker: None,
  }
}

///|
pub fn[T] Events::register_to_world(
  self : Events[T],
  world : @ecs.World,
) -> Unit {
  let buses = registered_buses_key.get_or_insert_with(world, _ => [])
  for bus in buses {
    if bus.id == self.id {
      return
    }
  }
  let store = world_store(self, world~)
  buses.push({
    id: self.id,
    domain: self.domain,
    update: fn() { update_store(store) },
    dispatch: fn() { dispatch_store(store) },
  })
}

///|
pub fn[T] Events::writer(
  self : Events[T],
  world~ : @ecs.World = @ecs.require_current_world(),
) -> EventWriter[T] {
  EventWriter(self, world~)
}

///|
pub fn[T] Events::read(self : Events[T], reader : EventReader[T]) -> Array[T] {
  reader.read(self)
}

///|
pub fn[T] Events::send(self : Events[T], event : T) -> Unit {
  let store = world_store(self)
  let id = store.next_event_id
  store.next_event_id += 1
  store.newer.push({ id, event, })
}

///|
pub fn[T] Events::trigger(
  self : Events[T],
  event : T,
  target : @ecs.Entity?,
) -> Unit {
  let store = world_store(self)
  self.send(event)
  store.observer_queue.push({ event, target, })
}

///|
pub fn[T] Events::observe_global(
  self : Events[T],
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  let store = world_store(self)
  let handle = ObserverHandle(store.next_observer_id)
  store.next_observer_id += 1
  store.observers.set(handle, { target: None, callback, })
  handle
}

///|
pub fn[T] Events::observe_entity(
  self : Events[T],
  entity : @ecs.Entity,
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  let store = world_store(self)
  let handle = ObserverHandle(store.next_observer_id)
  store.next_observer_id += 1
  store.observers.set(handle, { target: Some(entity), callback, })
  handle
}

///|
pub fn[T] Events::unobserve(self : Events[T], handle : ObserverHandle) -> Unit {
  let store = world_store(self)
  store.observers.remove(handle)
}

///|
pub fn[T] Events::clear(self : Events[T]) -> Unit {
  let store = world_store(self)
  store.older.clear()
  store.newer.clear()
  store.observer_queue.clear()
}

///|
pub fn[T] Events::update(self : Events[T]) -> Unit {
  update_store(world_store(self))
}

///|
fn[T] update_store(store : EventWorldStore[T]) -> Unit {
  store.older = store.newer
  store.newer = []
}

///|
/// Subscription changes made by a callback take effect on the next trigger.
pub fn[T] Events::dispatch_observers(self : Events[T]) -> Unit {
  dispatch_store(world_store(self))
}

///|
fn[T] dispatch_store(store : EventWorldStore[T]) -> Unit {
  for item in store.observer_queue {
    for observer in store.observers.values().collect() {
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
  store.observer_queue.clear()
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
  entity : @ecs.Entity,
  callback : (Trigger[T]) -> Unit,
) -> ObserverHandle {
  events.observe_entity(entity, callback)
}

///|
pub fn[T] unobserve(events : Events[T], handle : ObserverHandle) -> Unit {
  events.unobserve(handle)
}
