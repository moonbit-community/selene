///|
#selene.resource
priv struct TimeState {
  mut raw_delta : Double
  mut delta : Double
  mut frame_delta : Double
  mut fixed_delta : Double
  mut elapsed_raw : Double
  mut elapsed : Double
  mut scale : Double
}

///|
fn TimeState::TimeState() -> TimeState {
  {
    raw_delta: 0.0,
    delta: 0.0,
    frame_delta: 0.0,
    fixed_delta: 0.0,
    elapsed_raw: 0.0,
    elapsed: 0.0,
    scale: 1.0,
  }
}

///|
/// Initializes the World's clock if it has not been initialized.
pub fn initialize(world : @ecs.World) -> Unit {
  let state : TimeState? = world.get_resource()
  if state is None {
    world.insert_resource(TimeState())
  }
}

///|
pub fn Time::begin_frame(self : Time, raw_delta : Double) -> Unit {
  let state = self.state
  let safe_raw = @cmp.maximum(0.0, raw_delta)
  let scaled = safe_raw * state.scale
  state.raw_delta = safe_raw
  state.frame_delta = scaled
  state.delta = scaled
  state.elapsed_raw += safe_raw
  state.elapsed += scaled
}

///|
pub fn Time::delta(self : Time) -> Double {
  self.state.delta
}

///|
pub fn Time::frame_delta(self : Time) -> Double {
  self.state.frame_delta
}

///|
pub fn Time::fixed_delta(self : Time) -> Double {
  self.state.fixed_delta
}

///|
pub fn Time::set_delta(self : Time, delta : Double) -> Unit {
  let state = self.state
  state.delta = @cmp.maximum(0.0, delta)
}

///|
pub fn Time::use_frame_delta(self : Time) -> Unit {
  let state = self.state
  state.delta = state.frame_delta
}

///|
pub fn Time::use_fixed_delta(self : Time, delta : Double) -> Unit {
  let state = self.state
  let safe = @cmp.maximum(0.0, delta)
  state.fixed_delta = safe
  state.delta = safe
}

///|
pub fn Time::raw_delta(self : Time) -> Double {
  self.state.raw_delta
}

///|
pub fn Time::elapsed(self : Time) -> Double {
  self.state.elapsed
}

///|
pub fn Time::elapsed_raw(self : Time) -> Double {
  self.state.elapsed_raw
}

///|
pub fn Time::set_scale(self : Time, scale : Double) -> Unit {
  let state = self.state
  state.scale = @cmp.maximum(0.0, scale)
}

///|
pub fn Time::scale(self : Time) -> Double {
  self.state.scale
}

///|
/// The executing World's clock, including the selected frame/fixed delta.
struct Time {
  state : TimeState
}

///|
pub impl @ecs.SystemParam for Time with fn prepare(world) {
  let time = Time(world)
  _ => time
}

///|
pub extend Time with @ecs.SystemParam::{prepare}

///|
/// Binds the clock initialized in this World.
pub fn Time::Time(world : @ecs.World) -> Time {
  let key : @ecs.ResourceKey[TimeState] = @ecs.Resource::resource_key()
  { state: key.get_or_insert_with(world, _ => TimeState()), }
}

///|
pub fn begin_frame(raw_delta : Double) -> Unit {
  Time(@ecs.require_current_world()).begin_frame(raw_delta)
}

///|
pub fn delta() -> Double {
  Time(@ecs.require_current_world()).delta()
}

///|
pub fn frame_delta() -> Double {
  Time(@ecs.require_current_world()).frame_delta()
}

///|
pub fn fixed_delta() -> Double {
  Time(@ecs.require_current_world()).fixed_delta()
}

///|
pub fn set_delta(delta : Double) -> Unit {
  Time(@ecs.require_current_world()).set_delta(delta)
}

///|
pub fn use_frame_delta() -> Unit {
  Time(@ecs.require_current_world()).use_frame_delta()
}

///|
pub fn use_fixed_delta(delta : Double) -> Unit {
  Time(@ecs.require_current_world()).use_fixed_delta(delta)
}

///|
pub fn raw_delta() -> Double {
  Time(@ecs.require_current_world()).raw_delta()
}

///|
pub fn elapsed() -> Double {
  Time(@ecs.require_current_world()).elapsed()
}

///|
pub fn elapsed_raw() -> Double {
  Time(@ecs.require_current_world()).elapsed_raw()
}

///|
pub fn set_scale(scale : Double) -> Unit {
  Time(@ecs.require_current_world()).set_scale(scale)
}

///|
pub fn scale() -> Double {
  Time(@ecs.require_current_world()).scale()
}
