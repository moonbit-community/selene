///|
#derive(Eq, Debug)
pub(all) enum EventDomain {
  Frame
  Fixed
  Render
}

///|
pub extend EventDomain with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EventDomain with Eq::{not_equal, equal}

///|
priv struct RegisteredBus {
  id : UInt32
  domain : EventDomain
  update : () -> Unit
  dispatch : () -> Unit
}

///|
let registered_buses_key : @ecs.ResourceKey[Array[RegisteredBus]] = ResourceKey()

///|
let next_event_bus_id : Ref[UInt32] = { val: 1U, }

///|
fn allocate_event_bus_id() -> UInt32 {
  let id = next_event_bus_id.val
  next_event_bus_id.val += 1U
  id
}

///|
fn update_domain(events : EventRegistry, domain : EventDomain) -> Unit {
  for bus in events.buses {
    if bus.domain == domain {
      (bus.update)()
    }
  }
}

///|
pub fn event_frame_update_system(events : EventRegistry) -> Unit {
  update_domain(events, Frame)
}

///|
pub fn event_fixed_update_system(events : EventRegistry) -> Unit {
  update_domain(events, Fixed)
}

///|
pub fn event_render_update_system(events : EventRegistry) -> Unit {
  update_domain(events, Render)
}

///|
pub fn event_observer_dispatch_system(events : EventRegistry) -> Unit {
  for bus in events.buses {
    (bus.dispatch)()
  }
}

///|
struct EventRegistry {
  buses : Array[RegisteredBus]
}

///|
pub fn EventRegistry::EventRegistry(world : @ecs.World) -> EventRegistry {
  { buses: registered_buses_key.get_or_insert_with(world, _ => []), }
}

///|
pub impl @ecs.SystemParam for EventRegistry with fn prepare(world) {
  let value = EventRegistry(world)
  _ => value
}

///|
pub extend EventRegistry with @ecs.SystemParam::{prepare}
