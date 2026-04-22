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
fn pass_target_is_supported(
  target : @render2d_types.RenderPassTarget2D,
) -> Bool {
  match target {
    Screen => true
    Offscreen(_) => true
  }
}

///|
fn draw_batches_for_pass(
  commands : Array[@render2d_types.DrawCommand2D],
  batches : Array[Array[@render2d_types.DrawCommand2D]],
) -> Array[Array[@render2d_types.DrawCommand2D]] {
  if !batches.is_empty() {
    return batches
  }
  if commands.is_empty() {
    []
  } else {
    [commands]
  }
}

///|
fn submit_draw_batches(
  batches : Array[Array[@render2d_types.DrawCommand2D]],
) -> Unit {
  for batch in batches {
    for command in batch {
      submit_draw_command(command)
    }
  }
}

///|
pub fn submit_frame(frame : @render_pipeline.RenderFrame) -> Unit {
  let clear = frame.frame3d.clear_color
  @impl.frame_begin(clear)

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

  @impl.render3d_submit(frame.frame3d)
  for pass in frame.frame2d.passes {
    if !pass_target_is_supported(pass.target) {
      continue
    }
    let world_batches = draw_batches_for_pass(
      pass.world_commands,
      pass.world_batches,
    )
    let ui_batches = draw_batches_for_pass(pass.ui_commands, pass.ui_batches)
    if !pass.world_commands.is_empty() ||
      pass.load_op is @render2d_types.RenderPassLoadOp2D::Clear {
      @impl.render2d_begin_pass(
        pass.viewport,
        pass.load_op,
        pass.clear_color,
        pass.target,
      )
      submit_draw_batches(world_batches)
      @impl.render2d_end_pass()
    }
    if !pass.ui_commands.is_empty() {
      @impl.render2d_begin_pass(
        pass.viewport,
        @render2d_types.RenderPassLoadOp2D::Load,
        pass.clear_color,
        pass.target,
      )
      submit_draw_batches(ui_batches)
      @impl.render2d_end_pass()
    }
  }
  @impl.frame_end()
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
