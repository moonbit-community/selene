///|
fn root_size() -> @math.Vec2D {
  match get_ui_scale_mode() {
    Screen => @system.get_screen_size()
    Viewport => @system.get_viewport_size()
  }
}

///|
fn val_to_dimension(value : Val) -> @moon_taffy.Dimension {
  match value {
    Auto => @moon_taffy.auto()
    Px(value) => @moon_taffy.length(@cmp.maximum(0.0, value))
    Percent(value) => @moon_taffy.percent(value)
  }
}

///|
fn rect_values_to_taffy(
  rect : UiRectValues,
) -> @moon_taffy.Rect[@moon_taffy.Dimension] {
  @moon_taffy.Rect::new(
    left=val_to_dimension(rect.left),
    right=val_to_dimension(rect.right),
    top=val_to_dimension(rect.top),
    bottom=val_to_dimension(rect.bottom),
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
fn resolve_insets(rect : UiRectValues, size : @math.Vec2D) -> UiInsets {
  {
    left: resolve_val(rect.left, size[X]),
    right: resolve_val(rect.right, size[X]),
    top: resolve_val(rect.top, size[Y]),
    bottom: resolve_val(rect.bottom, size[Y]),
  }
}

///|
fn node_to_taffy_style(node : Node) -> @moon_taffy.Style {
  @moon_taffy.Style::default()
  .with_display(
    match node.display {
      Flex => @moon_taffy.display_flex()
      None => @moon_taffy.display_none()
    },
  )
  .with_position(
    match node.position_type {
      Relative => @moon_taffy.position_relative()
      Absolute => @moon_taffy.position_absolute()
    },
  )
  .with_size(
    @moon_taffy.Size::new(
      width=val_to_dimension(node.width),
      height=val_to_dimension(node.height),
    ),
  )
  .with_min_size(
    @moon_taffy.Size::new(
      width=val_to_dimension(node.min_width),
      height=val_to_dimension(node.min_height),
    ),
  )
  .with_max_size(
    @moon_taffy.Size::new(
      width=val_to_dimension(node.max_width),
      height=val_to_dimension(node.max_height),
    ),
  )
  .with_margin(rect_values_to_taffy(node.margin))
  .with_padding(rect_values_to_taffy(node.padding))
  .with_border(rect_values_to_taffy(node.border))
  .with_inset(
    rect_values_to_taffy(
      UiRectValues::new(
        left=node.left,
        right=node.right,
        top=node.top,
        bottom=node.bottom,
      ),
    ),
  )
  .with_flex_direction(
    match node.flex_direction {
      Row => @moon_taffy.flex_direction_row()
      Column => @moon_taffy.flex_direction_column()
    },
  )
  .with_justify_content(
    match node.justify_content {
      Start => @moon_taffy.justify_content_flex_start()
      Center => @moon_taffy.justify_content_center()
      End => @moon_taffy.justify_content_flex_end()
      SpaceBetween => @moon_taffy.justify_content_space_between()
      SpaceAround => @moon_taffy.justify_content_space_around()
      SpaceEvenly => @moon_taffy.justify_content_space_evenly()
    },
  )
  .with_align_items(
    match node.align_items {
      Start => @moon_taffy.align_items_flex_start()
      Center => @moon_taffy.align_items_center()
      End => @moon_taffy.align_items_flex_end()
      Stretch => @moon_taffy.align_items_stretch()
    },
  )
  .with_gap(
    @moon_taffy.Size::new(
      width=@moon_taffy.length(@cmp.maximum(0.0, node.column_gap)),
      height=@moon_taffy.length(@cmp.maximum(0.0, node.row_gap)),
    ),
  )
  .with_flex_grow(node.flex_grow)
  .with_flex_shrink(node.flex_shrink)
  .with_overflow(
    @moon_taffy.Point::new(
      x=match node.overflow_x {
        Visible => @moon_taffy.overflow_visible()
        Clip => @moon_taffy.overflow_clip()
        Scroll => @moon_taffy.overflow_scroll()
      },
      y=match node.overflow_y {
        Visible => @moon_taffy.overflow_visible()
        Clip => @moon_taffy.overflow_clip()
        Scroll => @moon_taffy.overflow_scroll()
      },
    ),
  )
}

///|
fn implicit_root_style(size : @math.Vec2D) -> @moon_taffy.Style {
  @moon_taffy.Style::default()
  .with_display(@moon_taffy.display_flex())
  .with_size(
    @moon_taffy.Size::new(
      width=@moon_taffy.length(size[X]),
      height=@moon_taffy.length(size[Y]),
    ),
  )
  .with_min_size(
    @moon_taffy.Size::new(
      width=@moon_taffy.length(size[X]),
      height=@moon_taffy.length(size[Y]),
    ),
  )
}

///|
fn measure_node(
  known_dimensions : @moon_taffy.Size[Double?],
  _available : @moon_taffy.Size[@moon_taffy.AvailableSpace],
  _node_id : Int,
  entity : @entity.Entity?,
  _style : @moon_taffy.Style,
) -> @moon_taffy.Size[Double] {
  guard entity is Some(entity) else { return @moon_taffy.Size::zero() }
  let (intrinsic_width, intrinsic_height) = if texts.get(entity) is Some(text) {
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
  } else if ui_images.get(entity) is Some(image) {
    (image.size[X], image.size[Y])
  } else {
    (0.0, 0.0)
  }
  @moon_taffy.Size::new(
    width=known_dimensions.width.unwrap_or(intrinsic_width),
    height=known_dimensions.height.unwrap_or(intrinsic_height),
  )
}

///|
fn build_taffy_tree(
  taffy : @moon_taffy.TaffyTree[@entity.Entity],
  entity : @entity.Entity,
  entity_to_node_id : Map[@entity.Entity, Int],
) -> Int? {
  guard nodes.get(entity) is Some(node) else { return None }
  guard node.active else { return None }
  let child_ids : Array[Int] = []
  for child in ui_children(entity) {
    if build_taffy_tree(taffy, child, entity_to_node_id) is Some(child_id) {
      child_ids.push(child_id)
    }
  }
  let node_id = taffy.new_with_children(node_to_taffy_style(node), child_ids)
  let _ = try? taffy.set_node_context(node_id, entity)
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
      position: @math.Vec2D(left, top),
      size: @math.Vec2D(right - left, bottom - top),
    })
  }
}

