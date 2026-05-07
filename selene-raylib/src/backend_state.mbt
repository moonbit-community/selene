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
priv struct LightingShaderState {
  shader : @raylib.Shader
  ambient_light_loc : Int
  view_position_loc : Int
  view_forward_loc : Int
  directional_count_loc : Int
  directional_directions_loc : Int
  directional_colors_loc : Int
  point_count_loc : Int
  point_positions_loc : Int
  point_colors_loc : Int
  point_ranges_loc : Int
  spot_count_loc : Int
  spot_positions_loc : Int
  spot_directions_loc : Int
  spot_colors_loc : Int
  spot_params_loc : Int
  material_base_color_loc : Int
  material_emissive_color_loc : Int
  material_normal_scale_loc : Int
  material_occlusion_strength_loc : Int
  material_metallic_loc : Int
  material_roughness_loc : Int
  material_alpha_mode_loc : Int
  material_alpha_cutoff_loc : Int
  material_has_base_texture_loc : Int
  material_has_emissive_texture_loc : Int
  material_has_metallic_roughness_texture_loc : Int
  material_has_occlusion_texture_loc : Int
  material_has_normal_texture_loc : Int
  material_has_tangents_loc : Int
  material_unlit_loc : Int
  material_receive_shadows_loc : Int
  shadow_enabled_locs : Array[Int]
  shadow_cascade_count_locs : Array[Int]
  shadow_matrix_locs : Array[Int]
  shadow_rect_locs : Array[Int]
  shadow_bound_locs : Array[Int]
  shadow_depth_bias_locs : Array[Int]
  shadow_normal_bias_locs : Array[Int]
  shadow_sampler_locs : Array[Int]
  directional_shadow_texel_size_loc : Int
  spot_shadow_enabled_locs : Array[Int]
  spot_shadow_matrix_locs : Array[Int]
  spot_shadow_rect_locs : Array[Int]
  spot_shadow_depth_bias_locs : Array[Int]
  spot_shadow_normal_bias_locs : Array[Int]
  spot_shadow_sampler_loc : Int
  spot_shadow_texel_size_loc : Int
  point_shadow_enabled_locs : Array[Int]
  point_shadow_depth_bias_locs : Array[Int]
  point_shadow_normal_bias_locs : Array[Int]
  point_shadow_matrix_locs : Array[Int]
  point_shadow_rect_locs : Array[Int]
  point_shadow_sampler_loc : Int
  point_shadow_texel_size_loc : Int
  base_uv_offset_scale_loc : Int
  base_uv_rotation_loc : Int
  base_uv_set_loc : Int
  metallic_roughness_uv_offset_scale_loc : Int
  metallic_roughness_uv_rotation_loc : Int
  metallic_roughness_uv_set_loc : Int
  normal_uv_offset_scale_loc : Int
  normal_uv_rotation_loc : Int
  normal_uv_set_loc : Int
  occlusion_uv_offset_scale_loc : Int
  occlusion_uv_rotation_loc : Int
  occlusion_uv_set_loc : Int
  emissive_uv_offset_scale_loc : Int
  emissive_uv_rotation_loc : Int
  emissive_uv_set_loc : Int
}

///|
priv struct MaterialTextureBundle3D {
  base_texture : @raylib.Texture
  emissive_texture : @raylib.Texture
  metallic_roughness_texture : @raylib.Texture
  occlusion_texture : @raylib.Texture
  normal_texture : @raylib.Texture
  has_base_texture : Bool
  has_emissive_texture : Bool
  has_metallic_roughness_texture : Bool
  has_occlusion_texture : Bool
  has_normal_texture : Bool
  base_transform : @render3d_types.TextureTransform3D
  emissive_transform : @render3d_types.TextureTransform3D
  metallic_roughness_transform : @render3d_types.TextureTransform3D
  occlusion_transform : @render3d_types.TextureTransform3D
  normal_transform : @render3d_types.TextureTransform3D
  base_texcoord_set : Int
  emissive_texcoord_set : Int
  metallic_roughness_texcoord_set : Int
  occlusion_texcoord_set : Int
  normal_texcoord_set : Int
}

///|
priv struct MaterialTextureSource3D {
  texture : @raylib.Texture
  texcoord_set : Int
  transform : @render3d_types.TextureTransform3D
}

///|
priv struct MaterialTextureSlotBinding {
  shader_loc : Int
  uniform_name : String
  slot : Int
  material_map : Int
}

