///|
fn sanitize_triangle_uv_set(
  mesh_handle : @render3d_types.MeshHandle,
  label : String,
  set : Int,
) -> Int {
  if set == 0 || set == 1 {
    set
  } else {
    warn_texture_issue(
      "triangles_unsupported_uv_set:\{mesh_handle_text(mesh_handle)}:\{label}:\{set}",
      "triangle mesh \{mesh_handle_text(mesh_handle)} uses unsupported \{label} UV set TEXCOORD_\{set}; fallback to TEXCOORD_0",
    )
    0
  }
}

///|
fn resolve_triangle_uv_sets(
  mesh : @render3d_types.TriangleMesh3D,
  mesh_handle : @render3d_types.MeshHandle,
  texture_bundle : MaterialTextureBundle3D?,
) -> (MaterialTextureBundle3D?, Array[@smath.Vec2]?, Array[@smath.Vec2]?) {
  let vertex_count = mesh.positions.length()
  match texture_bundle {
    Some(bundle) => {
      let base_set = sanitize_triangle_uv_set(
        mesh_handle,
        "base_color_texture",
        bundle.base_texcoord_set,
      )
      let emissive_set = sanitize_triangle_uv_set(
        mesh_handle,
        "emissive_texture",
        bundle.emissive_texcoord_set,
      )
      let metallic_set = sanitize_triangle_uv_set(
        mesh_handle,
        "metallic_roughness_texture",
        bundle.metallic_roughness_texcoord_set,
      )
      let occlusion_set = sanitize_triangle_uv_set(
        mesh_handle,
        "occlusion_texture",
        bundle.occlusion_texcoord_set,
      )
      let normal_set = sanitize_triangle_uv_set(
        mesh_handle,
        "normal_texture",
        bundle.normal_texcoord_set,
      )
      let uv0 = mesh.uv_sets
        .get(0)
        .filter(fn(values) { values.length() == vertex_count })
      let uv1 = mesh.uv_sets
        .get(1)
        .filter(fn(values) { values.length() == vertex_count })
      let has_uv0 = uv0 is Some(_)
      let has_uv1 = uv1 is Some(_)
      let mut has_base = bundle.has_base_texture
      let mut has_emissive = bundle.has_emissive_texture
      let mut has_metallic = bundle.has_metallic_roughness_texture
      let mut has_occlusion = bundle.has_occlusion_texture
      let mut has_normal = bundle.has_normal_texture
      if (has_base && base_set == 0 && !has_uv0) ||
        (has_emissive && emissive_set == 0 && !has_uv0) ||
        (has_metallic && metallic_set == 0 && !has_uv0) ||
        (has_occlusion && occlusion_set == 0 && !has_uv0) ||
        (has_normal && normal_set == 0 && !has_uv0) {
        warn_texture_issue(
          "triangles_missing_uv_set0:\{mesh_handle_text(mesh_handle)}",
          "triangle mesh \{mesh_handle_text(mesh_handle)} is missing TEXCOORD_0; texture maps that require UV0 are disabled",
        )
        if base_set == 0 {
          has_base = false
        }
        if emissive_set == 0 {
          has_emissive = false
        }
        if metallic_set == 0 {
          has_metallic = false
        }
        if occlusion_set == 0 {
          has_occlusion = false
        }
        if normal_set == 0 {
          has_normal = false
        }
      }
      if (has_base && base_set == 1 && !has_uv1) ||
        (has_emissive && emissive_set == 1 && !has_uv1) ||
        (has_metallic && metallic_set == 1 && !has_uv1) ||
        (has_occlusion && occlusion_set == 1 && !has_uv1) ||
        (has_normal && normal_set == 1 && !has_uv1) {
        warn_texture_issue(
          "triangles_missing_uv_set1:\{mesh_handle_text(mesh_handle)}",
          "triangle mesh \{mesh_handle_text(mesh_handle)} is missing TEXCOORD_1; texture maps that require UV1 are disabled",
        )
        if base_set == 1 {
          has_base = false
        }
        if emissive_set == 1 {
          has_emissive = false
        }
        if metallic_set == 1 {
          has_metallic = false
        }
        if occlusion_set == 1 {
          has_occlusion = false
        }
        if normal_set == 1 {
          has_normal = false
        }
      }
      if !has_base &&
        !has_emissive &&
        !has_metallic &&
        !has_occlusion &&
        !has_normal {
        (None, uv0, uv1)
      } else {
        (
          Some({
            ..bundle,
            has_base_texture: has_base,
            has_emissive_texture: has_emissive,
            has_metallic_roughness_texture: has_metallic,
            has_occlusion_texture: has_occlusion,
            has_normal_texture: has_normal,
            base_texcoord_set: base_set,
            emissive_texcoord_set: emissive_set,
            metallic_roughness_texcoord_set: metallic_set,
            occlusion_texcoord_set: occlusion_set,
            normal_texcoord_set: normal_set,
          }),
          uv0,
          uv1,
        )
      }
    }
    None => (None, None, None)
  }
}

