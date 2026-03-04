///|
pub(all) struct ImageRegion2D {
  position : @math.Vec2D
  size : @math.Vec2D
}

///|
pub(all) struct ImageDrawCommand2D {
  image : @asset_types.ImageHandle
  destination : @math.Rect
  source : ImageRegion2D?
  transform : @math.Transform
  repeat : @math.RepeatMode
  color : @render.Color
}

///|
pub(all) struct TextStyle2D {
  font : @asset_types.FontHandle?
  family : String
  size : Double
  color : @render.Color
  align : @math.HAlign
  baseline : @math.VAlign
}

///|
pub(all) struct TextDrawCommand2D {
  text : String
  position : @math.Vec2D
  style : TextStyle2D
}

///|
pub(all) struct RectDrawCommand2D {
  rect : @math.Rect
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct CircleDrawCommand2D {
  center : @math.Vec2D
  radius : Double
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct GradientRectDrawCommand2D {
  rect : @math.Rect
  color_start : @render.Color
  color_end : @render.Color
}

///|
pub(all) enum DrawCommand2D {
  Image(ImageDrawCommand2D)
  Text(TextDrawCommand2D)
  Rect(RectDrawCommand2D)
  Circle(CircleDrawCommand2D)
  GradientRect(GradientRectDrawCommand2D)
}

///|
pub(all) struct RenderFrame2D {
  mut commands : Array[DrawCommand2D]
}

///|
pub fn empty_render_frame2d() -> RenderFrame2D {
  { commands: [] }
}
