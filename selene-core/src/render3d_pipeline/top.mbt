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
let prepared_frame3d_by_world : Map[UInt, @render3d.RenderFrame3D] = Map([])

///|
fn prepared_frame3d() -> @render3d.RenderFrame3D {
  let world_id = @ecs.require_current_world().id()
  prepared_frame3d_by_world.get_or_init(
    world_id, @render3d.empty_render_frame3d,
  )
}

///|
pub fn render3d_prepare_system(_delta : Double) -> Unit {
  prepared_frame3d_by_world.set(
    @ecs.require_current_world().id(),
    @render3d.get_extracted_frame3d(),
  )
}

///|
pub fn get_prepared_frame3d() -> @render3d.RenderFrame3D {
  prepared_frame3d()
}
