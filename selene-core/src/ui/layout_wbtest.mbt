///|
fn cleanup_layout_test_entity(entity : @ecs.Entity) -> Unit {
  ignore(@ecs_test.delete(entity))
}

///|
test "ui nodes map flex wrap and align content into wrapped layout" {
  let chicle : @tree.ChicleTree[Unit] = ChicleTree()
  let mk_child = fn() {
    chicle.new_leaf(
      node_to_chicle_style(Node(width=Val::px(50.0), height=Val::px(10.0))),
    )
  }
  let child0 = mk_child()
  let child1 = mk_child()
  let child2 = mk_child()
  let child3 = mk_child()
  let child4 = mk_child()
  let child5 = mk_child()
  let root = chicle.new_with_children(
    node_to_chicle_style(
      Node(
        width=Val::px(120.0),
        height=Val::px(100.0),
        flex_direction=Row,
        flex_wrap=flex_wrap_wrap(),
        align_content=Some(align_content_center()),
      ),
    ),
    [child0, child1, child2, child3, child4, child5],
  )
  chicle.compute_layout(root, @geometry.Size::max_content())

  let root_layout = chicle.layout(root)
  inspect(root_layout.size.width == 120.0, content="true")
  inspect(root_layout.size.height == 100.0, content="true")

  inspect(chicle.layout(child0).location.y == 35.0, content="true")
  inspect(chicle.layout(child1).location.y == 35.0, content="true")
  inspect(chicle.layout(child2).location.y == 45.0, content="true")
  inspect(chicle.layout(child3).location.y == 45.0, content="true")
  inspect(chicle.layout(child4).location.y == 55.0, content="true")
  inspect(chicle.layout(child5).location.y == 55.0, content="true")
}

///|
test "ui nodes map block display and aspect ratio into block layout" {
  let chicle : @tree.ChicleTree[Unit] = ChicleTree()
  let child = chicle.new_leaf(
    node_to_chicle_style(
      Node(
        position_type=Absolute,
        left=Val::percent(0.05),
        right=Val::percent(0.05),
        top=Val::percent(0.05),
        bottom=Val::percent(0.05),
        aspect_ratio=Some(3.0),
      ),
    ),
  )
  let root = chicle.new_with_children(
    node_to_chicle_style(
      Node(display=Block, width=Val::px(400.0), height=Val::px(300.0)),
    ),
    [child],
  )
  chicle.compute_layout(root, @geometry.Size::max_content())

  let layout = chicle.layout(child)
  inspect(layout.size.width == 360.0, content="true")
  inspect(layout.size.height == 120.0, content="true")
  inspect(layout.location.x == 20.0, content="true")
  inspect(layout.location.y == 15.0, content="true")
}

///|
test "ui wrapped text contributes lines to auto height" {
  let world = @ecs.require_current_world()
  let entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
  entity_draft.add((Text("hello world") : Text))
  entity_draft.add((TextFont(size=16.0) : TextFont))
  entity_draft.add((TextLayout(wrap=WordWrap) : TextLayout))
  let entity = @ecs_test.spawn_draft(entity_draft)

  let measured = measure_node(
    world~,
    Size(width=Some(60.0), height=None),
    Size(
      width=@style_helpers.available_space_definite(60.0),
      height=@style_helpers.max_content(),
    ),
    0,
    Some(entity),
    node_to_chicle_style(Node(width=Val::px(60.0))),
  )

  inspect(measured.width, content="60")
  inspect(measured.height, content="32")

  let measured_with_padding = measure_node(
    world~,
    Size(width=Some(100.0), height=None),
    Size(
      width=@style_helpers.available_space_definite(100.0),
      height=@style_helpers.max_content(),
    ),
    0,
    Some(entity),
    node_to_chicle_style(
      Node(
        width=Val::px(100.0),
        padding=UiRectValues::px(left=20.0, right=20.0),
      ),
    ),
  )

  inspect(measured_with_padding.width, content="100")
  inspect(measured_with_padding.height, content="32")
  cleanup_layout_test_entity(entity)
}

