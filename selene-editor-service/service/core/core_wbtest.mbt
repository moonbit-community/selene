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
fn expect_error_response(
  response : @shared.RpcResponse,
  code : String,
  message : String,
) -> Unit raise {
  match response {
    @shared.Error(error~) => {
      inspect(error.code, content=code)
      inspect(error.message, content=message)
    }
    _ => fail("expected rpc error")
  }
}

///|
async fn read_scene_document_from_file(
  path : String,
) -> @editor_bridge.SceneDocument {
  let json = @json.parse(@fs.read_file(path).text())
  @editor_bridge.decode_scene_snf(json)
}

///|
async fn read_project_manifest_from_file(
  path : String,
) -> @editor_bridge.ProjectManifest {
  let json = @json.parse(@fs.read_file(path).text())
  @editor_bridge.decode_project_manifest(json)
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
      @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
    )
    let response = response_envelope(payload).response
    let loaded = match response {
      @shared.ProjectState(state~) => state.manifest.unwrap()
      @shared.Error(error~) =>
        fail("unexpected project-open error: " + error.message)
      _ => fail("expected project state")
    }

    inspect(loaded.name, content="Auto Open Demo")
    inspect(loaded.startup_scene, content="scenes/auto-open-demo.scene.json")
    inspect(@fs.exists(path_join(root, "selene.project.json")), content="true")
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
      @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
    )
    let response = response_envelope(payload).response
    let loaded = match response {
      @shared.ProjectState(state~) => state.manifest.unwrap()
      @shared.Error(error~) =>
        fail("unexpected project-open error: " + error.message)
      _ => fail("expected project state")
    }

    inspect(loaded.name, content="Existing Dir Demo")
    inspect(loaded.startup_scene, content="scenes/existing-dir-demo.scene.json")
    inspect(@fs.exists(path_join(root, "selene.project.json")), content="true")
    inspect(@fs.exists(path_join(root, loaded.startup_scene)), content="true")
  })
}

///|
async test "project.open auto-migrates legacy v2 project manifests missing indexes" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-core")
    let root = path_join(temp_root, "Legacy Manifest Demo")
    @fs.mkdir(path_join(root, "scenes"), permission=0o755, recursive=true)
    @fs.write_file(
      path_join(root, "selene.project.json"),
      "{\n  \"version\": 2,\n  \"name\": \"Legacy\",\n  \"startup_scene\": \"scenes/main.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n"
      |> @utf8.encode,
      create=0o644,
    )
    @fs.write_file(
      path_join(root, "scenes/main.scene.json"),
      (@editor_bridge.SceneDocument::default_main()
      .to_json()
      .stringify(indent=2) +
      "\n")
      |> @utf8.encode,
      create=0o644,
    )
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    let payload = service.handle_rpc(
      @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
    )
    let response = response_envelope(payload).response
    let manifest = match response {
      @shared.ProjectState(state~) => state.manifest.unwrap()
      _ => fail("expected project state")
    }

    inspect(manifest.scene_index.length(), content="1")
    inspect(manifest.prefab_index.length(), content="0")
    inspect(
      read_project_manifest_from_file(path_join(root, "selene.project.json")).scene_index.length(),
      content="1",
    )
  })
}

///|
async test "project.open fails when workspace.json is invalid instead of silently defaulting" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-core")
    let root = path_join(temp_root, "Invalid Workspace Demo")
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
      ),
    )

    @fs.write_file(
      path_join(root, ".selene-editor/workspace.json"),
      "{\n  \"version\": 2,\n  \"move_snap_step\": 0\n}\n" |> @utf8.encode,
      create=0o644,
    )

    let payload = service.handle_rpc(
      @shared.rpc_request_envelope(2, @shared.rpc_request_project_open(root)),
    )
    expect_error_response(
      response_envelope(payload).response,
      "internal_error",
      "Workspace document is invalid: .selene-editor/workspace.json",
    )
  })
}

///|
async test "project.open rejects an empty root" {
  let service = EditorService::new(".")
  let payload = service.handle_rpc(
    @shared.rpc_request_envelope(1, @shared.rpc_request_project_open("")),
  )
  let response = response_envelope(payload).response
  expect_error_response(response, "invalid_request", "Project root is required")
}

