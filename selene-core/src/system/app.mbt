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
pub(all) struct App {
  canvas_height : Double
  canvas_width : Double
  zoom : Double
  image_smooth : Bool
  fps : UInt
  systems : Array[(System, Schedule, String)]
  plugins : Array[Plugin]
}

///|
pub fn App::new() -> App {
  {
    canvas_height: DEFAULT_CANVAS_HEIGHT,
    canvas_width: DEFAULT_CANVAS_WIDTH,
    zoom: 1.0,
    image_smooth: true,
    fps: DEFAULT_FPS,
    systems: [],
    plugins: [],
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
pub fn App::add_plugin(self : App, plugin : Plugin) -> App {
  let plugins = self.plugins
  plugins.push(plugin)
  { ..self, plugins, }
}

///|
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

  let run_game = @backend.initialize(
    startup~,
    render_loop~,
    game_loop~,
    canvas_width=self.canvas_width,
    canvas_height=self.canvas_height,
    fps=self.fps,
    image_smooth=self.image_smooth,
    zoom=self.zoom,
  )
  @backend.register_key_events(@inputs.pressed_keys)
  @backend.register_mouse_events(@inputs.mouse, @inputs.mouse_movement)
  run_game()
}
