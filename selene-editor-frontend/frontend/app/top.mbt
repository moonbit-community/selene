///|
pub enum ResourceSelection {
  Image(String)
  Atlas(String)
  AnimationClip(String)
  AnimationGraph(String)
  Prefab(String)
} derive(Eq)

///|
pub fn resource_selection_image(path : String) -> ResourceSelection {
  Image(path)
}

///|
pub fn resource_selection_atlas(path : String) -> ResourceSelection {
  Atlas(path)
}

///|
pub fn resource_selection_animation_clip(path : String) -> ResourceSelection {
  AnimationClip(path)
}

///|
pub fn resource_selection_animation_graph(path : String) -> ResourceSelection {
  AnimationGraph(path)
}

///|
pub fn resource_selection_prefab(path : String) -> ResourceSelection {
  Prefab(path)
}

///|
pub struct SceneEditTransaction {
  label : String
  before : @editor_bridge.SceneDocument
} derive(Eq)

///|
pub enum SceneConflictState {
  NoConflict
  ExternalSceneChanged(
    path~ : String,
    disk_hash~ : String,
    disk_revision~ : Int
  )
  SaveConflict(
    path~ : String,
    base_hash~ : String,
    current_hash~ : String,
    base_revision~ : Int,
    current_revision~ : Int
  )
} derive(Eq)

///|
pub struct SceneSession {
  path : String
  scene : @editor_bridge.SceneDocument
  dirty : Bool
  base_hash : String
  base_revision : Int
  last_saved_at : Int
  conflict_state : SceneConflictState
  undo_stack : Array[@editor_bridge.SceneDocument]
  redo_stack : Array[@editor_bridge.SceneDocument]
  active_scene_edit_transaction : SceneEditTransaction?
} derive(Eq)

///|
pub enum SceneSaveOutcome {
  Saved(@shared.SceneSaveResult)
  Conflict(@shared.RpcConflictDocument)
} derive(Eq)

///|
pub fn scene_save_outcome_saved(
  save : @shared.SceneSaveResult,
) -> SceneSaveOutcome {
  Saved(save)
}

///|
pub fn scene_save_outcome_conflict(
  conflict : @shared.RpcConflictDocument,
) -> SceneSaveOutcome {
  Conflict(conflict)
}

///|
pub struct Model {
  project_root_input : String
  project_name_input : String
  current_root : String?
  manifest : @editor_bridge.ProjectManifest?
  scene_refs : Array[@editor_bridge.SceneRef]
  prefab_refs : Array[@editor_bridge.PrefabRef]
  atlas_refs : Array[@editor_bridge.AssetRef]
  animation_clip_refs : Array[@editor_bridge.AssetRef]
  animation_graph_refs : Array[@editor_bridge.AssetRef]
  scene_session : SceneSession?
  assets : Array[@editor_bridge.AssetDocument]
  asset_sizes : Map[String, @editor_bridge.Vec2Doc]
  asset_query : String
  failed_image_assets : Map[String, Bool]
  prefab_documents : Map[String, @editor_bridge.PrefabDocument]
  atlas_documents : Map[String, @editor_bridge.AtlasAssetDocument]
  animation_clip_documents : Map[
    String,
    @editor_bridge.AnimationClipAssetDocument,
  ]
  animation_graph_documents : Map[
    String,
    @editor_bridge.AnimationGraphAssetDocument,
  ]
  workspace : @editor_bridge.WorkspaceDocument
  selected_resource : ResourceSelection?
  selected_entity_id : String?
  selected_entity_ids : Array[String]
  add_component_panel_open : Bool
  component_search_query : String
  open_component_menu_kind : String?
  collapsed_component_cards : Map[String, Bool]
  add_custom_component_kind : String
  custom_component_json_drafts : Map[String, String]
  custom_component_json_errors : Map[String, String]
  pending_scene_migration : @editor_bridge.SceneMigrationPreview?
  pending_animation_migration_paths : Array[String]
  pending_animation_migration_scene_path : String?
  animation_migration_in_progress : Bool
  animation_migration_total : Int
  animation_migration_completed : Int
  animation_migration_failed : Int
  animation_migration_prompt_dismissed : Bool
  hover_hint : String?
  asset_tree_expanded : Map[String, Bool]
  images_section_expanded : Bool
  atlases_section_expanded : Bool
  animation_clips_section_expanded : Bool
  animation_graphs_section_expanded : Bool
  prefabs_section_expanded : Bool
  recent_projects : Array[String]
  logs : Array[String]
  status : String
  active_tool : @shared.PreviewTool
  move_snap_enabled : Bool
  move_snap_step : Double
  sidebar_scene_ratio : Double
  sidebar_assets_ratio : Double
  autotile_brush_terrain : Int
  autotile_palette_json_draft : String
  autotile_palette_json_error : String?
  animation_preview_paused : Bool
  animation_preview_speed : Double
  animation_preview_seek_input : String
  animation_preview_seek_seconds : Double
  animation_preview_seek_serial : Int
  graph_edge_connect_source_node : String?
} derive(Eq)

