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
pub fn capability_warning(feature : String, fallback : String) -> Unit {
  ignore(feature)
  ignore(fallback)
}
