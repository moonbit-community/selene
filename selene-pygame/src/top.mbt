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
struct PygameBackend {
  pygame : @python.PyModule
  screen : @python.PyObject
  clock : @python.PyObject
}

///|
pub fn PygameBackend::new() -> PygameBackend {
  guard @python.pyimport("pygame") is Some(pygame)
  guard pygame.get_attr("init") is Some(@python.PyCallable(init_func))
  guard (try? init_func.invoke()) is Ok(_)
  guard pygame.get_attr("display") is Some(@python.PyModule(display))
  guard display.get_attr("set_mode") is Some(@python.PyCallable(set_mode_func))
  let size = @python.PyTuple::new(2)
  size.set(0, @python.PyFloat::from(5.0))
  size.set(1, @python.PyFloat::from(5.0))
  let args = @python.PyTuple::new(1)
  args.set(0, size)
  guard (try? set_mode_func.invoke(args~)) is Ok(Some(PyClass(screen)))
  guard pygame.get_attr("time") is Some(@python.PyModule(time))
  guard time.get_attr("Clock") is Some(@python.PyCallable(clock))
  guard (try? clock.invoke()) is Ok(Some(PyClass(clock)))
  { pygame, screen, clock }
}

///|
pub impl @system.Backend for PygameBackend with build(
  self,
  initialize,
  game_loop,
  canvas_width,
  canvas_height,
  fps,
) {
  let size = @python.PyTuple::new(2)
  size.set(0, @python.PyFloat::from(canvas_width))
  size.set(1, @python.PyFloat::from(canvas_height))
  let args = @python.PyTuple::new(1)
  args.set(0, size)
  guard self.pygame.get_attr("display") is Some(@python.PyModule(display))
  guard display.get_attr("set_mode") is Some(@python.PyCallable(set_mode_func))
  guard (try? set_mode_func.invoke(args~)) is Ok(_)
  initialize()
  return fn() {
    for {
      println("Running game loop...")
      game_loop()
      guard display.get_attr("flip") is Some(@python.PyCallable(flip_func))
      guard (try? flip_func.invoke()) is Ok(_)
      guard self.clock.get_attr("tick") is Some(@python.PyCallable(tick_func))
      let args = @python.PyTuple::new(1)
      args.set(0, @python.PyInteger::from(fps.to_int64()))
      guard (try? tick_func.invoke(args~)) is Ok(_)
    }
  }
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
  guard self.pygame.get_attr("image") is Some(@python.PyModule(image))
  guard image.get_attr("load") is Some(@python.PyCallable(load_func))
  let args = @python.PyTuple::new(1)
  args.set(0, @python.PyString::from(png))
  guard (try? load_func.invoke(args~)) is Ok(Some(PyClass(tile)))
  guard tile.get_attr("get_size") is Some(@python.PyCallable(get_size_func))
  guard (try? get_size_func.invoke())
    is Ok(Some(@python.PyTuple(img_width_height)))
  guard img_width_height.len() == 2
  guard img_width_height.get(0) is Some(@python.PyInteger(img_width))
  guard img_width_height.get(1) is Some(@python.PyInteger(img_height))
  let img_width = img_width.to_double()
  let img_height = img_height.to_double()
  for y = y; y < height + y; y = y + img_height {
    for x = x; x < width + x; x = x + img_width {
      let pos = @python.PyTuple::new(2)
      pos.set(0, @python.PyFloat::from(x))
      pos.set(1, @python.PyFloat::from(y))
      let args = @python.PyTuple::new(2)
      args.set(0, tile)
      args.set(1, pos)
      guard self.screen.get_attr("blit") is Some(@python.PyCallable(blit_func))
      guard (try? blit_func.invoke(args~)) is Ok(_)
    }
  }
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

}

///|
pub impl @system.Backend for PygameBackend with register_key_events(
  self,
  pressed_keys,
  keyup_callbacks,
  keydown_callbacks,
) {

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
  let x : Float = 0.2
  let y = x.exp()
}
