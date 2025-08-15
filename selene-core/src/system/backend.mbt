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
/// Texture repetition behavior for drawing operations.
///
/// Constructors:
///
/// * `RepeatX` - Repeat texture only along the X-axis
/// * `RepeatY` - Repeat texture only along the Y-axis
/// * `NoRepeat` - Do not repeat texture in any direction
/// * `Repeat` - Repeat texture in both X and Y directions
///
pub(all) enum RepeatMode {
  RepeatX
  RepeatY
  NoRepeat
  Repeat
}

///|
typealias (&Backend) -> Unit as System

///|
typealias (App) -> Unit as Plugin

///|
pub(all) struct DebugInfo {
  system_execution_time : Map[String, Double]
  fps : Double
}

///| Things need to be done in `build`:
/// - Initialize the backend.
/// - Set the viewport size.
/// - Return the scheduled game loop with a fixed interval (fps).
pub(open) trait Backend {
  build(
    Self,
    systems : Array[(System, Schedule, String)],
    canvas_width : Double,
    canvas_height : Double,
    fps : UInt,
  ) -> () -> Unit
  draw_picture(
    Self,
    png : String,
    x~ : Double,
    y~ : Double,
    width~ : Double,
    height~ : Double,
    transform~ : @math.Transform,
    repeat~ : RepeatMode,
  ) -> Unit
  draw_sprite(
    Self,
    sprite_path : String,
    x~ : Double,
    y~ : Double,
    offset_x~ : Double,
    offset_y~ : Double,
    width~ : Double,
    height~ : Double,
    transform~ : @math.Transform,
  ) -> Unit
  register_key_events(Self, pressed_keys : Set[Code]) -> Unit
  register_mouse_events(Self, mouse : Mouse) -> Unit
  draw_stroke_rect(
    Self,
    x~ : Double,
    y~ : Double,
    width~ : Double,
    height~ : Double,
    color~ : String,
  ) -> Unit
  draw_text(
    Self,
    text : String,
    x~ : Double,
    y~ : Double,
    font~ : String,
    color~ : String,
  ) -> Unit
  draw_color_rect(
    Self,
    x~ : Double,
    y~ : Double,
    width~ : Double,
    height~ : Double,
    color~ : String,
  ) -> Unit
  play_audio(Self, audio_path : String, volume~ : Double, loop_~ : Bool) -> Unit
  get_canvas_size(Self) -> @math.Vec2D
  get_debug_info(Self) -> DebugInfo
  preload_img(Self, path : String) -> Unit
  preload_audio(Self, path : String) -> Unit
}
