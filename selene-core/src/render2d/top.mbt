///|
let frame2d : Ref[@render2d_types.RenderFrame2D] = Ref::new(
  @render2d_types.empty_render_frame2d(),
)

///|
pub fn begin_frame2d_system(_delta : Double) -> Unit {
  frame2d.val = @render2d_types.empty_render_frame2d()
}

///|
pub fn push_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Image(command))
}

///|
pub fn push_overlay_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  frame2d.val.overlay_commands.push(Image(command))
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Text(command))
}

///|
pub fn push_overlay_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  frame2d.val.overlay_commands.push(Text(command))
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Rect(command))
}

///|
pub fn push_overlay_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  frame2d.val.overlay_commands.push(Rect(command))
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Circle(command))
}

///|
pub fn push_overlay_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  frame2d.val.overlay_commands.push(Circle(command))
}

///|
pub fn push_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  frame2d.val.world_commands.push(GradientRect(command))
}

///|
pub fn push_overlay_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  frame2d.val.overlay_commands.push(GradientRect(command))
}

///|
pub fn get_frame2d() -> @render2d_types.RenderFrame2D {
  frame2d.val
}
