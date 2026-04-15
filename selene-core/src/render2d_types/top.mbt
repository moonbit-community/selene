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
  transform : @math.Transform
  uv_transform : @math.Transform
  repeat : @math.RepeatMode
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
  align : @math.HAlign
  baseline : @math.VAlign
}

///|
pub(all) struct TextDrawCommand2D {
  text : String
  position : @math.Vec2
  transform : @math.Transform
  blend_mode : @render.BlendMode2D
  style : TextStyle2D
}

///|
pub(all) struct RectDrawCommand2D {
  rect : @math.Rect
  transform : @math.Transform
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct CircleDrawCommand2D {
  center : @math.Vec2
  radius : Double
  transform : @math.Transform
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
  fill_color : @render.Color
  stroke_color : @render.Color?
}

///|
pub(all) struct GradientRectDrawCommand2D {
  rect : @math.Rect
  transform : @math.Transform
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

///|
pub(all) enum RenderPassLoadOp2D {
  Load
  Clear
} derive(Eq, Debug)

///|
pub(all) enum RenderPassTarget2D {
  Screen
  Offscreen(String)
} derive(Eq, Debug)

///|
pub(all) struct RenderPass2D {
  camera_entity_id : UInt?
  order : Int
  viewport : @math.Rect
  load_op : RenderPassLoadOp2D
  clear_color : @render.Color
  target : RenderPassTarget2D
  mut world_commands : Array[DrawCommand2D]
  mut ui_commands : Array[DrawCommand2D]
  mut world_batches : Array[Array[DrawCommand2D]]
  mut ui_batches : Array[Array[DrawCommand2D]]
}

///|
pub(all) struct RenderFrame2D {
  mut passes : Array[RenderPass2D]
  mut world_commands : Array[DrawCommand2D]
  mut ui_commands : Array[DrawCommand2D]
}

///|
pub fn empty_render_frame2d() -> RenderFrame2D {
  { passes: [], world_commands: [], ui_commands: [] }
}
