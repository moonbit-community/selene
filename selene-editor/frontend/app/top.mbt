///|
pub struct ProjectStateResponse {
  root : String?
  manifest : @shared.ProjectManifest?
  recent_projects : Array[String]
} derive(FromJson, Show, Eq)

///|
pub struct SceneLoadResponse {
  path : String
  scene : @shared.SceneDocument
} derive(FromJson, Show, Eq)

///|
pub struct AssetsListResponse {
  assets : Array[@shared.AssetDocument]
} derive(FromJson, Show, Eq)

///|
pub struct DirectoryPickResponse {
  path : String?
} derive(FromJson, Show, Eq)

///|
pub struct Model {
  project_root_input : String
  project_name_input : String
  current_root : String?
  manifest : @shared.ProjectManifest?
  scene_path : String
  scene : @shared.SceneDocument?
  assets : Array[@shared.AssetDocument]
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
  ProjectRootPicked(Result[DirectoryPickResponse, String])
  ProjectLoaded(Result[ProjectStateResponse, String])
  SceneLoaded(Result[SceneLoadResponse, String])
  AssetsLoaded(Result[AssetsListResponse, String])
  SceneSaved(Result[Json, String])
  ServiceEvent(Result[@shared.EventEnvelope, String])
  PreviewEvent(@bridge.PreviewEvent)
  SelectEntity(String?)
  RenameSelected(String)
  UpdateSelectedTranslateX(String)
  UpdateSelectedTranslateY(String)
  UpdateSelectedRotation(String)
  UpdateSelectedText(String)
  ToggleSelectedVisibility
  SaveScene
  ReloadScene
  AddSpriteEntity
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
  AssetsLoaded
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
    scene_path: @shared.startup_scene_path_for_name("main"),
    scene: None,
    assets: [],
    selected_entity_id: None,
    status: "Ready",
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
  result : Result[DirectoryPickResponse, String],
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
pub fn msg_assets_loaded(result : Result[AssetsListResponse, String]) -> Msg {
  AssetsLoaded(result)
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
pub fn msg_select_entity(id : String?) -> Msg {
  SelectEntity(id)
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
fn sync_preview_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = [
    Preview(@bridge.preview_command_set_tool(model.active_tool)),
    Preview(@bridge.preview_command_select_entity(model.selected_entity_id)),
  ]
  match model.scene {
    Some(scene) =>
      effects.push(Preview(@bridge.preview_command_load_scene(scene)))
    None => effects.push(Preview(@bridge.preview_command_clear_scene()))
  }
  effects
}

///|
fn refresh_project_effects(
  manifest : @shared.ProjectManifest?,
  scene_path : String,
) -> Array[Effect] {
  match manifest {
    Some(_) =>
      [
        rpc_effect(
          SceneLoaded,
          "scene.load",
          { "path": scene_path.to_json() }.to_json(),
        ),
        rpc_effect(AssetsLoaded, "assets.list", Json::null()),
      ]
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
pub fn entity_label(entity : @shared.EntityDocument) -> String {
  entity.name + " (" + entity.id + ")"
}

///|
fn selected_after_load(
  previous : String?,
  scene : @shared.SceneDocument,
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
pub fn Model::selected_entity(self : Model) -> @shared.EntityDocument? {
  match (self.scene, self.selected_entity_id) {
    (Some(scene), Some(id)) => scene.entity(id)
    _ => None
  }
}

///|
pub fn[T : FromJson] component_of(
  entity : @shared.EntityDocument,
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
  updater : (@shared.EntityDocument) -> @shared.EntityDocument,
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
  component : @shared.ComponentDocument,
) -> Model {
  update_selected_entity(model, fn(entity) { entity.with_component(component) })
}

///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  match msg {
    Initialize =>
      (
        [
          rpc_effect(ProjectLoaded, "project.current", Json::null()),
          SubscribeServiceEvents,
          SubscribePreviewEvents,
          Preview(@bridge.preview_command_bootstrap()),
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
      (
        [
          rpc_effect(
            ProjectLoaded,
            "project.open",
            { "root": model.project_root_input.to_json() }.to_json(),
          ),
        ],
        { ..model, status: "Opening project..." },
      )
    CreateProject =>
      (
        [
          rpc_effect(
            ProjectLoaded,
            "project.create",
            {
              "root": model.project_root_input.to_json(),
              "name": model.project_name_input.to_json(),
            }.to_json(),
          ),
        ],
        { ..model, status: "Creating project..." },
      )
    ProjectRootPicked(result) =>
      match result {
        Ok(response) =>
          match response.path {
            Some(path) =>
              (
                [],
                {
                  ..model,
                  project_root_input: path,
                  status: "Selected " + path,
                },
              )
            None => ([], { ..model, status: "Folder selection cancelled" })
          }
        Err(message) => {
          let next = push_log(model, "Folder picker failed: " + message)
          ([], { ..next, status: "Folder picker failed: " + message })
        }
      }
    ProjectLoaded(result) =>
      match result {
        Ok(response) => {
          let scene_path = match response.manifest {
            Some(manifest) => manifest.startup_scene
            None => model.scene_path
          }
          let status = match response.root {
            Some(root) => "Project: " + root
            None => "No project open"
          }
          let project_root_input = response.root.unwrap_or(
            model.project_root_input,
          )
          let next = {
            ..model,
            current_root: response.root,
            manifest: response.manifest,
            recent_projects: response.recent_projects,
            scene_path,
            project_root_input,
            status,
          }
          (refresh_project_effects(next.manifest, next.scene_path), next)
        }
        Err(message) => {
          let next = push_log(model, "Project error: " + message)
          ([], { ..next, status: "Project error: " + message })
        }
      }
    SceneLoaded(result) =>
      match result {
        Ok(response) => {
          let next = {
            ..model,
            scene_path: response.path,
            scene: Some(response.scene),
            selected_entity_id: selected_after_load(
              model.selected_entity_id,
              response.scene,
            ),
            status: "Loaded " + response.path,
          }
          (sync_preview_effects(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Scene load failed: " + message)
          ([], { ..next, status: "Scene load failed: " + message })
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
              status: "Indexed \{response.assets.length()} assets",
            },
          )
        Err(message) => {
          let next = push_log(model, "Assets load failed: " + message)
          ([], { ..next, status: "Assets load failed: " + message })
        }
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
              (refresh_project_effects(model.manifest, model.scene_path), model)
            "project.opened" =>
              (
                [rpc_effect(ProjectLoaded, "project.current", Json::null())],
                model,
              )
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
              let transform : @shared.Transform2dComponent = component_of(
                entity, "Transform2d",
              ).unwrap_or(@shared.transform2d_value())
              let next = update_selected_component(
                model,
                @shared.transform2d_component(
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
    SelectEntity(id) => {
      let next = { ..model, selected_entity_id: id }
      (sync_preview_effects(next), next)
    }
    RenameSelected(value) => {
      let next = update_selected_entity(model, fn(entity) {
        entity.renamed(value)
      })
      normalize_scene_after_change(next)
    }
    UpdateSelectedTranslateX(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @shared.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let next = update_selected_component(
                model,
                @shared.transform2d_component(
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
          let transform : @shared.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let next = update_selected_component(
                model,
                @shared.transform2d_component(
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
          let transform : @shared.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let next = update_selected_component(
                model,
                @shared.transform2d_component(
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
          let text_component : @shared.Text2dComponent? = component_of(
            entity, "Text2d",
          )
          match text_component {
            Some(text_component) => {
              let next = update_selected_component(
                model,
                @shared.text2d_component(
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
          let visibility_component : @shared.VisibilityComponent? = component_of(
            entity, "Visibility",
          )
          match visibility_component {
            Some(visibility_component) => {
              let next = update_selected_component(
                model,
                @shared.visibility_component(
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
        refresh_project_effects(model.manifest, model.scene_path),
        { ..model, status: "Reloading..." },
      )
    AddSpriteEntity =>
      match model.scene {
        Some(scene) => {
          let id = "entity-\{scene.entities.length()}"
          let entity = @shared.entity_document(id, "Sprite", components=[
            @shared.transform2d_component(),
            @shared.visibility_component(),
            @shared.sprite_component(
              custom_size=Some(@shared.vec2_doc(64.0, 64.0)),
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
    AddTextEntity =>
      match model.scene {
        Some(scene) => {
          let id = "entity-\{scene.entities.length()}"
          let entity = @shared.entity_document(id, "Text", components=[
            @shared.transform2d_component(),
            @shared.visibility_component(),
            @shared.text2d_component("Text"),
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
