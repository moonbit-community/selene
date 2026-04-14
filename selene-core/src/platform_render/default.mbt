///|
pub fn submit_frame(frame : @render_pipeline.RenderFrame) -> Unit {
  ignore(frame)
}

///|
pub fn register_font(family : String, path : String) -> Unit {
  ignore(family)
  ignore(path)
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @math.Vec2D {
  ignore(style.font)
  ignore(style.family)
  let width = text.length().to_double() * style.size * 0.6
  let height = style.size
  @math.Vec2D(width, height)
}

///|
pub fn push_clip_rect(_rect : @math.Rect) -> Unit {
  ()
}

///|
pub fn pop_clip_rect() -> Unit {
  ()
}

///|
pub fn reset_clip_stack() -> Unit {
  ()
}

///|
pub fn capability_warning(feature : String, fallback : String) -> Unit {
  ignore(feature)
  ignore(fallback)
}

///|
pub fn capture_frame_png() -> Bytes? {
  None
}

///|
pub fn capture_frame_png_to_file(path : String) -> Bool {
  ignore(path)
  false
}

///|
pub fn render_offscreen_png(
  frame : @render_pipeline.RenderFrame,
  width : Int,
  height : Int,
) -> Bytes? {
  ignore(frame)
  ignore(width)
  ignore(height)
  None
}

///|
pub fn image_region_is_fully_transparent(
  path : String,
  rect : @math.Rect,
) -> Bool? {
  ignore(path)
  ignore(rect)
  None
}
