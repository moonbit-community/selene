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
pub fn submit_frame(frame : @render_pipeline.RenderFrame) -> Unit {
  let clear = frame.frame3d.clear_color
  @impl.begin_frame(clear)

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

  for command in frame.frame2d.commands {
    match command {
      Image(image) =>
        if @asset.image_path(image.image) is Some(path) {
          @impl.draw_image(image, path)
        }
      Text(text) => @impl.draw_text(resolve_text_command(text))
      Rect(rect) => @impl.draw_rect(rect)
      Circle(circle) => @impl.draw_circle(circle)
      GradientRect(gradient) => @impl.draw_gradient_rect(gradient)
    }
  }

  @impl.render_3d_frame(frame.frame3d)
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
) -> @math.Vec2D {
  @impl.measure_text(resolve_text_style(style), text)
}
