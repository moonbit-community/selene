///|
fn decode_rpc_payload(
  payload : Json,
) -> Result[@shared.RpcResponseEnvelope, String] {
  Ok(@json.from_json(payload)) catch {
    err => {
      console_error("RPC response decode failed: " + err.to_string())
      Err("Invalid server response")
    }
  }
}

///|
#cfg(target="js")
extern "js" fn console_error(message : String) =
  #| (message) => console.error(message)

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
) -> Result[@shared.SceneLoadOutcome, String] {
  match response {
    @shared.SceneLoaded(scene~) => Ok(@shared.scene_load_outcome_loaded(scene))
    @shared.SceneMigrationRequired(preview~) =>
      Ok(@shared.scene_load_outcome_migration_required(preview))
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
fn animation_clip_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.AnimationClipLoadResponse, String] {
  match response {
    @shared.AnimationClipLoaded(clip~) => Ok(clip)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for animation clip")
  }
}

///|
fn animation_graph_loaded_of_response(
  response : @shared.RpcResponse,
) -> Result[@shared.AnimationGraphLoadResponse, String] {
  match response {
    @shared.AnimationGraphLoaded(graph~) => Ok(graph)
    @shared.Error(error~) => Err(error.message)
    _ => Err("Unexpected RPC response for animation graph")
  }
}

///|
fn save_ack_of_response(response : @shared.RpcResponse) -> Result[Unit, String] {
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
fn[T] log_rpc_result_error(scope : String, result : Result[T, String]) -> Unit {
  match result {
    Ok(_) => ()
    Err(message) => console_error("RPC " + scope + " failed: " + message)
  }
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

///|
#cfg(target="js")
extern "js" fn schedule_cmd(scheduler : &@cmd.Scheduler, cmd : @rabbita.Cmd) =
  #| (scheduler, cmd) => scheduler.method_table.method_0(scheduler.self, cmd)

///|
#cfg(target="js")
extern "js" fn prompt_text(message : String, initial : String) -> String =
  #| (message, initial) => window.prompt(message, initial) || ""

///|
#cfg(target="js")
extern "js" fn subscribe_shortcuts_forever(
  on_undo : () -> Unit,
  on_redo : () -> Unit,
  on_save : () -> Unit,
  on_delete : () -> Unit,
  on_frame : () -> Unit,
  on_select : () -> Unit,
  on_drag_canvas : () -> Unit,
  on_move : () -> Unit,
  on_rotate : () -> Unit,
  on_scale : () -> Unit,
  on_expand_assets : () -> Unit,
  on_collapse_assets : () -> Unit,
  on_insert_selected_asset : () -> Unit,
  on_select_previous_asset : () -> Unit,
  on_select_next_asset : () -> Unit,
  on_select_first_asset : () -> Unit,
  on_select_last_asset : () -> Unit,
  on_select_previous_asset_page : () -> Unit,
  on_select_next_asset_page : () -> Unit,
  on_move_snap_step_down : () -> Unit,
  on_move_snap_step_up : () -> Unit,
  on_open_add_component : () -> Unit,
  on_clear_selection : () -> Unit,
) =
  #| (
  #|   onUndo,
  #|   onRedo,
  #|   onSave,
  #|   onDelete,
  #|   onFrame,
  #|   onSelect,
  #|   onDragCanvas,
  #|   onMove,
  #|   onRotate,
  #|   onScale,
  #|   onExpandAssets,
  #|   onCollapseAssets,
  #|   onInsertSelectedAsset,
  #|   onSelectPreviousAsset,
  #|   onSelectNextAsset,
  #|   onSelectFirstAsset,
  #|   onSelectLastAsset,
  #|   onSelectPreviousAssetPage,
  #|   onSelectNextAssetPage,
  #|   onMoveSnapStepDown,
  #|   onMoveSnapStepUp,
  #|   onOpenAddComponent,
  #|   onClearSelection
  #| ) => {
  #|   const isEditable = (target) => {
  #|     if (!target) return false;
  #|     const tag = (target.tagName || "").toLowerCase();
  #|     return (
  #|       tag === "input" ||
  #|       tag === "textarea" ||
  #|       tag === "select" ||
  #|       target.isContentEditable === true
  #|     );
  #|   };
  #|   window.addEventListener("keydown", (event) => {
  #|     const key = (event.key || "").toLowerCase();
  #|     if (isEditable(event.target)) return;
  #|     if (event.metaKey || event.ctrlKey) {
  #|       if (key === "z") {
  #|         event.preventDefault();
  #|         if (event.shiftKey) onRedo();
  #|         else onUndo();
  #|         return;
  #|       }
  #|       if (key === "y") {
  #|         event.preventDefault();
  #|         onRedo();
  #|         return;
  #|       }
  #|       if (key === "s") {
  #|         event.preventDefault();
  #|         onSave();
  #|         return;
  #|       }
  #|       return;
  #|     }
  #|     if (key === "backspace" || key === "delete") {
  #|       event.preventDefault();
  #|       onDelete();
  #|       return;
  #|     }
  #|     if (key === "f") {
  #|       event.preventDefault();
  #|       onFrame();
  #|       return;
  #|     }
  #|     if (key === "v") {
  #|       event.preventDefault();
  #|       onSelect();
  #|       return;
  #|     }
  #|     if (key === "h") {
  #|       event.preventDefault();
  #|       onDragCanvas();
  #|       return;
  #|     }
  #|     if (key === "w") {
  #|       event.preventDefault();
  #|       onMove();
  #|       return;
  #|     }
  #|     if (key === "e") {
  #|       event.preventDefault();
  #|       onRotate();
  #|       return;
  #|     }
  #|     if (key === "r") {
  #|       event.preventDefault();
  #|       onScale();
  #|       return;
  #|     }
  #|     if (key === "]") {
  #|       event.preventDefault();
  #|       onExpandAssets();
  #|       return;
  #|     }
  #|     if (key === "[") {
  #|       event.preventDefault();
  #|       onCollapseAssets();
  #|       return;
  #|     }
  #|     if (key === "i") {
  #|       event.preventDefault();
  #|       onInsertSelectedAsset();
  #|       return;
  #|     }
  #|     if (key === "enter") {
  #|       event.preventDefault();
  #|       onInsertSelectedAsset();
  #|       return;
  #|     }
  #|     if (key === "arrowup") {
  #|       event.preventDefault();
  #|       onSelectPreviousAsset();
  #|       return;
  #|     }
  #|     if (key === "arrowdown") {
  #|       event.preventDefault();
  #|       onSelectNextAsset();
  #|       return;
  #|     }
  #|     if (key === "home") {
  #|       event.preventDefault();
  #|       onSelectFirstAsset();
  #|       return;
  #|     }
  #|     if (key === "end") {
  #|       event.preventDefault();
  #|       onSelectLastAsset();
  #|       return;
  #|     }
  #|     if (key === "pageup") {
  #|       event.preventDefault();
  #|       onSelectPreviousAssetPage();
  #|       return;
  #|     }
  #|     if (key === "pagedown") {
  #|       event.preventDefault();
  #|       onSelectNextAssetPage();
  #|       return;
  #|     }
  #|     if (key === "-" || key === "_") {
  #|       event.preventDefault();
  #|       onMoveSnapStepDown();
  #|       return;
  #|     }
  #|     if (key === "=" || key === "+") {
  #|       event.preventDefault();
  #|       onMoveSnapStepUp();
  #|       return;
  #|     }
  #|     if (key === "c") {
  #|       event.preventDefault();
  #|       onOpenAddComponent();
  #|       return;
  #|     }
  #|     if (key === "escape") {
  #|       event.preventDefault();
  #|       onClearSelection();
  #|       return;
  #|     }
  #|   });
  #| }

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
extern "js" fn drag_event_canvas_metrics(
  event : @dom.DragEvent,
) -> Array[Double] =
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
extern "js" fn input_event_is_enter_key(event : @dom.Event) -> Bool =
  #| (event) => (event?.key || "").toLowerCase() === "enter"

///|
#cfg(target="js")
extern "js" fn input_event_is_escape_key(event : @dom.Event) -> Bool =
  #| (event) => (event?.key || "").toLowerCase() === "escape"

///|
#cfg(target="js")
extern "js" fn input_event_blur_target(event : @dom.Event) =
  #| (event) => event?.target?.blur?.()

///|
#cfg(target="js")
extern "js" fn scroll_selected_asset_row_into_view() =
  #| () => {
  #|   requestAnimationFrame(() => {
  #|     const row = document.querySelector(".asset-tree-row.file.selected");
  #|     if (!row || typeof row.scrollIntoView !== "function") return;
  #|     row.scrollIntoView({ block: "nearest", inline: "nearest" });
  #|   });
  #| }

///|
#cfg(target="js")
extern "js" fn focus_component_search_input() =
  #| () => {
  #|   requestAnimationFrame(() => {
  #|     const input = document.querySelector(".component-search-input");
  #|     if (!input || typeof input.focus !== "function") return;
  #|     input.focus();
  #|     if (typeof input.select === "function") {
  #|       input.select();
  #|     }
  #|   });
  #| }

///|
#cfg(target="js")
extern "js" fn project_asset_src(path : String) -> String =
  #| (path) => {
  #|   const normalized = (path || "").replace(/^\/+/, "");
  #|   if (!normalized) return "";
  #|   const segments = normalized.split("/").map((segment) => {
  #|     try {
  #|       return encodeURIComponent(decodeURIComponent(segment));
  #|     } catch (_error) {
  #|       return encodeURIComponent(segment);
  #|     }
  #|   });
  #|   return "/project/" + segments.join("/");
  #| }

///|
#cfg(target="js")
extern "js" fn image_event_natural_size(event : @dom.Event) -> Array[Double] =
  #| (event) => {
  #|   const target = event && event.target;
  #|   if (!target) return [];
  #|   const width = Number(target.naturalWidth || 0);
  #|   const height = Number(target.naturalHeight || 0);
  #|   if (width <= 0 || height <= 0) return [];
  #|   return [width, height];
  #| }

///|
#cfg(target="js")
extern "js" fn sync_asset_tree_sticky_overlay() =
  #| () => {
  #|   const scroll = document.querySelector(".asset-tree-scroll");
  #|   if (!scroll) return;
  #|   const overlay = scroll.querySelector(".asset-tree-sticky-overlay");
  #|   if (!overlay) return;
  #|
  #|   // Ported from VSCode sticky-scroll model:
  #|   // derive sticky ancestors from the first visible row in the viewport.
  #|   const render = () => {
  #|     const rows = Array.from(
  #|       scroll.querySelectorAll(".asset-grid .asset-tree-row")
  #|     );
  #|     if (!rows.length) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const scrollRect = scroll.getBoundingClientRect();
  #|     const firstVisible = rows.find((row) => {
  #|       const rect = row.getBoundingClientRect();
  #|       return rect.bottom > scrollRect.top + 1;
  #|     });
  #|     if (!firstVisible) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const chainRaw = firstVisible.dataset.stickyChain || "";
  #|     const section = firstVisible.dataset.stickySection || "";
  #|     const segments = chainRaw ? chainRaw.split("/") : [];
  #|     if (!segments.length) {
  #|       overlay.replaceChildren();
  #|       overlay.classList.add("empty");
  #|       return;
  #|     }
  #|     const fragment = document.createDocumentFragment();
  #|     const sectionRow = document.createElement("div");
  #|     sectionRow.className = "asset-tree-sticky-section";
  #|     sectionRow.textContent = section;
  #|     fragment.appendChild(sectionRow);
  #|     for (let depth = 0; depth < segments.length; depth++) {
  #|       const row = document.createElement("div");
  #|       row.className = "asset-tree-row folder sticky-overlay-row";
  #|
  #|       for (let i = 0; i < depth; i++) {
  #|         const indent = document.createElement("span");
  #|         indent.className = "asset-tree-indent";
  #|         row.appendChild(indent);
  #|       }
  #|
  #|       const node = document.createElement("span");
  #|       node.className = "asset-tree-node";
  #|       node.textContent = "▾";
  #|       row.appendChild(node);
  #|
  #|       const label = document.createElement("span");
  #|       label.className = "asset-tree-label folder";
  #|       label.textContent = segments[depth];
  #|       row.appendChild(label);
  #|
  #|       fragment.appendChild(row);
  #|     }
  #|     overlay.replaceChildren(fragment);
  #|     overlay.classList.remove("empty");
  #|   };
  #|
  #|   if (!scroll.__seleneTreeStickyBound) {
  #|     scroll.__seleneTreeStickyBound = true;
  #|     scroll.__seleneTreeStickyRender = render;
  #|     scroll.addEventListener("scroll", render, { passive: true });
  #|     window.addEventListener("resize", render, { passive: true });
  #|   } else {
  #|     scroll.__seleneTreeStickyRender = render;
  #|   }
  #|   requestAnimationFrame(render);
  #| }

///|
fn drag_drop_translation(event : @dom.DragEvent) -> @editor_bridge.Vec2Doc? {
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
          err => {
            console_error("SSE decode failed: " + err.to_string())
            Err("Invalid event payload")
          }
        }
        schedule_cmd(scheduler, dispatch(@app.msg_service_event(result)))
      },
      fn(message) {
        console_error("SSE stream failed: " + message)
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
fn subscribe_shortcuts_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @rabbita.Cmd {
  @cmd.raw_effect(fn(scheduler : &@cmd.Scheduler) {
    subscribe_shortcuts_forever(
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_undo_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_redo_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_save_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_delete_selected())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_frame_selection())) },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_select())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_drag_canvas())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_translate())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_rotate())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_scale())),
        )
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_expand_all_asset_folders()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_collapse_all_asset_folders()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_insert_selected_resource()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(-1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(1)))
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_move_selected_resource(-1000000)),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_move_selected_resource(1000000)),
        )
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(-10)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(10)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_adjust_move_snap_step(-1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_adjust_move_snap_step(1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_open_add_component_panel()))
      },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_clear_selection())) },
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
    @bridge.PreviewCommand::SetMoveSnap(enabled~, step~) =>
      @preview.set_move_snap(enabled, step)
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
        log_rpc_result_error("project.pick_directory", result)
        dispatch(@app.msg_project_root_picked(result))
      })
    @app.ProjectLoaded =>
      rpc_cmd(request, project_loaded_of_response, fn(result) {
        log_rpc_result_error("project.open", result)
        dispatch(@app.msg_project_loaded(result))
      })
    @app.SceneLoaded =>
      rpc_cmd(request, scene_loaded_of_response, fn(result) {
        log_rpc_result_error("scene.load", result)
        dispatch(@app.msg_scene_loaded(result))
      })
    @app.SceneListLoaded =>
      rpc_cmd(request, scene_list_of_response, fn(result) {
        log_rpc_result_error("scene.list", result)
        dispatch(@app.msg_scene_list_loaded(result))
      })
    @app.AssetsLoaded =>
      rpc_cmd(request, assets_list_of_response, fn(result) {
        log_rpc_result_error("assets.list", result)
        dispatch(@app.msg_assets_loaded(result))
      })
    @app.PrefabLoaded =>
      rpc_cmd(request, prefab_loaded_of_response, fn(result) {
        log_rpc_result_error("prefab.load", result)
        dispatch(@app.msg_prefab_loaded(result))
      })
    @app.AtlasLoaded =>
      rpc_cmd(request, atlas_loaded_of_response, fn(result) {
        log_rpc_result_error("atlas.load", result)
        dispatch(@app.msg_atlas_loaded(result))
      })
    @app.AnimationClipLoaded =>
      rpc_cmd(request, animation_clip_loaded_of_response, fn(result) {
        log_rpc_result_error("animation.clip.load", result)
        dispatch(@app.msg_animation_clip_loaded(result))
      })
    @app.AnimationGraphLoaded =>
      rpc_cmd(request, animation_graph_loaded_of_response, fn(result) {
        log_rpc_result_error("animation.graph.load", result)
        dispatch(@app.msg_animation_graph_loaded(result))
      })
    @app.SceneSaved =>
      rpc_cmd(request, save_ack_of_response, fn(result) {
        log_rpc_result_error("scene.save", result)
        dispatch(@app.msg_scene_saved(result))
      })
    @app.WorkspaceSaved =>
      rpc_cmd(request, save_ack_of_response, fn(result) {
        log_rpc_result_error("project.save_workspace", result)
        dispatch(@app.msg_workspace_saved(result))
      })
  }
}

