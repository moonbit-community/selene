///|
let default_host = "127.0.0.1"

///|
let default_port = 47142

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
async fn send_file(conn : @http.ServerConnection, path : String) -> Unit {
  let file = @fs.open(path, mode=ReadOnly)
  defer file.close()
  conn
  ..send_response(200, "OK", extra_headers={
    "Content-Type": content_type_for(path),
    "Cache-Control": "no-cache",
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
      send_file(conn, self.public_path("index.html")) catch {
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
      send_file(conn, self.public_path("editor.css")) catch {
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
      send_file(conn, self.frontend_bundle_path()) catch {
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
  let manifest = load_project_manifest(root)
  let snapshot = snapshot_project_files(root, manifest)
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
  let manifest = @shared.ProjectManifest::default(name)
  save_project_manifest(root, manifest)
  save_scene_document(
    root,
    manifest.startup_scene,
    @shared.SceneDocument::default_main(),
  )
  self.open_project(root)
}

///|
async fn EditorService::handle_rpc_request(
  self : EditorService,
  request : @shared.RpcRequest,
) -> Json {
  let id = request.id
  let method_name = request.method_name
  try {
    match method_name {
      "project.current" =>
        match self.current_project {
          Some(project) =>
            @shared.rpc_success(id, {
              "root": project.root.to_json(),
              "manifest": project.manifest.to_json(),
              "recent_projects": self.recent_projects.to_json(),
            })
          None =>
            @shared.rpc_success(id, {
              "root": Json::null(),
              "manifest": Json::null(),
              "recent_projects": self.recent_projects.to_json(),
            })
        }
      "project.open" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let root : String = @json.from_json(params["root"])
        @shared.rpc_success(id, self.open_project(root))
      }
      "project.create" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let root : String = @json.from_json(params["root"])
        let name : String = @json.from_json(params["name"])
        @shared.rpc_success(id, self.create_project(root, name))
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
      "scene.save" => {
        let params : Map[String, Json] = @json.from_json(request.params)
        let relative_path : String = @json.from_json(params["path"])
        let scene : @shared.SceneDocument = @json.from_json(params["scene"])
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
        let patch : @shared.ScenePatch = @json.from_json(params["patch"])
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
      "assets.list" => {
        let root = self.current_project_root()
        let manifest = self.current_manifest()
        let assets = collect_assets(root, manifest)
        @shared.rpc_success(id, { "assets": assets.to_json() })
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
        @fs.write_file(target_path, data)
        let asset = @shared.asset_document(
          target_relative,
          @shared.infer_asset_kind(target_relative),
        )
        self.broadcast(
          @shared.event_envelope("asset.imported", asset.to_json()),
        )
        @shared.rpc_success(id, asset.to_json())
      }
      "build.check" => {
        let root = self.current_project_root()
        let result = self.run_moon_command(root, "build.check", [
          "check", "--target", "all",
        ])
        @shared.rpc_success(id, result)
      }
      "build.run_preview" => {
        let root = self.current_project_root()
        let params : Map[String, Json] = @json.from_json(request.params)
        let args : Array[String] = if params.contains("args") {
          @json.from_json(params["args"])
        } else {
          ["build", "--target", "js"]
        }
        let result = self.run_moon_command(root, "build.run_preview", args)
        @shared.rpc_success(id, result)
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
        details=Some(request.params),
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
async fn EditorService::handle_http_request(
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
      let response = self.handle_rpc_request(request_doc)
      send_json(conn, response)
    }
    _ => send_text(conn, "Not Found", code=404, reason="Not Found")
  }
}

///|
async fn EditorService::watch_loop(self : EditorService) -> Unit {
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

///|
async fn maybe_open_browser(url : String) -> Unit {
  ignore(@process.spawn_orphan("open", [url])) catch {
    _ => ()
  }
}
