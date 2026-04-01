///|
pub struct AtlasAssetEntry {
  path : String
  atlas : @editor_bridge.AtlasAssetDocument
} derive(Show, Eq)

///|
pub struct AnimationAssetEntry {
  path : String
  animation : @editor_bridge.AnimationAssetDocument
} derive(Show, Eq)

///|
pub struct PreviewScenePayload {
  scene_path : String?
  scene : @editor_bridge.SceneDocument
  atlases : Array[AtlasAssetEntry]
  animations : Array[AnimationAssetEntry]
} derive(Show, Eq)

///|
pub fn atlas_asset_entry(
  path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> AtlasAssetEntry {
  { path, atlas }
}

///|
pub fn animation_asset_entry(
  path : String,
  animation : @editor_bridge.AnimationAssetDocument,
) -> AnimationAssetEntry {
  { path, animation }
}

///|
pub fn preview_scene_payload(
  scene_path : String?,
  scene : @editor_bridge.SceneDocument,
  atlases : Array[AtlasAssetEntry],
  animations : Array[AnimationAssetEntry],
) -> PreviewScenePayload {
  { scene_path, scene, atlases, animations }
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
pub fn preview_command_frame_selection() -> PreviewCommand {
  FrameSelection
}
