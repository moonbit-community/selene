///|
pub fn msg_select_resource(resource : ResourceSelection?) -> Msg {
  SelectResource(resource)
}

///|
pub fn msg_select_entity(id : String?) -> Msg {
  SelectEntity(id)
}

///|
pub fn msg_move_selected_resource(delta : Int) -> Msg {
  MoveSelectedResource(delta)
}

///|
pub fn msg_set_tool(tool : @shared.PreviewTool) -> Msg {
  SetTool(tool)
}

///|
pub fn msg_frame_selection() -> Msg {
  FrameSelection
}

///|
pub fn msg_set_hover_hint(hint : String?) -> Msg {
  SetHoverHint(hint)
}

///|
pub fn msg_toggle_asset_tree_folder(key : String) -> Msg {
  ToggleAssetTreeFolder(key)
}

///|
pub fn msg_expand_all_asset_folders() -> Msg {
  ExpandAllAssetFolders
}

///|
pub fn msg_collapse_all_asset_folders() -> Msg {
  CollapseAllAssetFolders
}

///|
pub fn msg_toggle_images_section() -> Msg {
  ToggleImagesSection
}

///|
pub fn msg_toggle_atlases_section() -> Msg {
  ToggleAtlasesSection
}

///|
pub fn msg_toggle_animation_clips_section() -> Msg {
  ToggleAnimationClipsSection
}

///|
pub fn msg_toggle_animation_graphs_section() -> Msg {
  ToggleAnimationGraphsSection
}

///|
pub fn msg_toggle_prefabs_section() -> Msg {
  TogglePrefabsSection
}

///|
pub fn msg_toggle_move_snap() -> Msg {
  ToggleMoveSnap
}

///|
pub fn msg_adjust_move_snap_step(delta : Int) -> Msg {
  AdjustMoveSnapStep(delta)
}

///|
pub fn msg_commit_scene_edit_transaction() -> Msg {
  CommitSceneEditTransaction
}

///|
pub fn msg_undo_scene() -> Msg {
  UndoScene
}

///|
pub fn msg_redo_scene() -> Msg {
  RedoScene
}

///|
pub fn msg_clear_selection() -> Msg {
  ClearSelection
}
