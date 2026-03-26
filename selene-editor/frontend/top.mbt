///|
fn decode_rpc_payload(
  payload : Json,
) -> Result[@shared.RpcResponseEnvelope, String] {
  try {
    Ok(@json.from_json(payload))
  } catch {
    err => Err(err.to_string())
  }
}

///|
fn project_root_picked_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.DirectoryPickResult, String] {
  match response {
    @shared.DirectoryPicked(result~) => Ok(result)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for project root picker")
  }
}

///|
fn project_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.ProjectStateResponse, String] {
  match response {
    @shared.ProjectState(state~) => Ok(state)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for project state")
  }
}

///|
fn scene_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.SceneLoadResponse, String] {
  match response {
    @shared.SceneLoaded(scene~) => Ok(scene)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for scene")
  }
}

///|
fn scene_list_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.SceneListResponse, String] {
  match response {
    @shared.SceneListed(list~) => Ok(list)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for scene list")
  }
}

///|
fn assets_list_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.AssetsListResponse, String] {
  match response {
    @shared.AssetsListed(list~) => Ok(list)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for assets")
  }
}

///|
fn prefab_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.PrefabLoadResponse, String] {
  match response {
    @shared.PrefabLoaded(prefab~) => Ok(prefab)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for prefab")
  }
}

///|
fn atlas_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.AtlasLoadResponse, String] {
  match response {
    @shared.AtlasLoaded(atlas~) => Ok(atlas)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for atlas")
  }
}

///|
fn animation_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.AnimationLoadResponse, String] {
  match response {
    @shared.AnimationLoaded(animation~) => Ok(animation)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for animation")
  }
}

///|
fn save_ack_of_response(
  response : @shared.RpcResponse,
) -> Result[Unit, String] {
  match response {
    @shared.SavedOk | @shared.StartupSceneUpdated(_) => Ok(())
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for save")
  }
}

