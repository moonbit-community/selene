///|
pub(all) struct FramePerformanceMetrics {
  frame_index : UInt32
  fixed_step_index : UInt32
  fixed_steps_this_frame : Int32
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int32
  draw2d_count : Int32
  draw3d_count : Int32
}

///|
let frame_metrics_key : @ecs.ResourceKey[FramePerformanceMetrics] = ResourceKey()

///|
let frame_metrics_history_key : @ecs.ResourceKey[Array[FramePerformanceMetrics]] = ResourceKey()

///|
fn FramePerformanceMetrics::FramePerformanceMetrics(
  world : @ecs.World,
) -> FramePerformanceMetrics {
  {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    fixed_steps_this_frame: 0,
    update_delta: 0.0,
    fixed_delta_total: 0.0,
    render_delta: 0.0,
    entity_count: 0,
    draw2d_count: 0,
    draw3d_count: 0,
  }
}

///|
fn ensure_metrics() -> FramePerformanceMetrics {
  let world = current_world()
  frame_metrics_key.get_or_insert_with(world, _ => {
    FramePerformanceMetrics(world)
  })
}

///|
pub fn begin_frame_metrics() -> Unit {
  let world = current_world()
  frame_metrics_key.insert_in(world, {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    fixed_steps_this_frame: 0,
    update_delta: 0.0,
    fixed_delta_total: 0.0,
    render_delta: 0.0,
    entity_count: 0,
    draw2d_count: 0,
    draw3d_count: 0,
  })
}

///|
pub fn note_fixed_step(delta : Double) -> Unit {
  let metrics = ensure_metrics()
  frame_metrics_key.insert_in(current_world(), {
    ..metrics,
    fixed_steps_this_frame: metrics.fixed_steps_this_frame + 1,
    fixed_delta_total: metrics.fixed_delta_total + @cmp.maximum(0.0, delta),
  })
}

///|
pub fn note_update(update_delta : Double, entity_count : Int32) -> Unit {
  let metrics = ensure_metrics()
  frame_metrics_key.insert_in(current_world(), {
    ..metrics,
    update_delta: @cmp.maximum(0.0, update_delta),
    entity_count: @cmp.maximum(0, entity_count),
  })
}

///|
pub fn note_render(
  render_delta : Double,
  draw2d_count : Int32,
  draw3d_count : Int32,
) -> Unit {
  let metrics = ensure_metrics()
  let next_metrics = {
    ..metrics,
    render_delta: @cmp.maximum(0.0, render_delta),
    draw2d_count: @cmp.maximum(0, draw2d_count),
    draw3d_count: @cmp.maximum(0, draw3d_count),
  }
  frame_metrics_key.insert_in(current_world(), next_metrics)
  let history = frame_metrics_history_key.get_or_insert_with(current_world(), _ => {
    []
  })
  history.push({ ..next_metrics, })
  let max_samples = 120
  if history.length() > max_samples {
    let retained = history.copy()
    history.clear()
    let keep_from = retained.length() - max_samples
    for index in keep_from..<retained.length() {
      history.push(retained[index])
    }
  }
}

///|
pub fn latest_metrics() -> FramePerformanceMetrics {
  { ..ensure_metrics(), }
}

///|
pub fn rolling_metrics() -> Array[FramePerformanceMetrics] {
  frame_metrics_history_key.get_or_insert_with(current_world(), _ => []).copy()
}
