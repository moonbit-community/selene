///|
pub(all) struct RuntimePlan {
  world : @ecs.World
  fixed_dt : Double
  max_fixed_steps : Int32
  startup_systems : Array[RegisteredSystem]
  frame_first : Array[RegisteredSystem]
  frame_pre : Array[RegisteredSystem]
  frame_on_exit : Array[RegisteredSystem]
  frame_on_enter : Array[RegisteredSystem]
  frame_update : Array[RegisteredSystem]
  frame_post : Array[RegisteredSystem]
  frame_last : Array[RegisteredSystem]
  fixed_first : Array[RegisteredSystem]
  fixed_pre : Array[RegisteredSystem]
  fixed_update : Array[RegisteredSystem]
  fixed_post : Array[RegisteredSystem]
  fixed_last : Array[RegisteredSystem]
  render_extract : Array[RegisteredSystem]
  render_prepare : Array[RegisteredSystem]
  render_stage : Array[RegisteredSystem]
  render_cleanup : Array[RegisteredSystem]
}

///|
fn setup_runtime_world(app : App) -> Unit {
  @ecs.set_current_world(app.world)
  @time.initialize(app.world)
  @system.configure_display(app.viewport_width, app.viewport_height, app.zoom)
  for register_event in app.event_registrations {
    register_event(app.world)
  }
}

///|
fn resolve_fixed_dt(app : App, fixed_delta_override : Double?) -> Double {
  let deterministic_override = @runtime_debug.fixed_delta_override()
  let chosen = match fixed_delta_override {
    Some(value) => Some(value)
    None => deterministic_override
  }
  match chosen {
    Some(value) => value
    None => 1.0 / app.fixed_hz.to_double()
  }
}

///|
fn build_runtime_plan(
  app : App,
  fixed_delta_override~ : Double? = None,
) -> RuntimePlan {
  if app.zoom <= 0.0 {
    abort("App::with_zoom must be a positive number")
  }
  if app.max_fps == Some(0U) {
    abort("App::with_max_fps must be greater than 0")
  }
  if app.fixed_hz == 0 {
    abort("App::with_fixed_hz must be greater than 0")
  }
  if app.max_fixed_steps_per_frame == 0 {
    abort("App::with_max_fixed_steps_per_frame must be greater than 0")
  }
  let fixed_dt = resolve_fixed_dt(app, fixed_delta_override)
  if fixed_dt <= 0.0 {
    abort("App::run_frames/step_fixed fixed delta must be greater than 0")
  }
  let deterministic_ordering = @runtime_debug.deterministic_ordering_enabled()
  {
    world: app.world,
    fixed_dt,
    max_fixed_steps: app.max_fixed_steps_per_frame.reinterpret_as_int(),
    startup_systems: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is Startup
    }),
    frame_first: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is First
    }),
    frame_pre: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is PreUpdate
    }),
    frame_on_exit: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is OnExit(_)
    }),
    frame_on_enter: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is OnEnter(_)
    }),
    frame_update: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is Update
    }),
    frame_post: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is PostUpdate
    }),
    frame_last: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is Last
    }),
    fixed_first: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is FixedFirst
    }),
    fixed_pre: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is FixedPreUpdate
    }),
    fixed_update: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is FixedUpdate
    }),
    fixed_post: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is FixedPostUpdate
    }),
    fixed_last: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is FixedLast
    }),
    render_extract: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is RenderExtract
    }),
    render_prepare: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is RenderPrepare
    }),
    render_stage: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is Render
    }),
    render_cleanup: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is RenderCleanup
    }),
  }
}

///|
fn startup_runtime(plan : RuntimePlan) -> Unit {
  @ecs.set_current_world(plan.world)
  @time.set_delta(0.0)
  try! @ecs.run_schedule(plan.world, world => {
    run_stage(plan.startup_systems, world)
  })
}

///|
fn resolved_frame_delta(raw_delta : Double) -> Double {
  match @runtime_debug.frame_delta_override() {
    Some(override_delta) => override_delta
    None => raw_delta
  }
}

