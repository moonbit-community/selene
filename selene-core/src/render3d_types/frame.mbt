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
pub(all) enum CameraProjection3D {
  Perspective
  Orthographic
}

///|
pub extend CameraProjection3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CameraProjection3D with Eq::{not_equal, equal}

///|
pub(all) struct FrameCamera3D {
  position : @math.Vec3
  target : @math.Vec3
  up : @math.Vec3
  fov_y : Double
  projection : CameraProjection3D
  orthographic_size : @math.Vec2?
  near : Double
  far : Double
  clear_color : @render.Color
}

///|
pub(all) struct RenderItem3D {
  entity_id : UInt32?
  transform : @math.Affine3
  mesh : MeshHandle
  material : MaterialHandle
  cast_shadows : Bool
  receive_shadows : Bool
}

///|
#derive(Eq, Debug)
pub(all) struct RenderLine3D {
  start : @math.Vec3
  end : @math.Vec3
  color : @render.Color
}

///|
pub extend RenderLine3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RenderLine3D with Eq::{not_equal, equal}

///|
pub(all) struct RenderFrame3D {
  mut camera : FrameCamera3D?
  mut clear_color : @render.Color
  mut skybox : Skybox3D?
  mut items : Array[RenderItem3D]
  mut lines : Array[RenderLine3D]
  mut directional_lights : Array[DirectionalLight3D]
  mut point_lights : Array[FramePointLight3D]
  mut spot_lights : Array[FrameSpotLight3D]
  mut ambient_light : AmbientLight3D?
  mut directional_shadow_map_size : Int32
  mut point_shadow_map_size : Int32
}

///|
pub fn RenderFrame3D::RenderFrame3D() -> RenderFrame3D {
  {
    camera: None,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0, },
    skybox: None,
    items: [],
    lines: [],
    directional_lights: [],
    point_lights: [],
    spot_lights: [],
    ambient_light: None,
    directional_shadow_map_size: DirectionalLightShadowMap3D().size,
    point_shadow_map_size: PointLightShadowMap3D().size,
  }
}
