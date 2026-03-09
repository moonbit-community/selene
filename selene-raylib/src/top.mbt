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
  material_has_texture_loc : Int
  material_unlit_loc : Int
  material_receive_shadows_loc : Int
  shadow_enabled_locs : Array[Int]
  shadow_cascade_count_locs : Array[Int]
  shadow_matrix_locs : Array[Int]
  shadow_rect_locs : Array[Int]
  shadow_bound_locs : Array[Int]
  shadow_depth_bias_locs : Array[Int]
  shadow_normal_bias_locs : Array[Int]
  directional_shadow_texel_size_loc : Int
  spot_shadow_enabled_locs : Array[Int]
  spot_shadow_matrix_locs : Array[Int]
  spot_shadow_rect_locs : Array[Int]
  spot_shadow_depth_bias_locs : Array[Int]
  spot_shadow_normal_bias_locs : Array[Int]
  spot_shadow_texel_size_loc : Int
  point_shadow_enabled_locs : Array[Int]
  point_shadow_depth_bias_locs : Array[Int]
  point_shadow_normal_bias_locs : Array[Int]
  point_shadow_matrix_locs : Array[Int]
  point_shadow_rect_locs : Array[Int]
  point_shadow_texel_size_loc : Int
  base_uv_offset_scale_loc : Int
  base_uv_rotation_loc : Int
  metallic_roughness_uv_offset_scale_loc : Int
  metallic_roughness_uv_rotation_loc : Int
  normal_uv_offset_scale_loc : Int
  normal_uv_rotation_loc : Int
  occlusion_uv_offset_scale_loc : Int
  occlusion_uv_rotation_loc : Int
  emissive_uv_offset_scale_loc : Int
  emissive_uv_rotation_loc : Int
}

///|
priv struct MaterialTextureBundle3D {
  base_texture : @raylib.Texture
  emissive_texture : @raylib.Texture
  metallic_roughness_texture : @raylib.Texture
  occlusion_texture : @raylib.Texture
  normal_texture : @raylib.Texture
  base_transform : @render3d_types.TextureTransform3D
  emissive_transform : @render3d_types.TextureTransform3D
  metallic_roughness_transform : @render3d_types.TextureTransform3D
  occlusion_transform : @render3d_types.TextureTransform3D
  normal_transform : @render3d_types.TextureTransform3D
  texcoord_set : Int
}

///|
priv struct MaterialTextureSource3D {
  texture : @raylib.Texture
  texcoord_set : Int
  transform : @render3d_types.TextureTransform3D
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
  mut embedded_asset_cache : Map[String, Bytes]
  meshes3d : Map[@render3d_types.MeshHandle, @render3d_types.MeshAsset]
  materials3d : Map[
    @render3d_types.MaterialHandle,
    @render3d_types.StandardMaterial3D,
  ]
  images3d : Map[@render3d_types.ImageHandle, @render3d_types.ImageAsset]
  primitive_meshes : Map[String, @raylib.Mesh]
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
  textures: Map::new(),
  sounds: Map::new(),
  audio_instances: Map::new(),
  next_audio_instance: 1U,
  font_alias: Map::new(),
  fonts_by_path: Map::new(),
  embedded_asset_cache: Map::new(),
  meshes3d: Map::new(),
  materials3d: Map::new(),
  images3d: Map::new(),
  primitive_meshes: Map::new(),
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
  texture_warning_keys: Set::new(),
}

///|
let clip_stack : Array[@smath.Rect] = []

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
  "in vec3 vertexNormal;\n" +
  "in vec4 vertexColor;\n" +
  "uniform mat4 mvp;\n" +
  "uniform mat4 matModel;\n" +
  "uniform mat4 matNormal;\n" +
  "out vec3 fragPosition;\n" +
  "out vec2 fragTexCoord;\n" +
  "out vec3 fragNormal;\n" +
  "out vec4 fragVertexColor;\n" +
  "void main() {\n" +
  "  vec4 worldPosition = matModel * vec4(vertexPosition, 1.0);\n" +
  "  fragPosition = worldPosition.xyz;\n" +
  "  fragTexCoord = vertexTexCoord;\n" +
  "  fragNormal = normalize((matNormal * vec4(vertexNormal, 0.0)).xyz);\n" +
  "  fragVertexColor = vertexColor;\n" +
  "  gl_Position = mvp * vec4(vertexPosition, 1.0);\n" +
  "}\n"

///|
let raylib_lighting_fragment_shader : String = "#version 330\n" +
  "in vec3 fragPosition;\n" +
  "in vec2 fragTexCoord;\n" +
  "in vec3 fragNormal;\n" +
  "in vec4 fragVertexColor;\n" +
  "uniform sampler2D texture0;\n" +
  "uniform sampler2D texture1;\n" +
  "uniform sampler2D texture2;\n" +
  "uniform sampler2D texture3;\n" +
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
  "uniform int materialHasTexture;\n" +
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
  "uniform vec4 metallicRoughnessUvOffsetScale;\n" +
  "uniform vec2 metallicRoughnessUvRotation;\n" +
  "uniform vec4 normalUvOffsetScale;\n" +
  "uniform vec2 normalUvRotation;\n" +
  "uniform vec4 occlusionUvOffsetScale;\n" +
  "uniform vec2 occlusionUvRotation;\n" +
  "uniform vec4 emissiveUvOffsetScale;\n" +
  "uniform vec2 emissiveUvRotation;\n" +
  "out vec4 finalColor;\n" +
  "float rangeAttenuation(float distanceToLight, float lightRange) {\n" +
  "  if (lightRange <= 0.000001) return 1.0;\n" +
  "  if (distanceToLight >= lightRange) return 0.0;\n" +
  "  float t = 1.0 - distanceToLight / lightRange;\n" +
  "  return t * t;\n" +
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
  "  vec2 baseUv = applyTextureTransform(fragTexCoord, baseUvOffsetScale, baseUvRotation);\n" +
  "  vec2 metallicRoughnessUv = applyTextureTransform(fragTexCoord, metallicRoughnessUvOffsetScale, metallicRoughnessUvRotation);\n" +
  "  vec2 normalUv = applyTextureTransform(fragTexCoord, normalUvOffsetScale, normalUvRotation);\n" +
  "  vec2 occlusionUv = applyTextureTransform(fragTexCoord, occlusionUvOffsetScale, occlusionUvRotation);\n" +
  "  vec2 emissiveUv = applyTextureTransform(fragTexCoord, emissiveUvOffsetScale, emissiveUvRotation);\n" +
  "  vec4 albedoSample = materialHasTexture != 0 ? texture(texture0, baseUv) : vec4(1.0);\n" +
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
  "  vec4 metallicRoughnessSample = materialHasTexture != 0 ? texture(texture1, metallicRoughnessUv) : vec4(1.0);\n" +
  "  vec3 normal = normalize(fragNormal);\n" +
  "  if (length(normal) <= 0.00001) normal = vec3(0.0, 1.0, 0.0);\n" +
  "  vec3 geometricNormal = normal;\n" +
  "  if (materialHasTexture != 0) normal = applyNormalMap(normal, fragPosition, normalUv);\n" +
  "  vec3 viewDir = normalize(viewPosition - fragPosition);\n" +
  "  if (length(viewDir) <= 0.00001) viewDir = vec3(0.0, 0.0, 1.0);\n" +
  "  float roughness = clamp(materialRoughness * metallicRoughnessSample.g, 0.0, 1.0);\n" +
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
  "  float occlusion = materialHasTexture != 0 ? mix(1.0, texture(texture4, occlusionUv).r, clamp(materialOcclusionStrength, 0.0, 1.0)) : 1.0;\n" +
  "  vec3 emissive = materialHasTexture != 0 ? texture(texture5, emissiveUv).rgb * materialEmissiveColor : materialEmissiveColor;\n" +
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

///|
fn read_float(bytes : Bytes, off : Int) -> Float {
  let bits = bytes[off].to_int() |
    (bytes[off + 1].to_int() << 8) |
    (bytes[off + 2].to_int() << 16) |
    (bytes[off + 3].to_int() << 24)
  Float::reinterpret_from_int(bits)
}

///|
fn clamp_u8(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 255 {
    255
  } else {
    value
  }
}

///|
fn to_float(value : Double) -> Float {
  Float::from_double(value)
}

///|
fn clamp_playback_speed(speed : Double) -> Double {
  if speed <= 0.0 {
    0.01
  } else {
    speed
  }
}

///|
fn to_ray_vector2(x : Double, y : Double) -> @raylib.Vector2 {
  @raylib.Vector2::new(to_float(x), to_float(y))
}

///|
fn to_ray_vector3_smath(value : @smath.Vec3) -> @raylib.Vector3 {
  @raylib.Vector3::new(to_float(value.x), to_float(value.y), to_float(value.z))
}

///|
fn to_ray_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> @raylib.Rectangle {
  @raylib.Rectangle::new(
    to_float(x),
    to_float(y),
    to_float(width),
    to_float(height),
  )
}

///|
fn clip_rect_intersection(lhs : @smath.Rect, rhs : @smath.Rect) -> @smath.Rect? {
  let left = @cmp.maximum(lhs.position[X], rhs.position[X])
  let top = @cmp.maximum(lhs.position[Y], rhs.position[Y])
  let right = @cmp.minimum(
    lhs.position[X] + lhs.size[X],
    rhs.position[X] + rhs.size[X],
  )
  let bottom = @cmp.minimum(
    lhs.position[Y] + lhs.size[Y],
    rhs.position[Y] + rhs.size[Y],
  )
  if right <= left || bottom <= top {
    None
  } else {
    Some({
      position: @smath.Vec2D(left, top),
      size: @smath.Vec2D(right - left, bottom - top),
    })
  }
}

///|
fn activate_clip_rect(rect : @smath.Rect) -> Unit {
  @raylib.begin_scissor_mode(
    rect.position[X].to_int(),
    rect.position[Y].to_int(),
    rect.size[X].to_int(),
    rect.size[Y].to_int(),
  )
}

///|
fn refresh_clip_stack() -> Unit {
  @raylib.end_scissor_mode()
  match clip_stack.last() {
    Some(rect) => activate_clip_rect(rect)
    None => ()
  }
}

///|
fn vector2_x(value : @raylib.Vector2) -> Double {
  read_float(value.to_bytes(), 0).to_double()
}

///|
fn vector2_y(value : @raylib.Vector2) -> Double {
  read_float(value.to_bytes(), 4).to_double()
}

///|
fn to_selene_vec2(value : @raylib.Vector2) -> @smath.Vec2D {
  @smath.Vec2D(vector2_x(value), vector2_y(value))
}

///|
fn to_ray_color(color : @render.Color) -> @raylib.Color {
  @raylib.Color::new(
    color.r.reinterpret_as_int(),
    color.g.reinterpret_as_int(),
    color.b.reinterpret_as_int(),
    clamp_u8((color.a * 255.0).to_int()),
  )
}

///|
fn to_ray_color_bytes(color : @render.Color) -> (Byte, Byte, Byte, Byte) {
  (
    color.r.reinterpret_as_int().to_byte(),
    color.g.reinterpret_as_int().to_byte(),
    color.b.reinterpret_as_int().to_byte(),
    clamp_u8((color.a * 255.0).to_int()).to_byte(),
  )
}

///|
fn color_to_vec3(color : @render.Color) -> @smath.Vec3 {
  @smath.Vec3::new(
    color.r.to_double() / 255.0,
    color.g.to_double() / 255.0,
    color.b.to_double() / 255.0,
  )
}

///|
fn normalize_or(value : @smath.Vec3, fallback : @smath.Vec3) -> @smath.Vec3 {
  if value.length_squared() <= 0.0000001 {
    fallback
  } else {
    value.normalize()
  }
}

