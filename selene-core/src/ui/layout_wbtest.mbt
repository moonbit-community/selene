///|
fn cleanup_layout_test_entity(entity : @entity.Entity) -> Unit {
  nodes.remove(entity)
  computed_ui_nodes.remove(entity)
  global_ui_nodes.remove(entity)
  ui_zindexes.remove(entity)
  scroll_positions.remove(entity)
  focus_policies.remove(entity)
  focusables.remove(entity)
  focuseds.remove(entity)
  background_colors.remove(entity)
  border_colors.remove(entity)
  border_radii.remove(entity)
  box_shadows.remove(entity)
  outlines.remove(entity)
  ui_images.remove(entity)
  texts.remove(entity)
  text_fonts.remove(entity)
  text_colors.remove(entity)
  text_layouts.remove(entity)
  buttons.remove(entity)
  interactions.remove(entity)
  screen_clip_rects.remove(entity)
  tree_orders.remove(entity)
  entity.destroy()
}

///|
test "ui nodes map flex wrap and align content into wrapped layout" {
  let taffy : @moon_taffy.TaffyTree[Unit] = @moon_taffy.TaffyTree::new()
  let mk_child = fn() {
    taffy.new_leaf(
      node_to_taffy_style(Node::new(width=Val::px(50.0), height=Val::px(10.0))),
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
      Node::new(
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
      Node::new(
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
      Node::new(
        display=Display::Block,
        width=Val::px(400.0),
        height=Val::px(300.0),
      ),
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
      Node::new(
        width=Val::px(20.0),
        height=Val::px(20.0),
        grid_row=GridLine::new(start=grid_line_index(1)),
        grid_column=GridLine::new(start=grid_line_index(1)),
      ),
    ),
  )
  let child1 = taffy.new_leaf(
    node_to_taffy_style(
      Node::new(
        width=Val::px(20.0),
        height=Val::px(20.0),
        align_self=Some(AlignItems::Center),
        justify_self=Some(AlignItems::Center),
        grid_row=GridLine::new(start=grid_line_index(3)),
        grid_column=GridLine::new(start=grid_line_index(3)),
      ),
    ),
  )
  let root = taffy.new_with_children(
    node_to_taffy_style(
      Node::new(
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
    Node::new(
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
  let entity = @entity.Entity::new()
  nodes.set(
    entity,
    Node::absolute(
      @math.Vec2D(10.0, 20.0),
      size=@math.Vec2D(100.0, 80.0),
      padding=UiRectValues::px(left=6.0),
      border=UiRectValues::px(left=4.0),
      overflow_x=Overflow::Hidden,
      overflow_y=Overflow::Hidden,
      overflow_clip_margin=OverflowClipMargin::padding_box().with_margin(3.0),
    ),
  )

  ui_layout_system(0.0)

  let clip = screen_clip_rects.get(entity).unwrap()
  inspect(clip.position[X] == 11.0, content="true")
  inspect(clip.position[Y] == 21.0, content="true")
  inspect(clip.size[X] == 98.0, content="true")
  inspect(clip.size[Y] == 78.0, content="true")

  cleanup_layout_test_entity(entity)
}
