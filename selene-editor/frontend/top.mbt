///|
priv struct ProjectStateResponse {
  root : String?
  manifest : @shared.ProjectManifest?
  recent_projects : Array[String]
} derive(FromJson)

///|
priv struct SceneLoadResponse {
  path : String
  scene : @shared.SceneDocument
} derive(FromJson)

///|
priv struct AssetsListResponse {
  assets : Array[@shared.AssetDocument]
} derive(FromJson)

///|
priv struct CommandResultResponse {
  exit_code : Int
  stdout : String
  stderr : String
} derive(FromJson)

///|
priv struct Model {
  project_root_input : String
  project_name_input : String
  current_root : String?
  manifest : @shared.ProjectManifest?
  recent_projects : Array[String]
  scene_path : String
  scene : @shared.SceneDocument?
  assets : Array[@shared.AssetDocument]
  selected_entity_id : String?
  status : String
  logs : Array[String]
  active_tool : @shared.PreviewTool
}

///|
priv enum Msg {
  Initialize
  SetProjectRootInput(String)
  SetProjectNameInput(String)
  OpenProject
  CreateProject
  RunCheck
  ProjectLoaded(Result[ProjectStateResponse, String])
  SceneLoaded(Result[SceneLoadResponse, String])
  AssetsLoaded(Result[AssetsListResponse, String])
  SceneSaved(Result[Json, String])
  BuildChecked(Result[CommandResultResponse, String])
  ServiceEvent(Result[@shared.EventEnvelope, String])
  PreviewEvent(@preview.PreviewEvent)
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
fn initial_model() -> Model {
  {
    project_root_input: "",
    project_name_input: "Selene Project",
    current_root: None,
    manifest: None,
    recent_projects: [],
    scene_path: "scenes/main.scene.json",
    scene: None,
    assets: [],
    selected_entity_id: None,
    status: "Ready",
    logs: [],
    active_tool: @shared.preview_tool_select(),
  }
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
fn project_loaded_cmd(dispatch : @rabbita.Dispatch[Msg]) -> @rabbita.Cmd {
  rpc_cmd("project.current", Json::null(), fn(result) {
    dispatch(ProjectLoaded(result))
  })
}

///|
fn scene_loaded_cmd(
  dispatch : @rabbita.Dispatch[Msg],
  path : String,
) -> @rabbita.Cmd {
  rpc_cmd("scene.load", { "path": path.to_json() }.to_json(), fn(result) {
    dispatch(SceneLoaded(result))
  })
}

///|
fn assets_loaded_cmd(dispatch : @rabbita.Dispatch[Msg]) -> @rabbita.Cmd {
  rpc_cmd("assets.list", Json::null(), fn(result) {
    dispatch(AssetsLoaded(result))
  })
}

///|
fn build_check_cmd(dispatch : @rabbita.Dispatch[Msg]) -> @rabbita.Cmd {
  rpc_cmd("build.check", Json::null(), fn(result) {
    dispatch(BuildChecked(result))
  })
}

///|
fn[T : FromJson] decode_rpc_payload(payload : Json) -> Result[T, String] {
  try {
    let success : @shared.RpcSuccess = @json.from_json(payload)
    Ok(@json.from_json(success.result))
  } catch {
    _ =>
      try {
        let failure : @shared.RpcFailure = @json.from_json(payload)
        Err(failure.error.message)
      } catch {
        err => Err(err.to_string())
      }
  }
}

///|
fn[T : FromJson] rpc_cmd(
  method_name : String,
  params : Json,
  on_result : (Result[T, String]) -> @rabbita.Cmd,
) -> @rabbita.Cmd {
  @http.post(
    "/rpc",
    @http.Body::Json(@shared.rpc_request(1, method_name, params).to_json()),
    expect=@http.Json(on_result, decode_rpc_payload),
  )
}

///|
#cfg(target="js")
extern "js" fn subscribe_events_forever(
  url : String,
  on_data : (String) -> Unit,
  on_error : (String) -> Unit,
) =
  #| (url, onData, onError) => {
  #|   const source = new EventSource(url);
  #|   source.onmessage = (event) => onData(event.data);
  #|   source.onerror = () => onError("EventSource error");
  #| }

///|
#cfg(target="js")
extern "js" fn schedule_cmd(scheduler : &@cmd.Scheduler, cmd : @rabbita.Cmd) = "(scheduler, cmd) => scheduler.add(cmd)"

///|
fn bootstrap_preview_cmd(dispatch : @rabbita.Dispatch[Msg]) -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(scheduler : &@cmd.Scheduler) {
      @preview.set_event_sink(
        Some(fn(event) {
          schedule_cmd(scheduler, dispatch(PreviewEvent(event)))
        }),
      )
      @preview.bootstrap()
    },
    kind=@cmd.after_render,
  )
}