///|
fn light_rgb(color : @render.Color, intensity : Double) -> @smath.Vec3 {
  color_to_vec3(color).scalar_mul(@cmp.maximum(0.0, intensity))
}

///|
fn append_u32_le(out : Array[Byte], value : UInt) -> Unit {
  out.push(value.to_byte())
  out.push((value >> 8).to_byte())
  out.push((value >> 16).to_byte())
  out.push((value >> 24).to_byte())
}

///|
fn append_i32_le(out : Array[Byte], value : Int) -> Unit {
  append_u32_le(out, value.reinterpret_as_uint())
}

///|
fn append_f32_le(out : Array[Byte], value : Double) -> Unit {
  append_i32_le(out, to_float(value).reinterpret_as_int())
}

///|
fn append_vec3_le(out : Array[Byte], value : @smath.Vec3) -> Unit {
  append_f32_le(out, value.x)
  append_f32_le(out, value.y)
  append_f32_le(out, value.z)
}

///|
fn bytes_from_int(value : Int) -> Bytes {
  let out : Array[Byte] = []
  append_i32_le(out, value)
  Bytes::from_array(out)
}

///|
fn bytes_from_float(value : Double) -> Bytes {
  let out : Array[Byte] = []
  append_f32_le(out, value)
  Bytes::from_array(out)
}

///|
fn bytes_from_vec2(value : @smath.Vec2D) -> Bytes {
  let out : Array[Byte] = []
  append_f32_le(out, value[X])
  append_f32_le(out, value[Y])
  Bytes::from_array(out)
}

///|
fn bytes_from_vec3(value : @smath.Vec3) -> Bytes {
  let out : Array[Byte] = []
  append_vec3_le(out, value)
  Bytes::from_array(out)
}

///|
fn bytes_from_color4(color : @render.Color) -> Bytes {
  let out : Array[Byte] = []
  append_f32_le(out, color.r.to_double() / 255.0)
  append_f32_le(out, color.g.to_double() / 255.0)
  append_f32_le(out, color.b.to_double() / 255.0)
  append_f32_le(out, color.a)
  Bytes::from_array(out)
}

///|
#borrow(target, source)
extern "c" fn reset_material_from_material(
  target : @raylib.Material,
  source : @raylib.Material,
) = "selene_raylib_reset_material_from_material"

///|
fn texture_transform_offset_scale(
  transform : @render3d_types.TextureTransform3D,
) -> (Double, Double, Double, Double) {
  (
    transform.offset[X],
    transform.offset[Y],
    transform.scale[X],
    transform.scale[Y],
  )
}

///|
fn texture_transform_rotation_sin_cos(
  transform : @render3d_types.TextureTransform3D,
) -> @smath.Vec2D {
  @smath.Vec2D(@cmath.sin(transform.rotation), @cmath.cos(transform.rotation))
}

///|
fn bytes_from_texture_transform_offset_scale(
  transform : @render3d_types.TextureTransform3D,
) -> Bytes {
  let (offset_x, offset_y, scale_x, scale_y) = texture_transform_offset_scale(
    transform,
  )
  let out : Array[Byte] = []
  append_f32_le(out, offset_x)
  append_f32_le(out, offset_y)
  append_f32_le(out, scale_x)
  append_f32_le(out, scale_y)
  Bytes::from_array(out)
}

///|
fn bytes_from_texture_transform_rotation(
  transform : @render3d_types.TextureTransform3D,
) -> Bytes {
  bytes_from_vec2(texture_transform_rotation_sin_cos(transform))
}

///|
fn pack_vec3_array(values : Array[@smath.Vec3], count : Int) -> Bytes {
  let out : Array[Byte] = []
  for index in 0..<count {
    append_vec3_le(out, values[index])
  }
  Bytes::from_array(out)
}

///|
fn pack_float_array(values : Array[Double], count : Int) -> Bytes {
  let out : Array[Byte] = []
  for index in 0..<count {
    append_f32_le(out, values[index])
  }
  Bytes::from_array(out)
}

///|
fn set_shader_uniform(
  shader : @raylib.Shader,
  loc : Int,
  value : Bytes,
  uniform_type : Int,
) -> Unit {
  if loc == -1 {
    return
  }
  @raylib.set_shader_value(shader, loc, value, uniform_type)
}

///|
fn set_shader_uniform_v(
  shader : @raylib.Shader,
  loc : Int,
  value : Bytes,
  uniform_type : Int,
  count : Int,
) -> Unit {
  if loc == -1 || count <= 0 {
    return
  }
  @raylib.set_shader_value_v(shader, loc, value, uniform_type, count)
}

