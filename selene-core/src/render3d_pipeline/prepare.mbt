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
let prepared_frame3d_key : @ecs.ResourceKey[Ref[@render3d.RenderFrame3D]] = ResourceKey()

///|
struct PreparedFrame3D {
  frame : Ref[@render3d.RenderFrame3D]
}

///|
pub fn PreparedFrame3D::PreparedFrame3D(world : @ecs.World) -> PreparedFrame3D {
  {
    frame: prepared_frame3d_key.get_or_insert_with(world, _ => {
      Ref(RenderFrame3D())
    }),
  }
}

///|
pub impl @ecs.SystemParam for PreparedFrame3D with fn prepare(world) {
  let frame = PreparedFrame3D(world)
  _ => frame
}

///|
pub extend PreparedFrame3D with @ecs.SystemParam::{prepare}

///|
fn prepared_frame3d() -> @render3d.RenderFrame3D {
  PreparedFrame3D(@ecs.require_current_world()).frame.val
}

///|
pub fn render3d_prepare_system(
  extracted : @render3d.ExtractedFrame3D,
  prepared : PreparedFrame3D,
) -> Unit {
  prepared.frame.val = extracted.get()
}

///|
pub fn push_line3d(line : @render3d.RenderLine3D) -> Unit {
  @render3d.push_line3d(line)
  prepared_frame3d().lines.push(line)
}

///|
pub fn get_prepared_frame3d() -> @render3d.RenderFrame3D {
  prepared_frame3d()
}

///|
pub fn PreparedFrame3D::get(self : PreparedFrame3D) -> @render3d.RenderFrame3D {
  self.frame.val
}

///|
pub fn PreparedFrame3D::push_line(
  self : PreparedFrame3D,
  line : @render3d.RenderLine3D,
) -> Unit {
  self.frame.val.lines.push(line)
}
