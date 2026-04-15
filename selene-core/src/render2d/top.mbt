///|
priv struct OrderedDrawCommand2D {
  depth : Double
  order : Int
  camera_entity_id : UInt?
  entity_id : UInt?
  command : @render2d_types.DrawCommand2D
}

///|
pub(all) struct DrawCommandWithDepth2D {
  depth : Double
  order : Int
  camera_entity_id : UInt?
  entity_id : UInt?
  command : @render2d_types.DrawCommand2D
}

///|
priv struct RenderFrameState2D {
  screen_world_commands : Array[OrderedDrawCommand2D]
  screen_ui_commands : Array[@render2d_types.DrawCommand2D]
  camera_world_commands : Map[UInt, Array[OrderedDrawCommand2D]]
  camera_ui_commands : Map[UInt, Array[@render2d_types.DrawCommand2D]]
  mut next_order : Int
  mut current_ui_camera_entity_id : UInt?
}

///|
let frame2d_by_world : Map[UInt, RenderFrameState2D] = Map::new()

///|
fn frame2d() -> RenderFrameState2D {
  let world_id = @ecs.require_current_world().id()
  frame2d_by_world.get_or_init(world_id, fn() {
    {
      screen_world_commands: [],
      screen_ui_commands: [],
      camera_world_commands: Map::new(),
      camera_ui_commands: Map::new(),
      next_order: 0,
      current_ui_camera_entity_id: None,
    }
  })
}

///|
pub fn begin_frame2d_system(_delta : Double) -> Unit {
  frame2d_by_world.set(@ecs.require_current_world().id(), {
    screen_world_commands: [],
    screen_ui_commands: [],
    camera_world_commands: Map::new(),
    camera_ui_commands: Map::new(),
    next_order: 0,
    current_ui_camera_entity_id: None,
  })
}

///|
fn world_command_bucket(
  state : RenderFrameState2D,
  camera_entity_id : UInt?,
) -> Array[OrderedDrawCommand2D] {
  match camera_entity_id {
    Some(camera_entity_id) =>
      state.camera_world_commands.get_or_init(camera_entity_id, fn() { [] })
    None => state.screen_world_commands
  }
}

///|
fn ui_command_bucket(
  state : RenderFrameState2D,
  camera_entity_id : UInt?,
) -> Array[@render2d_types.DrawCommand2D] {
  match camera_entity_id {
    Some(camera_entity_id) =>
      state.camera_ui_commands.get_or_init(camera_entity_id, fn() { [] })
    None => state.screen_ui_commands
  }
}

///|
fn push_world_command(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.DrawCommand2D,
  camera_entity_id? : UInt? = None,
) -> Unit {
  let frame = frame2d()
  world_command_bucket(frame, camera_entity_id).push({
    depth,
    order: frame.next_order,
    camera_entity_id,
    entity_id,
    command,
  })
  frame.next_order += 1
}

///|
fn sorted_world_commands(
  commands : Array[OrderedDrawCommand2D],
) -> Array[OrderedDrawCommand2D] {
  let world_commands = commands.copy()
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
  world_commands
}

///|
fn sorted_camera_entity_ids() -> Array[UInt] {
  let unique : Map[UInt, Unit] = Map::new()
  for id in frame2d().camera_world_commands.keys() {
    unique.set(id, ())
  }
  for id in frame2d().camera_ui_commands.keys() {
    unique.set(id, ())
  }
  let sorted = unique.keys().to_array()
  sorted.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
  sorted
}

///|
pub fn push_image_with_depth(
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
) -> Unit {
  push_world_command(depth, None, Image(command))
}

///|
pub fn push_image_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.ImageDrawCommand2D,
) -> Unit {
  push_world_command(depth, entity_id, Image(command))
}

///|
pub fn push_image_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
  entity_id? : UInt? = None,
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Image(command),
    camera_entity_id=Some(camera_entity_id),
  )
}

///|
pub fn push_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_image_with_depth(0.0, command)
}

///|
pub fn push_ui_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    Image(command),
  )
}

///|
pub fn push_text_with_depth(
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
) -> Unit {
  push_world_command(depth, None, Text(command))
}

///|
pub fn push_text_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.TextDrawCommand2D,
) -> Unit {
  push_world_command(depth, entity_id, Text(command))
}

