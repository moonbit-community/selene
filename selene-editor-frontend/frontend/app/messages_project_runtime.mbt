///|
pub fn msg_initialize() -> Msg {
  Initialize
}

///|
pub fn msg_open_project() -> Msg {
  OpenProject
}

///|
pub fn msg_project_root_picked(
  result : AsyncOutcome[@shared.DirectoryPickResult],
) -> Msg {
  ProjectRootPicked(result)
}

///|
pub fn msg_project_loaded(
  result : AsyncOutcome[@shared.ProjectStateResponse],
) -> Msg {
  ProjectLoaded(result)
}

///|
pub fn msg_scene_loaded(result : AsyncOutcome[@shared.SceneLoadOutcome]) -> Msg {
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
  result : AsyncOutcome[@shared.SceneListResponse],
) -> Msg {
  SceneListLoaded(result)
}

///|
pub fn msg_assets_loaded(
  result : AsyncOutcome[@shared.AssetsListResponse],
) -> Msg {
  AssetsLoaded(result)
}

///|
pub fn msg_prefab_loaded(
  result : AsyncOutcome[@shared.PrefabLoadResponse],
) -> Msg {
  PrefabLoaded(result)
}

///|
pub fn msg_atlas_loaded(
  result : AsyncOutcome[@shared.AtlasLoadResponse],
) -> Msg {
  AtlasLoaded(result)
}

///|
pub fn msg_animation_clip_loaded(
  result : AsyncOutcome[@shared.AnimationClipLoadResponse],
) -> Msg {
  AnimationClipLoaded(result)
}

///|
pub fn msg_animation_graph_loaded(
  result : AsyncOutcome[@shared.AnimationGraphLoadResponse],
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
pub fn msg_scene_saved(result : AsyncOutcome[SceneSaveOutcome]) -> Msg {
  SceneSaved(result)
}

///|
pub fn msg_resolve_scene_conflict_keep_mine() -> Msg {
  ResolveSceneConflictKeepMine
}

///|
pub fn msg_resolve_scene_conflict_reload_disk() -> Msg {
  ResolveSceneConflictReloadDisk
}

///|
pub fn msg_resolve_scene_conflict_save_as(path : String) -> Msg {
  ResolveSceneConflictSaveAs(path)
}

///|
pub fn msg_animation_migration_saved(result : AsyncOutcome[Unit]) -> Msg {
  AnimationMigrationSaved(result)
}

///|
pub fn msg_workspace_saved(result : AsyncOutcome[Unit]) -> Msg {
  WorkspaceSaved(result)
}

///|
pub fn msg_rpc_ack(result : AsyncOutcome[Unit]) -> Msg {
  RpcAck(result)
}

///|
pub fn msg_service_event(result : AsyncOutcome[@shared.EditorEvent]) -> Msg {
  ServiceEvent(result)
}

///|
pub fn msg_preview_event(event : @bridge.PreviewEvent) -> Msg {
  PreviewEvent(event)
}
