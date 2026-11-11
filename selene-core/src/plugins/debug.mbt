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
pub fn debug_plugin(app : @app.App) -> @app.App {
  let render_prepare = @app.SystemSet("render_prepare")
  let app = add_system(
    app,
    @physics2d.debug_colliders_system,
    RenderPrepare,
    "Debug Collide System",
    in_set=render_prepare,
  )
  add_system(
    app,
    @physics3d.debug_colliders_system,
    RenderPrepare,
    "Debug Collider3D System",
    in_set=render_prepare,
  )
}
