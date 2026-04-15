///|
pub fn msg_update_selected_animation_clip_asset_name(value : String) -> Msg {
  UpdateSelectedAnimationClipAssetName(value)
}

///|
pub fn msg_update_selected_animation_graph_asset_name(value : String) -> Msg {
  UpdateSelectedAnimationGraphAssetName(value)
}

///|
pub fn msg_update_selected_animation_graph_default_node(value : String) -> Msg {
  UpdateSelectedAnimationGraphDefaultNode(value)
}

///|
pub fn msg_update_selected_animation_clip_fps(value : String) -> Msg {
  UpdateSelectedAnimationClipFps(value)
}

///|
pub fn msg_toggle_selected_animation_clip_looping() -> Msg {
  ToggleSelectedAnimationClipLooping
}

///|
pub fn msg_update_selected_animation_clip_frames(value : String) -> Msg {
  UpdateSelectedAnimationClipFrames(value)
}

///|
pub fn msg_add_selected_animation_graph_clip_node() -> Msg {
  AddSelectedAnimationGraphClipNode
}

///|
pub fn msg_add_selected_animation_graph_blend_node() -> Msg {
  AddSelectedAnimationGraphBlendNode
}

///|
pub fn msg_add_selected_animation_graph_additive_blend_node() -> Msg {
  AddSelectedAnimationGraphAdditiveBlendNode
}

///|
pub fn msg_remove_selected_animation_graph_node(id : String) -> Msg {
  RemoveSelectedAnimationGraphNode(id)
}

///|
pub fn msg_update_selected_animation_graph_node_clip_path(
  id : String,
  path : String,
) -> Msg {
  UpdateSelectedAnimationGraphNodeClipPath(id, path)
}

///|
pub fn msg_add_selected_animation_graph_edge(node_id : String) -> Msg {
  AddSelectedAnimationGraphEdge(node_id)
}

///|
pub fn msg_remove_selected_animation_graph_edge(
  node_id : String,
  edge_index : Int,
) -> Msg {
  RemoveSelectedAnimationGraphEdge(node_id, edge_index)
}

///|
pub fn msg_update_selected_animation_graph_edge_target(
  node_id : String,
  edge_index : Int,
  target : String,
) -> Msg {
  UpdateSelectedAnimationGraphEdgeTarget(node_id, edge_index, target)
}

///|
pub fn msg_update_selected_animation_graph_edge_weight(
  node_id : String,
  edge_index : Int,
  value : String,
) -> Msg {
  UpdateSelectedAnimationGraphEdgeWeight(node_id, edge_index, value)
}

///|
pub fn msg_begin_selected_animation_graph_edge_connect(node_id : String) -> Msg {
  BeginSelectedAnimationGraphEdgeConnect(node_id)
}

///|
pub fn msg_complete_selected_animation_graph_edge_connect(
  node_id : String,
) -> Msg {
  CompleteSelectedAnimationGraphEdgeConnect(node_id)
}

///|
pub fn msg_cancel_selected_animation_graph_edge_connect() -> Msg {
  CancelSelectedAnimationGraphEdgeConnect
}

///|
pub fn msg_move_selected_animation_graph_node(
  node_id : String,
  normalized_x : Double,
  normalized_y : Double,
) -> Msg {
  MoveSelectedAnimationGraphNode(node_id, normalized_x, normalized_y)
}

///|
pub fn msg_toggle_animation_preview_paused() -> Msg {
  ToggleAnimationPreviewPaused
}

///|
pub fn msg_update_animation_preview_speed(value : String) -> Msg {
  UpdateAnimationPreviewSpeed(value)
}

///|
pub fn msg_update_animation_preview_seek_input(value : String) -> Msg {
  UpdateAnimationPreviewSeekInput(value)
}

///|
pub fn msg_apply_animation_preview_seek() -> Msg {
  ApplyAnimationPreviewSeek
}

///|
pub fn msg_save_selected_animation_clip() -> Msg {
  SaveSelectedAnimationClip
}

///|
pub fn msg_save_selected_animation_graph() -> Msg {
  SaveSelectedAnimationGraph
}

///|
pub fn msg_update_selected_animation_player_graph_path(value : String) -> Msg {
  UpdateSelectedAnimationPlayerGraphPath(value)
}

///|
pub fn msg_update_selected_animation_player_start_node(value : String) -> Msg {
  UpdateSelectedAnimationPlayerStartNode(value)
}

///|
pub fn msg_toggle_selected_animation_player_autoplay() -> Msg {
  ToggleSelectedAnimationPlayerAutoplay
}

///|
pub fn msg_update_selected_animation_player_repeat_mode(value : String) -> Msg {
  UpdateSelectedAnimationPlayerRepeatMode(value)
}

///|
pub fn msg_update_selected_animation_player_speed(value : String) -> Msg {
  UpdateSelectedAnimationPlayerSpeed(value)
}

///|
pub fn msg_update_selected_animation_transitions_duration(
  value : String,
) -> Msg {
  UpdateSelectedAnimationTransitionsDuration(value)
}
