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
  material_metallic_loc : Int
  material_roughness_loc : Int
  material_has_texture_loc : Int
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
  texture_warning_keys: Set::new(),
}

///|
let clip_stack : Array[@smath.Rect] = []

///|
const MAX_DIRECTIONAL_LIGHTS : Int = 4

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
  "uniform vec3 ambientLight;\n" +
  "uniform vec3 viewPosition;\n" +
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
  "uniform float materialMetallic;\n" +
  "uniform float materialRoughness;\n" +
  "uniform int materialHasTexture;\n" +
  "out vec4 finalColor;\n" +
  "float rangeAttenuation(float distanceToLight, float lightRange) {\n" +
  "  if (lightRange <= 0.000001) return 1.0;\n" +
  "  if (distanceToLight >= lightRange) return 0.0;\n" +
  "  float t = 1.0 - distanceToLight / lightRange;\n" +
  "  return t * t;\n" +
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
  "void main() {\n" +
  "  vec4 albedoSample = materialHasTexture != 0 ? texture(texture0, fragTexCoord) : vec4(1.0);\n" +
  "  vec4 albedo = albedoSample * fragVertexColor * materialBaseColor;\n" +
  "  if (albedo.a <= 0.0001) discard;\n" +
  "  vec3 normal = normalize(fragNormal);\n" +
  "  if (length(normal) <= 0.00001) normal = vec3(0.0, 1.0, 0.0);\n" +
  "  vec3 viewDir = normalize(viewPosition - fragPosition);\n" +
  "  if (length(viewDir) <= 0.00001) viewDir = vec3(0.0, 0.0, 1.0);\n" +
  "  float roughness = clamp(materialRoughness, 0.0, 1.0);\n" +
  "  float metallic = clamp(materialMetallic, 0.0, 1.0);\n" +
  "  float shininess = mix(96.0, 8.0, roughness);\n" +
  "  float specularStrength = mix(0.04, 1.0, metallic);\n" +
  "  vec3 diffuseLight = ambientLight;\n" +
  "  vec3 specularLight = vec3(0.0);\n" +
  "  for (int i = 0; i < directionalCount; i++) {\n" +
  "    vec3 lightDir = normalize(-directionalDirections[i]);\n" +
  "    addLight(lightDir, directionalColors[i], 1.0, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  for (int i = 0; i < pointCount; i++) {\n" +
  "    vec3 toLight = pointPositions[i] - fragPosition;\n" +
  "    float distanceToLight = length(toLight);\n" +
  "    if (distanceToLight <= 0.00001) continue;\n" +
  "    vec3 lightDir = toLight / distanceToLight;\n" +
  "    float attenuation = rangeAttenuation(distanceToLight, pointRanges[i]);\n" +
  "    addLight(lightDir, pointColors[i], attenuation, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  for (int i = 0; i < spotCount; i++) {\n" +
  "    vec3 toLight = spotPositions[i] - fragPosition;\n" +
  "    float distanceToLight = length(toLight);\n" +
  "    if (distanceToLight <= 0.00001) continue;\n" +
  "    vec3 lightDir = toLight / distanceToLight;\n" +
  "    float attenuation = rangeAttenuation(distanceToLight, spotParams[i].x);\n" +
  "    float cone = spotAttenuation(spotDirections[i], -lightDir, spotParams[i]);\n" +
  "    addLight(lightDir, spotColors[i], attenuation * cone, normal, viewDir, shininess, specularStrength, diffuseLight, specularLight);\n" +
  "  }\n" +
  "  if (directionalCount == 0 && pointCount == 0 && spotCount == 0 && dot(ambientLight, ambientLight) <= 0.000001) {\n" +
  "    diffuseLight = vec3(1.0);\n" +
  "  }\n" +
  "  vec3 litColor = albedo.rgb * diffuseLight + specularLight + materialEmissiveColor;\n" +
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
}

