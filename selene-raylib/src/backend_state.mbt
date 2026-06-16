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
  mut mouse_relative_delta : Ref[@smath.Vec2?]?
  mut mouse_wheel : @inputs.MouseWheel?
  mut touch_state : Map[@inputs.TouchId, @inputs.TouchPoint]?
  mut touch_changes_state : Array[@inputs.TouchEvent]?
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
  cubemaps3d : Map[
    @render3d_types.CubemapHandle,
    @render3d_types.CubemapAsset3D,
  ]
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
  asset_io_warning_keys : Set[String]
  last_touches : Map[@inputs.TouchId, @inputs.TouchPoint]
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
  mouse_relative_delta: None,
  mouse_wheel: None,
  touch_state: None,
  touch_changes_state: None,
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
  cubemaps3d: Map([]),
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
  asset_io_warning_keys: Set([]),
  last_touches: Map([]),
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
let raylib_lighting_vertex_shader : String =
  #|#version 330
  #|in vec3 vertexPosition;
  #|in vec2 vertexTexCoord;
  #|in vec2 vertexTexCoord2;
  #|in vec3 vertexNormal;
  #|in vec4 vertexTangent;
  #|in vec4 vertexColor;
  #|uniform mat4 mvp;
  #|uniform mat4 matModel;
  #|uniform mat4 matNormal;
  #|out vec3 fragPosition;
  #|out vec2 fragTexCoord;
  #|out vec2 fragTexCoord2;
  #|out vec3 fragNormal;
  #|out vec4 fragTangent;
  #|out vec4 fragVertexColor;
  #|void main() {
  #|  vec4 worldPosition = matModel * vec4(vertexPosition, 1.0);
  #|  fragPosition = worldPosition.xyz;
  #|  fragTexCoord = vertexTexCoord;
  #|  fragTexCoord2 = vertexTexCoord2;
  #|  fragNormal = normalize((matNormal * vec4(vertexNormal, 0.0)).xyz);
  #|  vec3 tangent = normalize((matNormal * vec4(vertexTangent.xyz, 0.0)).xyz);
  #|  fragTangent = vec4(tangent, vertexTangent.w);
  #|  fragVertexColor = vertexColor;
  #|  gl_Position = mvp * vec4(vertexPosition, 1.0);
  #|}
  #|

