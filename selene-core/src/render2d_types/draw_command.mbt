///|
pub(all) struct ImageRegion2D {
  position : @math.Vec2
  size : @math.Vec2
}

///|
pub(all) struct ImageDrawCommand2D {
  image : @asset_types.ImageHandle
  destination : @math.Rect
  source : ImageRegion2D?
  transform : @math.Affine2
  uv_transform : @math.Affine2
  repeat : RepeatMode
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  color : @render.Color
}

///|
pub(all) struct TextStyle2D {
  font : @asset_types.FontHandle?
  family : String
  size : Double
  color : @render.Color
  align : HAlign
  baseline : VAlign
}

///|
pub(all) struct TextDrawCommand2D {
  text : String
  position : @math.Vec2
  transform : @math.Affine2
  blend_mode : @render.BlendMode2D
  style : TextStyle2D
}

///|
pub(all) struct RectDrawCommand2D {
  rect : @math.Rect
  transform : @math.Affine2
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct CircleDrawCommand2D {
  center : @math.Vec2
  radius : Double
  transform : @math.Affine2
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct GradientRectDrawCommand2D {
  rect : @math.Rect
  transform : @math.Affine2
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  color_start : @render.Color
  color_end : @render.Color
}

///|
pub(all) struct ClipRectCommand2D {
  rect : @math.Rect
}

///|
pub(all) enum DrawCommand2D {
  Image(ImageDrawCommand2D)
  Text(TextDrawCommand2D)
  Rect(RectDrawCommand2D)
  Circle(CircleDrawCommand2D)
  GradientRect(GradientRectDrawCommand2D)
  PushClip(ClipRectCommand2D)
  PopClip
}
