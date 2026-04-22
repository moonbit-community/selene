///|
fn EditorService::resolve_scene_path_for_rpc(
  self : EditorService,
  path : String,
) -> String raise {
  let manifest = self.current_manifest()
  if path == "" {
    manifest.startup_scene
  } else {
    path
  }
}

///|
async fn EditorService::handle_scene_rpc(
  self : EditorService,
  request : @shared.RpcRequest,
) -> @shared.RpcResponse? {
  match request {
    @shared.SceneLoad(path~) => {
      let relative_path = self.resolve_scene_path_for_rpc(path)
      let root = self.current_project_root()
      Some(
        match load_scene_document(root, relative_path) {
          @editor_bridge.Ready(_) =>
            @shared.rpc_response_scene_loaded(
              load_scene_bundle(root, relative_path),
            )
          @editor_bridge.MigrationRequired(preview) =>
            @shared.rpc_response_scene_migration_required(preview)
        },
      )
    }
    @shared.SceneMigrate(path~) => {
      let relative_path = self.resolve_scene_path_for_rpc(path)
      let root = self.current_project_root()
      ignore(migrate_scene_document(root, relative_path))
      self.broadcast(
        @shared.event_envelope(@shared.editor_event_scene_saved(relative_path)),
      )
      Some(
        @shared.rpc_response_scene_loaded(
          load_scene_bundle(root, relative_path),
        ),
      )
    }
    @shared.SceneList => {
      let root = self.current_project_root()
      Some(
        @shared.rpc_response_scene_listed(
          @shared.scene_list_response(
            list_scene_documents(root),
            self.current_manifest().startup_scene,
          ),
        ),
      )
    }
    @shared.SceneCreate(name~) => {
      let path = "scenes/" + @editor_bridge.scene_file_name(name)
      let root = self.current_project_root()
      let scene = @editor_bridge.SceneDocument::empty(name~)
      let disk = save_scene_document(root, path, scene)
      self.broadcast(
        @shared.event_envelope(@shared.editor_event_scene_created(path)),
      )
      Some(
        @shared.rpc_response_scene_loaded(
          @shared.scene_bundle_response(
            path,
            scene,
            disk_hash=disk.hash,
            disk_revision=disk.revision,
          ),
        ),
      )
    }
    @shared.SceneSave(path~, scene~, base_hash~, base_revision~) => {
      let root = self.current_project_root()
      let current = scene_disk_state(root, path)
      if current.hash != base_hash || current.revision != base_revision {
        Some(
          @shared.rpc_response_conflict(
            @shared.rpc_conflict_document(
              path,
              base_hash,
              current.hash,
              base_revision,
              current.revision,
            ),
          ),
        )
      } else {
        let disk = save_scene_document(root, path, scene)
        self.broadcast(
          @shared.event_envelope(
            @shared.editor_event_project_delta(
              @shared.project_delta_scene_file_changed(
                path,
                disk.hash,
                disk.revision,
              ),
            ),
          ),
        )
        Some(
          @shared.rpc_response_scene_saved(
            @shared.scene_save_result(path, disk.hash, disk.revision),
          ),
        )
      }
    }
    @shared.SceneDelete(path~) => {
      let root = self.current_project_root()
      let absolute_path = scene_path(root, path)
      if @fs.exists(absolute_path) {
        @fs.remove(absolute_path)
      }
      self.broadcast(
        @shared.event_envelope(@shared.editor_event_scene_deleted(path)),
      )
      Some(@shared.rpc_response_saved_ok())
    }
    _ => None
  }
}
