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
#derive(Eq, Debug, Hash)
pub(all) struct MeshHandle(UInt32)

///|
#derive(Eq, Debug, Hash)
pub(all) struct MaterialHandle(UInt32)

///|
#derive(Eq, Debug, Hash)
pub(all) struct ImageHandle(UInt32)

///|
#derive(Eq, Debug, Hash)
#selene.component
pub(all) struct SceneHandle(UInt32)

///|
#derive(Eq, Debug, Hash)
pub(all) struct CubemapHandle(UInt32)

///|
#derive(Eq, Debug)
pub(all) enum CameraProjection3D {
  Perspective
  Orthographic
}

///|
#derive(Eq, Debug)
pub(all) enum AlphaMode3D {
  Opaque
  Mask
  Blend
}

///|
#derive(Eq, Debug)
pub(all) enum TextureWrap3D {
  ClampToEdge
  Repeat
  MirroredRepeat
}

///|
#derive(Eq, Debug)
pub(all) enum TextureFilter3D {
  Nearest
  Linear
}

///|
#derive(Eq, Debug)
pub(all) struct TextureSampler3D {
  wrap_u : TextureWrap3D
  wrap_v : TextureWrap3D
  min_filter : TextureFilter3D
  mag_filter : TextureFilter3D
  mipmap_filter : TextureFilter3D?
}

///|
#derive(Eq, Debug)
pub(all) struct TextureTransform3D {
  offset : @math.Vec2
  scale : @math.Vec2
  rotation : Double
}

///|
#derive(Eq, Debug)
pub(all) struct TextureBinding3D {
  image : ImageHandle
  sampler : TextureSampler3D
  texcoord_set : Int32
  transform : TextureTransform3D
}

///|
#derive(Eq, Debug)
pub(all) struct Tangent3D {
  x : Double
  y : Double
  z : Double
  w : Double
}

///|
#derive(Eq, Debug)
pub(all) enum TriangleTopology3D {
  TriangleList
  TriangleStrip
  TriangleFan
}

///|
#derive(Eq, Debug)
pub(all) struct TriangleMesh3D {
  positions : Array[@math.Vec3]
  indices : Array[Int32]?
  topology : TriangleTopology3D
  uv_sets : Array[Array[@math.Vec2]]
  normals : Array[@math.Vec3]?
  tangents : Array[Tangent3D]?
  colors : Array[@render.Color]?
}

///|
#derive(Eq, Debug)
pub(all) enum MeshPrimitive3D {
  Cube(@math.Vec3)
  Sphere(Double)
  Cylinder(Double, Double, Double, Int32)
  Plane(@math.Vec3)
  Triangles(TriangleMesh3D)
}

///|
#derive(Eq, Debug)
pub(all) struct MeshAsset {
  primitive : MeshPrimitive3D
}

///|
#derive(Eq, Debug)
pub(all) struct ImageAsset {
  path : String
}

///|
#derive(Eq, Debug)
pub(all) struct CubemapFaces3D {
  positive_x : ImageHandle
  negative_x : ImageHandle
  positive_y : ImageHandle
  negative_y : ImageHandle
  positive_z : ImageHandle
  negative_z : ImageHandle
}

