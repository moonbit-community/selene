///|
pub struct ProjectStateResponse {
  root : String?
  manifest : @editor_bridge.ProjectManifest?
  scenes : Array[@editor_bridge.SceneRef]?
  prefabs : Array[@editor_bridge.PrefabRef]?
  atlases : Array[@editor_bridge.AssetRef]?
  animations : Array[@editor_bridge.AssetRef]?
  workspace : @editor_bridge.WorkspaceDocument?
  recent_projects : Array[String]
} derive(FromJson, Show, Eq)

///|
pub struct SceneLoadResponse {
  path : String
  scene : @editor_bridge.SceneDocument
} derive(FromJson, Show, Eq)

///|
pub struct AssetsListResponse {
  assets : Array[@editor_bridge.AssetDocument]
} derive(FromJson, Show, Eq)

///|
pub struct PrefabLoadResponse {
  path : String
  prefab : @editor_bridge.PrefabDocument
} derive(FromJson, Show, Eq)

///|
pub struct AtlasLoadResponse {
  path : String
  atlas : @editor_bridge.AtlasAssetDocument
} derive(FromJson, Show, Eq)

///|
pub struct AnimationLoadResponse {
  path : String
  animation : @editor_bridge.AnimationAssetDocument
} derive(FromJson, Show, Eq)

///|
pub struct SceneListResponse {
  scenes : Array[@editor_bridge.SceneRef]
  startup_scene : String
} derive(FromJson, Show, Eq)

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
  prefab_documents : Map[String, @editor_bridge.PrefabDocument]
  atlas_documents : Map[String, @editor_bridge.AtlasAssetDocument]
  animation_documents : Map[String, @editor_bridge.AnimationAssetDocument]
  workspace : @editor_bridge.WorkspaceDocument
  selected_resource : ResourceSelection?
  selected_entity_id : String?
  recent_projects : Array[String]
  logs : Array[String]
  status : String
  active_tool : @shared.PreviewTool
} derive(Show, Eq)

///|
pub enum Msg {
  Initialize
  SetProjectRootInput(String)
  SetProjectNameInput(String)
  PickProjectRoot
  OpenProject
  CreateProject
  ProjectRootPicked(Result[@shared.DirectoryPickResult, String])
  ProjectLoaded(Result[ProjectStateResponse, String])
  SceneLoaded(Result[SceneLoadResponse, String])
  SceneListLoaded(Result[SceneListResponse, String])
  AssetsLoaded(Result[AssetsListResponse, String])
  PrefabLoaded(Result[PrefabLoadResponse, String])
  AtlasLoaded(Result[AtlasLoadResponse, String])
  AnimationLoaded(Result[AnimationLoadResponse, String])
  AssetSizeResolved(String, Double, Double)
  SceneSaved(Result[Json, String])
  ServiceEvent(Result[@shared.EventEnvelope, String])
  PreviewEvent(@bridge.PreviewEvent)
  OpenScene(String)
  SelectResource(ResourceSelection?)
  SelectEntity(String?)
  CreateScene(String)
  DeleteCurrentScene
  SetCurrentSceneAsStartup
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
} derive(Show, Eq)

