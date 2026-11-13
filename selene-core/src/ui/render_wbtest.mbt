///|
fn test_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> @math.Rect {
  { position: Vec2(x, y), size: Vec2(width, height), }
}

///|
fn test_global_node(
  screen_rect : @math.Rect,
  screen_content_rect : @math.Rect,
) -> GlobalUiNode {
  {
    logical_rect: screen_rect,
    screen_rect,
    logical_content_rect: screen_content_rect,
    screen_content_rect,
    target_camera: None,
    target_viewport: screen_rect,
  }
}

///|
fn set_test_ui_geometry(
  entity : @ecs.Entity,
  global : GlobalUiNode,
  computed~ : ComputedUiNode = {
    position: global.logical_rect.position,
    size: global.logical_rect.size,
    content_position: global.logical_content_rect.position,
    content_size: global.logical_content_rect.size,
    max_scroll_position: @math.Vec2::zero(),
    border: UiInsets::zero(),
    padding: UiInsets::zero(),
  },
) -> Unit {
  ui_geometry().set(entity, { global, computed, })
}

///|
fn cleanup_test_ui_entity(entity : @ecs.Entity) -> Unit {
  ignore(@ecs_test.delete(entity))
}

///|
fn test_entity_index(
  entities : Array[@ecs.Entity],
  target : @ecs.Entity,
) -> Int32 {
  for index, entity in entities {
    if entity == target {
      return index
    }
  }
  -1
}

///|
test "ui rounded backgrounds emit quarter-circle fill commands" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let rect = test_rect(10.0, 20.0, 100.0, 60.0)
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (BackgroundColor(rgba(20, 40, 60, 1.0)), BorderRadius::all(Val::px(12.0))),
  )
  set_test_ui_geometry(entity, test_global_node(rect, rect))

  push_background(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  let mut rects = 0
  let mut circles = 0
  let mut push_clips = 0
  let mut pop_clips = 0
  for command in frame.ui_commands {
    match command {
      Rect(_) => rects += 1
      Circle(_) => circles += 1
      PushClip(_) => push_clips += 1
      PopClip => pop_clips += 1
      _ => ()
    }
  }
  inspect(rects, content="5")
  inspect(circles, content="4")
  inspect(push_clips, content="4")
  inspect(pop_clips, content="4")

  cleanup_test_ui_entity(entity)
}

///|
test "ui material nodes render gradient materials ahead of legacy background fills" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let rect = test_rect(8.0, 12.0, 80.0, 40.0)
  let handle = register_ui_material_asset(
    UiMaterialAsset::gradient(rgba(255, 0, 0, 1.0), rgba(0, 0, 255, 1.0)),
  )
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (Node(), MaterialNode(handle), BackgroundColor(rgba(20, 40, 60, 1.0))),
  )
  set_test_ui_geometry(entity, test_global_node(rect, rect))

  render_entity(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  inspect(frame.ui_commands.length(), content="1")
  inspect(
    match frame.ui_commands[0] {
      GradientRect(command) =>
        command.rect.position.x == 8.0 &&
        command.rect.position.y == 12.0 &&
        command.rect.size.x == 80.0 &&
        command.rect.size.y == 40.0
      _ => false
    },
    content="true",
  )

  release_ui_material_asset(handle)
  cleanup_test_ui_entity(entity)
}

///|
test "ui material assets can render through custom draw callbacks" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let screen_rect = test_rect(4.0, 6.0, 120.0, 80.0)
  let content_rect = test_rect(12.0, 18.0, 64.0, 24.0)
  let handle = register_ui_material_asset(
    UiMaterialAsset::from_draw(fn(context) {
      push_ui_rect_fill(
        context.frame,
        context.content_rect,
        rgba(0, 200, 80, 1.0),
      )
    }),
  )
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (Node(), MaterialNode(handle)),
  )
  set_test_ui_geometry(entity, test_global_node(screen_rect, content_rect))

  render_entity(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  inspect(frame.ui_commands.length(), content="1")
  inspect(
    match frame.ui_commands[0] {
      Rect(command) =>
        command.rect.position.x == 12.0 &&
        command.rect.position.y == 18.0 &&
        command.rect.size.x == 64.0 &&
        command.rect.size.y == 24.0
      _ => false
    },
    content="true",
  )

  release_ui_material_asset(handle)
  cleanup_test_ui_entity(entity)
}

