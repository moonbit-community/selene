///|
pub struct AtlasAssetEntry {
  path : String
  atlas : @editor_bridge.AtlasAssetDocument
} derive(Show, Eq)

///|
pub struct AnimationClipAssetEntry {
  path : String
  clip : @editor_bridge.AnimationClipAssetDocument
} derive(Show, Eq)

///|
pub struct AnimationGraphAssetEntry {
  path : String
  graph : @editor_bridge.AnimationGraphAssetDocument
} derive(Show, Eq)

///|
pub struct PreviewScenePayload {
  scene_path : String?
  scene : @editor_bridge.SceneDocument
  atlases : Array[AtlasAssetEntry]
  animation_clips : Array[AnimationClipAssetEntry]
  animation_graphs : Array[AnimationGraphAssetEntry]
} derive(Show, Eq)

///|
pub fn atlas_asset_entry(
  path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> AtlasAssetEntry {
  { path, atlas }
}

///|
pub fn animation_clip_asset_entry(
  path : String,
  clip : @editor_bridge.AnimationClipAssetDocument,
) -> AnimationClipAssetEntry {
  { path, clip }
}

///|
pub fn animation_graph_asset_entry(
  path : String,
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> AnimationGraphAssetEntry {
  { path, graph }
}

///|
pub fn preview_scene_payload(
  scene_path : String?,
  scene : @editor_bridge.SceneDocument,
  atlases : Array[AtlasAssetEntry],
  animation_clips : Array[AnimationClipAssetEntry],
  animation_graphs : Array[AnimationGraphAssetEntry],
) -> PreviewScenePayload {
  { scene_path, scene, atlases, animation_clips, animation_graphs }
}

///|
pub enum PreviewEvent {
  EntityPicked(String?)
  HoverChanged(String?)
  TransformGestureStarted(id~ : String)
  TransformChanged(
    id~ : String,
    translation~ : @editor_bridge.Vec2Doc,
    rotation~ : Double,
    scale~ : @editor_bridge.Vec2Doc
  )
  TransformGestureFinished(id~ : String)
} derive(Show, Eq)

///|
pub enum PreviewCommand {
  Bootstrap
  ClearScene
  LoadScene(PreviewScenePayload)
  SelectEntity(String?)
  SetTool(@shared.PreviewTool)
  SetMoveSnap(enabled~ : Bool, step~ : Double)
  SetAnimationPreviewPaused(Bool)
  SetAnimationPreviewSpeed(Double)
  SeekAnimationPreview(Double)
  FrameSelection
} derive(Show, Eq)

///|
pub fn preview_event_entity_picked(id : String?) -> PreviewEvent {
  EntityPicked(id)
}

///|
pub fn preview_event_hover_changed(id : String?) -> PreviewEvent {
  HoverChanged(id)
}

///|
pub fn preview_event_transform_changed(
  id : String,
  translation : @editor_bridge.Vec2Doc,
  rotation : Double,
  scale : @editor_bridge.Vec2Doc,
) -> PreviewEvent {
  TransformChanged(id~, translation~, rotation~, scale~)
}

///|
pub fn preview_event_transform_gesture_started(id : String) -> PreviewEvent {
  TransformGestureStarted(id~)
}

///|
pub fn preview_event_transform_gesture_finished(id : String) -> PreviewEvent {
  TransformGestureFinished(id~)
}

///|
pub fn preview_command_bootstrap() -> PreviewCommand {
  Bootstrap
}

///|
pub fn preview_command_clear_scene() -> PreviewCommand {
  ClearScene
}

///|
pub fn preview_command_load_scene(
  payload : PreviewScenePayload,
) -> PreviewCommand {
  LoadScene(payload)
}

///|
pub fn preview_command_select_entity(id : String?) -> PreviewCommand {
  SelectEntity(id)
}

///|
pub fn preview_command_set_tool(tool : @shared.PreviewTool) -> PreviewCommand {
  SetTool(tool)
}

///|
pub fn preview_command_set_move_snap(
  enabled : Bool,
  step : Double,
) -> PreviewCommand {
  SetMoveSnap(enabled~, step~)
}

///|
pub fn preview_command_set_animation_preview_paused(
  paused : Bool,
) -> PreviewCommand {
  SetAnimationPreviewPaused(paused)
}

///|
pub fn preview_command_set_animation_preview_speed(
  speed : Double,
) -> PreviewCommand {
  SetAnimationPreviewSpeed(speed)
}

///|
pub fn preview_command_seek_animation_preview(
  seconds : Double,
) -> PreviewCommand {
  SeekAnimationPreview(seconds)
}

///|
pub fn preview_command_frame_selection() -> PreviewCommand {
  FrameSelection
}
