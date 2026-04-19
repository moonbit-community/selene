///|
const DEFAULT_VIEWPORT_HEIGHT = 256.0

///|
const DEFAULT_VIEWPORT_WIDTH = 512.0

///|
const DEFAULT_FPS : UInt = 60

///|
const DEFAULT_FIXED_HZ : UInt = 64

///|
const DEFAULT_MAX_FIXED_STEPS_PER_FRAME : UInt = 8

///|
pub type System = (@ecs.World) -> Unit

///|
pub type RunCondition = (@ecs.World) -> Bool

///|
pub type Plugin = (App) -> App

///|
pub(all) struct RegisteredSystem {
  system : System
  schedule : @system.Schedule
  name : String
  in_set : @system_set.SystemSet?
  before : Array[@system_set.SystemSet]
  after : Array[@system_set.SystemSet]
  run_if : RunCondition?
}

///|
pub(all) struct App {
  viewport_height : Double
  viewport_width : Double
  zoom : Double
  image_smooth : Bool
  fps : UInt
  fixed_hz : UInt
  max_fixed_steps_per_frame : UInt
  world : @ecs.World
  event_registrations : Array[(@ecs.World) -> Unit]
  systems : Array[RegisteredSystem]

  fn new() -> App
}

///|
pub fn App::new() -> App {
  let world = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  {
    viewport_height: DEFAULT_VIEWPORT_HEIGHT,
    viewport_width: DEFAULT_VIEWPORT_WIDTH,
    zoom: 1.0,
    image_smooth: true,
    fps: DEFAULT_FPS,
    fixed_hz: DEFAULT_FIXED_HZ,
    max_fixed_steps_per_frame: DEFAULT_MAX_FIXED_STEPS_PER_FRAME,
    world,
    event_registrations: [],
    systems: [],
  }
}

///|
pub fn App::with_world(self : App, world : @ecs.World) -> App {
  { ..self, world, }
}

///|
pub fn App::world(self : App) -> @ecs.World {
  self.world
}

///|
pub fn App::with_image_smooth(self : App, image_smooth : Bool) -> App {
  { ..self, image_smooth, }
}

///|
pub fn App::with_viewport_height(self : App, height : Double) -> App {
  { ..self, viewport_height: height }
}

///|
pub fn App::with_viewport_width(self : App, width : Double) -> App {
  { ..self, viewport_width: width }
}

///|
pub fn App::with_fps(self : App, fps : UInt) -> App {
  { ..self, fps, }
}

///|
pub fn App::with_fixed_hz(self : App, fixed_hz : UInt) -> App {
  { ..self, fixed_hz, }
}

///|
pub fn App::with_max_fixed_steps_per_frame(self : App, steps : UInt) -> App {
  { ..self, max_fixed_steps_per_frame: steps }
}

///|
pub fn App::with_zoom(self : App, zoom : Double) -> App {
  { ..self, zoom, }
}

///|
pub fn App::add_plugin(self : App, plugin : Plugin) -> App {
  plugin(self)
}

///|
pub fn App::add_plugins(self : App, plugins : Array[Plugin]) -> App {
  let mut app = self
  for plugin in plugins {
    app = app.add_plugin(plugin)
  }
  app
}

///|
pub fn[T] App::add_message(self : App, events : @event.Events[T]) -> App {
  let registrations = self.event_registrations
  registrations.push(fn(world) { events.register_to_world(world) })
  { ..self, event_registrations: registrations }
}

///|
pub fn App::add_system(
  self : App,
  schedule : @system.Schedule,
  system : System,
  system_name? : String,
  in_set? : @system_set.SystemSet,
  before? : Array[@system_set.SystemSet] = [],
  after? : Array[@system_set.SystemSet] = [],
  run_if? : RunCondition,
) -> App {
  let system_name = system_name.unwrap_or(
    "unnamed_system\{self.systems.length()}",
  )
  let systems = self.systems
  systems.push({
    system,
    schedule,
    name: system_name,
    in_set,
    before,
    after,
    run_if,
  })
  { ..self, systems, }
}

