///|
fn extracted_ui_entities() -> Array[@ecs.Entity] {
  ui_model_world_store().extracted_entities
}

///|
fn push_ui_rect_fill(
  rect : @math.Rect,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 || color.a <= 0.0 {
    return
  }
  @render2d.push_ui_rect_to_camera(camera_entity_id, {
    rect,
    transform: @math.Affine2::identity(),
    alpha_mode: color_alpha_mode(color),
    blend_mode: Alpha,
    fill_color: color,
    stroke_color: None,
  })
}

///|
fn push_ui_circle_fill(
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if radius <= 0.0 || color.a <= 0.0 {
    return
  }
  @render2d.push_ui_circle_to_camera(camera_entity_id, {
    center,
    radius,
    transform: @math.Affine2::identity(),
    alpha_mode: color_alpha_mode(color),
    blend_mode: Alpha,
    fill_color: color,
    stroke_color: None,
  })
}

///|
fn color_alpha_mode(color : @render.Color) -> @render.AlphaMode2D {
  if color.a >= 0.999999 {
    Opaque
  } else {
    Blend
  }
}

///|
fn scale_alpha(color : @render.Color, factor : Double) -> @render.Color {
  let alpha = if factor <= 0.0 {
    0.0
  } else if factor >= 1.0 {
    color.a
  } else {
    color.a * factor
  }
  { ..color, a: alpha, }
}

///|
priv struct ResolvedBorderRadius {
  top_left : Double
  top_right : Double
  bottom_right : Double
  bottom_left : Double
}

///|
fn has_rounded_corners(radius : ResolvedBorderRadius) -> Bool {
  radius.top_left > 0.0 ||
  radius.top_right > 0.0 ||
  radius.bottom_right > 0.0 ||
  radius.bottom_left > 0.0
}

///|
fn resolve_corner_radius(value : Val, size : @math.Vec2) -> Double {
  let basis = @cmp.maximum(0.0, @cmp.minimum(size.x, size.y))
  resolve_val(value, basis)
}

///|
fn resolved_border_radius(
  radius : BorderRadius,
  size : @math.Vec2,
) -> ResolvedBorderRadius {
  let limit = @cmp.maximum(0.0, @cmp.minimum(size.x, size.y) / 2.0)
  {
    top_left: @cmp.minimum(
      limit,
      @cmp.maximum(0.0, resolve_corner_radius(radius.top_left, size)),
    ),
    top_right: @cmp.minimum(
      limit,
      @cmp.maximum(0.0, resolve_corner_radius(radius.top_right, size)),
    ),
    bottom_right: @cmp.minimum(
      limit,
      @cmp.maximum(0.0, resolve_corner_radius(radius.bottom_right, size)),
    ),
    bottom_left: @cmp.minimum(
      limit,
      @cmp.maximum(0.0, resolve_corner_radius(radius.bottom_left, size)),
    ),
  }
}

///|
fn inset_rect(rect : @math.Rect, inset : UiInsets) -> @math.Rect {
  {
    position: Vec2(rect.position.x + inset.left, rect.position.y + inset.top),
    size: Vec2(
      @cmp.maximum(0.0, rect.size.x - inset.left - inset.right),
      @cmp.maximum(0.0, rect.size.y - inset.top - inset.bottom),
    ),
  }
}

///|
fn inset_border_radius(
  radius : ResolvedBorderRadius,
  inset : UiInsets,
) -> ResolvedBorderRadius {
  {
    top_left: @cmp.maximum(
      0.0,
      radius.top_left - @cmp.maximum(inset.top, inset.left),
    ),
    top_right: @cmp.maximum(
      0.0,
      radius.top_right - @cmp.maximum(inset.top, inset.right),
    ),
    bottom_right: @cmp.maximum(
      0.0,
      radius.bottom_right - @cmp.maximum(inset.bottom, inset.right),
    ),
    bottom_left: @cmp.maximum(
      0.0,
      radius.bottom_left - @cmp.maximum(inset.bottom, inset.left),
    ),
  }
}

