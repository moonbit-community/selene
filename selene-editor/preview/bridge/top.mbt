///|
pub enum PreviewEvent {
  EntityPicked(String?)
  HoverChanged(String?)
  TransformChanged(
    id~ : String,
    translation~ : @shared.Vec2Doc,
    rotation~ : Double
  )
} derive(Show, Eq)

///|
pub enum PreviewCommand {
  Bootstrap
  ClearScene
  LoadScene(@shared.SceneDocument)
  SelectEntity(String?)
  SetTool(@shared.PreviewTool)
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
  translation : @shared.Vec2Doc,
  rotation : Double,
) -> PreviewEvent {
  TransformChanged(id~, translation~, rotation~)
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
  scene : @shared.SceneDocument,
) -> PreviewCommand {
  LoadScene(scene)
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
pub fn preview_command_frame_selection() -> PreviewCommand {
  FrameSelection
}
