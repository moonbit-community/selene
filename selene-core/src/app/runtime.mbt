///|
priv struct RuntimePlan {
  world : @ecs.World
  fixed_dt : Double
  max_fixed_steps : Int32
  startup : @ecs.Schedule
  frame_input : @ecs.Schedule
  frame_update : @ecs.Schedule
  fixed : @ecs.Schedule
  render : @ecs.Schedule
  state_validations : Array[(@ecs.World) -> Unit]
  state_on_exit : @ecs.Schedule
  state_on_enter : @ecs.Schedule
}

///|
fn setup_runtime_world(app : App) -> Unit {
  @ecs.check_schedule_idle() catch {
    ActiveQuery => abort("App execution is forbidden inside a query batch")
    ReentrantSchedule => abort("App execution is not reentrant")
  }
  @ecs.set_current_world(app.world)
  @time.initialize(app.world)
  @window.configure_display(app.viewport_width, app.viewport_height, app.zoom)
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
  let stage = fn(stage : Stage) {
    collect_systems(app.systems, deterministic_ordering, candidate => {
      candidate == stage
    })
  }
  let frame_events = @ecs.Schedule().add_exclusive_system(_ => {
    @event.event_frame_update_system()
  })
  let fixed_events = @ecs.Schedule().add_exclusive_system(_ => {
    @event.event_fixed_update_system()
  })
  let observers = @ecs.Schedule().add_exclusive_system(_ => {
    @event.event_observer_dispatch_system()
  })
  let render_events = @ecs.Schedule().add_exclusive_system(_ => {
    @event.event_render_update_system()
  })
  {
    world: app.world,
    fixed_dt,
    max_fixed_steps: app.max_fixed_steps_per_frame.reinterpret_as_int(),
    startup: stage(Startup),
    frame_input: @ecs.Schedule::chain([
      frame_events,
      stage(First),
      stage(PreUpdate),
    ]),
    frame_update: @ecs.Schedule::chain([
      stage(Update),
      stage(PostUpdate),
      observers,
      stage(Last),
    ]),
    fixed: @ecs.Schedule::chain([
      fixed_events,
      stage(FixedFirst),
      stage(FixedPreUpdate),
      stage(FixedUpdate),
      stage(FixedPostUpdate),
      stage(FixedLast),
    ]),
    render: @ecs.Schedule::chain([
      render_events,
      stage(RenderExtract),
      stage(RenderPrepare),
      stage(Render),
      stage(RenderCleanup),
    ]),
    state_validations: app.state_validations.copy(),
    state_on_exit: app.state_on_exit,
    state_on_enter: app.state_on_enter,
  }
}

///|
fn startup_runtime(plan : RuntimePlan) -> Unit {
  @ecs.set_current_world(plan.world)
  @time.set_delta(0.0)
  try! plan.startup.run(plan.world)
  for validate in plan.state_validations {
    validate(plan.world)
  }
  run_state_transitions(plan, initial_only=true)
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
  try! plan.fixed.run(plan.world)
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

  try! plan.frame_input.run(plan.world)
  run_state_transitions(plan)

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
  try! plan.frame_update.run(plan.world)

  @runtime_debug.note_update(delta, @ecs.alive_entity_count())
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
  try! plan.render.run(plan.world)
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
