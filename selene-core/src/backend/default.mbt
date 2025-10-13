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
priv struct DefaultBackend {
  mut canvas_width : Double
  mut canvas_height : Double
  mut zoom : Double
}

///|
let default_backend : DefaultBackend = {
  canvas_width: 32,
  canvas_height: 32,
  zoom: 1.0,
}

///|
pub fn initialize(
  startup~ : () -> Unit,
  render_loop~ : (Double) -> Unit,
  game_loop~ : (Double) -> Unit,
  canvas_width~ : Double,
  canvas_height~ : Double,
  fps~ : UInt,
  image_smooth~ : Bool,
  zoom~ : Double,
) -> () -> Unit {
  ignore(startup)
  ignore(render_loop)
  ignore(game_loop)
  default_backend.canvas_width = canvas_width
  default_backend.canvas_height = canvas_height
  ignore(fps)
  ignore(image_smooth)
  default_backend.zoom = zoom
  fn() {  }
}

///|
pub fn draw_picture(
  png~ : String,
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  transform~ : @math.Transform,
  repeat~ : @math.RepeatMode,
) -> Unit {
  ignore(png)
  ignore(x)
  ignore(y)
  ignore(width)
  ignore(height)
  ignore(transform)
  ignore(repeat)
}

///|
pub fn draw_sprite(
  sprite_path~ : String,
  x~ : Double,
  y~ : Double,
  offset_x~ : Double,
  offset_y~ : Double,
  width~ : Double,
  height~ : Double,
  transform~ : @math.Transform,
) -> Unit {
  ignore(sprite_path)
  ignore(x)
  ignore(y)
  ignore(offset_x)
  ignore(offset_y)
  ignore(width)
  ignore(height)
  ignore(transform)
}

///|
pub fn register_key_events(pressed_keys : Set[@inputs.Code]) -> Unit {
  ignore(pressed_keys)
}

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_movement : @inputs.MouseMovement,
) -> Unit {
  ignore(mouse)
  ignore(mouse_movement)
}

///|
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  ignore(locked)
}

///|
pub fn draw_stroke_rect(
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color~ : String,
) -> Unit {
  ignore(x)
  ignore(y)
  ignore(width)
  ignore(height)
  ignore(color)
}

///|
pub fn draw_text(
  text~ : String,
  x~ : Double,
  y~ : Double,
  font~ : String,
  color~ : String,
  align~ : @math.HAlign,
  baseline~ : @math.VAlign,
) -> Unit {
  ignore(text)
  ignore(x)
  ignore(y)
  ignore(font)
  ignore(color)
  ignore(align)
  ignore(baseline)
}

///|
pub fn draw_color_rect(
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color~ : String,
) -> Unit {
  ignore(x)
  ignore(y)
  ignore(width)
  ignore(height)
  ignore(color)
}

///|
pub fn draw_gradient_rect(
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color_start~ : String,
  color_end~ : String,
) -> Unit {
  ignore(x)
  ignore(y)
  ignore(width)
  ignore(height)
  ignore(color_start)
  ignore(color_end)
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  loop_~ : Bool,
) -> Unit {
  ignore(audio_path)
  ignore(volume)
  ignore(loop_)
}

///|
pub fn get_canvas_size() -> @math.Vec2D {
  Vec2D(default_backend.canvas_width, default_backend.canvas_height)
}

///|
pub fn get_zoom() -> Double {
  default_backend.zoom
}

///|
pub fn preload_img(path : String) -> Unit {
  ignore(path)
}

///|
pub fn preload_audio(path : String) -> Unit {
  ignore(path)
}

///|
pub fn set_time_scale(scale : Double) -> Unit {
  ignore(scale)
}

///|
pub fn load_font(font : String, path : String) -> Unit {
  ignore(font)
  ignore(path)
}

///|
pub fn get_realtime_delta() -> Double {
  0.016
}

///|
pub fn get_time_scale() -> Double {
  1.0
}
