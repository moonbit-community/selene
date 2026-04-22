///|
async fn EditorService::handle_animation_rpc(
  self : EditorService,
  request : @shared.RpcRequest,
) -> @shared.RpcResponse? {
  match request {
    @shared.AnimationClipLoad(path~) => {
      let root = self.current_project_root()
      let clip = load_animation_clip_asset_document(root, path)
      Some(
        @shared.rpc_response_animation_clip_loaded(
          @shared.animation_clip_load_response(path, clip),
        ),
      )
    }
    @shared.AnimationClipSave(path~, clip~) => {
      let root = self.current_project_root()
      save_animation_clip_asset_document(root, path, clip)
      self.broadcast(
        @shared.event_envelope(@shared.editor_event_animation_clip_saved(path)),
      )
      Some(@shared.rpc_response_saved_ok())
    }
    @shared.AnimationGraphLoad(path~) => {
      let root = self.current_project_root()
      let graph = load_animation_graph_asset_document(root, path)
      Some(
        @shared.rpc_response_animation_graph_loaded(
          @shared.animation_graph_load_response(path, graph),
        ),
      )
    }
    @shared.AnimationGraphSave(path~, graph~) => {
      let root = self.current_project_root()
      save_animation_graph_asset_document(root, path, graph)
      self.broadcast(
        @shared.event_envelope(@shared.editor_event_animation_graph_saved(path)),
      )
      Some(@shared.rpc_response_saved_ok())
    }
    @shared.AnimationMigrate(path~, scene_path~) => {
      let root = self.current_project_root()
      migrate_legacy_animation_document(root, path, scene_path)
      self.broadcast(
        @shared.event_envelope(
          @shared.editor_event_animation_migrated(scene_path, path),
        ),
      )
      Some(@shared.rpc_response_saved_ok())
    }
    _ => None
  }
}
