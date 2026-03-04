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
struct WebGpuBackend {
  canvas : @dom.HTMLCanvasElement
  mut time_scale : Double
  mouse_movement : Ref[@inputs.MouseMovement?]
}

///|
pub fn WebGpuBackend::new() -> WebGpuBackend {
  let canvas = @dom.document()
    .get_element_by_id("canvas")
    .unwrap()
    .to_html_canvas_element()
    .unwrap()
  { canvas, time_scale: 1.0, mouse_movement: Ref::new(None) }
}

///|
let canvas_backend : WebGpuBackend = WebGpuBackend::new()

///|
fn default_embedded_asset_lookup(_path : String) -> Bytes? {
  None
}

///|
let embedded_asset_lookup : Ref[(String) -> Bytes?] = Ref::new(
  default_embedded_asset_lookup,
)

///|
let embedded_asset_cache : Map[String, Bytes] = Map::new()

///|
fn get_embedded_asset(path : String) -> Bytes? {
  if embedded_asset_cache.get(path) is Some(bytes) {
    return Some(bytes)
  }
  if (embedded_asset_lookup.val)(path) is Some(bytes) {
    embedded_asset_cache.set(path, bytes)
    Some(bytes)
  } else {
    None
  }
}

///|
fn saturating_file_byte(value : Int) -> Byte {
  if value < 0 {
    Int::to_byte(0)
  } else if value > 255 {
    Int::to_byte(255)
  } else {
    value.to_byte()
  }
}

///|
pub fn set_time_scale(time_scale : Double) -> Unit {
  canvas_backend.time_scale = time_scale
}

///|
pub fn set_embedded_assets(lookup : (String) -> Bytes?) -> Unit {
  embedded_asset_lookup.val = lookup
  embedded_asset_cache.clear()
}

///|
pub fn get_asset_bytes(path : String) -> Bytes? {
  if get_embedded_asset(path) is Some(bytes) {
    return Some(bytes)
  }
  let resolved_path = resolve_asset_path(path)
  if resolved_path != path && get_embedded_asset(resolved_path) is Some(bytes) {
    return Some(bytes)
  }
  if resolved_path.has_prefix("/") {
    let trimmed = resolved_path.unsafe_substring(
      start=1,
      end=resolved_path.length(),
    )
    if get_embedded_asset(trimmed) is Some(bytes) {
      return Some(bytes)
    }
  }
  let raw = webgpu_load_file_bytes_sync(resolved_path)
  if raw.length() == 0 {
    return None
  }
  Some(
    Bytes::from_iter(raw.iter().map(fn(value) { saturating_file_byte(value) })),
  )
}

///|
let realtime_delta : Ref[Double] = Ref::new(0.0)

///|
pub fn initialize(config : @render.BackendConfig) -> () -> Unit {
  let startup = config.startup
  let render_loop = config.render_loop
  let game_loop = config.game_loop
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  let screen_width = config.screen_width
  let screen_height = config.screen_height
  let fps = config.fps
  let image_smooth = config.image_smooth
  if fps > 60 {
    println(
      "Warning: FPS is set above 60. The browser's window only support up to 60 FPS.",
    )
  }
  set_viewport_height(canvas_backend.canvas, screen_height)
  set_viewport_width(canvas_backend.canvas, screen_width)
  webgpu_initialize(
    canvas_backend.canvas,
    screen_width,
    screen_height,
    image_smooth,
  )
  startup()
  schedule_with_fixed_interval(1000 / fps.to_double(), fn(delta) {
    let delta = delta / 1000.0
    realtime_delta.val = delta
    game_loop(delta * canvas_backend.time_scale)
    webgpu_begin_frame(0.0, 0.0, 0.0, 1.0)
    render_loop(delta * canvas_backend.time_scale)
    webgpu_end_frame()
    if canvas_backend.mouse_movement.val is Some(mouse_movement) {
      mouse_movement.movement = @smath.Vec2D(0.0, 0.0)
    }
  })
  |> ignore
  return fn() {  }
}

///|
pub fn get_realtime_delta() -> Double {
  realtime_delta.val
}

///|
let window : @dom.Window = @dom.window()

///|
fn schedule_with_fixed_interval(
  interval : Double,
  callback : (Double) -> Unit,
) -> () -> Unit {
  let lastTime = Ref::new(0.0)
  let accumulator = Ref::new(0.0)
  let lastId = Ref::new(0.0)
  fn update(time : Double) -> Unit {
    if lastTime.val == 0.0 {
      lastTime.val = time
    }
    let delta = time - lastTime.val
    lastTime.val = time
    accumulator.val = accumulator.val + delta

    // Run callback for each complete interval
    while accumulator.val >= interval {
      callback(delta)
      accumulator.val = accumulator.val - interval
    }
    lastId.val = window.request_animation_frame(update)
  }

  lastId.val = window.request_animation_frame(update)
  () => if lastId.val != 0.0 { window.cancel_animation_frame(lastId.val) }
}

///|
pub fn load_font(font : String, path : String) -> Unit {
  let resolved_path = resolve_asset_path(path)
  load_font_async(font, resolved_path)
  webgpu_preload_font_bytes(font, resolved_path)
}

///|
pub fn get_time_scale() -> Double {
  canvas_backend.time_scale
}