///|
#derive(Eq, Debug)
pub(all) enum CubemapAsset3D {
  SixFaces(CubemapFaces3D)
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Skybox3D {
  cubemap : CubemapHandle
  brightness : Double
  rotation : @math.Rotation3
}

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
#derive(Eq, Debug)
pub(all) struct DirectionalLightShadowMap3D {
  size : Int32
}

///|
#derive(Eq, Debug)
pub(all) struct PointLightShadowMap3D {
  size : Int32
}

///|
#derive(Eq, Debug)
pub(all) struct CascadeShadowConfigBuilder3D {
  num_cascades : Int32
  minimum_distance : Double
  maximum_distance : Double
  first_cascade_far_bound : Double
  overlap_proportion : Double
}

///|
#derive(Debug)
pub(all) struct CascadeShadowConfig3D {
  bounds : Array[Double]
  minimum_distance : Double
  overlap_proportion : Double
}

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
pub fn TextureSampler3D::TextureSampler3D() -> TextureSampler3D {
  {
    wrap_u: Repeat,
    wrap_v: Repeat,
    min_filter: Linear,
    mag_filter: Linear,
    mipmap_filter: Some(Linear),
  }
}

///|
pub fn TextureTransform3D::TextureTransform3D() -> TextureTransform3D {
  { offset: @math.Vec2::zero(), scale: Vec2(1.0, 1.0), rotation: 0.0, }
}

///|
pub fn apply_texture_transform3d(
  transform : TextureTransform3D,
  uv : @math.Vec2,
) -> @math.Vec2 {
  let scaled = uv * transform.scale
  let sin_rotation = @cmath.sin(transform.rotation)
  let cos_rotation = @cmath.cos(transform.rotation)
  Vec2(
    scaled.x * cos_rotation - scaled.y * sin_rotation + transform.offset.x,
    scaled.x * sin_rotation + scaled.y * cos_rotation + transform.offset.y,
  )
}

///|
pub fn TextureBinding3D::TextureBinding3D(
  image : ImageHandle,
  texcoord_set~ : Int32 = 0,
  sampler~ : TextureSampler3D = TextureSampler3D(),
  transform~ : TextureTransform3D = TextureTransform3D(),
) -> TextureBinding3D {
  { image, sampler, texcoord_set, transform, }
}

///|
pub fn CubemapFaces3D::CubemapFaces3D(
  positive_x : ImageHandle,
  negative_x : ImageHandle,
  positive_y : ImageHandle,
  negative_y : ImageHandle,
  positive_z : ImageHandle,
  negative_z : ImageHandle,
) -> CubemapFaces3D {
  { positive_x, negative_x, positive_y, negative_y, positive_z, negative_z, }
}

///|
pub fn cubemap_asset_six_faces(faces : CubemapFaces3D) -> CubemapAsset3D {
  SixFaces(faces)
}

///|
pub fn Skybox3D::Skybox3D(
  cubemap : CubemapHandle,
  brightness~ : Double = 1.0,
  rotation~ : @math.Rotation3 = @math.Rotation3::identity(),
) -> Skybox3D {
  {
    cubemap,
    brightness: if brightness < 0.0 {
      0.0
    } else {
      brightness
    },
    rotation,
  }
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

///|
pub fn DirectionalLightShadowMap3D::DirectionalLightShadowMap3D() -> DirectionalLightShadowMap3D {
  { size: 2048, }
}

///|
pub fn PointLightShadowMap3D::PointLightShadowMap3D() -> PointLightShadowMap3D {
  { size: 1024, }
}

///|
pub fn CascadeShadowConfigBuilder3D::CascadeShadowConfigBuilder3D() -> CascadeShadowConfigBuilder3D {
  {
    num_cascades: 4,
    minimum_distance: 0.1,
    maximum_distance: 150.0,
    first_cascade_far_bound: 10.0,
    overlap_proportion: 0.2,
  }
}

///|
pub fn build_cascade_shadow_config3d(
  builder : CascadeShadowConfigBuilder3D,
) -> CascadeShadowConfig3D {
  let num_cascades = if builder.num_cascades < 1 {
    1
  } else {
    builder.num_cascades
  }
  let minimum_distance = if builder.minimum_distance < 0.0 {
    0.0
  } else {
    builder.minimum_distance
  }
  let maximum_distance = if builder.maximum_distance <= minimum_distance {
    minimum_distance + 1.0
  } else {
    builder.maximum_distance
  }
  let first_cascade_far_bound = if builder.first_cascade_far_bound <=
    minimum_distance {
    minimum_distance +
    (maximum_distance - minimum_distance) / num_cascades.to_double()
  } else if builder.first_cascade_far_bound >= maximum_distance {
    maximum_distance
  } else {
    builder.first_cascade_far_bound
  }
  let overlap_proportion = if builder.overlap_proportion < 0.0 {
    0.0
  } else if builder.overlap_proportion > 1.0 {
    1.0
  } else {
    builder.overlap_proportion
  }
  let bounds : Array[Double] = []
  if num_cascades == 1 {
    bounds.push(maximum_distance)
  } else {
    let base = @cmath.pow(
      maximum_distance / first_cascade_far_bound,
      1.0 / (num_cascades - 1).to_double(),
    )
    for index in 0..<num_cascades {
      bounds.push(first_cascade_far_bound * @cmath.pow(base, index.to_double()))
    }
  }
  { bounds, minimum_distance, overlap_proportion, }
}

///|
pub fn CascadeShadowConfig3D::CascadeShadowConfig3D() -> CascadeShadowConfig3D {
  build_cascade_shadow_config3d(CascadeShadowConfigBuilder3D())
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
