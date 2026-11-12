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
let prepared_frame3d_key : @ecs.ResourceKey[@render3d.RenderFrame3D] = ResourceKey()

///|
fn prepared_frame3d() -> @render3d.RenderFrame3D {
  prepared_frame3d_key.get_or_insert_with(@ecs.require_current_world(), _ => {
    RenderFrame3D()
  })
}

///|
pub fn render3d_prepare_system() -> Unit {
  prepared_frame3d_key.insert_in(
    @ecs.require_current_world(),
    @render3d.get_extracted_frame3d(),
  )
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
