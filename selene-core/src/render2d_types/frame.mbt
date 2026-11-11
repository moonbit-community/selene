///|
#derive(Eq, Debug)
pub(all) enum RenderPassLoadOp2D {
  Load
  Clear
}

///|
pub extend RenderPassLoadOp2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RenderPassLoadOp2D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum RenderPassTarget2D {
  Screen
  Offscreen(String)
}

///|
pub extend RenderPassTarget2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RenderPassTarget2D with Eq::{not_equal, equal}

///|
pub(all) struct RenderPass2D {
  camera_entity_id : UInt32?
  order : Int32
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
pub fn RenderFrame2D::RenderFrame2D() -> RenderFrame2D {
  { passes: [], world_commands: [], ui_commands: [], }
}