///|
fn create_lighting_shader_state() -> LightingShaderState {
  let shader = @raylib.load_shader_from_memory(
    raylib_lighting_vertex_shader, raylib_lighting_fragment_shader,
  )
  configure_lighting_shader_locations(shader)
  {
    shader,
    ambient_light_loc: @raylib.get_shader_location(shader, "ambientLight"),
    view_position_loc: @raylib.get_shader_location(shader, "viewPosition"),
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
    material_metallic_loc: @raylib.get_shader_location(
      shader, "materialMetallic",
    ),
    material_roughness_loc: @raylib.get_shader_location(
      shader, "materialRoughness",
    ),
    material_has_texture_loc: @raylib.get_shader_location(
      shader, "materialHasTexture",
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
fn upload_lighting_uniforms(
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  has_texture : Bool,
) -> LightingShaderState {
  let state = get_lighting_shader_state()
  let shader = state.shader
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
    state.material_has_texture_loc,
    bytes_from_int(if has_texture { 1 } else { 0 }),
    @raylib.ShaderUniformInt,
  )
  state
}

///|
fn to_ray_camera3d(camera : @render3d_types.FrameCamera3D) -> @raylib.Camera3D {
  @raylib.Camera3D::new(
    to_ray_vector3_smath(camera.position),
    to_ray_vector3_smath(camera.target),
    to_ray_vector3_smath(camera.up),
    to_float(camera.fov_y),
    @raylib.CameraPerspective,
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
  texture : @raylib.Texture?,
) -> Unit {
  ignore(
    upload_lighting_uniforms(
      frame,
      camera_position,
      material,
      texture is Some(_),
    ),
  )
  let ray_material = get_lit_material(texture is Some(_))
  if texture is Some(texture) {
    @raylib.set_material_texture(
      ray_material,
      @raylib.MaterialMapAlbedo,
      texture,
    )
  }
  @raylib.draw_mesh(mesh, ray_material, @raylib.Matrix::identity())
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
  for _path, texture in backend.textures {
    @raylib.unload_texture(texture)
  }
  backend.textures.clear()
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
  if backend.lit_material is Some(material) {
    @raylib.unload_material(material)
  }
  backend.lit_material = None
  if backend.lit_textured_material is Some(material) {
    @raylib.unload_material(material)
  }
  backend.lit_textured_material = None
  if backend.lighting_shader is Some(state) {
    @raylib.unload_shader(state.shader)
  }
  backend.lighting_shader = None
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
  let texture = resolve_material_texture(material)
  match mesh_asset.primitive {
    Cube(size) =>
      draw_lit_cuboid(size, material, frame, camera_position, texture)
    Sphere(radius) =>
      draw_lit_sphere(radius, material, frame, camera_position, texture)
    Cylinder(radius_top, radius_bottom, height, slices) =>
      draw_lit_cylinder(
        radius_top, radius_bottom, height, slices, material, frame, camera_position,
        texture,
      )
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
      let cuboid = @smath.Vec3::new(size.x, thickness, size.z)
      draw_lit_cuboid(cuboid, material, frame, camera_position, texture)
    }
    Triangles(mesh) =>
      draw_triangle_mesh(mesh, material, frame, camera_position, texture)
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
  texture : @raylib.Texture?,
) -> Unit {
  let key = "cube:\{size.x}:\{size.y}:\{size.z}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_cube(to_float(size.x), to_float(size.y), to_float(size.z))
  })
  draw_lit_mesh_with_material(mesh, frame, camera_position, material, texture)
}

///|
fn draw_lit_sphere(
  radius : Double,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture : @raylib.Texture?,
) -> Unit {
  let key = "sphere:\{radius}:\{TEXTURED_SPHERE_SLICES}:\{TEXTURED_SPHERE_STACKS}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_sphere(
      to_float(radius),
      TEXTURED_SPHERE_SLICES,
      TEXTURED_SPHERE_STACKS,
    )
  })
  draw_lit_mesh_with_material(mesh, frame, camera_position, material, texture)
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
  texture : @raylib.Texture?,
) -> Unit {
  if (radius_top - radius_bottom).abs() <= 0.000001 {
    let key = "cylinder:\{radius_top}:\{height}:\{slices}"
    let mesh = get_or_create_primitive_mesh(key, fn() {
      @raylib.gen_mesh_cylinder(to_float(radius_top), to_float(height), slices)
    })
    draw_lit_mesh_with_material(mesh, frame, camera_position, material, texture)
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
    texture,
    material,
    frame,
    camera_position,
  )
}

///|
fn resolve_material_texture(
  material : @render3d_types.StandardMaterial3D,
) -> @raylib.Texture? {
  guard material.base_color_texture is Some(image_handle) else { return None }
  guard backend.images3d.get(image_handle) is Some(image_asset) else {
    warn_texture_issue(
      "missing_image_handle:\{image_handle}",
      "material base_color_texture handle \{image_handle} is not synced; fallback to base_color",
    )
    return None
  }
  let texture = get_texture(image_asset.path)
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
  Some(texture)
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
  texture : @raylib.Texture?,
) -> Unit {
  let vertices = mesh.positions
  if vertices.length() < 3 {
    return
  }
  let normals = resolve_triangle_normals(mesh)
  if material.base_color_texture is Some(_) && texture is Some(texture) {
    guard mesh.uvs is Some(uvs) else {
      warn_texture_issue(
        "triangles_missing_uvs", "triangle mesh has base_color_texture but no UVs; fallback to base_color",
      )
      draw_triangle_vertices(
        vertices,
        None,
        normals,
        None,
        material,
        frame,
        camera_position,
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
        None,
        material,
        frame,
        camera_position,
      )
      return
    }
    draw_triangle_vertices(
      vertices,
      Some(uvs),
      normals,
      Some(texture),
      material,
      frame,
      camera_position,
    )
    return
  }
  draw_triangle_vertices(
    vertices,
    None,
    normals,
    None,
    material,
    frame,
    camera_position,
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
  texture : @raylib.Texture?,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
) -> Unit {
  let state = upload_lighting_uniforms(
    frame,
    camera_position,
    material,
    texture is Some(_),
  )
  ignore(@rl.check_render_batch_limit(vertices.length()))
  @raylib.begin_shader_mode(state.shader)
  if texture is Some(texture) {
    @rl.set_texture(@raylib.get_texture_id(texture).reinterpret_as_uint())
  }
  @rl.begin(@rl.Triangles)
  for index in 0..<vertices.length() {
    let vertex = vertices[index]
    let uv = uvs
      .map(fn(values) { values[index] })
      .unwrap_or(@smath.Vec2D(0.0, 0.0))
    let normal = normals[index]
    @rl.color4ub(255U.to_byte(), 255U.to_byte(), 255U.to_byte(), 255U.to_byte())
    @rl.normal3f(to_float(normal.x), to_float(normal.y), to_float(normal.z))
    @rl.tex_coord2f(to_float(uv[X]), to_float(uv[Y]))
    @rl.vertex3f(to_float(vertex.x), to_float(vertex.y), to_float(vertex.z))
  }
  @rl.end_()
  if texture is Some(_) {
    @rl.set_texture(0U)
  }
  @raylib.end_shader_mode()
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
