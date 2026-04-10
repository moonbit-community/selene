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
  scene_path : String
  scene : @editor_bridge.SceneDocument?
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
  undo_stack : Array[@editor_bridge.SceneDocument]
  redo_stack : Array[@editor_bridge.SceneDocument]
  active_scene_edit_transaction : SceneEditTransaction?
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
  animation_preview_paused : Bool
  animation_preview_speed : Double
  animation_preview_seek_input : String
  graph_edge_connect_source_node : String?
} derive(Eq)

///|
pub enum Msg {
  Initialize
  SetProjectRootInput(String)
  SetProjectNameInput(String)
  PickProjectRoot
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
  SceneSaved(Result[Unit, String])
  AnimationMigrationSaved(Result[Unit, String])
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
  UpdateSelectedAnimationClipName(String)
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
  UpdateSelectedAnimationPlayerGraphPath(String)
  UpdateSelectedAnimationPlayerStartNode(String)
  ToggleSelectedAnimationPlayerAutoplay
  UpdateSelectedAnimationPlayerRepeatMode(String)
  UpdateSelectedAnimationPlayerSpeed(String)
  UpdateSelectedAnimationTransitionsDuration(String)
  SaveScene
  ReloadScene
  AddSpriteEntity
  AddSpriteFromAsset(String)
  AddSpriteFromAssetAt(String, @editor_bridge.Vec2Doc)
  AddTextEntity
  DeleteSelected
  SetTool(@shared.PreviewTool)
  FrameSelection
}

///|
pub enum RpcTarget {
  ProjectLoaded
  ProjectRootPicked
  SceneLoaded
  SceneListLoaded
  AssetsLoaded
  PrefabLoaded
  AtlasLoaded
  AnimationClipLoaded
  AnimationGraphLoaded
  SceneSaved
  AnimationMigrationSaved
  WorkspaceSaved
} derive(Eq)

///|
pub enum Effect {
  Rpc(target~ : RpcTarget, request~ : @shared.RpcRequestEnvelope)
  SubscribeServiceEvents
  SubscribePreviewEvents
  SubscribeKeyboardShortcuts
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
    scene_path: @editor_bridge.startup_scene_path_for_name("main"),
    scene: None,
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
    undo_stack: [],
    redo_stack: [],
    active_scene_edit_transaction: None,
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
    animation_preview_paused: false,
    animation_preview_speed: 1.0,
    animation_preview_seek_input: "0",
    graph_edge_connect_source_node: None,
  }
}
