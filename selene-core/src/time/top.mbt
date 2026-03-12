///|
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
let time_world_states : Map[UInt, TimeState] = Map::new()

///|
fn time_state() -> TimeState {
  let world_id = @ecs.require_current_world().id()
  time_world_states.get_or_init(world_id, () => {
    raw_delta: 0.0,
    delta: 0.0,
    frame_delta: 0.0,
    fixed_delta: 0.0,
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
  let scaled = safe_raw * state.scale
  state.raw_delta = safe_raw
  state.frame_delta = scaled
  state.delta = scaled
  state.elapsed_raw += safe_raw
  state.elapsed += scaled
}

///|
pub fn delta() -> Double {
  time_state().delta
}

///|
pub fn frame_delta() -> Double {
  time_state().frame_delta
}

///|
pub fn fixed_delta() -> Double {
  time_state().fixed_delta
}

///|
pub fn set_delta(delta : Double) -> Unit {
  let state = time_state()
  state.delta = non_negative(delta)
}

///|
pub fn use_frame_delta() -> Unit {
  let state = time_state()
  state.delta = state.frame_delta
}

///|
pub fn use_fixed_delta(delta : Double) -> Unit {
  let state = time_state()
  let safe = non_negative(delta)
  state.fixed_delta = safe
  state.delta = safe
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
