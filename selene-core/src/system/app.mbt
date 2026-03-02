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
const DEFAULT_VIEWPORT_HEIGHT = 256.0

///|
const DEFAULT_VIEWPORT_WIDTH = 512.0

///|
const DEFAULT_FPS : UInt = 60

///|
/// Application configuration and runtime container for a game or interactive
/// application.
///
/// The `App` struct serves as the central configuration hub that defines canvas
/// properties, manages systems with their execution schedules, and handles
/// plugins. It provides a builder pattern for configuration and orchestrates
/// the application lifecycle through system execution.
///
/// Fields:
///
/// * `viewport_height` : Height of the virtual viewport in pixels.
/// * `viewport_width` : Width of the virtual viewport in pixels.
/// * `zoom` : Zoom factor applied to the canvas rendering.
/// * `image_smooth` : Whether image smoothing is enabled during rendering.
/// * `fps` : Target frames per second for the application.
/// * `systems` : Collection of systems with their schedules and names for
///   execution management.
/// * `plugins` : Collection of plugins that extend application functionality.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_viewport_width(800.0)
///   .with_viewport_height(600.0)
///   .with_fps(30)
///   .with_zoom(2.0)
///   .with_image_smooth(false)
///
/// inspect(app.viewport_width, content="800")
/// inspect(app.fps, content="30")
/// inspect(app.zoom, content="2")
/// ```
///
pub(all) struct App {
  viewport_height : Double
  viewport_width : Double
  zoom : Double
  image_smooth : Bool
  fps : UInt
  systems : Array[(System, Schedule, String)]
  plugins : Array[Plugin]
}

///|
/// Creates a new `App` instance with default configuration values.
///
/// Returns a new `App` with default viewport dimensions (512x256 pixels), 60
/// FPS target frame rate, 1.0 zoom level, image smoothing enabled, and empty
/// collections for systems and plugins.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
/// inspect(app.viewport_width, content="512")
/// inspect(app.viewport_height, content="256")
/// inspect(app.fps, content="60")
/// inspect(app.zoom, content="1")
/// inspect(app.image_smooth, content="true")
/// ```
///
pub fn App::new() -> App {
  {
    viewport_height: DEFAULT_VIEWPORT_HEIGHT,
    viewport_width: DEFAULT_VIEWPORT_WIDTH,
    zoom: 1.0,
    image_smooth: true,
    fps: DEFAULT_FPS,
    systems: [],
    plugins: [],
  }
}

///|
/// Configures the image smoothing setting for the application's rendering.
///
/// Parameters:
///
/// * `self` : The `App` instance to configure.
/// * `image_smooth` : Whether to enable image smoothing during rendering. When
///   `true`, the renderer will apply smoothing algorithms to scale images,
///   making them appear softer. When `false`, images will maintain crisp,
///   pixelated edges when scaled.
///
/// Returns a new `App` instance with the updated image smoothing configuration.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_image_smooth(false) // Disable smoothing for pixel-perfect rendering
///
/// inspect(app.image_smooth, content="false")
/// ```
///
pub fn App::with_image_smooth(self : App, image_smooth : Bool) -> App {
  { ..self, image_smooth, }
}

///|
/// Configures the viewport height for the application.
///
/// Parameters:
///
/// * `self` : The `App` instance to configure.
/// * `height` : The desired height of the virtual viewport in pixels.
///
/// Returns a new `App` instance with the updated viewport height
/// configuration.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_viewport_height(600.0)
///
/// inspect(app.viewport_height, content="600")
/// ```
///
pub fn App::with_viewport_height(self : App, height : Double) -> App {
  { ..self, viewport_height: height }
}

///|
/// Configures the viewport width for the application.
///
/// Parameters:
///
/// * `self` : The `App` instance to configure.
/// * `width` : The desired width of the virtual viewport in pixels.
///
/// Returns a new `App` instance with the updated viewport width configuration.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_viewport_width(800.0)
///
/// inspect(app.viewport_width, content="800")
/// ```
///
pub fn App::with_viewport_width(self : App, width : Double) -> App {
  { ..self, viewport_width: width }
}

///|
/// Configures the target frames per second (FPS) for the application.
///
/// Parameters:
///
/// * `self` : The `App` instance to configure.
/// * `fps` : The desired target frame rate in frames per second. This controls
///   how often the application's update and render loops execute.
///
/// Returns a new `App` instance with the updated FPS configuration.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_fps(30)
///
/// inspect(app.fps, content="30")
/// ```
///
pub fn App::with_fps(self : App, fps : UInt) -> App {
  { ..self, fps, }
}

