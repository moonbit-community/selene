///|
fn text2d_anchor(entity : @ecs.Entity) -> @sprite.Anchor {
  text_anchors().get(entity).unwrap_or(Anchor(Vec2(0.0, 0.0)))
}

///|
fn anchor_origin(anchor : @sprite.Anchor, size : @math.Vec2) -> @math.Vec2 {
  let normalized = anchor.as_vec()
  Vec2(-size.x * (normalized.x + 0.5), -size.y * (0.5 - normalized.y))
}

///|
pub fn render_text2d_system(delta : Double) -> Unit {
  ignore(delta)
  for (entity, _) in text_layout_caches().to_array() {
    if !entity.is_alive() {
      text_layout_caches().remove(entity)
    }
  }
  let camera_views = @camera.active_camera2d_views()
  let camera_extract = @culling2d.CameraExtract2dContext(camera_views)
  for entity, text2d in text2ds() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transform(entity) is Some(global_transform) else {
      continue
    }
    guard @ui.texts().get(entity) is Some(text) else { continue }
    guard @ui.text_style_for(entity) is Some(style) else { continue }
    let layout = text2d_layout(entity)
    let bounds = text_bounds().get(entity)
    let translation = global_transform.translation()
    let base_pos = @math.Vec2(translation.x, translation.y)
    let parallax = @parallax2d.inherited_parallax2d(entity)
    let sorting = @render2d.entity_sorting2d(entity)
    let anchor = text2d_anchor(entity)
    let depth = @render2d.sort_depth_for_transform(global_transform, sorting)
    let cached_layout = cached_text_layout(
      entity,
      text.content,
      style,
      layout,
      bounds,
    )
    let lines = cached_layout.lines
    if lines.is_empty() {
      continue
    }
    let line_height = cached_layout.line_height
    let block_height = cached_layout.block_height
    let bounds_width = bounds.map_or(0.0, fn(bounds) { bounds.width })
    let bounds_height = bounds.map_or(block_height, fn(bounds) { bounds.height })
    let max_line_width = cached_layout.max_line_width
    let layout_width = if bounds_width > 0.0 {
      bounds_width
    } else {
      max_line_width
    }
    let layout_size = @math.Vec2(layout_width, bounds_height)
    if camera_views.is_empty() {
      let screen_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        None,
      )
      push_text2d_lines(
        entity,
        lines,
        style,
        layout,
        layout_width,
        bounds_height,
        block_height,
        line_height,
        @camera.pixel_snapped_position(@window.scale_vec2(screen_pos)),
        layout_size,
        global_transform,
        None,
        text2d.blend_mode,
        depth,
        sorting,
      )
      continue
    }
    let world_pos = @parallax2d.parallax_world_position(
      base_pos,
      parallax,
      None,
    )
    let world_bounds = @camera.transformed_rect_bounds(
      world_pos + anchor_origin(anchor, layout_size),
      { position: @math.Vec2::zero(), size: layout_size, },
      @camera.world_transform_2d(global_transform),
    )
    let camera_views_for_entity = camera_extract.camera_views_for_bounds(
      world_bounds,
      @visibility.entity_render_layers(entity),
      @parallax2d.parallax_depends_on_camera(parallax),
    )
    if camera_views_for_entity.is_empty() {
      continue
    }
    for camera_view in camera_views_for_entity {
      let raw_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        Some(camera_view),
      )
      let screen_pos = @camera.pixel_snapped_position(
        camera_view.world_to_viewport(raw_pos),
      )
      let screen_transform = @camera.camera_screen_transform(
        global_transform,
        Some(camera_view),
      )
      let layout_origin = screen_pos + anchor_origin(anchor, layout_size)
      let layout_bounds = @camera.transformed_rect_bounds(
        layout_origin,
        { position: @math.Vec2::zero(), size: layout_size, },
        screen_transform,
      )
      guard camera_view.intersects_screen_rect(layout_bounds) else { continue }
      push_text2d_lines(
        entity,
        lines,
        style,
        layout,
        layout_width,
        bounds_height,
        block_height,
        line_height,
        screen_pos,
        layout_size,
        global_transform,
        Some(camera_view),
        text2d.blend_mode,
        depth,
        sorting,
      )
    }
  }
}

///|
fn push_text2d_lines(
  entity : @ecs.Entity,
  lines : Array[String],
  style : @render2d_types.TextStyle2D,
  layout : @ui.TextLayout,
  layout_width : Double,
  bounds_height : Double,
  block_height : Double,
  line_height : Double,
  screen_pos : @math.Vec2,
  layout_size : @math.Vec2,
  global_transform : @transform.GlobalTransform,
  camera_view : @camera.Camera2dView?,
  blend_mode : @render.BlendMode2D,
  depth : Double,
  sorting : @render2d.Sorting2d,
) -> Unit {
  let origin = screen_pos + anchor_origin(text2d_anchor(entity), layout_size)
  let start_y = match layout.baseline {
    Top => origin.y
    Center => origin.y + (bounds_height - block_height) / 2.0
    Bottom => origin.y + bounds_height - block_height
  }
  let style_for_draw = { ..style, align: Left, baseline: Top, }
  for index, line in lines {
    let measured = measure_text_fragment(style, line)
    let x = match layout.align {
      Left => origin.x
      Center => origin.x + (layout_width - measured.x) / 2.0
      Right => origin.x + layout_width - measured.x
    }
    let command : @render2d_types.TextDrawCommand2D = {
      text: line,
      position: @camera.pixel_snapped_position(
        Vec2(x, start_y + line_height * index.to_double()),
      ),
      transform: @camera.camera_screen_transform(global_transform, camera_view),
      blend_mode,
      style: style_for_draw,
    }
    match camera_view {
      Some(camera_view) =>
        @render2d.push_text_with_depth_to_camera(
          camera_view.entity.id(),
          depth,
          command,
          entity_id=Some(entity.id()),
          sorting~,
        )
      None =>
        @render2d.push_text_with_depth_for_entity(
          depth,
          Some(entity.id()),
          command,
          sorting~,
        )
    }
  }
}
