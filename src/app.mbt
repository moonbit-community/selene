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
pub(open) trait Backend {
  build(
    Self,
    game_loop : () -> Unit,
    physical_fps : UInt,
    render_loop : () -> Unit,
    canvas_width : Double,
    canvas_height : Double,
    fps : UInt,
  ) -> Unit
  render_picture(
    Self,
    png : String,
    x : Double,
    y : Double,
    width : Double,
    height : Double,
    repeat : Bool,
  ) -> Unit
}

///|
struct App {
  canvas_height : Double
  canvas_width : Double
  fps : UInt
  physical_fps : UInt
  systems : Array[System]
  render_pipes : Array[System]
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
    render_pipes: [],
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
pub fn App::add_system(self : App, system : (&Backend) -> Unit) -> App {
  let systems = self.systems
  systems.push(system)
  { ..self, systems, }
}

///|
pub fn App::add_render_pipe(self : App, pipe : (&Backend) -> Unit) -> App {
  let render_pipes = self.render_pipes
  render_pipes.push(pipe)
  { ..self, render_pipes, }
}

///|
pub fn App::run(self : App) -> Unit {
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

  self.backend.build(
    game_loop,
    self.physical_fps,
    render_loop,
    self.canvas_width,
    self.canvas_height,
    self.fps,
  )
}