///|
pub enum Effect {
  Rpc(target~ : RpcTarget, method_name~ : String, params~ : Json)
  SubscribeServiceEvents
  SubscribePreviewEvents
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
    prefab_documents: {},
    atlas_documents: {},
    animation_documents: {},
    workspace: @editor_bridge.WorkspaceDocument::default(),
    selected_resource: None,
    selected_entity_id: None,
    status: "Choose a project folder to begin",
    logs: [],
    active_tool: @shared.preview_tool_select(),
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
pub fn msg_create_project() -> Msg {
  CreateProject
}

///|
pub fn msg_project_root_picked(
  result : Result[@shared.DirectoryPickResult, String],
) -> Msg {
  ProjectRootPicked(result)
}

///|
pub fn msg_project_loaded(result : Result[ProjectStateResponse, String]) -> Msg {
  ProjectLoaded(result)
}

///|
pub fn msg_scene_loaded(result : Result[SceneLoadResponse, String]) -> Msg {
  SceneLoaded(result)
}

///|
pub fn msg_scene_list_loaded(result : Result[SceneListResponse, String]) -> Msg {
  SceneListLoaded(result)
}

///|
pub fn msg_assets_loaded(result : Result[AssetsListResponse, String]) -> Msg {
  AssetsLoaded(result)
}

///|
pub fn msg_prefab_loaded(result : Result[PrefabLoadResponse, String]) -> Msg {
  PrefabLoaded(result)
}

///|
pub fn msg_atlas_loaded(result : Result[AtlasLoadResponse, String]) -> Msg {
  AtlasLoaded(result)
}

///|
pub fn msg_animation_loaded(
  result : Result[AnimationLoadResponse, String],
) -> Msg {
  AnimationLoaded(result)
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
pub fn msg_scene_saved(result : Result[Json, String]) -> Msg {
  SceneSaved(result)
}

///|
pub fn msg_service_event(result : Result[@shared.EventEnvelope, String]) -> Msg {
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
fn rpc_effect(
  target : RpcTarget,
  method_name : String,
  params : Json,
) -> Effect {
  Rpc(target~, method_name~, params~)
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
fn sync_preview_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = [
    Preview(@bridge.preview_command_set_tool(model.active_tool)),
    Preview(@bridge.preview_command_select_entity(model.selected_entity_id)),
  ]
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
      effects.push(
        Preview(
          @bridge.preview_command_load_scene(
            @bridge.preview_scene_payload(scene, atlases, animations),
          ),
        ),
      )
    }
    None => effects.push(Preview(@bridge.preview_command_clear_scene()))
  }
  effects
}

///|
fn load_supporting_resource_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = []
  for prefab_ref in model.prefab_refs {
    effects.push(
      rpc_effect(
        PrefabLoaded,
        "prefab.load",
        { "path": prefab_ref.path.to_json() }.to_json(),
      ),
    )
  }
  for atlas_ref in model.atlas_refs {
    effects.push(
      rpc_effect(
        AtlasLoaded,
        "atlas.load",
        { "path": atlas_ref.path.to_json() }.to_json(),
      ),
    )
  }
  for animation_ref in model.animation_refs {
    effects.push(
      rpc_effect(
        AnimationLoaded,
        "animation.load",
        { "path": animation_ref.path.to_json() }.to_json(),
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
        rpc_effect(
          SceneLoaded,
          "scene.load",
          { "path": model.scene_path.to_json() }.to_json(),
        ),
        rpc_effect(SceneListLoaded, "scene.list", Json::null()),
        rpc_effect(AssetsLoaded, "assets.list", Json::null()),
      ]
      effects.push_iter(load_supporting_resource_effects(model).iter())
      effects
    }
    None => []
  }
}

///|
fn normalize_scene_after_change(model : Model) -> (Array[Effect], Model) {
  (sync_preview_effects(model), model)
}

