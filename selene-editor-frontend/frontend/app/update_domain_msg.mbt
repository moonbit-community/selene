///|
fn to_domain_msg(msg : Msg) -> DomainMsg {
  match msg {
    Initialize => ProjectRuntime(Initialize)
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
    SetSidebarLayout(scene_ratio, assets_ratio) =>
      SelectionHistoryTools(SetSidebarLayout(scene_ratio, assets_ratio))
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
    AddSpriteEntity => SceneLifecycle(AddSpriteEntity)
    AddSpriteFromAssetAt(path, translation) =>
      SceneLifecycle(AddSpriteFromAssetAt(path, translation))
    AddTextEntity => SceneLifecycle(AddTextEntity)
    DeleteSelected => SceneLifecycle(DeleteSelected)
    SetTool(tool) => SelectionHistoryTools(SetTool(tool))
    FrameSelection => SelectionHistoryTools(FrameSelection)
  }
}
