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
priv struct RaylibBackend {
  mut time_scale : Double
  mut image_smooth : Bool
  mut realtime_delta : Double
  mut embedded_asset_lookup : (String) -> Bytes?
  mut key_events : Set[@inputs.Code]?
  mut mouse_state : @inputs.Mouse?
  mut mouse_movement : @inputs.MouseMovement?
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
}

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
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn factor_to_u8(value : Double) -> UInt {
  (clamp01(value) * 255.0).to_int().reinterpret_as_uint()
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
fn has_scene_lights(frame : @render3d_types.RenderFrame3D) -> Bool {
  frame.ambient_light is Some(_) ||
  frame.directional_lights.length() > 0 ||
  frame.point_lights.length() > 0 ||
  frame.spot_lights.length() > 0
}

///|
fn light_rgb(color : @render.Color, intensity : Double) -> @smath.Vec3 {
  color_to_vec3(color).scalar_mul(@cmp.maximum(0.0, intensity))
}

///|
fn range_attenuation(distance : Double, range : Double) -> Double {
  if range <= 0.000001 {
    1.0
  } else if distance >= range {
    0.0
  } else {
    let t = 1.0 - distance / range
    t * t
  }
}

///|
fn spot_cone_attenuation(
  light : @render3d_types.FrameSpotLight3D,
  point : @smath.Vec3,
) -> Double {
  let light_dir = normalize_or(
    light.direction,
    @smath.Vec3::new(0.0, -1.0, 0.0),
  )
  let from_light = point - light.position
  if from_light.length_squared() <= 0.0000001 {
    return 1.0
  }
  let point_dir = from_light.normalize()
  let cos_theta = light_dir.dot(point_dir)
  let inner = @cmath.cos(light.inner_angle)
  let outer = @cmath.cos(light.outer_angle)
  let high = @cmp.maximum(inner, outer)
  let low = @cmp.minimum(inner, outer)
  let delta = high - low
  if cos_theta <= low {
    0.0
  } else if cos_theta >= high || delta.abs() <= 0.000001 {
    1.0
  } else {
    (cos_theta - low) / delta
  }
}

///|
fn compute_lighting_rgb(
  frame : @render3d_types.RenderFrame3D,
  world_pos : @smath.Vec3,
  world_normal : @smath.Vec3,
) -> @smath.Vec3 {
  if !has_scene_lights(frame) {
    return @smath.Vec3::one()
  }
  let normal = normalize_or(world_normal, @smath.Vec3::new(0.0, 1.0, 0.0))
  let mut out = @smath.Vec3::zero()
  if frame.ambient_light is Some(ambient) {
    out = out + light_rgb(ambient.color, ambient.intensity)
  }
  for light in frame.directional_lights {
    let incoming = -normalize_or(
      light.direction,
      @smath.Vec3::new(0.0, -1.0, 0.0),
    )
    let lambert = @cmp.maximum(0.0, normal.dot(incoming))
    if lambert > 0.0 {
      out = out + light_rgb(light.color, light.intensity * lambert)
    }
  }
  for light in frame.point_lights {
    let to_light = light.position - world_pos
    let distance = to_light.length()
    if distance <= 0.000001 {
      out = out + light_rgb(light.color, light.intensity)
      continue
    }
    let lambert = @cmp.maximum(0.0, normal.dot(to_light.scalar_div(distance)))
    if lambert <= 0.0 {
      continue
    }
    let attenuation = range_attenuation(distance, light.range)
    if attenuation <= 0.0 {
      continue
    }
    out = out + light_rgb(light.color, light.intensity * lambert * attenuation)
  }
  for light in frame.spot_lights {
    let to_light = light.position - world_pos
    let distance = to_light.length()
    if distance <= 0.000001 {
      out = out + light_rgb(light.color, light.intensity)
      continue
    }
    let lambert = @cmp.maximum(0.0, normal.dot(to_light.scalar_div(distance)))
    if lambert <= 0.0 {
      continue
    }
    let attenuation = range_attenuation(distance, light.range)
    if attenuation <= 0.0 {
      continue
    }
    let cone = spot_cone_attenuation(light, world_pos)
    if cone <= 0.0 {
      continue
    }
    out = out +
      light_rgb(light.color, light.intensity * lambert * attenuation * cone)
  }
  out
}

///|
fn lit_material_color(
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  world_pos : @smath.Vec3,
  world_normal : @smath.Vec3,
) -> @render.Color {
  let base_rgb = color_to_vec3(material.base_color)
  let emissive_rgb = color_to_vec3(material.emissive_color)
  let lighting_rgb = compute_lighting_rgb(frame, world_pos, world_normal)
  let lit = base_rgb * lighting_rgb + emissive_rgb
  {
    r: factor_to_u8(lit.x),
    g: factor_to_u8(lit.y),
    b: factor_to_u8(lit.z),
    a: clamp01(material.base_color.a),
  }
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
    // Keep raw screen-space mouse coordinates consistent with canvas backend.
    // Core click systems are responsible for applying zoom conversion.
    mouse.pos = @smath.Vec2D(pos[X], pos[Y])
    movement.movement = @smath.Vec2D(delta[X], delta[Y])
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
  for _path, sound in backend.sounds {
    @raylib.unload_sound(sound)
  }
  for _path, font in backend.fonts_by_path {
    @raylib.unload_font(font)
  }
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
    @raylib.set_target_fps(config.fps.reinterpret_as_int())
    if !@raylib.is_audio_device_ready() {
      @raylib.init_audio_device()
    }
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
pub fn register_key_events(pressed_keys : Set[@inputs.Code]) -> Unit {
  backend.key_events = Some(pressed_keys)
}

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_movement : @inputs.MouseMovement,
) -> Unit {
  backend.mouse_state = Some(mouse)
  backend.mouse_movement = Some(mouse_movement)
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
    draw_mesh3d_instance(mesh_asset, material, item.transform, frame)
  }
  end_3d()
}