///|
fn subscribe_events_cmd(dispatch : @rabbita.Dispatch[Msg]) -> @rabbita.Cmd {
  @cmd.raw_effect(fn(scheduler : &@cmd.Scheduler) {
    subscribe_events_forever(
      "/events",
      fn(data) {
        let result = try {
          let event : @shared.EventEnvelope = @json.from_json(@json.parse(data))
          Ok(event)
        } catch {
          err => Err(err.to_string())
        }
        schedule_cmd(scheduler, dispatch(ServiceEvent(result)))
      },
      fn(message) {
        schedule_cmd(scheduler, dispatch(ServiceEvent(Err(message))))
      },
    )
  })
}

///|
fn sync_preview_cmd(model : Model) -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(_scheduler) {
      @preview.set_tool(model.active_tool)
      @preview.select_entity(model.selected_entity_id)
      match model.scene {
        Some(scene) => @preview.load_scene(scene)
        None => ()
      }
    },
    kind=@cmd.after_render,
  )
}

///|
fn refresh_project_cmds(
  dispatch : @rabbita.Dispatch[Msg],
  manifest : @shared.ProjectManifest?,
  scene_path : String,
) -> @rabbita.Cmd {
  match manifest {
    Some(_) =>
      @cmd.batch([
        scene_loaded_cmd(dispatch, scene_path),
        assets_loaded_cmd(dispatch),
      ])
    None => @cmd.none
  }
}

///|
fn Model::selected_entity(self : Model) -> @shared.EntityDocument? {
  match (self.scene, self.selected_entity_id) {
    (Some(scene), Some(id)) => scene.entity(id)
    _ => None
  }
}

///|
fn[T : FromJson] component_of(
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
fn normalize_scene_after_change(model : Model) -> (@rabbita.Cmd, Model) {
  (sync_preview_cmd(model), model)
}

///|
fn parse_double_or(current : Double, input : String) -> Double {
  @strconv.parse_double(input) catch {
    _ => current
  }
}

///|
fn entity_label(entity : @shared.EntityDocument) -> String {
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
fn tree_view(
  dispatch : @rabbita.Dispatch[Msg],
  scene : @shared.SceneDocument,
  parent : String?,
  selected : String?,
  depth : Int,
) -> Array[@rabbita.Html] {
  let nodes : Array[@rabbita.Html] = []
  for entity in scene.entities {
    if entity.parent != parent {
      continue
    }
    let is_selected = selected == Some(entity.id)
    nodes.push(
      @html.div(
        class=if is_selected { "tree-item selected" } else { "tree-item" },
        style=["padding-left: \{depth * 14}px"],
        on_click=dispatch(SelectEntity(Some(entity.id))),
        entity_label(entity),
      ),
    )
    nodes.push_iter(
      tree_view(dispatch, scene, Some(entity.id), selected, depth + 1).iter(),
    )
  }
  nodes
}

///|
fn selected_transform_view(
  dispatch : @rabbita.Dispatch[Msg],
  model : Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let transform : @shared.Transform2dComponent? = component_of(
        entity, "Transform2d",
      )
      match transform {
        Some(transform) =>
          @html.div(class="inspector-block", [
            @html.h3("Transform2d"),
            labeled_input("X", transform.translation.x.to_string(), fn(value) {
              dispatch(UpdateSelectedTranslateX(value))
            }),
            labeled_input("Y", transform.translation.y.to_string(), fn(value) {
              dispatch(UpdateSelectedTranslateY(value))
            }),
            labeled_input("Rotation", transform.rotation.to_string(), fn(
              value,
            ) {
              dispatch(UpdateSelectedRotation(value))
            }),
          ])
        None => @html.nothing
      }
    }
    None => @html.nothing
  }
}

