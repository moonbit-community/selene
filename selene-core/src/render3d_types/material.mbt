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
pub(all) enum AlphaMode3D {
  Opaque
  Mask
  Blend
}

///|
pub extend AlphaMode3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AlphaMode3D with Eq::{not_equal, equal}

///|
pub(all) struct StandardMaterial3D {
  base_color : @render.Color
  base_color_texture : TextureBinding3D?
  normal_texture : TextureBinding3D?
  normal_scale : Double
  emissive_texture : TextureBinding3D?
  emissive_color : @render.Color
  metallic_roughness_texture : TextureBinding3D?
  occlusion_texture : TextureBinding3D?
  occlusion_strength : Double
  metallic : Double
  roughness : Double
  alpha_mode : AlphaMode3D
  alpha_cutoff : Double
  double_sided : Bool
  unlit : Bool
}

///|
pub fn StandardMaterial3D::StandardMaterial3D() -> StandardMaterial3D {
  {
    base_color: { r: 255U, g: 255U, b: 255U, a: 1.0, },
    base_color_texture: None,
    normal_texture: None,
    normal_scale: 1.0,
    emissive_texture: None,
    emissive_color: { r: 0U, g: 0U, b: 0U, a: 1.0, },
    metallic_roughness_texture: None,
    occlusion_texture: None,
    occlusion_strength: 1.0,
    metallic: 0.0,
    roughness: 1.0,
    alpha_mode: Opaque,
    alpha_cutoff: 0.5,
    double_sided: false,
    unlit: false,
  }
}