///|
test "ui border radii resolve percent values against node size" {
  let resolved = resolved_border_radius(
    BorderRadius(
      top_left=Val::percent(0.25),
      top_right=Val::percent(0.5),
      bottom_right=Val::px(8.0),
      bottom_left=Val::percent(1.0),
    ),
    Vec2(120.0, 80.0),
  )

  inspect(resolved.top_left == 20.0, content="true")
  inspect(resolved.top_right == 40.0, content="true")
  inspect(resolved.bottom_right == 8.0, content="true")
  inspect(resolved.bottom_left == 40.0, content="true")
}

///|
test "ui box shadows emit layered rounded shadow commands" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let rect = test_rect(16.0, 24.0, 96.0, 48.0)
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (
      BorderRadius::all(Val::px(8.0)),
      BoxShadow::single(
        rgba(0, 0, 0, 0.6),
        x_offset=Val::px(4.0),
        y_offset=Val::px(6.0),
        spread_radius=Val::px(2.0),
        blur_radius=Val::px(12.0),
      ),
    ),
  )
  set_test_ui_geometry(entity, test_global_node(rect, rect))

  push_box_shadow(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  let mut circles = 0
  let mut push_clips = 0
  for command in frame.ui_commands {
    match command {
      Circle(_) => circles += 1
      PushClip(_) => push_clips += 1
      _ => ()
    }
  }
  inspect(circles, content="12")
  inspect(push_clips, content="12")

  cleanup_test_ui_entity(entity)
}