///|
fn expand_vec3_with_indices(
  values : Array[@smath.Vec3],
  indices : Array[Int],
) -> Array[@smath.Vec3]? {
  let output : Array[@smath.Vec3] = []
  for index in indices {
    guard values.get(index) is Some(value) else { return None }
    output.push(value)
  }
  Some(output)
}

///|
fn expand_vec2_with_indices(
  values : Array[@smath.Vec2],
  indices : Array[Int],
) -> Array[@smath.Vec2]? {
  let output : Array[@smath.Vec2] = []
  for index in indices {
    guard values.get(index) is Some(value) else { return None }
    output.push(value)
  }
  Some(output)
}

///|
fn expand_color_with_indices(
  values : Array[@render.Color],
  indices : Array[Int],
) -> Array[@render.Color]? {
  let output : Array[@render.Color] = []
  for index in indices {
    guard values.get(index) is Some(value) else { return None }
    output.push(value)
  }
  Some(output)
}

///|
fn expand_tangent_with_indices(
  values : Array[@render3d_types.Tangent3D],
  indices : Array[Int],
) -> Array[@render3d_types.Tangent3D]? {
  let output : Array[@render3d_types.Tangent3D] = []
  for index in indices {
    guard values.get(index) is Some(value) else { return None }
    output.push(value)
  }
  Some(output)
}

///|
fn create_uploaded_triangle_mesh(
  vertices : Array[@smath.Vec3],
  uv0 : Array[@smath.Vec2]?,
  uv1 : Array[@smath.Vec2]?,
  normals : Array[@smath.Vec3],
  tangents : Array[@render3d_types.Tangent3D]?,
  colors : Array[@render.Color]?,
) -> @raylib.Mesh? {
  let vertex_count = vertices.length()
  if vertex_count < 3 || vertex_count % 3 != 0 {
    return None
  }
  if normals.length() != vertex_count {
    return None
  }
  let fixed_vertices = to_fixed_vec3_array(vertices)
  let fixed_normals = to_fixed_vec3_array(normals)
  let texcoords = uv0.map_or(
    FixedArray::make(vertex_count * 2, to_float(0.0)),
    to_fixed_vec2_array,
  )
  let texcoords2 = uv1.map_or(
    FixedArray::make(vertex_count * 2, to_float(0.0)),
    to_fixed_vec2_array,
  )
  let tangents = tangents.map_or(
    {
      let defaults : Array[@render3d_types.Tangent3D] = []
      for _ in 0..<vertex_count {
        defaults.push({ x: 1.0, y: 0.0, z: 0.0, w: 1.0 })
      }
      to_fixed_tangent_array(defaults)
    },
    fn(values) {
      if values.length() == vertex_count {
        to_fixed_tangent_array(values)
      } else {
        let defaults : Array[@render3d_types.Tangent3D] = []
        for _ in 0..<vertex_count {
          defaults.push({ x: 1.0, y: 0.0, z: 0.0, w: 1.0 })
        }
        to_fixed_tangent_array(defaults)
      }
    },
  )
  let colors = colors.map_or(
    {
      let defaults : Array[@render.Color] = []
      let white = white_render_color()
      for _ in 0..<vertex_count {
        defaults.push(white)
      }
      to_fixed_color_array(defaults)
    },
    fn(values) {
      if values.length() == vertex_count {
        to_fixed_color_array(values)
      } else {
        let defaults : Array[@render.Color] = []
        let white = white_render_color()
        for _ in 0..<vertex_count {
          defaults.push(white)
        }
        to_fixed_color_array(defaults)
      }
    },
  )
  let mesh = @raylib.Mesh::new(
    fixed_vertices,
    texcoords~,
    texcoords2~,
    normals=fixed_normals,
    tangents~,
    colors~,
  )
  mesh.upload(false)
  Some(mesh)
}

///|
fn material_texture_for_slot(
  bundle : MaterialTextureBundle3D,
  slot : Int,
) -> @raylib.Texture {
  match slot {
    0 => bundle.base_texture
    1 => bundle.metallic_roughness_texture
    2 => bundle.normal_texture
    4 => bundle.occlusion_texture
    5 => bundle.emissive_texture
    _ => get_white_texture()
  }
}

