///|
fn default_metrics(world : @ecs.World) -> FramePerformanceMetrics {
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
  frame_metrics_by_world.get_or_init(world.id(), () => default_metrics(world))
}

///|
pub fn begin_frame_metrics() -> Unit {
  let world = current_world()
  frame_metrics_by_world.set(world.id(), {
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
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  frame_metrics_by_world.set(world_id, {
    ..metrics,
    fixed_steps_this_frame: metrics.fixed_steps_this_frame + 1,
    fixed_delta_total: metrics.fixed_delta_total + @cmp.maximum(0.0, delta),
  })
}

///|
pub fn note_update(update_delta : Double, entity_count : Int) -> Unit {
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  frame_metrics_by_world.set(world_id, {
    ..metrics,
    update_delta: @cmp.maximum(0.0, update_delta),
    entity_count: @cmp.maximum(0, entity_count),
  })
}

///|
pub fn note_render(
  render_delta : Double,
  draw2d_count : Int,
  draw3d_count : Int,
) -> Unit {
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  let next_metrics = {
    ..metrics,
    render_delta: @cmp.maximum(0.0, render_delta),
    draw2d_count: @cmp.maximum(0, draw2d_count),
    draw3d_count: @cmp.maximum(0, draw3d_count),
  }
  frame_metrics_by_world.set(world_id, next_metrics)
  let history = frame_metrics_history_by_world.get_or_init(world_id, () => [])
  history.push({ ..next_metrics })
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
  { ..ensure_metrics() }
}

///|
pub fn rolling_metrics() -> Array[FramePerformanceMetrics] {
  frame_metrics_history_by_world
  .get_or_init(current_world_id(), () => [])
  .copy()
}
