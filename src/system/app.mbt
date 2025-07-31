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
const DEFAULT_CANVAS_HEIGHT = 600.0

///|
const DEFAULT_CANVAS_WIDTH = 800.0

///|
const DEFAULT_FPS : UInt = 60

///|
pub(all) struct App {
  canvas_height : Double
  canvas_width : Double
  fps : UInt
  physical_fps : UInt
  initializers : Array[System]
  systems : Array[System]
  render_pipes : Array[System]
  plugins : Array[Plugin]
  backend : &Backend
}

///|
pub fn App::new(backend : &Backend) -> App {
  {
    canvas_height: DEFAULT_CANVAS_HEIGHT,
    canvas_width: DEFAULT_CANVAS_WIDTH,
    fps: DEFAULT_FPS,
    physical_fps: DEFAULT_FPS,
    systems: [],
    initializers: [],
    render_pipes: [],
    plugins: [],
    backend,
  }
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
pub fn App::with_physical_fps(self : App, fps : UInt) -> App {
  { ..self, physical_fps: fps }
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
pub fn App::add_initializer(self : App, initializer : System) -> App {
  let initializers = self.initializers
  initializers.push(initializer)
  { ..self, initializers, }
}

///|
pub fn App::add_system(self : App, system : System) -> App {
  let systems = self.systems
  systems.push(system)
  { ..self, systems, }
}

///|
pub fn App::add_render_pipe(self : App, pipe : System) -> App {
  let render_pipes = self.render_pipes
  render_pipes.push(pipe)
  { ..self, render_pipes, }
}

///|
pub fn App::run(self : App) -> Unit {
  fn initialize() -> Unit {
    for initializer in self.initializers {
      initializer(self.backend)
    }
  }

  fn game_loop() -> Unit {
    for system in self.systems {
      system(self.backend)
    }
  }

  fn render_loop() -> Unit {
    for pipe in self.render_pipes {
      pipe(self.backend)
    }
  }

  for plugin in self.plugins {
    plugin(self)
  }
  self.backend.register_key_events(
    pressed_keys, keyup_callbacks, keydown_callbacks,
  )
  self.backend.build(
    initialize,
    game_loop,
    self.physical_fps,
    render_loop,
    self.canvas_width,
    self.canvas_height,
    self.fps,
  )
}
