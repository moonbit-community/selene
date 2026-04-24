///|
fn cleanup_layout_test_entity(entity : @entity.Entity) -> Unit {
  nodes().remove(entity)
  computed_ui_nodes().remove(entity)
  global_ui_nodes().remove(entity)
  ui_target_cameras().remove(entity)
  calculated_clips().remove(entity)
  layout_configs().remove(entity)
  z_indexes().remove(entity)
  global_zindexes().remove(entity)
  scroll_positions().remove(entity)
  focus_policies().remove(entity)
  focusables().remove(entity)
  focuseds().remove(entity)
  override_clips().remove(entity)
  relative_cursor_positions().remove(entity)
  background_colors().remove(entity)
  border_colors().remove(entity)
  border_radii().remove(entity)
  box_shadows().remove(entity)
  outlines().remove(entity)
  material_nodes().remove(entity)
  ui_images().remove(entity)
  texts().remove(entity)
  text_fonts().remove(entity)
  text_colors().remove(entity)
  text_layouts().remove(entity)
  buttons().remove(entity)
  interactions().remove(entity)
  tree_orders().remove(entity)
  entity.destroy()
}

///|
test "ui nodes map flex wrap and align content into wrapped layout" {
  let taffy : @moon_taffy.TaffyTree[Unit] = @moon_taffy.TaffyTree::new()
  let mk_child = fn() {
    taffy.new_leaf(
      node_to_taffy_style(Node(width=Val::px(50.0), height=Val::px(10.0))),
    )
  }
  let child0 = mk_child()
  let child1 = mk_child()
  let child2 = mk_child()
  let child3 = mk_child()
  let child4 = mk_child()
  let child5 = mk_child()
  let root = taffy.new_with_children(
    node_to_taffy_style(
      Node(
        width=Val::px(120.0),
        height=Val::px(100.0),
        flex_direction=FlexDirection::Row,
        flex_wrap=flex_wrap_wrap(),
        align_content=Some(align_content_center()),
      ),
    ),
    [child0, child1, child2, child3, child4, child5],
  )
  taffy.compute_layout(root, @moon_taffy.Size::max_content())

  let root_layout = taffy.layout(root)
  inspect(root_layout.size.width == 120.0, content="true")
  inspect(root_layout.size.height == 100.0, content="true")

  inspect(taffy.layout(child0).location.y == 35.0, content="true")
  inspect(taffy.layout(child1).location.y == 35.0, content="true")
  inspect(taffy.layout(child2).location.y == 45.0, content="true")
  inspect(taffy.layout(child3).location.y == 45.0, content="true")
  inspect(taffy.layout(child4).location.y == 55.0, content="true")
  inspect(taffy.layout(child5).location.y == 55.0, content="true")
}

///|
test "ui nodes map block display and aspect ratio into block layout" {
  let taffy : @moon_taffy.TaffyTree[Unit] = @moon_taffy.TaffyTree::new()
  let child = taffy.new_leaf(
    node_to_taffy_style(
      Node(
        position_type=PositionType::Absolute,
        left=Val::percent(0.05),
        right=Val::percent(0.05),
        top=Val::percent(0.05),
        bottom=Val::percent(0.05),
        aspect_ratio=Some(3.0),
      ),
    ),
  )
  let root = taffy.new_with_children(
    node_to_taffy_style(
      Node(display=Display::Block, width=Val::px(400.0), height=Val::px(300.0)),
    ),
    [child],
  )
  taffy.compute_layout(root, @moon_taffy.Size::max_content())

  let layout = taffy.layout(child)
  inspect(layout.size.width == 360.0, content="true")
  inspect(layout.size.height == 120.0, content="true")
  inspect(layout.location.x == 20.0, content="true")
  inspect(layout.location.y == 15.0, content="true")
}