///|
test "ui layout uses wrapped text height in the computed node" {
  let world = @ecs.require_current_world()
  let entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
  entity_draft.add(
    (
      Node(
        width=Val::px(60.0),
        position_type=Absolute,
        left=Val::px(0.0),
        top=Val::px(0.0),
      ) : Node),
  )
  entity_draft.add((Text("hello world") : Text))
  entity_draft.add((TextFont(size=16.0) : TextFont))
  entity_draft.add((TextLayout(wrap=WordWrap) : TextLayout))
  let entity = @ecs_test.spawn_draft(entity_draft)

  ui_layout_system(world~, 0.0)

  assert_eq(computed_ui_node(entity).unwrap().size, Vec2(60.0, 32.0))
  cleanup_layout_test_entity(entity)
}

///|
test "ui nodes map grid placement and self alignment into grid layout" {
  let chicle : @tree.ChicleTree[Unit] = ChicleTree()
  let child0 = chicle.new_leaf(
    node_to_chicle_style(
      Node(
        width=Val::px(20.0),
        height=Val::px(20.0),
        grid_row=GridLine(start=grid_line_index(1)),
        grid_column=GridLine(start=grid_line_index(1)),
      ),
    ),
  )
  let child1 = chicle.new_leaf(
    node_to_chicle_style(
      Node(
        width=Val::px(20.0),
        height=Val::px(20.0),
        align_self=Some(Center),
        justify_self=Some(Center),
        grid_row=GridLine(start=grid_line_index(3)),
        grid_column=GridLine(start=grid_line_index(3)),
      ),
    ),
  )
  let root = chicle.new_with_children(
    node_to_chicle_style(
      Node(
        display=Grid,
        width=Val::px(120.0),
        height=Val::px(120.0),
        align_items=End,
        justify_items=Some(End),
        grid_template_rows=[grid_px(40.0), grid_px(40.0), grid_px(40.0)],
        grid_template_columns=[grid_px(40.0), grid_px(40.0), grid_px(40.0)],
      ),
    ),
    [child0, child1],
  )
  chicle.compute_layout(root, @geometry.Size::max_content())

  let layout0 = chicle.layout(child0)
  inspect(layout0.location.x == 20.0, content="true")
  inspect(layout0.location.y == 20.0, content="true")

  let layout1 = chicle.layout(child1)
  inspect(layout1.location.x == 90.0, content="true")
  inspect(layout1.location.y == 90.0, content="true")
}

///|
test "ui nodes map style-only grid and flex fields into chicle style" {
  let style = node_to_chicle_style(
    Node(
      display=Grid,
      overflow_x=Hidden,
      flex_basis=Val::percent(0.25),
      scrollbar_width=12.0,
      grid_auto_rows=[grid_px(16.0)],
      grid_auto_columns=[grid_fr(1.0)],
      grid_auto_flow=grid_auto_flow_column_dense(),
      grid_template_columns=[grid_repeat(grid_repeat_count(2), [grid_px(20.0)])],
    ),
  )

  let has_percent_basis = match style.flex_basis {
    DimPercent(value) => value == 0.25
    _ => false
  }
  inspect(has_percent_basis, content="true")
  inspect(style.scrollbar_width == 12.0, content="true")

  let has_auto_row = match style.grid_auto_rows[0] {
    DimLength(value) => value == 16.0
    _ => false
  }
  inspect(has_auto_row, content="true")

  let has_auto_column = match style.grid_auto_columns[0] {
    DimFr(value) => value == 1.0
    _ => false
  }
  inspect(has_auto_column, content="true")

  let is_column_dense = match style.grid_auto_flow {
    ColumnDense => true
    _ => false
  }
  inspect(is_column_dense, content="true")

  let has_repeated_template = match style.grid_template_columns[0] {
    DimRepeat(RepeatCount(2), tracks) => {
      let has_single_track = tracks.length() == 1
      let has_length_track = if has_single_track {
        match tracks[0] {
          DimLength(value) => value == 20.0
          _ => false
        }
      } else {
        false
      }
      has_single_track && has_length_track
    }
    _ => false
  }
  inspect(has_repeated_template, content="true")

  let has_hidden_overflow = match style.overflow.x {
    OverflowHidden => true
    _ => false
  }
  inspect(has_hidden_overflow, content="true")
}

