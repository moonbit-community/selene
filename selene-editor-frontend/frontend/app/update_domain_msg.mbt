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
  ReloadScene
  AddSpriteEntity
  AddSpriteFromAsset(String)
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
  UpdateSelectedAnimationPlayerGraphPath(String)
  UpdateSelectedAnimationPlayerStartNode(String)
  ToggleSelectedAnimationPlayerAutoplay
  UpdateSelectedAnimationPlayerRepeatMode(String)
  UpdateSelectedAnimationPlayerSpeed(String)
  UpdateSelectedAnimationTransitionsDuration(String)
}

///|
fn to_domain_msg(msg : Msg) -> DomainMsg {
  match msg {
    Initialize => ProjectRuntime(Initialize)
    SetProjectRootInput(value) => ProjectRuntime(SetProjectRootInput(value))
    SetProjectNameInput(value) => ProjectRuntime(SetProjectNameInput(value))
    PickProjectRoot => ProjectRuntime(PickProjectRoot)
    OpenProject => ProjectRuntime(OpenProject)
    ProjectRootPicked(result) => ProjectRuntime(ProjectRootPicked(result))
    ProjectLoaded(result) => ProjectRuntime(ProjectLoaded(result))
    SceneLoaded(result) => ProjectRuntime(SceneLoaded(result))
    ConfirmSceneMigration => ProjectRuntime(ConfirmSceneMigration)
    CancelSceneMigration => ProjectRuntime(CancelSceneMigration)
    ConfirmAnimationMigration => ProjectRuntime(ConfirmAnimationMigration)
    CancelAnimationMigration => ProjectRuntime(CancelAnimationMigration)
    SceneListLoaded(result) => ProjectRuntime(SceneListLoaded(result))
    AssetsLoaded(result) => ProjectRuntime(AssetsLoaded(result))
    PrefabLoaded(result) => ProjectRuntime(PrefabLoaded(result))
    AtlasLoaded(result) => ProjectRuntime(AtlasLoaded(result))
    AnimationClipLoaded(result) => ProjectRuntime(AnimationClipLoaded(result))
    AnimationGraphLoaded(result) => ProjectRuntime(AnimationGraphLoaded(result))
    AssetSizeResolved(path, width, height) =>
      ProjectRuntime(AssetSizeResolved(path, width, height))
    AssetImageLoadFailed(path) => ProjectRuntime(AssetImageLoadFailed(path))
    SetAssetQuery(value) => ProjectRuntime(SetAssetQuery(value))
    SceneSaved(result) => ProjectRuntime(SceneSaved(result))
    ResolveSceneConflictKeepMine => ProjectRuntime(ResolveSceneConflictKeepMine)
    ResolveSceneConflictReloadDisk =>
      ProjectRuntime(ResolveSceneConflictReloadDisk)
    ResolveSceneConflictSaveAs(path) =>
      ProjectRuntime(ResolveSceneConflictSaveAs(path))
    AnimationMigrationSaved(result) =>
      ProjectRuntime(AnimationMigrationSaved(result))
    WorkspaceSaved(result) => ProjectRuntime(WorkspaceSaved(result))
    ServiceEvent(result) => ProjectRuntime(ServiceEvent(result))
    PreviewEvent(event) => ProjectRuntime(PreviewEvent(event))
    SetHoverHint(hint) => SelectionHistoryTools(SetHoverHint(hint))
    ToggleAssetTreeFolder(key) =>
      SelectionHistoryTools(ToggleAssetTreeFolder(key))
    ExpandAllAssetFolders => SelectionHistoryTools(ExpandAllAssetFolders)
    CollapseAllAssetFolders => SelectionHistoryTools(CollapseAllAssetFolders)
    ToggleImagesSection => SelectionHistoryTools(ToggleImagesSection)
    ToggleAtlasesSection => SelectionHistoryTools(ToggleAtlasesSection)
    ToggleAnimationClipsSection =>
      SelectionHistoryTools(ToggleAnimationClipsSection)
    ToggleAnimationGraphsSection =>
      SelectionHistoryTools(ToggleAnimationGraphsSection)
    TogglePrefabsSection => SelectionHistoryTools(TogglePrefabsSection)
    ToggleMoveSnap => SelectionHistoryTools(ToggleMoveSnap)
    AdjustMoveSnapStep(delta) =>
      SelectionHistoryTools(AdjustMoveSnapStep(delta))
    CommitSceneEditTransaction =>
      SelectionHistoryTools(CommitSceneEditTransaction)
    UndoScene => SelectionHistoryTools(UndoScene)
    RedoScene => SelectionHistoryTools(RedoScene)
    ClearSelection => SelectionHistoryTools(ClearSelection)
    OpenScene(path) => SceneLifecycle(OpenScene(path))
    SelectResource(resource) => SelectionHistoryTools(SelectResource(resource))
    SelectEntity(id) => SelectionHistoryTools(SelectEntity(id))
    CreateScene(name) => SceneLifecycle(CreateScene(name))
    DeleteCurrentScene => SceneLifecycle(DeleteCurrentScene)
    SetCurrentSceneAsStartup => SceneLifecycle(SetCurrentSceneAsStartup)
    RenameCurrentScene(value) => SceneLifecycle(RenameCurrentScene(value))
    CreateAtlasFromSelectedImage =>
      AssetsResources(CreateAtlasFromSelectedImage)
    CreateAnimationFromSelectedAtlas =>
      AssetsResources(CreateAnimationFromSelectedAtlas)
    CreateAnimationGraphFromSelectedClip =>
      AssetsResources(CreateAnimationGraphFromSelectedClip)
    SaveSelectedAsPrefab => AssetsResources(SaveSelectedAsPrefab)
    InsertSelectedResource => AssetsResources(InsertSelectedResource)
    MoveSelectedResource(delta) =>
      SelectionHistoryTools(MoveSelectedResource(delta))
    OpenAddComponentPanel => InspectorComponents(OpenAddComponentPanel)
    CloseAddComponentPanel => InspectorComponents(CloseAddComponentPanel)
    SetComponentSearchQuery(value) =>
      InspectorComponents(SetComponentSearchQuery(value))
    ToggleComponentCollapsed(kind) =>
      InspectorComponents(ToggleComponentCollapsed(kind))
    ToggleComponentMenu(kind) => InspectorComponents(ToggleComponentMenu(kind))
    AddBuiltinComponent(kind) => InspectorComponents(AddBuiltinComponent(kind))
    RemoveComponent(kind) => InspectorComponents(RemoveComponent(kind))
    UpdateAddCustomComponentKind(value) =>
      InspectorComponents(UpdateAddCustomComponentKind(value))
    AddCustomComponent(kind) => InspectorComponents(AddCustomComponent(kind))
    UpdateCustomComponentJson(kind, value) =>
      InspectorComponents(UpdateCustomComponentJson(kind, value))
    CommitCustomComponentJson(kind) =>
      InspectorComponents(CommitCustomComponentJson(kind))
    UpdateSelectedPrefabName(value) =>
      InspectorComponents(UpdateSelectedPrefabName(value))
    SaveSelectedPrefab => InspectorComponents(SaveSelectedPrefab)
    UpdateSelectedAtlasName(value) =>
      InspectorComponents(UpdateSelectedAtlasName(value))
    UpdateSelectedAtlasTileWidth(value) =>
      InspectorComponents(UpdateSelectedAtlasTileWidth(value))
    UpdateSelectedAtlasTileHeight(value) =>
      InspectorComponents(UpdateSelectedAtlasTileHeight(value))
    UpdateSelectedAtlasColumns(value) =>
      InspectorComponents(UpdateSelectedAtlasColumns(value))
    UpdateSelectedAtlasRows(value) =>
      InspectorComponents(UpdateSelectedAtlasRows(value))
    UpdateSelectedAtlasSpacingX(value) =>
      InspectorComponents(UpdateSelectedAtlasSpacingX(value))
    UpdateSelectedAtlasSpacingY(value) =>
      InspectorComponents(UpdateSelectedAtlasSpacingY(value))
    UpdateSelectedAtlasMarginX(value) =>
      InspectorComponents(UpdateSelectedAtlasMarginX(value))
    UpdateSelectedAtlasMarginY(value) =>
      InspectorComponents(UpdateSelectedAtlasMarginY(value))
    UpdateSelectedAtlasAnchorX(value) =>
      InspectorComponents(UpdateSelectedAtlasAnchorX(value))
    UpdateSelectedAtlasAnchorY(value) =>
      InspectorComponents(UpdateSelectedAtlasAnchorY(value))
    SaveSelectedAtlas => InspectorComponents(SaveSelectedAtlas)
    UpdateSelectedAnimationClipAssetName(value) =>
      AnimationEditor(UpdateSelectedAnimationClipAssetName(value))
    UpdateSelectedAnimationGraphAssetName(value) =>
      AnimationEditor(UpdateSelectedAnimationGraphAssetName(value))
    UpdateSelectedAnimationGraphDefaultNode(value) =>
      AnimationEditor(UpdateSelectedAnimationGraphDefaultNode(value))
    UpdateSelectedAnimationClipName(value) =>
      AnimationEditor(UpdateSelectedAnimationClipName(value))
    UpdateSelectedAnimationClipFps(value) =>
      AnimationEditor(UpdateSelectedAnimationClipFps(value))
    ToggleSelectedAnimationClipLooping =>
      AnimationEditor(ToggleSelectedAnimationClipLooping)
    UpdateSelectedAnimationClipFrames(value) =>
      AnimationEditor(UpdateSelectedAnimationClipFrames(value))
    AddSelectedAnimationGraphClipNode =>
      AnimationEditor(AddSelectedAnimationGraphClipNode)
    AddSelectedAnimationGraphBlendNode =>
      AnimationEditor(AddSelectedAnimationGraphBlendNode)
    AddSelectedAnimationGraphAdditiveBlendNode =>
      AnimationEditor(AddSelectedAnimationGraphAdditiveBlendNode)
    RemoveSelectedAnimationGraphNode(id) =>
      AnimationEditor(RemoveSelectedAnimationGraphNode(id))
    UpdateSelectedAnimationGraphNodeClipPath(id, path) =>
      AnimationEditor(UpdateSelectedAnimationGraphNodeClipPath(id, path))
    AddSelectedAnimationGraphEdge(node_id) =>
      AnimationEditor(AddSelectedAnimationGraphEdge(node_id))
    RemoveSelectedAnimationGraphEdge(node_id, edge_index) =>
      AnimationEditor(RemoveSelectedAnimationGraphEdge(node_id, edge_index))
    UpdateSelectedAnimationGraphEdgeTarget(node_id, edge_index, target) =>
      AnimationEditor(
        UpdateSelectedAnimationGraphEdgeTarget(node_id, edge_index, target),
      )
    UpdateSelectedAnimationGraphEdgeWeight(node_id, edge_index, value) =>
      AnimationEditor(
        UpdateSelectedAnimationGraphEdgeWeight(node_id, edge_index, value),
      )
    BeginSelectedAnimationGraphEdgeConnect(node_id) =>
      AnimationEditor(BeginSelectedAnimationGraphEdgeConnect(node_id))
    CompleteSelectedAnimationGraphEdgeConnect(node_id) =>
      AnimationEditor(CompleteSelectedAnimationGraphEdgeConnect(node_id))
    CancelSelectedAnimationGraphEdgeConnect =>
      AnimationEditor(CancelSelectedAnimationGraphEdgeConnect)
    MoveSelectedAnimationGraphNode(node_id, normalized_x, normalized_y) =>
      AnimationEditor(
        MoveSelectedAnimationGraphNode(node_id, normalized_x, normalized_y),
      )
    ToggleAnimationPreviewPaused =>
      AnimationEditor(ToggleAnimationPreviewPaused)
    UpdateAnimationPreviewSpeed(value) =>
      AnimationEditor(UpdateAnimationPreviewSpeed(value))
    UpdateAnimationPreviewSeekInput(value) =>
      AnimationEditor(UpdateAnimationPreviewSeekInput(value))
    ApplyAnimationPreviewSeek => AnimationEditor(ApplyAnimationPreviewSeek)
    SaveSelectedAnimationClip => AnimationEditor(SaveSelectedAnimationClip)
    SaveSelectedAnimationGraph => AnimationEditor(SaveSelectedAnimationGraph)
    RenameSelected(value) => InspectorComponents(RenameSelected(value))
    UpdateSelectedTranslateX(value) =>
      InspectorComponents(UpdateSelectedTranslateX(value))
    UpdateSelectedTranslateY(value) =>
      InspectorComponents(UpdateSelectedTranslateY(value))
    UpdateSelectedRotation(value) =>
      InspectorComponents(UpdateSelectedRotation(value))
    UpdateSelectedText(value) => InspectorComponents(UpdateSelectedText(value))
    ToggleSelectedVisibility => InspectorComponents(ToggleSelectedVisibility)
    UpdateSelectedAutoTileAtlasPath(value) =>
      InspectorComponents(UpdateSelectedAutoTileAtlasPath(value))
    UpdateSelectedAutoTileTileWidth(value) =>
      InspectorComponents(UpdateSelectedAutoTileTileWidth(value))
    UpdateSelectedAutoTileTileHeight(value) =>
      InspectorComponents(UpdateSelectedAutoTileTileHeight(value))
    UpdateSelectedAutoTileOriginX(value) =>
      InspectorComponents(UpdateSelectedAutoTileOriginX(value))
    UpdateSelectedAutoTileOriginY(value) =>
      InspectorComponents(UpdateSelectedAutoTileOriginY(value))
    UpdateSelectedAutoTileRuleSet(value) =>
      InspectorComponents(UpdateSelectedAutoTileRuleSet(value))
    UpdateSelectedAutoTilePaletteJson(value) =>
      InspectorComponents(UpdateSelectedAutoTilePaletteJson(value))
    CommitSelectedAutoTilePaletteJson =>
      InspectorComponents(CommitSelectedAutoTilePaletteJson)
    UpdateAutoTileBrushTerrain(value) =>
      InspectorComponents(UpdateAutoTileBrushTerrain(value))
    UpdateSelectedAnimationPlayerGraphPath(value) =>
      AnimationEditor(UpdateSelectedAnimationPlayerGraphPath(value))
    UpdateSelectedAnimationPlayerStartNode(value) =>
      AnimationEditor(UpdateSelectedAnimationPlayerStartNode(value))
    ToggleSelectedAnimationPlayerAutoplay =>
      AnimationEditor(ToggleSelectedAnimationPlayerAutoplay)
    UpdateSelectedAnimationPlayerRepeatMode(value) =>
      AnimationEditor(UpdateSelectedAnimationPlayerRepeatMode(value))
    UpdateSelectedAnimationPlayerSpeed(value) =>
      AnimationEditor(UpdateSelectedAnimationPlayerSpeed(value))
    UpdateSelectedAnimationTransitionsDuration(value) =>
      AnimationEditor(UpdateSelectedAnimationTransitionsDuration(value))
    SaveScene => SceneLifecycle(SaveScene)
    ReloadScene => SceneLifecycle(ReloadScene)
    AddSpriteEntity => SceneLifecycle(AddSpriteEntity)
    AddSpriteFromAsset(path) => SceneLifecycle(AddSpriteFromAsset(path))
    AddSpriteFromAssetAt(path, translation) =>
      SceneLifecycle(AddSpriteFromAssetAt(path, translation))
    AddTextEntity => SceneLifecycle(AddTextEntity)
    DeleteSelected => SceneLifecycle(DeleteSelected)
    SetTool(tool) => SelectionHistoryTools(SetTool(tool))
    FrameSelection => SelectionHistoryTools(FrameSelection)
  }
}
