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

///| Original python code 
/// ```python
/// import pygame
/// pygame.init()
/// screen = pygame.display.set_mode((1280, 720))
/// clock = pygame.time.Clock()
/// running = True
/// while running:
///     for event in pygame.event.get():
///         if event.type == pygame.QUIT:
///             running = False
///     screen.fill("purple")
///     pygame.display.flip()
///     clock.tick(60)
/// pygame.quit()
/// ```
// test {
//   guard @python.pyimport("pygame") is Some(pygame) else {
//     fail("Failed to import pygame")
//   }
//   guard pygame.get_attr("init") is Some(@python.PyCallable(init_func)) else {
//     fail("Failed to get pygame.init function")
//   }
//   try init_func.invoke() |> ignore catch {
//     e => fail("Failed to initialize pygame: \{e}")
//   }
//   guard pygame.get_attr("display") is Some(@python.PyModule(display)) else {
//     fail("Failed to get pygame.display")
//   }
//   guard display.get_attr("set_mode") is Some(@python.PyCallable(set_mode_func)) else {
//     fail("Failed to get pygame.display.set_mode function")
//   }
//   let size = @python.PyTuple::new(2)
//   size.set(0, @python.PyFloat::from(800.0))
//   size.set(1, @python.PyFloat::from(600.0))
//   let args = @python.PyTuple::new(1)
//   args.set(0, size)
//   let screen = set_mode_func.invoke(args~) catch {
//     e => fail("Failed to set display mode: \{e}")
//   }
//   guard screen is Some(@python.PyClass(screen)) else {
//     fail("Failed to get screen object")
//   }
//   guard screen.get_attr("fill") is Some(@python.PyCallable(fill_func)) else {
//     fail("Failed to get screen.fill function")
//   }
//   let args = @python.PyTuple::new(1)
//   args.set(0, @python.PyString::from("purple"))
//   try fill_func.invoke(args~) |> ignore catch {
//     e => fail("Failed to fill screen: \{e}")
//   }
// }

///|
struct PygameBackend {}

///|
pub fn PygameBackend::new() -> PygameBackend {
  ...
}

///|
pub impl @system.Backend for PygameBackend with build(
  self,
  initialize,
  game_loop,
  physical_fps,
  render_loop,
  canvas_width,
  canvas_height,
  fps,
) {
  ...
}

///|
pub impl @system.Backend for PygameBackend with draw_picture(
  self,
  png,
  x~,
  y~,
  width~,
  height~,
  transform~,
  repeat~,
) {
  ...
}

///|
pub impl @system.Backend for PygameBackend with draw_sprite(
  self,
  sprite_path,
  x~,
  y~,
  offset_x~,
  offset_y~,
  width~,
  height~,
  transform~,
) {
  ...
}

///|
pub impl @system.Backend for PygameBackend with register_key_events(
  self,
  pressed_keys,
  keyup_callbacks,
  keydown_callbacks,
) {
  ...
}

///|
pub impl @system.Backend for PygameBackend with draw_stroke_rect(
  self,
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color~ : String,
) {
  ...
}

///|
pub impl @system.Backend for PygameBackend with draw_text(
  self,
  text : String,
  x~ : Double,
  y~ : Double,
  font~ : String,
  color~ : String,
) {
  ...
}
