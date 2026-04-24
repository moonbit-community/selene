///|
const RAYLIB_DEFAULT_TEXT_SPACING : Float = 1.0

///|
const RAYLIB_DEFAULT_AUDIO_STREAM_BUFFER_SIZE = 4096

///|
fn reset_cosmic_runtime() -> Unit {
  backend.cosmic_loaded_families.clear()
  for _key, entry in backend.cosmic_textures {
    @raylib.unload_texture(entry.texture)
  }
  backend.cosmic_textures.clear()
  cosmic_font_system.val = @cosmic.FontSystem::new()
  cosmic_swash_cache.val = @cosmic.SwashCache::new()
}

///|
fn ensure_cosmic_font_loaded(family : String) -> Bool {
  if backend.cosmic_loaded_families.contains(family) {
    return true
  }
  guard backend.font_alias.get(family) is Some(path) else { return false }
  guard get_asset_bytes(path) is Some(bytes) else { return false }
  cosmic_font_system.val = cosmic_font_system.val.load_font_data(bytes)
  backend.cosmic_loaded_families.add(family)
  true
}

///|
fn cosmic_text_cache_key(
  text : String,
  style : @render2d_types.TextStyle2D,
) -> String {
  let color = style.color
  let alpha = clamp_u8((color.a * 255.0).round().to_int())
  "t:" +
  text.length().to_string() +
  ":" +
  text +
  "|f:" +
  style.family.length().to_string() +
  ":" +
  style.family +
  "|s:" +
  style.size.to_string() +
  "|r:" +
  color.r.to_string() +
  "|g:" +
  color.g.to_string() +
  "|b:" +
  color.b.to_string() +
  "|a:" +
  alpha.to_string()
}

///|
fn cosmic_font_size(size : Double) -> Double {
  if size <= 0.0 {
    1.0
  } else {
    size
  }
}

///|
fn rasterize_with_cosmic(
  text : String,
  style : @render2d_types.TextStyle2D,
) -> CosmicRasterImage? {
  guard text != "" else { return None }
  guard ensure_cosmic_font_loaded(style.family) else { return None }
  let font_size = cosmic_font_size(style.size)
  let metrics = @cosmic.Metrics::new(
    Float::from_double(font_size),
    Float::from_double(font_size * 1.25),
  )
  let attrs = @cosmic.Attrs::new().family(@cosmic.Family::Name(style.family))
  let attrs_list = @cosmic.AttrsList::new(attrs)
  let buffer = @cosmic.Buffer::new(metrics)
    .set_wrap(@cosmic.Wrap::None)
    .set_text(text, attrs_list, @cosmic.Shaping::Advanced)
    .set_size(None, None)

  let mut min_x = 0
  let mut min_y = 0
  let mut max_x = -1
  let mut max_y = -1
  let fills : Array[(Int, Int, Int, Int, Int, Int, Int, Int)] = []
  let (drawn_buffer, swash_cache) = buffer.draw(
    cosmic_font_system.val,
    cosmic_swash_cache.val,
    @cosmic.Color::rgba(
      style.color.r.to_byte(),
      style.color.g.to_byte(),
      style.color.b.to_byte(),
      clamp_u8((style.color.a * 255.0).round().to_int()).to_byte(),
    ),
    fn(x, y, width, height, color) {
      let w = width.reinterpret_as_int()
      let h = height.reinterpret_as_int()
      guard w > 0 && h > 0 else { return }
      let (r, g, b, a) = color.as_rgba()
      fills.push((x, y, w, h, r.to_int(), g.to_int(), b.to_int(), a.to_int()))
      let right = x + w - 1
      let bottom = y + h - 1
      if max_x < min_x {
        min_x = x
        min_y = y
        max_x = right
        max_y = bottom
      } else {
        if x < min_x {
          min_x = x
        }
        if y < min_y {
          min_y = y
        }
        if right > max_x {
          max_x = right
        }
        if bottom > max_y {
          max_y = bottom
        }
      }
    },
  )
  ignore(drawn_buffer)
  cosmic_swash_cache.val = swash_cache
  guard !fills.is_empty() else { return None }
  let width = max_x - min_x + 1
  let height = max_y - min_y + 1
  let pixels = Array::make(width * height * 4, 0)
  for fill in fills {
    let x = fill.0
    let y = fill.1
    let w = fill.2
    let h = fill.3
    let r = fill.4
    let g = fill.5
    let b = fill.6
    let a = fill.7
    for local_y in 0..<h {
      let py = y + local_y - min_y
      if py < 0 || py >= height {
        continue
      }
      for local_x in 0..<w {
        let px = x + local_x - min_x
        if px < 0 || px >= width {
          continue
        }
        let idx = (py * width + px) * 4
        pixels[idx] = r
        pixels[idx + 1] = g
        pixels[idx + 2] = b
        pixels[idx + 3] = a
      }
    }
  }
  Some({ width, height, pixels })
}

