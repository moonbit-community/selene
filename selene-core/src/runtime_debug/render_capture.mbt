///|
pub(all) struct DrawSubmission2DInfo {
  entity_id : UInt32?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  uv_rect : @math.Rect?
  destination_rect : @math.Rect?
  transform : @math.Affine2?
  color : @render.Color?
}

///|
pub(all) struct DrawSubmission3DInfo {
  entity_id : UInt32?
  mesh : @render3d_types.MeshHandle
  material : @render3d_types.MaterialHandle
  cast_shadows : Bool
  receive_shadows : Bool
  transform : @math.Affine3
}

///|
pub(all) struct RenderSubmissionDebug {
  frame_index : UInt32
  fixed_step_index : UInt32
  draw2d : Array[DrawSubmission2DInfo]
  draw3d : Array[DrawSubmission3DInfo]
}

///|
#derive(Debug, ToJson)
pub(all) struct DrawSubmission2DMetadataEntry {
  entity_id : UInt32?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  source_rect : DebugRect?
  destination_rect : DebugRect?
  transform_translation : DebugVec2?
  color : DebugColor?
}

///|
pub extend DrawSubmission2DMetadataEntry with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend DrawSubmission2DMetadataEntry with ToJson::{to_json}

///|
#derive(Eq, Debug, ToJson)
pub(all) struct FramePerformanceMetricsExport {
  frame_index : UInt32
  fixed_step_index : UInt32
  fixed_steps_this_frame : Int32
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int32
  draw2d_count : Int32
  draw3d_count : Int32
}

///|
pub extend FramePerformanceMetricsExport with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend FramePerformanceMetricsExport with Eq::{not_equal, equal}

///|
pub extend FramePerformanceMetricsExport with ToJson::{to_json}

///|
#derive(Debug, ToJson)
pub(all) struct FrameCaptureMetadata {
  frame_index : UInt32
  fixed_step_index : UInt32
  metrics : FramePerformanceMetricsExport?
  draw2d : Array[DrawSubmission2DMetadataEntry]
  draw3d_count : Int32
  sprites : Array[SpriteInspectorEntry]
  atlas_overlay : Array[AtlasOverlayEntry]
}

///|
pub extend FrameCaptureMetadata with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FrameCaptureMetadata with ToJson::{to_json}

///|
#derive(Debug)
pub(all) struct FrameCaptureArtifact {
  frame_index : UInt32
  fixed_step_index : UInt32
  file_stem : String
  png : Bytes
  metadata_json : String
}

///|
pub extend FrameCaptureArtifact with @moonbitlang/core/debug.Debug::{to_repr}

///|
let render_submission_key : @ecs.ResourceKey[RenderSubmissionDebug] = ResourceKey()

///|
let latest_render_frame_key : @ecs.ResourceKey[@render_pipeline.RenderFrame] = ResourceKey()

///|
fn draw2d_info(
  entity_id : UInt32?,
  layer : String,
  depth : Double?,
  command : @render2d_types.DrawCommand2D,
) -> DrawSubmission2DInfo {
  match command {
    Image(image) => {
      let uv_rect = image.source.map(fn(region) {
        @math.Rect::{ position: region.position, size: region.size, }
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
        position: circle.center - Vec2(circle.radius, circle.radius),
        size: Vec2(circle.radius * 2.0, circle.radius * 2.0),
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
    transform: item.transform,
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
  latest_render_frame_key.insert_in(world, frame)
  render_submission_key.insert_in(world, {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    draw2d,
    draw3d,
  })
}

///|
pub fn latest_render_submission() -> RenderSubmissionDebug? {
  render_submission_key.get_in(current_world())
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
      debug_vec2(Vec2(transform.tx, transform.ty))
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
pub fn capture_last_frame_metadata(
  world~ : @ecs.World,
) -> FrameCaptureMetadata? {
  guard latest_render_submission() is Some(submission) else { return None }
  let draw2d = submission.draw2d.map(draw2d_metadata_entry)
  let metrics = frame_metrics_key.get_in(current_world()).map(metrics_export)
  Some({
    frame_index: submission.frame_index,
    fixed_step_index: submission.fixed_step_index,
    metrics,
    draw2d,
    draw3d_count: submission.draw3d.length(),
    sprites: sprite_inspector_entries(world~),
    atlas_overlay: atlas_overlay_entries(),
  })
}

///|
pub fn capture_last_frame_metadata_json(
  world~ : @ecs.World,
  indent~ : Int32 = 2,
) -> String? {
  capture_last_frame_metadata(world~).map(fn(metadata) {
    metadata.to_json().stringify(indent~)
  })
}

///|
pub fn frame_capture_file_stem(
  frame_index : UInt32,
  fixed_step_index : UInt32,
) -> String {
  "frame_\{frame_index.to_string()}_fixed_\{fixed_step_index.to_string()}"
}

///|
pub fn capture_last_frame_with_metadata(
  world~ : @ecs.World,
  width : Int32,
  height : Int32,
  indent~ : Int32 = 2,
) -> FrameCaptureArtifact? {
  guard capture_last_frame_metadata(world~) is Some(metadata) else {
    return None
  }
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
pub fn render_last_frame_offscreen_png(width : Int32, height : Int32) -> Bytes? {
  guard latest_render_frame_key.get_in(current_world()) is Some(frame) else {
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
