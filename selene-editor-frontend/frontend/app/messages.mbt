///|
pub fn msg_initialize() -> Msg {
  Initialize
}

///|
pub fn msg_set_project_root_input(value : String) -> Msg {
  SetProjectRootInput(value)
}

///|
pub fn msg_set_project_name_input(value : String) -> Msg {
  SetProjectNameInput(value)
}

///|
pub fn msg_pick_project_root() -> Msg {
  PickProjectRoot
}

///|
pub fn msg_open_project() -> Msg {
  OpenProject
}

///|
pub fn msg_project_root_picked(
  result : Result[@shared.DirectoryPickResult, String],
) -> Msg {
  ProjectRootPicked(result)
}

///|
pub fn msg_project_loaded(
  result : Result[@shared.ProjectStateResponse, String],
) -> Msg {
  ProjectLoaded(result)
}

///|
pub fn msg_scene_loaded(
  result : Result[@shared.SceneLoadOutcome, String],
) -> Msg {
  SceneLoaded(result)
}

///|
pub fn msg_confirm_scene_migration() -> Msg {
  ConfirmSceneMigration
}

///|
pub fn msg_cancel_scene_migration() -> Msg {
  CancelSceneMigration
}

///|
pub fn msg_confirm_animation_migration() -> Msg {
  ConfirmAnimationMigration
}

///|
pub fn msg_cancel_animation_migration() -> Msg {
  CancelAnimationMigration
}

///|
pub fn msg_scene_list_loaded(
  result : Result[@shared.SceneListResponse, String],
) -> Msg {
  SceneListLoaded(result)
}

///|
pub fn msg_assets_loaded(
  result : Result[@shared.AssetsListResponse, String],
) -> Msg {
  AssetsLoaded(result)
}

///|
pub fn msg_prefab_loaded(
  result : Result[@shared.PrefabLoadResponse, String],
) -> Msg {
  PrefabLoaded(result)
}

///|
pub fn msg_atlas_loaded(
  result : Result[@shared.AtlasLoadResponse, String],
) -> Msg {
  AtlasLoaded(result)
}

///|
pub fn msg_animation_clip_loaded(
  result : Result[@shared.AnimationClipLoadResponse, String],
) -> Msg {
  AnimationClipLoaded(result)
}

///|
pub fn msg_animation_graph_loaded(
  result : Result[@shared.AnimationGraphLoadResponse, String],
) -> Msg {
  AnimationGraphLoaded(result)
}

///|
pub fn msg_asset_image_load_failed(path : String) -> Msg {
  AssetImageLoadFailed(path)
}

///|
pub fn msg_set_asset_query(value : String) -> Msg {
  SetAssetQuery(value)
}

///|
pub fn msg_asset_size_resolved(
  path : String,
  width : Double,
  height : Double,
) -> Msg {
  AssetSizeResolved(path, width, height)
}

///|
pub fn msg_scene_saved(result : Result[Unit, String]) -> Msg {
  SceneSaved(result)
}

///|
pub fn msg_animation_migration_saved(result : Result[Unit, String]) -> Msg {
  AnimationMigrationSaved(result)
}

///|
pub fn msg_workspace_saved(result : Result[Unit, String]) -> Msg {
  WorkspaceSaved(result)
}

///|
pub fn msg_service_event(result : Result[@shared.EditorEvent, String]) -> Msg {
  ServiceEvent(result)
}

///|
pub fn msg_preview_event(event : @bridge.PreviewEvent) -> Msg {
  PreviewEvent(event)
}

///|
pub fn msg_open_scene(path : String) -> Msg {
  OpenScene(path)
}

///|
pub fn msg_select_resource(resource : ResourceSelection?) -> Msg {
  SelectResource(resource)
}

///|
pub fn msg_select_entity(id : String?) -> Msg {
  SelectEntity(id)
}

///|
pub fn msg_create_scene(name : String) -> Msg {
  CreateScene(name)
}

///|
pub fn msg_delete_current_scene() -> Msg {
  DeleteCurrentScene
}

///|
pub fn msg_set_current_scene_as_startup() -> Msg {
  SetCurrentSceneAsStartup
}

///|
pub fn msg_rename_current_scene(value : String) -> Msg {
  RenameCurrentScene(value)
}

///|
pub fn msg_create_atlas_from_selected_image() -> Msg {
  CreateAtlasFromSelectedImage
}

///|
pub fn msg_create_animation_from_selected_atlas() -> Msg {
  CreateAnimationFromSelectedAtlas
}

///|
pub fn msg_create_animation_graph_from_selected_clip() -> Msg {
  CreateAnimationGraphFromSelectedClip
}

///|
pub fn msg_save_selected_as_prefab() -> Msg {
  SaveSelectedAsPrefab
}

///|
pub fn msg_insert_selected_resource() -> Msg {
  InsertSelectedResource
}

///|
pub fn msg_move_selected_resource(delta : Int) -> Msg {
  MoveSelectedResource(delta)
}

///|
pub fn msg_open_add_component_panel() -> Msg {
  OpenAddComponentPanel
}

///|
pub fn msg_close_add_component_panel() -> Msg {
  CloseAddComponentPanel
}

///|
pub fn msg_set_component_search_query(value : String) -> Msg {
  SetComponentSearchQuery(value)
}

///|
pub fn msg_toggle_component_collapsed(kind : String) -> Msg {
  ToggleComponentCollapsed(kind)
}

