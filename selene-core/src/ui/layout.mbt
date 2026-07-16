///|
fn val_to_dimension(value : Val) -> @style.Dimension {
  match value {
    Auto => @style_helpers.auto()
    Px(value) => @style_helpers.length(@cmp.maximum(0.0, value))
    Percent(value) => @style_helpers.percent(value)
  }
}

///|
fn rect_values_to_taffy(
  rect : UiRectValues,
) -> @geometry.Rect[@style.Dimension] {
  Rect(
    left=val_to_dimension(rect.left),
    right=val_to_dimension(rect.right),
    top=val_to_dimension(rect.top),
    bottom=val_to_dimension(rect.bottom),
  )
}

///|
fn align_items_to_taffy(value : AlignItems) -> @style.AlignItems {
  match value {
    Start => @style_helpers.align_items_start()
    End => @style_helpers.align_items_end()
    FlexStart => @style_helpers.align_items_flex_start()
    FlexEnd => @style_helpers.align_items_flex_end()
    Center => @style_helpers.align_items_center()
    Baseline => @style_helpers.align_items_baseline()
    Stretch => @style_helpers.align_items_stretch()
  }
}

///|
fn align_content_to_taffy(value : AlignContent) -> @style.AlignContent {
  match value {
    Start => @style_helpers.align_content_start()
    End => @style_helpers.align_content_end()
    FlexStart => @style_helpers.align_content_flex_start()
    FlexEnd => @style_helpers.align_content_flex_end()
    Center => @style_helpers.align_content_center()
    Stretch => @style_helpers.align_content_stretch()
    SpaceBetween => @style_helpers.align_content_space_between()
    SpaceAround => @style_helpers.align_content_space_around()
    SpaceEvenly => @style_helpers.align_content_space_evenly()
  }
}

///|
fn justify_content_to_taffy(value : JustifyContent) -> @style.AlignContent {
  match value {
    Start => @style_helpers.justify_content_start()
    End => @style_helpers.justify_content_end()
    FlexStart => @style_helpers.justify_content_flex_start()
    FlexEnd => @style_helpers.justify_content_flex_end()
    Center => @style_helpers.justify_content_center()
    Stretch => @style_helpers.justify_content_stretch()
    SpaceBetween => @style_helpers.justify_content_space_between()
    SpaceAround => @style_helpers.justify_content_space_around()
    SpaceEvenly => @style_helpers.justify_content_space_evenly()
  }
}

///|
fn flex_wrap_to_taffy(value : FlexWrap) -> @style.FlexWrap {
  match value {
    NoWrap => @style_helpers.flex_wrap_no_wrap()
    Wrap => @style_helpers.flex_wrap_wrap()
    WrapReverse => @style_helpers.flex_wrap_wrap_reverse()
  }
}

///|
fn grid_auto_flow_to_taffy(value : GridAutoFlow) -> @style.GridAutoFlow {
  match value {
    Row => @style_helpers.grid_auto_flow_row()
    Column => @style_helpers.grid_auto_flow_column()
    RowDense => @style_helpers.grid_auto_flow_row_dense()
    ColumnDense => @style_helpers.grid_auto_flow_column_dense()
  }
}

///|
fn grid_track_repetition_to_taffy(
  value : GridTrackRepetition,
) -> @style.GridTrackRepetition {
  match value {
    Count(count) => @style_helpers.repeat_count(count)
    AutoFill => @style_helpers.repeat_auto_fill()
    AutoFit => @style_helpers.repeat_auto_fit()
  }
}