///|
fn effect_to_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  effect : @app.Effect,
) -> @rabbita.Cmd {
  match effect {
    @app.Rpc(target~, request~) => rpc_effect_cmd(dispatch, target, request)
    @app.SubscribeServiceEvents => subscribe_events_cmd(dispatch)
    @app.SubscribePreviewEvents => subscribe_preview_events_cmd(dispatch)
    @app.SubscribeKeyboardShortcuts => subscribe_shortcuts_cmd(dispatch)
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
fn ensure_selected_asset_visible_cmd() -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(_scheduler) { scroll_selected_asset_row_into_view() },
    kind=@cmd.after_render,
  )
}

///|
fn focus_component_search_cmd() -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(_scheduler) { focus_component_search_input() },
    kind=@cmd.after_render,
  )
}

///|
fn sync_asset_tree_sticky_overlay_cmd() -> @rabbita.Cmd {
  @cmd.raw_effect(
    fn(_scheduler) { sync_asset_tree_sticky_overlay() },
    kind=@cmd.after_render,
  )
}

///|
fn update(
  dispatch : @rabbita.Dispatch[@app.Msg],
  msg : @app.Msg,
  model : @app.Model,
) -> (@rabbita.Cmd, @app.Model) {
  let (effects, next) = @app.update(msg, model)
  let effects_cmd = effects_to_cmd(dispatch, effects)
  let selection_sync_cmd = if next.selected_resource != model.selected_resource &&
    next.selected_resource is Some(_) {
    ensure_selected_asset_visible_cmd()
  } else {
    @cmd.none
  }
  let component_search_focus_cmd = if next.add_component_panel_open &&
    !model.add_component_panel_open {
    focus_component_search_cmd()
  } else {
    @cmd.none
  }
  let sticky_overlay_sync_cmd = sync_asset_tree_sticky_overlay_cmd()
  (
    @cmd.batch([
      effects_cmd, selection_sync_cmd, component_search_focus_cmd, sticky_overlay_sync_cmd,
    ]),
    next,
  )
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
        attrs=scene_tree_item_attrs(dispatch, entity),
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
fn scene_tree_item_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  entity : @editor_bridge.EntityDocument,
) -> @html.Attrs {
  let hover_hint = "Entity: " +
    @app.entity_label(entity) +
    " (double-click to frame)"
  @html.Attrs::build()
  .handler("click", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_select_entity(Some(entity.id))))
  })
  .handler("dblclick", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_select_entity(Some(entity.id))))
    schedule_cmd(scheduler, dispatch(@app.msg_frame_selection()))
  })
  .handler("mouseenter", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(Some(hover_hint))))
  })
  .handler("mouseleave", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
  })
}