///|
fn inflate_rect(rect : @math.Rect, amount : Double) -> @math.Rect {
  {
    position: Vec2(rect.position.x - amount, rect.position.y - amount),
    size: Vec2(
      @cmp.maximum(0.0, rect.size.x + amount * 2.0),
      @cmp.maximum(0.0, rect.size.y + amount * 2.0),
    ),
  }
}

///|
fn offset_rect(rect : @math.Rect, offset : @math.Vec2) -> @math.Rect {
  { position: rect.position + offset, size: rect.size, }
}

///|
fn inflate_border_radius(
  radius : ResolvedBorderRadius,
  amount : Double,
) -> ResolvedBorderRadius {
  {
    top_left: @cmp.maximum(0.0, radius.top_left + amount),
    top_right: @cmp.maximum(0.0, radius.top_right + amount),
    bottom_right: @cmp.maximum(0.0, radius.bottom_right + amount),
    bottom_left: @cmp.maximum(0.0, radius.bottom_left + amount),
  }
}

///|
fn push_quarter_circle(
  clip_rect : @math.Rect,
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if clip_rect.size.x <= 0.0 || clip_rect.size.y <= 0.0 || radius <= 0.0 {
    return
  }
  @render2d.push_ui_clip_for_camera(clip_rect, camera_entity_id)
  push_ui_circle_fill(center, radius, color, camera_entity_id~)
  @render2d.pop_ui_clip_for_camera(camera_entity_id)
}

///|
fn push_rounded_rect(
  rect : @math.Rect,
  radius : ResolvedBorderRadius,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 || color.a <= 0.0 {
    return
  }
  if !has_rounded_corners(radius) {
    push_ui_rect_fill(rect, color, camera_entity_id~)
    return
  }

  let tl = radius.top_left
  let tr = radius.top_right
  let br = radius.bottom_right
  let bl = radius.bottom_left
  let x = rect.position.x
  let y = rect.position.y
  let w = rect.size.x
  let h = rect.size.y
  let left_band = @cmp.maximum(tl, bl)
  let right_band = @cmp.maximum(tr, br)
  let top_band = @cmp.maximum(tl, tr)
  let bottom_band = @cmp.maximum(bl, br)

  push_ui_rect_fill(
    {
      position: Vec2(x + left_band, y + top_band),
      size: Vec2(
        @cmp.maximum(0.0, w - left_band - right_band),
        @cmp.maximum(0.0, h - top_band - bottom_band),
      ),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(x + tl, y),
      size: Vec2(@cmp.maximum(0.0, w - tl - tr), top_band),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(x + bl, y + h - bottom_band),
      size: Vec2(@cmp.maximum(0.0, w - bl - br), bottom_band),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(x, y + tl),
      size: Vec2(left_band, @cmp.maximum(0.0, h - tl - bl)),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(x + w - right_band, y + tr),
      size: Vec2(right_band, @cmp.maximum(0.0, h - tr - br)),
    },
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    { position: Vec2(x, y), size: Vec2(tl, tl), },
    Vec2(x + tl, y + tl),
    tl,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    { position: Vec2(x + w - tr, y), size: Vec2(tr, tr), },
    Vec2(x + w - tr, y + tr),
    tr,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    { position: Vec2(x + w - br, y + h - br), size: Vec2(br, br), },
    Vec2(x + w - br, y + h - br),
    br,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    { position: Vec2(x, y + h - bl), size: Vec2(bl, bl), },
    Vec2(x + bl, y + h - bl),
    bl,
    color,
    camera_entity_id~,
  )
}

///|
fn shadow_samples(blur : Double) -> Int32 {
  if blur <= 0.0 {
    1
  } else {
    let steps = (blur / 8.0).ceil().to_int() + 1
    @cmp.minimum(6, @cmp.maximum(2, steps))
  }
}