///|
fn grid_track_to_taffy(value : GridTrack) -> @style.Dimension {
  match value {
    Auto => @style_helpers.auto()
    Px(value) => @style_helpers.length(@cmp.maximum(0.0, value))
    Percent(value) => @style_helpers.percent(value)
    Fr(value) => @style_helpers.fr(@cmp.maximum(0.0, value))
    MinContent => @style_helpers.grid_min_content()
    MaxContent => @style_helpers.grid_max_content()
    FitContent(track) => @style_helpers.fit_content(grid_track_to_taffy(track))
    MinMax(min, max) =>
      @style_helpers.minmax(grid_track_to_taffy(min), grid_track_to_taffy(max))
    Repeat(repetition, tracks) =>
      @style_helpers.repeat(
        grid_track_repetition_to_taffy(repetition),
        tracks.map(grid_track_to_taffy),
      )
  }
}

///|
fn grid_placement_to_taffy(value : GridPlacement) -> @style.GridPlacement {
  match value {
    Auto => @style_helpers.place_auto()
    Line(value) => @style_helpers.line(value)
    Span(value) => @style_helpers.span(value)
  }
}

///|
fn grid_line_to_taffy(value : GridLine) -> @geometry.Line[@style.GridPlacement] {
  Line(
    start=grid_placement_to_taffy(value.start),
    end=grid_placement_to_taffy(value.end),
  )
}

///|
fn resolve_val(value : Val, basis : Double) -> Double {
  match value {
    Auto => 0.0
    Px(value) => @cmp.maximum(0.0, value)
    Percent(value) => @cmp.maximum(0.0, basis * value)
  }
}

///|
fn resolve_insets(rect : UiRectValues, size : @math.Vec2) -> UiInsets {
  {
    left: resolve_val(rect.left, size[X]),
    right: resolve_val(rect.right, size[X]),
    top: resolve_val(rect.top, size[Y]),
    bottom: resolve_val(rect.bottom, size[Y]),
  }
}

///|
fn node_to_taffy_style(node : Node) -> @style.Style {
  let mut style = @style.Style::default()
    .with_display(
      match node.display {
        Block => @style_helpers.display_block()
        Flex => @style_helpers.display_flex()
        Grid => @style_helpers.display_grid()
        None => @style_helpers.display_none()
      },
    )
    .with_position(
      match node.position_type {
        Relative => @style_helpers.position_relative()
        Absolute => @style_helpers.position_absolute()
      },
    )
    .with_size(
      Size(
        width=val_to_dimension(node.width),
        height=val_to_dimension(node.height),
      ),
    )
    .with_min_size(
      Size(
        width=val_to_dimension(node.min_width),
        height=val_to_dimension(node.min_height),
      ),
    )
    .with_max_size(
      Size(
        width=val_to_dimension(node.max_width),
        height=val_to_dimension(node.max_height),
      ),
    )
    .with_margin(rect_values_to_taffy(node.margin))
    .with_padding(rect_values_to_taffy(node.padding))
    .with_border(rect_values_to_taffy(node.border))
    .with_inset(
      rect_values_to_taffy(
        UiRectValues(
          left=node.left,
          right=node.right,
          top=node.top,
          bottom=node.bottom,
        ),
      ),
    )
    .with_flex_direction(
      match node.flex_direction {
        Row => @style_helpers.flex_direction_row()
        RowReverse => @style_helpers.flex_direction_row_reverse()
        Column => @style_helpers.flex_direction_column()
        ColumnReverse => @style_helpers.flex_direction_column_reverse()
      },
    )
    .with_justify_content(justify_content_to_taffy(node.justify_content))
    .with_align_items(align_items_to_taffy(node.align_items))
    .with_gap(
      Size(
        width=@style_helpers.length(@cmp.maximum(0.0, node.column_gap)),
        height=@style_helpers.length(@cmp.maximum(0.0, node.row_gap)),
      ),
    )
    .with_flex_wrap(flex_wrap_to_taffy(node.flex_wrap))
    .with_flex_basis(val_to_dimension(node.flex_basis))
    .with_flex_grow(node.flex_grow)
    .with_flex_shrink(node.flex_shrink)
    .with_scrollbar_width(@cmp.maximum(0.0, node.scrollbar_width))
    .with_grid_template_rows(node.grid_template_rows.map(grid_track_to_taffy))
    .with_grid_template_columns(
      node.grid_template_columns.map(grid_track_to_taffy),
    )
    .with_grid_auto_rows(node.grid_auto_rows.map(grid_track_to_taffy))
    .with_grid_auto_columns(node.grid_auto_columns.map(grid_track_to_taffy))
    .with_grid_auto_flow(grid_auto_flow_to_taffy(node.grid_auto_flow))
    .with_grid_row(grid_line_to_taffy(node.grid_row))
    .with_grid_column(grid_line_to_taffy(node.grid_column))
    .with_overflow(
      Point(
        x=match node.overflow_x {
          Visible => @style_helpers.overflow_visible()
          Clip => @style_helpers.overflow_clip()
          Hidden => @style_helpers.overflow_hidden()
          Scroll => @style_helpers.overflow_scroll()
        },
        y=match node.overflow_y {
          Visible => @style_helpers.overflow_visible()
          Clip => @style_helpers.overflow_clip()
          Hidden => @style_helpers.overflow_hidden()
          Scroll => @style_helpers.overflow_scroll()
        },
      ),
    )
  if node.align_content is Some(value) {
    style = style.with_align_content(align_content_to_taffy(value))
  }
  if node.align_self is Some(value) {
    style = style.with_align_self(align_items_to_taffy(value))
  }
  if node.justify_items is Some(value) {
    style = style.with_justify_items(align_items_to_taffy(value))
  }
  if node.justify_self is Some(value) {
    style = style.with_justify_self(align_items_to_taffy(value))
  }
  if node.aspect_ratio is Some(value) && value > 0.0 {
    style = style.with_aspect_ratio(value)
  }
  style
}

