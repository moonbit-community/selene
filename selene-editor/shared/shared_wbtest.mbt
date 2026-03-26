///|
test "all retained rpc requests round trip through typed envelopes" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let prefab = @editor_bridge.PrefabDocument::empty("Hero")
  let atlas = @editor_bridge.AtlasAssetDocument::default(
    "Hero Atlas",
    "assets/images/hero.png",
  )
  let animation = @editor_bridge.AnimationAssetDocument::default(
    "Hero Animation",
    "assets/atlases/hero.atlas.json",
  )
  let requests : Array[RpcRequestEnvelope] = [
    rpc_request_envelope(1, rpc_request_project_current()),
    rpc_request_envelope(2, rpc_request_project_open("/tmp/demo")),
    rpc_request_envelope(3, rpc_request_project_pick_directory("Choose folder")),
    rpc_request_envelope(4, rpc_request_project_set_startup_scene("scenes/main.scene.json")),
    rpc_request_envelope(5, rpc_request_scene_load("scenes/main.scene.json")),
    rpc_request_envelope(6, rpc_request_scene_migrate("scenes/main.scene.json")),
    rpc_request_envelope(7, rpc_request_scene_list()),
    rpc_request_envelope(8, rpc_request_scene_create("Main")),
    rpc_request_envelope(9, rpc_request_scene_save("scenes/main.scene.json", scene)),
    rpc_request_envelope(10, rpc_request_scene_delete("scenes/main.scene.json")),
    rpc_request_envelope(11, rpc_request_assets_list()),
    rpc_request_envelope(12, rpc_request_prefab_load("prefabs/hero.prefab.json")),
    rpc_request_envelope(13, rpc_request_prefab_save("prefabs/hero.prefab.json", prefab)),
    rpc_request_envelope(14, rpc_request_atlas_load("assets/atlases/hero.atlas.json")),
    rpc_request_envelope(15, rpc_request_atlas_save("assets/atlases/hero.atlas.json", atlas)),
    rpc_request_envelope(16, rpc_request_animation_load("assets/animations/hero.anim.json")),
    rpc_request_envelope(
      17,
      rpc_request_animation_save("assets/animations/hero.anim.json", animation),
    ),
  ]
  for request in requests {
    let decoded : RpcRequestEnvelope = @json.from_json(request.to_json())
    inspect(decoded == request, content="true")
  }
}

///|
test "all retained rpc responses and editor events round trip through typed envelopes" {
  let preview = @editor_bridge.scene_migration_preview(
    "scenes/main.scene.json",
    @editor_bridge.SceneDocument::default_main(),
    [
      @editor_bridge.migration_field_change(
        "name",
        "Missing required scene name",
        "Main",
      ),
    ],
  )
  let project_state = project_state_response(
    Some("/tmp/demo"),
    Some(@editor_bridge.ProjectManifest::default("Demo")),
    [@editor_bridge.scene_ref("scenes/main.scene.json")],
    [@editor_bridge.prefab_ref("prefabs/hero.prefab.json")],
    [@editor_bridge.asset_ref("assets/atlases/hero.atlas.json")],
    [@editor_bridge.asset_ref("assets/animations/hero.anim.json")],
    Some(@editor_bridge.WorkspaceDocument::default()),
    ["/tmp/demo"],
  )
  let responses : Array[RpcResponseEnvelope] = [
    rpc_response_envelope(1, rpc_response_project_state(project_state)),
    rpc_response_envelope(
      2,
      rpc_response_directory_picked(directory_pick_result(Some("/tmp/demo"))),
    ),
    rpc_response_envelope(
      3,
      rpc_response_scene_loaded(
        scene_load_response("scenes/main.scene.json", @editor_bridge.SceneDocument::default_main()),
      ),
    ),
    rpc_response_envelope(4, rpc_response_scene_migration_required(preview)),
    rpc_response_envelope(
      5,
      rpc_response_scene_listed(
        scene_list_response(
          [@editor_bridge.scene_ref("scenes/main.scene.json")],
          "scenes/main.scene.json",
        ),
      ),
    ),
    rpc_response_envelope(
      6,
      rpc_response_assets_listed(
        assets_list_response([
          @editor_bridge.asset_document(
            "assets/images/hero.png",
            @editor_bridge.infer_asset_kind("assets/images/hero.png"),
          ),
        ]),
      ),
    ),
    rpc_response_envelope(
      7,
      rpc_response_prefab_loaded(
        prefab_load_response(
          "prefabs/hero.prefab.json",
          @editor_bridge.PrefabDocument::empty("Hero"),
        ),
      ),
    ),
    rpc_response_envelope(
      8,
      rpc_response_atlas_loaded(
        atlas_load_response(
          "assets/atlases/hero.atlas.json",
          @editor_bridge.AtlasAssetDocument::default(
            "Hero Atlas",
            "assets/images/hero.png",
          ),
        ),
      ),
    ),
    rpc_response_envelope(
      9,
      rpc_response_animation_loaded(
        animation_load_response(
          "assets/animations/hero.anim.json",
          @editor_bridge.AnimationAssetDocument::default(
            "Hero Animation",
            "assets/atlases/hero.atlas.json",
          ),
        ),
      ),
    ),
    rpc_response_envelope(
      10,
      rpc_response_startup_scene_updated(@editor_bridge.ProjectManifest::default("Demo")),
    ),
    rpc_response_envelope(11, rpc_response_saved_ok()),
    rpc_error_response(12, "broken", "Something failed"),
  ]
  for response in responses {
    let decoded : RpcResponseEnvelope = @json.from_json(response.to_json())
    inspect(decoded == response, content="true")
  }

  let events : Array[EventEnvelope] = [
    event_envelope(editor_event_ready()),
    event_envelope(editor_event_log("core", "ready")),
    event_envelope(
      editor_event_project_opened(
        "/tmp/demo",
        @editor_bridge.ProjectManifest::default("Demo"),
      ),
    ),
    event_envelope(editor_event_files_changed(["scenes/main.scene.json"])),
    event_envelope(editor_event_scene_created("scenes/extra.scene.json")),
    event_envelope(editor_event_scene_saved("scenes/main.scene.json")),
    event_envelope(editor_event_scene_deleted("scenes/old.scene.json")),
    event_envelope(
      editor_event_asset_imported(
        @editor_bridge.asset_document(
          "assets/images/hero.png",
          @editor_bridge.infer_asset_kind("assets/images/hero.png"),
        ),
      ),
    ),
  ]
  for event in events {
    let decoded : EventEnvelope = @json.from_json(event.to_json())
    inspect(decoded == event, content="true")
  }
}

///|
test "invalid protocol payloads fail to decode" {
  let invalid_request : Result[RpcRequestEnvelope, Error] = try? @json.from_json(
    @json.parse("{\"id\":1}"),
  )
  let invalid_response : Result[RpcResponseEnvelope, Error] = try? @json.from_json(
    @json.parse("{\"id\":1,\"response\":{\"SavedOk\":{}}}"),
  )
  let invalid_event : Result[EventEnvelope, Error] = try? @json.from_json(
    @json.parse("{\"event\":{\"FilesChanged\":{}}}"),
  )
  match invalid_request {
    Err(_) => inspect(true, content="true")
    _ => fail("expected invalid request decode to fail")
  }
  match invalid_response {
    Err(_) => inspect(true, content="true")
    _ => fail("expected invalid response decode to fail")
  }
  match invalid_event {
    Err(_) => inspect(true, content="true")
    _ => fail("expected invalid event decode to fail")
  }
}