///|
test "ui layout uses overflow clip margins from the requested visual box" {
  let world = @ecs.require_current_world()
  let entity = @ecs_test.spawn1(
    world,
    Node::absolute(
      Vec2(10.0, 20.0),
      size=Vec2(100.0, 80.0),
      padding=UiRectValues::px(left=6.0),
      border=UiRectValues::px(left=4.0),
      overflow_x=Hidden,
      overflow_y=Hidden,
      overflow_clip_margin=OverflowClipMargin::padding_box().with_margin(3.0),
    ),
  )

  ui_layout_system(world~, 0.0)

  let clip = calculated_clips().get(entity).unwrap().clip
  inspect(clip.position.x == 11.0, content="true")
  inspect(clip.position.y == 21.0, content="true")
  inspect(clip.size.x == 98.0, content="true")
  inspect(clip.size.y == 78.0, content="true")

  cleanup_layout_test_entity(entity)
}

///|
test "ui layout projects nested border and padding offsets exactly once" {
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node::absolute(
      Vec2(10.0, 20.0),
      size=Vec2(100.0, 80.0),
      padding=UiRectValues::all(6.0),
      border=UiRectValues::all(2.0),
    ),
  )
  let child = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(
      width=Val::px(40.0),
      height=Val::px(30.0),
      padding=UiRectValues::all(3.0),
      border=UiRectValues::all(1.0),
    ),
    parent~,
  )
  let grandchild = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(10.0), height=Val::px(10.0)),
    parent=child,
  )

  ui_layout_system(world~, 0.0)

  assert_eq(computed_ui_node(parent).unwrap().position, Vec2(10.0, 20.0))
  assert_eq(
    computed_ui_node(parent).unwrap().content_position,
    Vec2(18.0, 28.0),
  )
  assert_eq(computed_ui_node(child).unwrap().position, Vec2(18.0, 28.0))
  assert_eq(computed_ui_node(child).unwrap().content_position, Vec2(22.0, 32.0))
  assert_eq(computed_ui_node(grandchild).unwrap().position, Vec2(22.0, 32.0))

  cleanup_layout_test_entity(grandchild)
  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(parent)
}

///|
test "ui layout config controls screen-space rounding for viewport-scaled rects" {
  let world = @ecs.require_current_world()
  let old_scale_mode = get_ui_scale_mode()
  let old_viewport = @window.get_viewport_size()
  let old_zoom = @window.get_zoom()
  set_ui_scale_mode(Viewport)
  @window.configure_display(101.0, 101.0, 1.5)

  let logical_rect : @math.Rect = {
    position: Vec2(33.835, 33.835),
    size: Vec2(10.0, 10.0),
  }
  let rounded_rect = screen_rect_for(
    logical_rect,
    ui_layout_space(world~, None),
    LayoutConfig().use_rounding,
  )
  inspect(rounded_rect.position.x == 51.0, content="true")
  inspect(rounded_rect.position.y == 51.0, content="true")

  let unrounded_rect = screen_rect_for(
    logical_rect,
    ui_layout_space(world~, None),
    LayoutConfig(use_rounding=false).use_rounding,
  )
  let expected = 33.835 * 1.5
  inspect(
    (unrounded_rect.position.x - expected).abs() < 0.000001,
    content="true",
  )
  inspect(
    (unrounded_rect.position.y - expected).abs() < 0.000001,
    content="true",
  )

  set_ui_scale_mode(old_scale_mode)
  @window.configure_display(old_viewport.x, old_viewport.y, old_zoom)
}

///|
test "ui target camera layouts use the camera viewport as screen-space origin" {
  let world = @ecs.require_current_world()
  @window.configure_display(200.0, 120.0, 1.0)
  let camera_draft = @ecs.commands(@ecs.require_current_world()).draft()
  camera_draft.add(
    (
      Camera(viewport=Some(CameraViewport(Vec2(20.0, 10.0), Vec2(80.0, 40.0)))) :
      @camera.Camera),
  )
  camera_draft.add((Camera2d() : @camera.Camera2d))
  camera_draft.add(
    (Spatial(@transform.Transform::default()) : @transform.Spatial),
  )
  let camera = @ecs_test.spawn_draft(camera_draft)

  let entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
  entity_draft.add(
    (Node::absolute(Vec2(4.0, 6.0), size=Vec2(20.0, 10.0)) : Node),
  )
  entity_draft.add((UiTargetCamera(camera) : UiTargetCamera))
  let entity = @ecs_test.spawn_draft(entity_draft)

  ui_layout_system(world~, 0.0)

  let global = global_ui_node(entity).unwrap()
  inspect(global.screen_rect.position.x == 24.0, content="true")
  inspect(global.screen_rect.position.y == 16.0, content="true")
  inspect(global.target_camera == Some(camera), content="true")

  cleanup_layout_test_entity(entity)
  ignore(@ecs_test.delete(camera))
}