///|
fn implicit_root_style(size : @math.Vec2) -> @style.Style {
  @style.Style::default()
  .with_display(@style_helpers.display_flex())
  .with_size(
    Size(
      width=@style_helpers.length(size[X]),
      height=@style_helpers.length(size[Y]),
    ),
  )
  .with_min_size(
    Size(
      width=@style_helpers.length(size[X]),
      height=@style_helpers.length(size[Y]),
    ),
  )
}

///|
fn measure_node(
  known_dimensions : @geometry.Size[Double?],
  _available : @geometry.Size[@geometry.AvailableSpace],
  _node_id : Int,
  entity : @entity.Entity?,
  _style : @style.Style,
) -> @geometry.Size[Double] {
  guard entity is Some(entity) else { return @geometry.Size::zero() }
  let (intrinsic_width, intrinsic_height) = if texts().get(entity) is Some(text) {
    let measured = @platform_render.measure_text(
      text_style_for(entity).unwrap_or({
        font: None,
        family: "Arial",
        size: 16.0,
        color: rgba(255, 255, 255, 1.0),
        align: Left,
        baseline: Top,
      }),
      text.content,
    )
    (measured[X], measured[Y])
  } else if ui_images().get(entity) is Some(image) {
    (image.size[X], image.size[Y])
  } else {
    (0.0, 0.0)
  }
  Size(
    width=known_dimensions.width.unwrap_or(intrinsic_width),
    height=known_dimensions.height.unwrap_or(intrinsic_height),
  )
}

///|
fn build_taffy_tree(
  taffy : @tree.TaffyTree[@entity.Entity],
  entity : @entity.Entity,
  entity_to_node_id : Map[@entity.Entity, Int],
) -> Int? {
  guard nodes().get(entity) is Some(node) else { return None }
  guard node.active else { return None }
  let child_ids : Array[Int] = []
  for child in ui_children(entity) {
    if build_taffy_tree(taffy, child, entity_to_node_id) is Some(child_id) {
      child_ids.push(child_id)
    }
  }
  let node_id = taffy.new_with_children(node_to_taffy_style(node), child_ids)
  ignore(taffy.set_node_context(node_id, entity)) catch {
    _ => ()
  }
  entity_to_node_id.set(entity, node_id)
  Some(node_id)
}

