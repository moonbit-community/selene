///|
pub enum ResourceSelection {
  Image(String)
  Atlas(String)
  Animation(String)
  Prefab(String)
} derive(Show, Eq)

///|
pub fn resource_selection_image(path : String) -> ResourceSelection {
  Image(path)
}

///|
pub fn resource_selection_atlas(path : String) -> ResourceSelection {
  Atlas(path)
}

///|
pub fn resource_selection_animation(path : String) -> ResourceSelection {
  Animation(path)
}

///|
pub fn resource_selection_prefab(path : String) -> ResourceSelection {
  Prefab(path)
}

///|
pub struct SceneEditTransaction {
  label : String
  before : @editor_bridge.SceneDocument
} derive(Show, Eq)

///|
pub struct Model {
  project_root_input : String
  project_name_input : String
  current_root : String?
  manifest : @editor_bridge.ProjectManifest?
  scene_refs : Array[@editor_bridge.SceneRef]
  prefab_refs : Array[@editor_bridge.PrefabRef]
  atlas_refs : Array[@editor_bridge.AssetRef]
  animation_refs : Array[@editor_bridge.AssetRef]
  scene_path : String
  scene : @editor_bridge.SceneDocument?
  assets : Array[@editor_bridge.AssetDocument]
  asset_sizes : Map[String, @editor_bridge.Vec2Doc]
  asset_query : String
  failed_image_assets : Map[String, Bool]
  prefab_documents : Map[String, @editor_bridge.PrefabDocument]
  atlas_documents : Map[String, @editor_bridge.AtlasAssetDocument]
  animation_documents : Map[String, @editor_bridge.AnimationAssetDocument]
  workspace : @editor_bridge.WorkspaceDocument
  selected_resource : ResourceSelection?
  selected_entity_id : String?
  pending_scene_migration : @editor_bridge.SceneMigrationPreview?
  undo_stack : Array[@editor_bridge.SceneDocument]
  redo_stack : Array[@editor_bridge.SceneDocument]
  active_scene_edit_transaction : SceneEditTransaction?
  hover_hint : String?
  images_section_expanded : Bool
  atlases_section_expanded : Bool
  animations_section_expanded : Bool
  prefabs_section_expanded : Bool
  recent_projects : Array[String]
  logs : Array[String]
  status : String
  active_tool : @shared.PreviewTool
  move_snap_enabled : Bool
  move_snap_step : Double
} derive(Show, Eq)

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
  SceneListLoaded(Result[@shared.SceneListResponse, String])
  AssetsLoaded(Result[@shared.AssetsListResponse, String])
  PrefabLoaded(Result[@shared.PrefabLoadResponse, String])
  AtlasLoaded(Result[@shared.AtlasLoadResponse, String])
  AnimationLoaded(Result[@shared.AnimationLoadResponse, String])
  AssetSizeResolved(String, Double, Double)
  AssetImageLoadFailed(String)
  SetAssetQuery(String)
  SceneSaved(Result[Unit, String])
  WorkspaceSaved(Result[Unit, String])
  ServiceEvent(Result[@shared.EditorEvent, String])
  PreviewEvent(@bridge.PreviewEvent)
  SetHoverHint(String?)
  ToggleImagesSection
  ToggleAtlasesSection
  ToggleAnimationsSection
  TogglePrefabsSection
  ToggleMoveSnap
  AdjustMoveSnapStep(Int)
  CommitSceneEditTransaction
  UndoScene
  RedoScene
  OpenScene(String)
  SelectResource(ResourceSelection?)
  SelectEntity(String?)
  CreateScene(String)
  DeleteCurrentScene
  SetCurrentSceneAsStartup
  RenameCurrentScene(String)
  CreateAtlasFromSelectedImage
  CreateAnimationFromSelectedAtlas
  SaveSelectedAsPrefab
  InsertSelectedResource
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
  UpdateSelectedAnimationName(String)
  UpdateSelectedAnimationDefaultClip(String)
  UpdateSelectedAnimationClipName(String)
  UpdateSelectedAnimationClipFps(String)
  ToggleSelectedAnimationClipLooping
  UpdateSelectedAnimationClipFrames(String)
  SaveSelectedAnimation
  RenameSelected(String)
  UpdateSelectedTranslateX(String)
  UpdateSelectedTranslateY(String)
  UpdateSelectedRotation(String)
  UpdateSelectedText(String)
  ToggleSelectedVisibility
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
  AnimationLoaded
  SceneSaved
  WorkspaceSaved
} derive(Show, Eq)