///|
fn cleanup_dead_ui_state() -> Unit {
  for pair in nodes.to_array() {
    if !pair.0.is_alive() {
      nodes.remove(pair.0)
    }
  }
  for pair in computed_ui_nodes.to_array() {
    if !pair.0.is_alive() {
      computed_ui_nodes.remove(pair.0)
    }
  }
  for pair in global_ui_nodes.to_array() {
    if !pair.0.is_alive() {
      global_ui_nodes.remove(pair.0)
    }
  }
  for pair in ui_zindexes.to_array() {
    if !pair.0.is_alive() {
      ui_zindexes.remove(pair.0)
    }
  }
  for pair in scroll_positions.to_array() {
    if !pair.0.is_alive() {
      scroll_positions.remove(pair.0)
    }
  }
  for pair in tab_indexes.to_array() {
    if !pair.0.is_alive() {
      tab_indexes.remove(pair.0)
    }
  }
  for pair in focus_policies.to_array() {
    if !pair.0.is_alive() {
      focus_policies.remove(pair.0)
    }
  }
  for pair in focusables.to_array() {
    if !pair.0.is_alive() {
      focusables.remove(pair.0)
    }
  }
  for pair in focuseds.to_array() {
    if !pair.0.is_alive() {
      focuseds.remove(pair.0)
    }
  }
  for pair in background_colors.to_array() {
    if !pair.0.is_alive() {
      background_colors.remove(pair.0)
    }
  }
  for pair in border_colors.to_array() {
    if !pair.0.is_alive() {
      border_colors.remove(pair.0)
    }
  }
  for pair in border_radii.to_array() {
    if !pair.0.is_alive() {
      border_radii.remove(pair.0)
    }
  }
  for pair in outlines.to_array() {
    if !pair.0.is_alive() {
      outlines.remove(pair.0)
    }
  }
  for pair in ui_images.to_array() {
    if !pair.0.is_alive() {
      ui_images.remove(pair.0)
    }
  }
  for pair in texts.to_array() {
    if !pair.0.is_alive() {
      texts.remove(pair.0)
    }
  }
  for pair in text_fonts.to_array() {
    if !pair.0.is_alive() {
      text_fonts.remove(pair.0)
    }
  }
  for pair in text_colors.to_array() {
    if !pair.0.is_alive() {
      text_colors.remove(pair.0)
    }
  }
  for pair in text_layouts.to_array() {
    if !pair.0.is_alive() {
      text_layouts.remove(pair.0)
    }
  }
  for pair in buttons.to_array() {
    if !pair.0.is_alive() {
      buttons.remove(pair.0)
    }
  }
  for pair in interactions.to_array() {
    if !pair.0.is_alive() {
      interactions.remove(pair.0)
    }
  }
  for pair in screen_clip_rects.to_array() {
    if !pair.0.is_alive() {
      screen_clip_rects.remove(pair.0)
    }
  }
  for pair in tree_orders.to_array() {
    if !pair.0.is_alive() {
      tree_orders.remove(pair.0)
    }
  }
}