///|
fn rect_intersection(lhs : @math.Rect, rhs : @math.Rect) -> @math.Rect? {
  let left = @cmp.maximum(lhs.position[X], rhs.position[X])
  let top = @cmp.maximum(lhs.position[Y], rhs.position[Y])
  let right = @cmp.minimum(
    lhs.position[X] + lhs.size[X],
    rhs.position[X] + rhs.size[X],
  )
  let bottom = @cmp.minimum(
    lhs.position[Y] + lhs.size[Y],
    rhs.position[Y] + rhs.size[Y],
  )
  if right <= left || bottom <= top {
    None
  } else {
    Some({
      position: Vec2(left, top),
      size: Vec2(right - left, bottom - top),
    })
  }
}

///|
fn clip_rect_for_node(
  logical_rect : @math.Rect,
  logical_content_rect : @math.Rect,
  border : UiInsets,
  node : Node,
  layout_space : UiLayoutSpace,
  use_rounding : Bool,
) -> @math.Rect {
  let base_rect = match node.overflow_clip_margin.visual_box {
    ContentBox => logical_content_rect
    PaddingBox =>
      {
        position: Vec2(
          logical_rect.position[X] + border.left,
          logical_rect.position[Y] + border.top,
        ),
        size: Vec2(
          @cmp.maximum(0.0, logical_rect.size[X] - border.left - border.right),
          @cmp.maximum(0.0, logical_rect.size[Y] - border.top - border.bottom),
        ),
      }
    BorderBox => logical_rect
  }
  let margin = node.overflow_clip_margin.margin
  screen_rect_for(
    {
      position: Vec2(
        base_rect.position[X] - margin,
        base_rect.position[Y] - margin,
      ),
      size: Vec2(
        @cmp.maximum(0.0, base_rect.size[X] + margin * 2.0),
        @cmp.maximum(0.0, base_rect.size[Y] + margin * 2.0),
      ),
    },
    layout_space,
    use_rounding,
  )
}

///|
fn rounded_screen_rect(rect : @math.Rect) -> @math.Rect {
  let left = rect.position[X].round()
  let top = rect.position[Y].round()
  let right = (rect.position[X] + rect.size[X]).round()
  let bottom = (rect.position[Y] + rect.size[Y]).round()
  {
    position: Vec2(left, top),
    size: Vec2(
      @cmp.maximum(0.0, right - left),
      @cmp.maximum(0.0, bottom - top),
    ),
  }
}

///|
fn screen_rect_for(
  logical_rect : @math.Rect,
  layout_space : UiLayoutSpace,
  use_rounding : Bool,
) -> @math.Rect {
  let screen_rect = to_screen_rect(logical_rect, layout_space)
  if use_rounding {
    rounded_screen_rect(screen_rect)
  } else {
    screen_rect
  }
}

