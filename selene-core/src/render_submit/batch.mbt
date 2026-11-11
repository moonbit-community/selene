///|
fn alpha_mode_batch_key(alpha_mode : @render.AlphaMode2D) -> String {
  match alpha_mode {
    Opaque => "opaque"
    Blend => "blend"
  }
}

///|
fn blend_mode_batch_key(blend_mode : @render.BlendMode2D) -> String {
  match blend_mode {
    Alpha => "alpha"
    Additive => "additive"
    Multiply => "multiply"
  }
}

///|
fn draw_command_batch_key(command : @render2d_types.DrawCommand2D) -> String? {
  match command {
    Image(command) =>
      Some(
        "image:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    Text(command) => Some("text:\{blend_mode_batch_key(command.blend_mode)}")
    Rect(command) =>
      Some(
        "rect:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    Circle(command) =>
      Some(
        "circle:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    GradientRect(command) =>
      Some(
        "gradient_rect:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    PushClip(_) => None
    PopClip => None
  }
}

///|
fn build_draw_batches(
  commands : Array[@render2d_types.DrawCommand2D],
) -> Array[Array[@render2d_types.DrawCommand2D]] {
  let batches : Array[Array[@render2d_types.DrawCommand2D]] = []
  let mut current_key : String? = None
  for command in commands {
    match draw_command_batch_key(command) {
      Some(key) =>
        if current_key == Some(key) && !batches.is_empty() {
          batches[batches.length() - 1].push(command)
        } else {
          batches.push([command])
          current_key = Some(key)
        }
      None => {
        // Clip commands are explicit batch barriers.
        batches.push([command])
        current_key = None
      }
    }
  }
  batches
}
