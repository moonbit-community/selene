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
    let loaded : @shared.ProjectManifest = @json.from_json(result["manifest"])

    inspect(loaded.name, content="Auto Open Demo")
    inspect(loaded.startup_scene, content="scenes/auto-open-demo.scene.json")
    inspect(
      @fs.exists(path_join(root, "auto-open-demo.project.json")),
      content="true",
    )
    inspect(@fs.exists(path_join(root, loaded.startup_scene)), content="true")
  })
}