///|
fn configure_lighting_shader_locations(shader : @raylib.Shader) -> Unit {
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocVertexPosition,
    @raylib.get_shader_location_attrib(shader, "vertexPosition"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocVertexTexcoord01,
    @raylib.get_shader_location_attrib(shader, "vertexTexCoord"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocVertexNormal,
    @raylib.get_shader_location_attrib(shader, "vertexNormal"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocVertexColor,
    @raylib.get_shader_location_attrib(shader, "vertexColor"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMatrixMvp,
    @raylib.get_shader_location(shader, "mvp"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMatrixView,
    @raylib.get_shader_location(shader, "matView"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMatrixProjection,
    @raylib.get_shader_location(shader, "matProjection"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMatrixModel,
    @raylib.get_shader_location(shader, "matModel"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMatrixNormal,
    @raylib.get_shader_location(shader, "matNormal"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapAlbedo,
    @raylib.get_shader_location(shader, "texture0"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapMetalness,
    @raylib.get_shader_location(shader, "texture1"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapNormal,
    @raylib.get_shader_location(shader, "texture2"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapRoughness,
    @raylib.get_shader_location(shader, "texture3"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapOcclusion,
    @raylib.get_shader_location(shader, "texture4"),
  )
  @raylib.set_shader_location(
    shader,
    @raylib.ShaderLocMapEmission,
    @raylib.get_shader_location(shader, "texture5"),
  )
}

///|
fn create_lighting_shader_state() -> LightingShaderState {
  let shader = @raylib.load_shader_from_memory(
    raylib_lighting_vertex_shader, raylib_lighting_fragment_shader,
  )
  configure_lighting_shader_locations(shader)
  let shadow_enabled_locs : Array[Int] = []
  let shadow_cascade_count_locs : Array[Int] = []
  let shadow_matrix_locs : Array[Int] = []
  let shadow_rect_locs : Array[Int] = []
  let shadow_bound_locs : Array[Int] = []
  let shadow_depth_bias_locs : Array[Int] = []
  let shadow_normal_bias_locs : Array[Int] = []
  let spot_shadow_enabled_locs : Array[Int] = []
  let spot_shadow_matrix_locs : Array[Int] = []
  let spot_shadow_rect_locs : Array[Int] = []
  let spot_shadow_depth_bias_locs : Array[Int] = []
  let spot_shadow_normal_bias_locs : Array[Int] = []
  let point_shadow_enabled_locs : Array[Int] = []
  let point_shadow_depth_bias_locs : Array[Int] = []
  let point_shadow_normal_bias_locs : Array[Int] = []
  let point_shadow_matrix_locs : Array[Int] = []
  let point_shadow_rect_locs : Array[Int] = []
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    shadow_enabled_locs.push(
      @raylib.get_shader_location(shader, "shadowEnabled[\{index}]"),
    )
    shadow_cascade_count_locs.push(
      @raylib.get_shader_location(shader, "shadowCascadeCounts[\{index}]"),
    )
    shadow_depth_bias_locs.push(
      @raylib.get_shader_location(shader, "shadowDepthBiases[\{index}]"),
    )
    shadow_normal_bias_locs.push(
      @raylib.get_shader_location(shader, "shadowNormalBiases[\{index}]"),
    )
    set_shader_uniform(
      shader,
      @raylib.get_shader_location(shader, "shadowMap\{index}"),
      bytes_from_int(shadow_texture_slot(index)),
      @raylib.ShaderUniformInt,
    )
  }
  for index in 0..<(MAX_DIRECTIONAL_LIGHTS * MAX_DIRECTIONAL_CASCADES) {
    shadow_matrix_locs.push(
      @raylib.get_shader_location(shader, "shadowMatrices[\{index}]"),
    )
    shadow_rect_locs.push(
      @raylib.get_shader_location(shader, "shadowRects[\{index}]"),
    )
    shadow_bound_locs.push(
      @raylib.get_shader_location(shader, "shadowBounds[\{index}]"),
    )
  }
  for index in 0..<MAX_SPOT_LIGHTS {
    spot_shadow_enabled_locs.push(
      @raylib.get_shader_location(shader, "spotShadowEnabled[\{index}]"),
    )
    spot_shadow_matrix_locs.push(
      @raylib.get_shader_location(shader, "spotShadowMatrices[\{index}]"),
    )
    spot_shadow_rect_locs.push(
      @raylib.get_shader_location(shader, "spotShadowRects[\{index}]"),
    )
    spot_shadow_depth_bias_locs.push(
      @raylib.get_shader_location(shader, "spotShadowDepthBiases[\{index}]"),
    )
    spot_shadow_normal_bias_locs.push(
      @raylib.get_shader_location(shader, "spotShadowNormalBiases[\{index}]"),
    )
  }
  set_shader_uniform(
    shader,
    @raylib.get_shader_location(shader, "spotShadowAtlas"),
    bytes_from_int(SPOT_SHADOW_TEXTURE_SLOT),
    @raylib.ShaderUniformInt,
  )
  for index in 0..<MAX_POINT_LIGHTS {
    point_shadow_enabled_locs.push(
      @raylib.get_shader_location(shader, "pointShadowEnabled[\{index}]"),
    )
    point_shadow_depth_bias_locs.push(
      @raylib.get_shader_location(shader, "pointShadowDepthBiases[\{index}]"),
    )
    point_shadow_normal_bias_locs.push(
      @raylib.get_shader_location(shader, "pointShadowNormalBiases[\{index}]"),
    )
  }
  for index in 0..<(MAX_POINT_LIGHTS * POINT_SHADOW_FACE_COUNT) {
    point_shadow_matrix_locs.push(
      @raylib.get_shader_location(shader, "pointShadowMatrices[\{index}]"),
    )
    point_shadow_rect_locs.push(
      @raylib.get_shader_location(shader, "pointShadowRects[\{index}]"),
    )
  }
  set_shader_uniform(
    shader,
    @raylib.get_shader_location(shader, "pointShadowAtlas"),
    bytes_from_int(POINT_SHADOW_TEXTURE_SLOT),
    @raylib.ShaderUniformInt,
  )
  {
    shader,
    ambient_light_loc: @raylib.get_shader_location(shader, "ambientLight"),
    view_position_loc: @raylib.get_shader_location(shader, "viewPosition"),
    view_forward_loc: @raylib.get_shader_location(shader, "viewForward"),
    directional_count_loc: @raylib.get_shader_location(
      shader, "directionalCount",
    ),
    directional_directions_loc: @raylib.get_shader_location(
      shader, "directionalDirections[0]",
    ),
    directional_colors_loc: @raylib.get_shader_location(
      shader, "directionalColors[0]",
    ),
    point_count_loc: @raylib.get_shader_location(shader, "pointCount"),
    point_positions_loc: @raylib.get_shader_location(
      shader, "pointPositions[0]",
    ),
    point_colors_loc: @raylib.get_shader_location(shader, "pointColors[0]"),
    point_ranges_loc: @raylib.get_shader_location(shader, "pointRanges[0]"),
    spot_count_loc: @raylib.get_shader_location(shader, "spotCount"),
    spot_positions_loc: @raylib.get_shader_location(shader, "spotPositions[0]"),
    spot_directions_loc: @raylib.get_shader_location(
      shader, "spotDirections[0]",
    ),
    spot_colors_loc: @raylib.get_shader_location(shader, "spotColors[0]"),
    spot_params_loc: @raylib.get_shader_location(shader, "spotParams[0]"),
    material_base_color_loc: @raylib.get_shader_location(
      shader, "materialBaseColor",
    ),
    material_emissive_color_loc: @raylib.get_shader_location(
      shader, "materialEmissiveColor",
    ),
    material_normal_scale_loc: @raylib.get_shader_location(
      shader, "materialNormalScale",
    ),
    material_occlusion_strength_loc: @raylib.get_shader_location(
      shader, "materialOcclusionStrength",
    ),
    material_metallic_loc: @raylib.get_shader_location(
      shader, "materialMetallic",
    ),
    material_roughness_loc: @raylib.get_shader_location(
      shader, "materialRoughness",
    ),
    material_alpha_mode_loc: @raylib.get_shader_location(
      shader, "materialAlphaMode",
    ),
    material_alpha_cutoff_loc: @raylib.get_shader_location(
      shader, "materialAlphaCutoff",
    ),
    material_has_texture_loc: @raylib.get_shader_location(
      shader, "materialHasTexture",
    ),
    material_unlit_loc: @raylib.get_shader_location(shader, "materialUnlit"),
    material_receive_shadows_loc: @raylib.get_shader_location(
      shader, "materialReceiveShadows",
    ),
    shadow_enabled_locs,
    shadow_cascade_count_locs,
    shadow_matrix_locs,
    shadow_rect_locs,
    shadow_bound_locs,
    shadow_depth_bias_locs,
    shadow_normal_bias_locs,
    directional_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "directionalShadowTexelSize",
    ),
    spot_shadow_enabled_locs,
    spot_shadow_matrix_locs,
    spot_shadow_rect_locs,
    spot_shadow_depth_bias_locs,
    spot_shadow_normal_bias_locs,
    spot_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "spotShadowTexelSize",
    ),
    point_shadow_enabled_locs,
    point_shadow_depth_bias_locs,
    point_shadow_normal_bias_locs,
    point_shadow_matrix_locs,
    point_shadow_rect_locs,
    point_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "pointShadowTexelSize",
    ),
    base_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "baseUvOffsetScale",
    ),
    base_uv_rotation_loc: @raylib.get_shader_location(shader, "baseUvRotation"),
    metallic_roughness_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "metallicRoughnessUvOffsetScale",
    ),
    metallic_roughness_uv_rotation_loc: @raylib.get_shader_location(
      shader, "metallicRoughnessUvRotation",
    ),
    normal_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "normalUvOffsetScale",
    ),
    normal_uv_rotation_loc: @raylib.get_shader_location(
      shader, "normalUvRotation",
    ),
    occlusion_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "occlusionUvOffsetScale",
    ),
    occlusion_uv_rotation_loc: @raylib.get_shader_location(
      shader, "occlusionUvRotation",
    ),
    emissive_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "emissiveUvOffsetScale",
    ),
    emissive_uv_rotation_loc: @raylib.get_shader_location(
      shader, "emissiveUvRotation",
    ),
  }
}

///|
fn get_lighting_shader_state() -> LightingShaderState {
  if backend.lighting_shader is Some(state) {
    return state
  }
  let state = create_lighting_shader_state()
  backend.lighting_shader = Some(state)
  state
}

///|
fn white_render_color() -> @render.Color {
  { r: 255U, g: 255U, b: 255U, a: 1.0 }
}

///|
const INTERNAL_WHITE_TEXTURE_KEY : String = "__selene_internal:white_1x1"

///|
const INTERNAL_FLAT_NORMAL_TEXTURE_KEY : String = "__selene_internal:flat_normal_1x1"

///|
fn get_solid_texture(key : String, color : @render.Color) -> @raylib.Texture {
  if backend.textures.get(key) is Some(texture) {
    return texture
  }
  let image = @raylib.gen_image_color(1, 1, to_ray_color(color))
  let texture = @raylib.load_texture_from_image(image)
  @raylib.unload_image(image)
  @raylib.set_texture_filter(texture, @raylib.TextureFilterPoint)
  backend.textures.set(key, texture)
  texture
}

///|
fn get_white_texture() -> @raylib.Texture {
  get_solid_texture(INTERNAL_WHITE_TEXTURE_KEY, white_render_color())
}

///|
fn get_flat_normal_texture() -> @raylib.Texture {
  get_solid_texture(INTERNAL_FLAT_NORMAL_TEXTURE_KEY, {
    r: 128U,
    g: 128U,
    b: 255U,
    a: 1.0,
  })
}

///|
fn fallback_lighting_texture_bundle() -> MaterialTextureBundle3D {
  let default_transform = @render3d_types.default_texture_transform3d()
  {
    base_texture: get_white_texture(),
    emissive_texture: get_white_texture(),
    metallic_roughness_texture: get_white_texture(),
    occlusion_texture: get_white_texture(),
    normal_texture: get_flat_normal_texture(),
    base_transform: default_transform,
    emissive_transform: default_transform,
    metallic_roughness_transform: default_transform,
    occlusion_transform: default_transform,
    normal_transform: default_transform,
    texcoord_set: 0,
  }
}

///|
fn get_lit_material(textured : Bool) -> @raylib.Material {
  let existing = if textured {
    backend.lit_textured_material
  } else {
    backend.lit_material
  }
  if existing is Some(material) {
    return material
  }
  let material = @raylib.load_material_default()
  @raylib.set_material_shader(material, get_lighting_shader_state().shader)
  @raylib.set_material_map_color(
    material,
    @raylib.MaterialMapAlbedo,
    to_ray_color(white_render_color()),
  )
  if textured {
    backend.lit_textured_material = Some(material)
  } else {
    backend.lit_material = Some(material)
  }
  material
}

///|
fn bind_shadow_textures(shadow_state : FrameShadowState?) -> Unit {
  guard shadow_state is Some(frame_shadow) else { return }
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    if frame_shadow.directional_shadows.get(index) is Some(shadow) {
      @rl.active_texture_slot(shadow_texture_slot(index))
      @rl.enable_texture(shadow.depth_texture_id)
    }
  }
  if frame_shadow.spot_shadow_atlas_id is Some(depth_texture_id) {
    @rl.active_texture_slot(SPOT_SHADOW_TEXTURE_SLOT)
    @rl.enable_texture(depth_texture_id)
  }
  if frame_shadow.point_shadow_atlas_id is Some(depth_texture_id) {
    @rl.active_texture_slot(POINT_SHADOW_TEXTURE_SLOT)
    @rl.enable_texture(depth_texture_id)
  }
  @rl.active_texture_slot(0)
}

///|
fn unbind_shadow_textures(shadow_state : FrameShadowState?) -> Unit {
  guard shadow_state is Some(frame_shadow) else { return }
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    if frame_shadow.directional_shadows.get(index) is Some(_) {
      @rl.active_texture_slot(shadow_texture_slot(index))
      @rl.disable_texture()
    }
  }
  if frame_shadow.spot_shadow_atlas_id is Some(_) {
    @rl.active_texture_slot(SPOT_SHADOW_TEXTURE_SLOT)
    @rl.disable_texture()
  }
  if frame_shadow.point_shadow_atlas_id is Some(_) {
    @rl.active_texture_slot(POINT_SHADOW_TEXTURE_SLOT)
    @rl.disable_texture()
  }
  @rl.active_texture_slot(0)
}

///|
fn upload_texture_transform_uniforms(
  shader : @raylib.Shader,
  offset_scale_loc : Int,
  rotation_loc : Int,
  transform : @render3d_types.TextureTransform3D,
) -> Unit {
  set_shader_uniform(
    shader,
    offset_scale_loc,
    bytes_from_texture_transform_offset_scale(transform),
    @raylib.ShaderUniformVec4,
  )
  set_shader_uniform(
    shader,
    rotation_loc,
    bytes_from_texture_transform_rotation(transform),
    @raylib.ShaderUniformVec2,
  )
}

///|
fn upload_lighting_uniforms(
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> LightingShaderState {
  let state = get_lighting_shader_state()
  let shader = state.shader
  let default_shadow_rect : ShadowAtlasRect = {
    offset: @smath.Vec2D(0.0, 0.0),
    scale: @smath.Vec2D(0.0, 0.0),
  }
  let ambient = frame.ambient_light
    .map(fn(light) { light_rgb(light.color, light.intensity) })
    .unwrap_or(@smath.Vec3::zero())
  set_shader_uniform(
    shader,
    state.ambient_light_loc,
    bytes_from_vec3(ambient),
    @raylib.ShaderUniformVec3,
  )
  set_shader_uniform(
    shader,
    state.view_position_loc,
    bytes_from_vec3(camera_position),
    @raylib.ShaderUniformVec3,
  )
  let camera_forward = frame.camera.map_or(@smath.Vec3::new(0.0, 0.0, -1.0), fn(
    active_camera,
  ) {
    normalize_or(
      active_camera.target - active_camera.position,
      @smath.Vec3::new(0.0, 0.0, -1.0),
    )
  })
  set_shader_uniform(
    shader,
    state.view_forward_loc,
    bytes_from_vec3(camera_forward),
    @raylib.ShaderUniformVec3,
  )

  let directional_count = @cmp.minimum(
    frame.directional_lights.length(),
    MAX_DIRECTIONAL_LIGHTS,
  )
  let directional_directions : Array[@smath.Vec3] = []
  let directional_colors : Array[@smath.Vec3] = []
  for index in 0..<directional_count {
    let light = frame.directional_lights[index]
    directional_directions.push(
      normalize_or(light.direction, @smath.Vec3::new(0.0, -1.0, 0.0)),
    )
    directional_colors.push(light_rgb(light.color, light.intensity))
  }
  set_shader_uniform(
    shader,
    state.directional_count_loc,
    bytes_from_int(directional_count),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform_v(
    shader,
    state.directional_directions_loc,
    pack_vec3_array(directional_directions, directional_count),
    @raylib.ShaderUniformVec3,
    directional_count,
  )
  set_shader_uniform_v(
    shader,
    state.directional_colors_loc,
    pack_vec3_array(directional_colors, directional_count),
    @raylib.ShaderUniformVec3,
    directional_count,
  )
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.directional_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.shadow_enabled_locs[index],
      bytes_from_int(if shadow is Some(_) { 1 } else { 0 }),
      @raylib.ShaderUniformInt,
    )
    set_shader_uniform(
      shader,
      state.shadow_cascade_count_locs[index],
      bytes_from_int(shadow.map_or(0, fn(value) { value.cascades.length() })),
      @raylib.ShaderUniformInt,
    )
    set_shader_uniform(
      shader,
      state.shadow_depth_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
      @raylib.ShaderUniformFloat,
    )
    set_shader_uniform(
      shader,
      state.shadow_normal_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
      @raylib.ShaderUniformFloat,
    )
    let base_index = index * MAX_DIRECTIONAL_CASCADES
    for cascade_index in 0..<MAX_DIRECTIONAL_CASCADES {
      let matrix_index = base_index + cascade_index
      let cascade = shadow.bind(fn(value) { value.cascades.get(cascade_index) })
      @raylib.set_shader_value_matrix(
        shader,
        state.shadow_matrix_locs[matrix_index],
        cascade.map_or(@raylib.Matrix::identity(), fn(value) {
          value.light_view_projection
        }),
      )
      set_shader_uniform(
        shader,
        state.shadow_rect_locs[matrix_index],
        cascade.map_or(bytes_from_shadow_atlas_rect(default_shadow_rect), fn(
          value,
        ) {
          bytes_from_shadow_atlas_rect(value.atlas_rect)
        }),
        @raylib.ShaderUniformVec4,
      )
      set_shader_uniform(
        shader,
        state.shadow_bound_locs[matrix_index],
        cascade.map_or(bytes_from_vec2(@smath.Vec2D(0.0, 0.0)), fn(value) {
          bytes_from_vec2(@smath.Vec2D(value.near_bound, value.far_bound))
        }),
        @raylib.ShaderUniformVec2,
      )
    }
  }
  set_shader_uniform(
    shader,
    state.directional_shadow_texel_size_loc,
    bytes_from_vec2(
      shadow_state.map_or(@smath.Vec2D(0.0, 0.0), fn(value) {
        value.directional_texel_size
      }),
    ),
    @raylib.ShaderUniformVec2,
  )

  let point_count = @cmp.minimum(frame.point_lights.length(), MAX_POINT_LIGHTS)
  let point_positions : Array[@smath.Vec3] = []
  let point_colors : Array[@smath.Vec3] = []
  let point_ranges : Array[Double] = []
  for index in 0..<point_count {
    let light = frame.point_lights[index]
    point_positions.push(light.position)
    point_colors.push(light_rgb(light.color, light.intensity))
    point_ranges.push(light.range)
  }
  set_shader_uniform(
    shader,
    state.point_count_loc,
    bytes_from_int(point_count),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform_v(
    shader,
    state.point_positions_loc,
    pack_vec3_array(point_positions, point_count),
    @raylib.ShaderUniformVec3,
    point_count,
  )
  set_shader_uniform_v(
    shader,
    state.point_colors_loc,
    pack_vec3_array(point_colors, point_count),
    @raylib.ShaderUniformVec3,
    point_count,
  )
  set_shader_uniform_v(
    shader,
    state.point_ranges_loc,
    pack_float_array(point_ranges, point_count),
    @raylib.ShaderUniformFloat,
    point_count,
  )

  let spot_count = @cmp.minimum(frame.spot_lights.length(), MAX_SPOT_LIGHTS)
  let spot_positions : Array[@smath.Vec3] = []
  let spot_directions : Array[@smath.Vec3] = []
  let spot_colors : Array[@smath.Vec3] = []
  let spot_params : Array[@smath.Vec3] = []
  for index in 0..<spot_count {
    let light = frame.spot_lights[index]
    let inner = @cmath.cos(light.inner_angle)
    let outer = @cmath.cos(light.outer_angle)
    spot_positions.push(light.position)
    spot_directions.push(
      normalize_or(light.direction, @smath.Vec3::new(0.0, -1.0, 0.0)),
    )
    spot_colors.push(light_rgb(light.color, light.intensity))
    spot_params.push(
      @smath.Vec3::new(
        light.range,
        @cmp.maximum(inner, outer),
        @cmp.minimum(inner, outer),
      ),
    )
  }
  set_shader_uniform(
    shader,
    state.spot_count_loc,
    bytes_from_int(spot_count),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform_v(
    shader,
    state.spot_positions_loc,
    pack_vec3_array(spot_positions, spot_count),
    @raylib.ShaderUniformVec3,
    spot_count,
  )
  set_shader_uniform_v(
    shader,
    state.spot_directions_loc,
    pack_vec3_array(spot_directions, spot_count),
    @raylib.ShaderUniformVec3,
    spot_count,
  )
  set_shader_uniform_v(
    shader,
    state.spot_colors_loc,
    pack_vec3_array(spot_colors, spot_count),
    @raylib.ShaderUniformVec3,
    spot_count,
  )
  set_shader_uniform_v(
    shader,
    state.spot_params_loc,
    pack_vec3_array(spot_params, spot_count),
    @raylib.ShaderUniformVec3,
    spot_count,
  )
  for index in 0..<MAX_SPOT_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.spot_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.spot_shadow_enabled_locs[index],
      bytes_from_int(if shadow is Some(_) { 1 } else { 0 }),
      @raylib.ShaderUniformInt,
    )
    @raylib.set_shader_value_matrix(
      shader,
      state.spot_shadow_matrix_locs[index],
      shadow.map_or(@raylib.Matrix::identity(), fn(value) {
        value.light_view_projection
      }),
    )
    set_shader_uniform(
      shader,
      state.spot_shadow_rect_locs[index],
      bytes_from_shadow_atlas_rect(
        shadow.map_or(default_shadow_rect, fn(value) { value.atlas_rect }),
      ),
      @raylib.ShaderUniformVec4,
    )
    set_shader_uniform(
      shader,
      state.spot_shadow_depth_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
      @raylib.ShaderUniformFloat,
    )
    set_shader_uniform(
      shader,
      state.spot_shadow_normal_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
      @raylib.ShaderUniformFloat,
    )
  }
  set_shader_uniform(
    shader,
    state.spot_shadow_texel_size_loc,
    bytes_from_vec2(
      shadow_state.map_or(@smath.Vec2D(0.0, 0.0), fn(value) {
        value.spot_texel_size
      }),
    ),
    @raylib.ShaderUniformVec2,
  )
  for index in 0..<MAX_POINT_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.point_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.point_shadow_enabled_locs[index],
      bytes_from_int(if shadow is Some(_) { 1 } else { 0 }),
      @raylib.ShaderUniformInt,
    )
    set_shader_uniform(
      shader,
      state.point_shadow_depth_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
      @raylib.ShaderUniformFloat,
    )
    set_shader_uniform(
      shader,
      state.point_shadow_normal_bias_locs[index],
      bytes_from_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
      @raylib.ShaderUniformFloat,
    )
    for face_index in 0..<POINT_SHADOW_FACE_COUNT {
      let matrix_index = index * POINT_SHADOW_FACE_COUNT + face_index
      @raylib.set_shader_value_matrix(
        shader,
        state.point_shadow_matrix_locs[matrix_index],
        shadow
        .bind(fn(value) { value.face_matrices.get(face_index) })
        .unwrap_or(@raylib.Matrix::identity()),
      )
      set_shader_uniform(
        shader,
        state.point_shadow_rect_locs[matrix_index],
        bytes_from_shadow_atlas_rect(
          shadow
          .bind(fn(value) { value.face_rects.get(face_index) })
          .unwrap_or(default_shadow_rect),
        ),
        @raylib.ShaderUniformVec4,
      )
    }
  }
  set_shader_uniform(
    shader,
    state.point_shadow_texel_size_loc,
    bytes_from_vec2(
      shadow_state.map_or(@smath.Vec2D(0.0, 0.0), fn(value) {
        value.point_texel_size
      }),
    ),
    @raylib.ShaderUniformVec2,
  )

  set_shader_uniform(
    shader,
    state.material_base_color_loc,
    bytes_from_color4(material.base_color),
    @raylib.ShaderUniformVec4,
  )
  set_shader_uniform(
    shader,
    state.material_emissive_color_loc,
    bytes_from_vec3(color_to_vec3(material.emissive_color)),
    @raylib.ShaderUniformVec3,
  )
  set_shader_uniform(
    shader,
    state.material_normal_scale_loc,
    bytes_from_float(material.normal_scale),
    @raylib.ShaderUniformFloat,
  )
  set_shader_uniform(
    shader,
    state.material_occlusion_strength_loc,
    bytes_from_float(material.occlusion_strength),
    @raylib.ShaderUniformFloat,
  )
  set_shader_uniform(
    shader,
    state.material_metallic_loc,
    bytes_from_float(material.metallic),
    @raylib.ShaderUniformFloat,
  )
  set_shader_uniform(
    shader,
    state.material_roughness_loc,
    bytes_from_float(material.roughness),
    @raylib.ShaderUniformFloat,
  )
  set_shader_uniform(
    shader,
    state.material_alpha_mode_loc,
    bytes_from_int(alpha_mode_to_int(material.alpha_mode)),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform(
    shader,
    state.material_alpha_cutoff_loc,
    bytes_from_float(material.alpha_cutoff),
    @raylib.ShaderUniformFloat,
  )
  set_shader_uniform(
    shader,
    state.material_has_texture_loc,
    bytes_from_int(if texture_bundle is Some(_) { 1 } else { 0 }),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform(
    shader,
    state.material_unlit_loc,
    bytes_from_int(if material.unlit { 1 } else { 0 }),
    @raylib.ShaderUniformInt,
  )
  set_shader_uniform(
    shader,
    state.material_receive_shadows_loc,
    bytes_from_int(if receive_shadows { 1 } else { 0 }),
    @raylib.ShaderUniformInt,
  )
  let default_transform = @render3d_types.default_texture_transform3d()
  upload_texture_transform_uniforms(
    shader,
    state.base_uv_offset_scale_loc,
    state.base_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.base_transform
    }),
  )
  upload_texture_transform_uniforms(
    shader,
    state.metallic_roughness_uv_offset_scale_loc,
    state.metallic_roughness_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.metallic_roughness_transform
    }),
  )
  upload_texture_transform_uniforms(
    shader,
    state.normal_uv_offset_scale_loc,
    state.normal_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.normal_transform
    }),
  )
  upload_texture_transform_uniforms(
    shader,
    state.occlusion_uv_offset_scale_loc,
    state.occlusion_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.occlusion_transform
    }),
  )
  upload_texture_transform_uniforms(
    shader,
    state.emissive_uv_offset_scale_loc,
    state.emissive_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.emissive_transform
    }),
  )
  state
}

