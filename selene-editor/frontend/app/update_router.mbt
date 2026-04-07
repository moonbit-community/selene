///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  let model = if is_scene_edit_continuation(msg) {
    model
  } else {
    with_committed_scene_edit_transaction(model)
  }
  if is_project_runtime_msg(msg) {
    update_project_runtime_msg(msg, model)
  } else if is_navigation_resource_msg(msg) {
    update_navigation_resource_msg(msg, model)
  } else if is_inspector_animation_msg(msg) {
    update_inspector_animation_msg(msg, model)
  } else {
    update_scene_tool_msg(msg, model)
  }
}

///|
fn update_project_runtime_msg(
  msg : Msg,
  model : Model,
) -> (Array[Effect], Model) {
  update_monolithic(msg, model)
}

///|
fn update_navigation_resource_msg(
  msg : Msg,
  model : Model,
) -> (Array[Effect], Model) {
  update_monolithic(msg, model)
}

///|
fn update_inspector_animation_msg(
  msg : Msg,
  model : Model,
) -> (Array[Effect], Model) {
  update_monolithic(msg, model)
}

///|
fn update_scene_tool_msg(msg : Msg, model : Model) -> (Array[Effect], Model) {
  update_monolithic(msg, model)
}

///|
fn is_project_runtime_msg(msg : Msg) -> Bool {
  match msg {
    Initialize
    | SetProjectRootInput(_)
    | SetProjectNameInput(_)
    | PickProjectRoot
    | OpenProject
    | ProjectRootPicked(_)
    | ProjectLoaded(_)
    | SceneLoaded(_)
    | ConfirmSceneMigration
    | CancelSceneMigration
    | ConfirmAnimationMigration
    | CancelAnimationMigration
    | AnimationMigrationSaved(_)
    | SceneListLoaded(_)
    | AssetsLoaded(_)
    | PrefabLoaded(_)
    | AtlasLoaded(_)
    | AnimationClipLoaded(_)
    | AnimationGraphLoaded(_)
    | AssetSizeResolved(_, _, _)
    | AssetImageLoadFailed(_)
    | SetAssetQuery(_)
    | SceneSaved(_)
    | WorkspaceSaved(_)
    | ServiceEvent(_)
    | PreviewEvent(_) => true
    _ => false
  }
}

///|
fn is_navigation_resource_msg(msg : Msg) -> Bool {
  match msg {
    SetHoverHint(_)
    | ToggleAssetTreeFolder(_)
    | ExpandAllAssetFolders
    | CollapseAllAssetFolders
    | ToggleImagesSection
    | ToggleAtlasesSection
    | ToggleAnimationClipsSection
    | ToggleAnimationGraphsSection
    | TogglePrefabsSection
    | ToggleMoveSnap
    | AdjustMoveSnapStep(_)
    | CommitSceneEditTransaction
    | UndoScene
    | RedoScene
    | ClearSelection
    | OpenScene(_)
    | SelectResource(_)
    | SelectEntity(_)
    | CreateScene(_)
    | DeleteCurrentScene
    | SetCurrentSceneAsStartup
    | RenameCurrentScene(_)
    | CreateAtlasFromSelectedImage
    | CreateAnimationFromSelectedAtlas
    | CreateAnimationGraphFromSelectedClip
    | SaveSelectedAsPrefab
    | InsertSelectedResource
    | MoveSelectedResource(_) => true
    _ => false
  }
}

///|
fn is_inspector_animation_msg(msg : Msg) -> Bool {
  match msg {
    OpenAddComponentPanel
    | CloseAddComponentPanel
    | SetComponentSearchQuery(_)
    | ToggleComponentCollapsed(_)
    | ToggleComponentMenu(_)
    | AddBuiltinComponent(_)
    | RemoveComponent(_)
    | UpdateAddCustomComponentKind(_)
    | AddCustomComponent(_)
    | UpdateCustomComponentJson(_, _)
    | CommitCustomComponentJson(_)
    | UpdateSelectedPrefabName(_)
    | SaveSelectedPrefab
    | UpdateSelectedAtlasName(_)
    | UpdateSelectedAtlasTileWidth(_)
    | UpdateSelectedAtlasTileHeight(_)
    | UpdateSelectedAtlasColumns(_)
    | UpdateSelectedAtlasRows(_)
    | UpdateSelectedAtlasSpacingX(_)
    | UpdateSelectedAtlasSpacingY(_)
    | UpdateSelectedAtlasMarginX(_)
    | UpdateSelectedAtlasMarginY(_)
    | UpdateSelectedAtlasAnchorX(_)
    | UpdateSelectedAtlasAnchorY(_)
    | SaveSelectedAtlas
    | UpdateSelectedAnimationClipAssetName(_)
    | UpdateSelectedAnimationGraphAssetName(_)
    | UpdateSelectedAnimationGraphDefaultNode(_)
    | UpdateSelectedAnimationClipName(_)
    | UpdateSelectedAnimationClipFps(_)
    | ToggleSelectedAnimationClipLooping
    | UpdateSelectedAnimationClipFrames(_)
    | AddSelectedAnimationGraphClipNode
    | AddSelectedAnimationGraphBlendNode
    | AddSelectedAnimationGraphAdditiveBlendNode
    | RemoveSelectedAnimationGraphNode(_)
    | UpdateSelectedAnimationGraphNodeClipPath(_, _)
    | AddSelectedAnimationGraphEdge(_)
    | RemoveSelectedAnimationGraphEdge(_, _)
    | UpdateSelectedAnimationGraphEdgeTarget(_, _, _)
    | UpdateSelectedAnimationGraphEdgeWeight(_, _, _)
    | BeginSelectedAnimationGraphEdgeConnect(_)
    | CompleteSelectedAnimationGraphEdgeConnect(_)
    | CancelSelectedAnimationGraphEdgeConnect
    | MoveSelectedAnimationGraphNode(_, _, _)
    | ToggleAnimationPreviewPaused
    | UpdateAnimationPreviewSpeed(_)
    | UpdateAnimationPreviewSeekInput(_)
    | ApplyAnimationPreviewSeek
    | SaveSelectedAnimationClip
    | SaveSelectedAnimationGraph
    | RenameSelected(_)
    | UpdateSelectedTranslateX(_)
    | UpdateSelectedTranslateY(_)
    | UpdateSelectedRotation(_)
    | UpdateSelectedText(_)
    | ToggleSelectedVisibility
    | UpdateSelectedAnimationPlayerGraphPath(_)
    | UpdateSelectedAnimationPlayerStartNode(_)
    | ToggleSelectedAnimationPlayerAutoplay
    | UpdateSelectedAnimationPlayerRepeatMode(_)
    | UpdateSelectedAnimationPlayerSpeed(_)
    | UpdateSelectedAnimationTransitionsDuration(_) => true
    _ => false
  }
}
