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
    uniform_texture_transform_offset_scale(transform),
  )
  set_shader_uniform(
    shader,
    rotation_loc,
    uniform_texture_transform_rotation(transform),
  )
}

///|
fn upload_lighting_uniforms(
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  texture_bundle : MaterialTextureBundle3D?,
  mesh_has_tangents : Bool,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> LightingShaderState {
  let state = get_lighting_shader_state()
  let shader = state.shader
  let default_shadow_rect : ShadowAtlasRect = {
    offset: @smath.Vec2(0.0, 0.0),
    scale: @smath.Vec2(0.0, 0.0),
  }
  let ambient = frame.ambient_light
    .map(fn(light) { light_rgb(light.color, light.intensity) })
    .unwrap_or(@smath.Vec3::zero())
  set_shader_uniform(shader, state.ambient_light_loc, uniform_vec3(ambient))
  set_shader_uniform(
    shader,
    state.view_position_loc,
    uniform_vec3(camera_position),
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
    uniform_vec3(camera_forward),
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
    uniform_int(directional_count),
  )
  set_shader_uniform_v(
    shader,
    state.directional_directions_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(directional_directions, directional_count),
    ),
  )
  set_shader_uniform_v(
    shader,
    state.directional_colors_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(directional_colors, directional_count),
    ),
  )
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.directional_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.shadow_enabled_locs[index],
      uniform_int(if shadow is Some(_) { 1 } else { 0 }),
    )
    set_shader_uniform(
      shader,
      state.shadow_cascade_count_locs[index],
      uniform_int(shadow.map_or(0, fn(value) { value.cascades.length() })),
    )
    set_shader_uniform(
      shader,
      state.shadow_depth_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
    )
    set_shader_uniform(
      shader,
      state.shadow_normal_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
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
        cascade.map_or(uniform_shadow_atlas_rect(default_shadow_rect), fn(
          value,
        ) {
          uniform_shadow_atlas_rect(value.atlas_rect)
        }),
      )
      set_shader_uniform(
        shader,
        state.shadow_bound_locs[matrix_index],
        cascade.map_or(uniform_vec2(@smath.Vec2(0.0, 0.0)), fn(value) {
          uniform_vec2(@smath.Vec2(value.near_bound, value.far_bound))
        }),
      )
    }
  }
  set_shader_uniform(
    shader,
    state.directional_shadow_texel_size_loc,
    uniform_vec2(
      shadow_state.map_or(@smath.Vec2(0.0, 0.0), fn(value) {
        value.directional_texel_size
      }),
    ),
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
  set_shader_uniform(shader, state.point_count_loc, uniform_int(point_count))
  set_shader_uniform_v(
    shader,
    state.point_positions_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(point_positions, point_count),
    ),
  )
  set_shader_uniform_v(
    shader,
    state.point_colors_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(point_colors, point_count),
    ),
  )
  set_shader_uniform_v(
    shader,
    state.point_ranges_loc,
    @raylib.ShaderUniformDataV::Float(to_float_array(point_ranges, point_count)),
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
  set_shader_uniform(shader, state.spot_count_loc, uniform_int(spot_count))
  set_shader_uniform_v(
    shader,
    state.spot_positions_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(spot_positions, spot_count),
    ),
  )
  set_shader_uniform_v(
    shader,
    state.spot_directions_loc,
    @raylib.ShaderUniformDataV::Vec3(
      to_ray_vec3_array(spot_directions, spot_count),
    ),
  )
  set_shader_uniform_v(
    shader,
    state.spot_colors_loc,
    @raylib.ShaderUniformDataV::Vec3(to_ray_vec3_array(spot_colors, spot_count)),
  )
  set_shader_uniform_v(
    shader,
    state.spot_params_loc,
    @raylib.ShaderUniformDataV::Vec3(to_ray_vec3_array(spot_params, spot_count)),
  )
  for index in 0..<MAX_SPOT_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.spot_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.spot_shadow_enabled_locs[index],
      uniform_int(if shadow is Some(_) { 1 } else { 0 }),
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
      uniform_shadow_atlas_rect(
        shadow.map_or(default_shadow_rect, fn(value) { value.atlas_rect }),
      ),
    )
    set_shader_uniform(
      shader,
      state.spot_shadow_depth_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
    )
    set_shader_uniform(
      shader,
      state.spot_shadow_normal_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
    )
  }
  set_shader_uniform(
    shader,
    state.spot_shadow_texel_size_loc,
    uniform_vec2(
      shadow_state.map_or(@smath.Vec2(0.0, 0.0), fn(value) {
        value.spot_texel_size
      }),
    ),
  )
  for index in 0..<MAX_POINT_LIGHTS {
    let shadow = match shadow_state {
      Some(frame_shadow) => frame_shadow.point_shadows.get(index)
      None => None
    }
    set_shader_uniform(
      shader,
      state.point_shadow_enabled_locs[index],
      uniform_int(if shadow is Some(_) { 1 } else { 0 }),
    )
    set_shader_uniform(
      shader,
      state.point_shadow_depth_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.depth_bias })),
    )
    set_shader_uniform(
      shader,
      state.point_shadow_normal_bias_locs[index],
      uniform_float(shadow.map_or(0.0, fn(value) { value.normal_bias })),
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
        uniform_shadow_atlas_rect(
          shadow
          .bind(fn(value) { value.face_rects.get(face_index) })
          .unwrap_or(default_shadow_rect),
        ),
      )
    }
  }
  set_shader_uniform(
    shader,
    state.point_shadow_texel_size_loc,
    uniform_vec2(
      shadow_state.map_or(@smath.Vec2(0.0, 0.0), fn(value) {
        value.point_texel_size
      }),
    ),
  )

  set_shader_uniform(
    shader,
    state.material_base_color_loc,
    uniform_color4(material.base_color),
  )
  set_shader_uniform(
    shader,
    state.material_emissive_color_loc,
    uniform_vec3(color_to_vec3(material.emissive_color)),
  )
  set_shader_uniform(
    shader,
    state.material_normal_scale_loc,
    uniform_float(material.normal_scale),
  )
  set_shader_uniform(
    shader,
    state.material_occlusion_strength_loc,
    uniform_float(material.occlusion_strength),
  )
  set_shader_uniform(
    shader,
    state.material_metallic_loc,
    uniform_float(material.metallic),
  )
  set_shader_uniform(
    shader,
    state.material_roughness_loc,
    uniform_float(material.roughness),
  )
  set_shader_uniform(
    shader,
    state.material_alpha_mode_loc,
    uniform_int(alpha_mode_to_int(material.alpha_mode)),
  )
  set_shader_uniform(
    shader,
    state.material_alpha_cutoff_loc,
    uniform_float(material.alpha_cutoff),
  )
  set_shader_uniform(
    shader,
    state.material_has_base_texture_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        if bundle.has_base_texture {
          1
        } else {
          0
        }
      }),
    ),
  )
  set_shader_uniform(
    shader,
    state.material_has_emissive_texture_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        if bundle.has_emissive_texture {
          1
        } else {
          0
        }
      }),
    ),
  )
  set_shader_uniform(
    shader,
    state.material_has_metallic_roughness_texture_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        if bundle.has_metallic_roughness_texture {
          1
        } else {
          0
        }
      }),
    ),
  )
  set_shader_uniform(
    shader,
    state.material_has_occlusion_texture_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        if bundle.has_occlusion_texture {
          1
        } else {
          0
        }
      }),
    ),
  )
  set_shader_uniform(
    shader,
    state.material_has_normal_texture_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        if bundle.has_normal_texture {
          1
        } else {
          0
        }
      }),
    ),
  )
  set_shader_uniform(
    shader,
    state.material_has_tangents_loc,
    uniform_int(if mesh_has_tangents { 1 } else { 0 }),
  )
  set_shader_uniform(
    shader,
    state.material_unlit_loc,
    uniform_int(if material.unlit { 1 } else { 0 }),
  )
  set_shader_uniform(
    shader,
    state.material_receive_shadows_loc,
    uniform_int(if receive_shadows { 1 } else { 0 }),
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
  set_shader_uniform(
    shader,
    state.base_uv_set_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) { bundle.base_texcoord_set }),
    ),
  )
  upload_texture_transform_uniforms(
    shader,
    state.metallic_roughness_uv_offset_scale_loc,
    state.metallic_roughness_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.metallic_roughness_transform
    }),
  )
  set_shader_uniform(
    shader,
    state.metallic_roughness_uv_set_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) {
        bundle.metallic_roughness_texcoord_set
      }),
    ),
  )
  upload_texture_transform_uniforms(
    shader,
    state.normal_uv_offset_scale_loc,
    state.normal_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.normal_transform
    }),
  )
  set_shader_uniform(
    shader,
    state.normal_uv_set_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) { bundle.normal_texcoord_set }),
    ),
  )
  upload_texture_transform_uniforms(
    shader,
    state.occlusion_uv_offset_scale_loc,
    state.occlusion_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.occlusion_transform
    }),
  )
  set_shader_uniform(
    shader,
    state.occlusion_uv_set_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) { bundle.occlusion_texcoord_set }),
    ),
  )
  upload_texture_transform_uniforms(
    shader,
    state.emissive_uv_offset_scale_loc,
    state.emissive_uv_rotation_loc,
    texture_bundle.map_or(default_transform, fn(bundle) {
      bundle.emissive_transform
    }),
  )
  set_shader_uniform(
    shader,
    state.emissive_uv_set_loc,
    uniform_int(
      texture_bundle.map_or(0, fn(bundle) { bundle.emissive_texcoord_set }),
    ),
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
fn mesh_handle_text(mesh_handle : @render3d_types.MeshHandle) -> String {
  mesh_handle.hash().to_string()
}

///|
fn image_handle_text(image_handle : @render3d_types.ImageHandle) -> String {
  image_handle.hash().to_string()
}

///|
fn triangle_mesh_cache_prefix(
  mesh_handle : @render3d_types.MeshHandle,
) -> String {
  "triangle_mesh:\{mesh_handle_text(mesh_handle)}:"
}

///|
fn triangle_mesh_cache_key(mesh_handle : @render3d_types.MeshHandle) -> String {
  "\{triangle_mesh_cache_prefix(mesh_handle)}mesh"
}

///|
fn clear_triangle_mesh_cache_for_handle(
  mesh_handle : @render3d_types.MeshHandle,
) -> Unit {
  let prefix = triangle_mesh_cache_prefix(mesh_handle)
  for pair in backend.triangle_mesh_cache.to_array() {
    if pair.0.has_prefix(prefix) {
      @raylib.unload_mesh(pair.1)
      backend.triangle_mesh_cache.remove(pair.0)
    }
  }
}

///|
fn to_fixed_vec3_array(values : Array[@smath.Vec3]) -> FixedArray[Float] {
  let out = FixedArray::make(values.length() * 3, to_float(0.0))
  for index in 0..<values.length() {
    let base = index * 3
    let value = values[index]
    out[base] = to_float(value.x)
    out[base + 1] = to_float(value.y)
    out[base + 2] = to_float(value.z)
  }
  out
}

///|
fn to_fixed_vec2_array(values : Array[@smath.Vec2]) -> FixedArray[Float] {
  let out = FixedArray::make(values.length() * 2, to_float(0.0))
  for index in 0..<values.length() {
    let base = index * 2
    let value = values[index]
    out[base] = to_float(value[X])
    out[base + 1] = to_float(value[Y])
  }
  out
}

///|
fn to_fixed_color_array(values : Array[@render.Color]) -> FixedArray[Byte] {
  let out = FixedArray::make(values.length() * 4, b'\x00')
  for index in 0..<values.length() {
    let base = index * 4
    let (r, g, b, a) = to_ray_color_bytes(values[index])
    out[base] = r
    out[base + 1] = g
    out[base + 2] = b
    out[base + 3] = a
  }
  out
}

///|
fn to_fixed_tangent_array(
  values : Array[@render3d_types.Tangent3D],
) -> FixedArray[Float] {
  let out = FixedArray::make(values.length() * 4, to_float(0.0))
  for index in 0..<values.length() {
    let base = index * 4
    let tangent = values[index]
    out[base] = to_float(tangent.x)
    out[base + 1] = to_float(tangent.y)
    out[base + 2] = to_float(tangent.z)
    out[base + 3] = to_float(tangent.w)
  }
  out
}

///|
fn default_mesh_indices(vertex_count : Int) -> Array[Int] {
  let indices : Array[Int] = []
  for index in 0..<vertex_count {
    indices.push(index)
  }
  indices
}

///|
fn triangulate_triangle_indices(
  indices : Array[Int],
  topology : @render3d_types.TriangleTopology3D,
) -> Array[Int] {
  let triangle_indices : Array[Int] = []
  let push_index = fn(index : Int) { triangle_indices.push(index) }
  match topology {
    TriangleList => {
      let tri_count = indices.length() / 3
      for tri in 0..<tri_count {
        let base = tri * 3
        push_index(indices[base])
        push_index(indices[base + 1])
        push_index(indices[base + 2])
      }
    }
    TriangleStrip =>
      if indices.length() >= 3 {
        for i in 0..<(indices.length() - 2) {
          if i % 2 == 0 {
            push_index(indices[i])
            push_index(indices[i + 1])
            push_index(indices[i + 2])
          } else {
            push_index(indices[i + 1])
            push_index(indices[i])
            push_index(indices[i + 2])
          }
        }
      }
    TriangleFan =>
      if indices.length() >= 3 {
        let head = indices[0]
        for i in 1..<(indices.length() - 1) {
          push_index(head)
          push_index(indices[i])
          push_index(indices[i + 1])
        }
      }
  }
  triangle_indices
}

///|
fn resolve_triangle_indices(
  mesh_handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[Int]? {
  let base_indices = mesh.indices.unwrap_or(
    default_mesh_indices(mesh.positions.length()),
  )
  if base_indices.length() == 0 {
    return None
  }
  for index in base_indices {
    if index < 0 || index >= mesh.positions.length() {
      warn_texture_issue(
        "triangles_invalid_index:\{mesh_handle_text(mesh_handle)}:\{index}",
        "triangle mesh \{mesh_handle_text(mesh_handle)} contains out-of-range index \{index}; skipping draw",
      )
      return None
    }
  }
  let triangle_indices = triangulate_triangle_indices(
    base_indices,
    mesh.topology,
  )
  if triangle_indices.length() < 3 || triangle_indices.length() % 3 != 0 {
    return None
  }
  Some(triangle_indices)
}
