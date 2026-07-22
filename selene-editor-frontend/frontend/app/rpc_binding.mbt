///|
pub suberror RpcBindingError {
  UnexpectedRpcResponse(String)
}

///|
pub enum RpcBinding {
  RpcProjectCurrent
  RpcProjectOpen(String)
  RpcProjectPickDirectory(String)
  RpcProjectSaveWorkspace(@editor_bridge.WorkspaceDocument)
  RpcProjectSetStartupScene(String)
  RpcSceneLoad(String)
  RpcSceneMigrate(String)
  RpcSceneList
  RpcSceneCreate(String)
  RpcSceneSave(String, @editor_bridge.SceneDocument, String, Int)
  RpcSceneDelete(String)
  RpcAssetsList
  RpcPrefabLoad(String)
  RpcPrefabSave(String, @editor_bridge.PrefabDocument)
  RpcAtlasLoad(String)
  RpcAtlasSave(String, @editor_bridge.AtlasAssetDocument)
  RpcAnimationClipLoad(String)
  RpcAnimationClipSave(String, @editor_bridge.AnimationClipAssetDocument)
  RpcAnimationGraphLoad(String)
  RpcAnimationGraphSave(String, @editor_bridge.AnimationGraphAssetDocument)
  RpcAnimationMigrate(String, String)
} derive(Eq)

///|
pub fn RpcBinding::scope(self : RpcBinding) -> String {
  match self {
    RpcProjectCurrent => "project.current"
    RpcProjectOpen(_) => "project.open"
    RpcProjectPickDirectory(_) => "project.pick_directory"
    RpcProjectSaveWorkspace(_) => "project.save_workspace"
    RpcProjectSetStartupScene(_) => "project.set_startup_scene"
    RpcSceneLoad(_) => "scene.load"
    RpcSceneMigrate(_) => "scene.migrate"
    RpcSceneList => "scene.list"
    RpcSceneCreate(_) => "scene.create"
    RpcSceneSave(_, _, _, _) => "scene.save"
    RpcSceneDelete(_) => "scene.delete"
    RpcAssetsList => "assets.list"
    RpcPrefabLoad(_) => "prefab.load"
    RpcPrefabSave(_, _) => "prefab.save"
    RpcAtlasLoad(_) => "atlas.load"
    RpcAtlasSave(_, _) => "atlas.save"
    RpcAnimationClipLoad(_) => "animation.clip.load"
    RpcAnimationClipSave(_, _) => "animation.clip.save"
    RpcAnimationGraphLoad(_) => "animation.graph.load"
    RpcAnimationGraphSave(_, _) => "animation.graph.save"
    RpcAnimationMigrate(_, _) => "animation.migrate"
  }
}

///|
fn RpcBinding::request(self : RpcBinding) -> @shared.RpcRequest {
  match self {
    RpcProjectCurrent => @shared.rpc_request_project_current()
    RpcProjectOpen(root) => @shared.rpc_request_project_open(root)
    RpcProjectPickDirectory(prompt) =>
      @shared.rpc_request_project_pick_directory(prompt)
    RpcProjectSaveWorkspace(workspace) =>
      @shared.rpc_request_project_save_workspace(workspace)
    RpcProjectSetStartupScene(path) =>
      @shared.rpc_request_project_set_startup_scene(path)
    RpcSceneLoad(path) => @shared.rpc_request_scene_load(path)
    RpcSceneMigrate(path) => @shared.rpc_request_scene_migrate(path)
    RpcSceneList => @shared.rpc_request_scene_list()
    RpcSceneCreate(name) => @shared.rpc_request_scene_create(name)
    RpcSceneSave(path, scene, base_hash, base_revision) =>
      @shared.rpc_request_scene_save(path, scene, base_hash, base_revision)
    RpcSceneDelete(path) => @shared.rpc_request_scene_delete(path)
    RpcAssetsList => @shared.rpc_request_assets_list()
    RpcPrefabLoad(path) => @shared.rpc_request_prefab_load(path)
    RpcPrefabSave(path, prefab) => @shared.rpc_request_prefab_save(path, prefab)
    RpcAtlasLoad(path) => @shared.rpc_request_atlas_load(path)
    RpcAtlasSave(path, atlas) => @shared.rpc_request_atlas_save(path, atlas)
    RpcAnimationClipLoad(path) => @shared.rpc_request_animation_clip_load(path)
    RpcAnimationClipSave(path, clip) =>
      @shared.rpc_request_animation_clip_save(path, clip)
    RpcAnimationGraphLoad(path) =>
      @shared.rpc_request_animation_graph_load(path)
    RpcAnimationGraphSave(path, graph) =>
      @shared.rpc_request_animation_graph_save(path, graph)
    RpcAnimationMigrate(path, scene_path) =>
      @shared.rpc_request_animation_migrate(path, scene_path)
  }
}

///|
pub fn RpcBinding::request_envelope(
  self : RpcBinding,
  id? : Int = 1,
) -> @shared.RpcRequestEnvelope {
  @shared.rpc_request_envelope(id, self.request())
}