///|
fn cleanup_dead_ui_state() -> Unit {
  for pair in nodes().to_array() {
    if !pair.0.is_alive() {
      nodes().remove(pair.0)
    }
  }
  for pair in computed_ui_nodes().to_array() {
    if !pair.0.is_alive() {
      computed_ui_nodes().remove(pair.0)
    }
  }
  for pair in global_ui_nodes().to_array() {
    if !pair.0.is_alive() {
      global_ui_nodes().remove(pair.0)
    }
  }
  for pair in ui_target_cameras().to_array() {
    if !pair.0.is_alive() {
      ui_target_cameras().remove(pair.0)
    }
  }
  for pair in z_indexes().to_array() {
    if !pair.0.is_alive() {
      z_indexes().remove(pair.0)
    }
  }
  for pair in global_zindexes().to_array() {
    if !pair.0.is_alive() {
      global_zindexes().remove(pair.0)
    }
  }
  for pair in scroll_positions().to_array() {
    if !pair.0.is_alive() {
      scroll_positions().remove(pair.0)
    }
  }
  for pair in tab_indexes().to_array() {
    if !pair.0.is_alive() {
      tab_indexes().remove(pair.0)
    }
  }
  for pair in focus_policies().to_array() {
    if !pair.0.is_alive() {
      focus_policies().remove(pair.0)
    }
  }
  for pair in focusables().to_array() {
    if !pair.0.is_alive() {
      focusables().remove(pair.0)
    }
  }
  for pair in focuseds().to_array() {
    if !pair.0.is_alive() {
      focuseds().remove(pair.0)
    }
  }
  for pair in override_clips().to_array() {
    if !pair.0.is_alive() {
      override_clips().remove(pair.0)
    }
  }
  for pair in relative_cursor_positions().to_array() {
    if !pair.0.is_alive() {
      relative_cursor_positions().remove(pair.0)
    }
  }
  for pair in background_colors().to_array() {
    if !pair.0.is_alive() {
      background_colors().remove(pair.0)
    }
  }
  for pair in border_colors().to_array() {
    if !pair.0.is_alive() {
      border_colors().remove(pair.0)
    }
  }
  for pair in border_radii().to_array() {
    if !pair.0.is_alive() {
      border_radii().remove(pair.0)
    }
  }
  for pair in outlines().to_array() {
    if !pair.0.is_alive() {
      outlines().remove(pair.0)
    }
  }
  for pair in material_nodes().to_array() {
    if !pair.0.is_alive() {
      material_nodes().remove(pair.0)
    }
  }
  for pair in ui_images().to_array() {
    if !pair.0.is_alive() {
      ui_images().remove(pair.0)
    }
  }
  for pair in texts().to_array() {
    if !pair.0.is_alive() {
      texts().remove(pair.0)
    }
  }
  for pair in text_fonts().to_array() {
    if !pair.0.is_alive() {
      text_fonts().remove(pair.0)
    }
  }
  for pair in text_colors().to_array() {
    if !pair.0.is_alive() {
      text_colors().remove(pair.0)
    }
  }
  for pair in text_layouts().to_array() {
    if !pair.0.is_alive() {
      text_layouts().remove(pair.0)
    }
  }
  for pair in buttons().to_array() {
    if !pair.0.is_alive() {
      buttons().remove(pair.0)
    }
  }
  for pair in interactions().to_array() {
    if !pair.0.is_alive() {
      interactions().remove(pair.0)
    }
  }
  for pair in calculated_clips().to_array() {
    if !pair.0.is_alive() {
      calculated_clips().remove(pair.0)
    }
  }
  for pair in layout_configs().to_array() {
    if !pair.0.is_alive() {
      layout_configs().remove(pair.0)
    }
  }
  for pair in tree_orders().to_array() {
    if !pair.0.is_alive() {
      tree_orders().remove(pair.0)
    }
  }
}