///|
fn draw_mesh3d_instance(
  mesh_asset : @render3d_types.MeshAsset,
  material : @render3d_types.StandardMaterial3D,
  transform : @render3d_types.FrameTransform3D,
  frame : @render3d_types.RenderFrame3D,
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
  let lit_color = lit_material_color(
    material,
    frame,
    transform.translation,
    transform.rotation.rotate_vec3(@smath.Vec3::new(0.0, 1.0, 0.0)),
  )
  let color = to_ray_color(lit_color)
  match mesh_asset.primitive {
    Cube(size) =>
      if !draw_textured_cuboid_if_possible(size, material, lit_color) {
        @raylib.draw_cube(
          @raylib.Vector3::new(0.0F, 0.0F, 0.0F),
          to_float(size.x),
          to_float(size.y),
          to_float(size.z),
          color,
        )
      }
    Sphere(radius) =>
      if !draw_textured_sphere_if_possible(radius, material, lit_color) {
        @raylib.draw_sphere(
          @raylib.Vector3::new(0.0F, 0.0F, 0.0F),
          to_float(radius),
          color,
        )
      }
    Cylinder(radius_top, radius_bottom, height, slices) =>
      if !draw_textured_cylinder_if_possible(
          radius_top, radius_bottom, height, slices, material, lit_color,
        ) {
        @raylib.draw_cylinder(
          @raylib.Vector3::new(0.0F, 0.0F, 0.0F),
          to_float(radius_top),
          to_float(radius_bottom),
          to_float(height),
          slices,
          color,
        )
      }
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
      let cuboid = @smath.Vec3::new(size.x, thickness, size.z)
      if !draw_textured_cuboid_if_possible(cuboid, material, lit_color) {
        @raylib.draw_cube(
          @raylib.Vector3::new(0.0F, 0.0F, 0.0F),
          to_float(size.x),
          to_float(thickness),
          to_float(size.z),
          color,
        )
      }
    }
    Triangles(mesh) => draw_triangle_mesh(mesh, material, lit_color)
  }
  @rl.pop_matrix()
}

///|
const TEXTURED_SPHERE_STACKS : Int = 16

///|
const TEXTURED_SPHERE_SLICES : Int = 24

///|
fn draw_textured_cuboid_if_possible(
  size : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  tint : @render.Color,
) -> Bool {
  guard resolve_material_texture(material) is Some(texture) else {
    return false
  }
  let (vertices, uvs, normals) = build_cuboid_mesh(size)
  draw_textured_triangle_mesh(vertices, uvs, normals, texture, tint)
  true
}

///|
fn draw_textured_sphere_if_possible(
  radius : Double,
  material : @render3d_types.StandardMaterial3D,
  tint : @render.Color,
) -> Bool {
  guard resolve_material_texture(material) is Some(texture) else {
    return false
  }
  let (vertices, uvs, normals) = build_sphere_mesh(radius)
  if vertices.length() < 3 {
    return false
  }
  draw_textured_triangle_mesh(vertices, uvs, normals, texture, tint)
  true
}

