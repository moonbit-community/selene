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
priv struct SceneNodeTemplate {
  name : String?
  transform : @transform.Transform
  renderers : Array[MeshRendererTemplate]
  skin_index : Int?
  morph_weights : Array[Double]
  camera : @camera3d.Camera3DComponent?
  directional_light : @render3d.DirectionalLight3D?
  point_light : @render3d.PointLight3D?
  spot_light : @render3d.SpotLight3D?
  children : Array[Int]
}

///|
priv struct SceneTemplate {
  roots : Array[Int]
  nodes : Array[SceneNodeTemplate]
  skins : Array[SkinTemplate]
  animations : Map[String, @animation.AnimationClipHandle]
}

///|
pub(all) struct SceneInstance {
  root : @entity.Entity
  parts : Map[String, @entity.Entity]
  animations : Map[String, @animation.AnimationNodeIndex]
}

///|
priv struct MeshSceneTemplate {
  renderers : Array[MeshRendererTemplate]
  morph_weights : Array[Double]
  morph_target_count : Int
}

///|
priv struct MeshRendererTemplate {
  renderer : @render3d.Mesh3DRenderer
  skinned : SkinnedPrimitiveTemplate?
}

///|
priv struct MorphTargetTemplate {
  position_deltas : Array[@math.Vec3]?
  normal_deltas : Array[@math.Vec3]?
}

///|
priv struct SkinTemplate {
  joints : Array[Int]
  inverse_bind_matrices : Array[@math.Mat4]
}

///|
priv struct SkinnedPrimitiveTemplate {
  base_positions : Array[@math.Vec3]
  indices : Array[Int]?
  topology : @render3d.TriangleTopology3D
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetTemplate]
  morph_weights : Array[Double]
  influences : Array[@animation.SkinVertexInfluence3D]
}

///|
priv struct PendingSkinBinding {
  entity : @entity.Entity
  target_entity : @entity.Entity
  mesh : @render3d.MeshHandle
  skin_index : Int
  skinned : SkinnedPrimitiveTemplate
}

///|
priv struct ParsedMeshAsset {
  mesh : @render3d.MeshAsset
  skinned : SkinnedPrimitiveTemplate?
}

///|
priv struct AnimationSamplerTemplate {
  times : Array[Double]
  output_accessor : Int
  interpolation : @animation.ChannelInterpolation
}

///|
priv struct ParsedAnimationChannel {
  target : @animation.AnimationTargetId
  translations : Array[@animation.Vec3Keyframe]
  rotations : Array[@animation.QuatKeyframe]
  scales : Array[@animation.Vec3Keyframe]
  weights : Array[@animation.WeightKeyframe]
  interpolation : @animation.ChannelInterpolation
}

///|
priv struct GltfSource {
  document : Json
  glb_buffers : Array[Bytes?]
}

///|
priv struct TextureSourceTemplate {
  image : @render3d.ImageHandle?
  sampler : @render3d.TextureSampler3D
}
