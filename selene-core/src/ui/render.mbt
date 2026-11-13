///|
fn push_ui_rect_fill(
  frame : @render2d.Frame2D,
  rect : @math.Rect,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 || color.a <= 0.0 {
    return
  }
  frame.push_ui(
    Rect({
      rect,
      transform: @math.Affine2::identity(),
      alpha_mode: color_alpha_mode(color),
      blend_mode: Alpha,
      fill_color: color,
      stroke_color: None,
    }),
    camera_entity_id~,
  )
}

///|
fn push_ui_circle_fill(
  frame : @render2d.Frame2D,
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if radius <= 0.0 || color.a <= 0.0 {
    return
  }
  frame.push_ui(
    Circle({
      center,
      radius,
      transform: @math.Affine2::identity(),
      alpha_mode: color_alpha_mode(color),
      blend_mode: Alpha,
      fill_color: color,
      stroke_color: None,
    }),
    camera_entity_id~,
  )
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
  frame : @render2d.Frame2D,
  clip_rect : @math.Rect,
  center : @math.Vec2,
  radius : Double,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if clip_rect.size.x <= 0.0 || clip_rect.size.y <= 0.0 || radius <= 0.0 {
    return
  }
  frame.push_ui(PushClip({ rect: clip_rect, }), camera_entity_id~)
  push_ui_circle_fill(frame, center, radius, color, camera_entity_id~)
  frame.push_ui(PopClip, camera_entity_id~)
}

