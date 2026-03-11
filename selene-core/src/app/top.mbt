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
pub type System = (@ecs.World, Double) -> Unit

///|
pub type RunCondition = (@ecs.World) -> Bool

///|
pub type Plugin = (App) -> Unit

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
  systems : Array[RegisteredSystem]
  plugins : Array[Plugin]
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
    systems: [],
    plugins: [],
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
  let plugins = self.plugins
  plugins.push(plugin)
  { ..self, plugins, }
}

///|
pub fn App::add_system(
  self : App,
  system : System,
  schedule? : @system.Schedule = @system.Update,
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
  systems_to_add : Array[System],
  schedule? : @system.Schedule = @system.Update,
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
fn set_key(system : RegisteredSystem, index : Int) -> String {
  match system.in_set {
    Some(set) => set.name
    None => "__system_\{index}"
  }
}

///|
fn sort_systems_by_set(
  systems : Array[RegisteredSystem],
) -> Array[RegisteredSystem] {
  if systems.length() <= 1 {
    return systems
  }

  let group_members : Map[String, Array[RegisteredSystem]] = Map::new()
  let group_order : Map[String, Int] = Map::new()
  let group_keys : Array[String] = []

  for index, system in systems {
    let key = set_key(system, index)
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
    let current_key = set_key(system, index)
    for target in system.before {
      add_edge(current_key, target.name, outgoing, indegree)
    }
    for source in system.after {
      add_edge(source.name, current_key, outgoing, indegree)
    }
  }

  let sorted_candidates = group_keys.copy()
  sorted_candidates.sort_by(fn(lhs, rhs) {
    group_order.get(lhs).unwrap_or(0) - group_order.get(rhs).unwrap_or(0)
  })

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
    for system in group_members.get(key).unwrap_or([]) {
      ordered.push(system)
    }
  }
  ordered
}