///|
fn hint_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  label : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("mouseenter", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(Some(label))))
  })
  .handler("mouseleave", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
  })
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
fn image_preview_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  path : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("load", fn(event, scheduler) {
    let size = image_event_natural_size(event)
    if size.length() >= 2 {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_asset_size_resolved(path, size[0], size[1])),
      )
    }
  })
  .handler("error", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_asset_image_load_failed(path)))
  })
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
fn tree_path_segments(path : String, drop_root : String?) -> Array[String] {
  let raw = path.split("/")
  let segments : Array[String] = []
  for segment in raw {
    if segment != "" {
      segments.push(segment.to_string())
    }
  }
  let mut start = 0
  match drop_root {
    Some(root) if !segments.is_empty() && segments[0] == root => start = 1
    _ => ()
  }
  let trimmed : Array[String] = []
  for index = start; index < segments.length(); index = index + 1 {
    trimmed.push(segments[index])
  }
  if trimmed.is_empty() {
    [path]
  } else {
    trimmed
  }
}

///|
fn common_prefix_len(left : Array[String], right : Array[String]) -> Int {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  for index = 0; index < limit; index = index + 1 {
    if left[index] != right[index] {
      return index
    }
  }
  limit
}

///|
fn tree_row_indents(depth : Int) -> Array[@rabbita.Html] {
  let indents : Array[@rabbita.Html] = []
  for _index = 0; _index < depth; _index = _index + 1 {
    indents.push(@html.span(class="asset-tree-indent", @html.nothing))
  }
  indents
}

///|
fn asset_tree_section_title(section_key : String) -> String {
  match section_key {
    "images" => "IMAGES"
    "atlases" => "ATLASES"
    "animations" => "ANIMATIONS"
    "prefabs" => "PREFABS"
    _ => section_key
  }
}

///|
fn folder_chain_key(
  section_key : String,
  folders : Array[String],
  depth : Int,
) -> String {
  section_key + ":" + folders[:depth + 1].join("/")
}

///|
fn folder_ancestors_expanded(
  model : @app.Model,
  section_key : String,
  folders : Array[String],
  force_expand : Bool,
  depth_exclusive : Int,
) -> Bool {
  if force_expand {
    return true
  }
  for index = 0; index < depth_exclusive; index = index + 1 {
    let key = folder_chain_key(section_key, folders, index)
    if !model.asset_tree_folder_expanded(key) {
      return false
    }
  }
  true
}

