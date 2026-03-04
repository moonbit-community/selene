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
let prepared_frame3d : Ref[@render3d.RenderFrame3D] = Ref::new(
  @render3d.empty_render_frame3d(),
)

///|
pub fn render3d_prepare_system(_delta : Double) -> Unit {
  prepared_frame3d.val = @render3d.get_extracted_frame3d()
}

///|
pub fn get_prepared_frame3d() -> @render3d.RenderFrame3D {
  prepared_frame3d.val
}