///|
pub struct ViewState {
  current_root : String?
  manifest : @editor_bridge.ProjectManifest?
  scene_refs : Array[@editor_bridge.SceneRef]
  prefab_refs : Array[@editor_bridge.PrefabRef]
  atlas_refs : Array[@editor_bridge.AssetRef]
  animation_clip_refs : Array[@editor_bridge.AssetRef]
  animation_graph_refs : Array[@editor_bridge.AssetRef]
  scene_session : SceneSession?
  asset_query : String
  failed_image_assets : Map[String, Bool]
  prefab_documents : Map[String, @editor_bridge.PrefabDocument]
  atlas_documents : Map[String, @editor_bridge.AtlasAssetDocument]
  animation_clip_documents : Map[
    String,
    @editor_bridge.AnimationClipAssetDocument,
  ]
  animation_graph_documents : Map[
    String,
    @editor_bridge.AnimationGraphAssetDocument,
  ]
  selected_resource : ResourceSelection?
  selected_entity_id : String?
  selected_entity_ids : Array[String]
  add_component_panel_open : Bool
  component_search_query : String
  add_custom_component_kind : String
  pending_scene_migration : @editor_bridge.SceneMigrationPreview?
  pending_animation_migration_paths : Array[String]
  pending_animation_migration_scene_path : String?
  animation_migration_in_progress : Bool
  animation_migration_total : Int
  animation_migration_completed : Int
  hover_hint : String?
  images_section_expanded : Bool
  atlases_section_expanded : Bool
  animation_clips_section_expanded : Bool
  animation_graphs_section_expanded : Bool
  prefabs_section_expanded : Bool
  status : String
  active_tool : @shared.PreviewTool
  move_snap_enabled : Bool
  move_snap_step : Double
  sidebar_scene_ratio : Double
  sidebar_assets_ratio : Double
  autotile_brush_terrain : Int
  autotile_palette_json_draft : String
  autotile_palette_json_error : String?
  animation_preview_paused : Bool
  animation_preview_speed : Double
  animation_preview_seek_input : String
  animation_preview_seek_seconds : Double
  animation_preview_seek_serial : Int
  graph_edge_connect_source_node : String?
  source : Model
} derive(Eq)

///|
pub fn view_state(model : Model) -> ViewState {
  {
    current_root: model.current_root,
    manifest: model.manifest,
    scene_refs: model.scene_refs,
    prefab_refs: model.prefab_refs,
    atlas_refs: model.atlas_refs,
    animation_clip_refs: model.animation_clip_refs,
    animation_graph_refs: model.animation_graph_refs,
    scene_session: model.scene_session,
    asset_query: model.asset_query,
    failed_image_assets: model.failed_image_assets,
    prefab_documents: model.prefab_documents,
    atlas_documents: model.atlas_documents,
    animation_clip_documents: model.animation_clip_documents,
    animation_graph_documents: model.animation_graph_documents,
    selected_resource: model.selected_resource,
    selected_entity_id: model.selected_entity_id,
    selected_entity_ids: model.selected_entity_ids,
    add_component_panel_open: model.add_component_panel_open,
    component_search_query: model.component_search_query,
    add_custom_component_kind: model.add_custom_component_kind,
    pending_scene_migration: model.pending_scene_migration,
    pending_animation_migration_paths: model.pending_animation_migration_paths,
    pending_animation_migration_scene_path: model.pending_animation_migration_scene_path,
    animation_migration_in_progress: model.animation_migration_in_progress,
    animation_migration_total: model.animation_migration_total,
    animation_migration_completed: model.animation_migration_completed,
    hover_hint: model.hover_hint,
    images_section_expanded: model.images_section_expanded,
    atlases_section_expanded: model.atlases_section_expanded,
    animation_clips_section_expanded: model.animation_clips_section_expanded,
    animation_graphs_section_expanded: model.animation_graphs_section_expanded,
    prefabs_section_expanded: model.prefabs_section_expanded,
    status: model.status,
    active_tool: model.active_tool,
    move_snap_enabled: model.move_snap_enabled,
    move_snap_step: model.move_snap_step,
    sidebar_scene_ratio: model.sidebar_scene_ratio,
    sidebar_assets_ratio: model.sidebar_assets_ratio,
    autotile_brush_terrain: model.autotile_brush_terrain,
    autotile_palette_json_draft: model.autotile_palette_json_draft,
    autotile_palette_json_error: model.autotile_palette_json_error,
    animation_preview_paused: model.animation_preview_paused,
    animation_preview_speed: model.animation_preview_speed,
    animation_preview_seek_input: model.animation_preview_seek_input,
    animation_preview_seek_seconds: model.animation_preview_seek_seconds,
    animation_preview_seek_serial: model.animation_preview_seek_serial,
    graph_edge_connect_source_node: model.graph_edge_connect_source_node,
    source: model,
  }
}