///|
async test "project.current returns an empty typed state before any project is open" {
  let service = EditorService::new(".")
  let payload = service.handle_rpc(
    @shared.rpc_request_envelope(1, @shared.rpc_request_project_current()),
  )
  let response = response_envelope(payload).response
  match response {
    @shared.ProjectState(state~) => {
      inspect(state.root, content="None")
      inspect(state.manifest is None, content="true")
      inspect(state.scenes.length(), content="0")
    }
    _ => fail("expected project state response")
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
    "selene-editor", "--port", "48123", "/tmp/demo-project",
  ])
  inspect(options.port, content="48123")
  inspect(options.project_root, content="Some(\"/tmp/demo-project\")")
}

///|
test "parse_cli_options rejects an invalid port" {
  let result : Result[CliOptions, Error] = try? parse_cli_options([
    "selene-editor", "--port", "70000",
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
    content="assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
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
        @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
      ),
    )

    let create_scene_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        2,
        @shared.rpc_request_scene_create("Battlefield"),
      ),
    )
    let created_scene_path = match
      response_envelope(create_scene_payload).response {
      @shared.SceneLoaded(scene~) => scene.path
      _ => fail("expected scene load response")
    }
    inspect(created_scene_path, content="scenes/battlefield.scene.json")

    let prefab = @editor_bridge.PrefabDocument::empty("Enemy").with_entity(
      @editor_bridge.entity_document("enemy", "Enemy", components=[
        @editor_bridge.name_component("Enemy"),
      ]),
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
      "Hero Atlas", "assets/images/hero.png",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          4,
          @shared.rpc_request_atlas_save(
            "assets/atlases/hero.atlas.json", atlas,
          ),
        ),
      ),
    )

    let animation = @editor_bridge.AnimationClipAssetDocument::default(
      "Hero Clip", "assets/atlases/hero.atlas.json",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          5,
          @shared.rpc_request_animation_clip_save(
            "assets/animation_clips/hero.clip.json", animation,
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
      @fs.exists(path_join(root, "assets/animation_clips/hero.clip.json")),
      content="true",
    )
  })
}

