///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  let model = if is_scene_edit_continuation(msg) {
    model
  } else {
    with_committed_scene_edit_transaction(model)
  }
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
    | PreviewEvent(_) => update_project_runtime(msg, model)
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
    | SelectResource(_)
    | SelectEntity(_)
    | MoveSelectedResource(_)
    | SetTool(_)
    | FrameSelection => update_selection_history_tools(msg, model)
    OpenScene(_)
    | CreateScene(_)
    | DeleteCurrentScene
    | SetCurrentSceneAsStartup
    | RenameCurrentScene(_)
    | SaveScene
    | ReloadScene
    | AddSpriteEntity
    | AddSpriteFromAsset(_)
    | AddSpriteFromAssetAt(_, _)
    | AddTextEntity
    | DeleteSelected => update_scene_lifecycle(msg, model)
    CreateAtlasFromSelectedImage
    | CreateAnimationFromSelectedAtlas
    | CreateAnimationGraphFromSelectedClip
    | SaveSelectedAsPrefab
    | InsertSelectedResource => update_assets_resources(msg, model)
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
    | RenameSelected(_)
    | UpdateSelectedTranslateX(_)
    | UpdateSelectedTranslateY(_)
    | UpdateSelectedRotation(_)
    | UpdateSelectedText(_)
    | ToggleSelectedVisibility => update_inspector_components(msg, model)
    UpdateSelectedAnimationClipAssetName(_)
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
    | UpdateSelectedAnimationPlayerGraphPath(_)
    | UpdateSelectedAnimationPlayerStartNode(_)
    | ToggleSelectedAnimationPlayerAutoplay
    | UpdateSelectedAnimationPlayerRepeatMode(_)
    | UpdateSelectedAnimationPlayerSpeed(_)
    | UpdateSelectedAnimationTransitionsDuration(_) =>
      update_animation_editor(msg, model)
  }
}