///|
fn alpha_mode_to_int(mode : @render3d_types.AlphaMode3D) -> Int {
  match mode {
    Opaque => 0
    Mask => 1
    Blend => 2
  }
}

///|
fn to_ray_camera3d(camera : @render3d_types.FrameCamera3D) -> @raylib.Camera3D {
  @raylib.Camera3D::new(
    to_ray_vector3_smath(camera.position),
    to_ray_vector3_smath(camera.target),
    to_ray_vector3_smath(camera.up),
    to_float(
      match camera.projection {
        Perspective => camera.fov_y
        Orthographic =>
          camera.orthographic_size.map_or(10.0, fn(size) { size[Y] })
      },
    ),
    match camera.projection {
      Perspective => @raylib.CameraPerspective
      Orthographic => @raylib.CameraOrthographic
    },
  )
}

///|
fn configured_filter() -> Int {
  if backend.image_smooth {
    @raylib.TextureFilterBilinear
  } else {
    @raylib.TextureFilterPoint
  }
}

///|
fn file_extension(path : String) -> String {
  if path.to_lower().has_prefix("data:") {
    return data_uri_extension(path)
  }
  let slash_idx = if path.rev_find("/") is Some(i) { i } else { -1 }
  let backslash_idx = if path.rev_find("\\") is Some(i) { i } else { -1 }
  let last_separator = if slash_idx > backslash_idx {
    slash_idx
  } else {
    backslash_idx
  }
  if path.rev_find(".") is Some(dot_idx) && dot_idx > last_separator {
    path.unsafe_substring(start=dot_idx, end=path.length())
  } else {
    ".bin"
  }
}

///|
fn data_uri_extension(uri : String) -> String {
  guard uri.find(",") is Some(comma_idx) else { return ".bin" }
  let meta = uri.unsafe_substring(start=0, end=comma_idx).to_lower()
  if meta.contains("image/png") {
    ".png"
  } else if meta.contains("image/jpeg") {
    ".jpg"
  } else if meta.contains("image/webp") {
    ".webp"
  } else if meta.contains("image/bmp") {
    ".bmp"
  } else if meta.contains("image/tga") {
    ".tga"
  } else {
    ".bin"
  }
}