///|
/// Configures the zoom factor for the application's rendering.
///
/// Parameters:
///
/// * `self` : The `App` instance to configure.
/// * `zoom` : The zoom factor to apply to the canvas rendering. A value of 1.0
///   represents normal size, values greater than 1.0 will magnify the content,
///   and values less than 1.0 will shrink it.
///
/// Returns a new `App` instance with the updated zoom configuration.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
///   .with_zoom(2.0)
///
/// inspect(app.zoom, content="2")
/// ```
///
pub fn App::with_zoom(self : App, zoom : Double) -> App {
  { ..self, zoom, }
}

///|
/// Adds a plugin to the application's plugin collection.
///
/// Parameters:
///
/// * `self` : The `App` instance to which the plugin will be added.
/// * `plugin` : The plugin to add to the application. Plugins extend
///   application functionality and are executed when the application runs.
///
/// Returns a new `App` instance with the plugin added to its plugin collection.
///
/// Example:
///
/// ```moonbit nocheck
/// fn my_plugin(_app : @system.App) -> Unit {
///   // Plugin implementation
/// }
///
/// let app = @system.App::new()
///   .add_plugin(my_plugin)
///
/// inspect(app.plugins.length(), content="1")
/// ```
///
pub fn App::add_plugin(self : App, plugin : Plugin) -> App {
  let plugins = self.plugins
  plugins.push(plugin)
  { ..self, plugins, }
}

///|
/// Adds a system to the application with an optional execution schedule and
/// name.
///
/// Parameters:
///
/// * `self` : The `App` instance to add the system to.
/// * `system` : The system function to be added that will be executed during
///   the application lifecycle.
/// * `schedule` : The execution schedule that determines when the system runs
///   (defaults to `Update` if not specified).
/// * `system_name` : An optional name for the system used for identification
///   and debugging purposes. If not provided, generates an automatic name in
///   the format "unnamed\_system{N}" where N is the current number of systems.
///
/// Returns a new `App` instance with the system added to its collection.
///
/// Example:
///
/// ```moonbit nocheck
/// @system.App::new()
///   .add_system(timer_system)
///   .run()
///
/// // The app now contains three systems with different schedules
/// ```
///
pub fn App::add_system(
  self : App,
  system : System,
  schedule? : Schedule = Update,
  system_name? : String,
) -> App {
  let system_name = system_name.unwrap_or(
    "unnamed_system\{self.systems.length()}",
  )
  let systems = self.systems
  systems.push((system, schedule, system_name))
  { ..self, systems, }
}

///|
/// Starts the application and begins the main execution loop.
///
/// Executes all registered plugins first, then initializes the backend with
/// configured systems organized by their schedules. Startup systems run once
/// during initialization, render systems are sorted by priority and executed in
/// the render loop, and update systems run in the game loop. Finally registers
/// input event handlers and starts the main application loop.
///
/// Parameters:
///
/// * `self` : The `App` instance to run with its configured systems, plugins,
///   and settings.
///
pub fn App::run(self : App) -> Unit {
  if self.zoom <= 0.0 {
    abort("App::with_zoom must be a positive number")
  }
  configure_display(self.viewport_width, self.viewport_height, self.zoom)
  let screen_width = self.viewport_width * self.zoom
  let screen_height = self.viewport_height * self.zoom
  for plugin in self.plugins {
    plugin(self)
  }
  fn startup() {
    for system in self.systems {
      if system.1 is Startup {
        (system.0)(0)
      }
    }
  }

  let renders = []
  for system in self.systems {
    if system.1 is Render(pri) {
      renders.push((system.0, pri))
    }
  }
  renders.sort_by_key(fn(system) { -system.1 })
  fn render_loop(delta : Double) {
    for render in renders {
      (render.0)(delta)
    }
  }

  let game_loops = []
  for system in self.systems {
    if system.1 is Update {
      game_loops.push(system.0)
    }
  }
  fn game_loop(delta : Double) {
    for system in game_loops {
      system(delta)
    }
  }

  let run_game = @backend.initialize(@render.BackendConfig::{
    startup,
    render_loop,
    game_loop,
    viewport_width: self.viewport_width,
    viewport_height: self.viewport_height,
    screen_width,
    screen_height,
    fps: self.fps,
    image_smooth: self.image_smooth,
  })
  @backend.register_key_events(@inputs.pressed_keys)
  @backend.register_mouse_events(@inputs.mouse, @inputs.mouse_movement)
  run_game()
}
