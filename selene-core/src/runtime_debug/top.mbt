///|
pub(all) struct DeterministicModeConfig {
  rng_seed : UInt
  fixed_delta_override : Double?
  frame_delta_override : Double?
  deterministic_ordering : Bool
}

///|
pub(all) enum InputInjectionEvent {
  KeyDown(@inputs.Code)
  KeyUp(@inputs.Code)
  MouseMove(@math.Vec2)
  MouseWheel(@math.Vec2)
  MouseLeft(Bool)
  MouseRight(Bool)
  MouseMiddle(Bool)
  GamepadConnected(@inputs.Gamepad, Bool)
  GamepadButton(@inputs.GamepadButtonInput, Bool)
  GamepadAxis(@inputs.GamepadAxisInput, Double)
}

///|
pub(all) struct FramePerformanceMetrics {
  frame_index : UInt
  fixed_step_index : UInt
  fixed_steps_this_frame : Int
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int
  draw2d_count : Int
  draw3d_count : Int
}

///|
pub(all) struct DrawSubmission2DInfo {
  entity_id : UInt?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  uv_rect : @math.Rect?
  destination_rect : @math.Rect?
  transform : @math.Transform?
  color : @render.Color?
}

///|
pub(all) struct DrawSubmission3DInfo {
  entity_id : UInt?
  mesh : @render3d_types.MeshHandle
  material : @render3d_types.MaterialHandle
  cast_shadows : Bool
  receive_shadows : Bool
  translation : @math.Vec3
  scale : @math.Vec3
}

///|
pub(all) struct RenderSubmissionDebug {
  frame_index : UInt
  fixed_step_index : UInt
  draw2d : Array[DrawSubmission2DInfo]
  draw3d : Array[DrawSubmission3DInfo]
}

///|
pub(all) enum AtlasValidationIssueKind {
  InvalidAtlasSize
  InvalidRectSize
  OutOfBounds
  DuplicateRect
  Overlap
  FullyTransparentRect
  TransparencyCheckUnavailable
}

///|
pub(all) struct AtlasValidationIssue {
  kind : AtlasValidationIssueKind
  rect_index : Int?
  other_rect_index : Int?
  message : String
}

///|
pub(all) struct AtlasValidationReport {
  total_rects : Int
  issues : Array[AtlasValidationIssue]
}

///|
pub(all) struct EntitySnapshot {
  entity_id : UInt
  name : String?
  transform : @transform.Transform?
  global_transform : @transform.GlobalTransform?
  visibility : @visibility.Visibility?
  sprite : @sprite.Sprite?
  rigid_body2d : @physics2d.RigidBody?
  collider2d : @physics2d.Collider?
  linear_velocity2d : @physics2d.LinearVelocity?
}

///|
pub(all) struct WorldSnapshot {
  frame_index : UInt
  fixed_step_index : UInt
  entities : Array[EntitySnapshot]
  custom_fields : Array[(String, String)]
}

///|
pub(all) struct DebugVec2 {
  x : Double
  y : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugVec3 {
  x : Double
  y : Double
  z : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugRect {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugColor {
  r : UInt
  g : UInt
  b : UInt
  a : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct SpriteInspectorEntry {
  entity_id : UInt
  entity_name : String?
  visible : Bool
  image_path : String?
  source_rect : DebugRect?
  destination_size : DebugVec2?
  anchor : DebugVec2
  flip_x : Bool
  flip_y : Bool
  local_translation : DebugVec3?
  world_translation : DebugVec3?
} derive(Debug, ToJson)

///|
pub(all) struct AtlasOverlayEntry {
  entity_id : UInt?
  layer : String
  texture_path : String
  source_rect : DebugRect
  destination_rect : DebugRect?
} derive(Debug, ToJson)

///|
pub(all) struct DrawSubmission2DMetadataEntry {
  entity_id : UInt?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  source_rect : DebugRect?
  destination_rect : DebugRect?
  transform_translation : DebugVec2?
  color : DebugColor?
} derive(Debug, ToJson)

///|
pub(all) struct FramePerformanceMetricsExport {
  frame_index : UInt
  fixed_step_index : UInt
  fixed_steps_this_frame : Int
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int
  draw2d_count : Int
  draw3d_count : Int
} derive(Eq, Debug, ToJson)

///|
pub(all) struct FrameCaptureMetadata {
  frame_index : UInt
  fixed_step_index : UInt
  metrics : FramePerformanceMetricsExport?
  draw2d : Array[DrawSubmission2DMetadataEntry]
  draw3d_count : Int
  sprites : Array[SpriteInspectorEntry]
  atlas_overlay : Array[AtlasOverlayEntry]
} derive(Debug, ToJson)

///|
pub(all) struct FrameCaptureArtifact {
  frame_index : UInt
  fixed_step_index : UInt
  file_stem : String
  png : Bytes
  metadata_json : String
} derive(Debug)

///|
pub type SnapshotProvider = (@ecs.World) -> String

///|
let deterministic_mode_by_world : Map[UInt, DeterministicModeConfig] = Map::new()

///|
let rng_state_by_world : Map[UInt, UInt] = Map::new()

///|
let queued_inputs_by_world : Map[UInt, Array[@inputs.InputSnapshot]] = Map::new()

///|
let staged_input_by_world : Map[UInt, @inputs.InputSnapshot] = Map::new()

///|
let frame_metrics_by_world : Map[UInt, FramePerformanceMetrics] = Map::new()

///|
let frame_metrics_history_by_world : Map[UInt, Array[FramePerformanceMetrics]] = Map::new()

///|
let render_submission_by_world : Map[UInt, RenderSubmissionDebug] = Map::new()

///|
let latest_render_frame_by_world : Map[UInt, @render_pipeline.RenderFrame] = Map::new()

///|
let snapshot_providers : Map[String, SnapshotProvider] = Map::new()

///|
let atlas_overlay_enabled_by_world : Map[UInt, Bool] = Map::new()

///|
fn current_world() -> @ecs.World {
  @ecs.require_current_world()
}

///|
fn current_world_id() -> UInt {
  current_world().id()
}
