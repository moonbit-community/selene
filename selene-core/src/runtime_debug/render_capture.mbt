///|
fn draw2d_info(
  entity_id : UInt?,
  layer : String,
  depth : Double?,
  command : @render2d_types.DrawCommand2D,
) -> DrawSubmission2DInfo {
  match command {
    Image(image) => {
      let uv_rect = image.source.map(fn(region) {
        @math.Rect::{ position: region.position, size: region.size }
      })
      {
        entity_id,
        layer,
        kind: "Image",
        depth,
        texture_path: @asset.image_path(image.image),
        uv_rect,
        destination_rect: Some(image.destination),
        transform: Some(image.transform),
        color: Some(image.color),
      }
    }
    Text(text) => {
      let destination = @math.Rect::{
        position: text.position,
        size: @math.Vec2::zero(),
      }
      {
        entity_id,
        layer,
        kind: "Text",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(destination),
        transform: Some(text.transform),
        color: Some(text.style.color),
      }
    }
    Rect(rect) =>
      {
        entity_id,
        layer,
        kind: "Rect",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(rect.rect),
        transform: Some(rect.transform),
        color: Some(rect.fill_color),
      }
    Circle(circle) => {
      let destination = @math.Rect::{
        position: circle.center - @math.Vec2(circle.radius, circle.radius),
        size: @math.Vec2(circle.radius * 2.0, circle.radius * 2.0),
      }
      {
        entity_id,
        layer,
        kind: "Circle",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(destination),
        transform: Some(circle.transform),
        color: Some(circle.fill_color),
      }
    }
    GradientRect(gradient) =>
      {
        entity_id,
        layer,
        kind: "GradientRect",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(gradient.rect),
        transform: Some(gradient.transform),
        color: Some(gradient.color_start),
      }
    PushClip(clip) =>
      {
        entity_id,
        layer,
        kind: "PushClip",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(clip.rect),
        transform: None,
        color: None,
      }
    PopClip =>
      {
        entity_id,
        layer,
        kind: "PopClip",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: None,
        transform: None,
        color: None,
      }
  }
}

///|
fn draw3d_info(item : @render3d_types.RenderItem3D) -> DrawSubmission3DInfo {
  {
    entity_id: item.entity_id,
    mesh: item.mesh,
    material: item.material,
    cast_shadows: item.cast_shadows,
    receive_shadows: item.receive_shadows,
    translation: item.transform.translation,
    scale: item.transform.scale,
  }
}

///|
pub fn record_render_submission(
  frame : @render_pipeline.RenderFrame,
  world_commands : Array[@render2d.DrawCommandWithDepth2D],
) -> Unit {
  let draw2d : Array[DrawSubmission2DInfo] = []
  for command in world_commands {
    draw2d.push(
      draw2d_info(
        command.entity_id,
        "world",
        Some(command.depth),
        command.command,
      ),
    )
  }
  for command in frame.frame2d.ui_commands {
    draw2d.push(draw2d_info(None, "ui", None, command))
  }
  let draw3d = frame.frame3d.items.map(draw3d_info)
  let world = current_world()
  latest_render_frame_by_world.set(world.id(), frame)
  render_submission_by_world.set(world.id(), {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    draw2d,
    draw3d,
  })
}

///|
pub fn latest_render_submission() -> RenderSubmissionDebug? {
  render_submission_by_world.get(current_world_id())
}

///|
fn draw2d_metadata_entry(
  item : DrawSubmission2DInfo,
) -> DrawSubmission2DMetadataEntry {
  {
    entity_id: item.entity_id,
    layer: item.layer,
    kind: item.kind,
    depth: item.depth,
    texture_path: item.texture_path,
    source_rect: item.uv_rect.map(debug_rect),
    destination_rect: item.destination_rect.map(debug_rect),
    transform_translation: item.transform.map(fn(transform) {
      debug_vec2(@math.Vec2(transform.tx, transform.ty))
    }),
    color: item.color.map(debug_color),
  }
}

///|
fn metrics_export(
  metrics : FramePerformanceMetrics,
) -> FramePerformanceMetricsExport {
  {
    frame_index: metrics.frame_index,
    fixed_step_index: metrics.fixed_step_index,
    fixed_steps_this_frame: metrics.fixed_steps_this_frame,
    update_delta: metrics.update_delta,
    fixed_delta_total: metrics.fixed_delta_total,
    render_delta: metrics.render_delta,
    entity_count: metrics.entity_count,
    draw2d_count: metrics.draw2d_count,
    draw3d_count: metrics.draw3d_count,
  }
}

///|
pub fn capture_last_frame_metadata() -> FrameCaptureMetadata? {
  guard latest_render_submission() is Some(submission) else { return None }
  let draw2d = submission.draw2d.map(draw2d_metadata_entry)
  let metrics = frame_metrics_by_world
    .get(current_world_id())
    .map(metrics_export)
  Some({
    frame_index: submission.frame_index,
    fixed_step_index: submission.fixed_step_index,
    metrics,
    draw2d,
    draw3d_count: submission.draw3d.length(),
    sprites: sprite_inspector_entries(),
    atlas_overlay: atlas_overlay_entries(),
  })
}

///|
pub fn capture_last_frame_metadata_json(indent? : Int = 2) -> String? {
  capture_last_frame_metadata().map(fn(metadata) {
    metadata.to_json().stringify(indent~)
  })
}

///|
pub fn frame_capture_file_stem(
  frame_index : UInt,
  fixed_step_index : UInt,
) -> String {
  "frame_\{frame_index.to_string()}_fixed_\{fixed_step_index.to_string()}"
}

///|
pub fn capture_last_frame_with_metadata(
  width : Int,
  height : Int,
  indent? : Int = 2,
) -> FrameCaptureArtifact? {
  guard capture_last_frame_metadata() is Some(metadata) else { return None }
  let png = match render_last_frame_offscreen_png(width, height) {
    Some(bytes) => Some(bytes)
    None => capture_frame_png()
  }
  guard png is Some(bytes) else { return None }
  let file_stem = frame_capture_file_stem(
    metadata.frame_index,
    metadata.fixed_step_index,
  )
  Some({
    frame_index: metadata.frame_index,
    fixed_step_index: metadata.fixed_step_index,
    file_stem,
    png: bytes,
    metadata_json: metadata.to_json().stringify(indent~),
  })
}

///|
pub fn render_last_frame_offscreen_png(width : Int, height : Int) -> Bytes? {
  guard latest_render_frame_by_world.get(current_world_id()) is Some(frame) else {
    return None
  }
  @platform_render.render_offscreen_png(frame, width, height)
}

///|
pub fn capture_frame_png() -> Bytes? {
  @platform_render.capture_frame_png()
}

///|
pub fn capture_frame_png_to_file(path : String) -> Bool {
  @platform_render.capture_frame_png_to_file(path)
}