///|
pub fn push_text_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
  entity_id? : UInt? = None,
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Text(command),
    camera_entity_id=Some(camera_entity_id),
  )
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_text_with_depth(0.0, command)
}

///|
pub fn push_ui_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    Text(command),
  )
}

///|
pub fn push_rect_with_depth(
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
) -> Unit {
  push_world_command(depth, None, Rect(command))
}

///|
pub fn push_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.RectDrawCommand2D,
) -> Unit {
  push_world_command(depth, entity_id, Rect(command))
}

///|
pub fn push_rect_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
  entity_id? : UInt? = None,
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Rect(command),
    camera_entity_id=Some(camera_entity_id),
  )
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    Rect(command),
  )
}

///|
pub fn push_circle_with_depth(
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
) -> Unit {
  push_world_command(depth, None, Circle(command))
}

///|
pub fn push_circle_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.CircleDrawCommand2D,
) -> Unit {
  push_world_command(depth, entity_id, Circle(command))
}

///|
pub fn push_circle_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
  entity_id? : UInt? = None,
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Circle(command),
    camera_entity_id=Some(camera_entity_id),
  )
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_circle_with_depth(0.0, command)
}

///|
pub fn push_ui_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    Circle(command),
  )
}

///|
pub fn push_gradient_rect_with_depth(
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_world_command(depth, None, GradientRect(command))
}

///|
pub fn push_gradient_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_world_command(depth, entity_id, GradientRect(command))
}

///|
pub fn push_gradient_rect_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
  entity_id? : UInt? = None,
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    GradientRect(command),
    camera_entity_id=Some(camera_entity_id),
  )
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
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    GradientRect(command),
  )
}

///|
pub fn push_ui_clip(rect : @math.Rect) -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    PushClip({ rect, }),
  )
}

///|
pub fn pop_ui_clip() -> Unit {
  ui_command_bucket(frame2d(), frame2d().current_ui_camera_entity_id).push(
    PopClip,
  )
}

///|
pub fn set_ui_camera_target(camera_entity_id : UInt?) -> Unit {
  frame2d().current_ui_camera_entity_id = camera_entity_id
}

///|
pub fn get_screen_world_commands_with_depth() -> Array[DrawCommandWithDepth2D] {
  sorted_world_commands(frame2d().screen_world_commands).map(fn(command) {
    {
      depth: command.depth,
      order: command.order,
      camera_entity_id: command.camera_entity_id,
      entity_id: command.entity_id,
      command: command.command,
    }
  })
}

///|
pub fn get_camera_world_commands_with_depth(
  camera_entity_id : UInt,
) -> Array[DrawCommandWithDepth2D] {
  let commands = frame2d().camera_world_commands
    .get(camera_entity_id)
    .unwrap_or([])
  sorted_world_commands(commands).map(fn(command) {
    {
      depth: command.depth,
      order: command.order,
      camera_entity_id: command.camera_entity_id,
      entity_id: command.entity_id,
      command: command.command,
    }
  })
}

///|
pub fn get_world_commands_with_depth() -> Array[DrawCommandWithDepth2D] {
  let commands = get_screen_world_commands_with_depth()
  for camera_entity_id in sorted_camera_entity_ids() {
    for command in get_camera_world_commands_with_depth(camera_entity_id) {
      commands.push(command)
    }
  }
  commands
}

///|
pub fn get_screen_ui_commands() -> Array[@render2d_types.DrawCommand2D] {
  frame2d().screen_ui_commands.copy()
}

///|
pub fn get_camera_ui_commands(
  camera_entity_id : UInt,
) -> Array[@render2d_types.DrawCommand2D] {
  frame2d().camera_ui_commands.get(camera_entity_id).unwrap_or([]).copy()
}

///|
pub fn get_ui_commands() -> Array[@render2d_types.DrawCommand2D] {
  let commands = get_screen_ui_commands()
  for camera_entity_id in sorted_camera_entity_ids() {
    for command in get_camera_ui_commands(camera_entity_id) {
      commands.push(command)
    }
  }
  commands
}

///|
pub fn get_frame2d() -> @render2d_types.RenderFrame2D {
  {
    passes: [],
    world_commands: get_world_commands_with_depth().map(fn(command) {
      command.command
    }),
    ui_commands: get_ui_commands(),
  }
}