///|
pub fn App::add_systems(
  self : App,
  schedule : @system.Schedule,
  systems_to_add : Array[System],
  in_set? : @system_set.SystemSet,
  before? : Array[@system_set.SystemSet] = [],
  after? : Array[@system_set.SystemSet] = [],
  run_if? : RunCondition,
) -> App {
  let systems = self.systems
  for system in systems_to_add {
    let name = "unnamed_system\{systems.length()}"
    systems.push({ system, schedule, name, in_set, before, after, run_if })
  }
  { ..self, systems, }
}

///|
fn set_key(
  system : RegisteredSystem,
  index : Int,
  deterministic_ordering : Bool,
) -> String {
  match system.in_set {
    Some(set) => set.name
    None =>
      if deterministic_ordering {
        "__system_\{system.name}_\{index}"
      } else {
        "__system_\{index}"
      }
  }
}

///|
fn sort_systems_by_set(
  systems : Array[RegisteredSystem],
  deterministic_ordering : Bool,
) -> Array[RegisteredSystem] {
  if systems.length() <= 1 {
    return systems
  }

  let group_members : Map[String, Array[RegisteredSystem]] = Map::new()
  let group_order : Map[String, Int] = Map::new()
  let group_keys : Array[String] = []

  for index, system in systems {
    let key = set_key(system, index, deterministic_ordering)
    if !group_members.contains(key) {
      group_members.set(key, [])
      group_order.set(key, index)
      group_keys.push(key)
    }
    let members = group_members.get(key).unwrap_or([])
    members.push(system)
    group_members.set(key, members)
  }

  let outgoing : Map[String, @set.Set[String]] = Map::new()
  let indegree : Map[String, Int] = Map::new()
  for key in group_keys {
    outgoing.set(key, @set.Set::new())
    indegree.set(key, 0)
  }

  fn add_edge(
    from : String,
    to : String,
    outgoing : Map[String, @set.Set[String]],
    indegree : Map[String, Int],
  ) -> Unit {
    if from == to {
      return
    }
    if !outgoing.contains(from) || !outgoing.contains(to) {
      return
    }
    guard outgoing.get(from) is Some(edges) else { return }
    if edges.contains(to) {
      return
    }
    edges.add(to)
    indegree.set(to, indegree.get(to).unwrap_or(0) + 1)
  }

  for index, system in systems {
    let current_key = set_key(system, index, deterministic_ordering)
    for target in system.before {
      add_edge(current_key, target.name, outgoing, indegree)
    }
    for source in system.after {
      add_edge(source.name, current_key, outgoing, indegree)
    }
  }

  let sorted_candidates = group_keys.copy()
  if deterministic_ordering {
    sorted_candidates.sort_by(fn(lhs, rhs) {
      if lhs < rhs {
        -1
      } else if lhs > rhs {
        1
      } else {
        0
      }
    })
  } else {
    sorted_candidates.sort_by(fn(lhs, rhs) {
      group_order.get(lhs).unwrap_or(0) - group_order.get(rhs).unwrap_or(0)
    })
  }

  let processed : @set.Set[String] = @set.Set::new()
  let sorted_keys : Array[String] = []
  while processed.to_array().length() < group_keys.length() {
    let mut progressed = false
    for key in sorted_candidates {
      if processed.contains(key) {
        continue
      }
      if indegree.get(key).unwrap_or(0) != 0 {
        continue
      }
      progressed = true
      processed.add(key)
      sorted_keys.push(key)
      for target in outgoing.get(key).unwrap_or(@set.Set::new()) {
        let degree = indegree.get(target).unwrap_or(0)
        indegree.set(target, @cmp.maximum(0, degree - 1))
      }
    }
    if progressed {
      continue
    }
    for key in sorted_candidates {
      if !processed.contains(key) {
        processed.add(key)
        sorted_keys.push(key)
      }
    }
  }

  let ordered : Array[RegisteredSystem] = []
  for key in sorted_keys {
    let members = group_members.get(key).unwrap_or([])
    if deterministic_ordering {
      members.sort_by(fn(lhs, rhs) {
        if lhs.name < rhs.name {
          -1
        } else if lhs.name > rhs.name {
          1
        } else {
          0
        }
      })
    }
    for system in members {
      ordered.push(system)
    }
  }
  ordered
}

