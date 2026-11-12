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
fn update_domain(domain : EventDomain) -> Unit {
  for
    bus in registered_buses_key
    .get_in(@ecs.require_current_world())
    .unwrap_or([]) {
    if bus.domain == domain {
      (bus.update)()
    }
  }
}

///|
pub fn event_frame_update_system(_delta : Double) -> Unit {
  update_domain(Frame)
}

///|
pub fn event_fixed_update_system(_delta : Double) -> Unit {
  update_domain(Fixed)
}

///|
pub fn event_render_update_system(_delta : Double) -> Unit {
  update_domain(Render)
}

///|
pub fn event_observer_dispatch_system(_delta : Double) -> Unit {
  for
    bus in registered_buses_key
    .get_in(@ecs.require_current_world())
    .unwrap_or([]) {
    (bus.dispatch)()
  }
}
