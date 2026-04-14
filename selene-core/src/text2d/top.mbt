///|
pub(all) struct Text2d {

  fn new() -> Text2d
} derive(Eq, Debug)

///|
pub(all) struct TextBounds {
  width : Double
  height : Double

  fn new(width : Double, height : Double) -> TextBounds
} derive(Eq, Debug)

///|
priv struct Text2dWorldStore {
  text2ds : Map[@entity.Entity, Text2d]
  text_bounds : Map[@entity.Entity, TextBounds]
  text_anchors : Map[@entity.Entity, @sprite.Anchor]
}

///|
let text2d_world_stores : Map[UInt, Text2dWorldStore] = Map::new()

///|
fn text2d_world_store() -> Text2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  text2d_world_stores.get_or_init(world_id, fn() {
    { text2ds: Map::new(), text_bounds: Map::new(), text_anchors: Map::new() }
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
pub fn Text2d::new() -> Text2d {
  Text2d::{  }
}

///|
pub fn TextBounds::new(width : Double, height : Double) -> TextBounds {
  { width: @cmp.maximum(0.0, width), height: @cmp.maximum(0.0, height) }
}

///|
fn active_camera2d_view() -> (
  @camera.Camera,
  @transform.GlobalTransform,
  @camera.OrthographicProjection,
)? {
  let mut selected : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
    Int,
  )? = None
  for entity, camera in @camera.cameras() {
    guard entity.is_alive() else { continue }
    guard camera.is_active else { continue }
    guard @camera.camera2ds().contains(entity) else { continue }
    let projection = @camera.orthographic_projections()
      .get(entity)
      .unwrap_or_default()
    guard @transform.global_transforms().get(entity) is Some(global) else {
      continue
    }
    match selected {
      Some((_, _, _, order)) if order >= camera.order => ()
      _ => selected = Some((camera, global, projection, camera.order))
    }
  }
  match selected {
    Some((camera, global, projection, _)) => Some((camera, global, projection))
    None => None
  }
}

///|
fn screen_space_transform(
  transform : @transform.Transform,
) -> @transform.Transform {
  transform.with_scale(
    @math.Vec3::new(
      transform.scale.x * @system.get_zoom(),
      transform.scale.y * @system.get_zoom(),
      transform.scale.z,
    ),
  )
}

///|
fn camera_relative_transform(
  global_transform : @transform.GlobalTransform,
  camera_transform : @transform.GlobalTransform,
  projection : @camera.OrthographicProjection,
) -> @transform.Transform {
  let relative_global = match camera_transform.affine.inverse() {
    Some(inverse_camera) =>
      @transform.GlobalTransform::{
        affine: inverse_camera * global_transform.affine,
      }
    None => global_transform
  }
  let relative = relative_global.compute_transform()
  let projection_scale = if projection.scale <= 0.0 {
    1.0
  } else {
    projection.scale
  }
  let pixels_per_world_unit = @system.get_zoom() / projection_scale
  relative.with_scale(
    @math.Vec3::new(
      relative.scale.x * pixels_per_world_unit,
      relative.scale.y * pixels_per_world_unit,
      relative.scale.z,
    ),
  )
}

///|
fn text_screen_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
  )?,
) -> @math.Transform {
  let transform = match camera_view {
    Some((_, camera_transform, projection)) =>
      camera_relative_transform(global_transform, camera_transform, projection)
    None => screen_space_transform(global_transform.compute_transform())
  }
  let x_axis = transform.rotation.rotate_vec3(
    @math.Vec3::x_axis().scalar_mul(transform.scale.x),
  )
  let y_axis = transform.rotation.rotate_vec3(
    @math.Vec3::y_axis().scalar_mul(transform.scale.y),
  )
  @math.Transform::new(a=x_axis.x, b=x_axis.y, c=y_axis.x, d=y_axis.y)
}

///|
fn pixel_snapped_position(position : @math.Vec2D) -> @math.Vec2D {
  @math.Vec2D(position[X].round(), position[Y].round())
}

///|
fn text2d_layout(entity : @entity.Entity) -> @ui.TextLayout {
  @ui.text_layouts().get(entity).unwrap_or(@ui.TextLayout::new())
}

///|
fn text2d_anchor(entity : @entity.Entity) -> @sprite.Anchor {
  text_anchors().get(entity).unwrap_or(@sprite.Anchor(@math.Vec2D(0.0, 0.0)))
}

///|
fn measure_text_fragment(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @math.Vec2D {
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
    words.push(word.to_string())
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
    raw_lines.push(raw_line.to_string())
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
fn anchor_origin(anchor : @sprite.Anchor, size : @math.Vec2D) -> @math.Vec2D {
  let normalized = anchor.as_vec()
  @math.Vec2D(
    -size[X] * (normalized[X] + 0.5),
    -size[Y] * (0.5 - normalized[Y]),
  )
}

///|
pub fn render_text2d_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_view = active_camera2d_view()
  for entity, _ in text2ds() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    guard @ui.texts().get(entity) is Some(text) else { continue }
    guard @ui.text_style_for(entity) is Some(style) else { continue }
    let layout = text2d_layout(entity)
    let anchor = text2d_anchor(entity)
    let bounds = text_bounds().get(entity)
    let transform = global_transform.compute_transform()
    let raw_pos = @math.Vec2D(transform.translation.x, transform.translation.y)
    let screen_pos = pixel_snapped_position(
      match camera_view {
        Some((camera, camera_global, projection)) =>
          camera.world_to_viewport(camera_global, projection, raw_pos)
        None => @system.scale_vec2(raw_pos)
      },
    )
    let lines = bounded_text_lines(text.content, style, layout, bounds)
    if lines.is_empty() {
      continue
    }
    let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
    let block_height = line_height * lines.length().to_double()
    let bounds_width = bounds.map_or(0.0, fn(bounds) { bounds.width })
    let bounds_height = bounds.map_or(block_height, fn(bounds) { bounds.height })
    let max_line_width = lines.fold(init=0.0, fn(acc, line) {
      @cmp.maximum(acc, measure_text_fragment(style, line)[X])
    })
    let layout_width = if bounds_width > 0.0 {
      bounds_width
    } else {
      max_line_width
    }
    let layout_size = @math.Vec2D(layout_width, bounds_height)
    let origin = screen_pos + anchor_origin(anchor, layout_size)
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
      @render2d.push_text_with_depth_for_entity(
        global_transform.translation().z,
        Some(entity.id()),
        {
          text: line,
          position: pixel_snapped_position(
            @math.Vec2D(x, start_y + line_height * index.to_double()),
          ),
          transform: text_screen_transform(global_transform, camera_view),
          style: style_for_draw,
        },
      )
    }
  }
}