///|
fn push_rounded_rect(
  frame : @render2d.Frame2D,
  rect : @math.Rect,
  radius : ResolvedBorderRadius,
  color : @render.Color,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 || color.a <= 0.0 {
    return
  }
  if !has_rounded_corners(radius) {
    push_ui_rect_fill(frame, rect, color, camera_entity_id~)
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
    frame,
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
    frame,
    {
      position: Vec2(x + tl, y),
      size: Vec2(@cmp.maximum(0.0, w - tl - tr), top_band),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    frame,
    {
      position: Vec2(x + bl, y + h - bottom_band),
      size: Vec2(@cmp.maximum(0.0, w - bl - br), bottom_band),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    frame,
    {
      position: Vec2(x, y + tl),
      size: Vec2(left_band, @cmp.maximum(0.0, h - tl - bl)),
    },
    color,
    camera_entity_id~,
  )
  push_ui_rect_fill(
    frame,
    {
      position: Vec2(x + w - right_band, y + tr),
      size: Vec2(right_band, @cmp.maximum(0.0, h - tr - br)),
    },
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    frame,
    { position: Vec2(x, y), size: Vec2(tl, tl), },
    Vec2(x + tl, y + tl),
    tl,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    frame,
    { position: Vec2(x + w - tr, y), size: Vec2(tr, tr), },
    Vec2(x + w - tr, y + tr),
    tr,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    frame,
    { position: Vec2(x + w - br, y + h - br), size: Vec2(br, br), },
    Vec2(x + w - br, y + h - br),
    br,
    color,
    camera_entity_id~,
  )
  push_quarter_circle(
    frame,
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
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  let query_box_shadow = nodes.box_shadow
  let query_border_radius = nodes.border_radius
  guard query_box_shadow.get(entity).map(value => value.0) is Some(shadow) else {
    return
  }
  guard nodes.global_node(entity) is Some(global) else { return }
  let base_radius = resolved_border_radius(
    query_border_radius
    .get(entity)
    .map(value => value.0)
    .unwrap_or(BorderRadius::all(Val::px(0.0))),
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
        frame,
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
fn should_render_ui(nodes~ : UiNodes, entity : @ecs.Entity) -> Bool {
  nodes.entities.is_alive(entity) &&
  nodes.visibility.is_visible(entity) &&
  nodes.model.geometry.contains(entity) &&
  nodes.node
  .get(entity)
  .map(value => value.0)
  .map(fn(node) { node.active && node.display != None })
  .unwrap_or(false)
}

///|
fn scaled_text_style(
  nodes~ : UiNodes,
  style : @render2d_types.TextStyle2D,
) -> @render2d_types.TextStyle2D {
  match nodes.scale_mode.val {
    Screen => style
    Viewport => { ..style, size: style.size * nodes.display.zoom(), }
  }
}

///|
fn render_text_style(
  nodes~ : UiNodes,
  entity : @ecs.Entity,
) -> @render2d_types.TextStyle2D? {
  nodes.text_style_for(entity).map(style => scaled_text_style(nodes~, style))
}

///|
fn ui_material_context_for(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> UiMaterialContext? {
  nodes
  .global_node(entity)
  .map(fn(transform) {
    UiMaterialContext(
      frame,
      entity,
      transform.screen_rect,
      content_rect=transform.screen_content_rect,
      border_radius=nodes.border_radius
        .get(entity)
        .map(value => value.0)
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
  let frame = context.frame
  push_rounded_rect(
    frame,
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
  let frame = context.frame
  frame.push_ui(
    GradientRect({
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
    }),
    camera_entity_id=context.target_camera_entity_id,
  )
}

///|
pub fn draw_ui_material_image(
  context : UiMaterialContext,
  image : UiImage,
) -> Unit {
  let frame = context.frame
  frame.push_ui(
    Image({
      image: image.image,
      destination: fitted_image_rect(context.rect, image),
      source: None,
      transform: Affine2(),
      uv_transform: @math.Affine2::identity(),
      repeat: NoRepeat,
      alpha_mode: Blend,
      blend_mode: Alpha,
      color: image.tint,
    }),
    camera_entity_id=context.target_camera_entity_id,
  )
}

///|
fn push_background(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  let query_material_node = nodes.material_node
  guard !query_material_node.contains(entity) else { return }
  guard nodes.background_color.get(entity).map(value => value.0)
    is Some(background) else {
    return
  }
  guard ui_material_context_for(frame, nodes~, entity, camera_entity_id~)
    is Some(context) else {
    return
  }
  draw_ui_material_solid(context, background.color)
}

///|
fn push_material_node(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Bool {
  guard nodes.material_node.get(entity).map(value => value.0)
    is Some(material_node) else {
    return false
  }
  guard ui_material_asset(material_node.material) is Some(material) else {
    return false
  }
  guard ui_material_context_for(frame, nodes~, entity, camera_entity_id~)
    is Some(context) else {
    return false
  }
  (material.draw)(context)
  true
}

///|
fn push_border(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  geometry : UiGeometry,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard nodes.border_color.get(entity).map(value => value.0)
    is Some(border_color) else {
    return
  }
  let rect = geometry.global.screen_rect
  let border = geometry.computed.border
  let radius = resolved_border_radius(
    nodes.border_radius
    .get(entity)
    .map(value => value.0)
    .unwrap_or(BorderRadius::all(Val::px(0.0))),
    rect.size,
  )
  if has_rounded_corners(radius) {
    match nodes.background_color.get(entity).map(value => value.0) {
      Some(background) => {
        push_rounded_rect(
          frame,
          rect,
          radius,
          border_color.color,
          camera_entity_id~,
        )
        push_rounded_rect(
          frame,
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
      frame,
      { position: rect.position, size: Vec2(rect.size.x, border.top), },
      border_color.color,
      camera_entity_id~,
    )
  }
  if border.bottom > 0.0 {
    push_ui_rect_fill(
      frame,
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
      frame,
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
      frame,
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
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard nodes.outline.get(entity).map(value => value.0) is Some(outline) else {
    return
  }
  guard nodes.global_node(entity) is Some(transform) else { return }
  let width = resolve_val(outline.width, transform.screen_rect.size.x)
  let offset = resolve_val(outline.offset, transform.screen_rect.size.x)
  if width <= 0.0 || outline.color.a <= 0.0 {
    return
  }
  let inner = inflate_rect(transform.screen_rect, offset)
  let outer = inflate_rect(transform.screen_rect, offset + width)
  let radius = resolved_border_radius(
    nodes.border_radius
    .get(entity)
    .map(value => value.0)
    .unwrap_or(BorderRadius::all(Val::px(0.0))),
    transform.screen_rect.size,
  )
  if has_rounded_corners(radius) {
    @platform_render.capability_warning(
      "ui_rounded_outline", "rounded UI outlines still render as square outline bands in the current 2D path",
    )
  }
  push_ui_rect_fill(
    frame,
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
    frame,
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
    frame,
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
    frame,
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
fn push_image(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  let query_material_node = nodes.material_node
  guard !query_material_node.contains(entity) else { return }
  guard nodes.ui_image.get(entity).map(value => value.0) is Some(image) else {
    return
  }
  guard nodes.global_node(entity) is Some(transform) else { return }
  frame.push_ui(
    Image({
      image: image.image,
      destination: fitted_image_rect(transform.screen_content_rect, image),
      source: None,
      transform: Affine2(),
      uv_transform: @math.Affine2::identity(),
      repeat: NoRepeat,
      alpha_mode: Blend,
      blend_mode: Alpha,
      color: image.tint,
    }),
    camera_entity_id~,
  )
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
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  available_width : @geometry.AvailableSpace,
) -> Array[String] {
  guard nodes.text.get(entity).map(value => value.0) is Some(text) else {
    return []
  }
  guard nodes.text_style_for(entity) is Some(style) else { return [] }
  prepare_text_layout(
    text.content,
    style,
    nodes.text_layout(entity),
    available_width,
  ).lines
}

///|
fn push_text(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  let query_text = nodes.text
  guard query_text.get(entity).map(value => value.0) is Some(_) else { return }
  guard nodes.global_node(entity) is Some(transform) else { return }
  guard render_text_style(nodes~, entity) is Some(style) else { return }
  let layout = nodes.text_layout(entity)
  let lines = prepared_text_lines(
    nodes~,
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
    frame.push_ui(
      Text({
        text: line,
        position: Vec2(x, start_y + index.to_double() * line_height),
        transform: @math.Affine2::identity(),
        blend_mode: Alpha,
        style: style_for_draw,
      }),
      camera_entity_id~,
    )
  }
}

///|
fn inherited_clip_for_entity(
  nodes~ : UiNodes,
  entity : @ecs.Entity,
) -> @math.Rect? {
  let query_override_clip = nodes.override_clip
  if query_override_clip.contains(entity) {
    return None
  }
  let mut current = nodes.hierarchy.parent(entity)
  let mut clip : @math.Rect? = None
  while current is Some(ancestor) {
    if nodes.model.calculated_clips.get(ancestor) is Some(calculated) {
      clip = match clip {
        Some(existing) => rect_intersection(existing, calculated.clip)
        None => Some(calculated.clip)
      }
    }
    if query_override_clip.contains(ancestor) {
      break
    }
    current = nodes.hierarchy.parent(ancestor)
  }
  clip
}

///|
fn render_entity(
  frame : @render2d.Frame2D,
  nodes~ : UiNodes,
  entity : @ecs.Entity,
  camera_entity_id~ : UInt32? = None,
) -> Unit {
  guard should_render_ui(nodes~, entity) else { return }
  guard nodes.node.get(entity).map(value => value.0) is Some(node) else {
    return
  }
  let effective_inherited_clip = inherited_clip_for_entity(nodes~, entity)

  let mut pushed_inherited_clip = false
  match effective_inherited_clip {
    Some(clip_rect) => {
      frame.push_ui(PushClip({ rect: clip_rect, }), camera_entity_id~)
      pushed_inherited_clip = true
    }
    None => ()
  }

  push_box_shadow(frame, nodes~, entity, camera_entity_id~)
  ignore(push_material_node(frame, nodes~, entity, camera_entity_id~))
  push_background(frame, nodes~, entity, camera_entity_id~)
  if nodes.model.geometry.get(entity) is Some(geometry) {
    push_border(frame, nodes~, entity, geometry, camera_entity_id~)
  }
  push_outline(frame, nodes~, entity, camera_entity_id~)

  if pushed_inherited_clip {
    frame.push_ui(PopClip, camera_entity_id~)
  }

  let needs_clip = node.overflow_x != Visible || node.overflow_y != Visible
  let content_clip = if needs_clip {
    nodes.model.calculated_clips.get(entity).map(fn(value) { value.clip })
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
        frame.push_ui(PushClip({ rect: clip_rect, }), camera_entity_id~)
        pushed_content_clip = true
      }
      None => ()
    }
    push_image(frame, nodes~, entity, camera_entity_id~)
    push_text(frame, nodes~, entity, camera_entity_id~)
    if pushed_content_clip {
      frame.push_ui(PopClip, camera_entity_id~)
    }
  }
}

///|
fn render_target_camera_id(nodes~ : UiNodes, entity : @ecs.Entity) -> UInt32? {
  nodes
  .global_node(entity)
  .map(fn(transform) { transform.target_camera.map(fn(camera) { camera.id() }) })
  .unwrap_or(None)
}

///|
pub fn ui_extract_system(extraction : UiExtraction) -> Unit {
  extraction.entities.clear()
  extraction.entities.append(extraction.stack)
}

///|
pub fn ui_prepare_system(frame : @render2d.Frame2D, nodes : UiNodes) -> Unit {
  guard !nodes.model.extracted_entities.is_empty() else { return }
  for entity in nodes.model.extracted_entities {
    let camera_entity_id = render_target_camera_id(nodes~, entity)
    render_entity(frame, nodes~, entity, camera_entity_id~)
  }
}

///|
struct UiExtraction {
  stack : Array[@ecs.Entity]
  entities : Array[@ecs.Entity]
}

///|
pub fn UiExtraction::UiExtraction(world : @ecs.World) -> UiExtraction {
  let state = ui_model_world_store(world~)
  { stack: state.ui_stack_entities, entities: state.extracted_entities, }
}

///|
pub impl @ecs.SystemParam for UiExtraction with fn prepare(world) {
  let value = UiExtraction(world)
  _ => value
}

///|
pub extend UiExtraction with @ecs.SystemParam::{prepare}
