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
    RpcProjectCurrent | RpcProjectOpen(_) => msg_project_loaded(Err(message))
    RpcProjectPickDirectory(_) => msg_project_root_picked(Err(message))
    RpcSceneLoad(_) | RpcSceneMigrate(_) | RpcSceneCreate(_) =>
      msg_scene_loaded(Err(message))
    RpcSceneList => msg_scene_list_loaded(Err(message))
    RpcAssetsList => msg_assets_loaded(Err(message))
    RpcPrefabLoad(_) => msg_prefab_loaded(Err(message))
    RpcAtlasLoad(_) => msg_atlas_loaded(Err(message))
    RpcAnimationClipLoad(_) => msg_animation_clip_loaded(Err(message))
    RpcAnimationGraphLoad(_) => msg_animation_graph_loaded(Err(message))
    RpcSceneSave(_, _, _, _) => msg_scene_saved(Err(message))
    RpcAnimationMigrate(_, _) => msg_animation_migration_saved(Err(message))
    RpcProjectSaveWorkspace(_) => msg_workspace_saved(Err(message))
    RpcProjectSetStartupScene(_) => msg_rpc_ack(Err(message))
    RpcSceneDelete(_)
    | RpcPrefabSave(_, _)
    | RpcAtlasSave(_, _)
    | RpcAnimationClipSave(_, _)
    | RpcAnimationGraphSave(_, _) => msg_rpc_ack(Err(message))
  }
}

///|
pub fn RpcBinding::response_to_msg(
  self : RpcBinding,
  response : @shared.RpcResponse,
) -> Result[Msg, String] {
  match self {
    RpcProjectCurrent | RpcProjectOpen(_) =>
      match response {
        @shared.ProjectState(state~) => Ok(msg_project_loaded(Ok(state)))
        @shared.Error(error~) => Ok(msg_project_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for project state")
      }
    RpcProjectPickDirectory(_) =>
      match response {
        @shared.DirectoryPicked(result~) =>
          Ok(msg_project_root_picked(Ok(result)))
        @shared.Error(error~) => Ok(msg_project_root_picked(Err(error.message)))
        _ => Err("Unexpected RPC response for project root picker")
      }
    RpcSceneLoad(_) | RpcSceneMigrate(_) | RpcSceneCreate(_) =>
      match response {
        @shared.SceneLoaded(scene~) =>
          Ok(msg_scene_loaded(Ok(@shared.scene_load_outcome_loaded(scene))))
        @shared.SceneMigrationRequired(preview~) =>
          Ok(
            msg_scene_loaded(
              Ok(@shared.scene_load_outcome_migration_required(preview)),
            ),
          )
        @shared.Error(error~) => Ok(msg_scene_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for scene")
      }
    RpcSceneList =>
      match response {
        @shared.SceneListed(list~) => Ok(msg_scene_list_loaded(Ok(list)))
        @shared.Error(error~) => Ok(msg_scene_list_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for scene list")
      }
    RpcProjectSetStartupScene(_) =>
      match response {
        @shared.StartupSceneUpdated(_) => Ok(msg_rpc_ack(Ok(())))
        @shared.Error(error~) => Ok(msg_rpc_ack(Err(error.message)))
        _ => Err("Unexpected RPC response for startup scene update")
      }
    RpcAssetsList =>
      match response {
        @shared.AssetsListed(list~) => Ok(msg_assets_loaded(Ok(list)))
        @shared.Error(error~) => Ok(msg_assets_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for assets")
      }
    RpcPrefabLoad(_) =>
      match response {
        @shared.PrefabLoaded(prefab~) => Ok(msg_prefab_loaded(Ok(prefab)))
        @shared.Error(error~) => Ok(msg_prefab_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for prefab")
      }
    RpcAtlasLoad(_) =>
      match response {
        @shared.AtlasLoaded(atlas~) => Ok(msg_atlas_loaded(Ok(atlas)))
        @shared.Error(error~) => Ok(msg_atlas_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for atlas")
      }
    RpcAnimationClipLoad(_) =>
      match response {
        @shared.AnimationClipLoaded(clip~) =>
          Ok(msg_animation_clip_loaded(Ok(clip)))
        @shared.Error(error~) =>
          Ok(msg_animation_clip_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for animation clip")
      }
    RpcAnimationGraphLoad(_) =>
      match response {
        @shared.AnimationGraphLoaded(graph~) =>
          Ok(msg_animation_graph_loaded(Ok(graph)))
        @shared.Error(error~) =>
          Ok(msg_animation_graph_loaded(Err(error.message)))
        _ => Err("Unexpected RPC response for animation graph")
      }
    RpcSceneSave(_, _, _, _) =>
      match response {
        @shared.SceneSaved(save~) =>
          Ok(msg_scene_saved(Ok(scene_save_outcome_saved(save))))
        @shared.Conflict(conflict~) =>
          Ok(msg_scene_saved(Ok(scene_save_outcome_conflict(conflict))))
        @shared.Error(error~) => Ok(msg_scene_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for scene save")
      }
    RpcAnimationMigrate(_, _) =>
      match response {
        @shared.SavedOk => Ok(msg_animation_migration_saved(Ok(())))
        @shared.Error(error~) =>
          Ok(msg_animation_migration_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for animation migrate")
      }
    RpcProjectSaveWorkspace(_) =>
      match response {
        @shared.SavedOk => Ok(msg_workspace_saved(Ok(())))
        @shared.Error(error~) => Ok(msg_workspace_saved(Err(error.message)))
        _ => Err("Unexpected RPC response for workspace save")
      }
    RpcSceneDelete(_)
    | RpcPrefabSave(_, _)
    | RpcAtlasSave(_, _)
    | RpcAnimationClipSave(_, _)
    | RpcAnimationGraphSave(_, _) =>
      match response {
        @shared.SavedOk => Ok(msg_rpc_ack(Ok(())))
        @shared.Error(error~) => Ok(msg_rpc_ack(Err(error.message)))
        _ => Err("Unexpected RPC response for save acknowledgement")
      }
  }
}
