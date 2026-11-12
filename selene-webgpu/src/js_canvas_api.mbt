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
  mut canvas : BrowserCanvas?
  mut time_scale : Double
  mut gamepads : Set[@inputs.Gamepad]?
  mut gamepad_buttons : Set[@inputs.GamepadButtonInput]?
  mut gamepad_axes : Map[@inputs.GamepadAxisInput, Double]?
  mut close_requested : Bool
  mut stop_loop : (() -> Unit)?
}

///|
#derive(Eq, Debug)
pub(all) struct WebGpuFrameTimingSnapshot {
  service_before_ms : Double
  game_ms : Double
  render_ms : Double
  service_after_ms : Double
  total_work_ms : Double
}

///|
pub extend WebGpuFrameTimingSnapshot with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend WebGpuFrameTimingSnapshot with Eq::{not_equal, equal}

///|
pub fn WebGpuBackend::WebGpuBackend() -> WebGpuBackend {
  {
    canvas: None,
    time_scale: 1.0,
    gamepads: None,
    gamepad_buttons: None,
    gamepad_axes: None,
    close_requested: false,
    stop_loop: None,
  }
}

///|
let canvas_backend : WebGpuBackend = WebGpuBackend()

///|
fn require_canvas() -> BrowserCanvas {
  match canvas_backend.canvas {
    Some(canvas) => canvas
    None => {
      let canvas = find_canvas().to_option().unwrap()
      canvas_backend.canvas = Some(canvas)
      canvas
    }
  }
}

///|
fn default_embedded_asset_lookup(_path : String) -> Bytes? {
  None
}

///|
let embedded_asset_lookup : Ref[(String) -> Bytes?] = Ref(
  default_embedded_asset_lookup,
)

///|
let embedded_asset_cache : Map[String, Bytes] = Map([])

///|
let reported_asset_io_failures : Set[String] = Set([])

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
fn saturating_file_byte(value : Int32) -> Byte {
  if value < 0 {
    Int32::to_byte(0)
  } else if value > 255 {
    Int32::to_byte(255)
  } else {
    value.to_byte()
  }
}

///|
pub fn set_time_scale(time_scale : Double) -> Unit {
  canvas_backend.time_scale = time_scale
}

///|
pub fn set_embedded_assets(
  lookup : (String) -> Bytes?,
  paths~ : Array[String] = [],
) -> Unit {
  embedded_asset_lookup.val = lookup
  embedded_paths.val = paths.copy()
  embedded_asset_urls.clear()
  embedded_asset_cache.clear()
  reported_asset_io_failures.clear()
  reset_audio_runtime()
}

///|
fn report_asset_io_failure(path : String, message : String) -> Unit {
  let key = path + ":" + message
  if reported_asset_io_failures.contains(key) {
    return
  }
  reported_asset_io_failures.add(key)
  println("[selene-webgpu][asset-error] Failed to read \{path}: \{message}")
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
  let error = webgpu_last_file_load_error()
  if error != "" {
    report_asset_io_failure(resolved_path, error)
    return None
  }
  Some(
    Bytes::from_iter(raw.iter().map(fn(value) { saturating_file_byte(value) })),
  )
}

///|
let realtime_delta : Ref[Double] = Ref(0.0)

///|
let last_frame_timing : Ref[WebGpuFrameTimingSnapshot] = Ref({
  service_before_ms: 0.0,
  game_ms: 0.0,
  render_ms: 0.0,
  service_after_ms: 0.0,
  total_work_ms: 0.0,
})

///|
extern "js" fn webgpu_runtime_ready() -> Bool =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   return !!(rt?.ready && rt?.device && rt?.context);
  #| }

///|
extern "js" fn webgpu_now_ms() -> Double = "() => performance.now()"

///|
pub fn webgpu_last_frame_timing() -> WebGpuFrameTimingSnapshot {
  { ..last_frame_timing.val, }
}

