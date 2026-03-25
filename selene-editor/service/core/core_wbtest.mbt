///|
async test "project.open auto-initializes a missing project manifest" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-core")
    let root = path_join(temp_root, "Auto Open Demo")
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    let payload = service.handle_rpc(
      @shared.rpc_request(
        1,
        "project.open",
        { "root": root.to_json() }.to_json(),
      ),
    )
    let success : @shared.RpcSuccess = @json.from_json(payload)
    let result : Map[String, Json] = @json.from_json(success.result)
    let loaded : @editor_bridge.ProjectManifest = @json.from_json(
      result["manifest"],
    )

    inspect(loaded.name, content="Auto Open Demo")
    inspect(loaded.startup_scene, content="scenes/main.scene.json")
    inspect(
      @fs.exists(path_join(root, "selene.project.json")),
      content="true",
    )
    inspect(@fs.exists(path_join(root, loaded.startup_scene)), content="true")
  })
}

///|
async test "project.open auto-initializes when the directory already exists" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-core")
    let root = path_join(temp_root, "Existing Dir Demo")
    @fs.mkdir(root, permission=0o755, recursive=true)
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    let payload = service.handle_rpc(
      @shared.rpc_request(
        1,
        "project.open",
        { "root": root.to_json() }.to_json(),
      ),
    )
    let success : @shared.RpcSuccess = @json.from_json(payload)
    let result : Map[String, Json] = @json.from_json(success.result)
    let loaded : @editor_bridge.ProjectManifest = @json.from_json(
      result["manifest"],
    )

    inspect(loaded.name, content="Existing Dir Demo")
    inspect(
      @fs.exists(path_join(root, "selene.project.json")),
      content="true",
    )
    inspect(@fs.exists(path_join(root, loaded.startup_scene)), content="true")
  })
}

///|
async test "project.open rejects an empty root" {
  let service = EditorService::new(".")
  let payload = service.handle_rpc(
    @shared.rpc_request(
      1,
      "project.open",
      { "root": "".to_json() }.to_json(),
    ),
  )
  let failure : @shared.RpcFailure = @json.from_json(payload)
  inspect(failure.error.code, content="invalid_request")
  inspect(failure.error.message, content="Project root is required")
}

///|
test "parse_cli_options defaults to the editor port" {
  let options = parse_cli_options(["selene-editor"])
  inspect(options.port, content="47142")
  inspect(options.project_root, content="None")
}

///|
test "parse_cli_options accepts --port and project root" {
  let options = parse_cli_options([
    "selene-editor",
    "--port",
    "48123",
    "/tmp/demo-project",
  ])
  inspect(options.port, content="48123")
  inspect(options.project_root, content="Some(\"/tmp/demo-project\")")
}

///|
test "parse_cli_options rejects an invalid port" {
  let result : Result[CliOptions, Error] = try? parse_cli_options([
    "selene-editor",
    "--port",
    "70000",
  ])
  match result {
    Err(Failure(message)) => inspect(message, content="Invalid port: 70000")
    _ => fail("expected invalid port failure")
  }
}

///|
test "normalize_relative_path decodes url-escaped asset paths" {
  inspect(
    normalize_relative_path(
      "assets/pixeladventure/Main%20Characters/Mask%20Dude/Fall%20(32x32).png",
    ),
    content=
      "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
  )
}
