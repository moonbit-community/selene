///|
fn response_envelope(payload : Json) -> @shared.RpcResponseEnvelope {
  let result : Result[@shared.RpcResponseEnvelope, Error] = try? @json.from_json(
    payload,
  )
  match result {
    Ok(envelope) => envelope
    Err(_) => abort("Failed to decode rpc response envelope")
  }
}

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
      @shared.rpc_request_envelope(
        1,
        @shared.rpc_request_project_open(root),
      ),
    )
    let response = response_envelope(payload).response
    let loaded = match response {
      @shared.ProjectState(state~) => state.manifest.unwrap()
      _ => fail("expected project state")
    }

    inspect(loaded.name, content="Auto Open Demo")
    inspect(loaded.startup_scene, content="scenes/auto-open-demo.scene.json")
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
      @shared.rpc_request_envelope(
        1,
        @shared.rpc_request_project_open(root),
      ),
    )
    let response = response_envelope(payload).response
    let loaded = match response {
      @shared.ProjectState(state~) => state.manifest.unwrap()
      _ => fail("expected project state")
    }

    inspect(loaded.name, content="Existing Dir Demo")
    inspect(
      loaded.startup_scene,
      content="scenes/existing-dir-demo.scene.json",
    )
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
    @shared.rpc_request_envelope(1, @shared.rpc_request_project_open("")),
  )
  let response = response_envelope(payload).response
  match response {
    @shared.Error(error~) => {
      inspect(error.code, content="invalid_request")
      inspect(error.message, content="Project root is required")
    }
    _ => fail("expected rpc error")
  }
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

///|
async test "service lists scenes and saves prefabs and asset docs" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-structure")
    let root = path_join(temp_root, "Structure Demo")
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          1,
          @shared.rpc_request_project_open(root),
        ),
      ),
    )

    let create_scene_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        2,
        @shared.rpc_request_scene_create("Battlefield"),
      ),
    )
    let created_scene_path = match response_envelope(create_scene_payload).response {
      @shared.SceneLoaded(scene~) => scene.path
      _ => fail("expected scene load response")
    }
    inspect(
      created_scene_path,
      content="scenes/battlefield.scene.json",
    )

    let prefab = @editor_bridge.PrefabDocument::empty("Enemy").with_entity(
      @editor_bridge.entity_document(
        "enemy",
        "Enemy",
        components=[@editor_bridge.name_component("Enemy")],
      ),
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          3,
          @shared.rpc_request_prefab_save("prefabs/enemy.prefab.json", prefab),
        ),
      ),
    )

    let atlas = @editor_bridge.AtlasAssetDocument::default(
      "Hero Atlas",
      "assets/images/hero.png",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          4,
          @shared.rpc_request_atlas_save("assets/atlases/hero.atlas.json", atlas),
        ),
      ),
    )

    let animation = @editor_bridge.AnimationAssetDocument::default(
      "Hero Animation",
      "assets/atlases/hero.atlas.json",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          5,
          @shared.rpc_request_animation_save(
            "assets/animations/hero.anim.json",
            animation,
          ),
        ),
      ),
    )

    inspect(
      @fs.exists(path_join(root, "prefabs/enemy.prefab.json")),
      content="true",
    )
    inspect(
      @fs.exists(path_join(root, "assets/atlases/hero.atlas.json")),
      content="true",
    )
    inspect(
      @fs.exists(path_join(root, "assets/animations/hero.anim.json")),
      content="true",
    )
  })
}
