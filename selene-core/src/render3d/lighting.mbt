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
pub fn build_cascade_shadow_config3d(
  builder : CascadeShadowConfigBuilder3D,
) -> CascadeShadowConfig3D {
  @render3d_types.build_cascade_shadow_config3d(builder)
}

///|
pub fn set_ambient_light3d(light : AmbientLight3D?) -> Unit {
  render3d_world_state().ambient_light = light
}

///|
pub fn get_ambient_light3d() -> AmbientLight3D? {
  render3d_world_state().ambient_light
}

///|
pub fn set_directional_light_shadow_map3d(
  resource : DirectionalLightShadowMap3D,
) -> Unit {
  let state = render3d_world_state()
  state.directional_shadow_map = {
    size: if resource.size < 1 {
      1
    } else {
      resource.size
    },
  }
}

///|
pub fn get_directional_light_shadow_map3d() -> DirectionalLightShadowMap3D {
  render3d_world_state().directional_shadow_map
}

///|
pub fn set_point_light_shadow_map3d(resource : PointLightShadowMap3D) -> Unit {
  let state = render3d_world_state()
  state.point_shadow_map = {
    size: if resource.size < 1 {
      1
    } else {
      resource.size
    },
  }
}

///|
pub fn get_point_light_shadow_map3d() -> PointLightShadowMap3D {
  render3d_world_state().point_shadow_map
}
