///|
async fn write_json_fixture(path : String, value : &ToJson) -> Unit {
  @fs.write_file(path, value.to_json().stringify(indent=2) + "\n", create=0o644)
}

///|
async test "legacy selene-editor.json manifests still open" {
  @async.with_task_group(group => {
    let root = @fs.tmpdir(prefix="selene-editor-core")
    group.add_defer(() => {
      if @fs.exists(root) {
        @fs.rmdir(root, recursive=true)
      }
    })

    @fs.mkdir(root, permission=0o755, recursive=true)
    @fs.mkdir(path_join(root, "scenes"), permission=0o755, recursive=true)
    @fs.mkdir(path_join(root, "assets"), permission=0o755, recursive=true)

    let manifest = @shared.ProjectManifest::default(
      "Legacy Demo",
      startup_scene="scenes/legacy.scene.json",
    )
    write_json_fixture(legacy_project_manifest_path(root), manifest)
    write_json_fixture(
      scene_path(root, manifest.startup_scene),
      @shared.SceneDocument::default_main(),
    )

    let service = EditorService::new(@env.current_dir().unwrap_or("."))
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

    inspect(loaded.name, content="Legacy Demo")
    inspect(loaded.startup_scene, content="scenes/legacy.scene.json")
  })
}
