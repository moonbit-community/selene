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
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
) -> Unit {
  @render2d.push_ui_circle({
    center,
    radius,
    transform: @math.Transform::identity(),
    alpha_mode: alpha_mode(color),
    blend_mode: Alpha,
    fill_color: color,
    stroke_color: None,
  })
}

///|
fn push_label(
  text : String,
  center : @math.Vec2,
  color : @render.Color,
  size? : Double = 18.0,
) -> Unit {
  if text == "" {
    return
  }
  @render2d.push_ui_text({
    text,
    position: center,
    transform: @math.Transform::identity(),
    blend_mode: Alpha,
    style: {
      font: None,
      family: "sans-serif",
      size,
      color,
      align: Center,
      baseline: Center,
    },
  })
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
  runtime : TouchControlsWorldStore,
  screen : @math.Vec2,
) -> Unit {
  for _, stick in runtime.sticks {
    let stick_state = stick_runtime_for(runtime, stick)
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
    push_circle(stick_state.center, stick.radius, base_color)
    push_circle(
      stick_knob_center(stick, stick_state),
      stick.radius * 0.42,
      stick.style.knob_color,
    )
  }
}

///|
fn render_buttons(
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
    push_circle(center, button.radius, fill)
    push_label(button.label, center, button.style.label_color)
  }
}

///|
pub fn touch_controls_render_system(_delta : Double) -> Unit {
  let runtime = store()
  if !runtime.visible {
    return
  }
  let screen = @system.get_screen_size()
  render_sticks(runtime, screen)
  render_buttons(runtime, screen)
}
