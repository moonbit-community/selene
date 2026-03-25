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
fn subscribe_events_cmd(dispatch : @rabbita.Dispatch[@app.Msg]) -> @rabbita.Cmd {
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
        schedule_cmd(scheduler, dispatch(@app.msg_service_event(result)))
      },
      fn(message) {
        schedule_cmd(scheduler, dispatch(@app.msg_service_event(Err(message))))
      },
    )
  })
}

///|
fn subscribe_preview_events_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @rabbita.Cmd {
  @cmd.raw_effect(fn(scheduler : &@cmd.Scheduler) {
    @preview.set_event_sink(
      Some(fn(event) {
        schedule_cmd(scheduler, dispatch(@app.msg_preview_event(event)))
      }),
    )
  })
}

///|
fn run_preview_command(command : @bridge.PreviewCommand) -> Unit {
  match command {
    @bridge.PreviewCommand::Bootstrap => @preview.bootstrap()
    @bridge.PreviewCommand::ClearScene => @preview.clear_scene()
    @bridge.PreviewCommand::LoadScene(scene) => @preview.load_scene(scene)
    @bridge.PreviewCommand::SelectEntity(id) => @preview.select_entity(id)
    @bridge.PreviewCommand::SetTool(tool) => @preview.set_tool(tool)
    @bridge.PreviewCommand::FrameSelection => @preview.frame_selection()
  }
}

///|
fn preview_cmd(command : @bridge.PreviewCommand) -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(_scheduler) { run_preview_command(command) },
    kind=@cmd.after_render,
  )
}

///|
fn rpc_effect_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  target : @app.RpcTarget,
  method_name : String,
  params : Json,
) -> @rabbita.Cmd {
  match target {
    @app.ProjectRootPicked =>
      rpc_cmd(method_name, params, fn(result) {
        dispatch(@app.msg_project_root_picked(result))
      })
    @app.ProjectLoaded =>
      rpc_cmd(method_name, params, fn(result) {
        dispatch(@app.msg_project_loaded(result))
      })
    @app.SceneLoaded =>
      rpc_cmd(method_name, params, fn(result) {
        dispatch(@app.msg_scene_loaded(result))
      })
    @app.AssetsLoaded =>
      rpc_cmd(method_name, params, fn(result) {
        dispatch(@app.msg_assets_loaded(result))
      })
    @app.SceneSaved =>
      rpc_cmd(method_name, params, fn(result : Result[Json, String]) {
        dispatch(@app.msg_scene_saved(result))
      })
  }
}

///|
fn effect_to_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  effect : @app.Effect,
) -> @rabbita.Cmd {
  match effect {
    @app.Rpc(target~, method_name~, params~) =>
      rpc_effect_cmd(dispatch, target, method_name, params)
    @app.SubscribeServiceEvents => subscribe_events_cmd(dispatch)
    @app.SubscribePreviewEvents => subscribe_preview_events_cmd(dispatch)
    @app.Preview(command) => preview_cmd(command)
  }
}

///|
fn effects_to_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  effects : Array[@app.Effect],
) -> @rabbita.Cmd {
  @cmd.batch(effects.map(fn(effect) { effect_to_cmd(dispatch, effect) }))
}

///|
fn update(
  dispatch : @rabbita.Dispatch[@app.Msg],
  msg : @app.Msg,
  model : @app.Model,
) -> (@rabbita.Cmd, @app.Model) {
  let (effects, next) = @app.update(msg, model)
  (effects_to_cmd(dispatch, effects), next)
}

///|
fn tree_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
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
        on_click=dispatch(@app.msg_select_entity(Some(entity.id))),
        @app.entity_label(entity),
      ),
    )
    nodes.push_iter(
      tree_view(dispatch, scene, Some(entity.id), selected, depth + 1).iter(),
    )
  }
  nodes
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
fn selected_transform_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let transform : @shared.Transform2dComponent? = @app.component_of(
        entity, "Transform2d",
      )
      match transform {
        Some(transform) =>
          @html.div(class="inspector-block", [
            @html.h3("Transform2d"),
            labeled_input("X", transform.translation.x.to_string(), fn(value) {
              dispatch(@app.msg_update_selected_translate_x(value))
            }),
            labeled_input("Y", transform.translation.y.to_string(), fn(value) {
              dispatch(@app.msg_update_selected_translate_y(value))
            }),
            labeled_input("Rotation", transform.rotation.to_string(), fn(
              value,
            ) {
              dispatch(@app.msg_update_selected_rotation(value))
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
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let text_component : @shared.Text2dComponent? = @app.component_of(
        entity, "Text2d",
      )
      match text_component {
        Some(text_component) =>
          @html.div(class="inspector-block", [
            @html.h3("Text2d"),
            labeled_input("Content", text_component.content, fn(value) {
              dispatch(@app.msg_update_selected_text(value))
            }),
          ])
        None => @html.nothing
      }
    }
    None => @html.nothing
  }
}

///|
fn selected_sprite_view(model : @app.Model) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let sprite_component : @shared.SpriteComponent? = @app.component_of(
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
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  match model.selected_entity() {
    Some(entity) => {
      let visibility_component : @shared.VisibilityComponent? = @app.component_of(
        entity, "Visibility",
      )
      match visibility_component {
        Some(visibility_component) =>
          @html.div(class="inspector-block", [
            @html.h3("Visibility"),
            @html.button(
              class="small-button",
              on_click=dispatch(@app.msg_toggle_selected_visibility()),
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
fn toolbar_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  current : @shared.PreviewTool,
  tool : @shared.PreviewTool,
  label : String,
) -> @rabbita.Html {
  @html.button(
    class=if current == tool { "small-button active" } else { "small-button" },
    on_click=dispatch(@app.msg_set_tool(tool)),
    label,
  )
}

///|
fn project_summary_view(model : @app.Model) -> @rabbita.Html {
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
fn view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let scene_tree = match model.scene {
    Some(scene) => tree_view(dispatch, scene, None, model.selected_entity_id, 0)
    None => [@html.div(class="empty", "No scene loaded")]
  }
  let inspector = match model.selected_entity() {
    Some(entity) =>
      @html.div(class="panel-body", [
        labeled_input("Name", entity.name, fn(value) {
          dispatch(@app.msg_rename_selected(value))
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
        dispatch(@app.msg_set_project_root_input(value))
      }),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_pick_project_root()),
        "Choose Folder",
      ),
      labeled_input("Project name", model.project_name_input, fn(value) {
        dispatch(@app.msg_set_project_name_input(value))
      }),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_open_project()),
        "Open",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_create_project()),
        "Create",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_save_scene()),
        "Save",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_reload_scene()),
        "Reload",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_add_sprite_entity()),
        "Add Sprite",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_add_text_entity()),
        "Add Text",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_delete_selected()),
        "Delete",
      ),
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_frame_selection()),
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
    model=@app.new_model(),
    update~,
    view~,
  )
  let app = @rabbita.new(root)
  app.with_init(dispatch(@app.msg_initialize()))
  app.mount("app")
}
