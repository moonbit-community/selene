///|
fn material_texture_slot_bindings() -> Array[MaterialTextureSlotBinding] {
  [
    {
      shader_loc: @raylib.ShaderLocMapAlbedo,
      uniform_name: "texture0",
      slot: 0,
      material_map: @raylib.MaterialMapAlbedo,
    },
    {
      shader_loc: @raylib.ShaderLocMapMetalness,
      uniform_name: "texture1",
      slot: 1,
      material_map: @raylib.MaterialMapMetalness,
    },
    {
      shader_loc: @raylib.ShaderLocMapNormal,
      uniform_name: "texture2",
      slot: 2,
      material_map: @raylib.MaterialMapNormal,
    },
    {
      shader_loc: @raylib.ShaderLocMapOcclusion,
      uniform_name: "texture4",
      slot: 4,
      material_map: @raylib.MaterialMapOcclusion,
    },
    {
      shader_loc: @raylib.ShaderLocMapEmission,
      uniform_name: "texture5",
      slot: 5,
      material_map: @raylib.MaterialMapEmission,
    },
  ]
}

///|
fn uniform_color4(color : @render.Color) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Vec4(
    @raylib.Vector4::new(
      to_float(color.r.to_double() / 255.0),
      to_float(color.g.to_double() / 255.0),
      to_float(color.b.to_double() / 255.0),
      to_float(color.a),
    ),
  )
}

///|
fn reset_material_from_material(
  target : @raylib.Material,
  source : @raylib.Material,
) -> Unit {
  target.set_shader(source.shader())
  let target_maps = target.maps()
  let source_maps = source.maps()
  let count = @cmp.minimum(target_maps.count(), source_maps.count())
  for i in 0..<count {
    target_maps[i] = source_maps[i]
  }
}

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
) -> @smath.Vec2 {
  @smath.Vec2(@cmath.sin(transform.rotation), @cmath.cos(transform.rotation))
}

///|
fn uniform_texture_transform_offset_scale(
  transform : @render3d_types.TextureTransform3D,
) -> @raylib.ShaderUniformData {
  let (offset_x, offset_y, scale_x, scale_y) = texture_transform_offset_scale(
    transform,
  )
  @raylib.ShaderUniformData::Vec4(
    @raylib.Vector4::new(
      to_float(offset_x),
      to_float(offset_y),
      to_float(scale_x),
      to_float(scale_y),
    ),
  )
}

///|
fn uniform_texture_transform_rotation(
  transform : @render3d_types.TextureTransform3D,
) -> @raylib.ShaderUniformData {
  uniform_vec2(texture_transform_rotation_sin_cos(transform))
}

///|
fn to_ray_vec3_array(
  values : Array[@smath.Vec3],
  count : Int,
) -> Array[@raylib.Vector3] {
  let out : Array[@raylib.Vector3] = []
  for index in 0..<count {
    let v = values[index]
    out.push(@raylib.Vector3::new(to_float(v.x), to_float(v.y), to_float(v.z)))
  }
  out
}

///|
fn to_float_array(values : Array[Double], count : Int) -> Array[Float] {
  let out : Array[Float] = []
  for index in 0..<count {
    out.push(to_float(values[index]))
  }
  out
}

///|
fn set_shader_uniform(
  shader : @raylib.Shader,
  loc : Int,
  value : @raylib.ShaderUniformData,
) -> Unit {
  if loc == -1 {
    return
  }
  shader.set_value(loc, value)
}

///|
fn set_shader_uniform_v(
  shader : @raylib.Shader,
  loc : Int,
  data : @raylib.ShaderUniformDataV,
) -> Unit {
  if loc == -1 {
    return
  }
  shader.set_value_v(loc, data)
}

