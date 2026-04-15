///|
pub let default_host = "127.0.0.1"

///|
pub let default_port = 47142

///|
fn content_type_for(path : String) -> String {
  match extension_of(path) {
    Some("html") => "text/html; charset=utf-8"
    Some("css") => "text/css; charset=utf-8"
    Some("js") => "text/javascript; charset=utf-8"
    Some("json") => "application/json; charset=utf-8"
    Some("png") => "image/png"
    Some("jpg") | Some("jpeg") => "image/jpeg"
    Some("webp") => "image/webp"
    Some("svg") => "image/svg+xml"
    Some("ttf") => "font/ttf"
    Some("otf") => "font/otf"
    Some("wav") => "audio/wav"
    Some("ogg") => "audio/ogg"
    Some("mp3") => "audio/mpeg"
    _ => "application/octet-stream"
  }
}

///|
async fn send_json(
  conn : @http.ServerConnection,
  payload : Json,
  code? : Int = 200,
  reason? : String = "OK",
) -> Unit {
  conn
  ..send_response(code, reason, extra_headers={
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-cache",
  })
  ..write(payload.stringify())
  .end_response()
}

///|
async fn send_text(
  conn : @http.ServerConnection,
  text : String,
  content_type? : String = "text/plain; charset=utf-8",
  code? : Int = 200,
  reason? : String = "OK",
) -> Unit {
  conn
  ..send_response(code, reason, extra_headers={ "Content-Type": content_type })
  ..write(text)
  .end_response()
}

///|
async fn send_file(
  conn : @http.ServerConnection,
  path : String,
  cache_control? : String = "no-cache",
) -> Unit {
  let file = @fs.open(path, mode=ReadOnly)
  defer file.close()
  conn
  ..send_response(200, "OK", extra_headers={
    "Content-Type": content_type_for(path),
    "Cache-Control": cache_control,
  })
  ..write_reader(file)
  .end_response()
}

///|
async fn EditorService::handle_static_request(
  self : EditorService,
  request : @http.Request,
  conn : @http.ServerConnection,
) -> Bool {
  match request.path {
    "/" => {
      send_file(conn, self.public_path("index.html"), cache_control="no-store") catch {
        err =>
          send_text(
            conn,
            err.to_string(),
            code=500,
            reason="Internal Server Error",
          )
      }
      true
    }
    "/editor.css" => {
      send_file(conn, self.public_path("editor.css"), cache_control="no-store") catch {
        err =>
          send_text(
            conn,
            err.to_string(),
            code=500,
            reason="Internal Server Error",
          )
      }
      true
    }
    "/editor.js" => {
      send_file(conn, self.editor_script_path(), cache_control="no-store") catch {
        err =>
          send_text(
            conn,
            err.to_string(),
            code=500,
            reason="Internal Server Error",
          )
      }
      true
    }
    _ if request.path.has_prefix("/project/") => {
      let root = self.current_project_root() catch {
        _ => {
          send_text(conn, "No project is open", code=404, reason="Not Found")
          return true
        }
      }
      let rel_path = normalize_relative_path(request.path[9:].to_string()) catch {
        err => {
          send_text(conn, err.to_string(), code=400, reason="Bad Request")
          return true
        }
      }
      let file_path = path_join(root, rel_path)
      if !@fs.exists(file_path) {
        send_text(conn, "Not found", code=404, reason="Not Found")
        return true
      }
      send_file(conn, file_path) catch {
        err =>
          send_text(
            conn,
            err.to_string(),
            code=500,
            reason="Internal Server Error",
          )
      }
      true
    }
    _ => false
  }
}

///|
async fn EditorService::open_project(
  self : EditorService,
  root : String,
) -> @shared.ProjectStateResponse {
  let loaded_manifest = load_project_manifest(root) catch {
    MissingProjectManifest(_) => {
      ensure_project_layout(root)
      let created = @editor_bridge.ProjectManifest::default(
        inferred_project_name(root),
      )
      ignore(
        save_scene_document(
          root,
          created.startup_scene,
          @editor_bridge.SceneDocument::default_main(),
        ),
      )
      save_project_manifest(root, created)
      created
    }
    err => raise err
  }
  let scenes = list_scene_documents(root)
  let prefabs = list_prefab_documents(root)
  let atlases = list_atlas_asset_documents(root)
  let animation_clips = list_animation_clip_asset_documents(root)
  let animation_graphs = list_animation_graph_asset_documents(root)
  let manifest = loaded_manifest.with_indexes(
    scenes, prefabs, atlases, animation_clips, animation_graphs,
  )
  if manifest != loaded_manifest {
    save_project_manifest(root, manifest)
  }
  let snapshot = snapshot_project_files(root, manifest)
  let workspace = load_workspace_document(root)
  self.current_project = Some({ root, manifest, snapshot })
  self.add_recent_project(root)
  self.broadcast(
    @shared.event_envelope(@shared.editor_event_project_opened(root, manifest)),
  )
  @shared.project_state_response(
    Some(root),
    Some(manifest),
    scenes,
    prefabs,
    atlases,
    animation_clips,
    animation_graphs,
    Some(workspace),
    self.recent_projects,
  )
}

///|
fn require_project_root(root : String) -> String raise {
  let normalized = root.trim().to_string()
  if normalized == "" {
    raise Failure("Project root is required")
  }
  normalized
}

