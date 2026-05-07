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
    @smath.Vec3(0.0, 1.0, 0.0)
  } else {
    @smath.Vec3(
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
  mesh_handle : @render3d_types.MeshHandle,
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
    warn_texture_issue(
      "triangles_invalid_positions:\{mesh_handle_text(mesh_handle)}:\{vertices.length()}",
      "triangle mesh positions length must be >= 3; skipping draw for \{mesh_handle_text(mesh_handle)}",
    )
    return
  }
  guard resolve_triangle_indices(mesh_handle, mesh) is Some(triangle_indices) else {
    warn_texture_issue(
      "triangles_invalid_indices:\{mesh_handle_text(mesh_handle)}",
      "triangle mesh \{mesh_handle_text(mesh_handle)} has invalid index/topology data; skipping draw",
    )
    return
  }
  let (effective_bundle, uv0, uv1) = resolve_triangle_uv_sets(
    mesh, mesh_handle, texture_bundle,
  )
  let mut normals = resolve_triangle_normals(mesh, triangle_indices)
  if normals.length() != vertices.length() {
    warn_texture_issue(
      "triangles_normals_mismatch:\{normals.length()}:\{vertices.length()}",
      "triangle mesh normal count (\{normals.length()}) != vertex count (\{vertices.length()}); fallback to default normals",
    )
    normals = []
    for _ in 0..<vertices.length() {
      normals.push(@smath.Vec3(0.0, 1.0, 0.0))
    }
  }
  let colors = mesh.colors.bind(fn(candidates) {
    if candidates.length() == vertices.length() {
      Some(candidates)
    } else {
      warn_texture_issue(
        "triangles_color_mismatch:\{candidates.length()}:\{vertices.length()}",
        "triangle mesh color count (\{candidates.length()}) != vertex count (\{vertices.length()}); ignoring vertex colors",
      )
      None
    }
  })
  let tangents = mesh.tangents.bind(fn(candidates) {
    if candidates.length() == vertices.length() {
      Some(candidates)
    } else {
      warn_texture_issue(
        "triangles_tangent_mismatch:\{candidates.length()}:\{vertices.length()}",
        "triangle mesh tangent count (\{candidates.length()}) != vertex count (\{vertices.length()}); ignoring vertex tangents",
      )
      None
    }
  })
  guard expand_vec3_with_indices(vertices, triangle_indices)
    is Some(expanded_vertices) else {
    return
  }
  guard expand_vec3_with_indices(normals, triangle_indices)
    is Some(expanded_normals) else {
    return
  }
  let expanded_uv0 = uv0.bind(fn(values) {
    expand_vec2_with_indices(values, triangle_indices)
  })
  let expanded_uv1 = uv1.bind(fn(values) {
    expand_vec2_with_indices(values, triangle_indices)
  })
  let expanded_colors = colors.bind(fn(values) {
    expand_color_with_indices(values, triangle_indices)
  })
  let expanded_tangents = tangents.bind(fn(values) {
    expand_tangent_with_indices(values, triangle_indices)
  })
  let cache_key = triangle_mesh_cache_key(mesh_handle)
  let ray_mesh = if backend.triangle_mesh_cache.get(cache_key) is Some(cached) {
    cached
  } else {
    guard create_uploaded_triangle_mesh(
        expanded_vertices, expanded_uv0, expanded_uv1, expanded_normals, expanded_tangents,
        expanded_colors,
      )
      is Some(created) else {
      warn_texture_issue(
        "triangles_build_failed:\{mesh_handle_text(mesh_handle)}",
        "failed to build GPU mesh from triangle primitive \{mesh_handle_text(mesh_handle)}; skipping draw",
      )
      return
    }
    backend.triangle_mesh_cache.set(cache_key, created)
    created
  }
  draw_lit_mesh_with_material(
    ray_mesh,
    frame,
    camera_position,
    material,
    effective_bundle,
    expanded_tangents is Some(_),
    receive_shadows,
    shadow_state,
  )
}

///|
fn resolve_triangle_normals(
  mesh : @render3d_types.TriangleMesh3D,
  triangle_indices : Array[Int],
) -> Array[@smath.Vec3] {
  mesh.normals
  .filter(fn(candidates) { candidates.length() == mesh.positions.length() })
  .unwrap_or(compute_vertex_normals(mesh.positions, triangle_indices))
}

///|
fn compute_vertex_normals(
  positions : Array[@smath.Vec3],
  triangle_indices : Array[Int],
) -> Array[@smath.Vec3] {
  let normals : Array[@smath.Vec3] = []
  for _ in 0..<positions.length() {
    normals.push(@smath.Vec3::zero())
  }
  let triangle_count = triangle_indices.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let ia = triangle_indices[base]
    let ib = triangle_indices[base + 1]
    let ic = triangle_indices[base + 2]
    if ia < 0 ||
      ia >= positions.length() ||
      ib < 0 ||
      ib >= positions.length() ||
      ic < 0 ||
      ic >= positions.length() {
      continue
    }
    let a = positions[ia]
    let b = positions[ib]
    let c = positions[ic]
    let mut normal = (b - a).cross(c - a)
    if normal.length_squared() <= 0.0000001 {
      normal = @smath.Vec3(0.0, 1.0, 0.0)
    }
    normals[ia] = normals[ia] + normal
    normals[ib] = normals[ib] + normal
    normals[ic] = normals[ic] + normal
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    normals[index] = if normal.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, 1.0, 0.0)
    } else {
      normal.normalize()
    }
  }
  normals
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
  reset_cosmic_runtime()
}

///|
pub fn set_embedded_assets(lookup : (String) -> Bytes?) -> Unit {
  backend.embedded_asset_lookup = lookup
  backend.embedded_asset_cache = Map([])
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
pub fn capture_frame_png() -> Bytes? {
  let image = @raylib.Image::load_from_screen()
  if !image.is_valid() {
    image.unload()
    return None
  }
  let bytes = image.export_to_memory(".png")
  image.unload()
  if bytes.length() == 0 {
    None
  } else {
    Some(bytes)
  }
}

///|
pub fn capture_frame_png_to_file(path : String) -> Bool {
  let image = @raylib.Image::load_from_screen()
  if !image.is_valid() {
    image.unload()
    return false
  }
  let ok = image.export_(path)
  image.unload()
  ok
}

///|
pub fn request_close() -> Unit {
  backend.close_requested = true
}