///|
fn decode_data_uri_base64(uri : String) -> Bytes? {
  guard uri.find(",") is Some(comma_idx) else { return None }
  let meta = uri.unsafe_substring(start=0, end=comma_idx).to_lower()
  if !meta.has_suffix(";base64") {
    return None
  }
  let payload = uri.unsafe_substring(start=comma_idx + 1, end=uri.length())
  Some(@base64.decode_lossy(payload.view()))
}

///|
fn get_embedded_asset(path : String) -> Bytes? {
  if backend.embedded_asset_cache.get(path) is Some(cached) {
    return Some(cached)
  }
  if (backend.embedded_asset_lookup)(path) is Some(bytes) {
    backend.embedded_asset_cache.set(path, bytes)
    Some(bytes)
  } else {
    None
  }
}

///|
fn warn_texture_issue(key : String, message : String) -> Unit {
  if backend.texture_warning_keys.contains(key) {
    return
  }
  backend.texture_warning_keys.add(key)
  println("[selene-raylib][texture-warning] \{message}")
}

///|
fn get_or_create_primitive_mesh(
  key : String,
  create : () -> @raylib.Mesh,
) -> @raylib.Mesh {
  if backend.primitive_meshes.get(key) is Some(mesh) {
    return mesh
  }
  let mesh = create()
  backend.primitive_meshes.set(key, mesh)
  mesh
}

///|
fn draw_lit_mesh_with_material(
  mesh : @raylib.Mesh,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  ignore(
    upload_lighting_uniforms(
      frame, camera_position, material, texture_bundle, receive_shadows, shadow_state,
    ),
  )
  let effective_bundle = texture_bundle.unwrap_or(
    fallback_lighting_texture_bundle(),
  )
  let ray_material = get_lit_material(texture_bundle is Some(_))
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapAlbedo,
    effective_bundle.base_texture,
  )
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapEmission,
    effective_bundle.emissive_texture,
  )
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapMetalness,
    effective_bundle.metallic_roughness_texture,
  )
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapRoughness,
    effective_bundle.metallic_roughness_texture,
  )
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapOcclusion,
    effective_bundle.occlusion_texture,
  )
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapNormal,
    effective_bundle.normal_texture,
  )
  if material.double_sided {
    @rl.disable_backface_culling()
  } else {
    @rl.enable_backface_culling()
  }
  bind_shadow_textures(shadow_state)
  @raylib.draw_mesh(mesh, ray_material, @raylib.Matrix::identity())
  unbind_shadow_textures(shadow_state)
  @rl.disable_backface_culling()
}

///|
fn get_texture(path : String) -> @raylib.Texture {
  if backend.textures.get(path) is Some(texture) {
    return texture
  }
  let texture = if get_embedded_asset(path) is Some(bytes) {
    let image = @raylib.load_image_from_memory(
      file_extension(path),
      bytes,
      bytes.length(),
    )
    let texture = @raylib.load_texture_from_image(image)
    @raylib.unload_image(image)
    texture
  } else if path.to_lower().has_prefix("data:") {
    match decode_data_uri_base64(path) {
      Some(bytes) => {
        let image = @raylib.load_image_from_memory(
          file_extension(path),
          bytes,
          bytes.length(),
        )
        let texture = @raylib.load_texture_from_image(image)
        @raylib.unload_image(image)
        texture
      }
      None => @raylib.load_texture(path)
    }
  } else {
    @raylib.load_texture(path)
  }
  @raylib.set_texture_filter(texture, configured_filter())
  backend.textures.set(path, texture)
  texture
}

///|
fn get_sound(path : String) -> @raylib.Sound {
  if backend.sounds.get(path) is Some(sound) {
    return sound
  }
  let sound = if get_embedded_asset(path) is Some(bytes) {
    let wave = @raylib.load_wave_from_memory(
      file_extension(path),
      bytes,
      bytes.length(),
    )
    let sound = @raylib.load_sound_from_wave(wave)
    @raylib.unload_wave(wave)
    sound
  } else {
    @raylib.load_sound(path)
  }
  backend.sounds.set(path, sound)
  sound
}

///|
fn create_music(path : String) -> @raylib.Music {
  if get_embedded_asset(path) is Some(bytes) {
    @raylib.load_music_stream_from_memory(
      file_extension(path),
      bytes,
      bytes.length(),
    )
  } else {
    @raylib.load_music_stream(path)
  }
}

///|
fn next_audio_instance() -> AudioInstance {
  let instance = backend.next_audio_instance.reinterpret_as_int()
  backend.next_audio_instance += 1U
  instance
}

///|
fn free_audio_playback(playback : AudioPlayback) -> Unit {
  match playback.kind {
    Sound(sound) => {
      @raylib.stop_sound(sound)
      @raylib.unload_sound_alias(sound)
    }
    Music(music) => {
      @raylib.stop_music_stream(music)
      @raylib.unload_music_stream(music)
    }
  }
}

///|
fn tick_audio_playback(playback : AudioPlayback) -> Unit {
  if playback.finished || playback.paused {
    return
  }
  match playback.kind {
    Sound(sound) =>
      if playback.started && !@raylib.is_sound_playing(sound) {
        if playback.loop_ {
          @raylib.play_sound(sound)
        } else {
          playback.finished = true
        }
      }
    Music(music) => {
      @raylib.update_music_stream(music)
      if playback.started && !@raylib.is_music_stream_playing(music) {
        if playback.loop_ {
          @raylib.play_music_stream(music)
        } else {
          playback.finished = true
        }
      }
    }
  }
}

///|
fn mark_frame_drawn() -> Unit {
  backend.frame_has_draw_commands = true
}

///|
fn get_font_by_family(family : String) -> @raylib.Font {
  if backend.font_alias.get(family) is Some(path) {
    if backend.fonts_by_path.get(path) is Some(font) {
      return font
    }
  }
  @raylib.get_font_default()
}

///|
fn key_to_raylib(code : @inputs.Code) -> Int {
  match code {
    KeyA => @raylib.KeyA
    KeyB => @raylib.KeyB
    KeyC => @raylib.KeyC
    KeyD => @raylib.KeyD
    KeyE => @raylib.KeyE
    KeyF => @raylib.KeyF
    KeyG => @raylib.KeyG
    KeyH => @raylib.KeyH
    KeyI => @raylib.KeyI
    KeyJ => @raylib.KeyJ
    KeyK => @raylib.KeyK
    KeyL => @raylib.KeyL
    KeyM => @raylib.KeyM
    KeyN => @raylib.KeyN
    KeyO => @raylib.KeyO
    KeyP => @raylib.KeyP
    KeyQ => @raylib.KeyQ
    KeyR => @raylib.KeyR
    KeyS => @raylib.KeyS
    KeyT => @raylib.KeyT
    KeyU => @raylib.KeyU
    KeyV => @raylib.KeyV
    KeyW => @raylib.KeyW
    KeyX => @raylib.KeyX
    KeyY => @raylib.KeyY
    KeyZ => @raylib.KeyZ
    ArrowUp => @raylib.KeyUp
    ArrowDown => @raylib.KeyDown
    ArrowLeft => @raylib.KeyLeft
    ArrowRight => @raylib.KeyRight
    Tab => @raylib.KeyTab
    ShiftLeft => @raylib.KeyLeftShift
    Space => @raylib.KeySpace
    Enter => @raylib.KeyEnter
    Escape => @raylib.KeyEscape
  }
}

///|
fn all_codes() -> Array[@inputs.Code] {
  [
    KeyA,
    KeyB,
    KeyC,
    KeyD,
    KeyE,
    KeyF,
    KeyG,
    KeyH,
    KeyI,
    KeyJ,
    KeyK,
    KeyL,
    KeyM,
    KeyN,
    KeyO,
    KeyP,
    KeyQ,
    KeyR,
    KeyS,
    KeyT,
    KeyU,
    KeyV,
    KeyW,
    KeyX,
    KeyY,
    KeyZ,
    ArrowUp,
    ArrowDown,
    ArrowLeft,
    ArrowRight,
    Tab,
    ShiftLeft,
    Space,
    Enter,
    Escape,
  ]
}

///|
fn sync_key_events() -> Unit {
  if backend.key_events is Some(pressed_keys) {
    for code in all_codes() {
      if @raylib.is_key_down(key_to_raylib(code)) {
        pressed_keys.add(code)
      } else {
        pressed_keys.remove(code)
      }
    }
  }
}

///|
fn sync_mouse_events() -> Unit {
  if backend.mouse_state is Some(mouse) &&
    backend.mouse_movement is Some(movement) {
    let pos = @raylib.get_mouse_position() |> to_selene_vec2
    let delta = @raylib.get_mouse_delta() |> to_selene_vec2
    let wheel = @raylib.get_mouse_wheel_move_v() |> to_selene_vec2
    // Keep raw screen-space mouse coordinates consistent with canvas backend.
    // Core click systems are responsible for applying zoom conversion.
    mouse.pos = @smath.Vec2D(pos[X], pos[Y])
    movement.movement = @smath.Vec2D(delta[X], delta[Y])
    if backend.mouse_wheel is Some(mouse_wheel) {
      mouse_wheel.delta = @smath.Vec2D(wheel[X], wheel[Y])
    }
    mouse.left_button = @raylib.is_mouse_button_down(@raylib.MouseButtonLeft)
    mouse.right_button = @raylib.is_mouse_button_down(@raylib.MouseButtonRight)
    mouse.middle_button = @raylib.is_mouse_button_down(
      @raylib.MouseButtonMiddle,
    )
  }
}

///|
const MAX_GAMEPADS : Int = 8

///|
fn sync_gamepad_events() -> Unit {
  guard backend.gamepads_state is Some(gamepads) else { return }
  guard backend.gamepad_buttons_state is Some(buttons) else { return }
  guard backend.gamepad_axes_state is Some(axes) else { return }

  gamepads.clear()
  buttons.clear()
  axes.clear()

  for id in 0..<MAX_GAMEPADS {
    if !@raylib.is_gamepad_available(id) {
      continue
    }
    let gamepad = @inputs.Gamepad::new(id)
    gamepads.add(gamepad)
    sync_one_gamepad_buttons(id, gamepad, buttons)
    sync_one_gamepad_axes(id, gamepad, axes)
  }
}

///|
fn sync_one_gamepad_buttons(
  id : Int,
  gamepad : @inputs.Gamepad,
  buttons : Set[@inputs.GamepadButtonInput],
) -> Unit {
  let mappings : Array[(Int, @inputs.GamepadButton)] = [
    (@raylib.GamepadButtonRightFaceDown, South),
    (@raylib.GamepadButtonRightFaceRight, East),
    (@raylib.GamepadButtonRightFaceUp, North),
    (@raylib.GamepadButtonRightFaceLeft, West),
    (@raylib.GamepadButtonLeftTrigger1, LeftTrigger),
    (@raylib.GamepadButtonLeftTrigger2, LeftTrigger2),
    (@raylib.GamepadButtonRightTrigger1, RightTrigger),
    (@raylib.GamepadButtonRightTrigger2, RightTrigger2),
    (@raylib.GamepadButtonMiddleLeft, Select),
    (@raylib.GamepadButtonMiddleRight, Start),
    (@raylib.GamepadButtonMiddle, Mode),
    (@raylib.GamepadButtonLeftThumb, LeftThumb),
    (@raylib.GamepadButtonRightThumb, RightThumb),
    (@raylib.GamepadButtonLeftFaceUp, DPadUp),
    (@raylib.GamepadButtonLeftFaceDown, DPadDown),
    (@raylib.GamepadButtonLeftFaceLeft, DPadLeft),
    (@raylib.GamepadButtonLeftFaceRight, DPadRight),
  ]
  for mapping in mappings {
    if @raylib.is_gamepad_button_down(id, mapping.0) {
      buttons.add(@inputs.GamepadButtonInput::new(gamepad, mapping.1))
    }
  }
}