///|
priv struct CosmicRasterImage {
  width : Int
  height : Int
  pixels : Array[Int]
}

///|
priv struct CosmicTextTexture {
  texture : @raylib.Texture
  width : Int
  height : Int
}

///|
priv struct OffscreenTarget2D {
  render_texture : @raylib.RenderTexture
  width : Int
  height : Int
}

///|
priv struct RaylibBackend {
  mut time_scale : Double
  mut image_smooth : Bool
  mut realtime_delta : Double
  mut embedded_asset_lookup : (String) -> Bytes?
  mut key_events : Set[@inputs.Code]?
  mut mouse_state : @inputs.Mouse?
  mut mouse_movement : @inputs.MouseMovement?
  mut mouse_wheel : @inputs.MouseWheel?
  mut gamepads_state : Set[@inputs.Gamepad]?
  mut gamepad_buttons_state : Set[@inputs.GamepadButtonInput]?
  mut gamepad_axes_state : Map[@inputs.GamepadAxisInput, Double]?
  mut lock_state : Ref[Bool]?
  mut lock_requested : Bool
  mut cursor_locked : Bool
  mut close_requested : Bool
  mut frame_has_draw_commands : Bool
  textures : Map[String, @raylib.Texture]
  sounds : Map[String, @raylib.Sound]
  audio_instances : Map[AudioInstance, AudioPlayback]
  mut next_audio_instance : UInt
  font_alias : Map[String, String]
  fonts_by_path : Map[String, @raylib.Font]
  cosmic_loaded_families : Set[String]
  cosmic_textures : Map[String, CosmicTextTexture]
  offscreen_targets_2d : Map[String, OffscreenTarget2D]
  mut active_2d_offscreen_target : String?
  mut embedded_asset_cache : Map[String, Bytes]
  meshes3d : Map[@render3d_types.MeshHandle, @render3d_types.MeshAsset]
  materials3d : Map[
    @render3d_types.MaterialHandle,
    @render3d_types.StandardMaterial3D,
  ]
  images3d : Map[@render3d_types.ImageHandle, @render3d_types.ImageAsset]
  primitive_meshes : Map[String, @raylib.Mesh]
  triangle_mesh_cache : Map[String, @raylib.Mesh]
  mut lighting_shader : LightingShaderState?
  mut lit_material : @raylib.Material?
  mut lit_textured_material : @raylib.Material?
  mut shadow_shader : ShadowShaderState?
  mut shadow_material : @raylib.Material?
  shadow_render_textures : Array[@raylib.RenderTexture]
  directional_shadow_tile_sizes : Array[Int]
  directional_shadow_atlas_columns : Array[Int]
  directional_shadow_atlas_rows : Array[Int]
  mut spot_shadow_render_texture : @raylib.RenderTexture?
  mut spot_shadow_map_size : Int
  mut point_shadow_render_texture : @raylib.RenderTexture?
  mut point_shadow_map_size : Int
  texture_warning_keys : Set[String]
}

///|
pub type AudioInstance = Int

///|
priv enum AudioPlaybackKind {
  Sound(@raylib.Sound)
  Music(@raylib.Music)
}

///|
priv struct AudioPlayback {
  kind : AudioPlaybackKind
  mut loop_ : Bool
  mut paused : Bool
  mut started : Bool
  mut finished : Bool
}

///|
let backend : RaylibBackend = {
  time_scale: 1.0,
  image_smooth: true,
  realtime_delta: 0.016,
  embedded_asset_lookup: default_embedded_asset_lookup,
  key_events: None,
  mouse_state: None,
  mouse_movement: None,
  mouse_wheel: None,
  gamepads_state: None,
  gamepad_buttons_state: None,
  gamepad_axes_state: None,
  lock_state: None,
  lock_requested: false,
  cursor_locked: false,
  close_requested: false,
  frame_has_draw_commands: false,
  textures: Map([]),
  sounds: Map([]),
  audio_instances: Map([]),
  next_audio_instance: 1U,
  font_alias: Map([]),
  fonts_by_path: Map([]),
  cosmic_loaded_families: Set([]),
  cosmic_textures: Map([]),
  offscreen_targets_2d: Map([]),
  active_2d_offscreen_target: None,
  embedded_asset_cache: Map([]),
  meshes3d: Map([]),
  materials3d: Map([]),
  images3d: Map([]),
  primitive_meshes: Map([]),
  triangle_mesh_cache: Map([]),
  lighting_shader: None,
  lit_material: None,
  lit_textured_material: None,
  shadow_shader: None,
  shadow_material: None,
  shadow_render_textures: [],
  directional_shadow_tile_sizes: [],
  directional_shadow_atlas_columns: [],
  directional_shadow_atlas_rows: [],
  spot_shadow_render_texture: None,
  spot_shadow_map_size: 0,
  point_shadow_render_texture: None,
  point_shadow_map_size: 0,
  texture_warning_keys: Set([]),
}

