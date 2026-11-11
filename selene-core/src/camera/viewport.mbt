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
#derive(Eq, Debug)
pub(all) struct CameraViewport {
  position : @math.Vec2
  size : @math.Vec2
}

///|
pub extend CameraViewport with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CameraViewport with Eq::{not_equal, equal}

///|
pub fn CameraViewport::CameraViewport(
  position : @math.Vec2,
  size : @math.Vec2,
) -> CameraViewport {
  let width = if size.x < 0.0 { 0.0 } else { size.x }
  let height = if size.y < 0.0 { 0.0 } else { size.y }
  { position, size: Vec2(width, height), }
}

///|
pub fn CameraViewport::from_rect(rect : @math.Rect) -> CameraViewport {
  CameraViewport(rect.position, rect.size)
}

///|
pub fn CameraViewport::rect(self : CameraViewport) -> @math.Rect {
  { position: self.position, size: self.size, }
}

///|
#derive(Eq, Debug)
pub(all) enum CameraPassLoadOp2D {
  Load
  Clear
}

///|
pub extend CameraPassLoadOp2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CameraPassLoadOp2D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum CameraPassTarget2D {
  Screen
  Offscreen(String)
}

///|
pub extend CameraPassTarget2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CameraPassTarget2D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct CameraPass2D {
  load_op : CameraPassLoadOp2D
  clear_color : @render.Color
  target : CameraPassTarget2D
}

///|
pub extend CameraPass2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CameraPass2D with Eq::{not_equal, equal}

///|
fn default_camera_clear_color() -> @render.Color {
  { r: 0U, g: 0U, b: 0U, a: 1.0, }
}

///|
pub fn CameraPass2D::CameraPass2D(
  load_op~ : CameraPassLoadOp2D = Load,
  clear_color~ : @render.Color = default_camera_clear_color(),
  target~ : CameraPassTarget2D = Screen,
) -> CameraPass2D {
  { load_op, clear_color, target, }
}