///|
fn null_texture() -> @raylib.Texture {
  @raylib.Texture::new(0U, 0, 0, 0, 0)
}

///|
fn sync_shadow_sampler_uniforms(
  state : LightingShaderState,
  shadow_state : FrameShadowState?,
) -> Unit {
  let shader = state.shader
  for index in 0..<MAX_DIRECTIONAL_LIGHTS {
    let unit = if shadow_state.bind(fn(value) {
        value.directional_shadows.get(index)
      })
      is Some(_) {
      shadow_texture_slot(index)
    } else {
      0
    }
    set_shader_uniform(
      shader,
      state.shadow_sampler_locs[index],
      uniform_texture_unit(unit),
    )
  }
  let spot_unit = if shadow_state.bind(fn(value) { value.spot_shadow_atlas_id })
    is Some(_) {
    SPOT_SHADOW_TEXTURE_SLOT
  } else {
    0
  }
  set_shader_uniform(
    shader,
    state.spot_shadow_sampler_loc,
    uniform_texture_unit(spot_unit),
  )
  let point_unit = if shadow_state.bind(fn(value) {
      value.point_shadow_atlas_id
    })
    is Some(_) {
    POINT_SHADOW_TEXTURE_SLOT
  } else {
    0
  }
  set_shader_uniform(
    shader,
    state.point_shadow_sampler_loc,
    uniform_texture_unit(point_unit),
  )
}

///|
fn draw_lit_mesh_with_material(
  mesh : @raylib.Mesh,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  texture_bundle : MaterialTextureBundle3D?,
  mesh_has_tangents : Bool,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let lighting_state = upload_lighting_uniforms(
    frame, camera_position, material, texture_bundle, mesh_has_tangents, receive_shadows,
    shadow_state,
  )
  let effective_bundle = texture_bundle.unwrap_or(
    fallback_lighting_texture_bundle(),
  )
  let ray_material = get_lit_material(texture_bundle is Some(_))
  for binding in material_texture_slot_bindings() {
    @raylib.set_material_texture(
      ray_material,
      binding.material_map,
      material_texture_for_slot(effective_bundle, binding.slot),
    )
  }
  @raylib.set_material_texture(
    ray_material,
    @raylib.MaterialMapRoughness,
    null_texture(),
  )
  if material.double_sided {
    @rl.disable_backface_culling()
  } else {
    @rl.enable_backface_culling()
  }
  bind_shadow_textures(shadow_state)
  sync_shadow_sampler_uniforms(lighting_state, shadow_state)
  @raylib.draw_mesh(mesh, ray_material, @raylib.Matrix::identity())
  unbind_shadow_textures(shadow_state)
  @rl.disable_backface_culling()
}

///|
const OFFSCREEN_IMAGE_PREFIX : String = "offscreen://"

///|
fn offscreen_target_name_from_path(path : String) -> String? {
  if !path.has_prefix(OFFSCREEN_IMAGE_PREFIX) {
    return None
  }
  if path.length() <= OFFSCREEN_IMAGE_PREFIX.length() {
    return None
  }
  Some(
    path.unsafe_substring(
      start=OFFSCREEN_IMAGE_PREFIX.length(),
      end=path.length(),
    ),
  )
}

///|
fn ensure_offscreen_target_2d(
  name : String,
  width : Int,
  height : Int,
) -> OffscreenTarget2D? {
  let width = @cmp.maximum(1, width)
  let height = @cmp.maximum(1, height)
  match backend.offscreen_targets_2d.get(name) {
    Some(existing) =>
      if existing.width == width && existing.height == height &&
        existing.render_texture.is_valid() {
        return Some(existing)
      } else {
        existing.render_texture.unload()
        backend.offscreen_targets_2d.remove(name)
      }
    None => ()
  }
  let render_texture = @raylib.RenderTexture::load(width, height)
  if !render_texture.is_valid() {
    render_texture.unload()
    return None
  }
  @raylib.set_texture_filter(render_texture.texture(), configured_filter())
  let created = { render_texture, width, height }
  backend.offscreen_targets_2d.set(name, created)
  Some(created)
}

///|
fn offscreen_target_texture(path : String) -> @raylib.Texture? {
  match offscreen_target_name_from_path(path) {
    Some(name) => backend.offscreen_targets_2d.get(name).map(fn(target) {
      target.render_texture.texture()
    })
    None => None
  }
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
  @raylib.Font::default()
}