///|
fn texture_from_cosmic_raster(raster : CosmicRasterImage) -> CosmicTextTexture? {
  guard raster.width > 0 && raster.height > 0 else { return None }
  let image = @raylib.gen_image_color(
    raster.width,
    raster.height,
    @raylib.Color::new(0, 0, 0, 0),
  )
  let texture = @raylib.load_texture_from_image(image)
  @raylib.unload_image(image)
  @raylib.update_texture(
    texture,
    Bytes::from_iter(
      raster.pixels.iter().map(fn(value) { clamp_u8(value).to_byte() }),
    ),
  )
  @raylib.set_texture_filter(texture, configured_filter())
  Some({ texture, width: raster.width, height: raster.height })
}

///|
fn cosmic_texture_for_text(
  text : String,
  style : @render2d_types.TextStyle2D,
) -> CosmicTextTexture? {
  let key = cosmic_text_cache_key(text, style)
  if backend.cosmic_textures.get(key) is Some(cached) {
    return Some(cached)
  }
  guard rasterize_with_cosmic(text, style) is Some(raster) else { return None }
  guard texture_from_cosmic_raster(raster) is Some(created) else { return None }
  backend.cosmic_textures.set(key, created)
  Some(created)
}

///|
fn measure_text_with_cosmic(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @smath.Vec2? {
  guard ensure_cosmic_font_loaded(style.family) else { return None }
  let font_size = cosmic_font_size(style.size)
  let metrics = @cosmic.Metrics::new(
    Float::from_double(font_size),
    Float::from_double(font_size * 1.25),
  )
  let attrs = @cosmic.Attrs::new().family(@cosmic.Family::Name(style.family))
  let attrs_list = @cosmic.AttrsList::new(attrs)
  let buffer = @cosmic.Buffer::new(metrics)
    .set_wrap(@cosmic.Wrap::None)
    .set_text(text, attrs_list, @cosmic.Shaping::Advanced)
    .set_size(None, None)
    .layout_all_with_font_system(cosmic_font_system.val)
  let mut width = 0.0
  let mut height = 0.0
  for run in buffer.layout_runs() {
    width = @cmp.maximum(width, run.line_w.to_double())
    height = @cmp.maximum(height, (run.line_top + run.line_height).to_double())
  }
  if height <= 0.0 {
    height = font_size
  }
  Some(@smath.Vec2(width, height))
}

///|
fn draw_text_with_cosmic(command : @render2d_types.TextDrawCommand2D) -> Bool {
  guard command.text != "" else { return true }
  guard command.style.color.a > 0.0 else { return true }
  guard cosmic_texture_for_text(command.text, command.style)
    is Some(cached_texture) else {
    return false
  }
  let measured = measure_text_with_cosmic(command.style, command.text).unwrap_or(
    @smath.Vec2(
      cached_texture.width.to_double(),
      cached_texture.height.to_double(),
    ),
  )
  let mut x = command.position[X]
  let mut y = command.position[Y]
  match command.style.align {
    Left => ()
    Center => x -= measured[X] / 2.0
    Right => x -= measured[X]
  }
  match command.style.baseline {
    Top => ()
    Center => y -= measured[Y] / 2.0
    Bottom => y -= measured[Y]
  }
  @raylib.draw_texture_pro(
    cached_texture.texture,
    to_ray_rect(
      0.0,
      0.0,
      cached_texture.width.to_double(),
      cached_texture.height.to_double(),
    ),
    to_ray_rect(
      x,
      y,
      cached_texture.width.to_double(),
      cached_texture.height.to_double(),
    ),
    to_ray_vector2(0.0, 0.0),
    0.0,
    to_ray_color(white_render_color()),
  )
  true
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
    mouse.pos = @smath.Vec2(pos[X], pos[Y])
    movement.movement = @smath.Vec2(delta[X], delta[Y])
    if backend.mouse_wheel is Some(mouse_wheel) {
      mouse_wheel.delta = @smath.Vec2(wheel[X], wheel[Y])
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
    let gamepad = @inputs.Gamepad(id)
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
      buttons.add(@inputs.GamepadButtonInput(gamepad, mapping.1))
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
    @inputs.GamepadAxisInput(gamepad, LeftStickX),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftX).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput(gamepad, LeftStickY),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftY).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput(gamepad, RightStickX),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisRightX).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput(gamepad, RightStickY),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisRightY).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput(gamepad, LeftZ),
    @raylib.get_gamepad_axis_movement(id, @raylib.GamepadAxisLeftTrigger).to_double(),
  )
  axes.set(
    @inputs.GamepadAxisInput(gamepad, RightZ),
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
  reset_cosmic_runtime()
  backend.embedded_asset_cache.clear()
  for _key, mesh in backend.primitive_meshes {
    @raylib.unload_mesh(mesh)
  }
  backend.primitive_meshes.clear()
  for _key, mesh in backend.triangle_mesh_cache {
    @raylib.unload_mesh(mesh)
  }
  backend.triangle_mesh_cache.clear()
  let cleanup_default_material = if backend.lit_material is Some(_) ||
    backend.lit_textured_material is Some(_) ||
    backend.shadow_material is Some(_) {
    Some(@raylib.Material::default())
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
    render_texture.unload()
  }
  backend.shadow_render_textures.clear()
  backend.directional_shadow_tile_sizes.clear()
  backend.directional_shadow_atlas_columns.clear()
  backend.directional_shadow_atlas_rows.clear()
  if backend.spot_shadow_render_texture is Some(render_texture) {
    render_texture.unload()
  }
  backend.spot_shadow_render_texture = None
  backend.spot_shadow_map_size = 0
  if backend.point_shadow_render_texture is Some(render_texture) {
    render_texture.unload()
  }
  backend.point_shadow_render_texture = None
  backend.point_shadow_map_size = 0
  for _name, target in backend.offscreen_targets_2d {
    target.render_texture.unload()
  }
  backend.offscreen_targets_2d.clear()
  backend.active_2d_offscreen_target = None
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
    @raylib.set_audio_stream_buffer_size_default(
      RAYLIB_DEFAULT_AUDIO_STREAM_BUFFER_SIZE,
    )
    backend.texture_warning_keys.clear()
    (callbacks.startup)()
    while !backend.close_requested && !@raylib.window_should_close() {
      let delta = @raylib.get_frame_time().to_double()
      backend.realtime_delta = delta
      sync_key_events()
      sync_mouse_events()
      sync_gamepad_events()
      sync_mouse_lock()
      (callbacks.service_frame)()
      (callbacks.game_loop)(delta * backend.time_scale)
      @raylib.begin_drawing()
      @raylib.clear_background(@raylib.black)
      backend.frame_has_draw_commands = false
      (callbacks.render_loop)(delta * backend.time_scale)
      (callbacks.service_frame)()
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
  let texture = match offscreen_target_texture(image_path) {
    Some(texture) => Some(texture)
    None =>
      if offscreen_target_name_from_path(image_path) is Some(_) {
        None
      } else {
        Some(get_texture(image_path))
      }
  }
  guard texture is Some(texture) else { return }
  mark_frame_drawn()
  with_blend_mode(command.blend_mode, fn() {
    draw_image_repeat_transform(
      texture,
      command,
      flip_y=offscreen_target_name_from_path(image_path) is Some(_),
    )
  })
}
