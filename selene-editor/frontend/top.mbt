///|
fn[T : FromJson] decode_rpc_payload(payload : Json) -> Result[T, String] {
  try {
    let success : @shared.RpcSuccess = @json.from_json(payload)
    try {
      Ok(@json.from_json(success.result))
    } catch {
      err => {
        let message = "RpcSuccess decode failed: \{err.to_string()} result=\{success.result.stringify()}"
        Err(message)
      }
    }
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
let dragged_asset_path : Ref[String] = Ref::new("")

///|
fn begin_dragged_asset(path : String) -> Unit {
  dragged_asset_path.val = path
}

///|
fn clear_dragged_asset() -> Unit {
  dragged_asset_path.val = ""
}

///|
fn current_dragged_asset() -> String? {
  if dragged_asset_path.val == "" {
    None
  } else {
    Some(dragged_asset_path.val)
  }
}

///|
#cfg(target="js")
extern "js" fn drag_event_canvas_metrics(event : @dom.DragEvent) -> Array[Double] =
  #| (event) => {
  #|   const rect = event.currentTarget.getBoundingClientRect();
  #|   return [
  #|     event.clientX - rect.left,
  #|     event.clientY - rect.top,
  #|     rect.width,
  #|     rect.height,
  #|   ];
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_asset_payload(
  event : @dom.DragEvent,
  path : String,
) =
  #| (event, path) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.setData("text/plain", path);
  #|   transfer.effectAllowed = "copy";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_get_asset_payload(event : @dom.DragEvent) -> String =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return "";
  #|   return transfer.getData("text/plain") || "";
  #| }

///|
#cfg(target="js")
extern "js" fn drag_event_set_drop_copy(event : @dom.DragEvent) =
  #| (event) => {
  #|   const transfer = event.dataTransfer;
  #|   if (!transfer) return;
  #|   transfer.dropEffect = "copy";
  #| }

///|
#cfg(target="js")
extern "js" fn image_event_natural_metrics(event : @dom.Event) -> Array[Double] =
  #| (event) => {
  #|   const image = event.currentTarget;
  #|   return [
  #|     image?.naturalWidth || 0,
  #|     image?.naturalHeight || 0,
  #|   ];
  #| }

///|
fn drag_drop_translation(
  event : @dom.DragEvent,
) -> @editor_bridge.Vec2Doc? {
  let metrics = drag_event_canvas_metrics(event)
  if metrics.length() < 4 {
    return None
  }
  @preview.viewport_to_world(metrics[0], metrics[1], metrics[2], metrics[3])
}

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
  scene : @editor_bridge.SceneDocument,
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
fn project_asset_url(asset : @editor_bridge.AssetDocument) -> String {
  "/project/" + asset.path
}

///|
fn asset_drag_attrs(
  asset_path : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .draggable("true")
  .handler("dragstart", fn(event, _scheduler) {
    begin_dragged_asset(asset_path)
    match event.to_drag_event() {
      Some(drag_event) => drag_event_set_asset_payload(drag_event, asset_path)
      None => ()
    }
  })
  .handler("dragend", fn(event, _scheduler) {
    ignore(event)
    clear_dragged_asset()
  })
}

///|
fn asset_image_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  asset_path : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("load", fn(event, scheduler) {
    let metrics = image_event_natural_metrics(event)
    if metrics.length() < 2 {
      return
    }
    schedule_cmd(
      scheduler,
      dispatch(@app.msg_asset_size_resolved(asset_path, metrics[0], metrics[1])),
    )
  })
}

///|
fn tooltip_attrs(label : String) -> @html.Attrs {
  @html.Attrs::build().title(label).data_set("tooltip", label)
}

///|
fn asset_display_name(asset : @editor_bridge.AssetDocument) -> String {
  asset_display_name_from_path(asset.path)
}

///|
fn asset_display_name_from_path(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn asset_panel_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let assets = model.image_assets()
  if assets.is_empty() {
    return @html.div(
      class="panel-body empty",
      "No image assets found under assets/",
    )
  }
  let cards : Array[@rabbita.Html] = []
  for asset in assets {
    let is_selected = model.selected_asset_path == Some(asset.path)
    let size_label = match model.asset_size(asset.path) {
      Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
      None => "image"
    }
    cards.push(
      @html.div(
        class=if is_selected { "asset-card selected" } else { "asset-card" },
        on_click=dispatch(@app.msg_select_asset(Some(asset.path))),
        attrs=asset_drag_attrs(asset.path),
        [
          @html.img(
            class="asset-thumb",
            src=project_asset_url(asset),
            alt=asset.path,
            loading="lazy",
            attrs=asset_image_attrs(dispatch, asset.path),
            @html.nothing,
          ),
          @html.div(class="asset-meta", [
            @html.div(class="asset-name", asset_display_name(asset)),
            @html.div(class="asset-subtitle", asset.path),
            @html.div(class="asset-badge", size_label),
          ]),
        ],
      ),
    )
  }
  @html.div(class="panel-body asset-grid", [
    match model.selected_asset_path {
      Some(path) =>
        @html.div(class="asset-selection-banner", [
          @html.span(class="asset-selection-label", "Selected"),
          @html.span(class="asset-selection-value", asset_display_name_from_path(path)),
        ])
      None =>
        @html.div(
          class="asset-selection-banner empty",
          "Select an asset, then drag it into the viewport",
        )
    },
    @html.div(class="asset-list", cards),
  ])
}

///|
fn viewport_drop_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("dragover", fn(event, _scheduler) {
    event.prevent_default()
    match event.to_drag_event() {
      Some(drag_event) => drag_event_set_drop_copy(drag_event)
      None => ()
    }
  })
  .handler("drop", fn(event, scheduler) {
    event.prevent_default()
    let cmd = match current_dragged_asset() {
      Some(asset_path) => match event.to_drag_event() {
        Some(drag_event) =>
          match drag_drop_translation(drag_event) {
            Some(translation) =>
              dispatch(
                @app.msg_add_sprite_from_asset_at(asset_path, translation),
              )
            None => @cmd.none
          }
        None => @cmd.none
      }
      None =>
        match event.to_drag_event() {
          Some(drag_event) => {
            let asset_path = drag_event_get_asset_payload(drag_event)
            if asset_path == "" {
              @cmd.none
            } else {
              match drag_drop_translation(drag_event) {
                Some(translation) =>
                  dispatch(
                    @app.msg_add_sprite_from_asset_at(asset_path, translation),
                  )
                None => @cmd.none
              }
            }
          }
          None => @cmd.none
        }
    }
    clear_dragged_asset()
    schedule_cmd(scheduler, cmd)
  })
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
      let transform : @editor_bridge.Transform2dComponent? = @app.component_of(
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
      let text_component : @editor_bridge.Text2dComponent? = @app.component_of(
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
      let sprite_component : @editor_bridge.SpriteComponent? = @app.component_of(
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
      let visibility_component : @editor_bridge.VisibilityComponent? = @app.component_of(
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
  icon : String,
) -> @rabbita.Html {
  @html.button(
    class=if current == tool {
      "small-button icon-button active"
    } else {
      "small-button icon-button"
    },
    on_click=dispatch(@app.msg_set_tool(tool)),
    attrs=tooltip_attrs(label),
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn action_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  label : String,
  icon : String,
  msg : @app.Msg,
  primary? : Bool = false,
) -> @rabbita.Html {
  @html.button(
    class=if primary {
      "small-button icon-button primary-button"
    } else {
      "small-button icon-button"
    },
    on_click=dispatch(msg),
    attrs=tooltip_attrs(label),
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn entry_view(dispatch : @rabbita.Dispatch[@app.Msg], model : @app.Model) -> @rabbita.Html {
  @html.div(class="editor-root entry-root", [
    @html.div(class="welcome", [
      @html.h1(class="welcome-title", "Open a folder"),
      @html.p(
        class="welcome-copy",
        "selene-editor works on a single scene inside one local project directory.",
      ),
      @html.button(
        class="small-button primary-button",
        on_click=dispatch(@app.msg_pick_project_root()),
        "Choose Folder",
      ),
      @html.div(class="welcome-status", model.status),
    ]),
  ])
}

///|
fn view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  if model.current_root is None || model.scene is None {
    return entry_view(dispatch, model)
  }
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
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Project"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Choose Folder",
            "📁",
            @app.msg_pick_project_root(),
            primary=true,
          ),
          action_button(dispatch, "Save Scene", "💾", @app.msg_save_scene()),
        ]),
      ]),
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Scene"),
        @html.div(class="topbar-group", [
          action_button(dispatch, "Add Sprite", "🖼", @app.msg_add_sprite_entity()),
          action_button(dispatch, "Add Text", "T", @app.msg_add_text_entity()),
          action_button(dispatch, "Delete Selected", "⌫", @app.msg_delete_selected()),
          action_button(dispatch, "Frame Selection", "⛶", @app.msg_frame_selection()),
        ]),
      ]),
      @html.div(class="topbar-section topbar-tools", [
        @html.div(class="topbar-section-label", "Tools"),
        @html.div(class="topbar-group", [
        toolbar_button(
          dispatch,
          model.active_tool,
          @shared.preview_tool_select(),
          "Select",
          "↖",
        ),
        toolbar_button(
          dispatch,
          model.active_tool,
          @shared.preview_tool_translate(),
          "Move",
          "✥",
        ),
        toolbar_button(
          dispatch,
          model.active_tool,
          @shared.preview_tool_rotate(),
          "Rotate",
          "⟳",
        ),
        toolbar_button(
          dispatch,
          model.active_tool,
          @shared.preview_tool_scale(),
          "Scale",
          "⬚",
        ),
        ]),
      ]),
      @html.div(class="status", model.status),
    ]),
    @html.div(class="content", [
      @html.div(class="sidebar-column", [
        @html.div(class="panel assets-panel", [
          @html.h2("Assets"),
          asset_panel_view(dispatch, model),
        ]),
        @html.div(class="panel tree-panel", [
          @html.h2("Scene Tree"),
          @html.div(class="panel-body", scene_tree),
        ]),
      ]),
      @html.div(class="panel viewport-panel", [
        @html.h2("Viewport"),
        @html.div(
          class="viewport-toolbar",
          "Drag the selected asset from the sidebar into the scene",
        ),
        @html.div(class="viewport-frame", [
          @html.canvas(
            id="canvas",
            class="viewport-canvas",
            attrs=viewport_drop_attrs(dispatch),
            @html.nothing,
          ),
        ]),
      ]),
      @html.div(class="panel inspector-panel", [
        @html.h2("Inspector"),
        inspector,
      ]),
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