///|
fn push_box_shadow(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard box_shadows().get(entity) is Some(shadow) else { return }
  guard global_ui_node(entity) is Some(global) else { return }
  let base_radius = resolved_border_radius(
    border_radii().get(entity).unwrap_or(BorderRadius::all(Val::px(0.0))),
    global.screen_rect.size,
  )
  let spread_basis = @cmp.minimum(
    global.screen_rect.size.x,
    global.screen_rect.size.y,
  )
  for layer in shadow.layers {
    let offset = @math.Vec2(
      resolve_val(layer.x_offset, global.screen_rect.size.x),
      resolve_val(layer.y_offset, global.screen_rect.size.y),
    )
    let spread = resolve_val(layer.spread_radius, spread_basis)
    let blur = resolve_val(layer.blur_radius, spread_basis)
    let samples = shadow_samples(blur)
    let mut index = samples - 1
    while index >= 0 {
      let t = if samples <= 1 {
        0.0
      } else {
        index.to_double() / (samples - 1).to_double()
      }
      let blur_amount = blur * t
      let alpha_scale = if samples <= 1 {
        1.0
      } else {
        (1.0 - t * 0.85) / samples.to_double()
      }
      push_rounded_rect(
        offset_rect(
          inflate_rect(global.screen_rect, spread + blur_amount),
          offset,
        ),
        inflate_border_radius(base_radius, spread + blur_amount),
        scale_alpha(layer.color, alpha_scale),
        camera_entity_id~,
      )
      index -= 1
    }
  }
}

///|
fn should_render_ui(entity : @ecs.Entity) -> Bool {
  entity.is_alive() &&
  @visibility.is_visible(entity) &&
  ui_geometry().contains(entity) &&
  nodes()
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
    Viewport => { ..style, size: @window.scale_value(style.size), }
  }
}

///|
fn render_text_style(entity : @ecs.Entity) -> @render2d_types.TextStyle2D? {
  text_style_for(entity).map(scaled_text_style)
}