///|
fn collect_systems(
  systems : Array[RegisteredSystem],
  matcher : (@system.Schedule) -> Bool,
) -> Array[RegisteredSystem] {
  let selected : Array[RegisteredSystem] = []
  for system in systems {
    if matcher(system.schedule) {
      selected.push(system)
    }
  }
  sort_systems_by_set(selected)
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
fn run_stage(
  systems : Array[RegisteredSystem],
  world : @ecs.World,
  delta : Double,
) -> Unit {
  @ecs.set_current_world(world)
  for system in systems {
    if should_run(system, world) {
      (system.system)(world, delta)
    }
  }
}

///|
pub fn App::run(self : App) -> Unit {
  if self.zoom <= 0.0 {
    abort("App::with_zoom must be a positive number")
  }
  if self.fixed_hz == 0 {
    abort("App::with_fixed_hz must be greater than 0")
  }
  if self.max_fixed_steps_per_frame == 0 {
    abort("App::with_max_fixed_steps_per_frame must be greater than 0")
  }

  @ecs.set_current_world(self.world)
  @system.configure_display(self.viewport_width, self.viewport_height, self.zoom)
  let screen_width = self.viewport_width * self.zoom
  let screen_height = self.viewport_height * self.zoom
  for plugin in self.plugins {
    plugin(self)
  }

  let startup_systems = collect_systems(self.systems, fn(schedule) {
    schedule is @system.Startup
  })
  let frame_first = collect_systems(self.systems, fn(schedule) {
    schedule is @system.First
  })
  let frame_pre = collect_systems(self.systems, fn(schedule) {
    schedule is @system.PreUpdate
  })
  let frame_on_exit = collect_systems(self.systems, fn(schedule) {
    schedule is @system.OnExit(_)
  })
  let frame_on_enter = collect_systems(self.systems, fn(schedule) {
    schedule is @system.OnEnter(_)
  })
  let frame_update = collect_systems(self.systems, fn(schedule) {
    schedule is @system.Update
  })
  let frame_post = collect_systems(self.systems, fn(schedule) {
    schedule is @system.PostUpdate
  })
  let frame_last = collect_systems(self.systems, fn(schedule) {
    schedule is @system.Last
  })

  let fixed_first = collect_systems(self.systems, fn(schedule) {
    schedule is @system.FixedFirst
  })
  let fixed_pre = collect_systems(self.systems, fn(schedule) {
    schedule is @system.FixedPreUpdate
  })
  let fixed_update = collect_systems(self.systems, fn(schedule) {
    schedule is @system.FixedUpdate
  })
  let fixed_post = collect_systems(self.systems, fn(schedule) {
    schedule is @system.FixedPostUpdate
  })
  let fixed_last = collect_systems(self.systems, fn(schedule) {
    schedule is @system.FixedLast
  })

  let render_extract = collect_systems(self.systems, fn(schedule) {
    schedule is @system.RenderExtract
  })
  let render_prepare = collect_systems(self.systems, fn(schedule) {
    schedule is @system.RenderPrepare
  })
  let render_stage = collect_systems(self.systems, fn(schedule) {
    schedule is @system.Render
  })
  let render_cleanup = collect_systems(self.systems, fn(schedule) {
    schedule is @system.RenderCleanup
  })

  let world = self.world

  fn startup() {
    @ecs.set_current_world(world)
    run_stage(startup_systems, world, 0.0)
    @commands.commands_flush_system(world, 0.0)
    @entity.entity_flush_system(0.0)
  }

  fn render_loop(_raw_delta : Double) {
    @ecs.set_current_world(world)
    let delta = @time.delta()
    @event.event_render_update_system(delta)
    run_stage(render_extract, world, delta)
    run_stage(render_prepare, world, delta)
    run_stage(render_stage, world, delta)
    run_stage(render_cleanup, world, delta)
    @platform_audio.tick()
  }

  let fixed_dt = 1.0 / self.fixed_hz.to_double()
  let max_fixed_steps = self.max_fixed_steps_per_frame.reinterpret_as_int()
  let accumulator : Ref[Double] = { val: 0.0 }

  fn game_loop(raw_delta : Double) {
    @ecs.set_current_world(world)
    world.advance_frame()
    @time.begin_frame(raw_delta)
    @inputs.apply_input_snapshot(@platform_input.poll_input())
    let delta = @time.delta()
    @state.state_transition_system(delta)
    @event.event_frame_update_system(delta)

    run_stage(frame_first, world, delta)
    run_stage(frame_pre, world, delta)
    run_stage(frame_on_exit, world, delta)
    run_stage(frame_on_enter, world, delta)
    run_stage(frame_update, world, delta)
    run_stage(frame_post, world, delta)

    @event.event_observer_dispatch_system(delta)
    run_stage(frame_last, world, delta)
    @commands.commands_flush_system(world, delta)
    @entity.entity_flush_system(delta)

    accumulator.val += delta
    let mut fixed_steps = 0
    while accumulator.val >= fixed_dt && fixed_steps < max_fixed_steps {
      world.advance_fixed_step()
      @event.event_fixed_update_system(fixed_dt)
      run_stage(fixed_first, world, fixed_dt)
      run_stage(fixed_pre, world, fixed_dt)
      run_stage(fixed_update, world, fixed_dt)
      run_stage(fixed_post, world, fixed_dt)
      run_stage(fixed_last, world, fixed_dt)
      @commands.commands_flush_system(world, fixed_dt)
      @entity.entity_flush_system(fixed_dt)
      accumulator.val -= fixed_dt
      fixed_steps += 1
    }
    if fixed_steps >= max_fixed_steps {
      accumulator.val = 0.0
    }

    let alpha = @cmp.maximum(0.0, @cmp.minimum(1.0, accumulator.val / fixed_dt))
    @system.set_render_alpha(alpha)
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
    { startup, render_loop, game_loop },
  )
  run_game()
}