///|
test "ui nodes map grid placement and self alignment into grid layout" {
  let taffy : @moon_taffy.TaffyTree[Unit] = @moon_taffy.TaffyTree::new()
  let child0 = taffy.new_leaf(
    node_to_taffy_style(
      Node(
        width=Val::px(20.0),
        height=Val::px(20.0),
        grid_row=GridLine(start=grid_line_index(1)),
        grid_column=GridLine(start=grid_line_index(1)),
      ),
    ),
  )
  let child1 = taffy.new_leaf(
    node_to_taffy_style(
      Node(
        width=Val::px(20.0),
        height=Val::px(20.0),
        align_self=Some(AlignItems::Center),
        justify_self=Some(AlignItems::Center),
        grid_row=GridLine(start=grid_line_index(3)),
        grid_column=GridLine(start=grid_line_index(3)),
      ),
    ),
  )
  let root = taffy.new_with_children(
    node_to_taffy_style(
      Node(
        display=Display::Grid,
        width=Val::px(120.0),
        height=Val::px(120.0),
        align_items=AlignItems::End,
        justify_items=Some(AlignItems::End),
        grid_template_rows=[grid_px(40.0), grid_px(40.0), grid_px(40.0)],
        grid_template_columns=[grid_px(40.0), grid_px(40.0), grid_px(40.0)],
      ),
    ),
    [child0, child1],
  )
  taffy.compute_layout(root, @moon_taffy.Size::max_content())

  let layout0 = taffy.layout(child0)
  inspect(layout0.location.x == 20.0, content="true")
  inspect(layout0.location.y == 20.0, content="true")

  let layout1 = taffy.layout(child1)
  inspect(layout1.location.x == 90.0, content="true")
  inspect(layout1.location.y == 90.0, content="true")
}

