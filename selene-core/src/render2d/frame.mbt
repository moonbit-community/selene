///|
priv struct OrderedDrawCommand2D {
  depth : Double
  order : Int32
  camera_entity_id : UInt32?
  entity_id : UInt32?
  sorting_layer : Int32
  sorting_group : Int32
  sorting_order : Int32
  command : @render2d_types.DrawCommand2D
}

///|
pub(all) struct DrawCommandWithDepth2D {
  depth : Double
  order : Int32
  camera_entity_id : UInt32?
  entity_id : UInt32?
  command : @render2d_types.DrawCommand2D
}

///|
priv struct RenderFrameState2D {
  screen_world_commands : Array[OrderedDrawCommand2D]
  screen_ui_commands : Array[@render2d_types.DrawCommand2D]
  camera_world_commands : Map[UInt32, Array[OrderedDrawCommand2D]]
  camera_ui_commands : Map[UInt32, Array[@render2d_types.DrawCommand2D]]
  mut next_order : Int32
}

///|
let frame2d_by_world : Map[UInt32, RenderFrameState2D] = Map([])

///|
fn frame2d() -> RenderFrameState2D {
  let world_id = @ecs.require_current_world().id()
  frame2d_by_world.get_or_init(world_id, fn() {
    {
      screen_world_commands: [],
      screen_ui_commands: [],
      camera_world_commands: Map([]),
      camera_ui_commands: Map([]),
      next_order: 0,
    }
  })
}

///|
pub fn begin_frame2d_system(_delta : Double) -> Unit {
  frame2d_by_world.set(@ecs.require_current_world().id(), {
    screen_world_commands: [],
    screen_ui_commands: [],
    camera_world_commands: Map([]),
    camera_ui_commands: Map([]),
    next_order: 0,
  })
}

///|
fn world_command_bucket(
  state : RenderFrameState2D,
  camera_entity_id : UInt32?,
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
  camera_entity_id : UInt32?,
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
  camera_entity_id : UInt32?,
) -> Unit {
  ui_command_bucket(frame2d(), camera_entity_id).push(command)
}

///|
/// Reserves a range of draw-order keys for one batch in the active frame.
pub fn reserve_world_command_order(count : Int32) -> Int32 {
  let frame = frame2d()
  let start = frame.next_order
  frame.next_order += count
  start
}

///|
/// Submits a world draw. An explicit order must belong to a reserved range.
pub fn push_world_command(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.DrawCommand2D,
  camera_entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
  order~ : Int32? = None,
) -> Unit {
  let frame = frame2d()
  let order = match order {
    Some(order) => order
    None => {
      let order = frame.next_order
      frame.next_order += 1
      order
    }
  }
  world_command_bucket(frame, camera_entity_id).push({
    depth,
    order,
    camera_entity_id,
    entity_id,
    sorting_layer: sorting.layer,
    sorting_group: sorting.group,
    sorting_order: sorting.order,
    command,
  })
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
fn sorted_camera_entity_ids() -> Array[UInt32] {
  let unique : Map[UInt32, Unit] = Map([])
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
fn sorted_camera_entity_ids_by_pass_order() -> Array[UInt32] {
  let camera_order_by_entity_id : Map[UInt32, Int32] = Map([])
  for camera_view in @camera.active_camera2d_views() {
    camera_order_by_entity_id.set(
      camera_view.entity.id(),
      camera_view.camera.order,
    )
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
  camera_entity_id : UInt32,
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
  camera_entity_id : UInt32,
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
