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
pub fn push_ui_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  frame2d.val.ui_commands.push(Image(command))
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Text(command))
}

///|
pub fn push_ui_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  frame2d.val.ui_commands.push(Text(command))
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Rect(command))
}

///|
pub fn push_ui_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  frame2d.val.ui_commands.push(Rect(command))
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  frame2d.val.world_commands.push(Circle(command))
}

///|
pub fn push_ui_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  frame2d.val.ui_commands.push(Circle(command))
}

///|
pub fn push_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  frame2d.val.world_commands.push(GradientRect(command))
}

///|
pub fn push_ui_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  frame2d.val.ui_commands.push(GradientRect(command))
}

///|
pub fn push_ui_clip(rect : @math.Rect) -> Unit {
  frame2d.val.ui_commands.push(PushClip({ rect, }))
}

///|
pub fn pop_ui_clip() -> Unit {
  frame2d.val.ui_commands.push(PopClip)
}

///|
pub fn get_frame2d() -> @render2d_types.RenderFrame2D {
  frame2d.val
}