///|
pub fn ViewState::selected_entity(
  self : ViewState,
) -> @editor_bridge.EntityDocument? {
  self.source.selected_entity()
}

///|
pub fn ViewState::has_entity_selection(self : ViewState) -> Bool {
  self.source.has_entity_selection()
}

///|
pub fn ViewState::image_assets(
  self : ViewState,
) -> Array[@editor_bridge.AssetDocument] {
  self.source.image_assets()
}

///|
pub fn ViewState::selected_image_asset(
  self : ViewState,
) -> @editor_bridge.AssetDocument? {
  self.source.selected_image_asset()
}

///|
pub fn ViewState::selected_atlas_document(
  self : ViewState,
) -> (String, @editor_bridge.AtlasAssetDocument)? {
  self.source.selected_atlas_document()
}

///|
pub fn ViewState::selected_animation_clip_document(
  self : ViewState,
) -> (String, @editor_bridge.AnimationClipAssetDocument)? {
  self.source.selected_animation_clip_document()
}

///|
pub fn ViewState::selected_animation_graph_document(
  self : ViewState,
) -> (String, @editor_bridge.AnimationGraphAssetDocument)? {
  self.source.selected_animation_graph_document()
}

///|
pub fn ViewState::selected_prefab_document(
  self : ViewState,
) -> (String, @editor_bridge.PrefabDocument)? {
  self.source.selected_prefab_document()
}

///|
pub fn ViewState::asset_size(
  self : ViewState,
  path : String,
) -> @editor_bridge.Vec2Doc? {
  self.source.asset_size(path)
}

///|
pub fn ViewState::asset_query_normalized(self : ViewState) -> String {
  self.source.asset_query_normalized()
}

///|
pub fn ViewState::asset_matches_query(
  self : ViewState,
  name : String,
  path : String,
) -> Bool {
  self.source.asset_matches_query(name, path)
}

///|
pub fn ViewState::asset_tree_folder_expanded(
  self : ViewState,
  key : String,
) -> Bool {
  self.source.asset_tree_folder_expanded(key)
}

///|
pub fn ViewState::can_undo(self : ViewState) -> Bool {
  self.source.can_undo()
}

///|
pub fn ViewState::can_redo(self : ViewState) -> Bool {
  self.source.can_redo()
}

///|
pub fn ViewState::builtin_component_matches_query(
  self : ViewState,
  kind : @editor_bridge.BuiltinComponentKind,
) -> Bool {
  self.source.builtin_component_matches_query(kind)
}

///|
pub fn ViewState::component_card_collapsed(
  self : ViewState,
  entity_id : String,
  kind : String,
) -> Bool {
  self.source.component_card_collapsed(entity_id, kind)
}

///|
pub fn ViewState::component_menu_is_open(
  self : ViewState,
  kind : String,
) -> Bool {
  self.source.component_menu_is_open(kind)
}

///|
pub fn ViewState::component_search_query_normalized(self : ViewState) -> String {
  self.source.component_search_query_normalized()
}

///|
pub fn ViewState::selected_component_remove_block_reason(
  self : ViewState,
  kind : String,
) -> String? {
  self.source.selected_component_remove_block_reason(kind)
}

///|
pub fn ViewState::custom_component_json_draft(
  self : ViewState,
  entity_id : String,
  kind : String,
  fallback : Json,
) -> String {
  self.source.custom_component_json_draft(entity_id, kind, fallback)
}

///|
pub fn ViewState::custom_component_json_error(
  self : ViewState,
  entity_id : String,
  kind : String,
) -> String? {
  self.source.custom_component_json_error(entity_id, kind)
}