///|
pub fn initialize(
  config : @runtime.WindowConfig,
  callbacks : @runtime.RunnerCallbacks,
) -> () -> Unit {
  let startup = callbacks.startup
  let service_frame = callbacks.service_frame
  let render_loop = callbacks.render_loop
  let game_loop = callbacks.game_loop
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  let screen_width = config.screen_width
  let screen_height = config.screen_height
  let max_fps = config.max_fps
  let image_smooth = config.image_smooth
  if max_fps == Some(0U) {
    abort("max_fps must be greater than 0")
  }
  if canvas_backend.stop_loop is Some(stop_loop) {
    stop_loop()
  }
  canvas_backend.stop_loop = None
  canvas_backend.close_requested = false
  let canvas = require_canvas()
  set_viewport_height(canvas, screen_height)
  set_viewport_width(canvas, screen_width)
  webgpu_initialize(
    canvas,
    screen_width,
    screen_height,
    image_smooth,
    webgpu_shader_sources(),
  )
  startup()
  let stop_loop = schedule_frames(max_fps, fn(delta) {
    if canvas_backend.close_requested {
      return
    }
    let delta = delta / 1000.0
    realtime_delta.val = delta
    sync_gamepad_events()
    let frame_start = webgpu_now_ms()
    let service_before_start = frame_start
    service_frame()
    let service_before_end = webgpu_now_ms()
    if !webgpu_runtime_ready() {
      return
    }
    let game_start = service_before_end
    game_loop(delta * canvas_backend.time_scale)
    let game_end = webgpu_now_ms()
    render_loop(delta * canvas_backend.time_scale)
    let render_end = webgpu_now_ms()
    service_frame()
    let service_after_end = webgpu_now_ms()
    last_frame_timing.val = {
      service_before_ms: service_before_end - service_before_start,
      game_ms: game_end - game_start,
      render_ms: render_end - game_end,
      service_after_ms: service_after_end - render_end,
      total_work_ms: service_after_end - frame_start,
    }
  })
  canvas_backend.stop_loop = Some(stop_loop)
  return fn() {  }
}

///|
pub fn get_realtime_delta() -> Double {
  realtime_delta.val
}

///|
priv struct FramePacer {
  interval : Double?
  mut previous_frame : Double?
  mut remainder : Double
}

///|
fn FramePacer::tick(self : FramePacer, time : Double) -> Double? {
  guard self.previous_frame is Some(previous) else {
    self.previous_frame = Some(time)
    return None
  }
  let elapsed = time - previous
  guard self.interval is Some(interval) else {
    self.previous_frame = Some(time)
    return Some(elapsed)
  }
  let accumulated = self.remainder + elapsed
  // RAF timestamps can land just before a deadline due to sub-millisecond jitter.
  let intervals = @math.floor((accumulated + 0.5) / interval)
  guard intervals >= 1.0 else { return None }
  // Carry the pacing phase while reporting only time since the last callback.
  self.remainder = accumulated - intervals * interval
  self.previous_frame = Some(time)
  Some(elapsed)
}

///|
fn schedule_frames(
  max_fps : UInt32?,
  callback : (Double) -> Unit,
) -> () -> Unit {
  let pacer = {
    interval: max_fps.map(fps => 1000.0 / fps.to_double()),
    previous_frame: None,
    remainder: 0.0,
  }
  let lastId = Ref(0.0)
  fn update(time : Double) -> Unit {
    if canvas_backend.close_requested {
      lastId.val = 0.0
      return
    }
    if pacer.tick(time) is Some(elapsed) {
      callback(elapsed)
      if canvas_backend.close_requested {
        lastId.val = 0.0
        return
      }
    }
    lastId.val = window_request_animation_frame(update)
  }

  lastId.val = window_request_animation_frame(update)
  () => if lastId.val != 0.0 { window_cancel_animation_frame(lastId.val) }
}

///|
pub fn request_close() -> Unit {
  reset_audio_runtime()
  canvas_backend.close_requested = true
  if canvas_backend.stop_loop is Some(stop_loop) {
    stop_loop()
  }
  canvas_backend.stop_loop = None
}

///|
pub fn get_time_scale() -> Double {
  canvas_backend.time_scale
}