///|
fn ui_material_context_for(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> UiMaterialContext? {
  global_ui_node(entity).map(fn(transform) {
    UiMaterialContext(
      entity,
      transform.screen_rect,
      content_rect=transform.screen_content_rect,
      border_radius=border_radii()
        .get(entity)
        .unwrap_or(BorderRadius::all(Val::px(0.0))),
      target_camera_entity_id=camera_entity_id,
    )
  })
}

///|
pub fn draw_ui_material_solid(
  context : UiMaterialContext,
  color : @render.Color,
) -> Unit {
  push_rounded_rect(
    context.rect,
    resolved_border_radius(context.border_radius, context.rect.size),
    color,
    camera_entity_id=context.target_camera_entity_id,
  )
}

///|
pub fn draw_ui_material_gradient(
  context : UiMaterialContext,
  gradient : UiGradient,
) -> Unit {
  @render2d.push_ui_gradient_rect_to_camera(context.target_camera_entity_id, {
    rect: context.rect,
    transform: @math.Affine2::identity(),
    alpha_mode: if gradient.color_start.a >= 0.999999 &&
      gradient.color_end.a >= 0.999999 {
      Opaque
    } else {
      Blend
    },
    blend_mode: Alpha,
    color_start: gradient.color_start,
    color_end: gradient.color_end,
  })
}

///|
pub fn draw_ui_material_image(
  context : UiMaterialContext,
  image : UiImage,
) -> Unit {
  @render2d.push_ui_image_to_camera(context.target_camera_entity_id, {
    image: image.image,
    destination: fitted_image_rect(context.rect, image),
    source: None,
    transform: Affine2(),
    uv_transform: @math.Affine2::identity(),
    repeat: NoRepeat,
    alpha_mode: Blend,
    blend_mode: Alpha,
    color: image.tint,
  })
}

///|
fn push_background(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard !material_nodes().contains(entity) else { return }
  guard background_colors().get(entity) is Some(background) else { return }
  guard ui_material_context_for(entity, camera_entity_id~) is Some(context) else {
    return
  }
  draw_ui_material_solid(context, background.color)
}

///|
fn push_material_node(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Bool {
  guard material_nodes().get(entity) is Some(material_node) else {
    return false
  }
  guard ui_material_asset(material_node.material) is Some(material) else {
    return false
  }
  guard ui_material_context_for(entity, camera_entity_id~) is Some(context) else {
    return false
  }
  (material.draw)(context)
  true
}

///|
fn push_border(
  entity : @ecs.Entity,
  geometry : UiGeometry,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard border_colors().get(entity) is Some(border_color) else { return }
  let rect = geometry.global.screen_rect
  let border = geometry.computed.border
  let radius = resolved_border_radius(
    border_radii().get(entity).unwrap_or(BorderRadius::all(Val::px(0.0))),
    rect.size,
  )
  if has_rounded_corners(radius) {
    match background_colors().get(entity) {
      Some(background) => {
        push_rounded_rect(rect, radius, border_color.color, camera_entity_id~)
        push_rounded_rect(
          inset_rect(rect, border),
          inset_border_radius(radius, border),
          background.color,
          camera_entity_id~,
        )
        return
      }
      None =>
        @platform_render.capability_warning(
          "ui_rounded_border_without_fill", "rounded UI borders without a background color still fall back to square edge segments",
        )
    }
  }
  if border.top > 0.0 {
    push_ui_rect_fill(
      { position: rect.position, size: Vec2(rect.size.x, border.top), },
      border_color.color,
      camera_entity_id~,
    )
  }
  if border.bottom > 0.0 {
    push_ui_rect_fill(
      {
        position: Vec2(
          rect.position.x,
          rect.position.y + rect.size.y - border.bottom,
        ),
        size: Vec2(rect.size.x, border.bottom),
      },
      border_color.color,
      camera_entity_id~,
    )
  }
  if border.left > 0.0 {
    push_ui_rect_fill(
      {
        position: Vec2(rect.position.x, rect.position.y + border.top),
        size: Vec2(
          border.left,
          @cmp.maximum(0.0, rect.size.y - border.top - border.bottom),
        ),
      },
      border_color.color,
      camera_entity_id~,
    )
  }
  if border.right > 0.0 {
    push_ui_rect_fill(
      {
        position: Vec2(
          rect.position.x + rect.size.x - border.right,
          rect.position.y + border.top,
        ),
        size: Vec2(
          border.right,
          @cmp.maximum(0.0, rect.size.y - border.top - border.bottom),
        ),
      },
      border_color.color,
      camera_entity_id~,
    )
  }
}

///|
fn push_outline(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard outlines().get(entity) is Some(outline) else { return }
  guard global_ui_node(entity) is Some(transform) else { return }
  let width = resolve_val(outline.width, transform.screen_rect.size.x)
  let offset = resolve_val(outline.offset, transform.screen_rect.size.x)
  if width <= 0.0 || outline.color.a <= 0.0 {
    return
  }
  let inner = inflate_rect(transform.screen_rect, offset)
  let outer = inflate_rect(transform.screen_rect, offset + width)
  let radius = resolved_border_radius(
    border_radii().get(entity).unwrap_or(BorderRadius::all(Val::px(0.0))),
    transform.screen_rect.size,
  )
  if has_rounded_corners(radius) {
    @platform_render.capability_warning(
      "ui_rounded_outline", "rounded UI outlines still render as square outline bands in the current 2D path",
    )
  }
  push_ui_rect_fill(
    {
      position: outer.position,
      size: Vec2(
        outer.size.x,
        @cmp.maximum(0.0, inner.position.y - outer.position.y),
      ),
    },
    outline.color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(outer.position.x, inner.position.y + inner.size.y),
      size: Vec2(
        outer.size.x,
        @cmp.maximum(
          0.0,
          outer.position.y + outer.size.y - inner.position.y - inner.size.y,
        ),
      ),
    },
    outline.color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(outer.position.x, inner.position.y),
      size: Vec2(
        @cmp.maximum(0.0, inner.position.x - outer.position.x),
        inner.size.y,
      ),
    },
    outline.color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    {
      position: Vec2(inner.position.x + inner.size.x, inner.position.y),
      size: Vec2(
        @cmp.maximum(
          0.0,
          outer.position.x + outer.size.x - inner.position.x - inner.size.x,
        ),
        inner.size.y,
      ),
    },
    outline.color,
    camera_entity_id~,
  )
}

