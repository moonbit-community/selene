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
) -> Json {
  let manifest = load_project_manifest(root) catch {
    MissingProjectManifest(_) => {
      ensure_project_layout(root)
      let created = @editor_bridge.ProjectManifest::default(
        inferred_project_name(root),
      )
      save_project_manifest(root, created)
      save_scene_document(
        root,
        created.startup_scene,
        @editor_bridge.SceneDocument::default_main(),
      )
      created
    }
    err => raise err
  }
  let snapshot = snapshot_project_files(root, manifest)
  let scenes = list_scene_documents(root)
  let prefabs = list_prefab_documents(root)
  let atlases = list_atlas_asset_documents(root)
  let animations = list_animation_asset_documents(root)
  let workspace = load_workspace_document(root)
  self.current_project = Some({ root, manifest, snapshot })
  self.add_recent_project(root)
  self.broadcast(
    @shared.event_envelope("project.opened", {
      "root": root.to_json(),
      "manifest": manifest.to_json(),
    }),
  )
  {
    "root": root.to_json(),
    "manifest": manifest.to_json(),
    "scenes": scenes.to_json(),
    "prefabs": prefabs.to_json(),
    "atlases": atlases.to_json(),
    "animations": animations.to_json(),
    "workspace": workspace.to_json(),
    "recent_projects": self.recent_projects.to_json(),
  }
}

///|
async fn EditorService::create_project(
  self : EditorService,
  root : String,
  name : String,
) -> Json {
  ensure_project_layout(root)
  let manifest = @editor_bridge.ProjectManifest::default(name)
  save_project_manifest(root, manifest)
  save_scene_document(
    root,
    manifest.startup_scene,
    @editor_bridge.SceneDocument::default_main(),
  )
  self.open_project(root)
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
    ProjectNotOpen => "No project is open"
    _ => err.to_string()
  }
}