///|
pub enum Msg {
  Initialize
  OpenProject
  ProjectRootPicked(Result[@shared.DirectoryPickResult, String])
  ProjectLoaded(Result[@shared.ProjectStateResponse, String])
  SceneLoaded(Result[@shared.SceneLoadOutcome, String])
  ConfirmSceneMigration
  CancelSceneMigration
  ConfirmAnimationMigration
  CancelAnimationMigration
  SceneListLoaded(Result[@shared.SceneListResponse, String])
  AssetsLoaded(Result[@shared.AssetsListResponse, String])
  PrefabLoaded(Result[@shared.PrefabLoadResponse, String])
  AtlasLoaded(Result[@shared.AtlasLoadResponse, String])
  AnimationClipLoaded(Result[@shared.AnimationClipLoadResponse, String])
  AnimationGraphLoaded(Result[@shared.AnimationGraphLoadResponse, String])
  AssetSizeResolved(String, Double, Double)
  AssetImageLoadFailed(String)
  SetAssetQuery(String)
  SceneSaved(Result[SceneSaveOutcome, String])
  ResolveSceneConflictKeepMine
  ResolveSceneConflictReloadDisk
  ResolveSceneConflictSaveAs(String)
  AnimationMigrationSaved(Result[Unit, String])
  RpcAck(Result[Unit, String])
  WorkspaceSaved(Result[Unit, String])
  ServiceEvent(Result[@shared.EditorEvent, String])
  PreviewEvent(@bridge.PreviewEvent)
  SetHoverHint(String?)
  ToggleAssetTreeFolder(String)
  ExpandAllAssetFolders
  CollapseAllAssetFolders
  ToggleImagesSection
  ToggleAtlasesSection
  ToggleAnimationClipsSection
  ToggleAnimationGraphsSection
  TogglePrefabsSection
  ToggleMoveSnap
  AdjustMoveSnapStep(Int)
  SetSidebarLayout(Double, Double)
  CommitSceneEditTransaction
  UndoScene
  RedoScene
  ClearSelection
  OpenScene(String)
  SelectResource(ResourceSelection?)
  SelectEntity(String?)
  CreateScene(String)
  DeleteCurrentScene
  SetCurrentSceneAsStartup
  RenameCurrentScene(String)
  CreateAtlasFromSelectedImage
  CreateAnimationFromSelectedAtlas
  CreateAnimationGraphFromSelectedClip
  SaveSelectedAsPrefab
  InsertSelectedResource
  MoveSelectedResource(Int)
  OpenAddComponentPanel
  CloseAddComponentPanel
  SetComponentSearchQuery(String)
  ToggleComponentCollapsed(String)
  ToggleComponentMenu(String?)
  AddBuiltinComponent(@editor_bridge.BuiltinComponentKind)
  RemoveComponent(String)
  UpdateAddCustomComponentKind(String)
  AddCustomComponent(String)
  UpdateCustomComponentJson(String, String)
  CommitCustomComponentJson(String)
  UpdateSelectedPrefabName(String)
  SaveSelectedPrefab
  UpdateSelectedAtlasName(String)
  UpdateSelectedAtlasTileWidth(String)
  UpdateSelectedAtlasTileHeight(String)
  UpdateSelectedAtlasColumns(String)
  UpdateSelectedAtlasRows(String)
  UpdateSelectedAtlasSpacingX(String)
  UpdateSelectedAtlasSpacingY(String)
  UpdateSelectedAtlasMarginX(String)
  UpdateSelectedAtlasMarginY(String)
  UpdateSelectedAtlasAnchorX(String)
  UpdateSelectedAtlasAnchorY(String)
  SaveSelectedAtlas
  UpdateSelectedAnimationClipAssetName(String)
  UpdateSelectedAnimationGraphAssetName(String)
  UpdateSelectedAnimationGraphDefaultNode(String)
  UpdateSelectedAnimationClipFps(String)
  ToggleSelectedAnimationClipLooping
  UpdateSelectedAnimationClipFrames(String)
  AddSelectedAnimationGraphClipNode
  AddSelectedAnimationGraphBlendNode
  AddSelectedAnimationGraphAdditiveBlendNode
  RemoveSelectedAnimationGraphNode(String)
  UpdateSelectedAnimationGraphNodeClipPath(String, String)
  AddSelectedAnimationGraphEdge(String)
  RemoveSelectedAnimationGraphEdge(String, Int)
  UpdateSelectedAnimationGraphEdgeTarget(String, Int, String)
  UpdateSelectedAnimationGraphEdgeWeight(String, Int, String)
  BeginSelectedAnimationGraphEdgeConnect(String)
  CompleteSelectedAnimationGraphEdgeConnect(String)
  CancelSelectedAnimationGraphEdgeConnect
  MoveSelectedAnimationGraphNode(String, Double, Double)
  ToggleAnimationPreviewPaused
  UpdateAnimationPreviewSpeed(String)
  UpdateAnimationPreviewSeekInput(String)
  ApplyAnimationPreviewSeek
  SaveSelectedAnimationClip
  SaveSelectedAnimationGraph
  RenameSelected(String)
  UpdateSelectedTranslateX(String)
  UpdateSelectedTranslateY(String)
  UpdateSelectedRotation(String)
  UpdateSelectedText(String)
  ToggleSelectedVisibility
  UpdateSelectedAutoTileAtlasPath(String)
  UpdateSelectedAutoTileTileWidth(String)
  UpdateSelectedAutoTileTileHeight(String)
  UpdateSelectedAutoTileOriginX(String)
  UpdateSelectedAutoTileOriginY(String)
  UpdateSelectedAutoTileRuleSet(String)
  UpdateSelectedAutoTilePaletteJson(String)
  CommitSelectedAutoTilePaletteJson
  UpdateAutoTileBrushTerrain(String)
  UpdateSelectedAnimationPlayerGraphPath(String)
  UpdateSelectedAnimationPlayerStartNode(String)
  ToggleSelectedAnimationPlayerAutoplay
  UpdateSelectedAnimationPlayerRepeatMode(String)
  UpdateSelectedAnimationPlayerSpeed(String)
  UpdateSelectedAnimationTransitionsDuration(String)
  SaveScene
  AddSpriteEntity
  AddSpriteFromAssetAt(String, @editor_bridge.Vec2Doc)
  AddTextEntity
  DeleteSelected
  SetTool(@shared.PreviewTool)
  FrameSelection
}