///|
let clip_stack : Array[@smath.Rect] = []

///|
let cosmic_font_system : Ref[@cosmic.FontSystem] = Ref(
  @cosmic.FontSystem::new(),
)

///|
let cosmic_swash_cache : Ref[@cosmic.SwashCache] = Ref(
  @cosmic.SwashCache::new(),
)

///|
const MAX_DIRECTIONAL_LIGHTS : Int = 4

///|
const MAX_DIRECTIONAL_CASCADES : Int = 4

///|
const MAX_POINT_LIGHTS : Int = 8

///|
const MAX_SPOT_LIGHTS : Int = 4

///|
let raylib_lighting_vertex_shader : String = "#version 330\n" +
  "in vec3 vertexPosition;\n" +
  "in vec2 vertexTexCoord;\n" +
  "in vec2 vertexTexCoord2;\n" +
  "in vec3 vertexNormal;\n" +
  "in vec4 vertexTangent;\n" +
  "in vec4 vertexColor;\n" +
  "uniform mat4 mvp;\n" +
  "uniform mat4 matModel;\n" +
  "uniform mat4 matNormal;\n" +
  "out vec3 fragPosition;\n" +
  "out vec2 fragTexCoord;\n" +
  "out vec2 fragTexCoord2;\n" +
  "out vec3 fragNormal;\n" +
  "out vec4 fragTangent;\n" +
  "out vec4 fragVertexColor;\n" +
  "void main() {\n" +
  "  vec4 worldPosition = matModel * vec4(vertexPosition, 1.0);\n" +
  "  fragPosition = worldPosition.xyz;\n" +
  "  fragTexCoord = vertexTexCoord;\n" +
  "  fragTexCoord2 = vertexTexCoord2;\n" +
  "  fragNormal = normalize((matNormal * vec4(vertexNormal, 0.0)).xyz);\n" +
  "  vec3 tangent = normalize((matNormal * vec4(vertexTangent.xyz, 0.0)).xyz);\n" +
  "  fragTangent = vec4(tangent, vertexTangent.w);\n" +
  "  fragVertexColor = vertexColor;\n" +
  "  gl_Position = mvp * vec4(vertexPosition, 1.0);\n" +
  "}\n"