///|
fn apply_layout_recursive(
  entity : @entity.Entity,
  taffy : @moon_taffy.TaffyTree[@entity.Entity],
  entity_to_node_id : Map[@entity.Entity, Int],
  parent_content_origin : @math.Vec2D,
  parent_clip : @math.Rect?,
  order_counter : Ref[Int],
) -> Unit {
  guard entity_to_node_id.get(entity) is Some(node_id) else { return }
  guard nodes.get(entity) is Some(node) else { return }
  let layout_result = try? taffy.layout(node_id)
  guard layout_result is Ok(layout) else { return }

  let logical_pos = parent_content_origin +
    @math.Vec2D(layout.location.x, layout.location.y)
  let logical_size = @math.Vec2D(layout.size.width, layout.size.height)
  let logical_rect = @math.Rect::{ position: logical_pos, size: logical_size }

  let border = resolve_insets(node.border, logical_size)
  let padding = resolve_insets(node.padding, logical_size)
  let content_position = @math.Vec2D(
    logical_pos[X] + border.left + padding.left,
    logical_pos[Y] + border.top + padding.top,
  )
  let content_size = @math.Vec2D(
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

  computed_ui_nodes.set(entity, {
    position: logical_pos,
    size: logical_size,
    content_position,
    content_size,
    border,
    padding,
  })
  global_ui_nodes.set(entity, {
    logical_rect,
    screen_rect: to_screen_rect(logical_rect),
    logical_content_rect,
    screen_content_rect: to_screen_rect(logical_content_rect),
  })

  order_counter.val += 1
  tree_orders.set(entity, order_counter.val)

  let current_clip = if node.overflow_x == Visible && node.overflow_y == Visible {
    parent_clip
  } else {
    match parent_clip {
      Some(parent) =>
        rect_intersection(parent, to_screen_rect(logical_content_rect))
      None => Some(to_screen_rect(logical_content_rect))
    }
  }
  match current_clip {
    Some(rect) => screen_clip_rects.set(entity, rect)
    None => screen_clip_rects.remove(entity)
  }

  let scroll = scroll_positions.get(entity).unwrap_or(ScrollPosition::zero())
  let next_origin = @math.Vec2D(
    logical_content_rect.position[X] - scroll.x,
    logical_content_rect.position[Y] - scroll.y,
  )
  for child in ui_children(entity) {
    apply_layout_recursive(
      child, taffy, entity_to_node_id, next_origin, current_clip, order_counter,
    )
  }
}

///|
pub fn ui_layout_system(_delta : Double) -> Unit {
  cleanup_dead_ui_state()
  computed_ui_nodes.clear()
  global_ui_nodes.clear()
  screen_clip_rects.clear()
  tree_orders.clear()

  let viewport = root_size()
  let order_counter : Ref[Int] = Ref::new(0)
  for root_entity in top_level_ui_nodes() {
    let taffy : @moon_taffy.TaffyTree[@entity.Entity] = @moon_taffy.TaffyTree::new()
    let entity_to_node_id : Map[@entity.Entity, Int] = Map::new()
    guard build_taffy_tree(taffy, root_entity, entity_to_node_id)
      is Some(root_node) else {
      continue
    }
    let implicit_root = taffy.new_with_children(implicit_root_style(viewport), [
      root_node,
    ])
    let layout_result = try? taffy.compute_layout_with_measure(
      implicit_root,
      @moon_taffy.Size::new(
        width=@moon_taffy.available_space_definite(viewport[X]),
        height=@moon_taffy.available_space_definite(viewport[Y]),
      ),
      measure_node,
    )
    guard layout_result is Ok(_) else { continue }
    apply_layout_recursive(
      root_entity,
      taffy,
      entity_to_node_id,
      @math.Vec2D::zero(),
      None,
      order_counter,
    )
  }
}