///|
async test "service typed rpc surface succeeds across current workspace actions" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-rpc-surface")
    let root = path_join(temp_root, "Rpc Demo")
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
      ),
    )
    @fs.write_file(
      path_join(root, "assets/images/hero.png"),
      b"fake-image",
      create=0o644,
    )

    let current_payload = service.handle_rpc(
      @shared.rpc_request_envelope(2, @shared.rpc_request_project_current()),
    )
    match response_envelope(current_payload).response {
      @shared.ProjectState(state~) =>
        inspect(state.root, content="Some(\"" + root + "\")")
      _ => fail("expected project state")
    }

    let list_payload = service.handle_rpc(
      @shared.rpc_request_envelope(3, @shared.rpc_request_scene_list()),
    )
    match response_envelope(list_payload).response {
      @shared.SceneListed(list~) => inspect(list.scenes.length(), content="1")
      _ => fail("expected scene list response")
    }

    let load_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        4,
        @shared.rpc_request_scene_load("scenes/rpc-demo.scene.json"),
      ),
    )
    let loaded_scene_bundle = match response_envelope(load_payload).response {
      @shared.SceneLoaded(scene~) => {
        inspect(scene.path, content="scenes/rpc-demo.scene.json")
        scene
      }
      _ => fail("expected scene load response")
    }

    let save_scene = @editor_bridge.SceneDocument::default_main().with_name(
      "Gameplay",
    )
    let save_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        5,
        @shared.rpc_request_scene_save(
          "scenes/rpc-demo.scene.json",
          save_scene,
          loaded_scene_bundle.disk_hash,
          loaded_scene_bundle.disk_revision,
        ),
      ),
    )
    inspect(
      match response_envelope(save_payload).response {
        @shared.SceneSaved(save~) => save.path == "scenes/rpc-demo.scene.json"
        _ => false
      },
      content="true",
    )

    let create_scene_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        6,
        @shared.rpc_request_scene_create("Battlefield"),
      ),
    )
    let created_scene_path = match
      response_envelope(create_scene_payload).response {
      @shared.SceneLoaded(scene~) => scene.path
      _ => fail("expected created scene response")
    }
    inspect(created_scene_path, content="scenes/battlefield.scene.json")

    let startup_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        7,
        @shared.rpc_request_project_set_startup_scene(created_scene_path),
      ),
    )
    match response_envelope(startup_payload).response {
      @shared.StartupSceneUpdated(manifest~) =>
        inspect(manifest.startup_scene, content="scenes/battlefield.scene.json")
      _ => fail("expected startup scene response")
    }

    let workspace = @editor_bridge.WorkspaceDocument::default()
      .with_last_scene(Some("scenes/rpc-demo.scene.json"))
      .with_selected_entity_id(Some("camera"))
      .with_move_snap_enabled(true)
      .with_move_snap_step(32.0)
    let workspace_save_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        8,
        @shared.rpc_request_project_save_workspace(workspace),
      ),
    )
    inspect(
      match response_envelope(workspace_save_payload).response {
        @shared.SavedOk => true
        _ => false
      },
      content="true",
    )

    let assets_payload = service.handle_rpc(
      @shared.rpc_request_envelope(9, @shared.rpc_request_assets_list()),
    )
    match response_envelope(assets_payload).response {
      @shared.AssetsListed(list~) => inspect(list.assets.length(), content="1")
      _ => fail("expected assets list response")
    }

    let prefab = @editor_bridge.PrefabDocument::empty("Enemy").with_entity(
      @editor_bridge.entity_document("enemy", "Enemy", components=[
        @editor_bridge.name_component("Enemy"),
      ]),
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          10,
          @shared.rpc_request_prefab_save("prefabs/enemy.prefab.json", prefab),
        ),
      ),
    )
    let prefab_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        11,
        @shared.rpc_request_prefab_load("prefabs/enemy.prefab.json"),
      ),
    )
    match response_envelope(prefab_payload).response {
      @shared.PrefabLoaded(prefab~) =>
        inspect(prefab.prefab.name, content="Enemy")
      _ => fail("expected prefab load response")
    }

    let atlas = @editor_bridge.AtlasAssetDocument::default(
      "Hero Atlas", "assets/images/hero.png",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          12,
          @shared.rpc_request_atlas_save(
            "assets/atlases/hero.atlas.json", atlas,
          ),
        ),
      ),
    )
    let atlas_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        13,
        @shared.rpc_request_atlas_load("assets/atlases/hero.atlas.json"),
      ),
    )
    match response_envelope(atlas_payload).response {
      @shared.AtlasLoaded(atlas~) =>
        inspect(atlas.atlas.name, content="Hero Atlas")
      _ => fail("expected atlas load response")
    }

    let animation = @editor_bridge.AnimationClipAssetDocument::default(
      "Hero Clip", "assets/atlases/hero.atlas.json",
    )
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          14,
          @shared.rpc_request_animation_clip_save(
            "assets/animation_clips/hero.clip.json", animation,
          ),
        ),
      ),
    )
    let animation_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        15,
        @shared.rpc_request_animation_clip_load(
          "assets/animation_clips/hero.clip.json",
        ),
      ),
    )
    match response_envelope(animation_payload).response {
      @shared.AnimationClipLoaded(clip~) =>
        inspect(clip.clip.name, content="Hero Clip")
      _ => fail("expected animation load response")
    }

    let delete_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        16,
        @shared.rpc_request_scene_delete(created_scene_path),
      ),
    )
    inspect(
      match response_envelope(delete_payload).response {
        @shared.SavedOk => true
        _ => false
      },
      content="true",
    )

    let workspace_json = @json.parse(
      @fs.read_file(path_join(root, ".selene-editor/workspace.json")).text(),
    )
    let loaded_workspace = @editor_bridge.decode_workspace_document(
      workspace_json,
    )
    inspect(loaded_workspace.move_snap_enabled, content="Some(true)")
    inspect(loaded_workspace.move_snap_step, content="Some(32)")
  })
}