///|
fn draw_textured_cylinder_if_possible(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  material : @render3d_types.StandardMaterial3D,
  tint : @render.Color,
) -> Bool {
  guard resolve_material_texture(material) is Some(texture) else {
    return false
  }
  let (vertices, uvs, normals) = build_cylinder_mesh(
    radius_top, radius_bottom, height, slices,
  )
  if vertices.length() < 3 {
    return false
  }
  draw_textured_triangle_mesh(vertices, uvs, normals, texture, tint)
  true
}

///|
fn resolve_material_texture(
  material : @render3d_types.StandardMaterial3D,
) -> @raylib.Texture? {
  guard material.base_color_texture is Some(image_handle) else { return None }
  guard backend.images3d.get(image_handle) is Some(image_asset) else {
    return None
  }
  Some(get_texture(image_asset.path))
}

///|
fn build_sphere_mesh(
  radius : Double,
) -> (Array[@smath.Vec3], Array[@smath.Vec2D], Array[@smath.Vec3]) {
  let vertices : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2D] = []
  let normals : Array[@smath.Vec3] = []
  for stack in 0..<TEXTURED_SPHERE_STACKS {
    let stack0 = stack.to_double() / TEXTURED_SPHERE_STACKS.to_double()
    let stack1 = (stack + 1).to_double() / TEXTURED_SPHERE_STACKS.to_double()
    let theta0 = stack0 * @cmath.PI
    let theta1 = stack1 * @cmath.PI
    for slice in 0..<TEXTURED_SPHERE_SLICES {
      let slice0 = slice.to_double() / TEXTURED_SPHERE_SLICES.to_double()
      let slice1 = (slice + 1).to_double() / TEXTURED_SPHERE_SLICES.to_double()
      let phi0 = slice0 * 2.0 * @cmath.PI
      let phi1 = slice1 * 2.0 * @cmath.PI
      let p00 = sphere_vertex(radius, theta0, phi0)
      let p01 = sphere_vertex(radius, theta0, phi1)
      let p10 = sphere_vertex(radius, theta1, phi0)
      let p11 = sphere_vertex(radius, theta1, phi1)
      let n00 = sphere_normal(theta0, phi0)
      let n01 = sphere_normal(theta0, phi1)
      let n10 = sphere_normal(theta1, phi0)
      let n11 = sphere_normal(theta1, phi1)
      let uv00 = @smath.Vec2D(slice0, 1.0 - stack0)
      let uv01 = @smath.Vec2D(slice1, 1.0 - stack0)
      let uv10 = @smath.Vec2D(slice0, 1.0 - stack1)
      let uv11 = @smath.Vec2D(slice1, 1.0 - stack1)
      push_textured_triangle(
        vertices, uvs, normals, p00, p10, p11, uv00, uv10, uv11, n00, n10, n11,
      )
      push_textured_triangle(
        vertices, uvs, normals, p00, p11, p01, uv00, uv11, uv01, n00, n11, n01,
      )
    }
  }
  (vertices, uvs, normals)
}

///|
fn sphere_vertex(radius : Double, theta : Double, phi : Double) -> @smath.Vec3 {
  let sin_theta = @cmath.sin(theta)
  @smath.Vec3::new(
    radius * sin_theta * @cmath.cos(phi),
    radius * @cmath.cos(theta),
    radius * sin_theta * @cmath.sin(phi),
  )
}

