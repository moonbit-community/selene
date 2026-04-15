///|
fn test_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> @math.Rect {
  { position: @math.Vec2(x, y), size: @math.Vec2(width, height) }
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
fn cleanup_test_ui_entity(entity : @entity.Entity) -> Unit {
  nodes().remove(entity)
  computed_ui_nodes().remove(entity)
  global_ui_nodes().remove(entity)
  ui_target_cameras().remove(entity)
  calculated_clips().remove(entity)
  layout_configs().remove(entity)
  background_colors().remove(entity)
  border_colors().remove(entity)
  border_radii().remove(entity)
  box_shadows().remove(entity)
  outlines().remove(entity)
  material_nodes().remove(entity)
  texts().remove(entity)
  text_fonts().remove(entity)
  text_colors().remove(entity)
  text_layouts().remove(entity)
  ui_images().remove(entity)
  z_indexes().remove(entity)
  global_zindexes().remove(entity)
  override_clips().remove(entity)
  relative_cursor_positions().remove(entity)
  tree_orders().remove(entity)
  entity.destroy()
}

///|
test "ui rounded backgrounds emit quarter-circle fill commands" {
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let rect = test_rect(10.0, 20.0, 100.0, 60.0)
  global_ui_nodes().set(entity, test_global_node(rect, rect))
  background_colors().set(entity, BackgroundColor::new(rgba(20, 40, 60, 1.0)))
  border_radii().set(entity, BorderRadius::all(Val::px(12.0)))

  push_background(entity)

  let frame = @render2d.get_frame2d()
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
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let rect = test_rect(8.0, 12.0, 80.0, 40.0)
  let handle = register_ui_material_asset(
    UiMaterialAsset::gradient(rgba(255, 0, 0, 1.0), rgba(0, 0, 255, 1.0)),
  )
  nodes().set(entity, Node::new())
  global_ui_nodes().set(entity, test_global_node(rect, rect))
  material_nodes().set(entity, MaterialNode::new(handle))
  background_colors().set(entity, BackgroundColor::new(rgba(20, 40, 60, 1.0)))

  render_entity(entity)

  let frame = @render2d.get_frame2d()
  inspect(frame.ui_commands.length(), content="1")
  inspect(
    match frame.ui_commands[0] {
      GradientRect(command) =>
        command.rect.position[X] == 8.0 &&
        command.rect.position[Y] == 12.0 &&
        command.rect.size[X] == 80.0 &&
        command.rect.size[Y] == 40.0
      _ => false
    },
    content="true",
  )

  release_ui_material_asset(handle)
  cleanup_test_ui_entity(entity)
}

///|
test "ui material assets can render through custom draw callbacks" {
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let screen_rect = test_rect(4.0, 6.0, 120.0, 80.0)
  let content_rect = test_rect(12.0, 18.0, 64.0, 24.0)
  let handle = register_ui_material_asset(
    UiMaterialAsset::from_draw(fn(context) {
      push_ui_rect_fill(context.content_rect, rgba(0, 200, 80, 1.0))
    }),
  )
  nodes().set(entity, Node::new())
  global_ui_nodes().set(entity, test_global_node(screen_rect, content_rect))
  material_nodes().set(entity, MaterialNode::new(handle))

  render_entity(entity)

  let frame = @render2d.get_frame2d()
  inspect(frame.ui_commands.length(), content="1")
  inspect(
    match frame.ui_commands[0] {
      Rect(command) =>
        command.rect.position[X] == 12.0 &&
        command.rect.position[Y] == 18.0 &&
        command.rect.size[X] == 64.0 &&
        command.rect.size[Y] == 24.0
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
    BorderRadius::new(
      top_left=Val::percent(0.25),
      top_right=Val::percent(0.5),
      bottom_right=Val::px(8.0),
      bottom_left=Val::percent(1.0),
    ),
    @math.Vec2(120.0, 80.0),
  )

  inspect(resolved.top_left == 20.0, content="true")
  inspect(resolved.top_right == 40.0, content="true")
  inspect(resolved.bottom_right == 8.0, content="true")
  inspect(resolved.bottom_left == 40.0, content="true")
}

///|
test "ui box shadows emit layered rounded shadow commands" {
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let rect = test_rect(16.0, 24.0, 96.0, 48.0)
  global_ui_nodes().set(entity, test_global_node(rect, rect))
  border_radii().set(entity, BorderRadius::all(Val::px(8.0)))
  box_shadows().set(
    entity,
    BoxShadow::single(
      rgba(0, 0, 0, 0.6),
      x_offset=Val::px(4.0),
      y_offset=Val::px(6.0),
      spread_radius=Val::px(2.0),
      blur_radius=Val::px(12.0),
    ),
  )

  push_box_shadow(entity)

  let frame = @render2d.get_frame2d()
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
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let rect = test_rect(20.0, 30.0, 100.0, 60.0)
  global_ui_nodes().set(entity, test_global_node(rect, rect))
  outlines().set(
    entity,
    Outline::new(Val::px(4.0), rgba(255, 200, 0, 1.0), offset=Val::px(2.0)),
  )

  push_outline(entity)

  let frame = @render2d.get_frame2d()
  inspect(frame.ui_commands.length(), content="4")
  inspect(
    match frame.ui_commands[0] {
      Rect(command) =>
        command.rect.position[X] == 14.0 &&
        command.rect.position[Y] == 24.0 &&
        command.rect.size[X] == 112.0 &&
        command.rect.size[Y] == 4.0
      _ => false
    },
    content="true",
  )
  inspect(
    match frame.ui_commands[2] {
      Rect(command) =>
        command.rect.position[X] == 14.0 &&
        command.rect.position[Y] == 28.0 &&
        command.rect.size[X] == 4.0 &&
        command.rect.size[Y] == 64.0
      _ => false
    },
    content="true",
  )

  cleanup_test_ui_entity(entity)
}

///|
test "ui overflow clipping applies after node decorations" {
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let screen_rect = test_rect(0.0, 0.0, 120.0, 80.0)
  let content_rect = test_rect(12.0, 10.0, 96.0, 54.0)
  nodes().set(entity, Node::new(overflow_y=Overflow::Scroll))
  global_ui_nodes().set(entity, test_global_node(screen_rect, content_rect))
  background_colors().set(entity, BackgroundColor::new(rgba(32, 64, 96, 1.0)))
  texts().set(entity, Text::new("Overflow"))
  calculated_clips().set(entity, CalculatedClip::new(content_rect))
  tree_orders().set(entity, 1)

  render_entity(entity)

  let frame = @render2d.get_frame2d()
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
  @render2d.begin_frame2d_system(0.0)
  let parent = @entity.Entity::new()
  let child = parent.spawn_child()
  nodes().set(
    parent,
    Node::new(overflow_x=Overflow::Hidden, overflow_y=Overflow::Hidden),
  )
  nodes().set(child, Node::new())
  global_ui_nodes().set(
    parent,
    test_global_node(
      test_rect(0.0, 0.0, 100.0, 80.0),
      test_rect(0.0, 0.0, 100.0, 80.0),
    ),
  )
  global_ui_nodes().set(
    child,
    test_global_node(
      test_rect(90.0, 12.0, 40.0, 20.0),
      test_rect(90.0, 12.0, 40.0, 20.0),
    ),
  )
  calculated_clips().set(
    parent,
    CalculatedClip::new(test_rect(0.0, 0.0, 100.0, 80.0)),
  )
  texts().set(child, Text::new("Child"))
  tree_orders().set(parent, 1)
  tree_orders().set(child, 2)
  override_clips().set(child, OverrideClip::new())

  render_entity(parent)
  render_entity(child)

  let frame = @render2d.get_frame2d()
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
test "ui stacking sorts by global z before local z and tree order" {
  let back = @entity.Entity::new()
  let front = @entity.Entity::new()
  nodes().set(back, Node::new())
  nodes().set(front, Node::new())
  tree_orders().set(back, 5)
  tree_orders().set(front, 1)
  z_indexes().set(back, ZIndex::new(100))
  z_indexes().set(front, ZIndex::new(0))
  global_zindexes().set(back, GlobalZIndex::new(0))
  global_zindexes().set(front, GlobalZIndex::new(1))

  let entities = [front, back]
  entities.sort_by(compare_ui_stacking)

  inspect(entities[0] == back, content="true")
  inspect(entities[1] == front, content="true")

  cleanup_test_ui_entity(back)
  cleanup_test_ui_entity(front)
}
