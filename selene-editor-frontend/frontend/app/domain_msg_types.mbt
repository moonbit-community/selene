///|
priv enum DomainMsg {
  ProjectRuntime(ProjectRuntimeMsg)
  SelectionHistoryTools(SelectionHistoryToolsMsg)
  SceneLifecycle(SceneLifecycleMsg)
  AssetsResources(AssetsResourcesMsg)
  InspectorComponents(InspectorComponentsMsg)
  AnimationEditor(AnimationEditorMsg)
}

///|
priv enum ProjectRuntimeMsg {
  Initialize
  OpenProject
  ProjectRootPicked(Result[@shared.DirectoryPickResult, String])
  ProjectLoaded(Result[@shared.ProjectStateResponse, String])
  SceneLoaded(Result[@shared.SceneLoadOutcome, String])
  ConfirmSceneMigration
  CancelSceneMigration
  ConfirmAnimationMigration
  CancelAnimationMigration
  AnimationMigrationSaved(Result[Unit, String])
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
  WorkspaceSaved(Result[Unit, String])
  ServiceEvent(Result[@shared.EditorEvent, String])
  PreviewEvent(@bridge.PreviewEvent)
}

///|
priv enum SelectionHistoryToolsMsg {
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
  SelectResource(ResourceSelection?)
  SelectEntity(String?)
  MoveSelectedResource(Int)
  SetTool(@shared.PreviewTool)
  FrameSelection
}

///|
priv enum SceneLifecycleMsg {
  OpenScene(String)
  CreateScene(String)
  DeleteCurrentScene
  SetCurrentSceneAsStartup
  RenameCurrentScene(String)
  SaveScene
  AddSpriteEntity
  AddSpriteFromAssetAt(String, @editor_bridge.Vec2Doc)
  AddTextEntity
  DeleteSelected
}

///|
priv enum AssetsResourcesMsg {
  CreateAtlasFromSelectedImage
  CreateAnimationFromSelectedAtlas
  CreateAnimationGraphFromSelectedClip
  SaveSelectedAsPrefab
  InsertSelectedResource
}

///|
priv enum InspectorComponentsMsg {
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
}

///|
priv enum AnimationEditorMsg {
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
  UpdateSelectedAnimationPlayerGraphPath(String)
  UpdateSelectedAnimationPlayerStartNode(String)
  ToggleSelectedAnimationPlayerAutoplay
  UpdateSelectedAnimationPlayerRepeatMode(String)
  UpdateSelectedAnimationPlayerSpeed(String)
  UpdateSelectedAnimationTransitionsDuration(String)
}
