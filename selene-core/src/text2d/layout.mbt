///|
#derive(Eq)
priv struct TextLayoutCacheKey {
  text : String
  font : @asset.FontHandle?
  family : String
  size : Double
  font_metrics_revision : UInt32
  line_height : Double
  wrap : @ui.TextWrap
  overflow : @ui.TextOverflow
  bounds_width : Double
  bounds_height : Double
}

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
  text_layout_caches : @ecs.EntityTable[CachedTextLayout2d]
}

///|
let text2d_world_store_key : @ecs.ResourceKey[Text2dWorldStore] = ResourceKey()

///|
fn Text2dWorldStore::Text2dWorldStore(world : @ecs.World) -> Text2dWorldStore {
  { text_layout_caches: EntityTable(world), }
}

///|
fn text2d_world_store() -> Text2dWorldStore {
  text2d_world_store_key.get_or_insert_with(@ecs.require_current_world(), world => {
    Text2dWorldStore(world)
  })
}

///|
fn text_layout_caches() -> @ecs.EntityTable[CachedTextLayout2d] {
  text2d_world_store().text_layout_caches
}

///|
fn text2d_layout(entity : @ecs.Entity) -> @ui.TextLayout {
  @ui.text_layouts().get(entity).unwrap_or(TextLayout())
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
  if measure_text_fragment(style, text).x <= max_width {
    return text
  }
  let ellipsis = "..."
  let mut current = text
  while current.length() > 0 &&
        measure_text_fragment(style, current + ellipsis).x > max_width {
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
    if measure_text_fragment(style, candidate).x <= max_width {
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
    font_metrics_revision: @platform_render.font_metrics_revision(style.family),
    line_height: layout.line_height,
    wrap: layout.wrap,
    overflow: layout.overflow,
    bounds_width: bounds.map_or(-1.0, fn(bounds) { bounds.width }),
    bounds_height: bounds.map_or(-1.0, fn(bounds) { bounds.height }),
  }
}

///|
fn cached_text_layout(
  entity : @ecs.Entity,
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
        @cmp.maximum(acc, measure_text_fragment(style, line).x)
      })
      let cached = { key, lines, max_line_width, line_height, block_height, }
      text_layout_caches().set(entity, cached)
      cached
    }
  }
}