///|
let raylib_lighting_fragment_shader : String =
  #|#version 330
  #|in vec3 fragPosition;
  #|in vec2 fragTexCoord;
  #|in vec2 fragTexCoord2;
  #|in vec3 fragNormal;
  #|in vec4 fragTangent;
  #|in vec4 fragVertexColor;
  #|uniform sampler2D texture0;
  #|uniform sampler2D texture1;
  #|uniform sampler2D texture2;
  #|uniform sampler2D texture4;
  #|uniform sampler2D texture5;
  #|uniform vec3 ambientLight;
  #|uniform vec3 viewPosition;
  #|uniform vec3 viewForward;
  #|uniform int directionalCount;
  #|uniform vec3 directionalDirections[4];
  #|uniform vec3 directionalColors[4];
  #|uniform int pointCount;
  #|uniform vec3 pointPositions[8];
  #|uniform vec3 pointColors[8];
  #|uniform float pointRanges[8];
  #|uniform int spotCount;
  #|uniform vec3 spotPositions[4];
  #|uniform vec3 spotDirections[4];
  #|uniform vec3 spotColors[4];
  #|uniform vec3 spotParams[4];
  #|uniform vec4 materialBaseColor;
  #|uniform vec3 materialEmissiveColor;
  #|uniform float materialNormalScale;
  #|uniform float materialOcclusionStrength;
  #|uniform float materialMetallic;
  #|uniform float materialRoughness;
  #|uniform int materialAlphaMode;
  #|uniform float materialAlphaCutoff;
  #|uniform int materialHasBaseTexture;
  #|uniform int materialHasEmissiveTexture;
  #|uniform int materialHasMetallicRoughnessTexture;
  #|uniform int materialHasOcclusionTexture;
  #|uniform int materialHasNormalTexture;
  #|uniform int materialHasTangents;
  #|uniform int materialUnlit;
  #|uniform int materialReceiveShadows;
  #|uniform int shadowEnabled[4];
  #|uniform int shadowCascadeCounts[4];
  #|uniform sampler2D shadowMap0;
  #|uniform sampler2D shadowMap1;
  #|uniform sampler2D shadowMap2;
  #|uniform sampler2D shadowMap3;
  #|uniform mat4 shadowMatrices[16];
  #|uniform vec4 shadowRects[16];
  #|uniform vec2 shadowBounds[16];
  #|uniform float shadowDepthBiases[4];
  #|uniform float shadowNormalBiases[4];
  #|uniform vec2 directionalShadowTexelSize;
  #|uniform int spotShadowEnabled[4];
  #|uniform sampler2D spotShadowAtlas;
  #|uniform mat4 spotShadowMatrices[4];
  #|uniform vec4 spotShadowRects[4];
  #|uniform float spotShadowDepthBiases[4];
  #|uniform float spotShadowNormalBiases[4];
  #|uniform vec2 spotShadowTexelSize;
  #|uniform int pointShadowEnabled[8];
  #|uniform sampler2D pointShadowAtlas;
  #|uniform mat4 pointShadowMatrices[48];
  #|uniform vec4 pointShadowRects[48];
  #|uniform float pointShadowDepthBiases[8];
  #|uniform float pointShadowNormalBiases[8];
  #|uniform vec2 pointShadowTexelSize;
  #|uniform vec4 baseUvOffsetScale;
  #|uniform vec2 baseUvRotation;
  #|uniform int baseUvSet;
  #|uniform vec4 metallicRoughnessUvOffsetScale;
  #|uniform vec2 metallicRoughnessUvRotation;
  #|uniform int metallicRoughnessUvSet;
  #|uniform vec4 normalUvOffsetScale;
  #|uniform vec2 normalUvRotation;
  #|uniform int normalUvSet;
  #|uniform vec4 occlusionUvOffsetScale;
  #|uniform vec2 occlusionUvRotation;
  #|uniform int occlusionUvSet;
  #|uniform vec4 emissiveUvOffsetScale;
  #|uniform vec2 emissiveUvRotation;
  #|uniform int emissiveUvSet;
  #|out vec4 finalColor;
  #|float rangeAttenuation(float distanceToLight, float lightRange) {
  #|  if (lightRange <= 0.000001) return 1.0;
  #|  if (distanceToLight >= lightRange) return 0.0;
  #|  float t = 1.0 - distanceToLight / lightRange;
  #|  return t * t;
  #|}
  #|vec2 selectUv(int setIndex) {
  #|  if (setIndex == 1) return fragTexCoord2;
  #|  return fragTexCoord;
  #|}
  #|vec2 applyTextureTransform(vec2 uv, vec4 offsetScale, vec2 rotationSinCos) {
  #|  vec2 scaled = uv * offsetScale.zw;
  #|  return vec2(
  #|    scaled.x * rotationSinCos.y - scaled.y * rotationSinCos.x + offsetScale.x,
  #|    scaled.x * rotationSinCos.x + scaled.y * rotationSinCos.y + offsetScale.y
  #|  );
  #|}
  #|float spotAttenuation(vec3 spotDirection, vec3 lightToFragment, vec3 params) {
  #|  float inner = max(params.y, params.z);
  #|  float outer = min(params.y, params.z);
  #|  float cosTheta = dot(normalize(spotDirection), normalize(lightToFragment));
  #|  float delta = inner - outer;
  #|  if (cosTheta <= outer) return 0.0;
  #|  if (cosTheta >= inner || abs(delta) <= 0.000001) return 1.0;
  #|  return (cosTheta - outer) / delta;
  #|}
  #|mat3 cotangentFrame(vec3 normal, vec3 worldPosition, vec2 uv) {
  #|  vec3 dp1 = dFdx(worldPosition);
  #|  vec3 dp2 = dFdy(worldPosition);
  #|  vec2 duv1 = dFdx(uv);
  #|  vec2 duv2 = dFdy(uv);
  #|  vec3 dp2perp = cross(dp2, normal);
  #|  vec3 dp1perp = cross(normal, dp1);
  #|  vec3 tangent = dp2perp * duv1.x + dp1perp * duv2.x;
  #|  vec3 bitangent = dp2perp * duv1.y + dp1perp * duv2.y;
  #|  float scale = max(dot(tangent, tangent), dot(bitangent, bitangent));
  #|  if (scale <= 0.000001) return mat3(1.0);
  #|  float invScale = inversesqrt(scale);
  #|  return mat3(tangent * invScale, bitangent * invScale, normal);
  #|}
  #|vec3 applyNormalMap(vec3 normal, vec3 worldPosition, vec2 uv) {
  #|  vec3 mapNormal = texture(texture2, uv).xyz * 2.0 - 1.0;
  #|  mapNormal.xy *= materialNormalScale;
  #|  mapNormal = normalize(mapNormal);
  #|  mat3 tbn = cotangentFrame(normal, worldPosition, uv);
  #|  if (materialHasTangents != 0) {
  #|    vec3 tangent = normalize(fragTangent.xyz);
  #|    vec3 bitangent = normalize(cross(normal, tangent) * fragTangent.w);
  #|    if (dot(tangent, tangent) > 0.000001 && dot(bitangent, bitangent) > 0.000001) {
  #|      tbn = mat3(tangent, bitangent, normal);
  #|    }
  #|  }
  #|  return normalize(tbn * mapNormal);
  #|}
  #|void addLight(
  #|  vec3 lightDir,
  #|  vec3 lightColor,
  #|  float attenuation,
  #|  vec3 normal,
  #|  vec3 viewDir,
  #|  float shininess,
  #|  float specularStrength,
  #|  inout vec3 diffuseLight,
  #|  inout vec3 specularLight
  #|) {
  #|  if (attenuation <= 0.0) return;
  #|  float lambert = max(dot(normal, lightDir), 0.0);
  #|  if (lambert <= 0.0) return;
  #|  diffuseLight += lightColor * (lambert * attenuation);
  #|  vec3 halfway = normalize(lightDir + viewDir);
  #|  float spec = pow(max(dot(normal, halfway), 0.0), shininess) * specularStrength;
  #|  specularLight += lightColor * (spec * attenuation);
  #|}
  #|float sampleShadowMapDepth(int index, vec2 uv) {
  #|  if (index == 0) return texture(shadowMap0, uv).r;
  #|  if (index == 1) return texture(shadowMap1, uv).r;
  #|  if (index == 2) return texture(shadowMap2, uv).r;
  #|  if (index == 3) return texture(shadowMap3, uv).r;
  #|  return 1.0;
  #|}
  #|float sampleShadowAtlasDepth(sampler2D atlasTexture, vec2 uv, vec4 atlasRect) {
  #|  return texture(atlasTexture, atlasRect.xy + uv * atlasRect.zw).r;
  #|}
  #|float sampleDirectionalShadowCascade(int lightIndex, int cascadeIndex, vec3 normal, vec3 lightDir) {
  #|  int matrixIndex = lightIndex * 4 + cascadeIndex;
  #|  vec4 atlasRect = shadowRects[matrixIndex];
  #|  if (atlasRect.z <= 0.0 || atlasRect.w <= 0.0) return 1.0;
  #|  vec4 shadowClip = shadowMatrices[matrixIndex] * vec4(fragPosition, 1.0);
  #|  if (abs(shadowClip.w) <= 0.00001) return 1.0;
  #|  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;
  #|  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;
  #|  float shadowDepth = shadowNdc.z * 0.5 + 0.5;
  #|  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;
  #|  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;
  #|  float texel = max(directionalShadowTexelSize.x, directionalShadowTexelSize.y);
  #|  float ndotl = max(dot(normal, lightDir), 0.0);
  #|  float bias = max(0.0, shadowDepthBiases[lightIndex]) + max(0.0, shadowNormalBiases[lightIndex]) * texel * (1.0 - ndotl);
  #|  float filterRadius = 1.25;
  #|  float lit = 0.0;
  #|  float totalWeight = 0.0;
  #|  for (int x = -1; x <= 1; x++) {
  #|    for (int y = -1; y <= 1; y++) {
  #|      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));
  #|      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * directionalShadowTexelSize * filterRadius;
  #|      float closest = sampleShadowMapDepth(lightIndex, clamp(atlasRect.xy + sampleUv * atlasRect.zw, vec2(0.0), vec2(1.0)));
  #|      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;
  #|      totalWeight += weight;
  #|    }
  #|  }
  #|  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;
  #|}
  #|float sampleDirectionalShadow(int index, vec3 normal, vec3 lightDir) {
  #|  if (materialReceiveShadows == 0 || index < 0 || index >= 4 || shadowEnabled[index] == 0) return 1.0;
  #|  int cascadeCount = shadowCascadeCounts[index];
  #|  if (cascadeCount <= 0) return 1.0;
  #|  float viewDepth = dot(fragPosition - viewPosition, viewForward);
  #|  int baseIndex = index * 4;
  #|  float firstNear = shadowBounds[baseIndex].x;
  #|  float lastFar = shadowBounds[baseIndex + cascadeCount - 1].y;
  #|  if (viewDepth < firstNear || viewDepth > lastFar) return 1.0;
  #|  int selected = cascadeCount - 1;
  #|  for (int i = 0; i < 4; i++) {
  #|    if (i >= cascadeCount) break;
  #|    if (viewDepth <= shadowBounds[baseIndex + i].y) {
  #|      selected = i;
  #|      break;
  #|    }
  #|  }
  #|  float shadow = sampleDirectionalShadowCascade(index, selected, normal, lightDir);
  #|  if (selected > 0) {
  #|    int previous = selected - 1;
  #|    float overlapNear = shadowBounds[baseIndex + selected].x;
  #|    float overlapFar = shadowBounds[baseIndex + previous].y;
  #|    if (overlapNear < overlapFar && viewDepth >= overlapNear && viewDepth <= overlapFar) {
  #|      float blend = clamp((viewDepth - overlapNear) / (overlapFar - overlapNear), 0.0, 1.0);
  #|      shadow = mix(sampleDirectionalShadowCascade(index, previous, normal, lightDir), shadow, blend);
  #|    }
  #|  }
  #|  return shadow;
  #|}
  #|float sampleSpotShadow(int index, vec3 normal, vec3 lightDir) {
  #|  if (materialReceiveShadows == 0 || index < 0 || index >= 4 || spotShadowEnabled[index] == 0) return 1.0;
  #|  vec4 shadowClip = spotShadowMatrices[index] * vec4(fragPosition, 1.0);
  #|  if (abs(shadowClip.w) <= 0.00001) return 1.0;
  #|  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;
  #|  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;
  #|  float shadowDepth = shadowNdc.z * 0.5 + 0.5;
  #|  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;
  #|  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;
  #|  float texel = max(spotShadowTexelSize.x, spotShadowTexelSize.y);
  #|  float ndotl = max(dot(normal, lightDir), 0.0);
  #|  float bias = max(0.0, spotShadowDepthBiases[index]) + max(0.0, spotShadowNormalBiases[index]) * texel * (1.0 - ndotl);
  #|  float filterRadius = 1.25;
  #|  float lit = 0.0;
  #|  float totalWeight = 0.0;
  #|  for (int x = -1; x <= 1; x++) {
  #|    for (int y = -1; y <= 1; y++) {
  #|      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));
  #|      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * spotShadowTexelSize * filterRadius;
  #|      float closest = sampleShadowAtlasDepth(spotShadowAtlas, clamp(sampleUv, vec2(0.0), vec2(1.0)), spotShadowRects[index]);
  #|      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;
  #|      totalWeight += weight;
  #|    }
  #|  }
  #|  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;
  #|}
  #|int selectPointShadowFace(vec3 dir) {
  #|  vec3 absDir = abs(dir);
  #|  if (absDir.x >= absDir.y && absDir.x >= absDir.z) return dir.x >= 0.0 ? 0 : 1;
  #|  if (absDir.y >= absDir.x && absDir.y >= absDir.z) return dir.y >= 0.0 ? 2 : 3;
  #|  return dir.z >= 0.0 ? 4 : 5;
  #|}
  #|float samplePointShadow(int index, vec3 normal, vec3 lightDir, vec3 lightToFragment) {
  #|  if (materialReceiveShadows == 0 || index < 0 || index >= 8 || pointShadowEnabled[index] == 0) return 1.0;
  #|  int face = selectPointShadowFace(lightToFragment);
  #|  int matrixIndex = index * 6 + face;
  #|  vec4 shadowClip = pointShadowMatrices[matrixIndex] * vec4(fragPosition, 1.0);
  #|  if (abs(shadowClip.w) <= 0.00001) return 1.0;
  #|  vec3 shadowNdc = shadowClip.xyz / shadowClip.w;
  #|  vec2 shadowUv = shadowNdc.xy * 0.5 + 0.5;
  #|  float shadowDepth = shadowNdc.z * 0.5 + 0.5;
  #|  if (shadowDepth <= 0.0 || shadowDepth >= 1.0) return 1.0;
  #|  if (shadowUv.x <= 0.0 || shadowUv.x >= 1.0 || shadowUv.y <= 0.0 || shadowUv.y >= 1.0) return 1.0;
  #|  float texel = max(pointShadowTexelSize.x, pointShadowTexelSize.y);
  #|  float ndotl = max(dot(normal, lightDir), 0.0);
  #|  float bias = max(0.0, pointShadowDepthBiases[index]) + max(0.0, pointShadowNormalBiases[index]) * texel * (1.0 - ndotl);
  #|  float filterRadius = 1.0;
  #|  float lit = 0.0;
  #|  float totalWeight = 0.0;
  #|  for (int x = -1; x <= 1; x++) {
  #|    for (int y = -1; y <= 1; y++) {
  #|      float weight = 1.0 / (1.0 + abs(float(x)) + abs(float(y)));
  #|      vec2 sampleUv = shadowUv + vec2(float(x), float(y)) * pointShadowTexelSize * filterRadius;
  #|      float closest = sampleShadowAtlasDepth(pointShadowAtlas, clamp(sampleUv, vec2(0.0), vec2(1.0)), pointShadowRects[matrixIndex]);
  #|      lit += (shadowDepth - bias <= closest ? 1.0 : 0.0) * weight;
  #|      totalWeight += weight;
  #|    }
  #|  }
  #|  return totalWeight <= 0.00001 ? 1.0 : lit / totalWeight;
  #|}
  #|void main() {
  #|  vec2 baseUv = applyTextureTransform(selectUv(baseUvSet), baseUvOffsetScale, baseUvRotation);
  #|  vec2 metallicRoughnessUv = applyTextureTransform(selectUv(metallicRoughnessUvSet), metallicRoughnessUvOffsetScale, metallicRoughnessUvRotation);
  #|  vec2 normalUv = applyTextureTransform(selectUv(normalUvSet), normalUvOffsetScale, normalUvRotation);
  #|  vec2 occlusionUv = applyTextureTransform(selectUv(occlusionUvSet), occlusionUvOffsetScale, occlusionUvRotation);
  #|  vec2 emissiveUv = applyTextureTransform(selectUv(emissiveUvSet), emissiveUvOffsetScale, emissiveUvRotation);
  #|  vec4 albedoSample = vec4(1.0);
  #|  if (materialHasBaseTexture != 0) albedoSample = texture(texture0, baseUv);
  #|  vec4 albedo = albedoSample * fragVertexColor * materialBaseColor;
  #|  if (materialAlphaMode == 0) {
  #|    albedo.a = 1.0;
  #|  } else if (materialAlphaMode == 1) {
  #|    if (albedo.a < materialAlphaCutoff) discard;
  #|    albedo.a = 1.0;
  #|  } else if (albedo.a <= 0.0001) discard;
  #|  if (materialUnlit != 0) {
  #|    finalColor = vec4(albedo.rgb, albedo.a);
  #|    return;
  #|  }
  #|  vec4 metallicRoughnessSample = vec4(1.0);
  #|  if (materialHasMetallicRoughnessTexture != 0) {
  #|    metallicRoughnessSample = texture(texture1, metallicRoughnessUv);
  #|  }
  #|  vec3 normal = normalize(fragNormal);
  #|  if (length(normal) <= 0.00001) normal = vec3(0.0, 1.0, 0.0);
  #|  vec3 geometricNormal = normal;
  #|  if (materialHasNormalTexture != 0) normal = applyNormalMap(normal, fragPosition, normalUv);
  #|  vec3 viewDir = normalize(viewPosition - fragPosition);
  #|  if (length(viewDir) <= 0.00001) viewDir = vec3(0.0, 0.0, 1.0);
  #|  float roughness = clamp(materialRoughness * metallicRoughnessSample.g, 0.089, 1.0);
  #|  float metallic = clamp(materialMetallic * metallicRoughnessSample.b, 0.0, 1.0);
  #|  float shininess = mix(96.0, 8.0, roughness);
  #|  float specularStrength = mix(0.04, 1.0, metallic);
  #|  vec3 diffuseLight = ambientLight;
  #|  vec3 specularLight = vec3(0.0);
  #|  for (int i = 0; i < directionalCount; i++) {
  #|    vec3 lightDir = normalize(-directionalDirections[i]);
  #|    float attenuation = sampleDirectionalShadow(i, geometricNormal, lightDir);
  #|    addLight(lightDir, directionalColors[i], attenuation, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);
  #|  }
  #|  for (int i = 0; i < pointCount; i++) {
  #|    vec3 toLight = pointPositions[i] - fragPosition;
  #|    float distanceToLight = length(toLight);
  #|    if (distanceToLight <= 0.00001) continue;
  #|    vec3 lightDir = toLight / distanceToLight;
  #|    float attenuation = rangeAttenuation(distanceToLight, pointRanges[i]) * samplePointShadow(i, geometricNormal, lightDir, fragPosition - pointPositions[i]);
  #|    addLight(lightDir, pointColors[i], attenuation, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);
  #|  }
  #|  for (int i = 0; i < spotCount; i++) {
  #|    vec3 toLight = spotPositions[i] - fragPosition;
  #|    float distanceToLight = length(toLight);
  #|    if (distanceToLight <= 0.00001) continue;
  #|    vec3 lightDir = toLight / distanceToLight;
  #|    float attenuation = rangeAttenuation(distanceToLight, spotParams[i].x);
  #|    float cone = spotAttenuation(spotDirections[i], -lightDir, spotParams[i]);
  #|    addLight(lightDir, spotColors[i], attenuation * cone * sampleSpotShadow(i, geometricNormal, lightDir), normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);
  #|  }
  #|  if (directionalCount == 0 && pointCount == 0 && spotCount == 0 && dot(ambientLight, ambientLight) <= 0.000001) {
  #|    diffuseLight = vec3(1.0);
  #|  }
  #|  float occlusion = 1.0;
  #|  if (materialHasOcclusionTexture != 0) {
  #|    occlusion = mix(1.0, texture(texture4, occlusionUv).r, clamp(materialOcclusionStrength, 0.0, 1.0));
  #|  }
  #|  vec3 emissive = materialEmissiveColor;
  #|  if (materialHasEmissiveTexture != 0) {
  #|    emissive = texture(texture5, emissiveUv).rgb * materialEmissiveColor;
  #|  }
  #|  vec3 litColor = albedo.rgb * diffuseLight * occlusion + specularLight * occlusion + emissive;
  #|  finalColor = vec4(litColor, albedo.a);
  #|}
  #|

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
