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
pub async fn EditorService::handle_rpc(
  self : EditorService,
  envelope : @shared.RpcRequestEnvelope,
) -> Json {
  let id = envelope.id
  try {
    let response = match envelope.request {
      @shared.ProjectCurrent =>
        match self.current_project {
          Some(project) =>
            @shared.rpc_response_project_state(
              self.project_state_response_for_open_project(project),
            )
          None =>
            @shared.rpc_response_project_state(
              self.project_state_response_when_empty(),
            )
        }
      @shared.ProjectOpen(root~) => {
        let root = require_project_root(root) catch {
          err =>
            return @shared.rpc_error_response(
              id,
              "invalid_request",
              request_error_message(err),
              details=envelope.request.to_json(),
            ).to_json()
        }
        @shared.rpc_response_project_state(self.open_project(root))
      }
      @shared.ProjectPickDirectory(prompt~) => {
        let path = pick_directory_dialog(prompt)
        @shared.rpc_response_directory_picked(
          @shared.directory_pick_result(path),
        )
      }
      @shared.ProjectSaveWorkspace(workspace~) => {
        let root = self.current_project_root()
        save_workspace_document(root, workspace)
        @shared.rpc_response_saved_ok()
      }
      @shared.SceneLoad(path~) => {
        let relative_path = self.resolve_scene_path_for_rpc(path)
        let root = self.current_project_root()
        match load_scene_document(root, relative_path) {
          @editor_bridge.Ready(_) =>
            @shared.rpc_response_scene_loaded(
              load_scene_bundle(root, relative_path),
            )
          @editor_bridge.MigrationRequired(preview) =>
            @shared.rpc_response_scene_migration_required(preview)
        }
      }
      @shared.SceneMigrate(path~) => {
        let relative_path = self.resolve_scene_path_for_rpc(path)
        let root = self.current_project_root()
        ignore(migrate_scene_document(root, relative_path))
        self.broadcast(
          @shared.event_envelope(
            @shared.editor_event_scene_saved(relative_path),
          ),
        )
        @shared.rpc_response_scene_loaded(
          load_scene_bundle(root, relative_path),
        )
      }
      @shared.SceneList => {
        let root = self.current_project_root()
        @shared.rpc_response_scene_listed(
          @shared.scene_list_response(
            list_scene_documents(root),
            self.current_manifest().startup_scene,
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
        @shared.rpc_response_scene_loaded(
          @shared.scene_bundle_response(
            path,
            scene,
            disk_hash=disk.hash,
            disk_revision=disk.revision,
          ),
        )
      }
      @shared.SceneSave(path~, scene~, base_hash~, base_revision~) => {
        let root = self.current_project_root()
        let current = scene_disk_state(root, path)
        if current.hash != base_hash || current.revision != base_revision {
          @shared.rpc_response_conflict(
            @shared.rpc_conflict_document(
              path,
              base_hash,
              current.hash,
              base_revision,
              current.revision,
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
          @shared.rpc_response_scene_saved(
            @shared.scene_save_result(path, disk.hash, disk.revision),
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
        @shared.rpc_response_saved_ok()
      }
      @shared.ProjectSetStartupScene(path~) => {
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let next_manifest = manifest.with_startup_scene(path)
        save_project_manifest(root, next_manifest)
        if self.current_project is Some(project) {
          project.manifest = next_manifest
        }
        @shared.rpc_response_startup_scene_updated(next_manifest)
      }
      @shared.AssetsList => {
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let assets = collect_assets(root, manifest)
        @shared.rpc_response_assets_listed(@shared.assets_list_response(assets))
      }
      @shared.PrefabLoad(path~) => {
        let root = self.current_project_root()
        let prefab = load_prefab_document(root, path)
        @shared.rpc_response_prefab_loaded(
          @shared.prefab_load_response(path, prefab),
        )
      }
      @shared.PrefabSave(path~, prefab~) => {
        let root = self.current_project_root()
        save_prefab_document(root, path, prefab)
        @shared.rpc_response_saved_ok()
      }
      @shared.AtlasLoad(path~) => {
        let root = self.current_project_root()
        let atlas = load_atlas_asset_document(root, path)
        @shared.rpc_response_atlas_loaded(
          @shared.atlas_load_response(path, atlas),
        )
      }
      @shared.AtlasSave(path~, atlas~) => {
        let root = self.current_project_root()
        save_atlas_asset_document(root, path, atlas)
        @shared.rpc_response_saved_ok()
      }
      @shared.AnimationClipLoad(path~) => {
        let root = self.current_project_root()
        let clip = load_animation_clip_asset_document(root, path)
        @shared.rpc_response_animation_clip_loaded(
          @shared.animation_clip_load_response(path, clip),
        )
      }
      @shared.AnimationClipSave(path~, clip~) => {
        let root = self.current_project_root()
        save_animation_clip_asset_document(root, path, clip)
        self.broadcast(
          @shared.event_envelope(
            @shared.editor_event_animation_clip_saved(path),
          ),
        )
        @shared.rpc_response_saved_ok()
      }
      @shared.AnimationGraphLoad(path~) => {
        let root = self.current_project_root()
        let graph = load_animation_graph_asset_document(root, path)
        @shared.rpc_response_animation_graph_loaded(
          @shared.animation_graph_load_response(path, graph),
        )
      }
      @shared.AnimationGraphSave(path~, graph~) => {
        let root = self.current_project_root()
        save_animation_graph_asset_document(root, path, graph)
        self.broadcast(
          @shared.event_envelope(
            @shared.editor_event_animation_graph_saved(path),
          ),
        )
        @shared.rpc_response_saved_ok()
      }
      @shared.AnimationMigrate(path~, scene_path~) => {
        let root = self.current_project_root()
        migrate_legacy_animation_document(root, path, scene_path)
        self.broadcast(
          @shared.event_envelope(
            @shared.editor_event_animation_migrated(scene_path, path),
          ),
        )
        @shared.rpc_response_saved_ok()
      }
    }
    @shared.rpc_response_envelope(id, response).to_json()
  } catch {
    err =>
      @shared.rpc_error_response(
        id,
        "internal_error",
        request_error_message(err),
        details=envelope.request.to_json(),
      ).to_json()
  }
}