///|
fn parse_double_or(current : Double, input : String) -> Double {
  @strconv.parse_double(input) catch {
    _ => current
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
fn text_or_fallback(json : Json, fallback : String) -> String {
  match json {
    Json::String(value) => value
    _ => fallback
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
    None =>
      if scene_refs.is_empty() {
        current
      } else {
        scene_refs[0].path
      }
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
  let entity = @editor_bridge.entity_document(
    id,
    asset_basename(asset_path),
    components=[
      @editor_bridge.transform2d_component(translation~),
      @editor_bridge.visibility_component(),
      @editor_bridge.sprite_component(
        image_path=Some(asset_path),
        custom_size=asset_size,
      ),
    ],
  )
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
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  match msg {
    Initialize =>
      (
        [
          SubscribeServiceEvents,
          SubscribePreviewEvents,
          Preview(@bridge.preview_command_bootstrap()),
          rpc_effect(
            ProjectRootPicked,
            "project.pick_directory",
            { "prompt": "Choose a project folder".to_json() }.to_json(),
          ),
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
            "project.pick_directory",
            { "prompt": "Choose a project folder".to_json() }.to_json(),
          ),
        ],
        { ..model, status: "Choosing project folder..." },
      )
    OpenProject =>
      {
        let root = normalized_project_root(model.project_root_input)
        if root == "" {
          let message = "Choose a project folder first"
          let next = push_log(model, message)
          ([], { ..next, status: message })
        } else {
          (
            [
              rpc_effect(
                ProjectLoaded,
                "project.open",
                { "root": root.to_json() }.to_json(),
              ),
            ],
            { ..model, project_root_input: root, status: "Opening project..." },
          )
        }
      }
    CreateProject =>
      {
        let root = normalized_project_root(model.project_root_input)
        if root == "" {
          let message = "Choose a project folder first"
          let next = push_log(model, message)
          ([], { ..next, status: message })
        } else {
          (
            [
              rpc_effect(
                ProjectLoaded,
                "project.create",
                {
                  "root": root.to_json(),
                  "name": model.project_name_input.to_json(),
                }.to_json(),
              ),
            ],
            { ..model, project_root_input: root, status: "Creating project..." },
          )
        }
      }
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
                    "project.open",
                    { "root": root.to_json() }.to_json(),
                  ),
                ],
                {
                  ..model,
                  project_root_input: root,
                  status: "Opening project...",
                },
              )
            }
            None =>
              (
                [],
                { ..model, status: "Choose a project folder to begin" },
              )
          }
        Err(message) => {
          let next = push_log(model, "Folder picker failed: " + message)
          ([], { ..next, status: "Folder picker failed: " + message })
        }
      }
    ProjectLoaded(result) =>
      match result {
        Ok(response) => {
          let scene_refs = response.scenes.unwrap_or([])
          let prefab_refs = response.prefabs.unwrap_or([])
          let atlas_refs = response.atlases.unwrap_or([])
          let animation_refs = response.animations.unwrap_or([])
          let workspace = response.workspace.unwrap_or(
            @editor_bridge.WorkspaceDocument::default(),
          )
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
            status,
          }
          (refresh_project_effects(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Project error: " + message)
          ([], { ..next, status: "Project error: " + message })
        }
      }
    SceneLoaded(result) =>
      match result {
        Ok(response) => {
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
            selected_entity_id: workspace.selected_entity_id,
            status: "Loaded " + response.path,
          }
          (sync_preview_effects(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Scene load failed: " + message)
          ([], { ..next, status: "Scene load failed: " + message })
        }
      }
    SceneListLoaded(result) =>
      match result {
        Ok(response) => {
          let manifest = model.manifest.map(fn(value) {
            value.with_startup_scene(response.startup_scene)
          })
          let next_scene_path = if scene_path_exists(response.scenes, model.scene_path) {
            model.scene_path
          } else {
            preferred_scene_path(manifest, response.scenes, model.workspace, model.scene_path)
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
                Some(selection) if resource_exists({ ..model, assets: response.assets }, selection) =>
                  Some(selection)
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
          ([], { ..model, prefab_documents })
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
          let next = { ..model, atlas_documents }
          (sync_preview_effects(next), next)
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
          let next = { ..model, animation_documents }
          (sync_preview_effects(next), next)
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
        (
          [],
          { ..model, asset_sizes },
        )
      } else {
        ([], model)
      }
    SceneSaved(result) =>
      match result {
        Ok(_) => ([], { ..model, status: "Scene saved" })
        Err(message) => {
          let next = push_log(model, "Save failed: " + message)
          ([], { ..next, status: "Save failed: " + message })
        }
      }
    ServiceEvent(result) =>
      match result {
        Ok(event) =>
          match event.kind {
            "ready" => ([], model)
            "log" =>
              match event.data {
                Json::Object(payload) => {
                  let label = if payload.contains("label") {
                    text_or_fallback(payload["label"], "log")
                  } else {
                    "log"
                  }
                  let message = if payload.contains("message") {
                    text_or_fallback(payload["message"], "")
                  } else {
                    ""
                  }
                  ([], push_log(model, "[\{label}] \{message}"))
                }
                _ => ([], model)
              }
            "files.changed"
            | "scene.saved"
            | "scene.patched"
            | "asset.imported" =>
              (
                [rpc_effect(ProjectLoaded, "project.current", Json::null())],
                model,
              )
            "project.opened" => ([], model)
            _ => ([], model)
          }
        Err(message) => {
          let next = push_log(model, "SSE error: " + message)
          ([], { ..next, status: "SSE error" })
        }
      }
    PreviewEvent(event) =>
      match event {
        @bridge.EntityPicked(id) => {
          let next = { ..model, selected_entity_id: id }
          (sync_preview_effects(next), next)
        }
        @bridge.HoverChanged(_) => ([], model)
        @bridge.TransformChanged(id~, translation~, rotation~) =>
          match model.selected_entity() {
            Some(entity) if model.selected_entity_id == Some(id) => {
              let transform : @editor_bridge.Transform2dComponent = component_of(
                entity, "Transform2d",
              ).unwrap_or(@editor_bridge.transform2d_value())
              let next = update_selected_component(
                model,
                @editor_bridge.transform2d_component(
                  translation~,
                  rotation~,
                  scale=transform.scale,
                ),
              )
              normalize_scene_after_change(next)
            }
            _ => ([], model)
          }
      }
    OpenScene(path) =>
      (
        [
          rpc_effect(
            SceneLoaded,
            "scene.load",
            { "path": path.to_json() }.to_json(),
          ),
        ],
        { ..model, scene_path: path, status: "Loading " + path + "..." },
      )
    SelectResource(resource) =>
      (
        [],
        {
          ..model,
          selected_resource: resource,
          selected_entity_id: None,
        },
      )
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
            rpc_effect(
              SceneLoaded,
              "scene.create",
              { "name": trimmed.to_json() }.to_json(),
            ),
            rpc_effect(SceneListLoaded, "scene.list", Json::null()),
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
        let next_scene_path = if model.scene_path == fallback && model.scene_refs.length() > 1 {
          model.scene_refs[1].path
        } else {
          fallback
        }
        (
          [
            rpc_effect(
              SceneSaved,
              "scene.delete",
              { "path": model.scene_path.to_json() }.to_json(),
            ),
            rpc_effect(SceneListLoaded, "scene.list", Json::null()),
            rpc_effect(
              SceneLoaded,
              "scene.load",
              { "path": next_scene_path.to_json() }.to_json(),
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
            "project.set_startup_scene",
            { "path": model.scene_path.to_json() }.to_json(),
          ),
          rpc_effect(SceneListLoaded, "scene.list", Json::null()),
        ],
        { ..model, status: "Updating startup scene..." },
      )
    RenameSelected(value) => {
      let next = update_selected_entity(model, fn(entity) {
        entity.renamed(value)
      })
      normalize_scene_after_change(next)
    }
    UpdateSelectedTranslateX(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let next = update_selected_component(
                model,
                @editor_bridge.transform2d_component(
                  translation=transform.translation.with_x(
                    parse_double_or(transform.translation.x, value),
                  ),
                  rotation=transform.rotation,
                  scale=transform.scale,
                ),
              )
              normalize_scene_after_change(next)
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
              let next = update_selected_component(
                model,
                @editor_bridge.transform2d_component(
                  translation=transform.translation.with_y(
                    parse_double_or(transform.translation.y, value),
                  ),
                  rotation=transform.rotation,
                  scale=transform.scale,
                ),
              )
              normalize_scene_after_change(next)
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
              let next = update_selected_component(
                model,
                @editor_bridge.transform2d_component(
                  translation=transform.translation,
                  rotation=parse_double_or(transform.rotation, value),
                  scale=transform.scale,
                ),
              )
              normalize_scene_after_change(next)
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
              let next = update_selected_component(
                model,
                @editor_bridge.text2d_component(
                  value,
                  font_path=text_component.font_path,
                  font_size=text_component.font_size,
                  color=text_component.color,
                  bounds=text_component.bounds,
                  anchor=text_component.anchor,
                ),
              )
              normalize_scene_after_change(next)
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
              normalize_scene_after_change(next)
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
                "scene.save",
                { "path": model.scene_path.to_json(), "scene": scene.to_json() }.to_json(),
              ),
            ],
            { ..model, status: "Saving scene..." },
          )
        None => ([], model)
      }
    ReloadScene =>
      (
        refresh_project_effects(model),
        { ..model, status: "Reloading..." },
      )
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
          normalize_scene_after_change(next)
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
            @editor_bridge.vec2_doc(0.0, 0.0),
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id: Some(id),
          }
          normalize_scene_after_change(next)
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
          normalize_scene_after_change(next)
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
          normalize_scene_after_change(next)
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
          normalize_scene_after_change(next)
        }
        _ => ([], model)
      }
    SetTool(tool) => {
      let next = { ..model, active_tool: tool }
      (sync_preview_effects(next), next)
    }
    FrameSelection =>
      ([Preview(@bridge.preview_command_frame_selection())], model)
  }
}