///|
pub async fn EditorService::handle_rpc(
  self : EditorService,
  request : @shared.RpcRequest,
) -> Json {
  let id = request.id
  let method_name = request.method_name
  try {
    match method_name {
      "project.current" =>
        match self.current_project {
          Some(project) => {
            let scenes = list_scene_documents(project.root)
            let prefabs = list_prefab_documents(project.root)
            let atlases = list_atlas_asset_documents(project.root)
            let animations = list_animation_asset_documents(project.root)
            let workspace = load_workspace_document(project.root)
            @shared.rpc_success(id, {
              "root": project.root.to_json(),
              "manifest": project.manifest.to_json(),
              "scenes": scenes.to_json(),
              "prefabs": prefabs.to_json(),
              "atlases": atlases.to_json(),
              "animations": animations.to_json(),
              "workspace": workspace.to_json(),
              "recent_projects": self.recent_projects.to_json(),
            })
          }
          None => {
            let empty_scenes : Array[@editor_bridge.SceneRef] = []
            let empty_prefabs : Array[@editor_bridge.PrefabRef] = []
            let empty_assets : Array[@editor_bridge.AssetRef] = []
            @shared.rpc_success(id, {
              "root": Json::null(),
              "manifest": Json::null(),
              "scenes": empty_scenes.to_json(),
              "prefabs": empty_prefabs.to_json(),
              "atlases": empty_assets.to_json(),
              "animations": empty_assets.to_json(),
              "workspace": Json::null(),
              "recent_projects": self.recent_projects.to_json(),
            })
          }
      }
      "project.open" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let root = require_project_root(@json.from_json(params["root"])) catch {
          err =>
            return @shared.rpc_failure(
              Some(id),
              "invalid_request",
              request_error_message(err),
              details=request.params,
            )
        }
        @shared.rpc_success(id, self.open_project(root))
      }
      "project.create" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let root = require_project_root(@json.from_json(params["root"])) catch {
          err =>
            return @shared.rpc_failure(
              Some(id),
              "invalid_request",
              request_error_message(err),
              details=request.params,
            )
        }
        let name : String = @json.from_json(params["name"])
        @shared.rpc_success(id, self.create_project(root, name))
      }
      "project.pick_directory" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let prompt = if params.contains("prompt") {
          @json.from_json(params["prompt"])
        } else {
          "Choose a project folder"
        }
        let path = pick_directory_dialog(prompt)
        @shared.rpc_success(id, @shared.directory_pick_result(path).to_json())
      }
      "scene.load" => {
        let manifest = self.current_manifest()
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path = if params.contains("path") {
          @json.from_json(params["path"])
        } else {
          manifest.startup_scene
        }
        let root = self.current_project_root()
        let scene = load_scene_document(root, relative_path)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "scene": scene.to_json(),
        })
      }
      "scene.list" => {
        let root = self.current_project_root()
        @shared.rpc_success(id, {
          "scenes": list_scene_documents(root).to_json(),
          "startup_scene": self.current_manifest().startup_scene.to_json(),
        })
      }
      "scene.create" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let name : String = @json.from_json(params["name"])
        let path = "scenes/" + @editor_bridge.scene_file_name(name)
        let root = self.current_project_root()
        let scene = @editor_bridge.SceneDocument::empty(name=name)
        save_scene_document(root, path, scene)
        self.broadcast(
          @shared.event_envelope("scene.created", {
            "path": path.to_json(),
          }),
        )
        @shared.rpc_success(id, {
          "path": path.to_json(),
          "scene": scene.to_json(),
          "scenes": list_scene_documents(root).to_json(),
        })
      }
      "scene.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let scene : @editor_bridge.SceneDocument = @json.from_json(
          params["scene"],
        )
        let root = self.current_project_root()
        save_scene_document(root, relative_path, scene)
        self.broadcast(
          @shared.event_envelope("scene.saved", {
            "path": relative_path.to_json(),
          }),
        )
        @shared.rpc_success(id, { "ok": true.to_json() })
      }
      "scene.patch" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let patch : @editor_bridge.ScenePatch = @json.from_json(params["patch"])
        let root = self.current_project_root()
        let scene = load_scene_document(root, relative_path)
        let next_scene = scene.apply_patch(patch)
        save_scene_document(root, relative_path, next_scene)
        self.broadcast(
          @shared.event_envelope("scene.patched", {
            "path": relative_path.to_json(),
            "patch": patch.to_json(),
          }),
        )
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "scene": next_scene.to_json(),
        })
      }
      "scene.delete" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let root = self.current_project_root()
        let path = scene_path(root, relative_path)
        if @fs.exists(path) {
          @fs.remove(path)
        }
        self.broadcast(
          @shared.event_envelope("scene.deleted", {
            "path": relative_path.to_json(),
          }),
        )
        @shared.rpc_success(id, {
          "ok": true.to_json(),
          "scenes": list_scene_documents(root).to_json(),
        })
      }
      "project.set_startup_scene" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let startup_scene : String = @json.from_json(params["path"])
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let next_manifest = manifest.with_startup_scene(startup_scene)
        save_project_manifest(root, next_manifest)
        if self.current_project is Some(project) {
          project.manifest = next_manifest
        }
        @shared.rpc_success(id, { "manifest": next_manifest.to_json() })
      }
      "assets.list" => {
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let assets = collect_assets(root, manifest)
        @shared.rpc_success(id, { "assets": assets.to_json() })
      }
      "prefab.list" => {
        let root = self.current_project_root()
        @shared.rpc_success(id, {
          "prefabs": list_prefab_documents(root).to_json(),
        })
      }
      "prefab.load" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let root = self.current_project_root()
        let prefab = load_prefab_document(root, relative_path)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "prefab": prefab.to_json(),
        })
      }
      "prefab.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let prefab : @editor_bridge.PrefabDocument = @json.from_json(
          params["prefab"],
        )
        let root = self.current_project_root()
        save_prefab_document(root, relative_path, prefab)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "prefab": prefab.to_json(),
        })
      }
      "atlas.list" => {
        let root = self.current_project_root()
        @shared.rpc_success(id, {
          "atlases": list_atlas_asset_documents(root).to_json(),
        })
      }
      "atlas.load" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let root = self.current_project_root()
        let atlas = load_atlas_asset_document(root, relative_path)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "atlas": atlas.to_json(),
        })
      }
      "atlas.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let atlas : @editor_bridge.AtlasAssetDocument = @json.from_json(
          params["atlas"],
        )
        let root = self.current_project_root()
        save_atlas_asset_document(root, relative_path, atlas)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "atlas": atlas.to_json(),
        })
      }
      "animation.list" => {
        let root = self.current_project_root()
        @shared.rpc_success(id, {
          "animations": list_animation_asset_documents(root).to_json(),
        })
      }
      "animation.load" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let root = self.current_project_root()
        let animation = load_animation_asset_document(root, relative_path)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "animation": animation.to_json(),
        })
      }
      "animation.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let animation : @editor_bridge.AnimationAssetDocument = @json.from_json(
          params["animation"],
        )
        let root = self.current_project_root()
        save_animation_asset_document(root, relative_path, animation)
        @shared.rpc_success(id, {
          "path": relative_path.to_json(),
          "animation": animation.to_json(),
        })
      }
      "workspace.load" => {
        let root = self.current_project_root()
        @shared.rpc_success(id, {
          "workspace": load_workspace_document(root).to_json(),
        })
      }
      "workspace.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let workspace : @editor_bridge.WorkspaceDocument = @json.from_json(
          params["workspace"],
        )
        let root = self.current_project_root()
        save_workspace_document(root, workspace)
        @shared.rpc_success(id, { "workspace": workspace.to_json() })
      }
      "assets.import" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let source_path : String = @json.from_json(params["source_path"])
        let desired_name : String? = if params.contains("name") {
          Some(@json.from_json(params["name"]))
        } else {
          None
        }
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let asset_root = match manifest.asset_roots {
          [first, ..] => first
          _ => "assets"
        }
        let output_name = desired_name.unwrap_or(basename_of(source_path))
        let target_relative = path_join(asset_root, output_name)
        let target_path = path_join(root, target_relative)
        ensure_dir(path_join(root, asset_root))
        let data = @fs.read_file(source_path)
        @fs.write_file(target_path, data, create=0o644)
        let asset = @editor_bridge.asset_document(
          target_relative,
          @editor_bridge.infer_asset_kind(target_relative),
        )
        self.broadcast(
          @shared.event_envelope("asset.imported", asset.to_json()),
        )
        @shared.rpc_success(id, asset.to_json())
      }
      _ =>
        @shared.rpc_failure(
          Some(id),
          "method_not_found",
          "Unknown RPC method: " + method_name,
        )
    }
  } catch {
    err =>
      @shared.rpc_failure(
        Some(id),
        "internal_error",
        err.to_string(),
        details=request.params,
      )
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
  let ready = @shared.event_envelope("ready", Json::null())
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
      let request_doc : @shared.RpcRequest = @json.from_json(
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
        self.broadcast(
          @shared.event_envelope("files.changed", { "paths": changed.to_json() }),
        )
      }
    }
    @async.sleep(1000)
  }
}
