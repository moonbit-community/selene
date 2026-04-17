///|
priv struct OrderedDrawCommand2D {
  depth : Double
  order : Int
  camera_entity_id : UInt?
  entity_id : UInt?
  sorting_layer : Int
  sorting_group : Int
  sorting_order : Int
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
pub(all) enum SortMode2D {
  Depth
  Y
} derive(Eq, Debug)

///|
pub(all) struct Sorting2d {
  layer : Int
  group : Int
  order : Int
  mode : SortMode2D

  fn new(
    layer? : Int,
    group? : Int,
    order? : Int,
    mode? : SortMode2D,
  ) -> Sorting2d
} derive(Eq, Debug)

///|
pub fn Sorting2d::new(
  layer? : Int = 0,
  group? : Int = 0,
  order? : Int = 0,
  mode? : SortMode2D = Depth,
) -> Sorting2d {
  { layer, group, order, mode }
}

///|
priv struct Sorting2dWorldStore {
  sorting2ds : Map[@entity.Entity, Sorting2d]
}

///|
priv struct RenderFrameState2D {
  screen_world_commands : Array[OrderedDrawCommand2D]
  screen_ui_commands : Array[@render2d_types.DrawCommand2D]
  camera_world_commands : Map[UInt, Array[OrderedDrawCommand2D]]
  camera_ui_commands : Map[UInt, Array[@render2d_types.DrawCommand2D]]
  mut next_order : Int
}

///|
let frame2d_by_world : Map[UInt, RenderFrameState2D] = Map::new()

///|
let sorting2d_by_world : Map[UInt, Sorting2dWorldStore] = Map::new()

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
    }
  })
}

///|
fn sorting2d_store() -> Sorting2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  sorting2d_by_world.get_or_init(world_id, fn() { { sorting2ds: Map::new() } })
}

///|
pub fn sorting2ds() -> Map[@entity.Entity, Sorting2d] {
  sorting2d_store().sorting2ds
}

///|
pub fn begin_frame2d_system(_delta : Double) -> Unit {
  frame2d_by_world.set(@ecs.require_current_world().id(), {
    screen_world_commands: [],
    screen_ui_commands: [],
    camera_world_commands: Map::new(),
    camera_ui_commands: Map::new(),
    next_order: 0,
  })
  let sorting = sorting2ds()
  for pair in sorting.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      sorting.remove(entity)
    }
  }
}

///|
pub fn entity_sorting2d(entity : @entity.Entity) -> Sorting2d {
  sorting2ds().get(entity).unwrap_or(Sorting2d::new())
}

///|
pub fn sort_depth_for_transform(
  global_transform : @transform.GlobalTransform,
  sorting : Sorting2d,
) -> Double {
  match sorting.mode {
    Depth => global_transform.translation().z
    Y => global_transform.translation().y
  }
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
fn push_ui_command(
  command : @render2d_types.DrawCommand2D,
  camera_entity_id : UInt?,
) -> Unit {
  ui_command_bucket(frame2d(), camera_entity_id).push(command)
}

///|
fn push_world_command(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.DrawCommand2D,
  camera_entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  let frame = frame2d()
  world_command_bucket(frame, camera_entity_id).push({
    depth,
    order: frame.next_order,
    camera_entity_id,
    entity_id,
    sorting_layer: sorting.layer,
    sorting_group: sorting.group,
    sorting_order: sorting.order,
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
    if lhs.sorting_layer < rhs.sorting_layer {
      -1
    } else if lhs.sorting_layer > rhs.sorting_layer {
      1
    } else if lhs.sorting_group < rhs.sorting_group {
      -1
    } else if lhs.sorting_group > rhs.sorting_group {
      1
    } else if lhs.sorting_order < rhs.sorting_order {
      -1
    } else if lhs.sorting_order > rhs.sorting_order {
      1
    } else if lhs.depth < rhs.depth {
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
fn sorted_camera_entity_ids_by_pass_order() -> Array[UInt] {
  let camera_order_by_entity_id : Map[UInt, Int] = Map::new()
  for camera_view in @camera.active_camera2d_views() {
    camera_order_by_entity_id.set(camera_view.entity.id(), camera_view.camera.order)
  }
  let sorted = sorted_camera_entity_ids()
  sorted.sort_by(fn(lhs, rhs) {
    let lhs_order = camera_order_by_entity_id.get(lhs).unwrap_or(0)
    let rhs_order = camera_order_by_entity_id.get(rhs).unwrap_or(0)
    if lhs_order < rhs_order {
      -1
    } else if lhs_order > rhs_order {
      1
    } else {
      lhs.compare(rhs)
    }
  })
  sorted
}

///|
pub fn push_image_with_depth(
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, None, Image(command), sorting~)
}

///|
pub fn push_image_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.ImageDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, entity_id, Image(command), sorting~)
}

///|
pub fn push_image_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
  entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Image(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_image_with_depth(0.0, command)
}

///|
pub fn push_ui_image_to_camera(
  camera_entity_id : UInt?,
  command : @render2d_types.ImageDrawCommand2D,
) -> Unit {
  push_ui_command(Image(command), camera_entity_id)
}

///|
pub fn push_ui_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_ui_image_to_camera(None, command)
}

///|
pub fn push_text_with_depth(
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, None, Text(command), sorting~)
}