///|
fn tree_folder_row(
  dispatch : @rabbita.Dispatch[@app.Msg],
  depth : Int,
  label : String,
  hover_label : String,
  expanded : Bool,
  toggle_enabled : Bool,
  folder_key : String,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @rabbita.Html {
  let children = tree_row_indents(depth)
  children.push(
    @html.span(class="asset-tree-node", if expanded { "▾" } else { "▸" }),
  )
  children.push(@html.span(class="asset-tree-label folder", label))
  let class = if toggle_enabled {
    if expanded {
      "asset-tree-row folder expanded"
    } else {
      "asset-tree-row folder collapsed"
    }
  } else if expanded {
    "asset-tree-row folder expanded locked"
  } else {
    "asset-tree-row folder collapsed locked"
  }
  let attrs = hint_attrs(dispatch, hover_label)
    .data_set("sticky-chain", sticky_chain.join("/"))
    .data_set("sticky-section", sticky_section)
    .data_set("sticky-kind", "folder")
  @html.button(
    class=if expanded { class } else { class },
    on_click=if toggle_enabled {
      dispatch(@app.msg_toggle_asset_tree_folder(folder_key))
    } else {
      @cmd.none
    },
    attrs~,
    children,
  )
}

///|
fn tree_file_row(
  dispatch : @rabbita.Dispatch[@app.Msg],
  selected : Bool,
  selection : @app.ResourceSelection,
  full_path : String,
  depth : Int,
  label : String,
  badge : String,
  draggable_asset_path : String?,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @rabbita.Html {
  let children = tree_row_indents(depth)
  children.push(
    @html.span(
      class="asset-tree-node file",
      match selection {
        @app.Image(_) => "I"
        @app.Atlas(_) => "A"
        @app.AnimationClip(_) => "C"
        @app.AnimationGraph(_) => "G"
        @app.Prefab(_) => "P"
      },
    ),
  )
  children.push(@html.span(class="asset-tree-label", label))
  children.push(@html.span(class="asset-tree-badge", badge))
  @html.div(
    class=if selected {
      "asset-tree-row file selected"
    } else {
      "asset-tree-row file"
    },
    on_click=dispatch(@app.msg_select_resource(Some(selection))),
    attrs=asset_tree_file_attrs(
      dispatch, selection, full_path, draggable_asset_path, sticky_chain, sticky_section,
    ),
    children,
  )
}

///|
fn asset_tree_file_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  selection : @app.ResourceSelection,
  full_path : String,
  draggable_asset_path : String?,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @html.Attrs {
  let attrs = @html.Attrs::build()
    .data_set("sticky-chain", sticky_chain.join("/"))
    .data_set("sticky-section", sticky_section)
    .data_set("sticky-kind", "file")
    .handler("mouseenter", fn(_event, scheduler) {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_set_hover_hint(Some(full_path))),
      )
    })
    .handler("mouseleave", fn(_event, scheduler) {
      schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
    })
    .handler("dblclick", fn(_event, scheduler) {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_select_resource(Some(selection))),
      )
      schedule_cmd(scheduler, dispatch(@app.msg_insert_selected_resource()))
    })
  match draggable_asset_path {
    Some(asset_path) =>
      attrs
      .draggable("true")
      .handler("dragstart", fn(event, _scheduler) {
        begin_dragged_asset(asset_path)
        match event.to_drag_event() {
          Some(drag_event) =>
            drag_event_set_asset_payload(drag_event, asset_path)
          None => ()
        }
      })
      .handler("dragend", fn(event, _scheduler) {
        ignore(event)
        clear_dragged_asset()
      })
    None => attrs
  }
}

///|
fn build_asset_tree_rows(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  paths : Array[String],
  section_key : String,
  force_expand : Bool,
  drop_root : String?,
  selection_of : (String) -> @app.ResourceSelection,
  badge_of : (String) -> String,
  draggable_path_of : (String) -> String?,
) -> Array[@rabbita.Html] {
  let rows : Array[@rabbita.Html] = []
  let section_title = asset_tree_section_title(section_key)
  let sorted_paths : Array[String] = []
  sorted_paths.push_iter(paths.iter())
  sorted_paths.sort_by(fn(left, right) { left.compare(right) })
  let mut previous_folders : Array[String] = []
  for path in sorted_paths {
    let segments = tree_path_segments(path, drop_root)
    if segments.is_empty() {
      continue
    }
    let file_index = segments.length() - 1
    let folders = if file_index > 0 {
      segments[:file_index].to_array()
    } else {
      []
    }
    let shared = common_prefix_len(previous_folders, folders)
    for index = shared; index < folders.length(); index = index + 1 {
      if !folder_ancestors_expanded(
          model, section_key, folders, force_expand, index,
        ) {
        break
      }
      let key = folder_chain_key(section_key, folders, index)
      let expanded = if force_expand {
        true
      } else {
        model.asset_tree_folder_expanded(key)
      }
      let folder_path = match drop_root {
        Some(root) => root + "/" + folders[:index + 1].join("/")
        None => folders[:index + 1].join("/")
      }
      rows.push(
        tree_folder_row(
          dispatch,
          index,
          folders[index],
          folder_path,
          expanded,
          !force_expand,
          key,
          folders[:index + 1].to_array(),
          section_title,
        ),
      )
    }
    if !folder_ancestors_expanded(
        model,
        section_key,
        folders,
        force_expand,
        folders.length(),
      ) {
      previous_folders = folders
      continue
    }
    let selection = selection_of(path)
    rows.push(
      tree_file_row(
        dispatch,
        model.selected_resource == Some(selection),
        selection,
        path,
        file_index,
        segments[file_index],
        badge_of(path),
        draggable_path_of(path),
        folders,
        section_title,
      ),
    )
    previous_folders = folders
  }
  rows
}

///|
fn asset_section(
  dispatch : @rabbita.Dispatch[@app.Msg],
  title : String,
  count : Int,
  expanded : Bool,
  toggle_msg : @app.Msg,
  items : Array[@rabbita.Html],
) -> @rabbita.Html {
  @html.div(class="asset-section", [
    @html.button(class="asset-section-toggle", on_click=dispatch(toggle_msg), [
      @html.span(
        class="asset-section-caret",
        if expanded {
          "▾"
        } else {
          "▸"
        },
      ),
      @html.span(class="asset-section-title", title),
      @html.span(class="asset-section-count", count.to_string()),
    ]),
    if expanded && !items.is_empty() {
      @html.div(class="asset-list", items)
    } else {
      @html.nothing
    },
  ])
}