///|
pub fn RpcBinding::transport_error_msg(
  self : RpcBinding,
  message : String,
) -> Msg {
  match self {
    RpcProjectCurrent | RpcProjectOpen(_) =>
      msg_project_loaded(AsyncErr(message))
    RpcProjectPickDirectory(_) => msg_project_root_picked(AsyncErr(message))
    RpcSceneLoad(_) | RpcSceneMigrate(_) | RpcSceneCreate(_) =>
      msg_scene_loaded(AsyncErr(message))
    RpcSceneList => msg_scene_list_loaded(AsyncErr(message))
    RpcAssetsList => msg_assets_loaded(AsyncErr(message))
    RpcPrefabLoad(_) => msg_prefab_loaded(AsyncErr(message))
    RpcAtlasLoad(_) => msg_atlas_loaded(AsyncErr(message))
    RpcAnimationClipLoad(_) => msg_animation_clip_loaded(AsyncErr(message))
    RpcAnimationGraphLoad(_) => msg_animation_graph_loaded(AsyncErr(message))
    RpcSceneSave(_, _, _, _) => msg_scene_saved(AsyncErr(message))
    RpcAnimationMigrate(_, _) =>
      msg_animation_migration_saved(AsyncErr(message))
    RpcProjectSaveWorkspace(_) => msg_workspace_saved(AsyncErr(message))
    RpcProjectSetStartupScene(_) => msg_rpc_ack(AsyncErr(message))
    RpcSceneDelete(_)
    | RpcPrefabSave(_, _)
    | RpcAtlasSave(_, _)
    | RpcAnimationClipSave(_, _)
    | RpcAnimationGraphSave(_, _) => msg_rpc_ack(AsyncErr(message))
  }
}

///|
pub fn RpcBinding::response_to_msg(
  self : RpcBinding,
  response : @shared.RpcResponse,
) -> Msg raise RpcBindingError {
  match self {
    RpcProjectCurrent | RpcProjectOpen(_) =>
      match response {
        ProjectState(state~) => msg_project_loaded(AsyncOk(state))
        Error(error~) => msg_project_loaded(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for project state",
          )
      }
    RpcProjectPickDirectory(_) =>
      match response {
        DirectoryPicked(result~) => msg_project_root_picked(AsyncOk(result))
        Error(error~) => msg_project_root_picked(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for project root picker",
          )
      }
    RpcSceneLoad(_) | RpcSceneMigrate(_) | RpcSceneCreate(_) =>
      match response {
        SceneLoaded(scene~) =>
          msg_scene_loaded(AsyncOk(@shared.scene_load_outcome_loaded(scene)))
        SceneMigrationRequired(preview~) =>
          msg_scene_loaded(
            AsyncOk(@shared.scene_load_outcome_migration_required(preview)),
          )
        Error(error~) => msg_scene_loaded(AsyncErr(error.message))
        _ => raise UnexpectedRpcResponse("Unexpected RPC response for scene")
      }
    RpcSceneList =>
      match response {
        SceneListed(list~) => msg_scene_list_loaded(AsyncOk(list))
        Error(error~) => msg_scene_list_loaded(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse("Unexpected RPC response for scene list")
      }
    RpcProjectSetStartupScene(_) =>
      match response {
        StartupSceneUpdated(_) => msg_rpc_ack(AsyncOk(()))
        Error(error~) => msg_rpc_ack(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for startup scene update",
          )
      }
    RpcAssetsList =>
      match response {
        AssetsListed(list~) => msg_assets_loaded(AsyncOk(list))
        Error(error~) => msg_assets_loaded(AsyncErr(error.message))
        _ => raise UnexpectedRpcResponse("Unexpected RPC response for assets")
      }
    RpcPrefabLoad(_) =>
      match response {
        PrefabLoaded(prefab~) => msg_prefab_loaded(AsyncOk(prefab))
        Error(error~) => msg_prefab_loaded(AsyncErr(error.message))
        _ => raise UnexpectedRpcResponse("Unexpected RPC response for prefab")
      }
    RpcAtlasLoad(_) =>
      match response {
        AtlasLoaded(atlas~) => msg_atlas_loaded(AsyncOk(atlas))
        Error(error~) => msg_atlas_loaded(AsyncErr(error.message))
        _ => raise UnexpectedRpcResponse("Unexpected RPC response for atlas")
      }
    RpcAnimationClipLoad(_) =>
      match response {
        AnimationClipLoaded(clip~) => msg_animation_clip_loaded(AsyncOk(clip))
        Error(error~) => msg_animation_clip_loaded(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for animation clip",
          )
      }
    RpcAnimationGraphLoad(_) =>
      match response {
        AnimationGraphLoaded(graph~) =>
          msg_animation_graph_loaded(AsyncOk(graph))
        Error(error~) => msg_animation_graph_loaded(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for animation graph",
          )
      }
    RpcSceneSave(_, _, _, _) =>
      match response {
        SceneSaved(save~) =>
          msg_scene_saved(AsyncOk(scene_save_outcome_saved(save)))
        Conflict(conflict~) =>
          msg_scene_saved(AsyncOk(scene_save_outcome_conflict(conflict)))
        Error(error~) => msg_scene_saved(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse("Unexpected RPC response for scene save")
      }
    RpcAnimationMigrate(_, _) =>
      match response {
        SavedOk => msg_animation_migration_saved(AsyncOk(()))
        Error(error~) => msg_animation_migration_saved(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for animation migrate",
          )
      }
    RpcProjectSaveWorkspace(_) =>
      match response {
        SavedOk => msg_workspace_saved(AsyncOk(()))
        Error(error~) => msg_workspace_saved(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for workspace save",
          )
      }
    RpcSceneDelete(_)
    | RpcPrefabSave(_, _)
    | RpcAtlasSave(_, _)
    | RpcAnimationClipSave(_, _)
    | RpcAnimationGraphSave(_, _) =>
      match response {
        SavedOk => msg_rpc_ack(AsyncOk(()))
        Error(error~) => msg_rpc_ack(AsyncErr(error.message))
        _ =>
          raise UnexpectedRpcResponse(
            "Unexpected RPC response for save acknowledgement",
          )
      }
  }
}