///|
fn selected_text_view(
  dispatch : @rabbita.Dispatch[Msg],
  model : Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let text_component : @shared.Text2dComponent? = component_of(
        entity, "Text2d",
      )
      match text_component {
        Some(text_component) =>
          @html.div(class="inspector-block", [
            @html.h3("Text2d"),
            labeled_input("Content", text_component.content, fn(value) {
              dispatch(UpdateSelectedText(value))
            }),
          ])
        None => @html.nothing
      }
    }
    None => @html.nothing
  }
}

///|
fn selected_sprite_view(model : Model) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let sprite_component : @shared.SpriteComponent? = component_of(
        entity, "Sprite",
      )
      match sprite_component {
        Some(sprite_component) =>
          @html.div(class="inspector-block", [
            @html.h3("Sprite"),
            @html.div(class="kv", [
              @html.span(class="kv-key", "Image"),
              @html.span(
                class="kv-value",
                sprite_component.image_path.unwrap_or("(none)"),
              ),
            ]),
            @html.div(class="kv", [
              @html.span(class="kv-key", "Mode"),
              @html.span(class="kv-value", sprite_component.image_mode),
            ]),
          ])
        None => @html.nothing
      }
    }
    None => @html.nothing
  }
}

///|
fn selected_visibility_view(
  dispatch : @rabbita.Dispatch[Msg],
  model : Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let visibility_component : @shared.VisibilityComponent? = component_of(
        entity, "Visibility",
      )
      match visibility_component {
        Some(visibility_component) =>
          @html.div(class="inspector-block", [
            @html.h3("Visibility"),
            @html.button(
              class="small-button",
              on_click=dispatch(ToggleSelectedVisibility),
              if visibility_component.visible {
                "Visible"
              } else {
                "Hidden"
              },
            ),
          ])
        None => @html.nothing
      }
    }
    None => @html.nothing
  }
}

///|
fn labeled_input(
  label : String,
  value : String,
  on_change : (String) -> @rabbita.Cmd,
) -> @rabbita.Html {
  @html.label(class="field", [
    @html.span(class="field-label", label),
    @html.input(value~, class="field-input", on_input=on_change, @html.nothing),
  ])
}