///|
fn fitted_image_rect(container : @math.Rect, image : UiImage) -> @math.Rect {
  match image.fit {
    Stretch => container
    None => { position: container.position, size: image.size, }
    Contain => {
      let scale = @cmp.minimum(
        if image.size.x <= 0.0 {
          1.0
        } else {
          container.size.x / image.size.x
        },
        if image.size.y <= 0.0 {
          1.0
        } else {
          container.size.y / image.size.y
        },
      )
      let size = @math.Vec2(image.size.x * scale, image.size.y * scale)
      {
        position: Vec2(
          container.position.x + (container.size.x - size.x) / 2.0,
          container.position.y + (container.size.y - size.y) / 2.0,
        ),
        size,
      }
    }
    Cover => {
      let scale = @cmp.maximum(
        if image.size.x <= 0.0 {
          1.0
        } else {
          container.size.x / image.size.x
        },
        if image.size.y <= 0.0 {
          1.0
        } else {
          container.size.y / image.size.y
        },
      )
      let size = @math.Vec2(image.size.x * scale, image.size.y * scale)
      {
        position: Vec2(
          container.position.x + (container.size.x - size.x) / 2.0,
          container.position.y + (container.size.y - size.y) / 2.0,
        ),
        size,
      }
    }
  }
}

///|
fn push_image(entity : @ecs.Entity, camera_entity_id~ : UInt32? = None) -> Unit {
  guard !material_nodes().contains(entity) else { return }
  guard ui_images().get(entity) is Some(image) else { return }
  guard global_ui_node(entity) is Some(transform) else { return }
  @render2d.push_ui_image_to_camera(camera_entity_id, {
    image: image.image,
    destination: fitted_image_rect(transform.screen_content_rect, image),
    source: None,
    transform: Affine2(),
    uv_transform: @math.Affine2::identity(),
    repeat: NoRepeat,
    alpha_mode: Blend,
    blend_mode: Alpha,
    color: image.tint,
  })
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
fn prepared_text_lines(
  entity : @ecs.Entity,
  available_width : @geometry.AvailableSpace,
) -> Array[String] {
  guard texts().get(entity) is Some(text) else { return [] }
  guard text_style_for(entity) is Some(style) else { return [] }
  prepare_text_layout(text.content, style, text_layout(entity), available_width).lines
}

///|
fn push_text(entity : @ecs.Entity, camera_entity_id~ : UInt32? = None) -> Unit {
  guard texts().get(entity) is Some(_) else { return }
  guard global_ui_node(entity) is Some(transform) else { return }
  guard render_text_style(entity) is Some(style) else { return }
  let layout = text_layout(entity)
  let lines = prepared_text_lines(
    entity,
    AvailDefinite(transform.logical_content_rect.size.x),
  )
  if lines.is_empty() {
    return
  }
  let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
  let block_height = line_height * lines.length().to_double()
  let start_y = match layout.baseline {
    Top => transform.screen_content_rect.position.y
    Center =>
      transform.screen_content_rect.position.y +
      (transform.screen_content_rect.size.y - block_height) / 2.0
    Bottom =>
      transform.screen_content_rect.position.y +
      transform.screen_content_rect.size.y -
      block_height
  }
  for index, line in lines {
    let measured = measure_text_fragment(style, line)
    let x = match layout.align {
      Left => transform.screen_content_rect.position.x
      Center =>
        transform.screen_content_rect.position.x +
        (transform.screen_content_rect.size.x - measured.x) / 2.0
      Right =>
        transform.screen_content_rect.position.x +
        transform.screen_content_rect.size.x -
        measured.x
    }
    // `x`/`y` are already fully resolved in UI layout space.
    // Force renderer-local alignment to top-left to avoid applying alignment twice.
    let style_for_draw = { ..style, align: Left, baseline: Top, }
    @render2d.push_ui_text_to_camera(camera_entity_id, {
      text: line,
      position: Vec2(x, start_y + index.to_double() * line_height),
      transform: @math.Affine2::identity(),
      blend_mode: Alpha,
      style: style_for_draw,
    })
  }
}

///|
fn inherited_clip_for_entity(entity : @ecs.Entity) -> @math.Rect? {
  if override_clips().contains(entity) {
    return None
  }
  let mut current = entity.get_parent()
  let mut clip : @math.Rect? = None
  while current is Some(ancestor) {
    if calculated_clips().get(ancestor) is Some(calculated) {
      clip = match clip {
        Some(existing) => rect_intersection(existing, calculated.clip)
        None => Some(calculated.clip)
      }
    }
    if override_clips().contains(ancestor) {
      break
    }
    current = ancestor.get_parent()
  }
  clip
}

///|
fn render_entity(
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard should_render_ui(entity) else { return }
  guard nodes().get(entity) is Some(node) else { return }
  let effective_inherited_clip = inherited_clip_for_entity(entity)

  let mut pushed_inherited_clip = false
  match effective_inherited_clip {
    Some(clip_rect) => {
      @render2d.push_ui_clip_for_camera(clip_rect, camera_entity_id)
      pushed_inherited_clip = true
    }
    None => ()
  }

  push_box_shadow(entity, camera_entity_id~)
  ignore(push_material_node(entity, camera_entity_id~))
  push_background(entity, camera_entity_id~)
  if ui_geometry().get(entity) is Some(geometry) {
    push_border(entity, geometry, camera_entity_id~)
  }
  push_outline(entity, camera_entity_id~)

  if pushed_inherited_clip {
    @render2d.pop_ui_clip_for_camera(camera_entity_id)
  }

  let needs_clip = node.overflow_x != Visible || node.overflow_y != Visible
  let content_clip = if needs_clip {
    calculated_clips().get(entity).map(fn(value) { value.clip })
  } else {
    effective_inherited_clip
  }
  let mut content_visible = true
  if needs_clip && content_clip is None {
    content_visible = false
  }

  if content_visible {
    let mut pushed_content_clip = false
    match content_clip {
      Some(clip_rect) => {
        @render2d.push_ui_clip_for_camera(clip_rect, camera_entity_id)
        pushed_content_clip = true
      }
      None => ()
    }
    push_image(entity, camera_entity_id~)
    push_text(entity, camera_entity_id~)
    if pushed_content_clip {
      @render2d.pop_ui_clip_for_camera(camera_entity_id)
    }
  }
}

///|
fn render_target_camera_id(entity : @ecs.Entity) -> UInt32? {
  global_ui_node(entity)
  .map(fn(transform) { transform.target_camera.map(fn(camera) { camera.id() }) })
  .unwrap_or(None)
}

///|
pub fn ui_extract_system(_delta : Double) -> Unit {
  extracted_ui_entities().clear()
  extracted_ui_entities().append(ui_stack())
}

///|
pub fn ui_prepare_system(_delta : Double) -> Unit {
  guard !extracted_ui_entities().is_empty() else { return }
  for entity in extracted_ui_entities() {
    let camera_entity_id = render_target_camera_id(entity)
    render_entity(entity, camera_entity_id~)
  }
}
