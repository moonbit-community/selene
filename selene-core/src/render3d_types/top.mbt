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
pub(all) struct MeshHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct MaterialHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct ImageHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct SceneHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) enum CameraProjection3D {
  Perspective
  Orthographic
} derive(Eq, Show)

///|
pub(all) enum AlphaMode3D {
  Opaque
  Mask
  Blend
} derive(Eq, Show)

///|
pub(all) enum MeshPrimitive3D {
  Cube(@math3d.Vec3)
  Sphere(Double)
  Cylinder(Double, Double, Double, Int)
  Plane(@math3d.Vec3)
} derive(Eq, Show)

///|
pub(all) struct MeshAsset {
  primitive : MeshPrimitive3D
} derive(Eq, Show)

///|
pub(all) struct ImageAsset {
  path : String
} derive(Eq, Show)

///|
pub(all) struct StandardMaterial3D {
  base_color : @render.Color
  base_color_texture : ImageHandle?
  normal_texture : ImageHandle?
  emissive_texture : ImageHandle?
  emissive_color : @render.Color
  metallic : Double
  roughness : Double
  alpha_mode : AlphaMode3D
}

///|
pub(all) struct DirectionalLight3D {
  direction : @math3d.Vec3
  color : @render.Color
  intensity : Double
  shadows : Bool
}

///|
pub(all) struct PointLight3D {
  color : @render.Color
  intensity : Double
  range : Double
}

///|
pub(all) struct SpotLight3D {
  direction : @math3d.Vec3
  color : @render.Color
  intensity : Double
  range : Double
  inner_angle : Double
  outer_angle : Double
}

///|
pub(all) struct AmbientLight3D {
  color : @render.Color
  intensity : Double
}

///|
pub(all) struct FrameTransform3D {
  translation : @math3d.Vec3
  rotation : @math3d.Quat
  scale : @math3d.Vec3
} derive(Eq, Show)

///|
pub(all) struct FrameCamera3D {
  position : @math3d.Vec3
  target : @math3d.Vec3
  up : @math3d.Vec3
  fov_y : Double
  projection : CameraProjection3D
  near : Double
  far : Double
  clear_color : @render.Color
}

///|
pub(all) struct RenderItem3D {
  transform : FrameTransform3D
  mesh : MeshHandle
  material : MaterialHandle
}

///|
pub(all) struct RenderFrame3D {
  mut camera : FrameCamera3D?
  mut clear_color : @render.Color
  mut items : Array[RenderItem3D]
  mut directional_lights : Array[DirectionalLight3D]
  mut point_lights : Array[PointLight3D]
  mut spot_lights : Array[SpotLight3D]
  mut ambient_light : AmbientLight3D?
}

///|
pub fn empty_render_frame3d() -> RenderFrame3D {
  {
    camera: None,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
    items: [],
    directional_lights: [],
    point_lights: [],
    spot_lights: [],
    ambient_light: None,
  }
}

///|
pub fn default_standard_material3d() -> StandardMaterial3D {
  {
    base_color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    base_color_texture: None,
    normal_texture: None,
    emissive_texture: None,
    emissive_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
    metallic: 0.0,
    roughness: 1.0,
    alpha_mode: Opaque,
  }
}
