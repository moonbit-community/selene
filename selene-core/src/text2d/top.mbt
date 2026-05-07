///|
pub(all) struct Text2d {
  blend_mode : @render.BlendMode2D
} derive(Eq, Debug)

///|
pub(all) struct TextBounds {
  width : Double
  height : Double
} derive(Eq, Debug)

///|
priv struct TextLayoutCacheKey {
  text : String
  font : @asset.FontHandle?
  family : String
  size : Double
  line_height : Double
  wrap : @ui.TextWrap
  overflow : @ui.TextOverflow
  bounds_width : Double
  bounds_height : Double
} derive(Eq)

///|
priv struct CachedTextLayout2d {
  key : TextLayoutCacheKey
  lines : Array[String]
  max_line_width : Double
  line_height : Double
  block_height : Double
}

///|
priv struct Text2dWorldStore {
  text2ds : Map[@entity.Entity, Text2d]
  text_bounds : Map[@entity.Entity, TextBounds]
  text_anchors : Map[@entity.Entity, @sprite.Anchor]
  text_layout_caches : Map[@entity.Entity, CachedTextLayout2d]
}

///|
let text2d_world_stores : Map[UInt, Text2dWorldStore] = Map::of([])

///|
fn text2d_world_store() -> Text2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  text2d_world_stores.get_or_init(world_id, fn() {
    {
      text2ds: Map::of([]),
      text_bounds: Map::of([]),
      text_anchors: Map::of([]),
      text_layout_caches: Map::of([]),
    }
  })
}

///|
pub fn text2ds() -> Map[@entity.Entity, Text2d] {
  text2d_world_store().text2ds
}

///|
pub fn text_bounds() -> Map[@entity.Entity, TextBounds] {
  text2d_world_store().text_bounds
}

///|
pub fn text_anchors() -> Map[@entity.Entity, @sprite.Anchor] {
  text2d_world_store().text_anchors
}

///|
fn text_layout_caches() -> Map[@entity.Entity, CachedTextLayout2d] {
  text2d_world_store().text_layout_caches
}

///|
pub fn Text2d::Text2d(
  blend_mode? : @render.BlendMode2D = @render.BlendMode2D::Alpha,
) -> Text2d {
  { blend_mode, }
}

///|
pub fn TextBounds::TextBounds(width : Double, height : Double) -> TextBounds {
  { width: @cmp.maximum(0.0, width), height: @cmp.maximum(0.0, height) }
}

///|
fn text2d_layout(entity : @entity.Entity) -> @ui.TextLayout {
  @ui.text_layouts().get(entity).unwrap_or(@ui.TextLayout())
}

///|
fn text2d_anchor(entity : @entity.Entity) -> @sprite.Anchor {
  text_anchors().get(entity).unwrap_or(@sprite.Anchor(@math.Vec2(0.0, 0.0)))
}

