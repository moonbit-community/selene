///|
pub struct RpcErrorDocument {
  code : String
  message : String
  details : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct DirectoryPickResult {
  path : String?
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct ProjectStateResponse {
  root : String?
  manifest : @editor_bridge.ProjectManifest?
  scenes : Array[@editor_bridge.SceneRef]
  prefabs : Array[@editor_bridge.PrefabRef]
  atlases : Array[@editor_bridge.AssetRef]
  animations : Array[@editor_bridge.AssetRef]
  workspace : @editor_bridge.WorkspaceDocument?
  recent_projects : Array[String]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneBundleAtlasEntry {
  path : String
  atlas : @editor_bridge.AtlasAssetDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneBundleAnimationEntry {
  path : String
  animation : @editor_bridge.AnimationAssetDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneBundleResponse {
  path : String
  scene : @editor_bridge.SceneDocument
  atlas_assets : Array[SceneBundleAtlasEntry]
  animation_assets : Array[SceneBundleAnimationEntry]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum SceneLoadOutcome {
  Loaded(SceneBundleResponse)
  MigrationRequired(@editor_bridge.SceneMigrationPreview)
} derive(Show, Eq)

///|
pub struct SceneListResponse {
  scenes : Array[@editor_bridge.SceneRef]
  startup_scene : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AssetsListResponse {
  assets : Array[@editor_bridge.AssetDocument]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct PrefabLoadResponse {
  path : String
  prefab : @editor_bridge.PrefabDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AtlasLoadResponse {
  path : String
  atlas : @editor_bridge.AtlasAssetDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AnimationLoadResponse {
  path : String
  animation : @editor_bridge.AnimationAssetDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum RpcRequest {
  ProjectCurrent
  ProjectOpen(root~ : String)
  ProjectPickDirectory(prompt~ : String)
  ProjectSetStartupScene(path~ : String)
  SceneLoad(path~ : String)
  SceneMigrate(path~ : String)
  SceneList
  SceneCreate(name~ : String)
  SceneSave(path~ : String, scene~ : @editor_bridge.SceneDocument)
  SceneDelete(path~ : String)
  AssetsList
  PrefabLoad(path~ : String)
  PrefabSave(path~ : String, prefab~ : @editor_bridge.PrefabDocument)
  AtlasLoad(path~ : String)
  AtlasSave(path~ : String, atlas~ : @editor_bridge.AtlasAssetDocument)
  AnimationLoad(path~ : String)
  AnimationSave(
    path~ : String,
    animation~ : @editor_bridge.AnimationAssetDocument
  )
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum RpcResponse {
  ProjectState(state~ : ProjectStateResponse)
  DirectoryPicked(result~ : DirectoryPickResult)
  SceneLoaded(scene~ : SceneBundleResponse)
  SceneMigrationRequired(preview~ : @editor_bridge.SceneMigrationPreview)
  SceneListed(list~ : SceneListResponse)
  AssetsListed(list~ : AssetsListResponse)
  PrefabLoaded(prefab~ : PrefabLoadResponse)
  AtlasLoaded(atlas~ : AtlasLoadResponse)
  AnimationLoaded(animation~ : AnimationLoadResponse)
  StartupSceneUpdated(manifest~ : @editor_bridge.ProjectManifest)
  SavedOk
  Error(error~ : RpcErrorDocument)
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RpcRequestEnvelope {
  id : Int
  request : RpcRequest
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RpcResponseEnvelope {
  id : Int
  response : RpcResponse
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum EditorEvent {
  Ready
  Log(label~ : String, message~ : String)
  ProjectOpened(root~ : String, manifest~ : @editor_bridge.ProjectManifest)
  FilesChanged(paths~ : Array[String])
  SceneCreated(path~ : String)
  SceneSaved(path~ : String)
  SceneDeleted(path~ : String)
  AssetImported(asset~ : @editor_bridge.AssetDocument)
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct EventEnvelope {
  event : EditorEvent
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn directory_pick_result(path : String?) -> DirectoryPickResult {
  { path, }
}

///|
pub fn project_state_response(
  root : String?,
  manifest : @editor_bridge.ProjectManifest?,
  scenes : Array[@editor_bridge.SceneRef],
  prefabs : Array[@editor_bridge.PrefabRef],
  atlases : Array[@editor_bridge.AssetRef],
  animations : Array[@editor_bridge.AssetRef],
  workspace : @editor_bridge.WorkspaceDocument?,
  recent_projects : Array[String],
) -> ProjectStateResponse {
  {
    root,
    manifest,
    scenes,
    prefabs,
    atlases,
    animations,
    workspace,
    recent_projects,
  }
}

///|
pub fn scene_bundle_atlas_entry(
  path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> SceneBundleAtlasEntry {
  { path, atlas }
}

///|
pub fn scene_bundle_animation_entry(
  path : String,
  animation : @editor_bridge.AnimationAssetDocument,
) -> SceneBundleAnimationEntry {
  { path, animation }
}

///|
pub fn scene_bundle_response(
  path : String,
  scene : @editor_bridge.SceneDocument,
) -> SceneBundleResponse {
  { path, scene, atlas_assets: [], animation_assets: [] }
}

///|
pub fn SceneBundleResponse::with_assets(
  self : SceneBundleResponse,
  atlas_assets : Array[SceneBundleAtlasEntry],
  animation_assets : Array[SceneBundleAnimationEntry],
) -> SceneBundleResponse {
  { ..self, atlas_assets, animation_assets }
}

///|
pub fn scene_load_outcome_loaded(
  scene : SceneBundleResponse,
) -> SceneLoadOutcome {
  Loaded(scene)
}

///|
pub fn scene_load_outcome_migration_required(
  preview : @editor_bridge.SceneMigrationPreview,
) -> SceneLoadOutcome {
  MigrationRequired(preview)
}

///|
pub fn scene_list_response(
  scenes : Array[@editor_bridge.SceneRef],
  startup_scene : String,
) -> SceneListResponse {
  { scenes, startup_scene }
}

///|
pub fn assets_list_response(
  assets : Array[@editor_bridge.AssetDocument],
) -> AssetsListResponse {
  { assets, }
}

///|
pub fn prefab_load_response(
  path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> PrefabLoadResponse {
  { path, prefab }
}

///|
pub fn atlas_load_response(
  path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> AtlasLoadResponse {
  { path, atlas }
}

///|
pub fn animation_load_response(
  path : String,
  animation : @editor_bridge.AnimationAssetDocument,
) -> AnimationLoadResponse {
  { path, animation }
}

///|
pub enum PreviewTool {
  Select
  Translate
  Rotate
  Scale
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum PreviewPivotMode {
  TransformOrigin
  BoundsCenter
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn preview_tool_select() -> PreviewTool {
  Select
}

///|
pub fn preview_tool_translate() -> PreviewTool {
  Translate
}

///|
pub fn preview_tool_rotate() -> PreviewTool {
  Rotate
}

///|
pub fn preview_tool_scale() -> PreviewTool {
  Scale
}

///|
pub fn preview_pivot_mode_transform_origin() -> PreviewPivotMode {
  TransformOrigin
}

///|
pub fn preview_pivot_mode_bounds_center() -> PreviewPivotMode {
  BoundsCenter
}

///|
pub fn rpc_request_project_current() -> RpcRequest {
  ProjectCurrent
}

///|
pub fn rpc_request_project_open(root : String) -> RpcRequest {
  ProjectOpen(root~)
}

///|
pub fn rpc_request_project_pick_directory(prompt : String) -> RpcRequest {
  ProjectPickDirectory(prompt~)
}

///|
pub fn rpc_request_project_set_startup_scene(path : String) -> RpcRequest {
  ProjectSetStartupScene(path~)
}

///|
pub fn rpc_request_scene_load(path : String) -> RpcRequest {
  SceneLoad(path~)
}

///|
pub fn rpc_request_scene_migrate(path : String) -> RpcRequest {
  SceneMigrate(path~)
}

///|
pub fn rpc_request_scene_list() -> RpcRequest {
  SceneList
}

///|
pub fn rpc_request_scene_create(name : String) -> RpcRequest {
  SceneCreate(name~)
}

///|
pub fn rpc_request_scene_save(
  path : String,
  scene : @editor_bridge.SceneDocument,
) -> RpcRequest {
  SceneSave(path~, scene~)
}

///|
pub fn rpc_request_scene_delete(path : String) -> RpcRequest {
  SceneDelete(path~)
}

///|
pub fn rpc_request_assets_list() -> RpcRequest {
  AssetsList
}

///|
pub fn rpc_request_prefab_load(path : String) -> RpcRequest {
  PrefabLoad(path~)
}

///|
pub fn rpc_request_prefab_save(
  path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> RpcRequest {
  PrefabSave(path~, prefab~)
}

///|
pub fn rpc_request_atlas_load(path : String) -> RpcRequest {
  AtlasLoad(path~)
}

///|
pub fn rpc_request_atlas_save(
  path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> RpcRequest {
  AtlasSave(path~, atlas~)
}

///|
pub fn rpc_request_animation_load(path : String) -> RpcRequest {
  AnimationLoad(path~)
}

///|
pub fn rpc_request_animation_save(
  path : String,
  animation : @editor_bridge.AnimationAssetDocument,
) -> RpcRequest {
  AnimationSave(path~, animation~)
}

///|
pub fn rpc_request_envelope(
  id : Int,
  request : RpcRequest,
) -> RpcRequestEnvelope {
  { id, request }
}

///|
pub fn rpc_response_envelope(
  id : Int,
  response : RpcResponse,
) -> RpcResponseEnvelope {
  { id, response }
}

///|
pub fn rpc_response_project_state(state : ProjectStateResponse) -> RpcResponse {
  ProjectState(state~)
}

///|
pub fn rpc_response_directory_picked(
  result : DirectoryPickResult,
) -> RpcResponse {
  DirectoryPicked(result~)
}

///|
pub fn rpc_response_scene_loaded(scene : SceneBundleResponse) -> RpcResponse {
  SceneLoaded(scene~)
}

///|
pub fn rpc_response_scene_migration_required(
  preview : @editor_bridge.SceneMigrationPreview,
) -> RpcResponse {
  SceneMigrationRequired(preview~)
}

///|
pub fn rpc_response_scene_listed(list : SceneListResponse) -> RpcResponse {
  SceneListed(list~)
}

///|
pub fn rpc_response_assets_listed(list : AssetsListResponse) -> RpcResponse {
  AssetsListed(list~)
}

///|
pub fn rpc_response_prefab_loaded(prefab : PrefabLoadResponse) -> RpcResponse {
  PrefabLoaded(prefab~)
}

///|
pub fn rpc_response_atlas_loaded(atlas : AtlasLoadResponse) -> RpcResponse {
  AtlasLoaded(atlas~)
}

///|
pub fn rpc_response_animation_loaded(
  animation : AnimationLoadResponse,
) -> RpcResponse {
  AnimationLoaded(animation~)
}

///|
pub fn rpc_response_startup_scene_updated(
  manifest : @editor_bridge.ProjectManifest,
) -> RpcResponse {
  StartupSceneUpdated(manifest~)
}

///|
pub fn rpc_response_saved_ok() -> RpcResponse {
  SavedOk
}

///|
pub fn rpc_error_response(
  id : Int,
  code : String,
  message : String,
  details? : Json = Json::null(),
) -> RpcResponseEnvelope {
  rpc_response_envelope(id, Error(error={ code, message, details }))
}

///|
pub fn event_envelope(event : EditorEvent) -> EventEnvelope {
  { event, }
}

///|
pub fn editor_event_ready() -> EditorEvent {
  Ready
}

///|
pub fn editor_event_log(label : String, message : String) -> EditorEvent {
  Log(label~, message~)
}

///|
pub fn editor_event_project_opened(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> EditorEvent {
  ProjectOpened(root~, manifest~)
}

///|
pub fn editor_event_files_changed(paths : Array[String]) -> EditorEvent {
  FilesChanged(paths~)
}

///|
pub fn editor_event_scene_created(path : String) -> EditorEvent {
  SceneCreated(path~)
}

///|
pub fn editor_event_scene_saved(path : String) -> EditorEvent {
  SceneSaved(path~)
}

///|
pub fn editor_event_scene_deleted(path : String) -> EditorEvent {
  SceneDeleted(path~)
}

///|
pub fn editor_event_asset_imported(
  asset : @editor_bridge.AssetDocument,
) -> EditorEvent {
  AssetImported(asset~)
}