///|
let raylib_lighting_fragment_shader : String = "#version 330\n" +
  "in vec3 fragPosition;\n" +
  "in vec2 fragTexCoord;\n" +
  "in vec2 fragTexCoord2;\n" +
  "in vec3 fragNormal;\n" +
  "in vec4 fragTangent;\n" +
  "in vec4 fragVertexColor;\n" +
  "uniform sampler2D texture0;\n" +
  "uniform sampler2D texture1;\n" +
  "uniform sampler2D texture2;\n" +
  "uniform sampler2D texture4;\n" +
  "uniform sampler2D texture5;\n" +
  "uniform vec3 ambientLight;\n" +
  "uniform vec3 viewPosition;\n" +
  "uniform vec3 viewForward;\n" +
  "uniform int directionalCount;\n" +
  "uniform vec3 directionalDirections[4];\n" +
  "uniform vec3 directionalColors[4];\n" +
  "uniform int pointCount;\n" +
  "uniform vec3 pointPositions[8];\n" +
  "uniform vec3 pointColors[8];\n" +
  "uniform float pointRanges[8];\n" +
  "uniform int spotCount;\n" +
  "uniform vec3 spotPositions[4];\n" +
  "uniform vec3 spotDirections[4];\n" +
  "uniform vec3 spotColors[4];\n" +
  "uniform vec3 spotParams[4];\n" +
  "uniform vec4 materialBaseColor;\n" +
  "uniform vec3 materialEmissiveColor;\n" +
  "uniform float materialNormalScale;\n" +
  "uniform float materialOcclusionStrength;\n" +
  "uniform float materialMetallic;\n" +
  "uniform float materialRoughness;\n" +
  "uniform int materialAlphaMode;\n" +
  "uniform float materialAlphaCutoff;\n" +
  "uniform int materialHasBaseTexture;\n" +
  "uniform int materialHasEmissiveTexture;\n" +
  "uniform int materialHasMetallicRoughnessTexture;\n" +
  "uniform int materialHasOcclusionTexture;\n" +
  "uniform int materialHasNormalTexture;\n" +
  "uniform int materialHasTangents;\n" +
  "uniform int materialUnlit;\n" +
  "uniform int materialReceiveShadows;\n" +
  "uniform int shadowEnabled[4];\n" +
  "uniform int shadowCascadeCounts[4];\n" +
  "uniform sampler2D shadowMap0;\n" +
  "uniform sampler2D shadowMap1;\n" +
  "uniform sampler2D shadowMap2;\n" +
  "uniform sampler2D shadowMap3;\n" +
  "uniform mat4 shadowMatrices[16];\n" +
  "uniform vec4 shadowRects[16];\n" +
  "uniform vec2 shadowBounds[16];\n" +
  "uniform float shadowDepthBiases[4];\n" +
  "uniform float shadowNormalBiases[4];\n" +
  "uniform vec2 directionalShadowTexelSize;\n" +
  "uniform int spotShadowEnabled[4];\n" +
  "uniform sampler2D spotShadowAtlas;\n" +
  "uniform mat4 spotShadowMatrices[4];\n" +
  "uniform vec4 spotShadowRects[4];\n" +
  "uniform float spotShadowDepthBiases[4];\n" +
  "uniform float spotShadowNormalBiases[4];\n" +
  "uniform vec2 spotShadowTexelSize;\n" +
  "uniform int pointShadowEnabled[8];\n" +
  "uniform sampler2D pointShadowAtlas;\n" +
  "uniform mat4 pointShadowMatrices[48];\n" +
  "uniform vec4 pointShadowRects[48];\n" +
  "uniform float pointShadowDepthBiases[8];\n" +
  "uniform float pointShadowNormalBiases[8];\n" +
  "uniform vec2 pointShadowTexelSize;\n" +
  "uniform vec4 baseUvOffsetScale;\n" +
  "uniform vec2 baseUvRotation;\n" +
  "uniform int baseUvSet;\n" +
  "uniform vec4 metallicRoughnessUvOffsetScale;\n" +
  "uniform vec2 metallicRoughnessUvRotation;\n" +
  "uniform int metallicRoughnessUvSet;\n" +
  "uniform vec4 normalUvOffsetScale;\n" +
  "uniform vec2 normalUvRotation;\n" +
  "uniform int normalUvSet;\n" +
  "uniform vec4 occlusionUvOffsetScale;\n" +
  "uniform vec2 occlusionUvRotation;\n" +
  "uniform int occlusionUvSet;\n" +
  "uniform vec4 emissiveUvOffsetScale;\n" +
  "uniform vec2 emissiveUvRotation;\n" +
  "uniform int emissiveUvSet;\n" +
  "out vec4 finalColor;\n" +
  "float rangeAttenuation(float distanceToLight, float lightRange) {\n" +
  "  if (lightRange <= 0.000001) return 1.0;\n" +
  "  if (distanceToLight >= lightRange) return 0.0;\n" +
  "  float t = 1.0 - distanceToLight / lightRange;\n" +
  "  return t * t;\n" +
  "}\n" +
  "vec2 selectUv(int setIndex) {\n" +
  "  if (setIndex == 1) return fragTexCoord2;\n" +
  "  return fragTexCoord;\n" +
  "}\n" +
  "vec2 applyTextureTransform(vec2 uv, vec4 offsetScale, vec2 rotationSinCos) {\n" +
  "  vec2 scaled = uv * offsetScale.zw;\n" +
  "  return vec2(\n" +
  "    scaled.x * rotationSinCos.y - scaled.y * rotationSinCos.x + offsetScale.x,\n" +
  "    scaled.x * rotationSinCos.x + scaled.y * rotationSinCos.y + offsetScale.y\n" +
  "  );\n" +
  "}\n" +
  "float spotAttenuation(vec3 spotDirection, vec3 lightToFragment, vec3 params) {\n" +
  "  float inner = max(params.y, params.z);\n" +
  "  float outer = min(params.y, params.z);\n" +
  "  float cosTheta = dot(normalize(spotDirection), normalize(lightToFragment));\n" +
  "  float delta = inner - outer;\n" +
  "  if (cosTheta <= outer) return 0.0;\n" +
  "  if (cosTheta >= inner || abs(delta) <= 0.000001) return 1.0;\n" +
  "  return (cosTheta - outer) / delta;\n" +
  "}\n" +
  "mat3 cotangentFrame(vec3 normal, vec3 worldPosition, vec2 uv) {\n" +
  "  vec3 dp1 = dFdx(worldPosition);\n" +
  "  vec3 dp2 = dFdy(worldPosition);\n" +
  "  vec2 duv1 = dFdx(uv);\n" +
  "  vec2 duv2 = dFdy(uv);\n" +
  "  vec3 dp2perp = cross(dp2, normal);\n" +
  "  vec3 dp1perp = cross(normal, dp1);\n" +
  "  vec3 tangent = dp2perp * duv1.x + dp1perp * duv2.x;\n" +
  "  vec3 bitangent = dp2perp * duv1.y + dp1perp * duv2.y;\n" +
  "  float scale = max(dot(tangent, tangent), dot(bitangent, bitangent));\n" +
  "  if (scale <= 0.000001) return mat3(1.0);\n" +
  "  float invScale = inversesqrt(scale);\n" +
  "  return mat3(tangent * invScale, bitangent * invScale, normal);\n" +
  "}\n" +
  "vec3 applyNormalMap(vec3 normal, vec3 worldPosition, vec2 uv) {\n" +
  "  vec3 mapNormal = texture(texture2, uv).xyz * 2.0 - 1.0;\n" +
  "  mapNormal.xy *= materialNormalScale;\n" +
  "  mapNormal = normalize(mapNormal);\n" +
  "  mat3 tbn = cotangentFrame(normal, worldPosition, uv);\n" +
  "  if (materialHasTangents != 0) {\n" +
  "    vec3 tangent = normalize(fragTangent.xyz);\n" +
  "    vec3 bitangent = normalize(cross(normal, tangent) * fragTangent.w);\n" +
  "    if (dot(tangent, tangent) > 0.000001 && dot(bitangent, bitangent) > 0.000001) {\n" +
  "      tbn = mat3(tangent, bitangent, normal);\n" +
  "    }\n" +
  "  }\n" +
  "  return normalize(tbn * mapNormal);\n" +
  "}\n" +
  "void addLight(\n" +
  "  vec3 lightDir,\n" +
  "  vec3 lightColor,\n" +
  "  float attenuation,\n" +
  "  vec3 normal,\n" +
  "  vec3 viewDir,\n" +
  "  float shininess,\n" +
  "  float specularStrength,\n" +
  "  inout vec3 diffuseLight,\n" +
  "  inout vec3 specularLight\n" +
  ") {\n" +
  "  if (attenuation <= 0.0) return;\n" +
  "  float lambert = max(dot(normal, lightDir), 0.0);\n" +
  "  if (lambert <= 0.0) return;\n" +
  "  diffuseLight += lightColor * (lambert * attenuation);\n" +
  "  vec3 halfway = normalize(lightDir + viewDir);\n" +
  "  float spec = pow(max(dot(normal, halfway), 0.0), shininess) * specularStrength;\n" +
  "  specularLight += lightColor * (spec * attenuation);\n" +
  "}\n" +
  "float sampleShadowMapDepth(int index, vec2 uv) {\n" +
  "  if (index == 0) return texture(shadowMap0, uv).r;\n" +
  "  if (index == 1) return texture(shadowMap1, uv).r;\n" +
  "  if (index == 2) return texture(shadowMap2, uv).r;\n" +
  "  if (index == 3) return texture(shadowMap3, uv).r;\n" +
  "  return 1.0;\n" +
  "}\n" +
  "float sampleShadowAtlasDepth(sampler2D atlasTexture, vec2 uv, vec4 atlasRect) {\n" +
  "  return texture(atlasTexture, atlasRect.xy + uv * atlasRect.zw).r;\n" +
  "}\n" +
  "float sampleDirectionalShadowCascade(int lightIndex, int cascadeIndex, vec3 normal, vec3 lightDir) {\n" +
  "  int matrixIndex = lightIndex * 4 + cascadeIndex;\n" +
  "  vec4 atlasRect = shadowRects[matrixIndex];\n" +
  "  if (atlasRect.z <= 0.0 || atlasRect.w <= 0.0) return 1.0;\n" +
  "  vec4 shadowClip = shadowMatrices[matrixIndex] * vec4(fragPosition, 1.0);\n" +
  "  if (abs(shadowClip.w) <= 0.00001) return 1.0;\n" +
  "  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;\n" +
  "  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;\n" +
  "  float shadowDepth = shadowNdc.z * 0.5 + 0.5;\n" +
  "  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;\n" +
  "  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;\n" +
  "  float texel = max(directionalShadowTexelSize.x, directionalShadowTexelSize.y);\n" +
  "  float ndotl = max(dot(normal, lightDir), 0.0);\n" +
  "  float bias = max(0.0, shadowDepthBiases[lightIndex]) + max(0.0, shadowNormalBiases[lightIndex]) * texel * (1.0 - ndotl);\n" +
  "  float filterRadius = 1.25;\n" +
  "  float lit = 0.0;\n" +
  "  float totalWeight = 0.0;\n" +
  "  for (int x = -1; x <= 1; x++) {\n" +
  "    for (int y = -1; y <= 1; y++) {\n" +
  "      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));\n" +
  "      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * directionalShadowTexelSize * filterRadius;\n" +
  "      float closest = sampleShadowMapDepth(lightIndex, clamp(atlasRect.xy + sampleUv * atlasRect.zw, vec2(0.0), vec2(1.0)));\n" +
  "      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;\n" +
  "      totalWeight += weight;\n" +
  "    }\n" +
  "  }\n" +
  "  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;\n" +
  "}\n" +
  "float sampleDirectionalShadow(int index, vec3 normal, vec3 lightDir) {\n" +
  "  if (materialReceiveShadows == 0 || index < 0 || index >= 4 || shadowEnabled[index] == 0) return 1.0;\n" +
  "  int cascadeCount = shadowCascadeCounts[index];\n" +
  "  if (cascadeCount <= 0) return 1.0;\n" +
  "  float viewDepth = dot(fragPosition - viewPosition, viewForward);\n" +
  "  int baseIndex = index * 4;\n" +
  "  float firstNear = shadowBounds[baseIndex].x;\n" +
  "  float lastFar = shadowBounds[baseIndex + cascadeCount - 1].y;\n" +
  "  if (viewDepth < firstNear || viewDepth > lastFar) return 1.0;\n" +
  "  int selected = cascadeCount - 1;\n" +
  "  for (int i = 0; i < 4; i++) {\n" +
  "    if (i >= cascadeCount) break;\n" +
  "    if (viewDepth <= shadowBounds[baseIndex + i].y) {\n" +
  "      selected = i;\n" +
  "      break;\n" +
  "    }\n" +
  "  }\n" +
  "  float shadow = sampleDirectionalShadowCascade(index, selected, normal, lightDir);\n" +
  "  if (selected > 0) {\n" +
  "    int previous = selected - 1;\n" +
  "    float overlapNear = shadowBounds[baseIndex + selected].x;\n" +
  "    float overlapFar = shadowBounds[baseIndex + previous].y;\n" +
  "    if (overlapNear < overlapFar && viewDepth >= overlapNear && viewDepth <= overlapFar) {\n" +
  "      float blend = clamp((viewDepth - overlapNear) / (overlapFar - overlapNear), 0.0, 1.0);\n" +
  "      shadow = mix(sampleDirectionalShadowCascade(index, previous, normal, lightDir), shadow, blend);\n" +
  "    }\n" +
  "  }\n" +
  "  return shadow;\n" +
  "}\n" +
  "float sampleSpotShadow(int index, vec3 normal, vec3 lightDir) {\n" +
  "  if (materialReceiveShadows == 0 || index < 0 || index >= 4 || spotShadowEnabled[index] == 0) return 1.0;\n" +
  "  vec4 shadowClip = spotShadowMatrices[index] * vec4(fragPosition, 1.0);\n" +
  "  if (abs(shadowClip.w) <= 0.00001) return 1.0;\n" +
  "  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;\n" +
  "  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;\n" +
  "  float shadowDepth = shadowNdc.z * 0.5 + 0.5;\n" +
  "  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;\n" +
  "  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;\n" +
  "  float texel = max(spotShadowTexelSize.x, spotShadowTexelSize.y);\n" +
  "  float ndotl = max(dot(normal, lightDir), 0.0);\n" +
  "  float bias = max(0.0, spotShadowDepthBiases[index]) + max(0.0, spotShadowNormalBiases[index]) * texel * (1.0 - ndotl);\n" +
  "  float filterRadius = 1.25;\n" +
  "  float lit = 0.0;\n" +
  "  float totalWeight = 0.0;\n" +
  "  for (int x = -1; x <= 1; x++) {\n" +
  "    for (int y = -1; y <= 1; y++) {\n" +
  "      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));\n" +
  "      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * spotShadowTexelSize * filterRadius;\n" +
  "      float closest = sampleShadowAtlasDepth(spotShadowAtlas, clamp(sampleUv, vec2(0.0), vec2(1.0)), spotShadowRects[index]);\n" +
  "      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;\n" +
  "      totalWeight += weight;\n" +
  "    }\n" +
  "  }\n" +
  "  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;\n" +
  "}\n" +
  "int selectPointShadowFace(vec3 dir) {\n" +
  "  vec3 absDir = abs(dir);\n" +
  "  if (absDir.x >= absDir.y && absDir.x >= absDir.z) return dir.x >= 0.0 ? 0 : 1;\n" +
  "  if (absDir.y >= absDir.x && absDir.y >= absDir.z) return dir.y >= 0.0 ? 2 : 3;\n" +
  "  return dir.z >= 0.0 ? 4 : 5;\n" +
  "}\n" +
  "float samplePointShadow(int index, vec3 normal, vec3 lightDir, vec3 lightToFragment) {\n" +
  "  if (materialReceiveShadows == 0 || index < 0 || index >= 8 || pointShadowEnabled[index] == 0) return 1.0;\n" +
  "  int face = selectPointShadowFace(lightToFragment);\n" +
  "  int matrixIndex = index * 6 + face;\n" +
  "  vec4 shadowClip = pointShadowMatrices[matrixIndex] * vec4(fragPosition, 1.0);\n" +
  "  if (abs(shadowClip.w) <= 0.00001) return 1.0;\n" +
  "  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;\n" +
  "  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;\n" +
  "  float shadowDepth = shadowNdc.z * 0.5 + 0.5;\n" +
  "  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;\n" +
  "  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;\n" +
  "  float texel = max(pointShadowTexelSize.x, pointShadowTexelSize.y);\n" +
  "  float ndotl = max(dot(normal, lightDir), 0.0);\n" +
  "  float bias = max(0.0, pointShadowDepthBiases[index]) + max(0.0, pointShadowNormalBiases[index]) * texel * (1.0 - ndotl);\n" +
  "  float filterRadius = 1.0;\n" +
  "  float lit = 0.0;\n" +
  "  float totalWeight = 0.0;\n" +
  "  for (int x = -1; x <= 1; x++) {\n" +
  "    for (int y = -1; y <= 1; y++) {\n" +
  "      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));\n" +
  "      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * pointShadowTexelSize * filterRadius;\n" +
  "      float closest = sampleShadowAtlasDepth(pointShadowAtlas, clamp(sampleUv, vec2(0.0), vec2(1.0)), pointShadowRects[matrixIndex]);\n" +
  "      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;\n" +
  "      totalWeight += weight;\n" +
  "    }\n" +
  "  }\n" +
  "  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;\n" +
  "}\n" +
  "void main() {\n" +
  "  vec2 baseUv = applyTextureTransform(selectUv(baseUvSet), baseUvOffsetScale, baseUvRotation);\n" +
  "  vec2 metallicRoughnessUv = applyTextureTransform(selectUv(metallicRoughnessUvSet), metallicRoughnessUvOffsetScale, metallicRoughnessUvRotation);\n" +
  "  vec2 normalUv = applyTextureTransform(selectUv(normalUvSet), normalUvOffsetScale, normalUvRotation);\n" +
  "  vec2 occlusionUv = applyTextureTransform(selectUv(occlusionUvSet), occlusionUvOffsetScale, occlusionUvRotation);\n" +
  "  vec2 emissiveUv = applyTextureTransform(selectUv(emissiveUvSet), emissiveUvOffsetScale, emissiveUvRotation);\n" +
  "  vec4 albedoSample = vec4(1.0);\n" +
  "  if (materialHasBaseTexture != 0) albedoSample = texture(texture0, baseUv);\n" +
  "  vec4 albedo = albedoSample * fragVertexColor * materialBaseColor;\n" +
  "  if (materialAlphaMode == 0) {\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (materialAlphaMode == 1) {\n" +
  "    if (albedo.a < materialAlphaCutoff) discard;\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (albedo.a <= 0.0001) discard;\n" +
  "  if (materialUnlit != 0) {\n" +
  "    finalColor = vec4(albedo.rgb, albedo.a);\n" +
  "    return;\n" +
  "  }\n" +
  "  vec4 metallicRoughnessSample = vec4(1.0);\n" +
  "  if (materialHasMetallicRoughnessTexture != 0) {\n" +
  "    metallicRoughnessSample = texture(texture1, metallicRoughnessUv);\n" +
  "  }\n" +
  "  vec3 normal = normalize(fragNormal);\n" +
  "  if (length(normal) <= 0.00001) normal = vec3(0.0, 1.0, 0.0);\n" +
  "  vec3 geometricNormal = normal;\n" +
  "  if (materialHasNormalTexture != 0) normal = applyNormalMap(normal, fragPosition, normalUv);\n" +
  "  vec3 viewDir = normalize(viewPosition - fragPosition);\n" +
  "  if (length(viewDir) <= 0.00001) viewDir = vec3(0.0, 0.0, 1.0);\n" +
  "  float roughness = clamp(materialRoughness * metallicRoughnessSample.g, 0.089, 1.0);\n" +
  "  float metallic = clamp(materialMetallic * metallicRoughnessSample.b, 0.0, 1.0);\n" +
  "  float shininess = mix(96.0, 8.0, roughness);\n" +
  "  float specularStrength = mix(0.04, 1.0, metallic);\n" +
  "  vec3 diffuseLight = ambientLight;\n" +
  "  vec3 specularLight = vec3(0.0);\n" +
  "  for (int i = 0; i < directionalCount; i++) {\n" +
  "    vec3 lightDir = normalize(-directionalDirections[i]);\n" +
  "    float attenuation = sampleDirectionalShadow(i, geometricNormal, lightDir);\n" +
  "    addLight(lightDir, directionalColors[i], attenuation, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  for (int i = 0; i < pointCount; i++) {\n" +
  "    vec3 toLight = pointPositions[i] - fragPosition;\n" +
  "    float distanceToLight = length(toLight);\n" +
  "    if (distanceToLight <= 0.00001) continue;\n" +
  "    vec3 lightDir = toLight / distanceToLight;\n" +
  "    float attenuation = rangeAttenuation(distanceToLight, pointRanges[i]) * samplePointShadow(i, geometricNormal, lightDir, fragPosition - pointPositions[i]);\n" +
  "    addLight(lightDir, pointColors[i], attenuation, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  for (int i = 0; i < spotCount; i++) {\n" +
  "    vec3 toLight = spotPositions[i] - fragPosition;\n" +
  "    float distanceToLight = length(toLight);\n" +
  "    if (distanceToLight <= 0.00001) continue;\n" +
  "    vec3 lightDir = toLight / distanceToLight;\n" +
  "    float attenuation = rangeAttenuation(distanceToLight, spotParams[i].x);\n" +
  "    float cone = spotAttenuation(spotDirections[i], -lightDir, spotParams[i]);\n" +
  "    addLight(lightDir, spotColors[i], attenuation * cone * sampleSpotShadow(i, geometricNormal, lightDir), normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  if (directionalCount == 0 && pointCount == 0 && spotCount == 0 && dot(ambientLight, ambientLight) <= 0.000001) {\n" +
  "    diffuseLight = vec3(1.0);\n" +
  "  }\n" +
  "  float occlusion = 1.0;\n" +
  "  if (materialHasOcclusionTexture != 0) {\n" +
  "    occlusion = mix(1.0, texture(texture4, occlusionUv).r, clamp(materialOcclusionStrength, 0.0, 1.0));\n" +
  "  }\n" +
  "  vec3 emissive = materialEmissiveColor;\n" +
  "  if (materialHasEmissiveTexture != 0) {\n" +
  "    emissive = texture(texture5, emissiveUv).rgb * materialEmissiveColor;\n" +
  "  }\n" +
  "  vec3 litColor = albedo.rgb * diffuseLight * occlusion + specularLight * occlusion + emissive;\n" +
  "  finalColor = vec4(litColor, albedo.a);\n" +
  "}\n"

///|
fn default_font_codepoints() -> Array[Int] {
  let codepoints : Array[Int] = []
  // Basic printable ASCII.
  for cp in 32..<127 {
    codepoints.push(cp)
  }
  // Latin-1 supplement (includes multiplication sign U+00D7).
  for cp in 160..<256 {
    codepoints.push(cp)
  }
  codepoints
}

///|
fn default_embedded_asset_lookup(_path : String) -> Bytes? {
  None
}