///|
pub fn push_text_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.TextDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, entity_id, Text(command), sorting~)
}

///|
pub fn push_text_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
  entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Text(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_text_with_depth(0.0, command)
}

///|
pub fn push_ui_text_to_camera(
  camera_entity_id : UInt?,
  command : @render2d_types.TextDrawCommand2D,
) -> Unit {
  push_ui_command(Text(command), camera_entity_id)
}

///|
pub fn push_ui_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_ui_text_to_camera(None, command)
}

///|
pub fn push_rect_with_depth(
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, None, Rect(command), sorting~)
}

///|
pub fn push_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.RectDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, entity_id, Rect(command), sorting~)
}

///|
pub fn push_rect_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
  entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Rect(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_rect_to_camera(
  camera_entity_id : UInt?,
  command : @render2d_types.RectDrawCommand2D,
) -> Unit {
  push_ui_command(Rect(command), camera_entity_id)
}

///|
pub fn push_ui_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_ui_rect_to_camera(None, command)
}

///|
pub fn push_circle_with_depth(
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, None, Circle(command), sorting~)
}

///|
pub fn push_circle_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.CircleDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, entity_id, Circle(command), sorting~)
}

///|
pub fn push_circle_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
  entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Circle(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_circle_with_depth(0.0, command)
}

///|
pub fn push_ui_circle_to_camera(
  camera_entity_id : UInt?,
  command : @render2d_types.CircleDrawCommand2D,
) -> Unit {
  push_ui_command(Circle(command), camera_entity_id)
}

///|
pub fn push_ui_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_ui_circle_to_camera(None, command)
}

///|
pub fn push_gradient_rect_with_depth(
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, None, GradientRect(command), sorting~)
}

///|
pub fn push_gradient_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt?,
  command : @render2d_types.GradientRectDrawCommand2D,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(depth, entity_id, GradientRect(command), sorting~)
}

///|
pub fn push_gradient_rect_with_depth_to_camera(
  camera_entity_id : UInt,
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
  entity_id? : UInt? = None,
  sorting? : Sorting2d = Sorting2d::new(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    GradientRect(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_gradient_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_gradient_rect_to_camera(
  camera_entity_id : UInt?,
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_ui_command(GradientRect(command), camera_entity_id)
}

///|
pub fn push_ui_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_ui_gradient_rect_to_camera(None, command)
}

///|
pub fn push_ui_clip_for_camera(rect : @math.Rect, camera_entity_id : UInt?) -> Unit {
  push_ui_command(PushClip({ rect, }), camera_entity_id)
}

///|
pub fn push_ui_clip(rect : @math.Rect) -> Unit {
  push_ui_clip_for_camera(rect, None)
}

///|
pub fn pop_ui_clip_for_camera(camera_entity_id : UInt?) -> Unit {
  push_ui_command(PopClip, camera_entity_id)
}

///|
pub fn pop_ui_clip() -> Unit {
  pop_ui_clip_for_camera(None)
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
  let commands : Array[DrawCommandWithDepth2D] = []
  for camera_entity_id in sorted_camera_entity_ids_by_pass_order() {
    for command in get_camera_world_commands_with_depth(camera_entity_id) {
      commands.push(command)
    }
  }
  for command in get_screen_world_commands_with_depth() {
    commands.push(command)
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
  let commands : Array[@render2d_types.DrawCommand2D] = []
  for camera_entity_id in sorted_camera_entity_ids_by_pass_order() {
    for command in get_camera_ui_commands(camera_entity_id) {
      commands.push(command)
    }
  }
  for command in get_screen_ui_commands() {
    commands.push(command)
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
