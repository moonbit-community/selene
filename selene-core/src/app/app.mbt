///|
const DEFAULT_VIEWPORT_HEIGHT = 256.0

///|
const DEFAULT_VIEWPORT_WIDTH = 512.0

///|
const DEFAULT_FRAME_DELTA : Double = 1.0 / 60.0

///|
const DEFAULT_FIXED_HZ : UInt32 = 64

///|
const DEFAULT_MAX_FIXED_STEPS_PER_FRAME : UInt32 = 8

///|
pub type Plugin = (App) -> App

///|
struct App {
  viewport_height : Double
  viewport_width : Double
  zoom : Double
  image_smooth : Bool
  max_fps : UInt32?
  fixed_hz : UInt32
  max_fixed_steps_per_frame : UInt32
  world : @ecs.World
  event_registrations : Array[(@ecs.World) -> Unit]
  systems : Array[RegisteredSystem]
  state_validations : Array[(@ecs.World) -> Unit]
  state_on_enter : @ecs.Schedule
  state_on_exit : @ecs.Schedule
}

///|
pub fn App::App() -> App {
  let world = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  {
    viewport_height: DEFAULT_VIEWPORT_HEIGHT,
    viewport_width: DEFAULT_VIEWPORT_WIDTH,
    zoom: 1.0,
    image_smooth: true,
    max_fps: None,
    fixed_hz: DEFAULT_FIXED_HZ,
    max_fixed_steps_per_frame: DEFAULT_MAX_FIXED_STEPS_PER_FRAME,
    world,
    event_registrations: [],
    systems: [],
    state_validations: [],
    state_on_enter: Schedule(),
    state_on_exit: Schedule(),
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
/// Inserts a resource into this app's World.
pub fn[T : @ecs.Resource] App::insert_resource(self : App, value : T) -> App {
  self.world.insert_resource(value)
  self
}

///|
pub fn App::with_image_smooth(self : App, image_smooth : Bool) -> App {
  { ..self, image_smooth, }
}

///|
pub fn App::with_viewport_height(self : App, height : Double) -> App {
  { ..self, viewport_height: height, }
}

///|
pub fn App::with_viewport_width(self : App, width : Double) -> App {
  { ..self, viewport_width: width, }
}

///|
/// Sets an optional upper bound on browser frames. The default follows RAF.
pub fn App::with_max_fps(self : App, fps : UInt32) -> App {
  { ..self, max_fps: Some(fps), }
}

///|
pub fn App::with_fixed_hz(self : App, fixed_hz : UInt32) -> App {
  { ..self, fixed_hz, }
}

///|
pub fn App::with_max_fixed_steps_per_frame(self : App, steps : UInt32) -> App {
  { ..self, max_fixed_steps_per_frame: steps, }
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
  { ..self, event_registrations: registrations, }
}
