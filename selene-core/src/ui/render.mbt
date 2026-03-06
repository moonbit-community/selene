///|
let extracted_ui_roots : Array[@entity.Entity] = []

///|
fn should_render_ui(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  @visibility.is_visible(entity) &&
  global_ui_nodes.contains(entity) &&
  nodes
  .get(entity)
  .map(fn(node) { node.active && node.display != None })
  .unwrap_or(false)
}

///|
fn scaled_text_style(
  style : @render2d_types.TextStyle2D,
) -> @render2d_types.TextStyle2D {
  match get_ui_scale_mode() {
    Screen => style
    Viewport => { ..style, size: @system.scale_value(style.size) }
  }
}

///|
fn render_text_style(entity : @entity.Entity) -> @render2d_types.TextStyle2D? {
  text_style_for(entity).map(scaled_text_style)
}

///|
fn push_background(entity : @entity.Entity) -> Unit {
  guard background_colors.get(entity) is Some(background) else { return }
  guard global_ui_nodes.get(entity) is Some(transform) else { return }
  if border_radii.get(entity) is Some(radius) &&
    (
      radius.top_left > 0.0 ||
      radius.top_right > 0.0 ||
      radius.bottom_right > 0.0 ||
      radius.bottom_left > 0.0
    ) {
    @platform_render.capability_warning(
      "ui_border_radius", "current UI path falls back to square-corner backgrounds",
    )
  }
  @render2d.push_ui_rect({
    rect: transform.screen_rect,
    fill_color: background.color,
    stroke_color: None,
  })
}

///|
fn push_border(entity : @entity.Entity) -> Unit {
  guard border_colors.get(entity) is Some(border_color) else { return }
  guard global_ui_nodes.get(entity) is Some(global) else { return }
  guard computed_ui_nodes.get(entity) is Some(computed) else { return }
  let rect = global.screen_rect
  let border = computed.border
  if border.top > 0.0 {
    @render2d.push_ui_rect({
      rect: {
        position: rect.position,
        size: @math.Vec2D(rect.size[X], border.top),
      },
      fill_color: border_color.color,
      stroke_color: None,
    })
  }
  if border.bottom > 0.0 {
    @render2d.push_ui_rect({
      rect: {
        position: @math.Vec2D(
          rect.position[X],
          rect.position[Y] + rect.size[Y] - border.bottom,
        ),
        size: @math.Vec2D(rect.size[X], border.bottom),
      },
      fill_color: border_color.color,
      stroke_color: None,
    })
  }
  if border.left > 0.0 {
    @render2d.push_ui_rect({
      rect: {
        position: @math.Vec2D(rect.position[X], rect.position[Y] + border.top),
        size: @math.Vec2D(
          border.left,
          @cmp.maximum(0.0, rect.size[Y] - border.top - border.bottom),
        ),
      },
      fill_color: border_color.color,
      stroke_color: None,
    })
  }
  if border.right > 0.0 {
    @render2d.push_ui_rect({
      rect: {
        position: @math.Vec2D(
          rect.position[X] + rect.size[X] - border.right,
          rect.position[Y] + border.top,
        ),
        size: @math.Vec2D(
          border.right,
          @cmp.maximum(0.0, rect.size[Y] - border.top - border.bottom),
        ),
      },
      fill_color: border_color.color,
      stroke_color: None,
    })
  }
}

///|
fn push_outline(entity : @entity.Entity) -> Unit {
  guard outlines.get(entity) is Some(outline) else { return }
  guard global_ui_nodes.get(entity) is Some(transform) else { return }
  let offset = outline.offset
  @render2d.push_ui_rect({
    rect: {
      position: @math.Vec2D(
        transform.screen_rect.position[X] - offset,
        transform.screen_rect.position[Y] - offset,
      ),
      size: @math.Vec2D(
        transform.screen_rect.size[X] + offset * 2.0,
        transform.screen_rect.size[Y] + offset * 2.0,
      ),
    },
    fill_color: transparent(),
    stroke_color: Some(outline.color),
  })
}

///|
fn fitted_image_rect(container : @math.Rect, image : UiImage) -> @math.Rect {
  match image.fit {
    Stretch => container
    None => { position: container.position, size: image.size }
    Contain => {
      let scale = @cmp.minimum(
        if image.size[X] <= 0.0 {
          1.0
        } else {
          container.size[X] / image.size[X]
        },
        if image.size[Y] <= 0.0 {
          1.0
        } else {
          container.size[Y] / image.size[Y]
        },
      )
      let size = @math.Vec2D(image.size[X] * scale, image.size[Y] * scale)
      {
        position: @math.Vec2D(
          container.position[X] + (container.size[X] - size[X]) / 2.0,
          container.position[Y] + (container.size[Y] - size[Y]) / 2.0,
        ),
        size,
      }
    }
    Cover => {
      let scale = @cmp.maximum(
        if image.size[X] <= 0.0 {
          1.0
        } else {
          container.size[X] / image.size[X]
        },
        if image.size[Y] <= 0.0 {
          1.0
        } else {
          container.size[Y] / image.size[Y]
        },
      )
      let size = @math.Vec2D(image.size[X] * scale, image.size[Y] * scale)
      {
        position: @math.Vec2D(
          container.position[X] + (container.size[X] - size[X]) / 2.0,
          container.position[Y] + (container.size[Y] - size[Y]) / 2.0,
        ),
        size,
      }
    }
  }
}

///|
fn push_image(entity : @entity.Entity) -> Unit {
  guard ui_images.get(entity) is Some(image) else { return }
  guard global_ui_nodes.get(entity) is Some(transform) else { return }
  @render2d.push_ui_image({
    image: image.image,
    destination: fitted_image_rect(transform.screen_content_rect, image),
    source: None,
    transform: @math.Transform::new(),
    repeat: NoRepeat,
    color: image.tint,
  })
}