///|
fn configure_lighting_shader_locations(shader : @raylib.Shader) -> Unit {
  shader.set_locs(
    @raylib.ShaderLocVertexPosition,
    @raylib.get_shader_location_attrib(shader, "vertexPosition"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexTexcoord01,
    @raylib.get_shader_location_attrib(shader, "vertexTexCoord"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexTexcoord02,
    @raylib.get_shader_location_attrib(shader, "vertexTexCoord2"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexNormal,
    @raylib.get_shader_location_attrib(shader, "vertexNormal"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexTangent,
    @raylib.get_shader_location_attrib(shader, "vertexTangent"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexColor,
    @raylib.get_shader_location_attrib(shader, "vertexColor"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixMvp,
    @raylib.get_shader_location(shader, "mvp"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixView,
    @raylib.get_shader_location(shader, "matView"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixProjection,
    @raylib.get_shader_location(shader, "matProjection"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixModel,
    @raylib.get_shader_location(shader, "matModel"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixNormal,
    @raylib.get_shader_location(shader, "matNormal"),
  )
  for binding in material_texture_slot_bindings() {
    shader.set_locs(
      binding.shader_loc,
      @raylib.get_shader_location(shader, binding.uniform_name),
    )
  }
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
  let shadow_sampler_locs : Array[Int] = []
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
    shadow_sampler_locs.push(
      @raylib.get_shader_location(shader, "shadowMap\{index}"),
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
  let spot_shadow_sampler_loc = @raylib.get_shader_location(
    shader, "spotShadowAtlas",
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
  let point_shadow_sampler_loc = @raylib.get_shader_location(
    shader, "pointShadowAtlas",
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
    material_has_base_texture_loc: @raylib.get_shader_location(
      shader, "materialHasBaseTexture",
    ),
    material_has_emissive_texture_loc: @raylib.get_shader_location(
      shader, "materialHasEmissiveTexture",
    ),
    material_has_metallic_roughness_texture_loc: @raylib.get_shader_location(
      shader, "materialHasMetallicRoughnessTexture",
    ),
    material_has_occlusion_texture_loc: @raylib.get_shader_location(
      shader, "materialHasOcclusionTexture",
    ),
    material_has_normal_texture_loc: @raylib.get_shader_location(
      shader, "materialHasNormalTexture",
    ),
    material_has_tangents_loc: @raylib.get_shader_location(
      shader, "materialHasTangents",
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
    shadow_sampler_locs,
    directional_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "directionalShadowTexelSize",
    ),
    spot_shadow_enabled_locs,
    spot_shadow_matrix_locs,
    spot_shadow_rect_locs,
    spot_shadow_depth_bias_locs,
    spot_shadow_normal_bias_locs,
    spot_shadow_sampler_loc,
    spot_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "spotShadowTexelSize",
    ),
    point_shadow_enabled_locs,
    point_shadow_depth_bias_locs,
    point_shadow_normal_bias_locs,
    point_shadow_matrix_locs,
    point_shadow_rect_locs,
    point_shadow_sampler_loc,
    point_shadow_texel_size_loc: @raylib.get_shader_location(
      shader, "pointShadowTexelSize",
    ),
    base_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "baseUvOffsetScale",
    ),
    base_uv_rotation_loc: @raylib.get_shader_location(shader, "baseUvRotation"),
    base_uv_set_loc: @raylib.get_shader_location(shader, "baseUvSet"),
    metallic_roughness_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "metallicRoughnessUvOffsetScale",
    ),
    metallic_roughness_uv_rotation_loc: @raylib.get_shader_location(
      shader, "metallicRoughnessUvRotation",
    ),
    metallic_roughness_uv_set_loc: @raylib.get_shader_location(
      shader, "metallicRoughnessUvSet",
    ),
    normal_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "normalUvOffsetScale",
    ),
    normal_uv_rotation_loc: @raylib.get_shader_location(
      shader, "normalUvRotation",
    ),
    normal_uv_set_loc: @raylib.get_shader_location(shader, "normalUvSet"),
    occlusion_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "occlusionUvOffsetScale",
    ),
    occlusion_uv_rotation_loc: @raylib.get_shader_location(
      shader, "occlusionUvRotation",
    ),
    occlusion_uv_set_loc: @raylib.get_shader_location(shader, "occlusionUvSet"),
    emissive_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "emissiveUvOffsetScale",
    ),
    emissive_uv_rotation_loc: @raylib.get_shader_location(
      shader, "emissiveUvRotation",
    ),
    emissive_uv_set_loc: @raylib.get_shader_location(shader, "emissiveUvSet"),
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
fn ensure_texture_mipmaps(texture : @raylib.Texture) -> Unit {
  if texture.mipmaps() < 2 {
    texture.gen_mipmaps()
  }
}

///|
fn get_solid_texture(key : String, color : @render.Color) -> @raylib.Texture {
  if backend.textures.get(key) is Some(texture) {
    return texture
  }
  let image = @raylib.gen_image_color(1, 1, to_ray_color(color))
  let texture = @raylib.load_texture_from_image(image)
  @raylib.unload_image(image)
  ensure_texture_mipmaps(texture)
  @raylib.set_texture_filter(texture, @raylib.TextureFilterPoint)
  backend.textures.set(key, texture)
  texture
}

///|
fn get_white_texture() -> @raylib.Texture {
  get_solid_texture(INTERNAL_WHITE_TEXTURE_KEY, white_render_color())
}

///|
fn fallback_lighting_texture_bundle() -> MaterialTextureBundle3D {
  let default_transform = @render3d_types.default_texture_transform3d()
  {
    base_texture: get_white_texture(),
    emissive_texture: get_white_texture(),
    metallic_roughness_texture: get_white_texture(),
    occlusion_texture: get_white_texture(),
    normal_texture: null_texture(),
    has_base_texture: false,
    has_emissive_texture: false,
    has_metallic_roughness_texture: false,
    has_occlusion_texture: false,
    has_normal_texture: false,
    base_transform: default_transform,
    emissive_transform: default_transform,
    metallic_roughness_transform: default_transform,
    occlusion_transform: default_transform,
    normal_transform: default_transform,
    base_texcoord_set: 0,
    emissive_texcoord_set: 0,
    metallic_roughness_texcoord_set: 0,
    occlusion_texcoord_set: 0,
    normal_texcoord_set: 0,
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
  let material = @raylib.Material::default()
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
