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