///|
fn sync_one_gamepad_axes(
  id : Int,
  gamepad : @inputs.Gamepad,
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, LeftStickX),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftX).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, LeftStickY),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftY).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, RightStickX),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisRightX).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, RightStickY),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisRightY).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, LeftZ),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftTrigger).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput::new(gamepad, RightZ),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisRightTrigger).to_double(),
  )
}

///|
fn sync_mouse_lock() -> Unit {
  if backend.lock_state is Some(lock_state) {
    // Keep requested lock state separate from runtime cursor visibility.
    if lock_state.val != backend.cursor_locked {
      backend.lock_requested = lock_state.val
    }
    if backend.lock_requested {
      if !backend.cursor_locked && @raylib.is_window_focused() {
        @raylib.disable_cursor()
      }
    } else if backend.cursor_locked {
      @raylib.enable_cursor()
    }
    backend.cursor_locked = @raylib.is_cursor_hidden()
    lock_state.val = backend.cursor_locked
  }
}

///|
fn update_audio_instances() -> Unit {
  for _instance, playback in backend.audio_instances {
    tick_audio_playback(playback)
  }
  for pair in backend.audio_instances.to_array() {
    if pair.1.finished {
      free_audio_playback(pair.1)
      backend.audio_instances.remove(pair.0)
    }
  }
}

///|
fn cleanup_resources() -> Unit {
  for pair in backend.audio_instances.to_array() {
    free_audio_playback(pair.1)
  }
  backend.audio_instances.clear()
  for _path, sound in backend.sounds {
    @raylib.unload_sound(sound)
  }
  backend.sounds.clear()
  for _path, font in backend.fonts_by_path {
    @raylib.unload_font(font)
  }
  backend.fonts_by_path.clear()
  backend.font_alias.clear()
  backend.embedded_asset_cache.clear()
  for _key, mesh in backend.primitive_meshes {
    @raylib.unload_mesh(mesh)
  }
  backend.primitive_meshes.clear()
  let cleanup_default_material = if backend.lit_material is Some(_) ||
    backend.lit_textured_material is Some(_) ||
    backend.shadow_material is Some(_) {
    Some(@raylib.load_material_default())
  } else {
    None
  }
  if backend.lit_material is Some(material) {
    if cleanup_default_material is Some(default_material) {
      reset_material_from_material(material, default_material)
    }
    @raylib.unload_material(material)
  }
  backend.lit_material = None
  if backend.lit_textured_material is Some(material) {
    if cleanup_default_material is Some(default_material) {
      reset_material_from_material(material, default_material)
    }
    @raylib.unload_material(material)
  }
  backend.lit_textured_material = None
  if backend.shadow_material is Some(material) {
    if cleanup_default_material is Some(default_material) {
      reset_material_from_material(material, default_material)
    }
    @raylib.unload_material(material)
  }
  backend.shadow_material = None
  if cleanup_default_material is Some(material) {
    @raylib.unload_material(material)
  }
  if backend.lighting_shader is Some(state) {
    @raylib.unload_shader(state.shader)
  }
  backend.lighting_shader = None
  if backend.shadow_shader is Some(state) {
    @raylib.unload_shader(state.shader)
  }
  backend.shadow_shader = None
  for _path, texture in backend.textures {
    @raylib.unload_texture(texture)
  }
  backend.textures.clear()
  for render_texture in backend.shadow_render_textures {
    @raylib.unload_shadowmap_render_texture(render_texture)
  }
  backend.shadow_render_textures.clear()
  backend.directional_shadow_tile_sizes.clear()
  backend.directional_shadow_atlas_columns.clear()
  backend.directional_shadow_atlas_rows.clear()
  if backend.spot_shadow_render_texture is Some(render_texture) {
    @raylib.unload_shadowmap_render_texture(render_texture)
  }
  backend.spot_shadow_render_texture = None
  backend.spot_shadow_map_size = 0
  if backend.point_shadow_render_texture is Some(render_texture) {
    @raylib.unload_shadowmap_render_texture(render_texture)
  }
  backend.point_shadow_render_texture = None
  backend.point_shadow_map_size = 0
  backend.meshes3d.clear()
  backend.materials3d.clear()
  backend.images3d.clear()
  backend.texture_warning_keys.clear()
}

///|
pub fn initialize(
  config : @runtime.WindowConfig,
  callbacks : @runtime.RunnerCallbacks,
) -> () -> Unit {
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  backend.image_smooth = config.image_smooth
  backend.close_requested = false
  fn() {
    @raylib.init_window(
      config.screen_width.to_int(),
      config.screen_height.to_int(),
      "Selene (raylib)",
    )
    @raylib.set_exit_key(@raylib.KeyNull)
    @raylib.set_target_fps(config.fps.reinterpret_as_int())
    if !@raylib.is_audio_device_ready() {
      @raylib.init_audio_device()
    }
    backend.texture_warning_keys.clear()
    (callbacks.startup)()
    while !backend.close_requested && !@raylib.window_should_close() {
      let delta = @raylib.get_frame_time().to_double()
      backend.realtime_delta = delta
      sync_key_events()
      sync_mouse_events()
      sync_gamepad_events()
      sync_mouse_lock()
      (callbacks.game_loop)(delta * backend.time_scale)
      @raylib.begin_drawing()
      @raylib.clear_background(@raylib.black)
      backend.frame_has_draw_commands = false
      (callbacks.render_loop)(delta * backend.time_scale)
      @raylib.end_drawing()
    }
    cleanup_resources()
    if @raylib.is_audio_device_ready() {
      @raylib.close_audio_device()
    }
    @raylib.close_window()
  }
}

///|
pub fn draw_image(
  command : @render2d_types.ImageDrawCommand2D,
  image_path : String,
) -> Unit {
  mark_frame_drawn()
  let texture = get_texture(image_path)
  draw_image_repeat_transform(texture, command)
}

///|
pub fn push_clip_rect(rect : @smath.Rect) -> Unit {
  let next = match clip_stack.last() {
    Some(current) =>
      clip_rect_intersection(current, rect).unwrap_or({
        position: @smath.Vec2D::zero(),
        size: @smath.Vec2D::zero(),
      })
    None => rect
  }
  clip_stack.push(next)
  refresh_clip_stack()
}

///|
pub fn pop_clip_rect() -> Unit {
  if clip_stack.is_empty() {
    return
  }
  ignore(clip_stack.pop())
  refresh_clip_stack()
}

///|
pub fn reset_clip_stack() -> Unit {
  while !clip_stack.is_empty() {
    ignore(clip_stack.pop())
  }
  @raylib.end_scissor_mode()
}

///|
pub fn register_key_events(pressed_keys : Set[@inputs.Code]) -> Unit {
  backend.key_events = Some(pressed_keys)
}

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_movement : @inputs.MouseMovement,
  mouse_wheel : @inputs.MouseWheel,
) -> Unit {
  backend.mouse_state = Some(mouse)
  backend.mouse_movement = Some(mouse_movement)
  backend.mouse_wheel = Some(mouse_wheel)
}

///|
pub fn register_gamepad_events(
  gamepads : Set[@inputs.Gamepad],
  buttons : Set[@inputs.GamepadButtonInput],
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  backend.gamepads_state = Some(gamepads)
  backend.gamepad_buttons_state = Some(buttons)
  backend.gamepad_axes_state = Some(axes)
  sync_gamepad_events()
}

///|
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  backend.lock_state = Some(locked)
  backend.lock_requested = locked.val
  sync_mouse_lock()
  backend.cursor_locked = @raylib.is_cursor_hidden()
  locked.val = backend.cursor_locked
}

///|
pub fn draw_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  mark_frame_drawn()
  let font = get_font_by_family(command.style.family)
  let measured = measure_text(command.style, command.text)
  let text_width = measured[X]
  let text_height = measured[Y]
  let mut x = command.position[X]
  let mut y = command.position[Y]
  match command.style.align {
    Left => ()
    Center => x -= text_width / 2.0
    Right => x -= text_width
  }
  match command.style.baseline {
    Top => ()
    Center => y -= text_height / 2.0
    Bottom => y -= text_height
  }
  @raylib.draw_text_ex(
    font,
    command.text,
    to_ray_vector2(x, y),
    to_float(command.style.size),
    0.0,
    to_ray_color(command.style.color),
  )
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @smath.Vec2D {
  let font = get_font_by_family(style.family)
  let measured = @raylib.measure_text_ex(font, text, to_float(style.size), 0.0)
  @smath.Vec2D(vector2_x(measured), vector2_y(measured))
}

///|
pub fn draw_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  mark_frame_drawn()
  let rect = to_ray_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
  )
  @raylib.draw_rectangle_rec(rect, to_ray_color(command.fill_color))
  if command.stroke_color is Some(stroke_color) {
    @raylib.draw_rectangle_lines_ex(rect, 1.0, to_ray_color(stroke_color))
  }
}

///|
pub fn draw_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  mark_frame_drawn()
  let center = to_ray_vector2(command.center[X], command.center[Y])
  let radius = to_float(command.radius)
  @raylib.draw_circle_v(center, radius, to_ray_color(command.fill_color))
  if command.stroke_color is Some(stroke_color) {
    @raylib.draw_circle_lines_v(center, radius, to_ray_color(stroke_color))
  }
}

///|
pub fn draw_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  mark_frame_drawn()
  let rect = to_ray_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
  )
  @raylib.draw_rectangle_gradient_ex(
    rect,
    to_ray_color(command.color_start),
    to_ray_color(command.color_start),
    to_ray_color(command.color_end),
    to_ray_color(command.color_end),
  )
}

///|
fn begin_3d(camera : @render3d_types.FrameCamera3D) -> Unit {
  @raylib.begin_mode_3d(to_ray_camera3d(camera))
}

///|
fn end_3d() -> Unit {
  @raylib.end_mode_3d()
}

///|
pub fn sync_mesh_asset(
  handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.MeshAsset,
) -> Unit {
  backend.meshes3d.set(handle, mesh)
}

///|
pub fn sync_material_asset(
  handle : @render3d_types.MaterialHandle,
  material : @render3d_types.StandardMaterial3D,
) -> Unit {
  backend.materials3d.set(handle, material)
}

///|
pub fn sync_image_asset(
  handle : @render3d_types.ImageHandle,
  image : @render3d_types.ImageAsset,
) -> Unit {
  backend.images3d.set(handle, image)
}

///|
pub fn release_mesh_asset(handle : @render3d_types.MeshHandle) -> Unit {
  backend.meshes3d.remove(handle)
}

///|
pub fn release_material_asset(handle : @render3d_types.MaterialHandle) -> Unit {
  backend.materials3d.remove(handle)
}

///|
pub fn release_image_asset(handle : @render3d_types.ImageHandle) -> Unit {
  backend.images3d.remove(handle)
}

///|
pub fn render_3d_frame(frame : @render3d_types.RenderFrame3D) -> Unit {
  guard frame.camera is Some(active_camera) else { return }
  let shadow_state = render_directional_shadow_map(frame, active_camera)
  if !backend.frame_has_draw_commands {
    @raylib.clear_background(to_ray_color(frame.clear_color))
  }
  mark_frame_drawn()
  begin_3d(active_camera)
  for item in frame.items {
    guard backend.meshes3d.get(item.mesh) is Some(mesh_asset) else { continue }
    let material = backend.materials3d
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    draw_mesh3d_instance(
      mesh_asset,
      material,
      item.transform,
      frame,
      active_camera.position,
      item.receive_shadows,
      shadow_state,
    )
  }
  end_3d()
}

