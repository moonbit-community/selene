///|
fn alpha_mode(color : @render.Color) -> @render.AlphaMode2D {
  if color.a >= 0.999999 {
    Opaque
  } else {
    Blend
  }
}

///|
fn push_circle(
  frame : @render2d.Frame2D,
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
) -> Unit {
  frame.push_ui(
    Circle({
      center,
      radius,
      transform: @math.Affine2::identity(),
      alpha_mode: alpha_mode(color),
      blend_mode: Alpha,
      fill_color: color,
      stroke_color: None,
    }),
  )
}

///|
fn push_label(
  frame : @render2d.Frame2D,
  text : String,
  center : @math.Vec2,
  color : @render.Color,
  size~ : Double = 18.0,
) -> Unit {
  if text == "" {
    return
  }
  frame.push_ui(
    Text({
      text,
      position: center,
      transform: @math.Affine2::identity(),
      blend_mode: Alpha,
      style: {
        font: None,
        family: "sans-serif",
        size,
        color,
        align: Center,
        baseline: Center,
      },
    }),
  )
}

///|
fn stick_knob_center(
  stick : VirtualStick,
  stick_state : StickRuntime,
) -> @math.Vec2 {
  stick_state.center + stick_state.value.scalar_mul(stick.radius)
}

///|
fn render_sticks(
  frame : @render2d.Frame2D,
  runtime : TouchControlsWorldStore,
  screen : @math.Vec2,
) -> Unit {
  for _, stick in runtime.sticks {
    let stick_state = stick_runtime_for(runtime, stick, screen)
    if stick_state.touch_id is None {
      stick_state.center = resolved_placement(
        stick.placement,
        screen,
        stick.radius,
      )
    }
    let active = stick_state.touch_id is Some(_)
    let base_color = if active {
      stick.style.active_color
    } else {
      stick.style.base_color
    }
    push_circle(frame, stick_state.center, stick.radius, base_color)
    push_circle(
      frame,
      stick_knob_center(stick, stick_state),
      stick.radius * 0.42,
      stick.style.knob_color,
    )
  }
}

///|
fn render_buttons(
  frame : @render2d.Frame2D,
  runtime : TouchControlsWorldStore,
  screen : @math.Vec2,
) -> Unit {
  for _, button in runtime.buttons {
    let button_state = button_runtime_for(runtime, button)
    let center = resolved_placement(button.placement, screen, button.radius)
    let fill = if button_state.pressed {
      button.style.active_color
    } else {
      button.style.base_color
    }
    push_circle(frame, center, button.radius, fill)
    push_label(frame, button.label, center, button.style.label_color)
  }
}

///|
pub fn touch_controls_render_system(
  controls : TouchControls,
  frame : @render2d.Frame2D,
  display : @window.Display,
) -> Unit {
  let runtime = controls.state
  if !runtime.visible {
    return
  }
  let screen = display.screen_size()
  render_sticks(frame, runtime, screen)
  render_buttons(frame, runtime, screen)
}
