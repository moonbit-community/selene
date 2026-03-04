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
  mut lock_state : Ref[Bool]?
  mut lock_requested : Bool
  mut cursor_locked : Bool
  textures : Map[String, @raylib.Texture]
  sounds : Map[String, @raylib.Sound]
  musics : Map[String, @raylib.Music]
  looping_tracks : Set[String]
  font_alias : Map[String, String]
  fonts_by_path : Map[String, @raylib.Font]
  mut embedded_asset_cache : Map[String, Bytes]
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
  lock_state: None,
  lock_requested: false,
  cursor_locked: false,
  textures: Map::new(),
  sounds: Map::new(),
  musics: Map::new(),
  looping_tracks: Set::new(),
  font_alias: Map::new(),
  fonts_by_path: Map::new(),
  embedded_asset_cache: Map::new(),
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
fn to_ray_vector2(x : Double, y : Double) -> @raylib.Vector2 {
  @raylib.Vector2::new(to_float(x), to_float(y))
}

///|
fn to_ray_vector3(value : @render.Vec3) -> @raylib.Vector3 {
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
fn to_ray_camera3d(camera : @render.Camera3D) -> @raylib.Camera3D {
  @raylib.Camera3D::new(
    to_ray_vector3(camera.position),
    to_ray_vector3(camera.target),
    to_ray_vector3(camera.up),
    to_float(camera.fovy),
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
fn get_music(path : String) -> @raylib.Music {
  if backend.musics.get(path) is Some(music) {
    return music
  }
  let music = if get_embedded_asset(path) is Some(bytes) {
    @raylib.load_music_stream_from_memory(
      file_extension(path),
      bytes,
      bytes.length(),
    )
  } else {
    @raylib.load_music_stream(path)
  }
  backend.musics.set(path, music)
  music
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
fn update_looping_tracks() -> Unit {
  for path in backend.looping_tracks {
    if backend.musics.get(path) is Some(music) {
      @raylib.update_music_stream(music)
      if !@raylib.is_music_stream_playing(music) {
        @raylib.play_music_stream(music)
      }
    }
  }
}

///|
fn cleanup_resources() -> Unit {
  for _path, texture in backend.textures {
    @raylib.unload_texture(texture)
  }
  for _path, sound in backend.sounds {
    @raylib.unload_sound(sound)
  }
  for _path, music in backend.musics {
    @raylib.unload_music_stream(music)
  }
  for _path, font in backend.fonts_by_path {
    @raylib.unload_font(font)
  }
}

///|
pub fn initialize(config : @render.BackendConfig) -> () -> Unit {
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  backend.image_smooth = config.image_smooth
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
    (config.startup)()
    while !@raylib.window_should_close() {
      let delta = @raylib.get_frame_time().to_double()
      backend.realtime_delta = delta
      sync_key_events()
      sync_mouse_events()
      sync_mouse_lock()
      update_looping_tracks()
      (config.game_loop)(delta * backend.time_scale)
      @raylib.begin_drawing()
      @raylib.clear_background(@raylib.black)
      (config.render_loop)(delta * backend.time_scale)
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
pub fn draw_image(command : @render.ImageDrawCommand) -> Unit {
  let texture = get_texture(command.path)
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
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  backend.lock_state = Some(locked)
  backend.lock_requested = locked.val
  sync_mouse_lock()
  backend.cursor_locked = @raylib.is_cursor_hidden()
  locked.val = backend.cursor_locked
}

///|
pub fn draw_text(command : @render.TextDrawCommand) -> Unit {
  let font = get_font_by_family(command.style.family)
  let measured = @raylib.measure_text_ex(
    font,
    command.text,
    to_float(command.style.size),
    0.0,
  )
  let text_width = vector2_x(measured)
  let text_height = vector2_y(measured)
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
pub fn draw_rect(command : @render.RectDrawCommand) -> Unit {
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
pub fn draw_circle(command : @render.CircleDrawCommand) -> Unit {
  let center = to_ray_vector2(command.center[X], command.center[Y])
  let radius = to_float(command.radius)
  @raylib.draw_circle_v(center, radius, to_ray_color(command.fill_color))
  if command.stroke_color is Some(stroke_color) {
    @raylib.draw_circle_lines_v(center, radius, to_ray_color(stroke_color))
  }
}

///|
pub fn draw_gradient_rect(command : @render.GradientRectDrawCommand) -> Unit {
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
pub fn begin_3d(camera : @render.Camera3D) -> Unit {
  @raylib.begin_mode_3d(to_ray_camera3d(camera))
}

///|
pub fn end_3d() -> Unit {
  @raylib.end_mode_3d()
}

///|
pub fn draw_cube_3d(command : @render.CubeDrawCommand3D) -> Unit {
  @raylib.draw_cube(
    to_ray_vector3(command.center),
    to_float(command.size.x),
    to_float(command.size.y),
    to_float(command.size.z),
    to_ray_color(command.color),
  )
}

///|
pub fn draw_cube_wires_3d(command : @render.CubeDrawCommand3D) -> Unit {
  @raylib.draw_cube_wires(
    to_ray_vector3(command.center),
    to_float(command.size.x),
    to_float(command.size.y),
    to_float(command.size.z),
    to_ray_color(command.color),
  )
}

///|
pub fn draw_sphere_3d(command : @render.SphereDrawCommand3D) -> Unit {
  @raylib.draw_sphere(
    to_ray_vector3(command.center),
    to_float(command.radius),
    to_ray_color(command.color),
  )
}

///|
pub fn draw_cylinder_3d(command : @render.CylinderDrawCommand3D) -> Unit {
  @raylib.draw_cylinder(
    to_ray_vector3(command.center),
    to_float(command.radius_top),
    to_float(command.radius_bottom),
    to_float(command.height),
    command.slices,
    to_ray_color(command.color),
  )
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  loop_~ : Bool,
) -> Unit {
  if loop_ {
    let music = get_music(audio_path)
    @raylib.set_music_volume(music, to_float(volume))
    if !@raylib.is_music_stream_playing(music) {
      @raylib.play_music_stream(music)
    }
    backend.looping_tracks.add(audio_path)
  } else {
    backend.looping_tracks.remove(audio_path)
    let sound = get_sound(audio_path)
    @raylib.set_sound_volume(sound, to_float(volume))
    @raylib.play_sound(sound)
  }
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
