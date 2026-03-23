///|
priv struct OrderedDrawCommand2D {
  depth : Double
  order : Int
  command : @render2d_types.DrawCommand2D
}

///|
priv struct RenderFrameState2D {
  world_commands : Array[OrderedDrawCommand2D]
  ui_commands : Array[@render2d_types.DrawCommand2D]
  mut next_order : Int
}

///|
let frame2d_by_world : Map[UInt, RenderFrameState2D] = Map::new()

///|
fn frame2d() -> RenderFrameState2D {
  let world_id = @ecs.require_current_world().id()
  frame2d_by_world.get_or_init(world_id, fn() {
    { world_commands: [], ui_commands: [], next_order: 0 }
  })
}

///|
pub fn begin_frame2d_system(_delta : Double) -> Unit {
  frame2d_by_world.set(@ecs.require_current_world().id(), {
    world_commands: [],
    ui_commands: [],
    next_order: 0,
  })
}

///|
fn push_world_command(
  depth : Double,
  command : @render2d_types.DrawCommand2D,
) -> Unit {
  let frame = frame2d()
  frame.world_commands.push({ depth, order: frame.next_order, command })
  frame.next_order += 1
}

///|
pub fn push_image_with_depth(
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
) -> Unit {
  push_world_command(depth, Image(command))
}

///|
pub fn push_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_image_with_depth(0.0, command)
}

///|
pub fn push_ui_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  frame2d().ui_commands.push(Image(command))
}

///|
pub fn push_text_with_depth(
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
) -> Unit {
  push_world_command(depth, Text(command))
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_text_with_depth(0.0, command)
}

///|
pub fn push_ui_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  frame2d().ui_commands.push(Text(command))
}

///|
pub fn push_rect_with_depth(
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
) -> Unit {
  push_world_command(depth, Rect(command))
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  frame2d().ui_commands.push(Rect(command))
}

///|
pub fn push_circle_with_depth(
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
) -> Unit {
  push_world_command(depth, Circle(command))
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_circle_with_depth(0.0, command)
}

///|
pub fn push_ui_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  frame2d().ui_commands.push(Circle(command))
}

///|
pub fn push_gradient_rect_with_depth(
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_world_command(depth, GradientRect(command))
}

///|
pub fn push_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_gradient_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  frame2d().ui_commands.push(GradientRect(command))
}

///|
pub fn push_ui_clip(rect : @math.Rect) -> Unit {
  frame2d().ui_commands.push(PushClip({ rect, }))
}

///|
pub fn pop_ui_clip() -> Unit {
  frame2d().ui_commands.push(PopClip)
}

///|
pub fn get_frame2d() -> @render2d_types.RenderFrame2D {
  let state = frame2d()
  let world_commands = state.world_commands.copy()
  world_commands.sort_by(fn(lhs, rhs) {
    if lhs.depth < rhs.depth {
      -1
    } else if lhs.depth > rhs.depth {
      1
    } else if lhs.order < rhs.order {
      -1
    } else if lhs.order > rhs.order {
      1
    } else {
      0
    }
  })
  {
    world_commands: world_commands.map(fn(command) { command.command }),
    ui_commands: state.ui_commands.copy(),
  }
}
