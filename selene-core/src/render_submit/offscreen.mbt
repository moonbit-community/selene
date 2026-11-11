///|
fn offscreen_local_viewport(viewport : @math.Rect) -> @math.Rect {
  { position: @math.Vec2::zero(), size: viewport.size, }
}

///|
fn offset_rect(rect : @math.Rect, offset : @math.Vec2) -> @math.Rect {
  { position: rect.position - offset, size: rect.size, }
}

///|
fn normalize_draw_command_for_offscreen(
  command : @render2d_types.DrawCommand2D,
  offset : @math.Vec2,
) -> @render2d_types.DrawCommand2D {
  match command {
    Image(image) =>
      Image({ ..image, destination: offset_rect(image.destination, offset), })
    Text(text) => Text({ ..text, position: text.position - offset, })
    Rect(rect) => Rect({ ..rect, rect: offset_rect(rect.rect, offset), })
    Circle(circle) => Circle({ ..circle, center: circle.center - offset, })
    GradientRect(command) =>
      GradientRect({ ..command, rect: offset_rect(command.rect, offset), })
    PushClip(clip) => PushClip({ rect: offset_rect(clip.rect, offset), })
    PopClip => PopClip
  }
}

///|
fn normalize_draw_commands_for_target(
  commands : Array[@render2d_types.DrawCommand2D],
  target : @render2d_types.RenderPassTarget2D,
  viewport : @math.Rect,
) -> Array[@render2d_types.DrawCommand2D] {
  match target {
    Screen => commands
    Offscreen(_) =>
      commands.map(fn(command) {
        normalize_draw_command_for_offscreen(command, viewport.position)
      })
  }
}

///|
fn normalize_draw_command_for_target(
  command : @render2d_types.DrawCommand2D,
  target : @render2d_types.RenderPassTarget2D,
  viewport : @math.Rect,
) -> @render2d_types.DrawCommand2D {
  normalize_draw_commands_for_target([command], target, viewport)[0]
}