///|
fn asset_panel_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let has_asset_filter = model.asset_query_normalized() != ""
  let force_expand_tree = model.asset_query_normalized() != ""
  let force_expand_sections = force_expand_tree
  let image_paths : Array[String] = []
  let image_badges : Map[String, String] = {}
  for asset in model.image_assets() {
    let title = asset_display_name(asset)
    if !model.asset_matches_query(title, asset.path) {
      continue
    }
    let size_label = match model.asset_size(asset.path) {
      Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
      None => "image"
    }
    image_paths.push(asset.path)
    image_badges.set(asset.path, size_label)
  }
  let image_rows = build_asset_tree_rows(
    dispatch,
    model,
    image_paths,
    "images",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_image(path) },
    fn(path) { image_badges.get(path).unwrap_or("image") },
    fn(path) { Some(path) },
  )

  let atlas_paths : Array[String] = []
  for atlas_ref in model.atlas_refs {
    let atlas_name = match model.atlas_documents.get(atlas_ref.path) {
      Some(atlas) => atlas.name
      None => asset_display_name_from_path(atlas_ref.path)
    }
    if !model.asset_matches_query(atlas_name, atlas_ref.path) {
      continue
    }
    atlas_paths.push(atlas_ref.path)
  }
  let atlas_rows = build_asset_tree_rows(
    dispatch,
    model,
    atlas_paths,
    "atlases",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_atlas(path) },
    fn(_path) { "atlas" },
    fn(_path) { None },
  )

  let animation_clip_paths : Array[String] = []
  for animation_ref in model.animation_clip_refs {
    let animation_name = match
      model.animation_clip_documents.get(animation_ref.path) {
      Some(animation) => animation.name
      None => asset_display_name_from_path(animation_ref.path)
    }
    if !model.asset_matches_query(animation_name, animation_ref.path) {
      continue
    }
    animation_clip_paths.push(animation_ref.path)
  }
  let animation_clip_rows = build_asset_tree_rows(
    dispatch,
    model,
    animation_clip_paths,
    "animation-clips",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_animation_clip(path) },
    fn(_path) { "clip" },
    fn(_path) { None },
  )

  let animation_graph_paths : Array[String] = []
  for animation_ref in model.animation_graph_refs {
    let animation_name = match
      model.animation_graph_documents.get(animation_ref.path) {
      Some(animation) => animation.name
      None => asset_display_name_from_path(animation_ref.path)
    }
    if !model.asset_matches_query(animation_name, animation_ref.path) {
      continue
    }
    animation_graph_paths.push(animation_ref.path)
  }
  let animation_graph_rows = build_asset_tree_rows(
    dispatch,
    model,
    animation_graph_paths,
    "animation-graphs",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_animation_graph(path) },
    fn(_path) { "graph" },
    fn(_path) { None },
  )

  let prefab_paths : Array[String] = []
  for prefab_ref in model.prefab_refs {
    let prefab_name = match model.prefab_documents.get(prefab_ref.path) {
      Some(prefab) => prefab.name
      None => asset_display_name_from_path(prefab_ref.path)
    }
    if !model.asset_matches_query(prefab_name, prefab_ref.path) {
      continue
    }
    prefab_paths.push(prefab_ref.path)
  }
  let prefab_rows = build_asset_tree_rows(
    dispatch,
    model,
    prefab_paths,
    "prefabs",
    force_expand_tree,
    Some("prefabs"),
    fn(path) { @app.resource_selection_prefab(path) },
    fn(_path) { "prefab" },
    fn(_path) { None },
  )
  let toolbar = @html.div(class="asset-toolbar", [
    @html.input(
      class="field-input asset-search-input",
      value=model.asset_query,
      placeholder="Filter Assets",
      on_input=fn(value) { dispatch(@app.msg_set_asset_query(value)) },
      @html.nothing,
    ),
  ])
  let content : Array[@rabbita.Html] = []
  if !image_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Images",
        image_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.images_section_expanded
        },
        @app.msg_toggle_images_section(),
        image_rows,
      ),
    )
  }
  if !atlas_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Atlases",
        atlas_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.atlases_section_expanded
        },
        @app.msg_toggle_atlases_section(),
        atlas_rows,
      ),
    )
  }
  if !animation_clip_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Animation Clips",
        animation_clip_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.animation_clips_section_expanded
        },
        @app.msg_toggle_animation_clips_section(),
        animation_clip_rows,
      ),
    )
  }
  if !animation_graph_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Animation Graphs",
        animation_graph_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.animation_graphs_section_expanded
        },
        @app.msg_toggle_animation_graphs_section(),
        animation_graph_rows,
      ),
    )
  }
  if !prefab_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Prefabs",
        prefab_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.prefabs_section_expanded
        },
        @app.msg_toggle_prefabs_section(),
        prefab_rows,
      ),
    )
  }
  if image_rows.is_empty() &&
    atlas_rows.is_empty() &&
    animation_clip_rows.is_empty() &&
    animation_graph_rows.is_empty() &&
    prefab_rows.is_empty() {
    content.push(
      @html.div(
        class="empty",
        if has_asset_filter {
          [
            @html.span("No assets match this filter"),
            @html.button(
              class="small-button",
              attrs=hint_attrs(dispatch, "Clear asset search filter"),
              on_click=dispatch(@app.msg_set_asset_query("")),
              "Reset Filter",
            ),
          ]
        } else {
          [@html.span("No assets found")]
        },
      ),
    )
  }
  @html.div(class="panel-body asset-panel-body", [
    toolbar,
    @html.div(class="asset-tree-scroll", [
      @html.div(class="asset-tree-sticky-overlay empty", @html.nothing),
      @html.div(class="asset-grid", content),
    ]),
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
        class=if is_selected {
          "tree-item scene-browser-item selected"
        } else {
          "tree-item scene-browser-item"
        },
        on_click=dispatch(@app.msg_open_scene(scene_ref.path)),
        [
          @html.span(class="scene-browser-path", scene_ref.path),
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
    @html.div(class="scene-browser-head", [
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
          attrs=hint_attrs(dispatch, "Create Scene"),
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
          attrs=hint_attrs(dispatch, "Rename Current Scene"),
          on_click=@cmd.raw_effect(fn(scheduler) {
            let current_name = match model.scene {
              Some(scene) => scene.name
              None => "scene"
            }
            let name = prompt_text("Scene name", current_name)
            if name.trim() != "" {
              schedule_cmd(
                scheduler,
                dispatch(@app.msg_rename_current_scene(name)),
              )
            }
          }),
          "✎",
        ),
        @html.button(
          class="small-button",
          attrs=hint_attrs(dispatch, "Delete Current Scene"),
          on_click=dispatch(@app.msg_delete_current_scene()),
          "−",
        ),
        @html.button(
          class="small-button",
          attrs=hint_attrs(dispatch, "Set Current As Startup"),
          on_click=dispatch(@app.msg_set_current_scene_as_startup()),
          "★",
        ),
      ]),
    ]),
    if items.is_empty() {
      @html.div(class="empty", "No scenes in this project")
    } else {
      @html.div(class="scene-browser-list", [
        @html.div(
          class="scene-browser-list-header",
          "All Scenes (\{items.length()})",
        ),
        @html.div(class="scene-browser-list-body", items),
      ])
    },
  ])
}