///|
async test "service typed rpc surface returns stable errors for missing or invalid data" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-rpc-errors")
    let root = path_join(temp_root, "Rpc Errors")
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")

    let not_open_requests : Array[@shared.RpcRequest] = [
      @shared.rpc_request_scene_load("scenes/main.scene.json"),
      @shared.rpc_request_scene_migrate("scenes/main.scene.json"),
      @shared.rpc_request_scene_list(),
      @shared.rpc_request_scene_create("Main"),
      @shared.rpc_request_scene_save(
        "scenes/main.scene.json",
        @editor_bridge.SceneDocument::default_main(),
        "",
        0,
      ),
      @shared.rpc_request_scene_delete("scenes/main.scene.json"),
      @shared.rpc_request_project_set_startup_scene("scenes/main.scene.json"),
      @shared.rpc_request_project_save_workspace(
        @editor_bridge.WorkspaceDocument::default(),
      ),
      @shared.rpc_request_assets_list(),
      @shared.rpc_request_prefab_load("prefabs/missing.prefab.json"),
      @shared.rpc_request_prefab_save(
        "prefabs/test.prefab.json",
        @editor_bridge.PrefabDocument::empty("Test"),
      ),
      @shared.rpc_request_atlas_load("assets/atlases/missing.atlas.json"),
      @shared.rpc_request_atlas_save(
        "assets/atlases/test.atlas.json",
        @editor_bridge.AtlasAssetDocument::default(
          "Test Atlas", "assets/images/test.png",
        ),
      ),
      @shared.rpc_request_animation_clip_load(
        "assets/animation_clips/missing.clip.json",
      ),
      @shared.rpc_request_animation_clip_save(
        "assets/animation_clips/test.clip.json",
        @editor_bridge.AnimationClipAssetDocument::default(
          "Test Clip", "assets/atlases/test.atlas.json",
        ),
      ),
      @shared.rpc_request_animation_graph_load(
        "assets/animation_graphs/missing.graph.json",
      ),
      @shared.rpc_request_animation_graph_save(
        "assets/animation_graphs/test.graph.json",
        @editor_bridge.AnimationGraphAssetDocument::default(
          "Test Graph", "assets/animation_clips/test.clip.json",
        ),
      ),
    ]
    let mut request_id = 1
    for request in not_open_requests {
      let payload = service.handle_rpc(
        @shared.rpc_request_envelope(request_id, request),
      )
      request_id += 1
      expect_error_response(
        response_envelope(payload).response,
        "internal_error",
        "No project is open",
      )
    }

    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(
          request_id,
          @shared.rpc_request_project_open(root),
        ),
      ),
    )
    request_id += 1

    let invalid_scene_path = path_join(root, "scenes/rpc-errors.scene.json")
    @fs.write_file(
      invalid_scene_path,
      "{\"version\":1,\"entities\":" |> @utf8.encode,
      create=0o644,
    )
    let invalid_scene_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        request_id,
        @shared.rpc_request_scene_load("scenes/rpc-errors.scene.json"),
      ),
    )
    request_id += 1
    expect_error_response(
      response_envelope(invalid_scene_payload).response,
      "internal_error",
      "Scene document is invalid: scenes/rpc-errors.scene.json",
    )

    let missing_scene_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        request_id,
        @shared.rpc_request_scene_load("scenes/missing.scene.json"),
      ),
    )
    request_id += 1
    expect_error_response(
      response_envelope(missing_scene_payload).response,
      "internal_error",
      "Scene not found: scenes/missing.scene.json",
    )

    @fs.write_file(
      path_join(root, "prefabs/broken.prefab.json"),
      "{\n  \"version\": 1,\n  \"name\": \"\",\n  \"entities\": []\n}\n"
      |> @utf8.encode,
      create=0o644,
    )
    let invalid_prefab_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        request_id,
        @shared.rpc_request_prefab_load("prefabs/broken.prefab.json"),
      ),
    )
    request_id += 1
    expect_error_response(
      response_envelope(invalid_prefab_payload).response,
      "internal_error",
      "Prefab document is invalid: prefabs/broken.prefab.json",
    )

    @fs.write_file(
      path_join(root, "assets/atlases/broken.atlas.json"),
      "{\n  \"version\": 1,\n  \"name\": \"Broken\",\n  \"source_image\": \"assets/images/hero.png\",\n  \"tile_size\": {\"x\": 0, \"y\": 0},\n  \"columns\": 0,\n  \"rows\": 0,\n  \"spacing\": {\"x\": 0, \"y\": 0},\n  \"margin\": {\"x\": 0, \"y\": 0},\n  \"default_anchor\": {\"x\": 0.5, \"y\": 0.5},\n  \"regions\": []\n}\n"
      |> @utf8.encode,
      create=0o644,
    )
    let invalid_atlas_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        request_id,
        @shared.rpc_request_atlas_load("assets/atlases/broken.atlas.json"),
      ),
    )
    request_id += 1
    expect_error_response(
      response_envelope(invalid_atlas_payload).response,
      "internal_error",
      "Atlas document is invalid: assets/atlases/broken.atlas.json",
    )

    @fs.write_file(
      path_join(root, "assets/animation_clips/broken.clip.json"),
      "{\n  \"version\": 3,\n  \"name\": \"Broken\"\n}\n" |> @utf8.encode,
      create=0o644,
    )
    let invalid_animation_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        request_id,
        @shared.rpc_request_animation_clip_load(
          "assets/animation_clips/broken.clip.json",
        ),
      ),
    )
    expect_error_response(
      response_envelope(invalid_animation_payload).response,
      "internal_error",
      "Animation clip document is invalid: assets/animation_clips/broken.clip.json",
    )
  })
}

