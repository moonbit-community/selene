///|
async fn main {
  let module_root = @env.current_dir().unwrap_or(".")
  let service = EditorService::new(module_root)
  let args = @env.args()
  let maybe_project = match args {
    [_, project_root, ..] => Some(project_root)
    _ => None
  }
  service.ensure_frontend_bundle() catch {
    err => println("Failed to build frontend bundle: \{err}")
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