///|
fn update(
  dispatch : @rabbita.Dispatch[Msg],
  msg : Msg,
  model : Model,
) -> (@rabbita.Cmd, Model) {
  match msg {
    Initialize =>
      (
        @cmd.batch([
          project_loaded_cmd(dispatch),
          subscribe_events_cmd(dispatch),
          bootstrap_preview_cmd(dispatch),
        ]),
        model,
      )
    SetProjectRootInput(value) =>
      (@cmd.none, { ..model, project_root_input: value })
    SetProjectNameInput(value) =>
      (@cmd.none, { ..model, project_name_input: value })
    OpenProject =>
      (
        rpc_cmd(
          "project.open",
          { "root": model.project_root_input.to_json() }.to_json(),
          fn(result) { dispatch(ProjectLoaded(result)) },
        ),
        { ..model, status: "Opening project..." },
      )
    CreateProject =>
      (
        rpc_cmd(
          "project.create",
          {
            "root": model.project_root_input.to_json(),
            "name": model.project_name_input.to_json(),
          }.to_json(),
          fn(result) { dispatch(ProjectLoaded(result)) },
        ),
        { ..model, status: "Creating project..." },
      )
    RunCheck =>
      (build_check_cmd(dispatch), { ..model, status: "Running moon check..." })
    ProjectLoaded(result) =>
      match result {
        Ok(response) => {
          let next = {
            ..model,
            current_root: response.root,
            manifest: response.manifest,
            recent_projects: response.recent_projects,
            scene_path: response.manifest.map_or(model.scene_path, fn(
              manifest,
            ) {
              manifest.startup_scene
            }),
            project_root_input: response.root.unwrap_or(
              model.project_root_input,
            ),
            status: response.root.map_or("No project open", fn(root) {
              "Project: " + root
            }),
          }
          (refresh_project_cmds(dispatch, next.manifest, next.scene_path), next)
        }
        Err(message) => {
          let next = push_log(model, "Project error: " + message)
          (@cmd.none, { ..next, status: "Project error: " + message })
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
          (sync_preview_cmd(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Scene load failed: " + message)
          (@cmd.none, { ..next, status: "Scene load failed: " + message })
        }
      }
    AssetsLoaded(result) =>
      match result {
        Ok(response) =>
          (
            @cmd.none,
            {
              ..model,
              assets: response.assets,
              status: "Indexed \{response.assets.length()} assets",
            },
          )
        Err(message) => {
          let next = push_log(model, "Assets load failed: " + message)
          (@cmd.none, { ..next, status: "Assets load failed: " + message })
        }
      }
    SceneSaved(result) =>
      match result {
        Ok(_) => (@cmd.none, { ..model, status: "Scene saved" })
        Err(message) => {
          let next = push_log(model, "Save failed: " + message)
          (@cmd.none, { ..next, status: "Save failed: " + message })
        }
      }
    BuildChecked(result) =>
      match result {
        Ok(response) => {
          let next0 = {
            ..model,
            status: "moon check exit code \{response.exit_code}",
          }
          let next1 = if response.stdout == "" {
            next0
          } else {
            push_log(next0, response.stdout)
          }
          let next2 = if response.stderr == "" {
            next1
          } else {
            push_log(next1, response.stderr)
          }
          (@cmd.none, next2)
        }
        Err(message) => {
          let next = push_log(model, "Build failed: " + message)
          (@cmd.none, { ..next, status: "Build failed: " + message })
        }
      }
    ServiceEvent(result) =>
      match result {
        Ok(event) =>
          match event.kind {
            "ready" => (@cmd.none, model)
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
                  (@cmd.none, push_log(model, "[\{label}] \{message}"))
                }
                _ => (@cmd.none, model)
              }
            "files.changed"
            | "scene.saved"
            | "scene.patched"
            | "asset.imported" =>
              (
                refresh_project_cmds(dispatch, model.manifest, model.scene_path),
                model,
              )
            "project.opened" => (project_loaded_cmd(dispatch), model)
            _ => (@cmd.none, model)
          }
        Err(message) => {
          let next = push_log(model, "SSE error: " + message)
          (@cmd.none, { ..next, status: "SSE error" })
        }
      }
    PreviewEvent(event) =>
      match event {
        EntityPicked(id) => {
          let next = { ..model, selected_entity_id: id }
          (sync_preview_cmd(next), next)
        }
        HoverChanged(_) => (@cmd.none, model)
        TransformChanged(id~, translation~, rotation~) =>
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
            _ => (@cmd.none, model)
          }
      }
    SelectEntity(id) => {
      let next = { ..model, selected_entity_id: id }
      (sync_preview_cmd(next), next)
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
            None => (@cmd.none, model)
          }
        }
        None => (@cmd.none, model)
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
            None => (@cmd.none, model)
          }
        }
        None => (@cmd.none, model)
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
            None => (@cmd.none, model)
          }
        }
        None => (@cmd.none, model)
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
            None => (@cmd.none, model)
          }
        }
        None => (@cmd.none, model)
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
            None => (@cmd.none, model)
          }
        }
        None => (@cmd.none, model)
      }
    SaveScene =>
      match model.scene {
        Some(scene) =>
          (
            rpc_cmd(
              "scene.save",
              { "path": model.scene_path.to_json(), "scene": scene.to_json() }.to_json(),
              fn(result) { dispatch(SceneSaved(result)) },
            ),
            { ..model, status: "Saving scene..." },
          )
        None => (@cmd.none, model)
      }
    ReloadScene =>
      (
        refresh_project_cmds(dispatch, model.manifest, model.scene_path),
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
        None => (@cmd.none, model)
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
        None => (@cmd.none, model)
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
        _ => (@cmd.none, model)
      }
    SetTool(tool) => {
      let next = { ..model, active_tool: tool }
      (sync_preview_cmd(next), next)
    }
    FrameSelection =>
      (
        @cmd.raw_effect(
          fn(_scheduler) { @preview.frame_selection() },
          kind=@cmd.after_render,
        ),
        model,
      )
  }
}

///|
fn toolbar_button(
  dispatch : @rabbita.Dispatch[Msg],
  current : @shared.PreviewTool,
  tool : @shared.PreviewTool,
  label : String,
) -> @rabbita.Html {
  @html.button(
    class=if current == tool { "small-button active" } else { "small-button" },
    on_click=dispatch(SetTool(tool)),
    label,
  )
}

