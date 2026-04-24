///|
async fn maybe_open_browser(url : String) -> Unit {
  ignore(@process.spawn_orphan("open", [url])) catch {
    _ => ignore(@process.spawn_orphan("xdg-open", [url])) catch { _ => () }
  }
}

///|
priv struct CliOptions {
  port : Int
  project_root : String?
}

///|
fn parse_port(text : String) -> Int raise {
  let parsed : Result[Int, Error] = try? @string.parse_int(text.view(), base=10)
  match parsed {
    Ok(port) if port > 0 && port <= 65535 => port
    _ => raise Failure("Invalid port: " + text)
  }
}

///|
fn parse_cli_options(args : Array[String]) -> CliOptions raise {
  let mut port = default_port
  let mut project_root : String? = None
  let mut index = 1
  while index < args.length() {
    match args[index] {
      "--port" => {
        if index + 1 >= args.length() {
          raise Failure("Missing value for --port")
        }
        port = parse_port(args[index + 1])
        index += 2
      }
      value if value.has_prefix("--") =>
        raise Failure("Unknown option: " + value)
      value => {
        if project_root is Some(_) {
          raise Failure("Unexpected extra argument: " + value)
        }
        project_root = Some(value)
        index += 1
      }
    }
  }
  { port, project_root }
}

///|
async fn EditorService::ensure_runtime_assets(self : EditorService) -> Unit {
  let assets = [
    self.public_path("index.html"),
    self.public_path("editor.css"),
    self.editor_script_path(),
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
      ". Build `selene-editor-frontend/frontend/web` and copy web.js to `selene-editor-service/public/editor.js` when developing from source, or use a release bundle."
    raise Failure(message)
  }
}

///|
pub async fn run_cli(module_root : String, args : Array[String]) -> Unit {
  let service = EditorService(module_root)
  let options = parse_cli_options(args) catch {
    err => {
      println("Failed to start selene-editor: \{err}")
      return
    }
  }
  service.ensure_runtime_assets() catch {
    err => {
      println("Failed to start selene-editor: \{err}")
      return
    }
  }
  if options.project_root is Some(project_root) {
    ignore(service.open_project(project_root)) catch {
      err => println("Failed to open project \{project_root}: \{err}")
    }
  }
  let server = @http.Server::new(
    @socket.Addr::parse("\{default_host}:\{options.port}"),
  )
  let url = "http://\{default_host}:\{options.port}"
  println("selene-editor listening at \{url}")
  maybe_open_browser(url) |> ignore
  @async.with_task_group(async fn(group) {
    group.spawn_bg(no_wait=true, async fn() { service.watch_loop() })
    server.run_forever(async fn(request, body, conn) {
      service.handle_http_request(request, body, conn)
    })
  })
}
