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
pub(all) struct BackendConfig {
  startup : () -> Unit
  render_loop : (Double) -> Unit
  game_loop : (Double) -> Unit
  viewport_width : Double
  viewport_height : Double
  screen_width : Double
  screen_height : Double
  fps : UInt
  image_smooth : Bool
}

///|
pub(all) struct Color {
  r : UInt
  g : UInt
  b : UInt
  a : Double
}

///|
pub(all) struct ImageRegion {
  position : @math.Vec2D
  size : @math.Vec2D
}

///|
pub(all) struct ImageDrawCommand {
  path : String
  destination : @math.Rect
  source : ImageRegion?
  transform : @math.Transform
  repeat : @math.RepeatMode
}

///|
pub(all) struct TextStyle {
  family : String
  size : Double
  color : Color
  align : @math.HAlign
  baseline : @math.VAlign
}

///|
pub(all) struct TextDrawCommand {
  text : String
  position : @math.Vec2D
  style : TextStyle
}

///|
pub(all) struct RectDrawCommand {
  rect : @math.Rect
  fill_color : Color
  stroke_color : Color?
}

///|
pub(all) struct CircleDrawCommand {
  center : @math.Vec2D
  radius : Double
  fill_color : Color
  stroke_color : Color?
}

///|
pub(all) struct GradientRectDrawCommand {
  rect : @math.Rect
  color_start : Color
  color_end : Color
}