///|
fn request_error_message(err : Error) -> String {
  match err {
    Failure(message) => message
    InvalidEditorPath(path) => "Invalid editor path: " + path
    MissingProjectManifest(path) => "Missing project manifest: " + path
    SceneNotFound(path) => "Scene not found: " + path
    PrefabNotFound(path) => "Prefab not found: " + path
    AtlasNotFound(path) => "Atlas not found: " + path
    AnimationNotFound(path) => "Animation not found: " + path
    ProjectNotOpen => "No project is open"
    _ => err.to_string()
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
          Some(project) => {
            let state = @shared.project_state_response(
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
            @shared.rpc_response_project_state(state)
          }
          None => {
            let empty_scenes : Array[@editor_bridge.SceneRef] = []
            let empty_prefabs : Array[@editor_bridge.PrefabRef] = []
            let empty_assets : Array[@editor_bridge.AssetRef] = []
            @shared.rpc_response_project_state(
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
              ),
            )
          }
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
        let manifest = self.current_manifest()
        let relative_path = if path == "" {
          manifest.startup_scene
        } else {
          path
        }
        let root = self.current_project_root()
        match load_scene_document(root, relative_path) {
          @editor_bridge.Ready(_) =>
            @shared.rpc_response_scene_loaded(
              load_scene_bundle(root, relative_path),
            )
          @editor_bridge.MigrationRequired(preview) =>
            @shared.rpc_response_scene_migration_required(
              @editor_bridge.scene_migration_preview(
                relative_path,
                preview.scene,
                preview.changes,
              ),
            )
        }
      }
      @shared.SceneMigrate(path~) => {
        let manifest = self.current_manifest()
        let relative_path = if path == "" {
          manifest.startup_scene
        } else {
          path
        }
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

///|
async fn EditorService::handle_events(
  self : EditorService,
  conn : @http.ServerConnection,
) -> Unit {
  let (subscriber_id, queue) = self.add_subscriber()
  defer self.remove_subscriber(subscriber_id)
  conn.send_response(200, "OK", extra_headers={
    "Content-Type": "text/event-stream; charset=utf-8",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
  })
  let ready = @shared.event_envelope(@shared.editor_event_ready())
    .to_json()
    .stringify()
  conn.write("data: \{ready}\n\n")
  conn.flush()
  for ;; {
    let event = queue.get()
    conn.write("data: \{event.to_json().stringify()}\n\n")
    conn.flush()
  }
}

///|
pub async fn EditorService::handle_http_request(
  self : EditorService,
  request : @http.Request,
  body : &@io.Reader,
  conn : @http.ServerConnection,
) -> Unit {
  if request.meth is Get && self.handle_static_request(request, conn) {
    return
  }
  match (request.meth, request.path) {
    (Get, "/events") => self.handle_events(conn)
    (Post, "/rpc") => {
      let payload = body.read_all().text()
      let request_doc : @shared.RpcRequestEnvelope = @json.from_json(
        @json.parse(payload),
      )
      let response = self.handle_rpc(request_doc)
      send_json(conn, response)
    }
    _ => send_text(conn, "Not Found", code=404, reason="Not Found")
  }
}

///|
pub async fn EditorService::watch_loop(self : EditorService) -> Unit {
  fn sort_unique(values : Array[String]) -> Array[String] {
    let seen : Map[String, Bool] = {}
    let ordered : Array[String] = []
    for value in values {
      if seen.contains(value) {
        continue
      }
      seen.set(value, true)
      ordered.push(value)
    }
    ordered.sort_by(fn(left, right) { left.compare(right) })
    ordered
  }

  for ;; {
    if self.current_project is Some(project) {
      let next_snapshot = snapshot_project_files(project.root, project.manifest) catch {
        _ => {
          @async.sleep(1000)
          continue
        }
      }
      let changed : Array[String] = []
      for path, stamp in next_snapshot {
        if !project.snapshot.contains(path) || project.snapshot[path] != stamp {
          changed.push(path)
        }
      }
      for path, _ in project.snapshot {
        if !next_snapshot.contains(path) {
          changed.push(path)
        }
      }
      if !changed.is_empty() {
        project.snapshot = next_snapshot
        let unique_changed = sort_unique(changed)
        let mut workspace_changed = false
        let mut manifest_changed = false
        let scene_paths : Array[String] = []
        let asset_paths : Array[String] = []
        for path in unique_changed {
          if path.has_prefix(".selene-editor/") {
            workspace_changed = true
          } else if path == "selene.project.json" ||
            path.has_suffix(".project.json") {
            manifest_changed = true
          } else if path.has_prefix("scenes/") && path.has_suffix(".scene.json") {
            scene_paths.push(path)
          } else if path.has_prefix("assets/") {
            asset_paths.push(path)
          }
        }
        if workspace_changed {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_workspace_changed(),
              ),
            ),
          )
        }
        if manifest_changed {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_manifest_changed(),
              ),
            ),
          )
        }
        for path in sort_unique(scene_paths) {
          let state = scene_disk_state(project.root, path) catch {
            _ => { hash: "", revision: 0 }
          }
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_scene_file_changed(
                  path,
                  state.hash,
                  state.revision,
                ),
              ),
            ),
          )
        }
        for path in sort_unique(asset_paths) {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_asset_file_changed(path),
              ),
            ),
          )
        }
      }
    }
    @async.sleep(1000)
  }
}