///|
pub enum Effect {
  Rpc(binding~ : RpcBinding)
  SubscribeServiceEvents
  SubscribePreviewEvents
  SubscribeKeyboardShortcuts
  SubscribeSidebarLayout
  Preview(@bridge.PreviewCommand)
} derive(Eq)

///|
pub fn new_model() -> Model {
  {
    project_root_input: "",
    project_name_input: "Selene Project",
    current_root: None,
    manifest: None,
    recent_projects: [],
    scene_refs: [],
    prefab_refs: [],
    atlas_refs: [],
    animation_clip_refs: [],
    animation_graph_refs: [],
    scene_session: None,
    assets: [],
    asset_sizes: {},
    asset_query: "",
    failed_image_assets: {},
    prefab_documents: {},
    atlas_documents: {},
    animation_clip_documents: {},
    animation_graph_documents: {},
    workspace: @editor_bridge.WorkspaceDocument::default(),
    selected_resource: None,
    selected_entity_id: None,
    selected_entity_ids: [],
    add_component_panel_open: false,
    component_search_query: "",
    open_component_menu_kind: None,
    collapsed_component_cards: {},
    add_custom_component_kind: "",
    custom_component_json_drafts: {},
    custom_component_json_errors: {},
    pending_scene_migration: None,
    pending_animation_migration_paths: [],
    pending_animation_migration_scene_path: None,
    animation_migration_in_progress: false,
    animation_migration_total: 0,
    animation_migration_completed: 0,
    animation_migration_failed: 0,
    animation_migration_prompt_dismissed: false,
    hover_hint: None,
    asset_tree_expanded: {},
    images_section_expanded: true,
    atlases_section_expanded: true,
    animation_clips_section_expanded: true,
    animation_graphs_section_expanded: true,
    prefabs_section_expanded: true,
    status: "Choose a project folder to begin",
    logs: [],
    active_tool: @shared.preview_tool_select(),
    move_snap_enabled: false,
    move_snap_step: 16.0,
    sidebar_scene_ratio: 0.18,
    sidebar_assets_ratio: 0.47,
    autotile_brush_terrain: 1,
    autotile_palette_json_draft: "",
    autotile_palette_json_error: None,
    animation_preview_paused: false,
    animation_preview_speed: 1.0,
    animation_preview_seek_input: "0",
    animation_preview_seek_seconds: 0.0,
    animation_preview_seek_serial: 0,
    graph_edge_connect_source_node: None,
  }
}
