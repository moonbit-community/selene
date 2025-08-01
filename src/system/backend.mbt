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
typealias (&Backend) -> Unit as System

///|
typealias (&Backend) -> Unit as Initializer

///|
typealias (&Backend) -> Unit as RenderPipe

///|
typealias (App) -> Unit as Plugin

///|
pub(open) trait Backend {
  build(
    Self,
    initialize : () -> Unit,
    game_loop : () -> Unit,
    physical_fps : UInt,
    render_loop : () -> Unit,
    canvas_width : Double,
    canvas_height : Double,
    fps : UInt,
  ) -> Unit
  draw_picture(
    Self,
    png : String,
    x~ : Double,
    y~ : Double,
    width~ : Double,
    height~ : Double,
    transform~ : @math.Transform,
    repeat~ : Bool,
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
  register_key_events(
    Self,
    pressed_keys : Set[Code],
    keyup_callbacks : Map[Code, Array[() -> Unit]],
    keydown_callbacks : Map[Code, Array[() -> Unit]],
  ) -> Unit
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
}