///|
fn[T] rpc_cmd(
  request : @shared.RpcRequestEnvelope,
  decode : (@shared.RpcResponse) -> Result[T, String],
  on_result : (Result[T, String]) -> @rabbita.Cmd,
) -> @rabbita.Cmd {
  @http.post(
    "/rpc",
    @http.Body::Json(request.to_json()),
    expect=@http.Json(on_result, fn(payload) {
      match decode_rpc_payload(payload) {
        Ok(envelope) => decode(envelope.response)
        Err(message) => Err(message)
      }
    }),
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
#cfg(target="js")
extern "js" fn prompt_text(message : String, initial : String) -> String =
  #| (message, initial) => window.prompt(message, initial) || ""

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
          Ok(event.event)
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
  request : @shared.RpcRequestEnvelope,
) -> @rabbita.Cmd {
  match target {
    @app.ProjectRootPicked =>
      rpc_cmd(request, project_root_picked_of_response, fn(result) {
        dispatch(@app.msg_project_root_picked(result))
      })
    @app.ProjectLoaded =>
      rpc_cmd(request, project_loaded_of_response, fn(result) {
        dispatch(@app.msg_project_loaded(result))
      })
    @app.SceneLoaded =>
      rpc_cmd(request, scene_loaded_of_response, fn(result) {
        dispatch(@app.msg_scene_loaded(result))
      })
    @app.SceneListLoaded =>
      rpc_cmd(request, scene_list_of_response, fn(result) {
        dispatch(@app.msg_scene_list_loaded(result))
      })
    @app.AssetsLoaded =>
      rpc_cmd(request, assets_list_of_response, fn(result) {
        dispatch(@app.msg_assets_loaded(result))
      })
    @app.PrefabLoaded =>
      rpc_cmd(request, prefab_loaded_of_response, fn(result) {
        dispatch(@app.msg_prefab_loaded(result))
      })
    @app.AtlasLoaded =>
      rpc_cmd(request, atlas_loaded_of_response, fn(result) {
        dispatch(@app.msg_atlas_loaded(result))
      })
    @app.AnimationLoaded =>
      rpc_cmd(request, animation_loaded_of_response, fn(result) {
        dispatch(@app.msg_animation_loaded(result))
      })
    @app.SceneSaved =>
      rpc_cmd(request, save_ack_of_response, fn(result) {
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
    @app.Rpc(target~, request~) =>
      rpc_effect_cmd(dispatch, target, request)
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
fn atlas_region_preview_names(
  regions : Array[@editor_bridge.AtlasRegionDocument],
) -> String {
  if regions.is_empty() {
    return "No regions generated"
  }
  let names : Array[String] = []
  let limit = if regions.length() < 8 { regions.length() } else { 8 }
  for index = 0; index < limit; index = index + 1 {
    names.push(regions[index].name)
  }
  names.join(", ")
}

///|
fn resource_card(
  dispatch : @rabbita.Dispatch[@app.Msg],
  selected : Bool,
  selection : @app.ResourceSelection,
  title : String,
  subtitle : String,
  badge : String,
  preview : @rabbita.Html,
  attrs? : @html.Attrs = @html.Attrs::build(),
) -> @rabbita.Html {
  @html.div(
    class=if selected { "asset-card selected" } else { "asset-card" },
    on_click=dispatch(@app.msg_select_resource(Some(selection))),
    attrs=attrs,
    [
      preview,
      @html.div(class="asset-meta", [
        @html.div(class="asset-name", title),
        @html.div(class="asset-subtitle", subtitle),
        @html.div(class="asset-badge", badge),
      ]),
    ],
  )
}

///|
fn asset_section(
  title : String,
  items : Array[@rabbita.Html],
) -> @rabbita.Html {
  @html.div(class="asset-section", [
    @html.div(class="asset-section-title", title),
    if items.is_empty() {
      @html.div(class="asset-section-empty", "None")
    } else {
      @html.div(class="asset-list", items)
    },
  ])
}

///|
fn asset_panel_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let image_cards : Array[@rabbita.Html] = []
  for asset in model.image_assets() {
    let selection = @app.resource_selection_image(asset.path)
    let is_selected = model.selected_resource == Some(selection)
    let size_label = match model.asset_size(asset.path) {
      Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
      None => "image"
    }
    image_cards.push(
      resource_card(
        dispatch,
        is_selected,
        selection,
        asset_display_name(asset),
        asset.path,
        size_label,
        @html.img(
          class="asset-thumb",
          src=project_asset_url(asset),
          alt=asset.path,
          loading="lazy",
          attrs=asset_image_attrs(dispatch, asset.path),
          @html.nothing,
        ),
        attrs=asset_drag_attrs(asset.path),
      ),
    )
  }

  let atlas_cards : Array[@rabbita.Html] = []
  for atlas_ref in model.atlas_refs {
    let selection = @app.resource_selection_atlas(atlas_ref.path)
    let atlas_name = match model.atlas_documents.get(atlas_ref.path) {
      Some(atlas) => atlas.name
      None => asset_display_name_from_path(atlas_ref.path)
    }
    atlas_cards.push(
      resource_card(
        dispatch,
        model.selected_resource == Some(selection),
        selection,
        atlas_name,
        atlas_ref.path,
        "atlas",
        @html.div(class="asset-thumb asset-thumb-glyph", "▦"),
      ),
    )
  }

  let animation_cards : Array[@rabbita.Html] = []
  for animation_ref in model.animation_refs {
    let selection = @app.resource_selection_animation(animation_ref.path)
    let animation_name = match model.animation_documents.get(animation_ref.path) {
      Some(animation) => animation.name
      None => asset_display_name_from_path(animation_ref.path)
    }
    animation_cards.push(
      resource_card(
        dispatch,
        model.selected_resource == Some(selection),
        selection,
        animation_name,
        animation_ref.path,
        "anim",
        @html.div(class="asset-thumb asset-thumb-glyph", "▶"),
      ),
    )
  }

  let prefab_cards : Array[@rabbita.Html] = []
  for prefab_ref in model.prefab_refs {
    let selection = @app.resource_selection_prefab(prefab_ref.path)
    let prefab_name = match model.prefab_documents.get(prefab_ref.path) {
      Some(prefab) => prefab.name
      None => asset_display_name_from_path(prefab_ref.path)
    }
    prefab_cards.push(
      resource_card(
        dispatch,
        model.selected_resource == Some(selection),
        selection,
        prefab_name,
        prefab_ref.path,
        "prefab",
        @html.div(class="asset-thumb asset-thumb-glyph", "◆"),
      ),
    )
  }

  @html.div(class="panel-body asset-grid", [
    match model.selected_resource_path() {
      Some(path) =>
        @html.div(class="asset-selection-banner", [
          @html.span(class="asset-selection-label", "Selected"),
          @html.span(class="asset-selection-value", asset_display_name_from_path(path)),
        ])
      None =>
        @html.div(
          class="asset-selection-banner empty",
          "Select an asset or resource, then use the scene tools or drag images into the viewport",
        )
    },
    asset_section("Images", image_cards),
    asset_section("Atlases", atlas_cards),
    asset_section("Animations", animation_cards),
    asset_section("Prefabs", prefab_cards),
  ])
}

///|
fn scene_browser_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let items : Array[@rabbita.Html] = []
  for scene_ref in model.scene_refs {
    let is_selected = model.scene_path == scene_ref.path
    let is_startup = match model.manifest {
      Some(manifest) => manifest.startup_scene == scene_ref.path
      None => false
    }
    items.push(
      @html.div(
        class=if is_selected { "tree-item selected" } else { "tree-item" },
        on_click=dispatch(@app.msg_open_scene(scene_ref.path)),
        [
          @html.span(scene_ref.path),
          if is_startup {
            @html.span(class="scene-pill", "startup")
          } else {
            @html.nothing
          },
        ],
      ),
    )
  }
  @html.div(class="panel-body scene-browser-body", [
    @html.div(class="inspector-block", [
      @html.h3("Current Scene"),
      @html.div(class="kv", [
        @html.span(class="kv-key", "Name"),
        @html.span(
          class="kv-value",
          match model.scene {
            Some(scene) => scene.name
            None => "(none)"
          },
        ),
      ]),
      @html.div(class="kv", [
        @html.span(class="kv-key", "Path"),
        @html.span(class="kv-value", model.scene_path),
      ]),
    ]),
    @html.div(class="scene-browser-actions", [
      @html.button(
        class="small-button",
        attrs=tooltip_attrs("Create Scene"),
        on_click=@cmd.raw_effect(fn(scheduler) {
          let name = prompt_text("Scene name", "scene")
          if name.trim() != "" {
            schedule_cmd(scheduler, dispatch(@app.msg_create_scene(name)))
          }
        }),
        "+",
      ),
      @html.button(
        class="small-button",
        attrs=tooltip_attrs("Rename Current Scene"),
        on_click=@cmd.raw_effect(fn(scheduler) {
          let current_name = match model.scene {
            Some(scene) => scene.name
            None => "scene"
          }
          let name = prompt_text("Scene name", current_name)
          if name.trim() != "" {
            schedule_cmd(scheduler, dispatch(@app.msg_rename_current_scene(name)))
          }
        }),
        "✎",
      ),
      @html.button(
        class="small-button",
        attrs=tooltip_attrs("Delete Current Scene"),
        on_click=dispatch(@app.msg_delete_current_scene()),
        "−",
      ),
      @html.button(
        class="small-button",
        attrs=tooltip_attrs("Set Current As Startup"),
        on_click=dispatch(@app.msg_set_current_scene_as_startup()),
        "★",
      ),
    ]),
    if items.is_empty() {
      @html.div(class="empty", "No scenes in this project")
    } else {
      @html.div(class="scene-browser-list", items)
    },
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
fn selected_asset_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  match model.selected_resource {
    Some(@app.Image(path)) =>
      match model.selected_image_asset() {
        Some(asset) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Image"),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Name"),
                @html.span(class="kv-value", asset_display_name(asset)),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", asset.path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Size"),
                @html.span(
                  class="kv-value",
                  match model.asset_size(path) {
                    Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
                    None => "Unknown"
                  }
                ),
              ]),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Sprite To Scene",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_create_atlas_from_selected_image()),
                  "Create Atlas",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "No resource selected")
      }
    Some(@app.Atlas(_)) =>
      match model.selected_atlas_document() {
        Some((path, atlas)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Atlas"),
              labeled_input("Name", atlas.name, fn(value) {
                dispatch(@app.msg_update_selected_atlas_name(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Source"),
                @html.span(class="kv-value", atlas.source_image),
              ]),
              labeled_input("Tile Width", atlas.tile_size.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_tile_width(value))
              }),
              labeled_input("Tile Height", atlas.tile_size.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_tile_height(value))
              }),
              labeled_input("Columns", atlas.columns.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_columns(value))
              }),
              labeled_input("Rows", atlas.rows.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_rows(value))
              }),
              labeled_input("Spacing X", atlas.spacing.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_spacing_x(value))
              }),
              labeled_input("Spacing Y", atlas.spacing.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_spacing_y(value))
              }),
              labeled_input("Margin X", atlas.margin.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_x(value))
              }),
              labeled_input("Margin Y", atlas.margin.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_y(value))
              }),
              labeled_input("Anchor X", atlas.default_anchor.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_anchor_x(value))
              }),
              labeled_input("Anchor Y", atlas.default_anchor.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_anchor_y(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Regions"),
                @html.span(class="kv-value", atlas.regions.length().to_string()),
              ]),
              @html.div(
                class="kv-value",
                atlas_region_preview_names(atlas.regions),
              ),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_atlas()),
                  "Save Atlas",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Atlas Sprite",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_create_animation_from_selected_atlas()),
                  "Create Animation",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Atlas is still loading")
      }
    Some(@app.Animation(_)) =>
      match model.selected_animation_document() {
        Some((path, animation)) =>
          {
            let primary_clip = if animation.clips.is_empty() {
              @editor_bridge.animation_clip_document("default", 8.0, true, ["frame_0"])
            } else {
              animation.clips[0]
            }
            @html.div(class="panel-body", [
              @html.div(class="inspector-block", [
                @html.h3("Animation"),
                labeled_input("Name", animation.name, fn(value) {
                  dispatch(@app.msg_update_selected_animation_name(value))
                }),
                @html.div(class="kv", [
                  @html.span(class="kv-key", "Path"),
                  @html.span(class="kv-value", path),
                ]),
                @html.div(class="kv", [
                  @html.span(class="kv-key", "Atlas"),
                  @html.span(class="kv-value", animation.atlas_asset_path),
                ]),
                labeled_input(
                  "Default Clip",
                  animation.default_clip.unwrap_or(""),
                  fn(value) {
                    dispatch(@app.msg_update_selected_animation_default_clip(value))
                  },
                ),
                labeled_input("Clip Name", primary_clip.name, fn(value) {
                  dispatch(@app.msg_update_selected_animation_clip_name(value))
                }),
                labeled_input("Clip FPS", primary_clip.fps.to_string(), fn(value) {
                  dispatch(@app.msg_update_selected_animation_clip_fps(value))
                }),
                @html.label(class="field", [
                  @html.span(class="field-label", "Looping"),
                  @html.button(
                    class="small-button",
                    on_click=dispatch(@app.msg_toggle_selected_animation_clip_looping()),
                    if primary_clip.looping { "Enabled" } else { "Disabled" },
                  ),
                ]),
                labeled_input(
                  "Frames",
                  primary_clip.frames.join(", "),
                  fn(value) {
                    dispatch(@app.msg_update_selected_animation_clip_frames(value))
                  },
                ),
                @html.div(class="kv", [
                  @html.span(class="kv-key", "Clip Count"),
                  @html.span(class="kv-value", animation.clips.length().to_string()),
                ]),
                @html.div(class="inspector-actions", [
                  @html.button(
                    class="small-button",
                    on_click=dispatch(@app.msg_save_selected_animation()),
                    "Save Animation",
                  ),
                  @html.button(
                    class="small-button",
                    on_click=dispatch(@app.msg_insert_selected_resource()),
                    "Add Animated Sprite",
                  ),
                ]),
              ]),
            ])
          }
        None => @html.div(class="empty", "Animation is still loading")
      }
    Some(@app.Prefab(_)) =>
      match model.selected_prefab_document() {
        Some((path, prefab)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Prefab"),
              labeled_input("Name", prefab.name, fn(value) {
                dispatch(@app.msg_update_selected_prefab_name(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Entities"),
                @html.span(class="kv-value", prefab.entities.length().to_string()),
              ]),
              @html.div(
                class="kv-value",
                prefab.entities
                .map(fn(entity) { entity.name + " (" + entity.id + ")" })
                .join(", "),
              ),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_prefab()),
                  "Save Prefab",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Instantiate Prefab",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Prefab is still loading")
      }
    None => @html.div(class="empty", "No entity or resource selected")
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
      @html.div(class="welcome-logo", [
        @html.div(class="welcome-logo-mark", "S"),
        @html.div(class="welcome-logo-text", [
          @html.h1(class="welcome-title", "Selene Editor"),
          @html.p(class="welcome-tagline", "Build Selene-native 2D scenes, atlases, animations, and prefabs"),
        ]),
      ]),
      @html.p(
        class="welcome-copy",
        "Open a local Selene project directory to start editing scenes and resources.",
      ),
      @html.button(
        class="small-button primary-button",
        on_click=dispatch(@app.msg_open_project()),
        "Open Project",
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
        @html.div(class="inspector-actions", [
          @html.button(
            class="small-button",
            on_click=dispatch(@app.msg_save_selected_as_prefab()),
            "Save As Prefab",
          ),
        ]),
        selected_transform_view(dispatch, model),
        selected_visibility_view(dispatch, model),
        selected_sprite_view(model),
        selected_text_view(dispatch, model),
      ])
    None => selected_asset_view(dispatch, model)
  }
  @html.div(class="editor-root", [
    @html.div(class="topbar", [
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Project"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Open Project",
            "📁",
            @app.msg_open_project(),
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
        @html.div(class="panel scene-browser-panel", [
          @html.h2("Scenes"),
          scene_browser_view(dispatch, model),
        ]),
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