///|
test "ui nodes map style-only grid and flex fields into taffy style" {
  let style = node_to_taffy_style(
    Node(
      display=Display::Grid,
      overflow_x=Overflow::Hidden,
      flex_basis=Val::percent(0.25),
      scrollbar_width=12.0,
      grid_auto_rows=[grid_px(16.0)],
      grid_auto_columns=[grid_fr(1.0)],
      grid_auto_flow=grid_auto_flow_column_dense(),
      grid_template_columns=[grid_repeat(grid_repeat_count(2), [grid_px(20.0)])],
    ),
  )

  let has_percent_basis = match style.flex_basis {
    @moon_taffy.DimPercent(value) => value == 0.25
    _ => false
  }
  inspect(has_percent_basis, content="true")
  inspect(style.scrollbar_width == 12.0, content="true")

  let has_auto_row = match style.grid_auto_rows[0] {
    @moon_taffy.DimLength(value) => value == 16.0
    _ => false
  }
  inspect(has_auto_row, content="true")

  let has_auto_column = match style.grid_auto_columns[0] {
    @moon_taffy.DimFr(value) => value == 1.0
    _ => false
  }
  inspect(has_auto_column, content="true")

  let is_column_dense = match style.grid_auto_flow {
    @moon_taffy.ColumnDense => true
    _ => false
  }
  inspect(is_column_dense, content="true")

  let has_repeated_template = match style.grid_template_columns[0] {
    @moon_taffy.DimRepeat(@moon_taffy.RepeatCount(2), tracks) => {
      let has_single_track = tracks.length() == 1
      let has_length_track = if has_single_track {
        match tracks[0] {
          @moon_taffy.DimLength(value) => value == 20.0
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
    @moon_taffy.OverflowHidden => true
    _ => false
  }
  inspect(has_hidden_overflow, content="true")
}

///|
test "ui layout uses overflow clip margins from the requested visual box" {
  let entity = @entity.Entity()
  nodes().set(
    entity,
    Node::absolute(
      @math.Vec2(10.0, 20.0),
      size=@math.Vec2(100.0, 80.0),
      padding=UiRectValues::px(left=6.0),
      border=UiRectValues::px(left=4.0),
      overflow_x=Overflow::Hidden,
      overflow_y=Overflow::Hidden,
      overflow_clip_margin=OverflowClipMargin::padding_box().with_margin(3.0),
    ),
  )

  ui_layout_system(0.0)

  let clip = calculated_clips().get(entity).unwrap().clip
  inspect(clip.position[X] == 11.0, content="true")
  inspect(clip.position[Y] == 21.0, content="true")
  inspect(clip.size[X] == 98.0, content="true")
  inspect(clip.size[Y] == 78.0, content="true")

  cleanup_layout_test_entity(entity)
}

///|
test "ui layout config controls screen-space rounding for viewport-scaled rects" {
  let old_scale_mode = get_ui_scale_mode()
  let old_viewport = @system.get_viewport_size()
  let old_zoom = @system.get_zoom()
  set_ui_scale_mode(Viewport)
  @system.configure_display(101.0, 101.0, 1.5)

  let logical_rect : @math.Rect = {
    position: @math.Vec2(33.835, 33.835),
    size: @math.Vec2(10.0, 10.0),
  }
  let rounded_rect = screen_rect_for(
    logical_rect,
    ui_layout_space(None),
    LayoutConfig().use_rounding,
  )
  inspect(rounded_rect.position[X] == 51.0, content="true")
  inspect(rounded_rect.position[Y] == 51.0, content="true")

  let unrounded_rect = screen_rect_for(
    logical_rect,
    ui_layout_space(None),
    LayoutConfig(use_rounding=false).use_rounding,
  )
  let expected = 33.835 * 1.5
  inspect(
    (unrounded_rect.position[X] - expected).abs() < 0.000001,
    content="true",
  )
  inspect(
    (unrounded_rect.position[Y] - expected).abs() < 0.000001,
    content="true",
  )

  set_ui_scale_mode(old_scale_mode)
  @system.configure_display(old_viewport[X], old_viewport[Y], old_zoom)
}

///|
test "ui target camera layouts use the camera viewport as screen-space origin" {
  @system.configure_display(200.0, 120.0, 1.0)
  let camera = @entity.Entity()
  @camera.cameras().set(
    camera,
    @camera.Camera(
      viewport=Some(
        @camera.CameraViewport(@math.Vec2(20.0, 10.0), @math.Vec2(80.0, 40.0)),
      ),
    ),
  )
  @camera.camera2ds().set(camera, @camera.Camera2d())
  @transform.global_transforms().set(
    camera,
    @transform.GlobalTransform::from_transform(@transform.Transform::default()),
  )

  let entity = @entity.Entity()
  nodes().set(
    entity,
    Node::absolute(@math.Vec2(4.0, 6.0), size=@math.Vec2(20.0, 10.0)),
  )
  ui_target_cameras().set(entity, UiTargetCamera(camera))

  ui_layout_system(0.0)

  let global = global_ui_nodes().get(entity).unwrap()
  inspect(global.screen_rect.position[X] == 24.0, content="true")
  inspect(global.screen_rect.position[Y] == 16.0, content="true")
  inspect(global.target_camera == Some(camera), content="true")

  cleanup_layout_test_entity(entity)
  @camera.cameras().remove(camera)
  @camera.camera2ds().remove(camera)
  @transform.global_transforms().remove(camera)
  camera.destroy()
}

///|
test "ui override clip ignores inherited clipping rectangles" {
  let parent = @entity.Entity()
  let child = parent.spawn_child()

  nodes().set(
    parent,
    Node::absolute(
      @math.Vec2(0.0, 0.0),
      size=@math.Vec2(120.0, 120.0),
      overflow_x=Overflow::Hidden,
      overflow_y=Overflow::Hidden,
    ),
  )
  nodes().set(
    child,
    Node::absolute(@math.Vec2(90.0, 20.0), size=@math.Vec2(80.0, 40.0)),
  )
  override_clips().set(child, OverrideClip())

  ui_layout_system(0.0)

  inspect(calculated_clips().contains(parent), content="true")
  inspect(calculated_clips().contains(child), content="false")

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(parent)
}