///|
pub fn msg_toggle_component_menu(kind : String?) -> Msg {
  ToggleComponentMenu(kind)
}

///|
pub fn msg_add_builtin_component(
  kind : @editor_bridge.BuiltinComponentKind,
) -> Msg {
  AddBuiltinComponent(kind)
}

///|
pub fn msg_remove_component(kind : String) -> Msg {
  RemoveComponent(kind)
}

///|
pub fn msg_update_add_custom_component_kind(value : String) -> Msg {
  UpdateAddCustomComponentKind(value)
}

///|
pub fn msg_add_custom_component(kind : String) -> Msg {
  AddCustomComponent(kind)
}

///|
pub fn msg_update_custom_component_json(kind : String, value : String) -> Msg {
  UpdateCustomComponentJson(kind, value)
}

///|
pub fn msg_commit_custom_component_json(kind : String) -> Msg {
  CommitCustomComponentJson(kind)
}

///|
pub fn msg_update_selected_prefab_name(value : String) -> Msg {
  UpdateSelectedPrefabName(value)
}

///|
pub fn msg_save_selected_prefab() -> Msg {
  SaveSelectedPrefab
}

///|
pub fn msg_update_selected_atlas_name(value : String) -> Msg {
  UpdateSelectedAtlasName(value)
}

///|
pub fn msg_update_selected_atlas_tile_width(value : String) -> Msg {
  UpdateSelectedAtlasTileWidth(value)
}

///|
pub fn msg_update_selected_atlas_tile_height(value : String) -> Msg {
  UpdateSelectedAtlasTileHeight(value)
}

///|
pub fn msg_update_selected_atlas_columns(value : String) -> Msg {
  UpdateSelectedAtlasColumns(value)
}

///|
pub fn msg_update_selected_atlas_rows(value : String) -> Msg {
  UpdateSelectedAtlasRows(value)
}

///|
pub fn msg_update_selected_atlas_spacing_x(value : String) -> Msg {
  UpdateSelectedAtlasSpacingX(value)
}

///|
pub fn msg_update_selected_atlas_spacing_y(value : String) -> Msg {
  UpdateSelectedAtlasSpacingY(value)
}

///|
pub fn msg_update_selected_atlas_margin_x(value : String) -> Msg {
  UpdateSelectedAtlasMarginX(value)
}

///|
pub fn msg_update_selected_atlas_margin_y(value : String) -> Msg {
  UpdateSelectedAtlasMarginY(value)
}

///|
pub fn msg_update_selected_atlas_anchor_x(value : String) -> Msg {
  UpdateSelectedAtlasAnchorX(value)
}

///|
pub fn msg_update_selected_atlas_anchor_y(value : String) -> Msg {
  UpdateSelectedAtlasAnchorY(value)
}

///|
pub fn msg_save_selected_atlas() -> Msg {
  SaveSelectedAtlas
}

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
pub fn msg_update_selected_animation_clip_name(value : String) -> Msg {
  UpdateSelectedAnimationClipName(value)
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
pub fn msg_rename_selected(value : String) -> Msg {
  RenameSelected(value)
}

///|
pub fn msg_update_selected_translate_x(value : String) -> Msg {
  UpdateSelectedTranslateX(value)
}

///|
pub fn msg_update_selected_translate_y(value : String) -> Msg {
  UpdateSelectedTranslateY(value)
}

///|
pub fn msg_update_selected_rotation(value : String) -> Msg {
  UpdateSelectedRotation(value)
}

///|
pub fn msg_update_selected_text(value : String) -> Msg {
  UpdateSelectedText(value)
}

///|
pub fn msg_toggle_selected_visibility() -> Msg {
  ToggleSelectedVisibility
}

///|
pub fn msg_update_selected_autotile_atlas_path(value : String) -> Msg {
  UpdateSelectedAutoTileAtlasPath(value)
}

///|
pub fn msg_update_selected_autotile_tile_width(value : String) -> Msg {
  UpdateSelectedAutoTileTileWidth(value)
}

///|
pub fn msg_update_selected_autotile_tile_height(value : String) -> Msg {
  UpdateSelectedAutoTileTileHeight(value)
}

///|
pub fn msg_update_selected_autotile_origin_x(value : String) -> Msg {
  UpdateSelectedAutoTileOriginX(value)
}

///|
pub fn msg_update_selected_autotile_origin_y(value : String) -> Msg {
  UpdateSelectedAutoTileOriginY(value)
}

///|
pub fn msg_update_selected_autotile_rule_set(value : String) -> Msg {
  UpdateSelectedAutoTileRuleSet(value)
}

///|
pub fn msg_update_autotile_brush_terrain(value : String) -> Msg {
  UpdateAutoTileBrushTerrain(value)
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

///|
pub fn msg_save_scene() -> Msg {
  SaveScene
}

///|
pub fn msg_reload_scene() -> Msg {
  ReloadScene
}

///|
pub fn msg_add_sprite_entity() -> Msg {
  AddSpriteEntity
}

///|
pub fn msg_add_sprite_from_asset(path : String) -> Msg {
  AddSpriteFromAsset(path)
}

///|
pub fn msg_add_sprite_from_asset_at(
  path : String,
  translation : @editor_bridge.Vec2Doc,
) -> Msg {
  AddSpriteFromAssetAt(path, translation)
}

///|
pub fn msg_add_text_entity() -> Msg {
  AddTextEntity
}

///|
pub fn msg_delete_selected() -> Msg {
  DeleteSelected
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