///|
fn draw_mesh3d_instance(
  mesh_asset : @render3d_types.MeshAsset,
  material : @render3d_types.StandardMaterial3D,
  transform : @render3d_types.FrameTransform3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  @rl.push_matrix()
  @rl.translatef(
    to_float(transform.translation.x),
    to_float(transform.translation.y),
    to_float(transform.translation.z),
  )
  apply_quat_rotation(transform.rotation)
  @rl.scalef(
    to_float(transform.scale.x),
    to_float(transform.scale.y),
    to_float(transform.scale.z),
  )
  let texture_bundle = resolve_material_texture_bundle(material)
  match mesh_asset.primitive {
    Cube(size) =>
      draw_lit_cuboid(
        size, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    Sphere(radius) =>
      draw_lit_sphere(
        radius, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    Cylinder(radius_top, radius_bottom, height, slices) =>
      draw_lit_cylinder(
        radius_top, radius_bottom, height, slices, material, frame, camera_position,
        texture_bundle, receive_shadows, shadow_state,
      )
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
      let cuboid = @smath.Vec3::new(size.x, thickness, size.z)
      draw_lit_cuboid(
        cuboid, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    }
    Triangles(mesh) =>
      draw_triangle_mesh(
        mesh, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
  }
  @rl.pop_matrix()
}

///|
const TEXTURED_SPHERE_STACKS : Int = 16

///|
const TEXTURED_SPHERE_SLICES : Int = 24

///|
fn draw_lit_cuboid(
  size : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let key = "cube:\{size.x}:\{size.y}:\{size.z}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_cube(to_float(size.x), to_float(size.y), to_float(size.z))
  })
  draw_lit_mesh_with_material(
    mesh, frame, camera_position, material, texture_bundle, receive_shadows, shadow_state,
  )
}

///|
fn draw_lit_sphere(
  radius : Double,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let key = "sphere:\{radius}:\{TEXTURED_SPHERE_SLICES}:\{TEXTURED_SPHERE_STACKS}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_sphere(
      to_float(radius),
      TEXTURED_SPHERE_SLICES,
      TEXTURED_SPHERE_STACKS,
    )
  })
  draw_lit_mesh_with_material(
    mesh, frame, camera_position, material, texture_bundle, receive_shadows, shadow_state,
  )
}

///|
fn draw_lit_cylinder(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  if (radius_top - radius_bottom).abs() <= 0.000001 {
    let key = "cylinder:\{radius_top}:\{height}:\{slices}"
    let mesh = get_or_create_primitive_mesh(key, fn() {
      @raylib.gen_mesh_cylinder(to_float(radius_top), to_float(height), slices)
    })
    draw_lit_mesh_with_material(
      mesh, frame, camera_position, material, texture_bundle, receive_shadows, shadow_state,
    )
    return
  }
  let (vertices, uvs, normals) = build_cylinder_mesh(
    radius_top, radius_bottom, height, slices,
  )
  if vertices.length() < 3 {
    return
  }
  draw_triangle_vertices(
    vertices,
    Some(uvs),
    normals,
    None,
    texture_bundle,
    material,
    frame,
    camera_position,
    receive_shadows,
    shadow_state,
  )
}

///|
fn resolve_material_texture_source(
  binding : @render3d_types.TextureBinding3D,
) -> MaterialTextureSource3D? {
  guard backend.images3d.get(binding.image) is Some(image_asset) else {
    warn_texture_issue(
      "missing_image_handle:\{binding.image}",
      "material texture handle \{binding.image} is not synced; fallback to default texture",
    )
    return None
  }
  let texture = get_texture(image_asset.path)
  apply_texture_sampler(texture, binding.sampler)
  let texture_id = @raylib.get_texture_id(texture)
  let width = @raylib.get_texture_width(texture)
  let height = @raylib.get_texture_height(texture)
  if texture_id <= 0 || width <= 0 || height <= 0 {
    warn_texture_issue(
      "invalid_texture:\{image_asset.path}",
      "failed to load texture '\{image_asset.path}' (id=\{texture_id}, size=\{width}x\{height}); fallback to base_color",
    )
    return None
  }
  Some({
    texture,
    texcoord_set: binding.texcoord_set,
    transform: binding.transform,
  })
}

///|
fn resolve_material_texture_bundle(
  material : @render3d_types.StandardMaterial3D,
) -> MaterialTextureBundle3D? {
  let base_source = material.base_color_texture.bind(
    resolve_material_texture_source,
  )
  let emissive_source = material.emissive_texture.bind(
    resolve_material_texture_source,
  )
  let metallic_roughness_source = material.metallic_roughness_texture.bind(
    resolve_material_texture_source,
  )
  let occlusion_source = material.occlusion_texture.bind(
    resolve_material_texture_source,
  )
  let normal_source = material.normal_texture.bind(
    resolve_material_texture_source,
  )
  let primary = match base_source {
    Some(base) => Some(base)
    None =>
      match emissive_source {
        Some(emissive) => Some(emissive)
        None =>
          match metallic_roughness_source {
            Some(metallic_roughness) => Some(metallic_roughness)
            None =>
              match occlusion_source {
                Some(occlusion) => Some(occlusion)
                None => normal_source
              }
          }
      }
  }
  guard primary is Some(primary_source) else { return None }
  let resolve_aligned_source = fn(
    label : String,
    source : MaterialTextureSource3D?,
  ) -> MaterialTextureSource3D? {
    match source {
      Some(source) =>
        if source.texcoord_set == primary_source.texcoord_set {
          Some(source)
        } else {
          warn_texture_issue(
            "uv_set_mismatch:\{label}:\{primary_source.texcoord_set}:\{source.texcoord_set}",
            "raylib backend currently requires glTF material textures to share one UV set; ignoring \{label} on TEXCOORD_\{source.texcoord_set} because the active stack uses TEXCOORD_\{primary_source.texcoord_set}",
          )
          None
        }
      None => None
    }
  }
  let base_source = resolve_aligned_source("base_color_texture", base_source)
  let emissive_source = resolve_aligned_source(
    "emissive_texture", emissive_source,
  )
  let metallic_roughness_source = resolve_aligned_source(
    "metallic_roughness_texture", metallic_roughness_source,
  )
  let occlusion_source = resolve_aligned_source(
    "occlusion_texture", occlusion_source,
  )
  let normal_source = resolve_aligned_source("normal_texture", normal_source)
  let default_transform = @render3d_types.default_texture_transform3d()
  Some({
    base_texture: base_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    emissive_texture: emissive_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    metallic_roughness_texture: metallic_roughness_source.map_or(
      get_white_texture(),
      fn(source) { source.texture },
    ),
    occlusion_texture: occlusion_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    normal_texture: normal_source.map_or(get_flat_normal_texture(), fn(source) {
      source.texture
    }),
    base_transform: base_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    emissive_transform: emissive_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    metallic_roughness_transform: metallic_roughness_source.map_or(
      default_transform,
      fn(source) { source.transform },
    ),
    occlusion_transform: occlusion_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    normal_transform: normal_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    texcoord_set: primary_source.texcoord_set,
  })
}

///|
fn texture_wrap_to_raylib(wrap : @render3d_types.TextureWrap3D) -> Int {
  match wrap {
    ClampToEdge => @raylib.TextureWrapClamp
    MirroredRepeat => @raylib.TextureWrapMirrorRepeat
    Repeat => @raylib.TextureWrapRepeat
  }
}

///|
fn texture_filter_to_raylib(sampler : @render3d_types.TextureSampler3D) -> Int {
  let nearest = sampler.mag_filter == Nearest || sampler.min_filter == Nearest
  match sampler.mipmap_filter {
    Some(_) =>
      if nearest {
        @raylib.TextureFilterPoint
      } else {
        @raylib.TextureFilterTrilinear
      }
    None =>
      if nearest {
        @raylib.TextureFilterPoint
      } else {
        @raylib.TextureFilterBilinear
      }
  }
}

///|
fn apply_texture_sampler(
  texture : @raylib.Texture,
  sampler : @render3d_types.TextureSampler3D,
) -> Unit {
  @raylib.set_texture_wrap(texture, texture_wrap_to_raylib(sampler.wrap_u))
  @raylib.set_texture_filter(texture, texture_filter_to_raylib(sampler))
}

///|
fn build_cylinder_mesh(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
) -> (Array[@smath.Vec3], Array[@smath.Vec2D], Array[@smath.Vec3]) {
  let vertices : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2D] = []
  let normals : Array[@smath.Vec3] = []
  let segment_count = if slices < 3 { 3 } else { slices }
  let half_h = height / 2.0
  let slope_y = if height.abs() < 0.000001 {
    0.0
  } else {
    (radius_bottom - radius_top) / height
  }
  for segment in 0..<segment_count {
    let u0 = segment.to_double() / segment_count.to_double()
    let u1 = (segment + 1).to_double() / segment_count.to_double()
    let phi0 = u0 * 2.0 * @cmath.PI
    let phi1 = u1 * 2.0 * @cmath.PI
    let top0 = @smath.Vec3::new(
      radius_top * @cmath.cos(phi0),
      half_h,
      radius_top * @cmath.sin(phi0),
    )
    let top1 = @smath.Vec3::new(
      radius_top * @cmath.cos(phi1),
      half_h,
      radius_top * @cmath.sin(phi1),
    )
    let bot0 = @smath.Vec3::new(
      radius_bottom * @cmath.cos(phi0),
      -half_h,
      radius_bottom * @cmath.sin(phi0),
    )
    let bot1 = @smath.Vec3::new(
      radius_bottom * @cmath.cos(phi1),
      -half_h,
      radius_bottom * @cmath.sin(phi1),
    )
    let side_normal0 = @smath.Vec3::new(
      @cmath.cos(phi0),
      slope_y,
      @cmath.sin(phi0),
    ).normalize()
    let side_normal1 = @smath.Vec3::new(
      @cmath.cos(phi1),
      slope_y,
      @cmath.sin(phi1),
    ).normalize()
    push_textured_triangle(
      vertices,
      uvs,
      normals,
      top0,
      bot0,
      bot1,
      @smath.Vec2D(u0, 0.0),
      @smath.Vec2D(u0, 1.0),
      @smath.Vec2D(u1, 1.0),
      side_normal0,
      side_normal0,
      side_normal1,
    )
    push_textured_triangle(
      vertices,
      uvs,
      normals,
      top0,
      bot1,
      top1,
      @smath.Vec2D(u0, 0.0),
      @smath.Vec2D(u1, 1.0),
      @smath.Vec2D(u1, 0.0),
      side_normal0,
      side_normal1,
      side_normal1,
    )
    if radius_top.abs() > 0.000001 {
      let top_center = @smath.Vec3::new(0.0, half_h, 0.0)
      let top_normal = @smath.Vec3::new(0.0, 1.0, 0.0)
      push_textured_triangle(
        vertices,
        uvs,
        normals,
        top_center,
        top1,
        top0,
        @smath.Vec2D(0.5, 0.5),
        @smath.Vec2D(0.5 + 0.5 * @cmath.cos(phi1), 0.5 + 0.5 * @cmath.sin(phi1)),
        @smath.Vec2D(0.5 + 0.5 * @cmath.cos(phi0), 0.5 + 0.5 * @cmath.sin(phi0)),
        top_normal,
        top_normal,
        top_normal,
      )
    }
    if radius_bottom.abs() > 0.000001 {
      let bottom_center = @smath.Vec3::new(0.0, -half_h, 0.0)
      let bottom_normal = @smath.Vec3::new(0.0, -1.0, 0.0)
      push_textured_triangle(
        vertices,
        uvs,
        normals,
        bottom_center,
        bot0,
        bot1,
        @smath.Vec2D(0.5, 0.5),
        @smath.Vec2D(0.5 + 0.5 * @cmath.cos(phi0), 0.5 + 0.5 * @cmath.sin(phi0)),
        @smath.Vec2D(0.5 + 0.5 * @cmath.cos(phi1), 0.5 + 0.5 * @cmath.sin(phi1)),
        bottom_normal,
        bottom_normal,
        bottom_normal,
      )
    }
  }
  (vertices, uvs, normals)
}

