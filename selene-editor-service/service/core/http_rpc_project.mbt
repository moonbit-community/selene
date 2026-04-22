///|
async fn EditorService::project_state_response_for_open_project(
  self : EditorService,
  project : ProjectSession,
) -> @shared.ProjectStateResponse {
  @shared.project_state_response(
    Some(project.root),
    Some(project.manifest),
    list_scene_documents(project.root),
    list_prefab_documents(project.root),
    list_atlas_asset_documents(project.root),
    list_animation_clip_asset_documents(project.root),
    list_animation_graph_asset_documents(project.root),
    Some(load_workspace_document(project.root)),
    self.recent_projects,
  )
}

///|
fn EditorService::project_state_response_when_empty(
  self : EditorService,
) -> @shared.ProjectStateResponse {
  let empty_scenes : Array[@editor_bridge.SceneRef] = []
  let empty_prefabs : Array[@editor_bridge.PrefabRef] = []
  let empty_assets : Array[@editor_bridge.AssetRef] = []
  @shared.project_state_response(
    None,
    None,
    empty_scenes,
    empty_prefabs,
    empty_assets,
    empty_assets,
    empty_assets,
    None,
    self.recent_projects,
  )
}

///|
async fn EditorService::project_open_response(
  self : EditorService,
  request : @shared.RpcRequest,
  root : String,
) -> @shared.RpcResponse {
  let validated_root = require_project_root(root) catch {
    err =>
      return @shared.rpc_error_response(
          0,
          "invalid_request",
          request_error_message(err),
          details=request.to_json(),
        ).response
  }
  @shared.rpc_response_project_state(self.open_project(validated_root))
}

///|
async fn EditorService::handle_project_rpc(
  self : EditorService,
  request : @shared.RpcRequest,
) -> @shared.RpcResponse? {
  match request {
    @shared.ProjectCurrent =>
      Some(
        match self.current_project {
          Some(project) =>
            @shared.rpc_response_project_state(
              self.project_state_response_for_open_project(project),
            )
          None =>
            @shared.rpc_response_project_state(
              self.project_state_response_when_empty(),
            )
        },
      )
    @shared.ProjectOpen(root~) =>
      Some(self.project_open_response(request, root))
    @shared.ProjectPickDirectory(prompt~) =>
      Some(
        @shared.rpc_response_directory_picked(
          @shared.directory_pick_result(pick_directory_dialog(prompt)),
        ),
      )
    @shared.ProjectSaveWorkspace(workspace~) => {
      let root = self.current_project_root()
      save_workspace_document(root, workspace)
      Some(@shared.rpc_response_saved_ok())
    }
    @shared.ProjectSetStartupScene(path~) => {
      let root = self.current_project_root()
      let manifest = self.current_manifest()
      let next_manifest = manifest.with_startup_scene(path)
      save_project_manifest(root, next_manifest)
      if self.current_project is Some(project) {
        project.manifest = next_manifest
      }
      Some(@shared.rpc_response_startup_scene_updated(next_manifest))
    }
    _ => None
  }
}
