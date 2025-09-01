// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
const DEFAULT_CANVAS_HEIGHT = 256.0

///|
const DEFAULT_CANVAS_WIDTH = 512.0

///|
const DEFAULT_FPS : UInt = 60

///|
/// Main application container that manages the game loop, systems, plugins, and
/// rendering backend.
///
/// Fields:
///
/// * `canvas_height` : Height of the rendering canvas in pixels.
/// * `canvas_width` : Width of the rendering canvas in pixels.
/// * `fps` : Target frames per second for the game loop.
/// * `systems` : Collection of systems with their execution schedules and
///   names.
/// * `plugins` : Collection of plugins to be applied during application
///   startup.
/// * `backend` : Reference to the rendering and input backend implementation.
///
/// Example:
///
/// ```notest
/// let backend = // ... some backend implementation
/// let app = @system.App::new(backend)
///   .with_canvas_width(800.0)
///   .with_canvas_height(600.0)
///   .with_fps(60)
///   .add_system(my_update_system)
///   .add_plugin(my_plugin)
///
/// app.run()
/// ```
///
pub(all) struct App {
  canvas_height : Double
  canvas_width : Double
  zoom : Double
  image_smooth : Bool
  fps : UInt
  systems : Array[(System, Schedule, String)]
  plugins : Array[Plugin]
  backend : &Backend
}

///|
pub fn App::new(backend : &Backend) -> App {
  {
    canvas_height: DEFAULT_CANVAS_HEIGHT,
    canvas_width: DEFAULT_CANVAS_WIDTH,
    zoom: 1.0,
    image_smooth: true,
    fps: DEFAULT_FPS,
    systems: [],
    plugins: [],
    backend,
  }
}

///|
pub fn App::with_image_smooth(self : App, image_smooth : Bool) -> App {
  { ..self, image_smooth, }
}

///|
pub fn App::with_canvas_height(self : App, height : Double) -> App {
  { ..self, canvas_height: height }
}

///|
pub fn App::with_canvas_width(self : App, width : Double) -> App {
  { ..self, canvas_width: width }
}

///|
pub fn App::with_fps(self : App, fps : UInt) -> App {
  { ..self, fps, }
}

///|
pub fn App::with_zoom(self : App, zoom : Double) -> App {
  { ..self, zoom, }
}

///|
pub fn App::with_backend(self : App, backend : &Backend) -> App {
  { ..self, backend, }
}

///|
pub fn App::add_plugin(self : App, plugin : Plugin) -> App {
  let plugins = self.plugins
  plugins.push(plugin)
  { ..self, plugins, }
}

///|
/// Adds a system to the application with optional scheduling and naming
/// configuration.
///
/// Parameters:
///
/// * `self` : The application instance to modify.
/// * `system` : The system function to be executed during the game loop.
/// * `schedule` : The execution schedule for the system (defaults to `Update`).
/// * `system_name` : Optional custom name for the system. If not provided,
///   generates a name like "unnamed\_system0", "unnamed\_system1", etc.
///
/// Returns a new `App` instance with the system added to its collection.
///
/// Example:
///
/// ```notest
/// let app = @system.App::new(backend)
///   .add_system(my_update_system)
///   .add_system(my_render_system, schedule=@system.Schedule::Render(0), system_name="main_renderer")
/// ```
///
pub fn App::add_system(
  self : App,
  system : System,
  schedule? : Schedule = Update,
  system_name? : String,
) -> App {
  let system_name = match system_name {
    None => "unnamed_system\{self.systems.length()}"
    Some(name) => name
  }
  let systems = self.systems
  systems.push((system, schedule, system_name))
  { ..self, systems, }
}

///|
pub fn App::run(self : App) -> Unit {
  for plugin in self.plugins {
    plugin(self)
  }
  let run_game = self.backend.build(
    self.systems,
    self.canvas_width,
    self.canvas_height,
    self.fps,
    self.image_smooth,
    self.zoom,
  )
  self.backend.register_key_events(pressed_keys)
  self.backend.register_mouse_events(mouse, mouse_movement)
  run_game()
}