///|
fn apply_layout_recursive(
  entity : @entity.Entity,
  taffy : @tree.TaffyTree[@entity.Entity],
  entity_to_node_id : Map[@entity.Entity, Int],
  parent_content_origin : @math.Vec2,
  parent_clip : @math.Rect?,
  inherited_use_rounding : Bool,
  order_counter : Ref[Int],
  layout_space : UiLayoutSpace,
) -> Unit {
  guard entity_to_node_id.get(entity) is Some(node_id) else { return }
  guard nodes().get(entity) is Some(node) else { return }
  let effective_layout_space = match ui_target_cameras().get(entity) {
    Some(target) => ui_layout_space(Some(target.camera))
    None => layout_space
  }
  let effective_target_camera = effective_layout_space.target_camera
  let use_rounding = layout_configs()
    .get(entity)
    .map(fn(config) { config.use_rounding })
    .unwrap_or(inherited_use_rounding)
  let layout = taffy.layout(node_id) catch { _ => return }

  let logical_pos = parent_content_origin +
    Vec2(layout.location.x, layout.location.y)
  let logical_size = @math.Vec2(layout.size.width, layout.size.height)
  let logical_rect = @math.Rect::{ position: logical_pos, size: logical_size }

  let border = resolve_insets(node.border, logical_size)
  let padding = resolve_insets(node.padding, logical_size)
  let content_position = @math.Vec2(
    logical_pos[X] + border.left + padding.left,
    logical_pos[Y] + border.top + padding.top,
  )
  let content_size = @math.Vec2(
    @cmp.maximum(
      0.0,
      logical_size[X] -
      border.left -
      border.right -
      padding.left -
      padding.right,
    ),
    @cmp.maximum(
      0.0,
      logical_size[Y] -
      border.top -
      border.bottom -
      padding.top -
      padding.bottom,
    ),
  )
  let logical_content_rect = @math.Rect::{
    position: content_position,
    size: content_size,
  }

  computed_ui_nodes().set(entity, {
    position: logical_pos,
    size: logical_size,
    content_position,
    content_size,
    border,
    padding,
  })
  let screen_rect = screen_rect_for(
    logical_rect, effective_layout_space, use_rounding,
  )
  let screen_content_rect = screen_rect_for(
    logical_content_rect, effective_layout_space, use_rounding,
  )
  global_ui_nodes().set(entity, {
    logical_rect,
    screen_rect,
    logical_content_rect,
    screen_content_rect,
    target_camera: effective_target_camera,
    target_viewport: effective_layout_space.viewport,
  })

  order_counter.val += 1
  tree_orders().set(entity, order_counter.val)

  let inherited_clip : @math.Rect? = if override_clips().contains(entity) {
    None
  } else {
    parent_clip
  }
  let current_clip = if node.overflow_x == Visible && node.overflow_y == Visible {
    inherited_clip
  } else {
    let clip_rect = clip_rect_for_node(
      logical_rect, logical_content_rect, border, node, effective_layout_space, use_rounding,
    )
    match inherited_clip {
      Some(parent) => rect_intersection(parent, clip_rect)
      None => Some(clip_rect)
    }
  }
  match current_clip {
    Some(rect) => calculated_clips().set(entity, CalculatedClip(rect))
    None => calculated_clips().remove(entity)
  }

  let scroll = scroll_positions().get(entity).unwrap_or(ScrollPosition::zero())
  let next_origin = @math.Vec2(
    logical_content_rect.position[X] - scroll.x,
    logical_content_rect.position[Y] - scroll.y,
  )
  for child in ui_children(entity) {
    apply_layout_recursive(
      child, taffy, entity_to_node_id, next_origin, current_clip, use_rounding, order_counter,
      effective_layout_space,
    )
  }
}

///|
pub fn ui_layout_system(_delta : Double) -> Unit {
  cleanup_dead_ui_state()
  computed_ui_nodes().clear()
  global_ui_nodes().clear()
  calculated_clips().clear()
  tree_orders().clear()

  let order_counter : Ref[Int] = Ref(0)
  for root_entity in top_level_ui_nodes() {
    let layout_space = ui_layout_space(
      ui_target_cameras().get(root_entity).map(fn(target) { target.camera }),
    )
    let viewport = ui_layout_root_size(layout_space)
    let taffy : @tree.TaffyTree[@entity.Entity] = TaffyTree()
    let entity_to_node_id : Map[@entity.Entity, Int] = Map([])
    guard build_taffy_tree(taffy, root_entity, entity_to_node_id)
      is Some(root_node) else {
      continue
    }
    let implicit_root = taffy.new_with_children(implicit_root_style(viewport), [
      root_node,
    ])
    ignore(
      taffy.compute_layout_with_measure(
        implicit_root,
        Size(
          width=@style_helpers.available_space_definite(viewport[X]),
          height=@style_helpers.available_space_definite(viewport[Y]),
        ),
        measure_node,
      ),
    ) catch {
      _ => continue
    }
    apply_layout_recursive(
      root_entity,
      taffy,
      entity_to_node_id,
      @math.Vec2::zero(),
      None,
      true,
      order_counter,
      layout_space,
    )
  }
}
