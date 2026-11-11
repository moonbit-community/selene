///|
pub fn App::run(self : App) -> Unit {
  setup_runtime_world(self)
  let plan = build_runtime_plan(self)
  let accumulator : Ref[Double] = { val: 0.0, }
  let screen_width = self.viewport_width * self.zoom
  let screen_height = self.viewport_height * self.zoom

  fn startup() {
    startup_runtime(plan)
  }

  fn service_frame() {
    @platform_audio.tick()
  }

  fn render_loop(_raw_delta : Double) {
    run_render_frame(plan, _raw_delta)
  }

  fn game_loop(raw_delta : Double) {
    run_game_frame(plan, accumulator, raw_delta, None)
  }

  let run_game = @platform_window.initialize(
    {
      viewport_width: self.viewport_width,
      viewport_height: self.viewport_height,
      screen_width,
      screen_height,
      max_fps: self.max_fps,
      image_smooth: self.image_smooth,
    },
    { startup, service_frame, render_loop, game_loop, },
  )
  run_game()
}

///|
pub fn App::run_frames(
  self : App,
  frames : Int32,
  raw_delta~ : Double = DEFAULT_FRAME_DELTA,
  fixed_delta_override~ : Double? = None,
) -> Unit {
  if frames <= 0 {
    return
  }
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  let accumulator : Ref[Double] = { val: 0.0, }
  let used_delta = if raw_delta > 0.0 { raw_delta } else { DEFAULT_FRAME_DELTA }
  for _ in 0..<frames {
    run_headless_frame(
      plan,
      accumulator,
      used_delta,
      None,
      @platform_audio.tick,
    )
  }
}

///|
fn resolved_capture_dimension(
  override_value : Int32,
  fallback : Double,
) -> Int32 {
  if override_value > 0 {
    return override_value
  }
  let candidate = fallback.to_int()
  if candidate > 0 {
    candidate
  } else {
    1
  }
}

///|
fn App::run_frames_capture_with(
  self : App,
  frames : Int32,
  raw_delta : Double,
  fixed_delta_override : Double?,
  capture_frame_indexes : Array[Int32]?,
  capture_frame : (Int32) -> @runtime_debug.FrameCaptureArtifact?,
) -> Array[@runtime_debug.FrameCaptureArtifact] {
  let captures : Array[@runtime_debug.FrameCaptureArtifact] = []
  if frames <= 0 {
    return captures
  }
  let selected_frames = match capture_frame_indexes {
    Some(indexes) => {
      let selected = indexes.copy()
      selected.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
      Some(selected)
    }
    None => None
  }
  let mut next_selected_frame = 0
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  let accumulator : Ref[Double] = { val: 0.0, }
  let used_delta = if raw_delta > 0.0 { raw_delta } else { DEFAULT_FRAME_DELTA }
  for frame_index in 0..<frames {
    run_headless_frame(
      plan,
      accumulator,
      used_delta,
      None,
      @platform_audio.tick,
    )
    let should_capture = match selected_frames {
      None => true
      Some(indexes) => {
        while next_selected_frame < indexes.length() &&
              indexes[next_selected_frame] < frame_index {
          next_selected_frame += 1
        }
        if next_selected_frame < indexes.length() &&
          indexes[next_selected_frame] == frame_index {
          while next_selected_frame < indexes.length() &&
                indexes[next_selected_frame] == frame_index {
            next_selected_frame += 1
          }
          true
        } else {
          false
        }
      }
    }
    if !should_capture {
      continue
    }
    if capture_frame(frame_index) is Some(capture) {
      captures.push(capture)
    }
  }
  captures
}

///|
pub fn App::run_frames_capture(
  self : App,
  frames : Int32,
  capture_width~ : Int32 = 0,
  capture_height~ : Int32 = 0,
  raw_delta~ : Double = DEFAULT_FRAME_DELTA,
  fixed_delta_override~ : Double? = None,
  metadata_indent~ : Int32 = 2,
  capture_frame_indexes~ : Array[Int32]? = None,
) -> Array[@runtime_debug.FrameCaptureArtifact] {
  let resolved_width = resolved_capture_dimension(
    capture_width,
    self.viewport_width * self.zoom,
  )
  let resolved_height = resolved_capture_dimension(
    capture_height,
    self.viewport_height * self.zoom,
  )
  self.run_frames_capture_with(
    frames,
    raw_delta,
    fixed_delta_override,
    capture_frame_indexes,
    fn(_frame_index) {
      @runtime_debug.capture_last_frame_with_metadata(
        resolved_width,
        resolved_height,
        indent=metadata_indent,
      )
    },
  )
}

///|
pub fn App::step_fixed(
  self : App,
  steps : Int32,
  fixed_delta_override~ : Double? = None,
) -> Unit {
  if steps <= 0 {
    return
  }
  setup_runtime_world(self)
  let plan = build_runtime_plan(self, fixed_delta_override~)
  startup_runtime(plan)
  for _ in 0..<steps {
    run_fixed_step_once(plan)
  }
}
