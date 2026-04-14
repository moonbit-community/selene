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
pub fn submit_frame(frame : @render_pipeline.RenderFrame) -> Unit {
  let clear = frame.frame3d.clear_color
  @impl.begin_frame(clear)
  @impl.reset_clip_stack()

  for pair in frame.assets3d.mesh_upserts {
    @impl.sync_mesh_asset(pair.0, pair.1)
  }
  for pair in frame.assets3d.material_upserts {
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
  @impl.end_frame()
}

///|
pub fn register_font(family : String, path : String) -> Unit {
  @impl.load_font(family, path)
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @math.Vec2 {
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
pub fn capability_warning(_feature : String, _fallback : String) -> Unit {
  ()
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
  ignore(frame)
  ignore(width)
  ignore(height)
  @impl.capture_frame_png()
}

///|
pub fn image_region_is_fully_transparent(
  path : String,
  rect : @math.Rect,
) -> Bool? {
  ignore(path)
  ignore(rect)
  None
}

///|
pub fn export_texture_region_png(
  image_path : String,
  rect : @math.Rect,
  out_path : String,
) -> Bool {
  ignore(image_path)
  ignore(rect)
  ignore(out_path)
  false
}