///|
test "ui layout clamps scroll positions to overflowing content" {
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node::absolute(Vec2(0.0, 0.0), size=Vec2(100.0, 100.0), overflow_y=Scroll),
  )
  let child = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(100.0), height=Val::px(300.0), flex_shrink=0.0),
    parent~,
  )
  set_scroll_position(world~, parent, { x: 80.0, y: 1000.0, })

  ui_layout_system(world~, 0.0)

  let scroll = scroll_position(parent).unwrap()
  debug_inspect([scroll.x, scroll.y], content="[0, 200]")
  let initial = computed_ui_node(parent).unwrap()
  assert_eq(initial.max_scroll_position, Vec2(0.0, 200.0))
  assert_eq(initial.max_scroll_position, Vec2(scroll.x, scroll.y))

  world.set_component(
    parent,
    (
      Node::absolute(Vec2(0.0, 0.0), size=Vec2(100.0, 250.0), overflow_y=Scroll) :
      Node),
  )
  ui_layout_system(world~, 0.0)
  let resized = computed_ui_node(parent).unwrap()
  debug_inspect(
    [resized.max_scroll_position.y, scroll_position(parent).unwrap().y],
    content="[50, 50]",
  )

  world.set_component(
    child,
    (Node(width=Val::px(100.0), height=Val::px(120.0), flex_shrink=0.0) : Node),
  )
  ui_layout_system(world~, 0.0)
  let shrunk = computed_ui_node(parent).unwrap()
  debug_inspect(
    [shrunk.max_scroll_position.y, scroll_position(parent).unwrap().y],
    content="[0, 0]",
  )

  world.set_component(
    child,
    (Node(width=Val::px(100.0), height=Val::px(300.0), flex_shrink=0.0) : Node),
  )
  set_scroll_position(world~, parent, { x: 0.0, y: 70.0, })
  world.set_component(
    parent,
    (
      Node::absolute(Vec2(0.0, 0.0), size=Vec2(100.0, 100.0), overflow_y=Hidden) :
      Node),
  )
  ui_layout_system(world~, 0.0)
  let disabled = computed_ui_node(parent).unwrap()
  debug_inspect(
    [disabled.max_scroll_position.y, scroll_position(parent).unwrap().y],
    content="[0, 0]",
  )

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(parent)
}

///|
test "ui scrolling preserves nested border and padding offsets" {
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node::absolute(
      Vec2(10.0, 20.0),
      size=Vec2(100.0, 100.0),
      padding=UiRectValues::all(6.0),
      border=UiRectValues::all(2.0),
      overflow_y=Scroll,
    ),
  )
  let child = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(84.0), height=Val::px(300.0), flex_shrink=0.0),
    parent~,
  )
  set_scroll_position(world~, parent, { x: 0.0, y: 20.0, })

  ui_layout_system(world~, 0.0)

  assert_eq(computed_ui_node(child).unwrap().position, Vec2(18.0, 8.0))
  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(parent)
}

///|
test "ui override clip ignores inherited clipping rectangles" {
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node::absolute(
      Vec2(0.0, 0.0),
      size=Vec2(120.0, 120.0),
      overflow_x=Hidden,
      overflow_y=Hidden,
    ),
  )
  let child = @ecs_test.spawn(
    @ecs.require_current_world(),
    (Node::absolute(Vec2(90.0, 20.0), size=Vec2(80.0, 40.0)), OverrideClip()),
    parent~,
  )

  ui_layout_system(world~, 0.0)

  inspect(calculated_clips().contains(parent), content="true")
  inspect(calculated_clips().contains(child), content="false")

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(parent)
}
