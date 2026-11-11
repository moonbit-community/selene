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
#selene.component
pub(all) struct DirectionalLight3D {
  direction : @math.Vec3
  color : @render.Color
  intensity : Double
  shadows : Bool
  shadow_depth_bias : Double
  shadow_normal_bias : Double
  cascade_shadow_config : CascadeShadowConfig3D
}

///|
#selene.component
pub(all) struct PointLight3D {
  color : @render.Color
  intensity : Double
  range : Double
  shadows : Bool
  shadow_depth_bias : Double
  shadow_normal_bias : Double
  shadow_map_near_z : Double
}

///|
pub(all) struct FramePointLight3D {
  position : @math.Vec3
  color : @render.Color
  intensity : Double
  range : Double
  shadows : Bool
  shadow_depth_bias : Double
  shadow_normal_bias : Double
  shadow_map_near_z : Double
}

///|
pub(all) struct FrameSpotLight3D {
  position : @math.Vec3
  direction : @math.Vec3
  color : @render.Color
  intensity : Double
  range : Double
  shadows : Bool
  shadow_depth_bias : Double
  shadow_normal_bias : Double
  shadow_map_near_z : Double
  inner_angle : Double
  outer_angle : Double
}

///|
#selene.component
pub(all) struct SpotLight3D {
  direction : @math.Vec3
  color : @render.Color
  intensity : Double
  range : Double
  shadows : Bool
  shadow_depth_bias : Double
  shadow_normal_bias : Double
  shadow_map_near_z : Double
  inner_angle : Double
  outer_angle : Double
}

///|
pub(all) struct AmbientLight3D {
  color : @render.Color
  intensity : Double
}

///|
pub fn DirectionalLight3D::DirectionalLight3D() -> DirectionalLight3D {
  {
    direction: Vec3(0.0, 0.0, -1.0),
    color: { r: 255U, g: 255U, b: 255U, a: 1.0, },
    intensity: 1.0,
    shadows: false,
    // Match Bevy's current defaults for directional shadow bias tuning.
    shadow_depth_bias: 0.02,
    shadow_normal_bias: 1.8,
    cascade_shadow_config: CascadeShadowConfig3D(),
  }
}

///|
pub fn PointLight3D::PointLight3D() -> PointLight3D {
  {
    color: { r: 255U, g: 255U, b: 255U, a: 1.0, },
    intensity: 1.0,
    range: 0.0,
    shadows: false,
    // Match Bevy's current defaults for point shadow bias tuning.
    shadow_depth_bias: 0.08,
    shadow_normal_bias: 0.6,
    shadow_map_near_z: 0.1,
  }
}

///|
pub fn SpotLight3D::SpotLight3D() -> SpotLight3D {
  {
    direction: Vec3(0.0, 0.0, -1.0),
    color: { r: 255U, g: 255U, b: 255U, a: 1.0, },
    intensity: 1.0,
    range: 0.0,
    shadows: false,
    // Match Bevy's current defaults for spot shadow bias tuning.
    shadow_depth_bias: 0.02,
    shadow_normal_bias: 1.8,
    shadow_map_near_z: 0.1,
    inner_angle: 0.0,
    outer_angle: 0.7853981633974483,
  }
}
