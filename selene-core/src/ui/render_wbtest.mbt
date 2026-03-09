///|
fn test_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> @math.Rect {
  { position: @math.Vec2D(x, y), size: @math.Vec2D(width, height) }
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
  }
}

///|
fn cleanup_test_ui_entity(entity : @entity.Entity) -> Unit {
  nodes.remove(entity)
  computed_ui_nodes.remove(entity)
  global_ui_nodes.remove(entity)
  calculated_clips.remove(entity)
  background_colors.remove(entity)
  border_colors.remove(entity)
  border_radii.remove(entity)
  box_shadows.remove(entity)
  outlines.remove(entity)
  texts.remove(entity)
  text_fonts.remove(entity)
  text_colors.remove(entity)
  text_layouts.remove(entity)
  ui_images.remove(entity)
  ui_zindexes.remove(entity)
  override_clips.remove(entity)
  relative_cursor_positions.remove(entity)
  tree_orders.remove(entity)
  entity.destroy()
}

///|
test "ui rounded backgrounds emit quarter-circle fill commands" {
  @render2d.begin_frame2d_system(0.0)
  let entity = @entity.Entity::new()
  let rect = test_rect(10.0, 20.0, 100.0, 60.0)
  global_ui_nodes.set(entity, test_global_node(rect, rect))
  background_colors.set(entity, BackgroundColor::new(rgba(20, 40, 60, 1.0)))
  border_radii.set(entity, BorderRadius::all(Val::px(12.0)))

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
test "ui border radii resolve percent values against node size" {
  let resolved = resolved_border_radius(
    BorderRadius::new(
      top_left=Val::percent(0.25),
      top_right=Val::percent(0.5),
      bottom_right=Val::px(8.0),
      bottom_left=Val::percent(1.0),
    ),
    @math.Vec2D(120.0, 80.0),
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
  global_ui_nodes.set(entity, test_global_node(rect, rect))
  border_radii.set(entity, BorderRadius::all(Val::px(8.0)))
  box_shadows.set(
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
  global_ui_nodes.set(entity, test_global_node(rect, rect))
  outlines.set(
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
  nodes.set(entity, Node::new(overflow_y=Overflow::Scroll))
  global_ui_nodes.set(entity, test_global_node(screen_rect, content_rect))
  background_colors.set(entity, BackgroundColor::new(rgba(32, 64, 96, 1.0)))
  texts.set(entity, Text::new("Overflow"))
  calculated_clips.set(entity, CalculatedClip::new(content_rect))
  tree_orders.set(entity, 1)

  render_entity_recursive(entity, None)

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
  nodes.set(
    parent,
    Node::new(overflow_x=Overflow::Hidden, overflow_y=Overflow::Hidden),
  )
  nodes.set(child, Node::new())
  global_ui_nodes.set(
    parent,
    test_global_node(
      test_rect(0.0, 0.0, 100.0, 80.0),
      test_rect(0.0, 0.0, 100.0, 80.0),
    ),
  )
  global_ui_nodes.set(
    child,
    test_global_node(
      test_rect(90.0, 12.0, 40.0, 20.0),
      test_rect(90.0, 12.0, 40.0, 20.0),
    ),
  )
  calculated_clips.set(
    parent,
    CalculatedClip::new(test_rect(0.0, 0.0, 100.0, 80.0)),
  )
  texts.set(child, Text::new("Child"))
  tree_orders.set(parent, 1)
  tree_orders.set(child, 2)
  override_clips.set(child, OverrideClip::new())

  render_entity_recursive(parent, None)

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
