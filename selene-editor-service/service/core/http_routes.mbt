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
      let rel_path = normalize_relative_path(request.path[9:].to_owned()) catch {
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