///|
pub enum Effect {
  Rpc(target~ : RpcTarget, request~ : @shared.RpcRequestEnvelope)
  SubscribeServiceEvents
  SubscribePreviewEvents
  SubscribeKeyboardShortcuts
  Preview(@bridge.PreviewCommand)
} derive(Show, Eq)

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
    animation_refs: [],
    scene_path: @editor_bridge.startup_scene_path_for_name("main"),
    scene: None,
    assets: [],
    asset_sizes: {},
    asset_query: "",
    failed_image_assets: {},
    prefab_documents: {},
    atlas_documents: {},
    animation_documents: {},
    workspace: @editor_bridge.WorkspaceDocument::default(),
    selected_resource: None,
    selected_entity_id: None,
    pending_scene_migration: None,
    undo_stack: [],
    redo_stack: [],
    active_scene_edit_transaction: None,
    hover_hint: None,
    images_section_expanded: true,
    atlases_section_expanded: true,
    animations_section_expanded: true,
    prefabs_section_expanded: true,
    status: "Choose a project folder to begin",
    logs: [],
    active_tool: @shared.preview_tool_select(),
    move_snap_enabled: false,
    move_snap_step: 16.0,
  }
}

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
pub fn msg_animation_loaded(
  result : Result[@shared.AnimationLoadResponse, String],
) -> Msg {
  AnimationLoaded(result)
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
pub fn msg_save_selected_as_prefab() -> Msg {
  SaveSelectedAsPrefab
}

///|
pub fn msg_insert_selected_resource() -> Msg {
  InsertSelectedResource
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
pub fn msg_update_selected_animation_name(value : String) -> Msg {
  UpdateSelectedAnimationName(value)
}

///|
pub fn msg_update_selected_animation_default_clip(value : String) -> Msg {
  UpdateSelectedAnimationDefaultClip(value)
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
pub fn msg_save_selected_animation() -> Msg {
  SaveSelectedAnimation
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
pub fn msg_toggle_images_section() -> Msg {
  ToggleImagesSection
}

///|
pub fn msg_toggle_atlases_section() -> Msg {
  ToggleAtlasesSection
}

///|
pub fn msg_toggle_animations_section() -> Msg {
  ToggleAnimationsSection
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
fn push_log(model : Model, line : String) -> Model {
  let next_logs = model.logs + [line]
  let logs = if next_logs.length() > 200 {
    next_logs[next_logs.length() - 200:].to_array()
  } else {
    next_logs
  }
  { ..model, logs, }
}

///|
let scene_history_limit = 200

///|
let move_snap_step_options : ReadOnlyArray[Double] = [
  1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0,
]

///|
fn nearest_move_snap_step(step : Double) -> Double {
  let fallback = 16.0
  let candidate = if step > 0.0 { step } else { fallback }
  let mut best = move_snap_step_options[0]
  let mut best_distance = (candidate - best).abs()
  for option in move_snap_step_options {
    let distance = (candidate - option).abs()
    if distance < best_distance {
      best = option
      best_distance = distance
    }
  }
  best
}

///|
fn move_snap_step_index(step : Double) -> Int {
  let normalized = nearest_move_snap_step(step)
  for index = 0; index < move_snap_step_options.length(); index = index + 1 {
    if move_snap_step_options[index] == normalized {
      return index
    }
  }
  4
}

///|
fn adjusted_move_snap_step(current : Double, delta : Int) -> Double {
  let index = move_snap_step_index(current)
  let target = index + delta
  if target < 0 {
    move_snap_step_options[0]
  } else if target >= move_snap_step_options.length() {
    move_snap_step_options[move_snap_step_options.length() - 1]
  } else {
    move_snap_step_options[target]
  }
}

///|
fn bounded_history(
  history : Array[@editor_bridge.SceneDocument],
) -> Array[@editor_bridge.SceneDocument] {
  if history.length() > scene_history_limit {
    history[history.length() - scene_history_limit:].to_array()
  } else {
    history
  }
}

///|
fn with_recorded_scene_change(previous : Model, next : Model) -> Model {
  match (previous.scene, next.scene) {
    (Some(before), Some(after)) if before != after => {
      let undo_stack = bounded_history(previous.undo_stack + [before])
      {
        ..next,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    (Some(before), None) => {
      let undo_stack = bounded_history(previous.undo_stack + [before])
      {
        ..next,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    _ => next
  }
}

///|
fn with_started_scene_edit_transaction(model : Model, label : String) -> Model {
  match (model.scene, model.active_scene_edit_transaction) {
    (Some(before), None) => {
      let transaction : SceneEditTransaction = { label, before }
      { ..model, active_scene_edit_transaction: Some(transaction) }
    }
    _ => model
  }
}

///|
fn with_committed_scene_edit_transaction(model : Model) -> Model {
  match (model.active_scene_edit_transaction, model.scene) {
    (Some(transaction), Some(after)) if transaction.before != after => {
      let undo_stack = bounded_history(model.undo_stack + [transaction.before])
      {
        ..model,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    (Some(_), _) => { ..model, active_scene_edit_transaction: None }
    _ => model
  }
}

///|
fn is_scene_edit_continuation(msg : Msg) -> Bool {
  match msg {
    RenameSelected(_)
    | UpdateSelectedTranslateX(_)
    | UpdateSelectedTranslateY(_)
    | UpdateSelectedRotation(_)
    | UpdateSelectedText(_)
    | CommitSceneEditTransaction
    | PreviewEvent(@bridge.TransformGestureStarted(..))
    | PreviewEvent(@bridge.TransformChanged(..))
    | PreviewEvent(@bridge.TransformGestureFinished(..)) => true
    _ => false
  }
}

///|
fn project_open_failed_message() -> String {
  "Project open failed. Check browser console for details."
}

///|
fn scene_load_failed_message() -> String {
  "Scene load failed. Check browser console for details."
}

///|
fn folder_picker_failed_message() -> String {
  "Folder picker failed. Check browser console for details."
}

///|
fn rpc_effect(target : RpcTarget, request : @shared.RpcRequest) -> Effect {
  Rpc(target~, request=@shared.rpc_request_envelope(1, request))
}

///|
fn save_workspace_effects(model : Model) -> Array[Effect] {
  match model.current_root {
    Some(_) =>
      [
        rpc_effect(
          WorkspaceSaved,
          @shared.rpc_request_project_save_workspace(model.workspace),
        ),
      ]
    None => []
  }
}

///|
fn normalized_project_root(root : String) -> String {
  root.trim().to_string()
}

///|
fn next_entity_id(scene : @editor_bridge.SceneDocument) -> String {
  let mut index = scene.entities.length()
  for ;; {
    let candidate = "entity-\{index}"
    if scene.entity(candidate) is None {
      return candidate
    }
    index += 1
  }
  "entity"
}

///|
fn asset_basename(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  let base = if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
  if base.rev_find(".") is Some(index) {
    base[:index].to_string()
  } else {
    base
  }
}

///|
fn resource_stem(path : String) -> String {
  asset_basename(path)
}

///|
fn next_resource_entity_translation() -> @editor_bridge.Vec2Doc {
  @editor_bridge.vec2_doc(0.0, 0.0)
}

///|
fn atlas_document_from_image(
  image_path : String,
  image_size : @editor_bridge.Vec2Doc?,
) -> @editor_bridge.AtlasAssetDocument {
  @editor_bridge.atlas_asset_document_from_image(
    resource_stem(image_path),
    image_path,
    image_size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)),
  )
}

///|
fn animation_document_from_atlas(
  atlas_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> @editor_bridge.AnimationAssetDocument {
  let mut frames : Array[String] = []
  for region in atlas.regions {
    frames.push(region.name)
  }
  if frames.is_empty() {
    frames = ["frame_0"]
  }
  @editor_bridge.animation_asset_document_from_frames(
    atlas.name,
    atlas_path,
    frames,
  )
}

///|
fn add_atlas_asset_to_scene(
  scene : @editor_bridge.SceneDocument,
  atlas_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let first_region = if atlas.regions.is_empty() {
    None
  } else {
    Some(atlas.regions[0])
  }
  let entity = @editor_bridge.entity_document(id, atlas.name, components=[
    @editor_bridge.name_component(atlas.name),
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      custom_size=Some(
        first_region.map_or(atlas.tile_size, fn(region) {
          @editor_bridge.vec2_doc(region.rect.width, region.rect.height)
        }),
      ),
      anchor=atlas.default_anchor,
    ),
    @editor_bridge.texture_atlas_component(
      atlas_asset_path=Some(atlas_path),
      region_name=first_region.map(fn(region) { region.name }),
      index=first_region.map_or(0, fn(region) { region.index }),
    ),
  ])
  (scene.with_entity(entity), id)
}

///|
fn add_animation_asset_to_scene(
  scene : @editor_bridge.SceneDocument,
  animation_path : String,
  animation : @editor_bridge.AnimationAssetDocument,
  atlas : @editor_bridge.AtlasAssetDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let default_clip_name = animation.default_clip.unwrap_or("default")
  let mut default_frame_name = "frame_0"
  for clip in animation.clips {
    if clip.name == default_clip_name && !clip.frames.is_empty() {
      default_frame_name = clip.frames[0]
      break
    }
  }
  let mut first_region : @editor_bridge.AtlasRegionDocument? = None
  for region in atlas.regions {
    if region.name == default_frame_name {
      first_region = Some(region)
      break
    }
  }
  if first_region is None && !atlas.regions.is_empty() {
    first_region = Some(atlas.regions[0])
  }
  let entity = @editor_bridge.entity_document(id, animation.name, components=[
    @editor_bridge.name_component(animation.name),
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      custom_size=Some(
        first_region.map_or(atlas.tile_size, fn(region) {
          @editor_bridge.vec2_doc(region.rect.width, region.rect.height)
        }),
      ),
      anchor=atlas.default_anchor,
    ),
    @editor_bridge.texture_atlas_component(
      atlas_asset_path=Some(animation.atlas_asset_path),
      region_name=first_region.map(fn(region) { region.name }),
      index=first_region.map_or(0, fn(region) { region.index }),
    ),
    @editor_bridge.animation_player_component(
      animation_asset_path=Some(animation_path),
      default_clip=Some(default_clip_name),
      autoplay=true,
    ),
    @editor_bridge.animation_transitions_component(),
  ])
  (scene.with_entity(entity), id)
}

///|
fn subtree_entities(
  scene : @editor_bridge.SceneDocument,
  root_id : String,
) -> Array[@editor_bridge.EntityDocument] {
  let entities : Array[@editor_bridge.EntityDocument] = []
  fn visit(
    scene : @editor_bridge.SceneDocument,
    id : String,
    entities : Array[@editor_bridge.EntityDocument],
  ) -> Unit {
    match scene.entity(id) {
      Some(entity) => entities.push(entity)
      None => return
    }
    for child in scene.entities {
      if child.parent == Some(id) {
        visit(scene, child.id, entities)
      }
    }
  }
  visit(scene, root_id, entities)
  entities
}

///|
fn prefab_from_scene_selection(
  scene : @editor_bridge.SceneDocument,
  entity_id : String,
) -> @editor_bridge.PrefabDocument? {
  match scene.entity(entity_id) {
    Some(entity) =>
      Some(
        @editor_bridge.prefab_document(
          entity.name,
          subtree_entities(scene, entity_id),
        ),
      )
    None => None
  }
}

///|
fn instantiate_prefab_into_scene(
  scene : @editor_bridge.SceneDocument,
  prefab : @editor_bridge.PrefabDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String?) {
  let mut next_scene = scene
  let id_map : Map[String, String] = {}
  let mut root_id : String? = None
  for entity in prefab.entities {
    let new_id = next_entity_id(next_scene)
    id_map.set(entity.id, new_id)
    let is_root = entity.parent is None
    let next_parent = match entity.parent {
      Some(parent) => id_map.get(parent)
      None => None
    }
    let mut next_entity = @editor_bridge.entity_document(
      new_id,
      entity.name,
      parent=next_parent,
      components=entity.components,
    )
    if is_root {
      root_id = Some(new_id)
      let transform : @editor_bridge.Transform2dComponent = component_of(
        entity, "Transform2d",
      ).unwrap_or(@editor_bridge.transform2d_value())
      next_entity = next_entity.with_component(
        @editor_bridge.transform2d_component(
          translation=@editor_bridge.vec2_doc(
            transform.translation.x + translation.x,
            transform.translation.y + translation.y,
          ),
          rotation=transform.rotation,
          scale=transform.scale,
        ),
      )
    }
    next_scene = next_scene.with_entity(next_entity)
  }
  (next_scene, root_id)
}

///|
fn sync_preview_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = [
    Preview(@bridge.preview_command_set_tool(model.active_tool)),
    Preview(
      @bridge.preview_command_set_move_snap(
        model.move_snap_enabled,
        model.move_snap_step,
      ),
    ),
    Preview(@bridge.preview_command_select_entity(model.selected_entity_id)),
  ]
  effects
}

///|
fn scene_preview_effect(model : Model) -> Effect {
  match model.scene {
    Some(scene) => {
      let atlases : Array[@bridge.AtlasAssetEntry] = []
      let animations : Array[@bridge.AnimationAssetEntry] = []
      for path, atlas in model.atlas_documents {
        atlases.push(@bridge.atlas_asset_entry(path, atlas))
      }
      for path, animation in model.animation_documents {
        animations.push(@bridge.animation_asset_entry(path, animation))
      }
      Preview(
        @bridge.preview_command_load_scene(
          @bridge.preview_scene_payload(scene, atlases, animations),
        ),
      )
    }
    None => Preview(@bridge.preview_command_clear_scene())
  }
}

///|
fn sync_preview_effects_with_scene(model : Model) -> Array[Effect] {
  let effects = sync_preview_effects(model)
  effects.push(scene_preview_effect(model))
  effects
}

///|
fn load_supporting_resource_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = []
  for prefab_ref in model.prefab_refs {
    effects.push(
      rpc_effect(PrefabLoaded, @shared.rpc_request_prefab_load(prefab_ref.path)),
    )
  }
  for atlas_ref in model.atlas_refs {
    effects.push(
      rpc_effect(AtlasLoaded, @shared.rpc_request_atlas_load(atlas_ref.path)),
    )
  }
  for animation_ref in model.animation_refs {
    effects.push(
      rpc_effect(
        AnimationLoaded,
        @shared.rpc_request_animation_load(animation_ref.path),
      ),
    )
  }
  effects
}

///|
fn refresh_project_effects(model : Model) -> Array[Effect] {
  match model.manifest {
    Some(_) => {
      let effects : Array[Effect] = [
        Preview(@bridge.preview_command_bootstrap()),
        rpc_effect(
          SceneLoaded,
          @shared.rpc_request_scene_load(model.scene_path),
        ),
        rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
        rpc_effect(AssetsLoaded, @shared.rpc_request_assets_list()),
      ]
      effects.push_iter(load_supporting_resource_effects(model).iter())
      effects
    }
    None => []
  }
}

///|
fn normalize_scene_after_change(model : Model) -> (Array[Effect], Model) {
  (sync_preview_effects_with_scene(model), model)
}

///|
fn normalize_scene_after_change_without_preview(
  model : Model,
) -> (Array[Effect], Model) {
  ([], model)
}

///|
fn apply_scene_change(previous : Model, next : Model) -> (Array[Effect], Model) {
  normalize_scene_after_change(with_recorded_scene_change(previous, next))
}

///|
fn apply_scene_change_without_history(
  _previous : Model,
  next : Model,
) -> (Array[Effect], Model) {
  normalize_scene_after_change(next)
}

///|
fn apply_scene_change_without_history_or_preview(
  _previous : Model,
  next : Model,
) -> (Array[Effect], Model) {
  normalize_scene_after_change_without_preview(next)
}

///|
fn parse_double_or(current : Double, input : String) -> Double {
  @strconv.parse_double(input) catch {
    _ => current
  }
}

///|
fn parse_int_or(current : Int, input : String) -> Int {
  @strconv.parse_int(input) catch {
    _ => current
  }
}

///|
fn parse_positive_double_or(current : Double, input : String) -> Double {
  let parsed = parse_double_or(current, input)
  if parsed <= 0.0 {
    current
  } else {
    parsed
  }
}

///|
fn parse_positive_int_or(current : Int, input : String) -> Int {
  let parsed = parse_int_or(current, input)
  if parsed <= 0 {
    current
  } else {
    parsed
  }
}

///|
fn atlas_region_name(
  existing : Array[@editor_bridge.AtlasRegionDocument],
  index : Int,
) -> String {
  for region in existing {
    if region.index == index {
      return region.name
    }
  }
  "frame_\{index}"
}

///|
fn rebuild_atlas_regions(
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Array[@editor_bridge.AtlasRegionDocument] {
  let regions : Array[@editor_bridge.AtlasRegionDocument] = []
  let step_x = atlas.tile_size.x + atlas.spacing.x
  let step_y = atlas.tile_size.y + atlas.spacing.y
  for row = 0; row < atlas.rows; row = row + 1 {
    for column = 0; column < atlas.columns; column = column + 1 {
      let index = row * atlas.columns + column
      regions.push(
        @editor_bridge.atlas_region_document(
          atlas_region_name(atlas.regions, index),
          index,
          @editor_bridge.rect_doc(
            atlas.margin.x + step_x * column.to_double(),
            atlas.margin.y + step_y * row.to_double(),
            atlas.tile_size.x,
            atlas.tile_size.y,
          ),
        ),
      )
    }
  }
  regions
}

///|
fn with_rebuilt_regions(
  atlas : @editor_bridge.AtlasAssetDocument,
) -> @editor_bridge.AtlasAssetDocument {
  atlas.with_regions(rebuild_atlas_regions(atlas))
}

///|
fn primary_animation_clip(
  animation : @editor_bridge.AnimationAssetDocument,
) -> @editor_bridge.AnimationClipDocument {
  if animation.clips.is_empty() {
    @editor_bridge.animation_clip_document(
      animation.default_clip.unwrap_or("default"),
      8.0,
      true,
      ["frame_0"],
    )
  } else {
    animation.clips[0]
  }
}

///|
fn parse_clip_frames(current : Array[String], input : String) -> Array[String] {
  let frames : Array[String] = []
  for raw in input.split(",") {
    let frame = raw.trim().to_string()
    if frame != "" {
      frames.push(frame)
    }
  }
  if frames.is_empty() {
    current
  } else {
    frames
  }
}

///|
fn save_success_status(model : Model) -> String {
  match model.status {
    "Saving prefab..." => "Prefab saved"
    "Saving atlas..." => "Atlas saved"
    "Saving animation..." => "Animation saved"
    _ => "Scene saved"
  }
}

///|
fn move_snap_status(enabled : Bool, step : Double) -> String {
  if enabled {
    "Move snap: ON (\{step.to_int()}px)"
  } else {
    "Move snap: OFF (\{step.to_int()}px, hold Shift to snap)"
  }
}

///|
pub fn tool_label(tool : @shared.PreviewTool) -> String {
  match tool {
    @shared.Select => "Select"
    @shared.DragCanvas => "Drag Canvas"
    @shared.Translate => "Move"
    @shared.Rotate => "Rotate"
    @shared.Scale => "Scale"
  }
}

///|
pub fn entity_label(entity : @editor_bridge.EntityDocument) -> String {
  entity.name + " (" + entity.id + ")"
}

///|
fn selected_after_load(
  previous : String?,
  scene : @editor_bridge.SceneDocument,
) -> String? {
  match previous {
    Some(id) if scene.entity(id) is Some(_) => Some(id)
    _ =>
      if scene.entities.is_empty() {
        None
      } else {
        Some(scene.entities[0].id)
      }
  }
}

///|
fn scene_path_exists(
  scene_refs : Array[@editor_bridge.SceneRef],
  path : String,
) -> Bool {
  for scene_ref in scene_refs {
    if scene_ref.path == path {
      return true
    }
  }
  false
}

///|
fn asset_ref_exists(
  refs : Array[@editor_bridge.AssetRef],
  path : String,
) -> Bool {
  for asset_ref in refs {
    if asset_ref.path == path {
      return true
    }
  }
  false
}

///|
fn prefab_ref_exists(
  refs : Array[@editor_bridge.PrefabRef],
  path : String,
) -> Bool {
  for prefab_ref in refs {
    if prefab_ref.path == path {
      return true
    }
  }
  false
}

///|
fn resource_exists(model : Model, selection : ResourceSelection) -> Bool {
  match selection {
    Image(path) => {
      for asset in model.assets {
        if asset.kind is @editor_bridge.Image && asset.path == path {
          return true
        }
      }
      false
    }
    Atlas(path) => {
      for asset_ref in model.atlas_refs {
        if asset_ref.path == path {
          return true
        }
      }
      false
    }
    Animation(path) => {
      for asset_ref in model.animation_refs {
        if asset_ref.path == path {
          return true
        }
      }
      false
    }
    Prefab(path) => {
      for prefab_ref in model.prefab_refs {
        if prefab_ref.path == path {
          return true
        }
      }
      false
    }
  }
}

///|
fn fallback_scene_path(model : Model) -> String {
  match model.manifest {
    Some(manifest) => manifest.startup_scene
    None => @editor_bridge.startup_scene_path_for_name("main")
  }
}

///|
fn preferred_scene_path(
  manifest : @editor_bridge.ProjectManifest?,
  scene_refs : Array[@editor_bridge.SceneRef],
  workspace : @editor_bridge.WorkspaceDocument,
  current : String,
) -> String {
  if workspace.last_scene is Some(path) && scene_path_exists(scene_refs, path) {
    return path
  }
  if scene_path_exists(scene_refs, current) {
    return current
  }
  match manifest {
    Some(value) if scene_path_exists(scene_refs, value.startup_scene) =>
      value.startup_scene
    Some(value) => value.startup_scene
    None => if scene_refs.is_empty() { current } else { scene_refs[0].path }
  }
}

///|
fn add_sprite_asset_to_scene(
  asset_size : @editor_bridge.Vec2Doc?,
  scene : @editor_bridge.SceneDocument,
  asset_path : String,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let entity = @editor_bridge.entity_document(id, asset_basename(asset_path), components=[
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      image_path=Some(asset_path),
      custom_size=asset_size,
    ),
  ])
  (scene.with_entity(entity), id)
}

///|
pub fn Model::selected_entity(self : Model) -> @editor_bridge.EntityDocument? {
  match (self.scene, self.selected_entity_id) {
    (Some(scene), Some(id)) => scene.entity(id)
    _ => None
  }
}

///|
pub fn Model::image_assets(self : Model) -> Array[@editor_bridge.AssetDocument] {
  let images : Array[@editor_bridge.AssetDocument] = []
  for asset in self.assets {
    if asset.kind is @editor_bridge.Image {
      images.push(asset)
    }
  }
  images
}

///|
pub fn Model::selected_image_asset(
  self : Model,
) -> @editor_bridge.AssetDocument? {
  match self.selected_resource {
    Some(Image(path)) => {
      for asset in self.assets {
        if asset.kind is @editor_bridge.Image && asset.path == path {
          return Some(asset)
        }
      }
      None
    }
    _ => None
  }
}

///|
pub fn Model::selected_atlas_document(
  self : Model,
) -> (String, @editor_bridge.AtlasAssetDocument)? {
  match self.selected_resource {
    Some(Atlas(path)) =>
      match self.atlas_documents.get(path) {
        Some(atlas) => Some((path, atlas))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::selected_animation_document(
  self : Model,
) -> (String, @editor_bridge.AnimationAssetDocument)? {
  match self.selected_resource {
    Some(Animation(path)) =>
      match self.animation_documents.get(path) {
        Some(animation) => Some((path, animation))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::selected_prefab_document(
  self : Model,
) -> (String, @editor_bridge.PrefabDocument)? {
  match self.selected_resource {
    Some(Prefab(path)) =>
      match self.prefab_documents.get(path) {
        Some(prefab) => Some((path, prefab))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::asset_size(
  self : Model,
  path : String,
) -> @editor_bridge.Vec2Doc? {
  self.asset_sizes.get(path)
}

///|
pub fn Model::asset_query_normalized(self : Model) -> String {
  self.asset_query.trim().to_string().to_lower()
}

///|
pub fn Model::asset_matches_query(
  self : Model,
  name : String,
  path : String,
) -> Bool {
  let query = self.asset_query_normalized()
  if query == "" {
    true
  } else {
    name.to_lower().contains(query) || path.to_lower().contains(query)
  }
}

///|
pub fn Model::selected_resource_path(self : Model) -> String? {
  match self.selected_resource {
    Some(Image(path)) => Some(path)
    Some(Atlas(path)) => Some(path)
    Some(Animation(path)) => Some(path)
    Some(Prefab(path)) => Some(path)
    None => None
  }
}

///|
pub fn Model::can_undo(self : Model) -> Bool {
  self.undo_stack.length() > 0
}

///|
pub fn Model::can_redo(self : Model) -> Bool {
  self.redo_stack.length() > 0
}

///|
pub fn[T : FromJson] component_of(
  entity : @editor_bridge.EntityDocument,
  kind : String,
) -> T? {
  match entity.component(kind) {
    Some(component) => Some(@json.from_json(component.data)) catch { _ => None }
    None => None
  }
}

///|
fn update_selected_entity(
  model : Model,
  updater : (@editor_bridge.EntityDocument) -> @editor_bridge.EntityDocument,
) -> Model {
  match (model.scene, model.selected_entity_id) {
    (Some(scene), Some(id)) =>
      match scene.entity(id) {
        Some(entity) =>
          { ..model, scene: Some(scene.with_entity(updater(entity))) }
        None => model
      }
    _ => model
  }
}

///|
fn update_selected_component(
  model : Model,
  component : @editor_bridge.ComponentDocument,
) -> Model {
  update_selected_entity(model, fn(entity) { entity.with_component(component) })
}

///|
fn update_entity_component(
  model : Model,
  entity_id : String,
  component : @editor_bridge.ComponentDocument,
) -> Model {
  match model.scene {
    Some(scene) =>
      match scene.entity(entity_id) {
        Some(entity) => {
          let next_scene = scene.with_entity(entity.with_component(component))
          { ..model, scene: Some(next_scene) }
        }
        None => model
      }
    None => model
  }
}

///|
fn update_selected_atlas_document(
  model : Model,
  updater : (@editor_bridge.AtlasAssetDocument) -> @editor_bridge.AtlasAssetDocument,
) -> Model {
  match model.selected_atlas_document() {
    Some((path, atlas)) => {
      let atlas_documents = model.atlas_documents
      atlas_documents.set(path, updater(atlas))
      { ..model, atlas_documents, }
    }
    None => model
  }
}

///|
fn update_selected_animation_document(
  model : Model,
  updater : (@editor_bridge.AnimationAssetDocument) -> @editor_bridge.AnimationAssetDocument,
) -> Model {
  match model.selected_animation_document() {
    Some((path, animation)) => {
      let animation_documents = model.animation_documents
      animation_documents.set(path, updater(animation))
      { ..model, animation_documents, }
    }
    None => model
  }
}

///|
fn update_selected_prefab_document(
  model : Model,
  updater : (@editor_bridge.PrefabDocument) -> @editor_bridge.PrefabDocument,
) -> Model {
  match model.selected_prefab_document() {
    Some((path, prefab)) => {
      let prefab_documents = model.prefab_documents
      prefab_documents.set(path, updater(prefab))
      { ..model, prefab_documents, }
    }
    None => model
  }
}

///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  let model = if is_scene_edit_continuation(msg) {
    model
  } else {
    with_committed_scene_edit_transaction(model)
  }
  match msg {
    Initialize =>
      (
        [
          SubscribeServiceEvents,
          SubscribePreviewEvents,
          SubscribeKeyboardShortcuts,
          rpc_effect(ProjectLoaded, @shared.rpc_request_project_current()),
        ],
        model,
      )
    SetProjectRootInput(value) => ([], { ..model, project_root_input: value })
    SetProjectNameInput(value) => ([], { ..model, project_name_input: value })
    PickProjectRoot =>
      (
        [
          rpc_effect(
            ProjectRootPicked,
            @shared.rpc_request_project_pick_directory(
              "Choose a project folder",
            ),
          ),
        ],
        { ..model, status: "Choosing project folder..." },
      )
    OpenProject =>
      (
        [
          rpc_effect(
            ProjectRootPicked,
            @shared.rpc_request_project_pick_directory("Open a Selene project"),
          ),
        ],
        { ..model, status: "Choose a project folder..." },
      )
    ProjectRootPicked(result) =>
      match result {
        Ok(response) =>
          match response.path {
            Some(path) => {
              let root = normalized_project_root(path)
              (
                [
                  rpc_effect(
                    ProjectLoaded,
                    @shared.rpc_request_project_open(root),
                  ),
                ],
                {
                  ..model,
                  project_root_input: root,
                  status: "Opening project...",
                },
              )
            }
            None => ([], { ..model, status: "Open a project to begin" })
          }
        Err(message) => {
          ignore(message)
          let next = push_log(model, folder_picker_failed_message())
          ([], { ..next, status: folder_picker_failed_message() })
        }
      }
    ProjectLoaded(result) =>
      match result {
        Ok(response) => {
          let scene_refs = response.scenes
          let prefab_refs = response.prefabs
          let atlas_refs = response.atlases
          let animation_refs = response.animations
          let loaded_workspace = response.workspace.unwrap_or(
            @editor_bridge.WorkspaceDocument::default(),
          )
          let move_snap_enabled = loaded_workspace.move_snap_enabled_or_default()
          let move_snap_step = nearest_move_snap_step(
            loaded_workspace.move_snap_step_or_default(),
          )
          let workspace = loaded_workspace
            .with_move_snap_enabled(move_snap_enabled)
            .with_move_snap_step(move_snap_step)
          let scene_path = preferred_scene_path(
            response.manifest,
            scene_refs,
            workspace,
            model.scene_path,
          )
          let status = match response.root {
            Some(root) => "Project: " + root
            None => "Choose a project folder to begin"
          }
          let project_root_input = response.root.unwrap_or(
            model.project_root_input,
          )
          let next = {
            ..model,
            current_root: response.root,
            manifest: response.manifest,
            scene_refs,
            prefab_refs,
            atlas_refs,
            animation_refs,
            workspace,
            recent_projects: response.recent_projects,
            scene_path,
            project_root_input,
            pending_scene_migration: None,
            undo_stack: [],
            redo_stack: [],
            active_scene_edit_transaction: None,
            status,
            move_snap_enabled,
            move_snap_step,
          }
          (refresh_project_effects(next), next)
        }
        Err(message) => {
          ignore(message)
          let next = push_log(model, project_open_failed_message())
          ([], { ..next, status: project_open_failed_message() })
        }
      }
    SceneLoaded(result) =>
      match result {
        Ok(@shared.Loaded(response)) => {
          let atlas_documents = model.atlas_documents
          let atlas_refs = model.atlas_refs
          for entry in response.atlas_assets {
            atlas_documents.set(entry.path, entry.atlas)
            if !asset_ref_exists(atlas_refs, entry.path) {
              atlas_refs.push(@editor_bridge.asset_ref(entry.path))
            }
          }
          let animation_documents = model.animation_documents
          let animation_refs = model.animation_refs
          for entry in response.animation_assets {
            animation_documents.set(entry.path, entry.animation)
            if !asset_ref_exists(animation_refs, entry.path) {
              animation_refs.push(@editor_bridge.asset_ref(entry.path))
            }
          }
          let workspace = model.workspace
            .with_last_scene(Some(response.path))
            .with_selected_entity_id(
              selected_after_load(model.selected_entity_id, response.scene),
            )
          let next = {
            ..model,
            scene_path: response.path,
            scene: Some(response.scene),
            workspace,
            atlas_documents,
            atlas_refs,
            animation_documents,
            animation_refs,
            selected_entity_id: workspace.selected_entity_id,
            pending_scene_migration: None,
            undo_stack: [],
            redo_stack: [],
            active_scene_edit_transaction: None,
            status: "Loaded " + response.path,
          }
          (sync_preview_effects_with_scene(next), next)
        }
        Ok(@shared.MigrationRequired(preview)) => {
          let next = {
            ..model,
            scene_path: preview.path,
            scene: None,
            selected_entity_id: None,
            pending_scene_migration: Some(preview),
            undo_stack: [],
            redo_stack: [],
            active_scene_edit_transaction: None,
            status: "Legacy scene requires migration",
          }
          let cleared = next.workspace
            .with_last_scene(Some(preview.path))
            .with_selected_entity_id(None)
          (
            [Preview(@bridge.preview_command_clear_scene())],
            { ..next, workspace: cleared },
          )
        }
        Err(message) => {
          ignore(message)
          let next = push_log(model, scene_load_failed_message())
          ([], { ..next, status: scene_load_failed_message() })
        }
      }
    ConfirmSceneMigration =>
      match model.pending_scene_migration {
        Some(preview) =>
          (
            [
              rpc_effect(
                SceneLoaded,
                @shared.rpc_request_scene_migrate(preview.path),
              ),
            ],
            { ..model, status: "Migrating " + preview.path + "..." },
          )
        None => ([], model)
      }
    CancelSceneMigration => {
      let workspace = model.workspace.with_selected_entity_id(None)
      (
        [Preview(@bridge.preview_command_clear_scene())],
        {
          ..model,
          scene: None,
          selected_entity_id: None,
          pending_scene_migration: None,
          undo_stack: [],
          redo_stack: [],
          active_scene_edit_transaction: None,
          workspace,
          status: "Scene migration cancelled",
        },
      )
    }
    SceneListLoaded(result) =>
      match result {
        Ok(response) => {
          let manifest = model.manifest.map(fn(value) {
            value.with_startup_scene(response.startup_scene)
          })
          let next_scene_path = if scene_path_exists(
              response.scenes,
              model.scene_path,
            ) {
            model.scene_path
          } else {
            preferred_scene_path(
              manifest,
              response.scenes,
              model.workspace,
              model.scene_path,
            )
          }
          let next = {
            ..model,
            manifest,
            scene_refs: response.scenes,
            scene_path: next_scene_path,
          }
          ([], next)
        }
        Err(message) => {
          let next = push_log(model, "Scene list failed: " + message)
          ([], { ..next, status: "Scene list failed: " + message })
        }
      }
    AssetsLoaded(result) =>
      match result {
        Ok(response) =>
          (
            [],
            {
              ..model,
              assets: response.assets,
              selected_resource: match model.selected_resource {
                Some(selection) if resource_exists(
                    { ..model, assets: response.assets },
                    selection,
                  ) => Some(selection)
                _ => None
              },
            },
          )
        Err(message) => {
          let next = push_log(model, "Assets load failed: " + message)
          ([], { ..next, status: "Assets load failed: " + message })
        }
      }
    PrefabLoaded(result) =>
      match result {
        Ok(response) => {
          let prefab_documents = model.prefab_documents
          prefab_documents.set(response.path, response.prefab)
          ([], { ..model, prefab_documents, })
        }
        Err(message) => {
          let next = push_log(model, "Prefab load failed: " + message)
          ([], { ..next, status: "Prefab load failed: " + message })
        }
      }
    AtlasLoaded(result) =>
      match result {
        Ok(response) => {
          let atlas_documents = model.atlas_documents
          atlas_documents.set(response.path, response.atlas)
          let next = { ..model, atlas_documents, }
          (sync_preview_effects_with_scene(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Atlas load failed: " + message)
          ([], { ..next, status: "Atlas load failed: " + message })
        }
      }
    AnimationLoaded(result) =>
      match result {
        Ok(response) => {
          let animation_documents = model.animation_documents
          animation_documents.set(response.path, response.animation)
          let next = { ..model, animation_documents, }
          (sync_preview_effects_with_scene(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Animation load failed: " + message)
          ([], { ..next, status: "Animation load failed: " + message })
        }
      }
    AssetSizeResolved(path, width, height) =>
      if width > 0.0 && height > 0.0 {
        let asset_sizes = model.asset_sizes
        asset_sizes.set(path, @editor_bridge.vec2_doc(width, height))
        let failed_image_assets = model.failed_image_assets
        failed_image_assets.remove(path) |> ignore
        ([], { ..model, asset_sizes, failed_image_assets })
      } else {
        ([], model)
      }
    AssetImageLoadFailed(path) => {
      let failed_image_assets = model.failed_image_assets
      failed_image_assets.set(path, true)
      ([], { ..model, failed_image_assets, })
    }
    SetAssetQuery(value) => ([], { ..model, asset_query: value })
    SceneSaved(result) =>
      match result {
        Ok(_) => ([], { ..model, status: save_success_status(model) })
        Err(message) => {
          let next = push_log(model, "Save failed: " + message)
          ([], { ..next, status: "Save failed: " + message })
        }
      }
    WorkspaceSaved(result) =>
      match result {
        Ok(_) => ([], model)
        Err(message) => {
          let next = push_log(model, "Workspace save failed: " + message)
          (
            [],
            {
              ..next,
              status: "Workspace save failed. Check browser console for details.",
            },
          )
        }
      }
    ServiceEvent(result) =>
      match result {
        Ok(event) =>
          match event {
            @shared.Ready => ([], model)
            @shared.Log(label~, message~) =>
              ([], push_log(model, "[\{label}] \{message}"))
            @shared.FilesChanged(_)
            | @shared.SceneSaved(_)
            | @shared.AssetImported(_) =>
              (
                [
                  rpc_effect(
                    ProjectLoaded,
                    @shared.rpc_request_project_current(),
                  ),
                ],
                model,
              )
            @shared.ProjectOpened(..)
            | @shared.SceneCreated(..)
            | @shared.SceneDeleted(..) => ([], model)
          }
        Err(message) => {
          let next = push_log(model, "SSE error: " + message)
          ([], { ..next, status: "SSE error" })
        }
      }
    PreviewEvent(event) =>
      match event {
        @bridge.EntityPicked(id) => {
          let next = {
            ..model,
            selected_entity_id: id,
            selected_resource: if id is Some(_) {
              None
            } else {
              model.selected_resource
            },
          }
          ([], next)
        }
        @bridge.HoverChanged(_) => ([], model)
        @bridge.TransformGestureStarted(id~) => {
          let next = with_started_scene_edit_transaction(
            { ..model, selected_entity_id: Some(id), selected_resource: None },
            "Transform",
          )
          ([], next)
        }
        @bridge.TransformChanged(id~, translation~, rotation~, scale~) =>
          match model.scene {
            Some(_) => {
              let next = update_entity_component(
                model,
                id,
                @editor_bridge.transform2d_component(
                  translation~,
                  rotation~,
                  scale~,
                ),
              )
              apply_scene_change_without_history_or_preview(model, {
                ..next,
                selected_entity_id: Some(id),
                selected_resource: None,
              })
            }
            _ => ([], model)
          }
        @bridge.TransformGestureFinished(id~) => {
          let committed = with_committed_scene_edit_transaction(model)
          let status = match model.active_scene_edit_transaction {
            Some(transaction) => transaction.label + " applied"
            None => "Transform applied"
          }
          let next = { ..committed, selected_entity_id: Some(id), status }
          (sync_preview_effects(next), next)
        }
      }
    SetHoverHint(hint) => ([], { ..model, hover_hint: hint })
    ToggleImagesSection =>
      ([], { ..model, images_section_expanded: !model.images_section_expanded })
    ToggleAtlasesSection =>
      (
        [],
        { ..model, atlases_section_expanded: !model.atlases_section_expanded },
      )
    ToggleAnimationsSection =>
      (
        [],
        {
          ..model,
          animations_section_expanded: !model.animations_section_expanded,
        },
      )
    TogglePrefabsSection =>
      (
        [],
        { ..model, prefabs_section_expanded: !model.prefabs_section_expanded },
      )
    ToggleMoveSnap => {
      let enabled = !model.move_snap_enabled
      let workspace = model.workspace.with_move_snap_enabled(enabled)
      let next = {
        ..model,
        move_snap_enabled: enabled,
        workspace,
        status: move_snap_status(enabled, model.move_snap_step),
      }
      (sync_preview_effects(next) + save_workspace_effects(next), next)
    }
    AdjustMoveSnapStep(delta) => {
      let next_step = adjusted_move_snap_step(model.move_snap_step, delta)
      if next_step == model.move_snap_step {
        ([], model)
      } else {
        let workspace = model.workspace.with_move_snap_step(next_step)
        let next = {
          ..model,
          move_snap_step: next_step,
          workspace,
          status: move_snap_status(model.move_snap_enabled, next_step),
        }
        (sync_preview_effects(next) + save_workspace_effects(next), next)
      }
    }
    CommitSceneEditTransaction => {
      let committed = with_committed_scene_edit_transaction(model)
      ([], committed)
    }
    UndoScene =>
      match (model.scene, model.undo_stack.length()) {
        (Some(current), count) if count > 0 => {
          let previous_scene = model.undo_stack[count - 1]
          let undo_stack = model.undo_stack[:count - 1].to_array()
          let redo_stack = bounded_history(model.redo_stack + [current])
          let selected_entity_id = selected_after_load(
            model.selected_entity_id,
            previous_scene,
          )
          let workspace = model.workspace.with_selected_entity_id(
            selected_entity_id,
          )
          let next = {
            ..model,
            scene: Some(previous_scene),
            selected_entity_id,
            workspace,
            undo_stack,
            redo_stack,
            active_scene_edit_transaction: None,
            status: "Undid last change",
          }
          normalize_scene_after_change(next)
        }
        _ => {
          let next = push_log(model, "Nothing to undo")
          ([], { ..next, status: "Nothing to undo" })
        }
      }
    RedoScene =>
      match (model.scene, model.redo_stack.length()) {
        (Some(current), count) if count > 0 => {
          let next_scene = model.redo_stack[count - 1]
          let redo_stack = model.redo_stack[:count - 1].to_array()
          let undo_stack = bounded_history(model.undo_stack + [current])
          let selected_entity_id = selected_after_load(
            model.selected_entity_id,
            next_scene,
          )
          let workspace = model.workspace.with_selected_entity_id(
            selected_entity_id,
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id,
            workspace,
            undo_stack,
            redo_stack,
            active_scene_edit_transaction: None,
            status: "Redid last change",
          }
          normalize_scene_after_change(next)
        }
        _ => {
          let next = push_log(model, "Nothing to redo")
          ([], { ..next, status: "Nothing to redo" })
        }
      }
    OpenScene(path) =>
      (
        [rpc_effect(SceneLoaded, @shared.rpc_request_scene_load(path))],
        { ..model, scene_path: path, status: "Loading " + path + "..." },
      )
    SelectResource(resource) =>
      ([], { ..model, selected_resource: resource, selected_entity_id: None })
    SelectEntity(id) => {
      let next = {
        ..model,
        selected_entity_id: id,
        selected_resource: if id is Some(_) {
          None
        } else {
          model.selected_resource
        },
      }
      (sync_preview_effects(next), next)
    }
    CreateScene(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        let next = push_log(model, "Scene name is required")
        ([], { ..next, status: "Scene name is required" })
      } else {
        (
          [
            rpc_effect(SceneLoaded, @shared.rpc_request_scene_create(trimmed)),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
          ],
          { ..model, status: "Creating scene..." },
        )
      }
    }
    DeleteCurrentScene =>
      if model.scene_refs.length() <= 1 {
        let next = push_log(model, "Cannot delete the last scene")
        ([], { ..next, status: "Cannot delete the last scene" })
      } else {
        let fallback = fallback_scene_path(model)
        let next_scene_path = if model.scene_path == fallback &&
          model.scene_refs.length() > 1 {
          model.scene_refs[1].path
        } else {
          fallback
        }
        (
          [
            rpc_effect(
              SceneSaved,
              @shared.rpc_request_scene_delete(model.scene_path),
            ),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
            rpc_effect(
              SceneLoaded,
              @shared.rpc_request_scene_load(next_scene_path),
            ),
          ],
          { ..model, scene_path: next_scene_path, status: "Deleting scene..." },
        )
      }
    SetCurrentSceneAsStartup =>
      (
        [
          rpc_effect(
            SceneSaved,
            @shared.rpc_request_project_set_startup_scene(model.scene_path),
          ),
          rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
        ],
        { ..model, status: "Updating startup scene..." },
      )
    RenameCurrentScene(value) =>
      match model.scene {
        Some(scene) => {
          let trimmed = value.trim().to_string()
          if trimmed == "" {
            let next = push_log(model, "Scene name is required")
            ([], { ..next, status: "Scene name is required" })
          } else {
            let next_scene = scene.with_name(trimmed)
            let next = {
              ..model,
              scene: Some(next_scene),
              status: "Renaming scene...",
            }
            let with_history = with_recorded_scene_change(model, next)
            (
              [
                rpc_effect(
                  SceneSaved,
                  @shared.rpc_request_scene_save(model.scene_path, next_scene),
                ),
              ] +
              sync_preview_effects_with_scene(with_history),
              with_history,
            )
          }
        }
        None => ([], model)
      }
    CreateAtlasFromSelectedImage =>
      match model.selected_image_asset() {
        Some(asset) => {
          let atlas = atlas_document_from_image(
            asset.path,
            model.asset_size(asset.path),
          )
          let path = "assets/atlases/" +
            @editor_bridge.atlas_asset_file_name(atlas.name)
          let atlas_documents = model.atlas_documents
          atlas_documents.set(path, atlas)
          let atlas_refs = model.atlas_refs
          if !asset_ref_exists(atlas_refs, path) {
            atlas_refs.push(@editor_bridge.asset_ref(path))
          }
          let next = {
            ..model,
            atlas_documents,
            atlas_refs,
            selected_resource: Some(resource_selection_atlas(path)),
            status: "Created atlas " + atlas.name,
          }
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_atlas_save(path, atlas),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    CreateAnimationFromSelectedAtlas =>
      match model.selected_atlas_document() {
        Some((path, atlas)) => {
          let animation = animation_document_from_atlas(path, atlas)
          let animation_path = "assets/animations/" +
            @editor_bridge.animation_asset_file_name(animation.name)
          let animation_documents = model.animation_documents
          animation_documents.set(animation_path, animation)
          let animation_refs = model.animation_refs
          if !asset_ref_exists(animation_refs, animation_path) {
            animation_refs.push(@editor_bridge.asset_ref(animation_path))
          }
          let next = {
            ..model,
            animation_documents,
            animation_refs,
            selected_resource: Some(
              resource_selection_animation(animation_path),
            ),
            status: "Created animation " + animation.name,
          }
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_save(animation_path, animation),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    SaveSelectedAsPrefab =>
      match (model.scene, model.selected_entity_id) {
        (Some(scene), Some(entity_id)) =>
          match prefab_from_scene_selection(scene, entity_id) {
            Some(prefab) => {
              let path = "prefabs/" +
                @editor_bridge.prefab_file_name(prefab.name)
              let prefab_documents = model.prefab_documents
              prefab_documents.set(path, prefab)
              let prefab_refs = model.prefab_refs
              if !prefab_ref_exists(prefab_refs, path) {
                prefab_refs.push(@editor_bridge.prefab_ref(path))
              }
              let next = {
                ..model,
                prefab_documents,
                prefab_refs,
                selected_resource: Some(resource_selection_prefab(path)),
                status: "Saved prefab " + prefab.name,
              }
              (
                [
                  rpc_effect(
                    SceneSaved,
                    @shared.rpc_request_prefab_save(path, prefab),
                  ),
                ],
                next,
              )
            }
            None => ([], model)
          }
        _ => ([], model)
      }
    InsertSelectedResource =>
      match (model.scene, model.selected_resource) {
        (Some(scene), Some(Image(path))) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            next_resource_entity_translation(),
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id: Some(id),
          }
          apply_scene_change(model, next)
        }
        (Some(scene), Some(Atlas(path))) =>
          match model.atlas_documents.get(path) {
            Some(atlas) => {
              let (next_scene, id) = add_atlas_asset_to_scene(
                scene,
                path,
                atlas,
                next_resource_entity_translation(),
              )
              let next = {
                ..model,
                scene: Some(next_scene),
                selected_entity_id: Some(id),
              }
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        (Some(scene), Some(Animation(path))) =>
          match model.animation_documents.get(path) {
            Some(animation) =>
              match model.atlas_documents.get(animation.atlas_asset_path) {
                Some(atlas) => {
                  let (next_scene, id) = add_animation_asset_to_scene(
                    scene,
                    path,
                    animation,
                    atlas,
                    next_resource_entity_translation(),
                  )
                  let next = {
                    ..model,
                    scene: Some(next_scene),
                    selected_entity_id: Some(id),
                  }
                  apply_scene_change(model, next)
                }
                None => ([], model)
              }
            None => ([], model)
          }
        (Some(scene), Some(Prefab(path))) =>
          match model.prefab_documents.get(path) {
            Some(prefab) => {
              let (next_scene, id) = instantiate_prefab_into_scene(
                scene,
                prefab,
                next_resource_entity_translation(),
              )
              let next = {
                ..model,
                scene: Some(next_scene),
                selected_entity_id: id,
              }
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        _ => ([], model)
      }
    UpdateSelectedPrefabName(value) => {
      let next = update_selected_prefab_document(model, fn(prefab) {
        prefab.with_name(value)
      })
      ([], next)
    }
    SaveSelectedPrefab =>
      match model.selected_prefab_document() {
        Some((path, prefab)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_prefab_save(path, prefab),
              ),
            ],
            { ..model, status: "Saving prefab..." },
          )
        None => ([], model)
      }
    UpdateSelectedAtlasName(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasTileWidth(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_tile_size(
            atlas.tile_size.with_x(
              parse_positive_double_or(atlas.tile_size.x, value),
            ),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasTileHeight(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_tile_size(
            atlas.tile_size.with_y(
              parse_positive_double_or(atlas.tile_size.y, value),
            ),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasColumns(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_columns(parse_positive_int_or(atlas.columns, value)),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasRows(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_rows(parse_positive_int_or(atlas.rows, value)),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasSpacingX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_spacing(
            atlas.spacing.with_x(parse_double_or(atlas.spacing.x, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasSpacingY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_spacing(
            atlas.spacing.with_y(parse_double_or(atlas.spacing.y, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasMarginX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_margin(
            atlas.margin.with_x(parse_double_or(atlas.margin.x, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasMarginY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_margin(
            atlas.margin.with_y(parse_double_or(atlas.margin.y, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasAnchorX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_default_anchor(
          atlas.default_anchor.with_x(
            parse_double_or(atlas.default_anchor.x, value),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasAnchorY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_default_anchor(
          atlas.default_anchor.with_y(
            parse_double_or(atlas.default_anchor.y, value),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    SaveSelectedAtlas =>
      match model.selected_atlas_document() {
        Some((path, atlas)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_atlas_save(path, atlas),
              ),
            ],
            { ..model, status: "Saving atlas..." },
          )
        None => ([], model)
      }
    UpdateSelectedAnimationName(value) => {
      let next = update_selected_animation_document(model, fn(animation) {
        animation.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationDefaultClip(value) => {
      let next = update_selected_animation_document(model, fn(animation) {
        let next_default = value.trim().to_string()
        animation.with_default_clip(
          if next_default == "" {
            None
          } else {
            Some(next_default)
          },
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipName(value) => {
      let next = update_selected_animation_document(model, fn(animation) {
        let clip = primary_animation_clip(animation)
        let next_default = match animation.default_clip {
          Some(current) if current == clip.name => Some(value)
          _ => animation.default_clip
        }
        animation
        .with_default_clip(next_default)
        .with_clips([clip.with_name(value)])
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipFps(value) => {
      let next = update_selected_animation_document(model, fn(animation) {
        let clip = primary_animation_clip(animation)
        animation.with_clips([
          clip.with_fps(parse_positive_double_or(clip.fps, value)),
        ])
      })
      (sync_preview_effects_with_scene(next), next)
    }
    ToggleSelectedAnimationClipLooping => {
      let next = update_selected_animation_document(model, fn(animation) {
        let clip = primary_animation_clip(animation)
        animation.with_clips([clip.with_looping(!clip.looping)])
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipFrames(value) => {
      let next = update_selected_animation_document(model, fn(animation) {
        let clip = primary_animation_clip(animation)
        animation.with_clips([
          clip.with_frames(parse_clip_frames(clip.frames, value)),
        ])
      })
      (sync_preview_effects_with_scene(next), next)
    }
    SaveSelectedAnimation =>
      match model.selected_animation_document() {
        Some((path, animation)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_save(path, animation),
              ),
            ],
            { ..model, status: "Saving animation..." },
          )
        None => ([], model)
      }
    RenameSelected(value) => {
      let staged = with_started_scene_edit_transaction(model, "Rename Entity")
      let next = update_selected_entity(staged, fn(entity) {
        entity.renamed(value)
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedTranslateX(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.transform2d_component(
                  translation=transform.translation.with_x(
                    parse_double_or(transform.translation.x, value),
                  ),
                  rotation=transform.rotation,
                  scale=transform.scale,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedTranslateY(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.transform2d_component(
                  translation=transform.translation.with_y(
                    parse_double_or(transform.translation.y, value),
                  ),
                  rotation=transform.rotation,
                  scale=transform.scale,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedRotation(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.transform2d_component(
                  translation=transform.translation,
                  rotation=parse_double_or(transform.rotation, value),
                  scale=transform.scale,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedText(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let text_component : @editor_bridge.Text2dComponent? = component_of(
            entity, "Text2d",
          )
          match text_component {
            Some(text_component) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Text",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.text2d_component(
                  value,
                  font_path=text_component.font_path,
                  font_size=text_component.font_size,
                  color=text_component.color,
                  bounds=text_component.bounds,
                  anchor=text_component.anchor,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    ToggleSelectedVisibility =>
      match model.selected_entity() {
        Some(entity) => {
          let visibility_component : @editor_bridge.VisibilityComponent? = component_of(
            entity, "Visibility",
          )
          match visibility_component {
            Some(visibility_component) => {
              let next = update_selected_component(
                model,
                @editor_bridge.visibility_component(
                  visible=!visibility_component.visible,
                ),
              )
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    SaveScene =>
      match model.scene {
        Some(scene) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_scene_save(model.scene_path, scene),
              ),
            ],
            { ..model, status: "Saving scene..." },
          )
        None => ([], model)
      }
    ReloadScene =>
      (refresh_project_effects(model), { ..model, status: "Reloading..." })
    AddSpriteEntity =>
      match model.scene {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Sprite", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.sprite_component(
              custom_size=Some(@editor_bridge.vec2_doc(64.0, 64.0)),
            ),
          ])
          let next = {
            ..model,
            scene: Some(scene.with_entity(entity)),
            selected_entity_id: Some(id),
          }
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddSpriteFromAsset(path) =>
      match model.scene {
        Some(scene) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            next_resource_entity_translation(),
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id: Some(id),
          }
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddSpriteFromAssetAt(path, translation) =>
      match model.scene {
        Some(scene) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            translation,
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id: Some(id),
          }
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddTextEntity =>
      match model.scene {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Text", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.text2d_component("Text"),
          ])
          let next = {
            ..model,
            scene: Some(scene.with_entity(entity)),
            selected_entity_id: Some(id),
          }
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    DeleteSelected =>
      match (model.scene, model.selected_entity_id) {
        (Some(scene), Some(id)) => {
          let next = {
            ..model,
            scene: Some(scene.without_entity(id)),
            selected_entity_id: None,
          }
          apply_scene_change(model, next)
        }
        _ => ([], model)
      }
    SetTool(tool) => {
      let next = {
        ..model,
        active_tool: tool,
        status: "Tool: " + tool_label(tool),
      }
      (sync_preview_effects(next), next)
    }
    FrameSelection =>
      ([Preview(@bridge.preview_command_frame_selection())], model)
  }
}