///|
fn measure_text_fragment(entity : @entity.Entity, text : String) -> @math.Vec2D {
  @platform_render.measure_text(
    render_text_style(entity).unwrap_or(
      scaled_text_style({
        font: None,
        family: "Arial",
        size: 16.0,
        color: rgba(255, 255, 255, 1.0),
        align: Left,
        baseline: Top,
      }),
    ),
    text,
  )
}

///|
fn truncate_line(
  entity : @entity.Entity,
  text : String,
  max_width : Double,
) -> String {
  if max_width <= 0.0 {
    return ""
  }
  if measure_text_fragment(entity, text)[X] <= max_width {
    return text
  }
  let ellipsis = "..."
  let mut current = text
  while current.length() > 0 &&
        measure_text_fragment(entity, current + ellipsis)[X] > max_width {
    current = current.unsafe_substring(start=0, end=current.length() - 1)
  }
  current + ellipsis
}

///|
fn wrap_line(
  entity : @entity.Entity,
  text : String,
  max_width : Double,
) -> Array[String] {
  if max_width <= 0.0 {
    return [""]
  }
  let words : Array[String] = []
  for word in text.split(" ") {
    words.push(word.to_string())
  }
  if words.length() <= 1 {
    return [truncate_line(entity, text, max_width)]
  }
  let lines : Array[String] = []
  let mut current = ""
  for word in words {
    let candidate = if current == "" { word } else { current + " " + word }
    if measure_text_fragment(entity, candidate)[X] <= max_width {
      current = candidate
    } else if current == "" {
      lines.push(truncate_line(entity, word, max_width))
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
fn prepared_text_lines(
  entity : @entity.Entity,
  content_rect : @math.Rect,
) -> Array[String] {
  guard texts.get(entity) is Some(text) else { return [] }
  let layout = text_layout(entity)
  let raw_lines : Array[String] = []
  for raw_line in text.content.split("\n") {
    raw_lines.push(raw_line.to_string())
  }
  let lines : Array[String] = []
  for raw_line in raw_lines {
    match layout.wrap {
      NoWrap =>
        lines.push(
          match layout.overflow {
            Clip => raw_line
            Ellipsis => truncate_line(entity, raw_line, content_rect.size[X])
          },
        )
      WordWrap =>
        for line in wrap_line(entity, raw_line, content_rect.size[X]) {
          lines.push(
            match layout.overflow {
              Clip => line
              Ellipsis => truncate_line(entity, line, content_rect.size[X])
            },
          )
        }
    }
  }
  lines
}

///|
fn push_text(entity : @entity.Entity) -> Unit {
  guard texts.get(entity) is Some(_) else { return }
  guard global_ui_nodes.get(entity) is Some(transform) else { return }
  guard render_text_style(entity) is Some(style) else { return }
  let layout = text_layout(entity)
  let lines = prepared_text_lines(entity, transform.screen_content_rect)
  if lines.is_empty() {
    return
  }
  let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
  let block_height = line_height * lines.length().to_double()
  let start_y = match layout.baseline {
    Top => transform.screen_content_rect.position[Y]
    Center =>
      transform.screen_content_rect.position[Y] +
      (transform.screen_content_rect.size[Y] - block_height) / 2.0
    Bottom =>
      transform.screen_content_rect.position[Y] +
      transform.screen_content_rect.size[Y] -
      block_height
  }
  for index, line in lines {
    let measured = measure_text_fragment(entity, line)
    let x = match layout.align {
      Left => transform.screen_content_rect.position[X]
      Center =>
        transform.screen_content_rect.position[X] +
        (transform.screen_content_rect.size[X] - measured[X]) / 2.0
      Right =>
        transform.screen_content_rect.position[X] +
        transform.screen_content_rect.size[X] -
        measured[X]
    }
    @render2d.push_ui_text({
      text: line,
      position: @math.Vec2D(x, start_y + index.to_double() * line_height),
      style,
    })
  }
}

///|
fn render_entity_recursive(entity : @entity.Entity) -> Unit {
  guard should_render_ui(entity) else { return }
  guard nodes.get(entity) is Some(node) else { return }
  let pushed_clip = node.overflow_x != Visible || node.overflow_y != Visible
  if pushed_clip {
    guard screen_clip_rects.get(entity) is Some(clip_rect) else { return }
    @render2d.push_ui_clip(clip_rect)
  }

  push_background(entity)
  push_border(entity)
  push_image(entity)
  push_text(entity)
  push_outline(entity)

  let children = ui_children(entity)
  children.sort_by(fn(lhs, rhs) {
    let lz = ui_zindexes.get(lhs).map(fn(value) { value.value }).unwrap_or(0)
    let rz = ui_zindexes.get(rhs).map(fn(value) { value.value }).unwrap_or(0)
    if lz != rz {
      lz - rz
    } else {
      tree_orders.get(lhs).unwrap_or(0) - tree_orders.get(rhs).unwrap_or(0)
    }
  })
  for child in children {
    render_entity_recursive(child)
  }

  if pushed_clip {
    @render2d.pop_ui_clip()
  }
}

///|
pub fn ui_extract_system(_delta : Double) -> Unit {
  extracted_ui_roots.clear()
  for entity in top_level_ui_nodes() {
    if should_render_ui(entity) {
      extracted_ui_roots.push(entity)
    }
  }
}

///|
pub fn ui_prepare_system(_delta : Double) -> Unit {
  for entity in extracted_ui_roots {
    render_entity_recursive(entity)
  }
}
