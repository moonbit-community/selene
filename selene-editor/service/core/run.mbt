///|
async fn maybe_open_browser(url : String) -> Unit {
  ignore(@process.spawn_orphan("open", [url])) catch {
    _ => ignore(@process.spawn_orphan("xdg-open", [url])) catch { _ => () }
  }
}

///|
async fn EditorService::ensure_runtime_assets(self : EditorService) -> Unit {
  let assets = [
    self.public_path("index.html"),
    self.public_path("editor.css"),
    self.frontend_bundle_path(),
  ]
  let missing : Array[String] = []
  for path in assets {
    if !@fs.exists(path) {
      missing.push(path)
    }
  }
  if !missing.is_empty() {
    let message = "Missing editor runtime assets: " +
      missing.join(", ") +
      ". Build the frontend when developing from source, or use a release bundle."
    raise Failure(message)
  }
}

///|
pub async fn run_cli(module_root : String, args : Array[String]) -> Unit {
  let service = EditorService::new(module_root)
  let maybe_project = match args {
    [_, project_root, ..] => Some(project_root)
    _ => None
  }
  service.ensure_runtime_assets() catch {
    err => {
      println("Failed to start selene-editor: \{err}")
      return
    }
  }
  if maybe_project is Some(project_root) {
    ignore(service.open_project(project_root)) catch {
      err => println("Failed to open project \{project_root}: \{err}")
    }
  }
  let server = @http.Server::new(
    @socket.Addr::parse("\{default_host}:\{default_port}"),
  )
  let url = "http://\{default_host}:\{default_port}"
  println("selene-editor listening at \{url}")
  maybe_open_browser(url) |> ignore
  @async.with_task_group(async fn(group) {
    group.spawn_bg(no_wait=true, async fn() { service.watch_loop() })
    server.run_forever(async fn(request, body, conn) {
      service.handle_http_request(request, body, conn)
    })
  })
}