///|
fn sphere_normal(theta : Double, phi : Double) -> @smath.Vec3 {
  let sin_theta = @cmath.sin(theta)
  @smath.Vec3::new(
    sin_theta * @cmath.cos(phi),
    @cmath.cos(theta),
    sin_theta * @cmath.sin(phi),
  )
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
fn build_cuboid_mesh(
  size : @smath.Vec3,
) -> (Array[@smath.Vec3], Array[@smath.Vec2D], Array[@smath.Vec3]) {
  let hx = size.x / 2.0
  let hy = size.y / 2.0
  let hz = size.z / 2.0
  let vertices : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2D] = []
  let normals : Array[@smath.Vec3] = []
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(-hx, -hy, hz),
    @smath.Vec3::new(hx, -hy, hz),
    @smath.Vec3::new(hx, hy, hz),
    @smath.Vec3::new(-hx, hy, hz),
    @smath.Vec3::new(0.0, 0.0, 1.0),
  )
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(-hx, -hy, -hz),
    @smath.Vec3::new(-hx, hy, -hz),
    @smath.Vec3::new(hx, hy, -hz),
    @smath.Vec3::new(hx, -hy, -hz),
    @smath.Vec3::new(0.0, 0.0, -1.0),
  )
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(hx, -hy, -hz),
    @smath.Vec3::new(hx, hy, -hz),
    @smath.Vec3::new(hx, hy, hz),
    @smath.Vec3::new(hx, -hy, hz),
    @smath.Vec3::new(1.0, 0.0, 0.0),
  )
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(-hx, -hy, -hz),
    @smath.Vec3::new(-hx, -hy, hz),
    @smath.Vec3::new(-hx, hy, hz),
    @smath.Vec3::new(-hx, hy, -hz),
    @smath.Vec3::new(-1.0, 0.0, 0.0),
  )
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(-hx, hy, -hz),
    @smath.Vec3::new(-hx, hy, hz),
    @smath.Vec3::new(hx, hy, hz),
    @smath.Vec3::new(hx, hy, -hz),
    @smath.Vec3::new(0.0, 1.0, 0.0),
  )
  add_cuboid_face(
    vertices,
    uvs,
    normals,
    @smath.Vec3::new(-hx, -hy, -hz),
    @smath.Vec3::new(hx, -hy, -hz),
    @smath.Vec3::new(hx, -hy, hz),
    @smath.Vec3::new(-hx, -hy, hz),
    @smath.Vec3::new(0.0, -1.0, 0.0),
  )
  (vertices, uvs, normals)
}

///|
fn add_cuboid_face(
  vertices : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2D],
  normals : Array[@smath.Vec3],
  a : @smath.Vec3,
  b : @smath.Vec3,
  c : @smath.Vec3,
  d : @smath.Vec3,
  normal : @smath.Vec3,
) -> Unit {
  vertices.push(a)
  vertices.push(b)
  vertices.push(c)
  vertices.push(a)
  vertices.push(c)
  vertices.push(d)
  let uv0 = @smath.Vec2D(0.0, 1.0)
  let uv1 = @smath.Vec2D(1.0, 1.0)
  let uv2 = @smath.Vec2D(1.0, 0.0)
  let uv3 = @smath.Vec2D(0.0, 0.0)
  uvs.push(uv0)
  uvs.push(uv1)
  uvs.push(uv2)
  uvs.push(uv0)
  uvs.push(uv2)
  uvs.push(uv3)
  for _ in 0..<6 {
    normals.push(normal)
  }
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
  lit_color : @render.Color,
) -> Unit {
  let vertices = mesh.positions
  if vertices.length() < 3 {
    return
  }
  if material.base_color_texture is Some(image_handle) &&
    backend.images3d.get(image_handle) is Some(image_asset) &&
    mesh.uvs is Some(uvs) &&
    uvs.length() == vertices.length() {
    let normals = resolve_triangle_normals(mesh)
    draw_textured_triangle_mesh(
      vertices,
      uvs,
      normals,
      get_texture(image_asset.path),
      lit_color,
    )
    return
  }
  draw_colored_triangle_mesh(vertices, to_ray_color(lit_color))
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
fn draw_colored_triangle_mesh(
  vertices : Array[@smath.Vec3],
  color : @raylib.Color,
) -> Unit {
  let triangle_count = vertices.length() / 3
  for index in 0..<triangle_count {
    let base = index * 3
    @raylib.draw_triangle_3d(
      to_ray_vector3_smath(vertices[base]),
      to_ray_vector3_smath(vertices[base + 1]),
      to_ray_vector3_smath(vertices[base + 2]),
      color,
    )
  }
}

///|
fn draw_textured_triangle_mesh(
  vertices : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2D],
  normals : Array[@smath.Vec3],
  texture : @raylib.Texture,
  tint : @render.Color,
) -> Unit {
  let (tint_r, tint_g, tint_b, tint_a) = to_ray_color_bytes(tint)
  ignore(@rl.check_render_batch_limit(vertices.length()))
  @rl.set_texture(@raylib.get_texture_id(texture).reinterpret_as_uint())
  @rl.begin(@rl.Triangles)
  for index in 0..<vertices.length() {
    let vertex = vertices[index]
    let uv = uvs[index]
    let normal = normals[index]
    @rl.color4ub(tint_r, tint_g, tint_b, tint_a)
    @rl.normal3f(to_float(normal.x), to_float(normal.y), to_float(normal.z))
    @rl.tex_coord2f(to_float(uv[X]), to_float(uv[Y]))
    @rl.vertex3f(to_float(vertex.x), to_float(vertex.y), to_float(vertex.z))
  }
  @rl.end_()
  @rl.set_texture(0U)
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