///|
test "ui outlines resolve width and offset into outer bands" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let rect = test_rect(20.0, 30.0, 100.0, 60.0)
  let entity = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Outline(Val::px(4.0), rgba(255, 200, 0, 1.0), offset=Val::px(2.0)),
  )
  set_test_ui_geometry(entity, test_global_node(rect, rect))

  push_outline(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  inspect(frame.ui_commands.length(), content="4")
  inspect(
    match frame.ui_commands[0] {
      Rect(command) =>
        command.rect.position.x == 14.0 &&
        command.rect.position.y == 24.0 &&
        command.rect.size.x == 112.0 &&
        command.rect.size.y == 4.0
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[2] {
      Rect(command) =>
        command.rect.position.x == 14.0 &&
        command.rect.position.y == 28.0 &&
        command.rect.size.x == 4.0 &&
        command.rect.size.y == 64.0
      _ => false
    },
    content="true",
  )

  cleanup_test_ui_entity(entity)
}

///|
test "ui overflow clipping applies after node decorations" {
  let world = @ecs.require_current_world()
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let screen_rect = test_rect(0.0, 0.0, 120.0, 80.0)
  let content_rect = test_rect(12.0, 10.0, 96.0, 54.0)
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (
      Node(overflow_y=Scroll),
      BackgroundColor(rgba(32, 64, 96, 1.0)),
      Text("Overflow"),
    ),
  )
  set_test_ui_geometry(entity, test_global_node(screen_rect, content_rect))
  calculated_clips().set(entity, CalculatedClip(content_rect))
  ui_model_world_store().tree_orders.set(entity, 1)

  render_entity(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    entity,
  )

  let frame = @render2d.get_frame2d(world~)
  inspect(frame.ui_commands.length(), content="4")
  inspect(
    match frame.ui_commands[0] {
      Rect(_) => true
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[1] {
      PushClip(_) => true
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[2] {
      Text(_) => true
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[3] {
      PopClip => true
      _ => false
    },
    content="true",
  )

  cleanup_test_ui_entity(entity)
}

///|
test "ui override clip removes inherited clip from child rendering" {
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    world,
    Node(overflow_x=Hidden, overflow_y=Hidden),
  )
  let child = @ecs_test.spawn(
    world,
    (Node(), Text("Child"), OverrideClip()),
    parent~,
  )
  set_test_ui_geometry(
    parent,
    test_global_node(
      test_rect(0.0, 0.0, 100.0, 80.0),
      test_rect(0.0, 0.0, 100.0, 80.0),
    ),
  )
  set_test_ui_geometry(
    child,
    test_global_node(
      test_rect(90.0, 12.0, 40.0, 20.0),
      test_rect(90.0, 12.0, 40.0, 20.0),
    ),
  )
  calculated_clips().set(
    parent,
    CalculatedClip(test_rect(0.0, 0.0, 100.0, 80.0)),
  )
  ui_model_world_store().tree_orders.set(parent, 1)
  ui_model_world_store().tree_orders.set(child, 2)

  render_entity(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    parent,
  )
  render_entity(
    Frame2D(@ecs.require_current_world()),
    nodes=UiNodes(world),
    child,
  )

  let frame = @render2d.get_frame2d(world~)
  inspect(frame.ui_commands.length(), content="3")
  inspect(
    match frame.ui_commands[0] {
      PushClip(_) => true
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[1] {
      PopClip => true
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[2] {
      Text(_) => true
      _ => false
    },
    content="true",
  )

  cleanup_test_ui_entity(child)
  cleanup_test_ui_entity(parent)
}

///|
test "ui stacking keeps a pause menu subtree above the HUD" {
  let world = @ecs.require_current_world()
  let node = Node(width=Val::px(100.0), height=Val::px(100.0))
  let root = @ecs_test.spawn1(world, node)
  let hud = @ecs_test.spawn1(world, node, parent=root)
  let minimap = @ecs_test.spawn(world, (node, ZIndex(10)), parent=hud)
  let pause_menu = @ecs_test.spawn(world, (node, ZIndex(1)), parent=root)
  let dimmer = @ecs_test.spawn(world, (node, ZIndex(0)), parent=pause_menu)
  let resume_button = @ecs_test.spawn(
    world,
    (node, ZIndex(20)),
    parent=pause_menu,
  )
  let entities = [root, hud, minimap, pause_menu, dimmer, resume_button]

  ui_layout_system(UiNodes(world))
  ui_extract_system(UiExtraction(@ecs.require_current_world()))

  let mut minimap_index = -1
  let mut pause_menu_index = -1
  let mut dimmer_index = -1
  for index, entity in ui_model_world_store().extracted_entities {
    if entity == minimap {
      minimap_index = index
    } else if entity == pause_menu {
      pause_menu_index = index
    } else if entity == dimmer {
      dimmer_index = index
    }
  }
  assert_eq(minimap_index < pause_menu_index, true)
  assert_eq(pause_menu_index < dimmer_index, true)

  ui_model_world_store().extracted_entities.clear()
  for entity in entities.rev() {
    cleanup_test_ui_entity(entity)
  }
}

///|
test "global z index lifts a descendant out of its parent stack" {
  let world = @ecs.require_current_world()
  let node = Node(width=Val::px(100.0), height=Val::px(100.0))
  let root = @ecs_test.spawn1(world, node)
  let hud = @ecs_test.spawn1(world, node, parent=root)
  let minimap = @ecs_test.spawn(world, (node, GlobalZIndex(2)), parent=hud)
  let pause_menu = @ecs_test.spawn(world, (node, ZIndex(1)), parent=root)
  let dimmer = @ecs_test.spawn1(world, node, parent=pause_menu)
  let entities = [root, hud, minimap, pause_menu, dimmer]

  ui_layout_system(UiNodes(world))
  ui_extract_system(UiExtraction(@ecs.require_current_world()))

  let mut dimmer_index = -1
  let mut minimap_index = -1
  for index, entity in ui_model_world_store().extracted_entities {
    if entity == dimmer {
      dimmer_index = index
    } else if entity == minimap {
      minimap_index = index
    }
  }
  assert_eq(dimmer_index < minimap_index, true)

  ui_model_world_store().extracted_entities.clear()
  for entity in entities.rev() {
    cleanup_test_ui_entity(entity)
  }
}

///|
test "global z index orders separate UI roots before local z index" {
  let world = @ecs.require_current_world()
  let node = Node(width=Val::px(100.0), height=Val::px(100.0))
  let local_front = @ecs_test.spawn(world, (node, ZIndex(100), GlobalZIndex(0)))
  let global_front = @ecs_test.spawn(world, (node, ZIndex(0), GlobalZIndex(1)))
  let entities = [local_front, global_front]

  ui_layout_system(UiNodes(world))
  ui_extract_system(UiExtraction(@ecs.require_current_world()))

  assert_eq(
    test_entity_index(ui_model_world_store().extracted_entities, local_front) <
    test_entity_index(ui_model_world_store().extracted_entities, global_front),
    true,
  )

  ui_model_world_store().extracted_entities.clear()
  for entity in entities {
    cleanup_test_ui_entity(entity)
  }
}

///|
test "ui extraction reuses the stack snapshot produced by layout" {
  let world = @ecs.require_current_world()
  let node = Node(width=Val::px(100.0), height=Val::px(100.0))
  let root = @ecs_test.spawn1(world, node)
  let first = @ecs_test.spawn(world, (node, ZIndex(0)), parent=root)
  let second = @ecs_test.spawn(world, (node, ZIndex(1)), parent=root)
  let entities = [root, first, second]

  ui_layout_system(UiNodes(world))
  world.set_component(first, (ZIndex(2) : ZIndex))
  ui_extract_system(UiExtraction(@ecs.require_current_world()))
  let first_snapshot = ui_model_world_store().extracted_entities.copy()

  ui_layout_system(UiNodes(world))
  ui_extract_system(UiExtraction(@ecs.require_current_world()))
  let second_snapshot = ui_model_world_store().extracted_entities.copy()

  assert_eq(
    test_entity_index(first_snapshot, first) <
    test_entity_index(first_snapshot, second),
    true,
  )
  assert_eq(
    test_entity_index(second_snapshot, second) <
    test_entity_index(second_snapshot, first),
    true,
  )

  ui_model_world_store().extracted_entities.clear()
  for entity in entities.rev() {
    cleanup_test_ui_entity(entity)
  }
}

///|
test "ui prepare preserves clipped border paint order and sees material changes" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let parent = @ecs_test.spawn(world, ())
  let rect = test_rect(10.0, 20.0, 100.0, 80.0)
  let clip = test_rect(10.0, 20.0, 80.0, 60.0)
  let red = rgba(1, 0, 0, 1.0)
  let green = rgba(2, 0, 0, 1.0)
  let blue = rgba(3, 0, 0, 1.0)
  let yellow = rgba(4, 0, 0, 1.0)
  let material = register_ui_material_asset(
    UiMaterialAsset::from_draw(context => {
      push_ui_rect_fill(context.frame, context.rect, blue)
      // Update a predeclared border during drawing.
      world.set_component(context.entity, (BorderColor(yellow) : BorderColor))
    }),
  )
  calculated_clips().set(parent, CalculatedClip(clip))
  let front = @ecs_test.spawn(
    world,
    (Node(), MaterialNode(material), BorderColor(rgba(0, 0, 0, 0.0))),
    parent~,
  )
  let back = @ecs_test.spawn(
    world,
    (
      Node(),
      BorderColor(red),
      BackgroundColor(green),
      BorderRadius::all(Val::px(8.0)),
    ),
    parent~,
  )
  for entity in [front, back] {
    let computed : ComputedUiNode = {
      position: rect.position,
      size: rect.size,
      content_position: rect.position,
      content_size: rect.size,
      max_scroll_position: Vec2(0.0, 0.0),
      border: { ..UiInsets::zero(), top: 2.0, },
      padding: UiInsets::zero(),
    }
    set_test_ui_geometry(entity, test_global_node(rect, rect), computed~)
  }
  defer release_ui_material_asset(material)
  ui_model_world_store().extracted_entities.clear()
  defer ui_model_world_store().extracted_entities.clear()
  ui_model_world_store().extracted_entities.append([back, front])
  @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
  ui_prepare_system(Frame2D(world), UiNodes(world))

  let commands = StringBuilder()
  for command in @render2d.get_frame2d(world~).ui_commands {
    match command {
      PushClip(command) =>
        commands.write_char(
          if command.rect.position == clip.position &&
            command.rect.size == clip.size {
            '['
          } else {
            '('
          },
        )
      PopClip => commands.write_char(']')
      Rect(command) =>
        commands.write_string("r" + command.fill_color.r.to_string())
      Circle(command) =>
        commands.write_string("c" + command.fill_color.r.to_string())
      _ => fail("unexpected UI draw command")
    }
  }
  let rounded_background = "r2r2r2r2r2(c2](c2](c2](c2]"
  let rounded_border = "r1r1r1r1r1(c1](c1](c1](c1]"
  assert_eq(
    commands.to_string(),
    "[" +
    rounded_background +
    rounded_border +
    rounded_background +
    "][][r3r4][]",
  )
}
