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
fn current_scene_path(model : @app.ViewState) -> String {
  match model.scene_session {
    Some(session) => session.path
    None =>
      if model.scene_refs.is_empty() {
        "scenes/main.scene.json"
      } else {
        model.scene_refs[0].path
      }
  }
}

///|
fn current_scene(model : @app.ViewState) -> @editor_bridge.SceneDocument? {
  model.scene_session.map(fn(session) { session.scene })
}

///|
fn rpc_scope(target : @app.RpcTarget) -> String {
  match target {
    @app.ProjectLoaded => "project.open"
    @app.ProjectRootPicked => "project.pick_directory"
    @app.SceneLoaded => "scene.load"
    @app.SceneListLoaded => "scene.list"
    @app.AssetsLoaded => "assets.list"
    @app.PrefabLoaded => "prefab.load"
    @app.AtlasLoaded => "atlas.load"
    @app.AnimationClipLoaded => "animation.clip.load"
    @app.AnimationGraphLoaded => "animation.graph.load"
    @app.SceneSaved => "scene.save"
    @app.AnimationMigrationSaved => "animation.migrate"
    @app.WorkspaceSaved => "project.save_workspace"
  }
}

///|
fn rpc_transport_error_msg(
  target : @app.RpcTarget,
  message : String,
) -> @app.Msg {
  match target {
    @app.ProjectLoaded => @app.msg_project_loaded(Err(message))
    @app.ProjectRootPicked => @app.msg_project_root_picked(Err(message))
    @app.SceneLoaded => @app.msg_scene_loaded(Err(message))
    @app.SceneListLoaded => @app.msg_scene_list_loaded(Err(message))
    @app.AssetsLoaded => @app.msg_assets_loaded(Err(message))
    @app.PrefabLoaded => @app.msg_prefab_loaded(Err(message))
    @app.AtlasLoaded => @app.msg_atlas_loaded(Err(message))
    @app.AnimationClipLoaded => @app.msg_animation_clip_loaded(Err(message))
    @app.AnimationGraphLoaded => @app.msg_animation_graph_loaded(Err(message))
    @app.SceneSaved => @app.msg_scene_saved(Err(message))
    @app.AnimationMigrationSaved =>
      @app.msg_animation_migration_saved(Err(message))
    @app.WorkspaceSaved => @app.msg_workspace_saved(Err(message))
  }
}

///|
fn rpc_msg_from_response(
  target : @app.RpcTarget,
  response : @shared.RpcResponse,
) -> Result[@app.Msg, String] {
  match target {
    @app.ProjectRootPicked =>
      match response {
        @shared.DirectoryPicked(result~) =>
          Ok(@app.msg_project_root_picked(Ok(result)))
        @shared.Error(error~) =>
          Ok(@app.msg_project_root_picked(Err(error.message)))
        _ => Err("Unexpected RPC response for project root picker")
      }
    @app.ProjectLoaded =>
      match response {
        @shared.ProjectState(state~) => Ok(@app.msg_project_loaded(Ok(state)))
        @shared.Error(error~) => Ok(@app.msg_project_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for project state")
      }
    @app.SceneLoaded =>
      match response {
        @shared.SceneLoaded(scene~) =>
          Ok(
            @app.msg_scene_loaded(Ok(@shared.scene_load_outcome_loaded(scene))),
          )
        @shared.Error(error~) => Ok(@app.msg_scene_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for scene")
      }
    @app.SceneListLoaded =>
      match response {
        @shared.SceneListed(list~) => Ok(@app.msg_scene_list_loaded(Ok(list)))
        @shared.Error(error~) =>
          Ok(@app.msg_scene_list_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for scene list")
      }
    @app.AssetsLoaded =>
      match response {
        @shared.AssetsListed(list~) => Ok(@app.msg_assets_loaded(Ok(list)))
        @shared.Error(error~) => Ok(@app.msg_assets_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for assets")
      }
    @app.PrefabLoaded =>
      match response {
        @shared.PrefabLoaded(prefab~) => Ok(@app.msg_prefab_loaded(Ok(prefab)))
        @shared.Error(error~) => Ok(@app.msg_prefab_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for prefab")
      }
    @app.AtlasLoaded =>
      match response {
        @shared.AtlasLoaded(atlas~) => Ok(@app.msg_atlas_loaded(Ok(atlas)))
        @shared.Error(error~) => Ok(@app.msg_atlas_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for atlas")
      }
    @app.AnimationClipLoaded =>
      match response {
        @shared.AnimationClipLoaded(clip~) =>
          Ok(@app.msg_animation_clip_loaded(Ok(clip)))
        @shared.Error(error~) =>
          Ok(@app.msg_animation_clip_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for animation clip")
      }
    @app.AnimationGraphLoaded =>
      match response {
        @shared.AnimationGraphLoaded(graph~) =>
          Ok(@app.msg_animation_graph_loaded(Ok(graph)))
        @shared.Error(error~) =>
          Ok(@app.msg_animation_graph_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for animation graph")
      }
    @app.SceneSaved =>
      match response {
        @shared.SceneSaved(save~) =>
          Ok(@app.msg_scene_saved(Ok(@app.scene_save_outcome_saved(save))))
        @shared.Conflict(conflict~) =>
          Ok(
            @app.msg_scene_saved(Ok(@app.scene_save_outcome_conflict(conflict))),
          )
        @shared.Error(error~) => Ok(@app.msg_scene_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for scene save")
      }
    @app.AnimationMigrationSaved =>
      match response {
        @shared.SavedOk | @shared.StartupSceneUpdated(_) =>
          Ok(@app.msg_animation_migration_saved(Ok(())))
        @shared.Error(error~) =>
          Ok(@app.msg_animation_migration_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for save")
      }
    @app.WorkspaceSaved =>
      match response {
        @shared.SavedOk | @shared.StartupSceneUpdated(_) =>
          Ok(@app.msg_workspace_saved(Ok(())))
        @shared.Error(error~) =>
          Ok(@app.msg_workspace_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for save")
      }
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