///|
fn measure_text_fragment(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @math.Vec2 {
  @platform_render.measure_text(style, text)
}

///|
fn truncate_line(
  style : @render2d_types.TextStyle2D,
  text : String,
  max_width : Double,
) -> String {
  if max_width <= 0.0 {
    return ""
  }
  if measure_text_fragment(style, text)[X] <= max_width {
    return text
  }
  let ellipsis = "..."
  let mut current = text
  while current.length() > 0 &&
        measure_text_fragment(style, current + ellipsis)[X] > max_width {
    current = current.unsafe_substring(start=0, end=current.length() - 1)
  }
  current + ellipsis
}

///|
fn wrap_line(
  style : @render2d_types.TextStyle2D,
  text : String,
  max_width : Double,
) -> Array[String] {
  if max_width <= 0.0 {
    return [""]
  }
  let words : Array[String] = []
  for word in text.split(" ") {
    words.push(word.to_owned())
  }
  if words.length() <= 1 {
    return [truncate_line(style, text, max_width)]
  }
  let lines : Array[String] = []
  let mut current = ""
  for word in words {
    let candidate = if current == "" { word } else { current + " " + word }
    if measure_text_fragment(style, candidate)[X] <= max_width {
      current = candidate
    } else if current == "" {
      lines.push(truncate_line(style, word, max_width))
    } else {
      lines.push(current)
      current = word
    }
  }
  if current != "" {
    lines.push(current)
  }
  lines
}

///|
fn bounded_text_lines(
  text : String,
  style : @render2d_types.TextStyle2D,
  layout : @ui.TextLayout,
  bounds : TextBounds?,
) -> Array[String] {
  let width = bounds.map_or(-1.0, fn(bounds) { bounds.width })
  let raw_lines : Array[String] = []
  for raw_line in text.split("\n") {
    raw_lines.push(raw_line.to_owned())
  }
  let lines : Array[String] = []
  for raw_line in raw_lines {
    if width > 0.0 {
      match layout.wrap {
        NoWrap =>
          lines.push(
            match layout.overflow {
              Clip => raw_line
              Ellipsis => truncate_line(style, raw_line, width)
            },
          )
        WordWrap =>
          for line in wrap_line(style, raw_line, width) {
            lines.push(
              match layout.overflow {
                Clip => line
                Ellipsis => truncate_line(style, line, width)
              },
            )
          }
      }
    } else {
      lines.push(raw_line)
    }
  }
  let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
  let max_lines = bounds.map_or(-1, fn(bounds) {
    if bounds.height <= 0.0 {
      0
    } else {
      (bounds.height / line_height).floor().to_int()
    }
  })
  if max_lines < 0 || lines.length() <= max_lines {
    return lines
  }
  if max_lines <= 0 {
    return []
  }
  let clipped : Array[String] = []
  for index, line in lines {
    if index >= max_lines {
      break
    }
    clipped.push(line)
  }
  if layout.overflow is Ellipsis && !clipped.is_empty() {
    let max_width = bounds.map_or(-1.0, fn(bounds) { bounds.width })
    if max_width > 0.0 {
      let last_index = clipped.length() - 1
      clipped[last_index] = truncate_line(style, clipped[last_index], max_width)
    }
  }
  clipped
}

///|
fn text_layout_cache_key(
  text : String,
  style : @render2d_types.TextStyle2D,
  layout : @ui.TextLayout,
  bounds : TextBounds?,
) -> TextLayoutCacheKey {
  {
    text,
    font: style.font,
    family: style.family,
    size: style.size,
    line_height: layout.line_height,
    wrap: layout.wrap,
    overflow: layout.overflow,
    bounds_width: bounds.map_or(-1.0, fn(bounds) { bounds.width }),
    bounds_height: bounds.map_or(-1.0, fn(bounds) { bounds.height }),
  }
}

///|
fn cached_text_layout(
  entity : @entity.Entity,
  text : String,
  style : @render2d_types.TextStyle2D,
  layout : @ui.TextLayout,
  bounds : TextBounds?,
) -> CachedTextLayout2d {
  let key = text_layout_cache_key(text, style, layout, bounds)
  match text_layout_caches().get(entity) {
    Some(cached) if cached.key == key => cached
    _ => {
      let lines = bounded_text_lines(text, style, layout, bounds)
      let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
      let block_height = line_height * lines.length().to_double()
      let max_line_width = lines.fold(init=0.0, fn(acc, line) {
        @cmp.maximum(acc, measure_text_fragment(style, line)[X])
      })
      let cached = { key, lines, max_line_width, line_height, block_height }
      text_layout_caches().set(entity, cached)
      cached
    }
  }
}

///|
fn anchor_origin(anchor : @sprite.Anchor, size : @math.Vec2) -> @math.Vec2 {
  let normalized = anchor.as_vec()
  @math.Vec2(-size[X] * (normalized[X] + 0.5), -size[Y] * (0.5 - normalized[Y]))
}

///|
pub fn render_text2d_system(delta : Double) -> Unit {
  ignore(delta)
  for pair in text_layout_caches().to_array() {
    if !pair.0.is_alive() {
      text_layout_caches().remove(pair.0)
    }
  }
  let camera_views = @camera.active_camera2d_views()
  let camera_extract = @culling2d.build_camera_extract2d_context(camera_views)
  for entity, text2d in text2ds() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    guard @ui.texts().get(entity) is Some(text) else { continue }
    guard @ui.text_style_for(entity) is Some(style) else { continue }
    let layout = text2d_layout(entity)
    let bounds = text_bounds().get(entity)
    let transform = global_transform.compute_transform()
    let base_pos = @math.Vec2(transform.translation.x, transform.translation.y)
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
        @camera.pixel_snapped_position(@system.scale_vec2(screen_pos)),
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
      { position: @math.Vec2::zero(), size: layout_size },
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
        { position: @math.Vec2::zero(), size: layout_size },
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
  entity : @entity.Entity,
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
    Top => origin[Y]
    Center => origin[Y] + (bounds_height - block_height) / 2.0
    Bottom => origin[Y] + bounds_height - block_height
  }
  let style_for_draw = { ..style, align: Left, baseline: Top }
  for index, line in lines {
    let measured = measure_text_fragment(style, line)
    let x = match layout.align {
      Left => origin[X]
      Center => origin[X] + (layout_width - measured[X]) / 2.0
      Right => origin[X] + layout_width - measured[X]
    }
    let command : @render2d_types.TextDrawCommand2D = {
      text: line,
      position: @camera.pixel_snapped_position(
        @math.Vec2(x, start_y + line_height * index.to_double()),
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