///|
fn push_textured_triangle(
  vertices : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2D],
  normals : Array[@smath.Vec3],
  a : @smath.Vec3,
  b : @smath.Vec3,
  c : @smath.Vec3,
  uv_a : @smath.Vec2D,
  uv_b : @smath.Vec2D,
  uv_c : @smath.Vec2D,
  n_a : @smath.Vec3,
  n_b : @smath.Vec3,
  n_c : @smath.Vec3,
) -> Unit {
  vertices.push(a)
  vertices.push(b)
  vertices.push(c)
  uvs.push(uv_a)
  uvs.push(uv_b)
  uvs.push(uv_c)
  normals.push(n_a)
  normals.push(n_b)
  normals.push(n_c)
}

///|
fn apply_quat_rotation(quat : @smath.Quat) -> Unit {
  let normalized = quat.normalize()
  let w = @cmp.minimum(1.0, @cmp.maximum(-1.0, normalized.w))
  let angle = 2.0 * @cmath.acos(w)
  if angle.abs() < 0.0000001 {
    return
  }
  let sin_half = (1.0 - w * w).sqrt()
  let axis = if sin_half < 0.000001 {
    @smath.Vec3::new(0.0, 1.0, 0.0)
  } else {
    @smath.Vec3::new(
      normalized.x / sin_half,
      normalized.y / sin_half,
      normalized.z / sin_half,
    )
  }
  @rl.rotatef(
    to_float(angle * 180.0 / @cmath.PI),
    to_float(axis.x),
    to_float(axis.y),
    to_float(axis.z),
  )
}

///|
fn draw_triangle_mesh(
  mesh : @render3d_types.TriangleMesh3D,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let vertices = mesh.positions
  if vertices.length() < 3 {
    return
  }
  let normals = resolve_triangle_normals(mesh)
  let colors = mesh.colors
  if texture_bundle is Some(bundle) {
    guard mesh.uv_sets.get(bundle.texcoord_set) is Some(uvs) else {
      warn_texture_issue(
        "triangles_missing_uvs:\{bundle.texcoord_set}",
        "triangle mesh has material textures but no matching UV set; fallback to material factors only",
      )
      draw_triangle_vertices(
        vertices,
        None,
        normals,
        colors,
        None,
        material,
        frame,
        camera_position,
        receive_shadows,
        shadow_state,
      )
      return
    }
    if uvs.length() != vertices.length() {
      warn_texture_issue(
        "triangles_uv_mismatch:\{uvs.length()}:\{vertices.length()}",
        "triangle mesh UV count (\{uvs.length()}) != vertex count (\{vertices.length()}); fallback to base_color",
      )
      draw_triangle_vertices(
        vertices,
        None,
        normals,
        colors,
        None,
        material,
        frame,
        camera_position,
        receive_shadows,
        shadow_state,
      )
      return
    }
    draw_triangle_vertices(
      vertices,
      Some(uvs),
      normals,
      colors,
      Some(bundle),
      material,
      frame,
      camera_position,
      receive_shadows,
      shadow_state,
    )
    return
  }
  draw_triangle_vertices(
    vertices,
    None,
    normals,
    colors,
    None,
    material,
    frame,
    camera_position,
    receive_shadows,
    shadow_state,
  )
}

///|
fn resolve_triangle_normals(
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[@smath.Vec3] {
  mesh.normals
  .filter(fn(candidates) { candidates.length() == mesh.positions.length() })
  .unwrap_or(compute_flat_triangle_normals(mesh.positions))
}

///|
fn compute_flat_triangle_normals(
  positions : Array[@smath.Vec3],
) -> Array[@smath.Vec3] {
  let normals : Array[@smath.Vec3] = []
  let triangle_count = positions.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let a = positions[base]
    let b = positions[base + 1]
    let c = positions[base + 2]
    let mut normal = (b - a).cross(c - a)
    if normal.length_squared() <= 0.0000001 {
      normal = @smath.Vec3::new(0.0, 1.0, 0.0)
    } else {
      normal = normal.normalize()
    }
    normals.push(normal)
    normals.push(normal)
    normals.push(normal)
  }
  normals
}

///|
fn draw_triangle_vertices(
  vertices : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2D]?,
  normals : Array[@smath.Vec3],
  colors : Array[@render.Color]?,
  texture_bundle : MaterialTextureBundle3D?,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let state = upload_lighting_uniforms(
    frame, camera_position, material, texture_bundle, receive_shadows, shadow_state,
  )
  let effective_bundle = texture_bundle.unwrap_or(
    fallback_lighting_texture_bundle(),
  )
  ignore(@rl.check_render_batch_limit(vertices.length()))
  if material.double_sided {
    @rl.disable_backface_culling()
  } else {
    @rl.enable_backface_culling()
  }
  @raylib.begin_shader_mode(state.shader)
  @rl.active_texture_slot(0)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.base_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(1)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.metallic_roughness_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(2)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.normal_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(3)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.metallic_roughness_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(4)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.occlusion_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(5)
  @rl.enable_texture(
    @raylib.get_texture_id(effective_bundle.emissive_texture).reinterpret_as_uint(),
  )
  @rl.active_texture_slot(0)
  bind_shadow_textures(shadow_state)
  @rl.begin(@rl.Triangles)
  for index in 0..<vertices.length() {
    let vertex = vertices[index]
    let uv = uvs
      .map(fn(values) { values[index] })
      .unwrap_or(@smath.Vec2D(0.0, 0.0))
    let normal = normals[index]
    let color = colors
      .bind(fn(values) { values.get(index) })
      .unwrap_or({ r: 255U, g: 255U, b: 255U, a: 1.0 })
    @rl.color4ub(
      color.r.to_byte(),
      color.g.to_byte(),
      color.b.to_byte(),
      (@cmp.maximum(0.0, @cmp.minimum(1.0, color.a)) * 255.0)
      .to_int()
      .reinterpret_as_uint()
      .to_byte(),
    )
    @rl.normal3f(to_float(normal.x), to_float(normal.y), to_float(normal.z))
    @rl.tex_coord2f(to_float(uv[X]), to_float(uv[Y]))
    @rl.vertex3f(to_float(vertex.x), to_float(vertex.y), to_float(vertex.z))
  }
  @rl.end_()
  for slot in 0..<6 {
    @rl.active_texture_slot(slot)
    @rl.disable_texture()
  }
  @rl.active_texture_slot(0)
  unbind_shadow_textures(shadow_state)
  @raylib.end_shader_mode()
  @rl.disable_backface_culling()
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  let speed = clamp_playback_speed(speed)
  let instance = next_audio_instance()
  let playback = if loop_ {
    let music = create_music(audio_path)
    @raylib.set_music_volume(music, to_float(volume))
    @raylib.set_music_pitch(music, to_float(speed))
    if !paused {
      @raylib.play_music_stream(music)
    }
    {
      kind: Music(music),
      loop_: true,
      paused,
      started: !paused,
      finished: false,
    }
  } else {
    let base_sound = get_sound(audio_path)
    let sound = @raylib.load_sound_alias(base_sound)
    @raylib.set_sound_volume(sound, to_float(volume))
    @raylib.set_sound_pitch(sound, to_float(speed))
    if !paused {
      @raylib.play_sound(sound)
    }
    {
      kind: Sound(sound),
      loop_: false,
      paused,
      started: !paused,
      finished: false,
    }
  }
  backend.audio_instances.set(instance, playback)
  instance
}

///|
pub fn set_volume(instance~ : AudioInstance, volume~ : Double) -> Unit {
  guard backend.audio_instances.get(instance) is Some(playback) else { return }
  match playback.kind {
    Sound(sound) => @raylib.set_sound_volume(sound, to_float(volume))
    Music(music) => @raylib.set_music_volume(music, to_float(volume))
  }
}

///|
pub fn set_speed(instance~ : AudioInstance, speed~ : Double) -> Unit {
  guard backend.audio_instances.get(instance) is Some(playback) else { return }
  let speed = clamp_playback_speed(speed)
  match playback.kind {
    Sound(sound) => @raylib.set_sound_pitch(sound, to_float(speed))
    Music(music) => @raylib.set_music_pitch(music, to_float(speed))
  }
}

///|
pub fn set_loop(instance~ : AudioInstance, loop_~ : Bool) -> Unit {
  if backend.audio_instances.get(instance) is Some(playback) {
    playback.loop_ = loop_
  }
}

///|
pub fn set_paused(instance~ : AudioInstance, paused~ : Bool) -> Unit {
  guard backend.audio_instances.get(instance) is Some(playback) else { return }
  if playback.paused == paused {
    return
  }
  playback.paused = paused
  match playback.kind {
    Sound(sound) =>
      if paused {
        if playback.started {
          @raylib.pause_sound(sound)
        }
      } else if playback.started {
        @raylib.resume_sound(sound)
      } else {
        @raylib.play_sound(sound)
        playback.started = true
      }
    Music(music) =>
      if paused {
        if playback.started {
          @raylib.pause_music_stream(music)
        }
      } else if playback.started {
        @raylib.resume_music_stream(music)
      } else {
        @raylib.play_music_stream(music)
        playback.started = true
      }
  }
}

///|
pub fn stop(instance~ : AudioInstance) -> Unit {
  if backend.audio_instances.get(instance) is Some(playback) {
    free_audio_playback(playback)
    backend.audio_instances.remove(instance)
  }
}

///|
pub fn is_finished(instance~ : AudioInstance) -> Bool {
  match backend.audio_instances.get(instance) {
    Some(playback) => playback.finished
    None => true
  }
}

///|
pub fn tick_audio() -> Unit {
  update_audio_instances()
}

///|
pub fn get_realtime_delta() -> Double {
  backend.realtime_delta
}

///|
pub fn preload_img(path : String) -> Unit {
  ignore(get_texture(path))
}

///|
pub fn preload_audio(path : String) -> Unit {
  ignore(get_sound(path))
}

///|
pub fn set_time_scale(scale : Double) -> Unit {
  backend.time_scale = scale
}

///|
pub fn get_time_scale() -> Double {
  backend.time_scale
}

///|
pub fn load_font(font : String, path : String) -> Unit {
  let loaded = if backend.fonts_by_path.get(path) is Some(loaded) {
    loaded
  } else {
    let loaded = if get_embedded_asset(path) is Some(bytes) {
      @raylib.load_font_from_memory(
        file_extension(path),
        bytes,
        bytes.length(),
        32,
      )
    } else {
      @raylib.load_font_ex_codepoints(path, 32, default_font_codepoints())
    }
    backend.fonts_by_path.set(path, loaded)
    loaded
  }
  ignore(loaded)
  backend.font_alias.set(font, path)
}

///|
pub fn set_embedded_assets(lookup : (String) -> Bytes?) -> Unit {
  backend.embedded_asset_lookup = lookup
  backend.embedded_asset_cache = Map::new()
}

///|
pub fn get_asset_bytes(path : String) -> Bytes? {
  if get_embedded_asset(path) is Some(bytes) {
    return Some(bytes)
  }
  if !@raylib.file_exists(path) {
    return None
  }
  Some(@raylib.load_file_data(path))
}

///|
pub fn request_close() -> Unit {
  backend.close_requested = true
}