///|
async test "scene.load can require migration and scene.migrate writes back the migrated scene" {
  @async.with_task_group(group => {
    let temp_root = @fs.tmpdir(prefix="selene-editor-migrate")
    let root = path_join(temp_root, "Legacy Demo")
    @fs.mkdir(path_join(root, "scenes"), permission=0o755, recursive=true)
    @fs.write_file(
      path_join(root, "selene.project.json"),
      (@editor_bridge.ProjectManifest::default(
        "Legacy Demo",
        startup_scene="scenes/main.scene.json",
        asset_roots=[
          "assets/images", "assets/audio", "assets/fonts", "assets/atlases", "assets/animations",
        ],
      )
      .to_json()
      .stringify(indent=2) +
      "\n")
      |> @utf8.encode,
      create=0o644,
    )
    @fs.write_file(
      path_join(root, "scenes/main.scene.json"),
      "{\n  \"version\": 2,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"name\": \"Camera2d\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": {\n              \"x\": 0,\n              \"y\": 0\n            },\n            \"rotation\": 0,\n            \"scale\": {\n              \"x\": 1,\n              \"y\": 1\n            }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": {\n            \"is_active\": true,\n            \"order\": 0,\n            \"scale\": 1\n          }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": {\n            \"visible\": true\n          }\n        }\n      ]\n    }\n  ]\n}\n"
      |> @utf8.encode,
      create=0o644,
    )
    group.add_defer(() => {
      if @fs.exists(temp_root) {
        @fs.rmdir(temp_root, recursive=true)
      }
    })

    let service = EditorService::new(".")
    ignore(
      service.handle_rpc(
        @shared.rpc_request_envelope(1, @shared.rpc_request_project_open(root)),
      ),
    )

    let load_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        2,
        @shared.rpc_request_scene_load("scenes/main.scene.json"),
      ),
    )
    let load_response = response_envelope(load_payload).response
    match load_response {
      @shared.SceneMigrationRequired(preview~) => {
        inspect(preview.scene.name, content="Main")
        inspect(preview.changes.length(), content="3")
      }
      _ => fail("expected migration-required response")
    }

    let migrate_payload = service.handle_rpc(
      @shared.rpc_request_envelope(
        3,
        @shared.rpc_request_scene_migrate("scenes/main.scene.json"),
      ),
    )
    let migrate_response = response_envelope(migrate_payload).response
    match migrate_response {
      @shared.SceneLoaded(scene~) => inspect(scene.scene.name, content="Main")
      _ => fail("expected migrated scene load response")
    }

    inspect(
      read_scene_document_from_file(path_join(root, "scenes/main.scene.json")).name,
      content="Main",
    )
  })
}
