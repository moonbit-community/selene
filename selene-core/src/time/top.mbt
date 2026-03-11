///|
priv struct TimeState {
  mut raw_delta : Double
  mut delta : Double
  mut elapsed_raw : Double
  mut elapsed : Double
  mut scale : Double
}

///|
let time_world_states : Map[UInt, TimeState] = Map::new()

///|
fn time_state() -> TimeState {
  let world_id = @ecs.require_current_world().id()
  time_world_states.get_or_init(world_id, () => {
    raw_delta: 0.0,
    delta: 0.0,
    elapsed_raw: 0.0,
    elapsed: 0.0,
    scale: 1.0,
  })
}

///|
fn non_negative(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else {
    value
  }
}

///|
pub fn begin_frame(raw_delta : Double) -> Unit {
  let state = time_state()
  let safe_raw = non_negative(raw_delta)
  state.raw_delta = safe_raw
  state.delta = safe_raw * state.scale
  state.elapsed_raw += safe_raw
  state.elapsed += state.delta
}

///|
pub fn delta() -> Double {
  time_state().delta
}

///|
pub fn raw_delta() -> Double {
  time_state().raw_delta
}

///|
pub fn elapsed() -> Double {
  time_state().elapsed
}

///|
pub fn elapsed_raw() -> Double {
  time_state().elapsed_raw
}

///|
pub fn set_scale(scale : Double) -> Unit {
  let state = time_state()
  state.scale = @cmp.maximum(0.0, scale)
}

///|
pub fn scale() -> Double {
  time_state().scale
}