///|
fn collect_systems(
  systems : Array[RegisteredSystem],
  deterministic_ordering : Bool,
  matcher : (@system.Schedule) -> Bool,
) -> Array[RegisteredSystem] {
  let selected : Array[RegisteredSystem] = []
  for system in systems {
    if matcher(system.schedule) {
      selected.push(system)
    }
  }
  sort_systems_by_set(selected, deterministic_ordering)
}

///|
fn should_run(system : RegisteredSystem, world : @ecs.World) -> Bool {
  let schedule_allows = match system.schedule {
    @system.OnEnter(condition) => condition()
    @system.OnExit(condition) => condition()
    _ => true
  }
  if !schedule_allows {
    return false
  }
  match system.run_if {
    Some(condition) => condition(world)
    None => true
  }
}

///|
fn run_stage(systems : Array[RegisteredSystem], world : @ecs.World) -> Unit {
  @ecs.set_current_world(world)
  for system in systems {
    if should_run(system, world) {
      (system.system)(world)
    }
  }
}

///|
pub(all) struct RuntimePlan {
  world : @ecs.World
  fixed_dt : Double
  max_fixed_steps : Int
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
  fixed_delta_override? : Double? = None,
) -> RuntimePlan {
  if app.zoom <= 0.0 {
    abort("App::with_zoom must be a positive number")
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
      schedule is @system.Startup
    }),
    frame_first: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.First
    }),
    frame_pre: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.PreUpdate
    }),
    frame_on_exit: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.OnExit(_)
    }),
    frame_on_enter: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.OnEnter(_)
    }),
    frame_update: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.Update
    }),
    frame_post: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.PostUpdate
    }),
    frame_last: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.Last
    }),
    fixed_first: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.FixedFirst
    }),
    fixed_pre: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.FixedPreUpdate
    }),
    fixed_update: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.FixedUpdate
    }),
    fixed_post: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.FixedPostUpdate
    }),
    fixed_last: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.FixedLast
    }),
    render_extract: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.RenderExtract
    }),
    render_prepare: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.RenderPrepare
    }),
    render_stage: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.Render
    }),
    render_cleanup: collect_systems(app.systems, deterministic_ordering, fn(
      schedule,
    ) {
      schedule is @system.RenderCleanup
    }),
  }
}

///|
fn startup_runtime(plan : RuntimePlan) -> Unit {
  @ecs.set_current_world(plan.world)
  @time.set_delta(0.0)
  run_stage(plan.startup_systems, plan.world)
  @commands.commands_flush_system(plan.world, 0.0)
  @entity.entity_flush_system(0.0)
}