///|
fn run_fixed_step_once(plan : RuntimePlan) -> Unit {
  @ecs.set_current_world(plan.world)
  plan.world.advance_fixed_step()
  @time.use_fixed_delta(plan.fixed_dt)
  let fixed_delta = @time.delta()
  try! @ecs.run_schedule(plan.world, world => {
    @event.event_fixed_update_system(fixed_delta)
    run_stage(plan.fixed_first, world)
    run_stage(plan.fixed_pre, world)
    run_stage(plan.fixed_update, world)
    run_stage(plan.fixed_post, world)
    run_stage(plan.fixed_last, world)
  })
  @runtime_debug.note_fixed_step(fixed_delta)
}

///|
fn run_game_frame(
  plan : RuntimePlan,
  accumulator : Ref[Double],
  raw_delta : Double,
  input_override : @inputs.InputSnapshot?,
) -> Unit {
  @ecs.set_current_world(plan.world)
  plan.world.advance_frame()
  @runtime_debug.begin_frame_metrics()

  let used_delta = resolved_frame_delta(raw_delta)
  @time.begin_frame(used_delta)
  let injected_or_polled = match input_override {
    Some(snapshot) => snapshot
    None =>
      @runtime_debug.consume_injected_input_or(fn() {
        @platform_input.poll_input()
      })
  }
  @inputs.apply_input_snapshot(injected_or_polled)
  accumulator.val += @time.delta()

  let mut fixed_steps = 0
  while accumulator.val >= plan.fixed_dt && fixed_steps < plan.max_fixed_steps {
    run_fixed_step_once(plan)
    accumulator.val -= plan.fixed_dt
    fixed_steps += 1
  }
  if fixed_steps >= plan.max_fixed_steps {
    accumulator.val = 0.0
  }

  @time.use_frame_delta()
  let delta = @time.delta()
  try! @ecs.run_schedule(plan.world, world => {
    @state.state_transition_system(delta)
    @event.event_frame_update_system(delta)
    run_stage(plan.frame_first, world)
    run_stage(plan.frame_pre, world)
    run_stage(plan.frame_on_exit, world)
    run_stage(plan.frame_on_enter, world)
    run_stage(plan.frame_update, world)
    run_stage(plan.frame_post, world)
    @event.event_observer_dispatch_system(delta)
    run_stage(plan.frame_last, world)
  })

  @runtime_debug.note_update(delta, @ecs.alive_entity_count())

  let alpha = @cmp.maximum(
    0.0,
    @cmp.minimum(1.0, accumulator.val / plan.fixed_dt),
  )
  @system.set_render_alpha(alpha)
}

///|
fn service_platform_frame(service_frame : () -> Unit) -> Unit {
  service_frame()
}

///|
fn run_render_frame(plan : RuntimePlan, raw_delta : Double) -> Unit {
  @ecs.set_current_world(plan.world)
  let used_delta = resolved_frame_delta(raw_delta)
  @time.set_delta(used_delta)
  @time.use_frame_delta()
  let delta = @time.delta()
  @event.event_render_update_system(delta)
  run_stage(plan.render_extract, plan.world)
  run_stage(plan.render_prepare, plan.world)
  run_stage(plan.render_stage, plan.world)
  run_stage(plan.render_cleanup, plan.world)
  let (draw2d_count, draw3d_count) = match
    @runtime_debug.latest_render_submission() {
    Some(submission) => (submission.draw2d.length(), submission.draw3d.length())
    None => (0, 0)
  }
  @runtime_debug.note_render(delta, draw2d_count, draw3d_count)
}

///|
fn run_headless_frame(
  plan : RuntimePlan,
  accumulator : Ref[Double],
  raw_delta : Double,
  input_override : @inputs.InputSnapshot?,
  service_frame : () -> Unit,
) -> Unit {
  service_platform_frame(service_frame)
  run_game_frame(plan, accumulator, raw_delta, input_override)
  run_render_frame(plan, raw_delta)
  service_platform_frame(service_frame)
}
