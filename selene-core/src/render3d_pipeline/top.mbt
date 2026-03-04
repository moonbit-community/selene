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
pub fn render3d_submit_system(_delta : Double) -> Unit {
  for pair in @render3d.take_dirty_mesh_assets() {
    @backend.sync_mesh_asset(pair.0, pair.1)
  }
  for pair in @render3d.take_dirty_material_assets() {
    @backend.sync_material_asset(pair.0, pair.1)
  }
  for pair in @render3d.take_dirty_image_assets() {
    @backend.sync_image_asset(pair.0, pair.1)
  }
  for handle in @render3d.take_released_mesh_assets() {
    @backend.release_mesh_asset(handle)
  }
  for handle in @render3d.take_released_material_assets() {
    @backend.release_material_asset(handle)
  }
  for handle in @render3d.take_released_image_assets() {
    @backend.release_image_asset(handle)
  }
  @backend.render_3d_frame(prepared_frame3d.val)
}
