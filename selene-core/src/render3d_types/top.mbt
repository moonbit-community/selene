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
pub(all) struct MeshHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct MaterialHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct ImageHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct SceneHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) enum CameraProjection3D {
  Perspective
  Orthographic
} derive(Eq, Debug)

///|
pub(all) enum AlphaMode3D {
  Opaque
  Mask
  Blend
} derive(Eq, Debug)

///|
pub(all) enum TextureWrap3D {
  ClampToEdge
  Repeat
  MirroredRepeat
} derive(Eq, Debug)

///|
pub(all) enum TextureFilter3D {
  Nearest
  Linear
} derive(Eq, Debug)

///|
pub(all) struct TextureSampler3D {
  wrap_u : TextureWrap3D
  wrap_v : TextureWrap3D
  min_filter : TextureFilter3D
  mag_filter : TextureFilter3D
  mipmap_filter : TextureFilter3D?
} derive(Eq, Debug)

///|
pub(all) struct TextureTransform3D {
  offset : @math.Vec2D
  scale : @math.Vec2D
  rotation : Double
} derive(Eq, Debug)

///|
pub(all) struct TextureBinding3D {
  image : ImageHandle
  sampler : TextureSampler3D
  texcoord_set : Int
  transform : TextureTransform3D
} derive(Eq, Debug)

///|
pub(all) struct Tangent3D {
  x : Double
  y : Double
  z : Double
  w : Double
} derive(Eq, Debug)

///|
pub(all) enum TriangleTopology3D {
  TriangleList
  TriangleStrip
  TriangleFan
} derive(Eq, Debug)

///|
pub(all) struct TriangleMesh3D {
  positions : Array[@math.Vec3]
  indices : Array[Int]?
  topology : TriangleTopology3D
  uv_sets : Array[Array[@math.Vec2D]]
  normals : Array[@math.Vec3]?
  tangents : Array[Tangent3D]?
  colors : Array[@render.Color]?
} derive(Eq, Debug)

///|
pub(all) enum MeshPrimitive3D {
  Cube(@math.Vec3)
  Sphere(Double)
  Cylinder(Double, Double, Double, Int)
  Plane(@math.Vec3)
  Triangles(TriangleMesh3D)
} derive(Eq, Debug)

///|
pub(all) struct MeshAsset {
  primitive : MeshPrimitive3D
} derive(Eq, Debug)

///|
pub(all) struct ImageAsset {
  path : String
} derive(Eq, Debug)

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
pub(all) struct DirectionalLightShadowMap3D {
  size : Int
} derive(Eq, Debug)

///|
pub(all) struct PointLightShadowMap3D {
  size : Int
} derive(Eq, Debug)

///|
pub(all) struct CascadeShadowConfigBuilder3D {
  num_cascades : Int
  minimum_distance : Double
  maximum_distance : Double
  first_cascade_far_bound : Double
  overlap_proportion : Double
} derive(Eq, Debug)

///|
pub(all) struct CascadeShadowConfig3D {
  bounds : Array[Double]
  minimum_distance : Double
  overlap_proportion : Double
} derive(Debug)

///|
pub(all) struct FrameTransform3D {
  translation : @math.Vec3
  rotation : @math.Quat
  scale : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct FrameCamera3D {
  position : @math.Vec3
  target : @math.Vec3
  up : @math.Vec3
  fov_y : Double
  projection : CameraProjection3D
  orthographic_size : @math.Vec2D?
  near : Double
  far : Double
  clear_color : @render.Color
}

///|
pub(all) struct RenderItem3D {
  entity_id : UInt?
  transform : FrameTransform3D
  mesh : MeshHandle
  material : MaterialHandle
  cast_shadows : Bool
  receive_shadows : Bool
}

///|
pub(all) struct RenderFrame3D {
  mut camera : FrameCamera3D?
  mut clear_color : @render.Color
  mut items : Array[RenderItem3D]
  mut directional_lights : Array[DirectionalLight3D]
  mut point_lights : Array[FramePointLight3D]
  mut spot_lights : Array[FrameSpotLight3D]
  mut ambient_light : AmbientLight3D?
  mut directional_shadow_map_size : Int
  mut point_shadow_map_size : Int
}

///|
pub fn default_texture_sampler3d() -> TextureSampler3D {
  {
    wrap_u: TextureWrap3D::Repeat,
    wrap_v: TextureWrap3D::Repeat,
    min_filter: TextureFilter3D::Linear,
    mag_filter: TextureFilter3D::Linear,
    mipmap_filter: Some(TextureFilter3D::Linear),
  }
}

///|
pub fn default_texture_transform3d() -> TextureTransform3D {
  { offset: @math.Vec2D::zero(), scale: @math.Vec2D(1.0, 1.0), rotation: 0.0 }
}

///|
pub fn apply_texture_transform3d(
  transform : TextureTransform3D,
  uv : @math.Vec2D,
) -> @math.Vec2D {
  let scaled = uv * transform.scale
  let sin_rotation = @cmath.sin(transform.rotation)
  let cos_rotation = @cmath.cos(transform.rotation)
  @math.Vec2D(
    scaled[X] * cos_rotation - scaled[Y] * sin_rotation + transform.offset[X],
    scaled[X] * sin_rotation + scaled[Y] * cos_rotation + transform.offset[Y],
  )
}

///|
pub fn texture_binding3d(
  image : ImageHandle,
  texcoord_set? : Int = 0,
  sampler? : TextureSampler3D = default_texture_sampler3d(),
  transform? : TextureTransform3D = default_texture_transform3d(),
) -> TextureBinding3D {
  { image, sampler, texcoord_set, transform }
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
    directional_shadow_map_size: default_directional_light_shadow_map3d().size,
    point_shadow_map_size: default_point_light_shadow_map3d().size,
  }
}

///|
pub fn default_directional_light_shadow_map3d() -> DirectionalLightShadowMap3D {
  { size: 2048 }
}

///|
pub fn default_point_light_shadow_map3d() -> PointLightShadowMap3D {
  { size: 1024 }
}

///|
pub fn default_cascade_shadow_config_builder3d() -> CascadeShadowConfigBuilder3D {
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
  { bounds, minimum_distance, overlap_proportion }
}

///|
pub fn default_cascade_shadow_config3d() -> CascadeShadowConfig3D {
  build_cascade_shadow_config3d(default_cascade_shadow_config_builder3d())
}

///|
pub fn default_directional_light3d() -> DirectionalLight3D {
  {
    direction: @math.Vec3::new(0.0, 0.0, -1.0),
    color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    intensity: 1.0,
    shadows: false,
    // Match Bevy's current defaults for directional shadow bias tuning.
    shadow_depth_bias: 0.02,
    shadow_normal_bias: 1.8,
    cascade_shadow_config: default_cascade_shadow_config3d(),
  }
}

///|
pub fn default_point_light3d() -> PointLight3D {
  {
    color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
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
pub fn default_spot_light3d() -> SpotLight3D {
  {
    direction: @math.Vec3::new(0.0, 0.0, -1.0),
    color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
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
pub fn default_standard_material3d() -> StandardMaterial3D {
  {
    base_color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    base_color_texture: None,
    normal_texture: None,
    normal_scale: 1.0,
    emissive_texture: None,
    emissive_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
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
