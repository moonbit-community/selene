///|
fn val_to_dimension(value : Val) -> @style.Dimension {
  match value {
    Auto => @style_helpers.auto()
    Px(value) => @style_helpers.length(@cmp.maximum(0.0, value))
    Percent(value) => @style_helpers.percent(value)
  }
}

///|
fn rect_values_to_chicle(
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
fn align_items_to_chicle(value : AlignItems) -> @style.AlignItems {
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
fn align_content_to_chicle(value : AlignContent) -> @style.AlignContent {
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
fn justify_content_to_chicle(value : JustifyContent) -> @style.AlignContent {
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
fn flex_wrap_to_chicle(value : FlexWrap) -> @style.FlexWrap {
  match value {
    NoWrap => @style_helpers.flex_wrap_no_wrap()
    Wrap => @style_helpers.flex_wrap_wrap()
    WrapReverse => @style_helpers.flex_wrap_wrap_reverse()
  }
}

///|
fn grid_auto_flow_to_chicle(value : GridAutoFlow) -> @style.GridAutoFlow {
  match value {
    Row => @style_helpers.grid_auto_flow_row()
    Column => @style_helpers.grid_auto_flow_column()
    RowDense => @style_helpers.grid_auto_flow_row_dense()
    ColumnDense => @style_helpers.grid_auto_flow_column_dense()
  }
}

///|
fn grid_track_repetition_to_chicle(
  value : GridTrackRepetition,
) -> @style.GridTrackRepetition {
  match value {
    Count(count) => @style_helpers.repeat_count(count)
    AutoFill => @style_helpers.repeat_auto_fill()
    AutoFit => @style_helpers.repeat_auto_fit()
  }
}

///|
fn grid_track_to_chicle(value : GridTrack) -> @style.Dimension {
  match value {
    Auto => @style_helpers.auto()
    Px(value) => @style_helpers.length(@cmp.maximum(0.0, value))
    Percent(value) => @style_helpers.percent(value)
    Fr(value) => @style_helpers.fr(@cmp.maximum(0.0, value))
    MinContent => @style_helpers.grid_min_content()
    MaxContent => @style_helpers.grid_max_content()
    FitContent(track) => @style_helpers.fit_content(grid_track_to_chicle(track))
    MinMax(min, max) =>
      @style_helpers.minmax(
        grid_track_to_chicle(min),
        grid_track_to_chicle(max),
      )
    Repeat(repetition, tracks) =>
      @style_helpers.repeat(
        grid_track_repetition_to_chicle(repetition),
        tracks.map(grid_track_to_chicle),
      )
  }
}

///|
fn grid_placement_to_chicle(value : GridPlacement) -> @style.GridPlacement {
  match value {
    Auto => @style_helpers.place_auto()
    Line(value) => @style_helpers.line(value)
    Span(value) => @style_helpers.span(value)
  }
}

///|
fn grid_line_to_chicle(
  value : GridLine,
) -> @geometry.Line[@style.GridPlacement] {
  Line(
    start=grid_placement_to_chicle(value.start),
    end=grid_placement_to_chicle(value.end),
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
    left: resolve_val(rect.left, size.x),
    right: resolve_val(rect.right, size.x),
    top: resolve_val(rect.top, size.y),
    bottom: resolve_val(rect.bottom, size.y),
  }
}

///|
fn node_to_chicle_style(node : Node) -> @style.Style {
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
    .with_margin(rect_values_to_chicle(node.margin))
    .with_padding(rect_values_to_chicle(node.padding))
    .with_border(rect_values_to_chicle(node.border))
    .with_inset(
      rect_values_to_chicle(
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
    .with_justify_content(justify_content_to_chicle(node.justify_content))
    .with_align_items(align_items_to_chicle(node.align_items))
    .with_gap(
      Size(
        width=@style_helpers.length(@cmp.maximum(0.0, node.column_gap)),
        height=@style_helpers.length(@cmp.maximum(0.0, node.row_gap)),
      ),
    )
    .with_flex_wrap(flex_wrap_to_chicle(node.flex_wrap))
    .with_flex_basis(val_to_dimension(node.flex_basis))
    .with_flex_grow(node.flex_grow)
    .with_flex_shrink(node.flex_shrink)
    .with_scrollbar_width(@cmp.maximum(0.0, node.scrollbar_width))
    .with_grid_template_rows(node.grid_template_rows.map(grid_track_to_chicle))
    .with_grid_template_columns(
      node.grid_template_columns.map(grid_track_to_chicle),
    )
    .with_grid_auto_rows(node.grid_auto_rows.map(grid_track_to_chicle))
    .with_grid_auto_columns(node.grid_auto_columns.map(grid_track_to_chicle))
    .with_grid_auto_flow(grid_auto_flow_to_chicle(node.grid_auto_flow))
    .with_grid_row(grid_line_to_chicle(node.grid_row))
    .with_grid_column(grid_line_to_chicle(node.grid_column))
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
    style = style.with_align_content(align_content_to_chicle(value))
  }
  if node.align_self is Some(value) {
    style = style.with_align_self(align_items_to_chicle(value))
  }
  if node.justify_items is Some(value) {
    style = style.with_justify_items(align_items_to_chicle(value))
  }
  if node.justify_self is Some(value) {
    style = style.with_justify_self(align_items_to_chicle(value))
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
      width=@style_helpers.length(size.x),
      height=@style_helpers.length(size.y),
    ),
  )
  .with_min_size(
    Size(
      width=@style_helpers.length(size.x),
      height=@style_helpers.length(size.y),
    ),
  )
}

///|
fn measure_node(
  world~ : @ecs.World,
  known_dimensions : @geometry.Size[Double?],
  available : @geometry.Size[@geometry.AvailableSpace],
  _node_id : Int32,
  entity : @ecs.Entity?,
  style : @style.Style,
) -> @geometry.Size[Double] {
  guard entity is Some(entity) else { return @geometry.Size::zero() }
  let (intrinsic_width, intrinsic_height) = if (
      world.get_component(entity) : Text?)
    is Some(text) {
    let text_style = text_style_for(world~, entity).unwrap_or({
      font: None,
      family: "Arial",
      size: 16.0,
      color: rgba(255, 255, 255, 1.0),
      align: Left,
      baseline: Top,
    })
    let width_basis = known_dimensions.width.unwrap_or(
      match available.width {
        AvailDefinite(width) => width
        _ => 0.0
      },
    )
    let horizontal_inset = @util.resolve_dimension_width_basis(
        style.padding.left,
        width_basis,
      ) +
      @util.resolve_dimension_width_basis(style.padding.right, width_basis) +
      @util.resolve_dimension_width_basis(style.border.left, width_basis) +
      @util.resolve_dimension_width_basis(style.border.right, width_basis)
    let available_content_width = match known_dimensions.width {
      Some(width) =>
        @style_helpers.available_space_definite(
          @cmp.maximum(0.0, width - horizontal_inset),
        )
      None =>
        match available.width {
          AvailDefinite(width) =>
            @style_helpers.available_space_definite(
              @cmp.maximum(0.0, width - horizontal_inset),
            )
          constraint => constraint
        }
    }
    let prepared = prepare_text_layout(
      text.content,
      text_style,
      text_layout(world~, entity),
      available_content_width,
    )
    (prepared.width, prepared.height)
  } else if (world.get_component(entity) : UiImage?) is Some(image) {
    (image.size.x, image.size.y)
  } else {
    (0.0, 0.0)
  }
  Size(
    width=known_dimensions.width.unwrap_or(intrinsic_width),
    height=known_dimensions.height.unwrap_or(intrinsic_height),
  )
}

///|
fn rect_intersection(lhs : @math.Rect, rhs : @math.Rect) -> @math.Rect? {
  let left = @cmp.maximum(lhs.position.x, rhs.position.x)
  let top = @cmp.maximum(lhs.position.y, rhs.position.y)
  let right = @cmp.minimum(
    lhs.position.x + lhs.size.x,
    rhs.position.x + rhs.size.x,
  )
  let bottom = @cmp.minimum(
    lhs.position.y + lhs.size.y,
    rhs.position.y + rhs.size.y,
  )
  if right <= left || bottom <= top {
    None
  } else {
    Some({ position: Vec2(left, top), size: Vec2(right - left, bottom - top), })
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
          logical_rect.position.x + border.left,
          logical_rect.position.y + border.top,
        ),
        size: Vec2(
          @cmp.maximum(0.0, logical_rect.size.x - border.left - border.right),
          @cmp.maximum(0.0, logical_rect.size.y - border.top - border.bottom),
        ),
      }
    BorderBox => logical_rect
  }
  let margin = node.overflow_clip_margin.margin
  screen_rect_for(
    {
      position: Vec2(
        base_rect.position.x - margin,
        base_rect.position.y - margin,
      ),
      size: Vec2(
        @cmp.maximum(0.0, base_rect.size.x + margin * 2.0),
        @cmp.maximum(0.0, base_rect.size.y + margin * 2.0),
      ),
    },
    layout_space,
    use_rounding,
  )
}

///|
fn rounded_screen_rect(rect : @math.Rect) -> @math.Rect {
  let left = rect.position.x.round()
  let top = rect.position.y.round()
  let right = (rect.position.x + rect.size.x).round()
  let bottom = (rect.position.y + rect.size.y).round()
  {
    position: Vec2(left, top),
    size: Vec2(@cmp.maximum(0.0, right - left), @cmp.maximum(0.0, bottom - top)),
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
  let alive = @ecs.alive_in_world(@ecs.require_current_world())
  focuseds().retain((entity, _) => alive(entity))
  interactions().retain((entity, _) => alive(entity))
  let world = @ecs.require_current_world()
  scroll_positions().retain((entity, _) => entity.is_valid_in(world))
}

///|
fn apply_layout_recursive(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  chicle : @tree.ChicleTree[@ecs.Entity],
  layout_nodes : @ecs.EntityTable[UiLayoutNodeRuntime],
  parent_layout_origin : @math.Vec2,
  parent_clip : @math.Rect?,
  inherited_use_rounding : Bool,
  layout_space : UiLayoutSpace,
  projected : Set[@ecs.Entity],
) -> Unit {
  let query_node : @ecs.Query[Node] = world.query()
  let query_ui_target_camera : @ecs.Query[UiTargetCamera] = world.query()
  let query_layout_config : @ecs.Query[LayoutConfig] = world.query()
  let query_override_clip : @ecs.Query[OverrideClip] = world.query()
  guard layout_nodes.get(entity) is Some(runtime_node) else { return }
  let node_id = runtime_node.node_id
  guard query_node.get(entity) is Some(node) else { return }
  let effective_layout_space = match query_ui_target_camera.get(entity) {
    Some(target) => ui_layout_space(world~, Some(target.camera))
    None => layout_space
  }
  let effective_target_camera = effective_layout_space.target_camera
  let use_rounding = query_layout_config
    .get(entity)
    .map(fn(config) { config.use_rounding })
    .unwrap_or(inherited_use_rounding)
  let layout = chicle.layout(node_id) catch { _ => return }
  projected.add(entity)

  let logical_pos = parent_layout_origin +
    Vec2(layout.location.x, layout.location.y)
  let logical_size = @math.Vec2(layout.size.width, layout.size.height)
  let logical_rect = @math.Rect::{ position: logical_pos, size: logical_size, }

  let border = resolve_insets(node.border, logical_size)
  let padding = resolve_insets(node.padding, logical_size)
  let content_position = @math.Vec2(
    logical_pos.x + border.left + padding.left,
    logical_pos.y + border.top + padding.top,
  )
  let content_size = @math.Vec2(
    @cmp.maximum(
      0.0,
      logical_size.x - border.left - border.right - padding.left - padding.right,
    ),
    @cmp.maximum(
      0.0,
      logical_size.y - border.top - border.bottom - padding.top - padding.bottom,
    ),
  )
  let logical_content_rect = @math.Rect::{
    position: content_position,
    size: content_size,
  }
  let max_scroll_position = @math.Vec2(
    if node.overflow_x == Scroll {
      layout.scroll_width()
    } else {
      0.0
    },
    if node.overflow_y == Scroll {
      layout.scroll_height()
    } else {
      0.0
    },
  )
  let mut effective_scroll_position = @math.Vec2::zero()
  if scroll_positions().get(entity) is Some(scroll) {
    scroll.x = @cmp.minimum(max_scroll_position.x, @cmp.maximum(0.0, scroll.x))
    scroll.y = @cmp.minimum(max_scroll_position.y, @cmp.maximum(0.0, scroll.y))
    effective_scroll_position = Vec2(scroll.x, scroll.y)
  }

  let computed : ComputedUiNode = {
    position: logical_pos,
    size: logical_size,
    content_position,
    content_size,
    max_scroll_position,
    border,
    padding,
  }
  let screen_rect = screen_rect_for(
    logical_rect, effective_layout_space, use_rounding,
  )
  let screen_content_rect = screen_rect_for(
    logical_content_rect, effective_layout_space, use_rounding,
  )
  let global : GlobalUiNode = {
    logical_rect,
    screen_rect,
    logical_content_rect,
    screen_content_rect,
    target_camera: effective_target_camera,
    target_viewport: effective_layout_space.viewport,
  }
  ui_geometry().set(entity, { computed, global, })

  let inherited_clip : @math.Rect? = if query_override_clip.contains(entity) {
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
    None => ignore(calculated_clips().remove(entity))
  }

  let next_origin = @math.Vec2(
    logical_pos.x - effective_scroll_position.x,
    logical_pos.y - effective_scroll_position.y,
  )
  for child in ui_children(world~, entity) {
    apply_layout_recursive(
      world~,
      child,
      chicle,
      layout_nodes,
      next_origin,
      current_clip,
      use_rounding,
      effective_layout_space,
      projected,
    )
  }
}