///|
fn alive_entity_count() -> Int {
  let mut count = 0
  for entity in @entity.iter_entities() {
    if entity.is_alive() {
      count += 1
    }
  }
  count
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
  @event.event_fixed_update_system(fixed_delta)
  run_stage(plan.fixed_first, plan.world)
  run_stage(plan.fixed_pre, plan.world)
  run_stage(plan.fixed_update, plan.world)
  run_stage(plan.fixed_post, plan.world)
  run_stage(plan.fixed_last, plan.world)
  @commands.commands_flush_system(plan.world, fixed_delta)
  @entity.entity_flush_system(fixed_delta)
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
  @state.state_transition_system(delta)
  @event.event_frame_update_system(delta)
  run_stage(plan.frame_first, plan.world)
  run_stage(plan.frame_pre, plan.world)
  run_stage(plan.frame_on_exit, plan.world)
  run_stage(plan.frame_on_enter, plan.world)
  run_stage(plan.frame_update, plan.world)
  run_stage(plan.frame_post, plan.world)
  @event.event_observer_dispatch_system(delta)
  run_stage(plan.frame_last, plan.world)
  @commands.commands_flush_system(plan.world, delta)
  @entity.entity_flush_system(delta)

  @runtime_debug.note_update(delta, alive_entity_count())

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

///|
pub fn App::run(self : App) -> Unit {
  setup_runtime_world(self)
  let plan = build_runtime_plan(self)
  let accumulator : Ref[Double] = { val: 0.0 }
  let screen_width = self.viewport_width * self.zoom
  let screen_height = self.viewport_height * self.zoom

  fn startup() {
    startup_runtime(plan)
  }

  fn service_frame() {
    @platform_audio.tick()
  }

  fn render_loop(_raw_delta : Double) {
    run_render_frame(plan, _raw_delta)
  }

  fn game_loop(raw_delta : Double) {
    run_game_frame(plan, accumulator, raw_delta, None)
  }

  let run_game = @platform_window.initialize(
    {
      viewport_width: self.viewport_width,
      viewport_height: self.viewport_height,
      screen_width,
      screen_height,
      fps: self.fps,
      image_smooth: self.image_smooth,
    },
    { startup, service_frame, render_loop, game_loop },
  )
  run_game()
}

///|
pub fn App::run_frames(
  self : App,
  frames : Int,
  raw_delta? : Double = 1.0 / DEFAULT_FPS.to_double(),
  fixed_delta_override? : Double? = None,
) -> Unit {
  if frames <= 0 {
    return
  }
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  let accumulator : Ref[Double] = { val: 0.0 }
  let default_delta = 1.0 / self.fps.to_double()
  let used_delta = if raw_delta > 0.0 { raw_delta } else { default_delta }
  for _ in 0..<frames {
    run_headless_frame(plan, accumulator, used_delta, None, @platform_audio.tick)
  }
}

///|
fn resolved_capture_dimension(override_value : Int, fallback : Double) -> Int {
  if override_value > 0 {
    return override_value
  }
  let candidate = fallback.to_int()
  if candidate > 0 {
    candidate
  } else {
    1
  }
}

///|
pub fn App::run_frames_capture(
  self : App,
  frames : Int,
  capture_width? : Int = 0,
  capture_height? : Int = 0,
  raw_delta? : Double = 1.0 / DEFAULT_FPS.to_double(),
  fixed_delta_override? : Double? = None,
  metadata_indent? : Int = 2,
) -> Array[@runtime_debug.FrameCaptureArtifact] {
  let captures : Array[@runtime_debug.FrameCaptureArtifact] = []
  if frames <= 0 {
    return captures
  }
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  let accumulator : Ref[Double] = { val: 0.0 }
  let default_delta = 1.0 / self.fps.to_double()
  let used_delta = if raw_delta > 0.0 { raw_delta } else { default_delta }
  let resolved_width = resolved_capture_dimension(
    capture_width,
    self.viewport_width * self.zoom,
  )
  let resolved_height = resolved_capture_dimension(
    capture_height,
    self.viewport_height * self.zoom,
  )
  for _ in 0..<frames {
    run_headless_frame(plan, accumulator, used_delta, None, @platform_audio.tick)
    if @runtime_debug.capture_last_frame_with_metadata(
        resolved_width,
        resolved_height,
        indent=metadata_indent,
      )
      is Some(capture) {
      captures.push(capture)
    }
  }
  captures
}

///|
pub fn App::step_fixed(
  self : App,
  steps : Int,
  fixed_delta_override? : Double? = None,
) -> Unit {
  if steps <= 0 {
    return
  }
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  for _ in 0..<steps {
    run_fixed_step_once(plan)
  }
  @system.set_render_alpha(0.0)
}
