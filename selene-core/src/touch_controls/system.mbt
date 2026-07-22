///|
fn stick_runtime_for(
  runtime : TouchControlsWorldStore,
  stick : VirtualStick,
) -> StickRuntime {
  runtime.stick_runtimes.get_or_init(stick.id, fn() {
    {
      touch_id: None,
      center: resolved_placement(
        stick.placement,
        @system.get_screen_size(),
        stick.radius,
      ),
      value: @math.Vec2::zero(),
    }
  })
}

///|
fn button_runtime_for(
  runtime : TouchControlsWorldStore,
  button : VirtualButtonControl,
) -> ButtonRuntime {
  runtime.button_runtimes.get_or_init(button.id, fn() {
    { touch_id: None, pressed: false }
  })
}

///|
fn release_outputs(runtime : TouchControlsWorldStore) -> Unit {
  for _, stick in runtime.sticks {
    @inputs.set_virtual_axis_value(stick.axis_x, 0.0)
    @inputs.set_virtual_axis_value(stick.axis_y, 0.0)
  }
  for _, button in runtime.buttons {
    @inputs.set_virtual_button_pressed(button.button, false)
  }
}

///|
fn reset_runtime_values(runtime : TouchControlsWorldStore) -> Unit {
  for _, stick_state in runtime.stick_runtimes {
    stick_state.touch_id = None
    stick_state.value = @math.Vec2::zero()
  }
  for _, button_state in runtime.button_runtimes {
    button_state.touch_id = None
    button_state.pressed = false
  }
  release_outputs(runtime)
}

///|
fn touch_ended_this_frame(id : @inputs.TouchId) -> Bool {
  for event in @inputs.touch_changes_this_frame() {
    if event.id == id && (event.phase == Ended || event.phase == Cancelled) {
      return true
    }
  }
  false
}

///|
fn update_stick_value(
  stick : VirtualStick,
  stick_state : StickRuntime,
  touch_position : @math.Vec2,
) -> Unit {
  let delta = clamp_vec2_length(
    touch_position - stick_state.center,
    stick.radius,
  )
  if delta.distance() <= stick.dead_zone {
    stick_state.value = @math.Vec2::zero()
  } else {
    stick_state.value = Vec2(
      clamp(delta[X] / stick.radius, -1.0, 1.0),
      clamp(delta[Y] / stick.radius, -1.0, 1.0),
    )
  }
  @inputs.set_virtual_axis_value(stick.axis_x, stick_state.value[X])
  @inputs.set_virtual_axis_value(stick.axis_y, stick_state.value[Y])
}

///|
fn process_existing_captures(runtime : TouchControlsWorldStore) -> Unit {
  for _, stick in runtime.sticks {
    let stick_state = stick_runtime_for(runtime, stick)
    match stick_state.touch_id {
      Some(id) =>
        if touch_ended_this_frame(id) {
          @ui.consume_touch(id)
          stick_state.touch_id = None
          stick_state.value = @math.Vec2::zero()
          @inputs.set_virtual_axis_value(stick.axis_x, 0.0)
          @inputs.set_virtual_axis_value(stick.axis_y, 0.0)
        } else if @inputs.touch_point(id) is Some(touch) {
          @ui.consume_touch(id)
          update_stick_value(stick, stick_state, touch.position)
        } else {
          stick_state.touch_id = None
          stick_state.value = @math.Vec2::zero()
          @inputs.set_virtual_axis_value(stick.axis_x, 0.0)
          @inputs.set_virtual_axis_value(stick.axis_y, 0.0)
        }
      None => ()
    }
  }
  for _, button in runtime.buttons {
    let button_state = button_runtime_for(runtime, button)
    match button_state.touch_id {
      Some(id) =>
        if touch_ended_this_frame(id) {
          @ui.consume_touch(id)
          button_state.touch_id = None
          button_state.pressed = false
          @inputs.set_virtual_button_pressed(button.button, false)
        } else if @inputs.touch_point(id) is Some(_) {
          @ui.consume_touch(id)
          button_state.pressed = true
          @inputs.set_virtual_button_pressed(button.button, true)
        } else {
          button_state.touch_id = None
          button_state.pressed = false
          @inputs.set_virtual_button_pressed(button.button, false)
        }
      None => ()
    }
  }
}

///|
fn capture_button_start(
  runtime : TouchControlsWorldStore,
  event : @inputs.TouchEvent,
  screen : @math.Vec2,
) -> Bool {
  for _, button in runtime.buttons {
    let button_state = button_runtime_for(runtime, button)
    if button_state.touch_id is Some(_) {
      continue
    }
    let center = resolved_placement(button.placement, screen, button.radius)
    if point_in_circle(event.position, center, hit_radius(button.radius)) {
      button_state.touch_id = Some(event.id)
      button_state.pressed = true
      @ui.consume_touch(event.id)
      @inputs.set_virtual_button_pressed(button.button, true)
      return true
    }
  }
  false
}

///|
fn capture_stick_start(
  runtime : TouchControlsWorldStore,
  event : @inputs.TouchEvent,
  screen : @math.Vec2,
) -> Bool {
  for _, stick in runtime.sticks {
    let stick_state = stick_runtime_for(runtime, stick)
    if stick_state.touch_id is Some(_) {
      continue
    }
    let placement_center = resolved_placement(
      stick.placement,
      screen,
      stick.radius,
    )
    let in_zone = match stick.mode {
      Fixed =>
        point_in_circle(
          event.position,
          placement_center,
          hit_radius(stick.radius),
        )
      Floating =>
        point_in_circle(
          event.position,
          placement_center,
          hit_radius(stick.radius) * 1.9,
        )
    }
    if in_zone {
      stick_state.touch_id = Some(event.id)
      stick_state.center = match stick.mode {
        Fixed => placement_center
        Floating => event.position
      }
      @ui.consume_touch(event.id)
      update_stick_value(stick, stick_state, event.position)
      return true
    }
  }
  false
}

///|
fn capture_new_starts(runtime : TouchControlsWorldStore) -> Unit {
  let screen = @system.get_screen_size()
  for event in @ui.unconsumed_touch_changes_this_frame() {
    if event.phase != Started {
      continue
    }
    if capture_button_start(runtime, event, screen) {
      continue
    }
    ignore(capture_stick_start(runtime, event, screen))
  }
}

///|
pub fn touch_controls_system(_delta : Double) -> Unit {
  let runtime = store()
  if !runtime.enabled {
    reset_runtime_values(runtime)
    return
  }
  process_existing_captures(runtime)
  capture_new_starts(runtime)
}