///|
fn viewport_drop_attrs(dispatch : @rabbita.Dispatch[@app.Msg]) -> @html.Attrs {
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
      Some(asset_path) =>
        match event.to_drag_event() {
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
fn labeled_input_with_commit(
  label : String,
  value : String,
  on_change : (String) -> @rabbita.Cmd,
  on_commit : () -> @rabbita.Cmd,
) -> @rabbita.Html {
  let attrs = @html.Attrs::build()
    .handler("change", fn(_event, scheduler) {
      schedule_cmd(scheduler, on_commit())
    })
    .handler("keydown", fn(event, scheduler) {
      if input_event_is_enter_key(event) {
        input_event_blur_target(event)
        schedule_cmd(scheduler, on_commit())
      }
    })
  @html.label(class="field", [
    @html.span(class="field-label", label),
    @html.input(
      value~,
      class="field-input",
      on_input=on_change,
      attrs~,
      @html.nothing,
    ),
  ])
}

///|
fn transform_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  transform : @editor_bridge.Transform2dComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "X",
      transform.translation.x.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_translate_x(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Y",
      transform.translation.y.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_translate_y(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Rotation",
      transform.rotation.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_rotation(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn text_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  text_component : @editor_bridge.Text2dComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Content",
      text_component.content,
      fn(value) { dispatch(@app.msg_update_selected_text(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn sprite_component_body(
  sprite_component : @editor_bridge.SpriteComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
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
}

///|
fn visibility_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  visibility_component : @editor_bridge.VisibilityComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
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
}

///|
fn animation_player_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  player : @editor_bridge.AnimationPlayerComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Graph Asset Path",
      player.graph_asset_path.unwrap_or(""),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_graph_path(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Start Node",
      player.start_node.unwrap_or(""),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_start_node(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Repeat Mode",
      player.repeat_mode,
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_repeat_mode(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Speed",
      player.speed.to_string(),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_speed(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    @html.button(
      class="small-button",
      on_click=dispatch(@app.msg_toggle_selected_animation_player_autoplay()),
      if player.autoplay {
        "Autoplay: Enabled"
      } else {
        "Autoplay: Disabled"
      },
    ),
  ])
}

///|
fn animation_transitions_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  transitions : @editor_bridge.AnimationTransitionsComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Duration",
      transitions.duration.to_string(),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_transitions_duration(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn animation_graph_node_kind_label(
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> String {
  match kind {
    @editor_bridge.Clip(..) => "Clip"
    @editor_bridge.Blend => "Blend"
    @editor_bridge.AdditiveBlend => "AdditiveBlend"
  }
}

///|
fn animation_graph_node_clip_path(
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> String? {
  match kind {
    @editor_bridge.Clip(clip_asset_path~) => Some(clip_asset_path)
    _ => None
  }
}

///|
fn animation_graph_node_edges_label(
  node : @editor_bridge.AnimationGraphNodeDocument,
) -> String {
  let labels : Array[String] = []
  for edge in node.edges {
    labels.push(edge.to + " (\{edge.weight.to_string()})")
  }
  labels.join(", ")
}

///|
fn animation_graph_node_card(
  dispatch : @rabbita.Dispatch[@app.Msg],
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node : @editor_bridge.AnimationGraphNodeDocument,
) -> @rabbita.Html {
  let is_default = graph.default_node == Some(node.id)
  @html.div(class="component-card", [
    @html.div(class="component-card-header", [
      @html.span(
        class="component-card-title",
        node.id + " • " + animation_graph_node_kind_label(node.kind),
      ),
      @html.button(
        class="component-card-menu-toggle",
        on_click=dispatch(
          @app.msg_remove_selected_animation_graph_node(node.id),
        ),
        "✕",
      ),
    ]),
    @html.div(class="component-card-body", [
      @html.div(class="inspector-block", [
        @html.div(class="kv", [
          @html.span(class="kv-key", "Position"),
          @html.span(
            class="kv-value",
            "\{node.position.x.to_string()}, \{node.position.y.to_string()}",
          ),
        ]),
        @html.div(class="kv", [
          @html.span(class="kv-key", "Edges"),
          @html.span(class="kv-value", node.edges.length().to_string()),
        ]),
        if node.edges.is_empty() {
          @html.nothing
        } else {
          @html.div(class="kv", [
            @html.span(class="kv-key", "Targets"),
            @html.span(class="kv-value", animation_graph_node_edges_label(node)),
          ])
        },
        match animation_graph_node_clip_path(node.kind) {
          Some(clip_path) =>
            labeled_input("Clip Asset Path", clip_path, fn(value) {
              dispatch(
                @app.msg_update_selected_animation_graph_node_clip_path(
                  node.id,
                  value,
                ),
              )
            })
          None => @html.nothing
        },
        @html.div(class="inspector-actions", [
          @html.button(
            class=if is_default {
              "small-button disabled"
            } else {
              "small-button"
            },
            on_click=if is_default {
              @cmd.none
            } else {
              dispatch(
                @app.msg_update_selected_animation_graph_default_node(node.id),
              )
            },
            if is_default {
              "Default Node"
            } else {
              "Set Default Node"
            },
          ),
        ]),
      ]),
    ]),
  ])
}

///|
fn custom_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let draft = model.custom_component_json_draft(
    entity.id,
    component.kind,
    component.data,
  )
  let error = model.custom_component_json_error(entity.id, component.kind)
  @html.div(class="inspector-block", [
    @html.div(class="kv", [
      @html.span(class="kv-key", "Kind"),
      @html.span(class="kv-value", component.kind),
    ]),
    @html.textarea(
      class="field-input custom-json-editor",
      value=draft,
      placeholder="{\"hp\": 10}",
      on_input=fn(value) {
        dispatch(@app.msg_update_custom_component_json(component.kind, value))
      },
      @html.nothing,
    ),
    match error {
      Some(message) => @html.div(class="component-error", message)
      None => @html.nothing
    },
    @html.div(class="inspector-actions", [
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_commit_custom_component_json(component.kind)),
        "Apply JSON",
      ),
    ]),
  ])
}

///|
fn component_body_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  match component.kind {
    "Transform2d" => {
      let transform : @editor_bridge.Transform2dComponent? = @app.component_of(
        entity, "Transform2d",
      )
      match transform {
        Some(transform) => transform_component_body(dispatch, transform)
        None => @html.div(class="component-error", "Invalid Transform2d data")
      }
    }
    "Visibility" => {
      let visibility_component : @editor_bridge.VisibilityComponent? = @app.component_of(
        entity, "Visibility",
      )
      match visibility_component {
        Some(visibility_component) =>
          visibility_component_body(dispatch, visibility_component)
        None => @html.div(class="component-error", "Invalid Visibility data")
      }
    }
    "Sprite" => {
      let sprite_component : @editor_bridge.SpriteComponent? = @app.component_of(
        entity, "Sprite",
      )
      match sprite_component {
        Some(sprite_component) => sprite_component_body(sprite_component)
        None => @html.div(class="component-error", "Invalid Sprite data")
      }
    }
    "Text2d" => {
      let text_component : @editor_bridge.Text2dComponent? = @app.component_of(
        entity, "Text2d",
      )
      match text_component {
        Some(text_component) => text_component_body(dispatch, text_component)
        None => @html.div(class="component-error", "Invalid Text2d data")
      }
    }
    "AnimationPlayer" => {
      let player : @editor_bridge.AnimationPlayerComponent? = @app.component_of(
        entity, "AnimationPlayer",
      )
      match player {
        Some(player) => animation_player_component_body(dispatch, player)
        None =>
          @html.div(class="component-error", "Invalid AnimationPlayer data")
      }
    }
    "AnimationTransitions" => {
      let transitions : @editor_bridge.AnimationTransitionsComponent? = @app.component_of(
        entity, "AnimationTransitions",
      )
      match transitions {
        Some(transitions) =>
          animation_transitions_component_body(dispatch, transitions)
        None =>
          @html.div(
            class="component-error",
            "Invalid AnimationTransitions data",
          )
      }
    }
    _ =>
      match @editor_bridge.builtin_component_kind_from_string(component.kind) {
        Some(_) =>
          @html.div(class="kv-value", component.data.stringify(indent=2))
        None => custom_component_body(dispatch, model, entity, component)
      }
  }
}

///|
fn remove_component_menu_item(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let reason = model.selected_component_remove_block_reason(component.kind)
  @html.button(
    class=if reason is Some(_) {
      "small-button component-menu-item disabled"
    } else {
      "small-button component-menu-item"
    },
    on_click=if reason is Some(_) {
      @cmd.none
    } else {
      dispatch(@app.msg_remove_component(component.kind))
    },
    attrs=if reason is Some(reason) {
      hint_attrs(dispatch, reason)
    } else {
      hint_attrs(dispatch, "Remove Component")
    },
    "Remove Component",
  )
}

///|
fn component_card(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let collapsed = model.component_card_collapsed(entity.id, component.kind)
  let menu_open = model.component_menu_is_open(component.kind)
  @html.div(class="component-card", [
    @html.div(class="component-card-header", [
      @html.button(
        class="component-card-toggle",
        on_click=dispatch(@app.msg_toggle_component_collapsed(component.kind)),
        if collapsed {
          "▸"
        } else {
          "▾"
        },
      ),
      @html.span(class="component-card-title", component.kind),
      @html.button(
        class="component-card-menu-toggle",
        on_click=dispatch(@app.msg_toggle_component_menu(Some(component.kind))),
        "⋮",
      ),
    ]),
    if menu_open {
      @html.div(class="component-card-menu", [
        remove_component_menu_item(dispatch, model, component),
      ])
    } else {
      @html.nothing
    },
    if collapsed {
      @html.nothing
    } else {
      @html.div(class="component-card-body", [
        component_body_view(dispatch, model, entity, component),
      ])
    },
  ])
}

///|
fn add_component_group(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  entity : @editor_bridge.EntityDocument,
  title : String,
  kinds : Array[@editor_bridge.BuiltinComponentKind],
) -> @rabbita.Html {
  let buttons : Array[@rabbita.Html] = []
  for kind in kinds {
    if @editor_bridge.builtin_component_category(kind) != title {
      continue
    }
    if !model.builtin_component_matches_query(kind) {
      continue
    }
    let kind_name = @editor_bridge.builtin_component_kind_to_string(kind)
    let exists = entity.component(kind_name) is Some(_)
    buttons.push(
      @html.button(
        class=if exists {
          "small-button component-add-item existing disabled"
        } else {
          "small-button component-add-item"
        },
        attrs=if exists {
          hint_attrs(dispatch, kind_name + " is already on this entity")
        } else {
          hint_attrs(dispatch, "Add " + kind_name + " component")
        },
        on_click=if exists {
          @cmd.none
        } else {
          dispatch(@app.msg_add_builtin_component(kind))
        },
        if exists {
          kind_name + " (Existing)"
        } else {
          kind_name
        },
      ),
    )
  }
  if buttons.is_empty() {
    @html.nothing
  } else {
    @html.div(class="component-add-group", [
      @html.div(class="component-add-group-title", title),
      @html.div(class="component-add-list", buttons),
    ])
  }
}

///|
fn matching_builtin_component_count(model : @app.Model) -> Int {
  let matched : Array[@editor_bridge.BuiltinComponentKind] = []
  for kind in @editor_bridge.builtin_component_kinds() {
    if model.builtin_component_matches_query(kind) {
      matched.push(kind)
    }
  }
  matched.length()
}

///|
fn close_add_component_panel_on_escape_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @html.Attrs {
  @html.Attrs::build().handler("keydown", fn(event, scheduler) {
    if input_event_is_escape_key(event) {
      event.prevent_default()
      input_event_blur_target(event)
      schedule_cmd(scheduler, dispatch(@app.msg_close_add_component_panel()))
    }
  })
}

///|
fn custom_component_kind_input_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  value : String,
) -> @html.Attrs {
  @html.Attrs::build().handler("keydown", fn(event, scheduler) {
    if input_event_is_escape_key(event) {
      event.prevent_default()
      input_event_blur_target(event)
      schedule_cmd(scheduler, dispatch(@app.msg_close_add_component_panel()))
      return
    }
    if input_event_is_enter_key(event) {
      event.prevent_default()
      schedule_cmd(scheduler, dispatch(@app.msg_add_custom_component(value)))
    }
  })
}

///|
fn add_component_panel(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
  entity : @editor_bridge.EntityDocument,
) -> @rabbita.Html {
  let matches_count = matching_builtin_component_count(model)
  let has_query = model.component_search_query_normalized() != ""
  let groups = [
    add_component_group(
      dispatch,
      model,
      entity,
      "Common",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Rendering",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Physics2D",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Animation",
      @editor_bridge.builtin_component_kinds(),
    ),
  ]
  @html.div(class="component-add-panel", [
    @html.div(class="component-add-header", [
      @html.span(class="component-add-title", "Add Component"),
      @html.button(
        class="small-button component-add-close",
        on_click=dispatch(@app.msg_close_add_component_panel()),
        "×",
      ),
    ]),
    @html.input(
      class="field-input component-search-input",
      value=model.component_search_query,
      placeholder="Search components...",
      on_input=fn(value) {
        dispatch(@app.msg_set_component_search_query(value))
      },
      attrs=close_add_component_panel_on_escape_attrs(dispatch),
      @html.nothing,
    ),
    @html.div(
      class="component-add-search-meta",
      if has_query {
        "\{matches_count} matching built-in components"
      } else {
        "Browse by category or type to filter"
      },
    ),
    if has_query && matches_count == 0 {
      @html.div(
        class="component-add-empty",
        "No built-in components match this search",
      )
    } else {
      @html.nothing
    },
    @html.div(class="component-add-groups", groups),
    @html.div(class="component-add-group custom", [
      @html.div(class="component-add-group-title", "Custom"),
      @html.input(
        class="field-input",
        value=model.add_custom_component_kind,
        placeholder="Custom component kind",
        on_input=fn(value) {
          dispatch(@app.msg_update_add_custom_component_kind(value))
        },
        attrs=custom_component_kind_input_attrs(
          dispatch,
          model.add_custom_component_kind,
        ),
        @html.nothing,
      ),
      @html.button(
        class="small-button component-add-item",
        on_click=dispatch(
          @app.msg_add_custom_component(model.add_custom_component_kind),
        ),
        "New Custom JSON Component",
      ),
    ]),
  ])
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
              if model.failed_image_assets.get(path).unwrap_or(false) {
                @html.div(
                  class="resource-preview-empty",
                  "Image preview unavailable",
                )
              } else {
                @html.div(class="resource-preview-frame", [
                  @html.img(
                    class="resource-preview-image",
                    src=project_asset_src(path),
                    alt=asset_display_name(asset),
                    attrs=image_preview_attrs(dispatch, path),
                    @html.nothing,
                  ),
                ])
              },
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
                  },
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
              labeled_input("Tile Width", atlas.tile_size.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_tile_width(value))
              }),
              labeled_input("Tile Height", atlas.tile_size.y.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_tile_height(value))
              }),
              labeled_input("Columns", atlas.columns.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_columns(value))
              }),
              labeled_input("Rows", atlas.rows.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_rows(value))
              }),
              labeled_input("Spacing X", atlas.spacing.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_spacing_x(value))
              }),
              labeled_input("Spacing Y", atlas.spacing.y.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_spacing_y(value))
              }),
              labeled_input("Margin X", atlas.margin.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_x(value))
              }),
              labeled_input("Margin Y", atlas.margin.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_y(value))
              }),
              labeled_input("Anchor X", atlas.default_anchor.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_anchor_x(value))
              }),
              labeled_input("Anchor Y", atlas.default_anchor.y.to_string(), fn(
                value,
              ) {
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
                  on_click=dispatch(
                    @app.msg_create_animation_from_selected_atlas(),
                  ),
                  "Create Animation",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Atlas is still loading")
      }
    Some(@app.AnimationClip(_)) =>
      match model.selected_animation_clip_document() {
        Some((path, clip)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Animation Clip"),
              labeled_input("Name", clip.name, fn(value) {
                dispatch(
                  @app.msg_update_selected_animation_clip_asset_name(value),
                )
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Atlas"),
                @html.span(class="kv-value", clip.atlas_asset_path),
              ]),
              labeled_input("FPS", clip.fps.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_animation_clip_fps(value))
              }),
              @html.label(class="field", [
                @html.span(class="field-label", "Looping"),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_toggle_selected_animation_clip_looping(),
                  ),
                  if clip.looping {
                    "Enabled"
                  } else {
                    "Disabled"
                  },
                ),
              ]),
              labeled_input("Frames", clip.frames.join(", "), fn(value) {
                dispatch(@app.msg_update_selected_animation_clip_frames(value))
              }),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_animation_clip()),
                  "Save Clip",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Clip Sprite",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Animation clip is still loading")
      }
    Some(@app.AnimationGraph(_)) =>
      match model.selected_animation_graph_document() {
        Some((path, graph)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Animation Graph"),
              labeled_input("Name", graph.name, fn(value) {
                dispatch(
                  @app.msg_update_selected_animation_graph_asset_name(value),
                )
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              labeled_input("Default Node", graph.default_node.unwrap_or(""), fn(
                value,
              ) {
                dispatch(
                  @app.msg_update_selected_animation_graph_default_node(value),
                )
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Node Count"),
                @html.span(class="kv-value", graph.nodes.length().to_string()),
              ]),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_clip_node(),
                  ),
                  "Add Clip Node",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_blend_node(),
                  ),
                  "Add Blend Node",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_additive_blend_node(),
                  ),
                  "Add Additive Node",
                ),
              ]),
              if graph.nodes.is_empty() {
                @html.div(class="empty", "No nodes yet")
              } else {
                @html.div(
                  class="component-card-list",
                  graph.nodes.map(fn(node) {
                    animation_graph_node_card(dispatch, graph, node)
                  }),
                )
              },
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_animation_graph()),
                  "Save Graph",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Animated Sprite",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Animation graph is still loading")
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
                @html.span(
                  class="kv-value",
                  prefab.entities.length().to_string(),
                ),
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
    attrs=hint_attrs(dispatch, label),
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn action_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  label : String,
  icon : String,
  msg : @app.Msg,
  enabled? : Bool = true,
  primary? : Bool = false,
) -> @rabbita.Html {
  let class = if primary {
    if enabled {
      "small-button icon-button primary-button"
    } else {
      "small-button icon-button primary-button disabled"
    }
  } else if enabled {
    "small-button icon-button"
  } else {
    "small-button icon-button disabled"
  }
  @html.button(
    class~,
    on_click=if enabled { dispatch(msg) } else { @cmd.none },
    attrs=if enabled {
      hint_attrs(dispatch, label)
    } else {
      @html.Attrs::build()
    },
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn info_message(model : @app.Model) -> String {
  let move_snap = if model.move_snap_enabled {
    "on (" + model.move_snap_step.to_string() + ")"
  } else {
    "off"
  }
  model.hover_hint.unwrap_or(
    "Tool: " +
    @app.tool_label(model.active_tool) +
    " | Move snap: " +
    move_snap +
    " | " +
    model.status,
  )
}

///|
fn entry_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  @html.div(class="editor-root entry-root", [
    @html.div(class="welcome", [
      @html.div(class="welcome-logo", [
        @html.div(class="welcome-logo-mark", "S"),
        @html.div(class="welcome-logo-text", [
          @html.h1(class="welcome-title", "Selene Editor"),
          @html.p(
            class="welcome-tagline",
            "Build Selene-native 2D scenes, atlases, animations, and prefabs",
          ),
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
fn scene_migration_dialog_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  preview : @editor_bridge.SceneMigrationPreview,
) -> @rabbita.Html {
  let items = preview.changes.map(fn(change) {
    @html.li(class="migration-change-item", [
      @html.div(class="migration-change-path", change.path),
      @html.div(class="migration-change-reason", change.reason),
      @html.div(class="migration-change-value", "Use: " + change.migrated_value),
    ])
  })
  @html.div(class="modal-backdrop", [
    @html.div(class="modal-card", [
      @html.h2(class="modal-title", "Legacy Scene Detected"),
      @html.p(
        class="modal-copy",
        "This scene uses an older Selene Editor schema. Review the planned migration before loading it.",
      ),
      @html.div(class="migration-summary", [
        @html.div(class="migration-label", "File"),
        @html.div(class="migration-value", preview.path),
      ]),
      @html.ul(class="migration-change-list", items),
      @html.div(class="modal-actions", [
        @html.button(
          class="small-button",
          on_click=dispatch(@app.msg_cancel_scene_migration()),
          "Cancel",
        ),
        @html.button(
          class="small-button primary-button",
          on_click=dispatch(@app.msg_confirm_scene_migration()),
          "Migrate and Load",
        ),
      ]),
    ]),
  ])
}

///|
fn view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  if model.current_root is None {
    return entry_view(dispatch, model)
  }
  let scene_tree = match model.scene {
    Some(scene) => tree_view(dispatch, scene, None, model.selected_entity_id, 0)
    None => [@html.div(class="empty", "No scene loaded")]
  }
  let inspector = match model.selected_entity() {
    Some(entity) => {
      let component_cards = entity.components.map(fn(component) {
        component_card(dispatch, model, entity, component)
      })
      @html.div(class="panel-body", [
        labeled_input_with_commit(
          "Name",
          entity.name,
          fn(value) { dispatch(@app.msg_rename_selected(value)) },
          fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
        ),
        @html.div(class="inspector-actions", [
          @html.button(
            class="small-button",
            on_click=dispatch(@app.msg_save_selected_as_prefab()),
            "Save As Prefab",
          ),
          @html.button(
            class="small-button",
            on_click=dispatch(@app.msg_open_add_component_panel()),
            "Add Component (C)",
          ),
        ]),
        if model.add_component_panel_open {
          add_component_panel(dispatch, model, entity)
        } else {
          @html.nothing
        },
        @html.div(class="component-stack", component_cards),
      ])
    }
    None => selected_asset_view(dispatch, model)
  }
  let body = @html.div(class="editor-root", [
    @html.div(class="topbar", [
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Project"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Open Project",
            "O",
            @app.msg_open_project(),
            enabled=true,
            primary=true,
          ),
          action_button(
            dispatch,
            "Save Scene (Cmd/Ctrl+S)",
            "S",
            @app.msg_save_scene(),
            enabled=model.scene is Some(_),
          ),
        ]),
      ]),
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Scene"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Undo (Cmd/Ctrl+Z)",
            "U",
            @app.msg_undo_scene(),
            enabled=model.can_undo(),
          ),
          action_button(
            dispatch,
            "Redo (Shift+Cmd/Ctrl+Z)",
            "R",
            @app.msg_redo_scene(),
            enabled=model.can_redo(),
          ),
          action_button(
            dispatch,
            "Add Sprite",
            "+",
            @app.msg_add_sprite_entity(),
            enabled=model.scene is Some(_),
          ),
          action_button(
            dispatch,
            "Add Text",
            "T",
            @app.msg_add_text_entity(),
            enabled=model.scene is Some(_),
          ),
          action_button(
            dispatch,
            "Delete Selected (Delete)",
            "⌫",
            @app.msg_delete_selected(),
            enabled=model.selected_entity_id is Some(_),
          ),
          action_button(
            dispatch,
            "Frame Selection (F)",
            "⛶",
            @app.msg_frame_selection(),
            enabled=model.selected_entity_id is Some(_),
          ),
        ]),
      ]),
      @html.div(class="topbar-section topbar-tools", [
        @html.div(class="topbar-section-label", "Tools"),
        @html.div(class="topbar-group", [
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_select(),
            "Select (V)",
            "↖",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_drag_canvas(),
            "Drag Canvas (H)",
            "H",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_translate(),
            "Move (W, hold Shift for temporary snap)",
            "✥",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_rotate(),
            "Rotate (E, Hold Shift for 15° snap)",
            "⟳",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_scale(),
            "Scale (R)",
            "⬚",
          ),
        ]),
      ]),
      @html.div(class="topbar-section topbar-options", [
        @html.div(class="topbar-section-label", "Options"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            if model.move_snap_enabled {
              "Disable Move Snap"
            } else {
              "Enable Move Snap"
            },
            "⌗",
            @app.msg_toggle_move_snap(),
            enabled=true,
            primary=model.move_snap_enabled,
          ),
          action_button(
            dispatch,
            "Decrease Move Snap Step (-)",
            "−",
            @app.msg_adjust_move_snap_step(-1),
            enabled=true,
          ),
          @html.span(
            class="topbar-option-readout",
            "Step \{model.move_snap_step.to_string()}",
          ),
          action_button(
            dispatch,
            "Increase Move Snap Step (+)",
            "+",
            @app.msg_adjust_move_snap_step(1),
            enabled=true,
          ),
        ]),
      ]),
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
    @html.div(class="info-bar", info_message(model)),
  ])
  match model.pending_scene_migration {
    Some(preview) =>
      @html.div(class="editor-shell", [
        body,
        scene_migration_dialog_view(dispatch, preview),
      ])
    None => body
  }
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
