///|
fn resolve_font_family(style : @render2d_types.TextStyle2D) -> String {
  match style.font {
    Some(handle) => @asset.font_family(handle).unwrap_or(style.family)
    None => style.family
  }
}

///|
fn resolve_text_style(
  style : @render2d_types.TextStyle2D,
) -> @render2d_types.TextStyle2D {
  { ..style, family: resolve_font_family(style) }
}

///|
fn resolve_text_command(
  command : @render2d_types.TextDrawCommand2D,
) -> @render2d_types.TextDrawCommand2D {
  { ..command, style: resolve_text_style(command.style) }
}

///|
fn submit_draw_command(command : @render2d_types.DrawCommand2D) -> Unit {
  match command {
    Image(image) =>
      if @asset.image_path(image.image) is Some(path) {
        @impl.draw_image(image, path)
      }
    Text(text) => @impl.draw_text(resolve_text_command(text))
    Rect(rect) => @impl.draw_rect(rect)
    Circle(circle) => @impl.draw_circle(circle)
    GradientRect(gradient) => @impl.draw_gradient_rect(gradient)
    PushClip(clip) => @impl.push_clip_rect(clip.rect)
    PopClip => @impl.pop_clip_rect()
  }
}

///|
let reported_capabilities : @set.Set[String] = @set.Set::new()

///|
fn submit_frame_contents(frame : @render_pipeline.RenderFrame) -> Unit {
  @impl.reset_clip_stack()
  for pair in frame.assets3d.mesh_upserts {
    @impl.sync_mesh_asset(pair.0, pair.1)
  }
  for pair in frame.assets3d.material_upserts {
    let material = pair.1
    if material.roughness < 0.999 || material.metallic > 0.001 {
      capability_warning(
        "pbr_metallic_roughness", "raylib backend uses a non-PBR Blinn-Phong lighting model",
      )
    }
    @impl.sync_material_asset(pair.0, pair.1)
  }
  for pair in frame.assets3d.image_upserts {
    @impl.sync_image_asset(pair.0, pair.1)
  }
  for handle in frame.assets3d.mesh_releases {
    @impl.release_mesh_asset(handle)
  }
  for handle in frame.assets3d.material_releases {
    @impl.release_material_asset(handle)
  }
  for handle in frame.assets3d.image_releases {
    @impl.release_image_asset(handle)
  }

  @impl.render_3d_frame(frame.frame3d)
  @impl.reset_clip_stack()
  for command in frame.frame2d.world_commands {
    submit_draw_command(command)
  }
  @impl.reset_clip_stack()
  for command in frame.frame2d.ui_commands {
    submit_draw_command(command)
  }
  @impl.reset_clip_stack()
}

///|
pub fn submit_frame(frame : @render_pipeline.RenderFrame) -> Unit {
  submit_frame_contents(frame)
}

///|
pub fn register_font(family : String, path : String) -> Unit {
  @impl.load_font(family, path)
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @math.Vec2D {
  @impl.measure_text(resolve_text_style(style), text)
}

///|
pub fn push_clip_rect(rect : @math.Rect) -> Unit {
  @impl.push_clip_rect(rect)
}

///|
pub fn pop_clip_rect() -> Unit {
  @impl.pop_clip_rect()
}

///|
pub fn reset_clip_stack() -> Unit {
  @impl.reset_clip_stack()
}

///|
pub fn capability_warning(feature : String, fallback : String) -> Unit {
  if reported_capabilities.contains(feature) {
    return
  }
  reported_capabilities.add(feature)
  println(
    "[selene-raylib][capability-note] \{feature} is not fully supported; fallback: \{fallback}",
  )
}

///|
pub fn capture_frame_png() -> Bytes? {
  @impl.capture_frame_png()
}

///|
pub fn capture_frame_png_to_file(path : String) -> Bool {
  @impl.capture_frame_png_to_file(path)
}

///|
pub fn render_offscreen_png(
  frame : @render_pipeline.RenderFrame,
  width : Int,
  height : Int,
) -> Bytes? {
  if width <= 0 || height <= 0 {
    return None
  }
  let target = @raylib.RenderTexture::load(width, height)
  if !target.is_valid() {
    target.unload()
    return None
  }
  target.begin_mode()
  @raylib.clear_background(@raylib.black)
  submit_frame_contents(frame)
  @raylib.end_texture_mode()
  let image = @raylib.Image::load_from_texture(target.texture())
  target.unload()
  if !image.is_valid() {
    image.unload()
    return None
  }
  let bytes = image.export_to_memory(".png")
  image.unload()
  if bytes.length() == 0 {
    None
  } else {
    Some(bytes)
  }
}

///|
pub fn image_region_is_fully_transparent(
  path : String,
  rect : @math.Rect,
) -> Bool? {
  if !@raylib.file_exists(path) {
    return None
  }
  let image = @raylib.Image::load(path)
  if !image.is_valid() {
    image.unload()
    return None
  }
  let min_x_raw = @cmath.floor(rect.position[@math.X]).to_int()
  let min_y_raw = @cmath.floor(rect.position[@math.Y]).to_int()
  let max_x_raw = @cmath.ceil(rect.position[@math.X] + rect.size[@math.X]).to_int()
  let max_y_raw = @cmath.ceil(rect.position[@math.Y] + rect.size[@math.Y]).to_int()
  let min_x = if min_x_raw < 0 { 0 } else { min_x_raw }
  let min_y = if min_y_raw < 0 { 0 } else { min_y_raw }
  let max_x = if max_x_raw > image.width() { image.width() } else { max_x_raw }
  let max_y = if max_y_raw > image.height() {
    image.height()
  } else {
    max_y_raw
  }
  if max_x <= min_x || max_y <= min_y {
    image.unload()
    return Some(true)
  }
  let mut opaque_found = false
  for y in min_y..<max_y {
    if opaque_found {
      break
    }
    for x in min_x..<max_x {
      if image.get_color(x, y).a != b'\x00' {
        opaque_found = true
        break
      }
    }
  }
  image.unload()
  Some(!opaque_found)
}
