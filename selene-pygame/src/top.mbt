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

///| If you want to support the Pygame backend, implement the 
/// @system.Backend trait for the PygameBackend type.
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