///|
fn project_summary_view(model : Model) -> @rabbita.Html {
  @html.div(class="panel-body", [
    @html.div(class="kv", [
      @html.span(class="kv-key", "Root"),
      @html.span(class="kv-value", model.current_root.unwrap_or("(none)")),
    ]),
    @html.div(class="kv", [
      @html.span(class="kv-key", "Recent"),
      @html.span(
        class="kv-value",
        if model.recent_projects.is_empty() {
          "(none)"
        } else {
          model.recent_projects.join(", ")
        },
      ),
    ]),
  ])
}

///|
fn view(dispatch : @rabbita.Dispatch[Msg], model : Model) -> @rabbita.Html {
  let scene_tree = match model.scene {
    Some(scene) => tree_view(dispatch, scene, None, model.selected_entity_id, 0)
    None => [@html.div(class="empty", "No scene loaded")]
  }
  let inspector = match model.selected_entity() {
    Some(entity) =>
      @html.div(class="panel-body", [
        labeled_input("Name", entity.name, fn(value) {
          dispatch(RenameSelected(value))
        }),
        selected_transform_view(dispatch, model),
        selected_visibility_view(dispatch, model),
        selected_sprite_view(model),
        selected_text_view(dispatch, model),
      ])
    None => @html.div(class="empty", "No entity selected")
  }
  @html.div(class="editor-root", [
    @html.div(class="topbar", [
      labeled_input("Project root", model.project_root_input, fn(value) {
        dispatch(SetProjectRootInput(value))
      }),
      labeled_input("Project name", model.project_name_input, fn(value) {
        dispatch(SetProjectNameInput(value))
      }),
      @html.button(class="small-button", on_click=dispatch(OpenProject), "Open"),
      @html.button(
        class="small-button",
        on_click=dispatch(CreateProject),
        "Create",
      ),
      @html.button(class="small-button", on_click=dispatch(SaveScene), "Save"),
      @html.button(
        class="small-button",
        on_click=dispatch(ReloadScene),
        "Reload",
      ),
      @html.button(class="small-button", on_click=dispatch(RunCheck), "Check"),
      @html.button(
        class="small-button",
        on_click=dispatch(AddSpriteEntity),
        "Add Sprite",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(AddTextEntity),
        "Add Text",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(DeleteSelected),
        "Delete",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(FrameSelection),
        "Frame",
      ),
      toolbar_button(
        dispatch,
        model.active_tool,
        @shared.preview_tool_select(),
        "Select",
      ),
      toolbar_button(
        dispatch,
        model.active_tool,
        @shared.preview_tool_translate(),
        "Move",
      ),
      toolbar_button(
        dispatch,
        model.active_tool,
        @shared.preview_tool_rotate(),
        "Rotate",
      ),
      toolbar_button(
        dispatch,
        model.active_tool,
        @shared.preview_tool_scale(),
        "Scale",
      ),
      @html.div(class="status", model.status),
    ]),
    @html.div(class="content", [
      @html.div(class="panel asset-panel", [
        @html.h2("Assets"),
        project_summary_view(model),
        @html.div(
          class="panel-body",
          model.assets.map(fn(asset) {
            @html.div(class="asset-row", asset.path)
          }),
        ),
      ]),
      @html.div(class="panel tree-panel", [
        @html.h2("Scene Tree"),
        @html.div(class="panel-body", scene_tree),
      ]),
      @html.div(class="panel viewport-panel", [
        @html.h2("Viewport"),
        @html.div(class="viewport-toolbar", "Selene preview"),
        @html.div(class="viewport-frame", [
          @html.canvas(id="canvas", class="viewport-canvas", @html.nothing),
        ]),
      ]),
      @html.div(class="panel inspector-panel", [
        @html.h2("Inspector"),
        inspector,
      ]),
    ]),
    @html.div(class="panel logs-panel", [
      @html.h2("Logs"),
      @html.div(
        class="panel-body logs",
        model.logs.map(fn(line) { @html.div(class="log-line", line) }),
      ),
    ]),
  ])
}

///|
#warnings("-alert_unstable")
pub fn start() -> Unit {
  let (dispatch, root) = @rabbita.cell_with_dispatch(
    model=initial_model(),
    update~,
    view~,
  )
  let app = @rabbita.new(root)
  app.with_init(dispatch(Initialize))
  app.mount("app")
}
