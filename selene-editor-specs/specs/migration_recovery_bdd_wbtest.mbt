///|
fn legacy_scene_json() -> String {
  "{\n  \"version\": 2,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"name\": \"Camera2d\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": {\n              \"x\": 0,\n              \"y\": 0\n            },\n            \"rotation\": 0,\n            \"scale\": {\n              \"x\": 1,\n              \"y\": 1\n            }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": {\n            \"is_active\": true,\n            \"order\": 0,\n            \"scale\": 1\n          }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": {\n            \"visible\": true\n          }\n        }\n      ]\n    }\n  ]\n}\n"
}

///|
async test "bdd recovery legacy startup scene fails open without migration flow" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default(
        "Project",
        startup_scene="scenes/main.scene.json",
      ),
    )
    harness.given_text_file("scenes/main.scene.json", legacy_scene_json())
    harness.when_editor_initialized()

    inspect(harness.scene() is None, content="true")
    inspect(harness.pending_scene_migration() is None, content="true")
    inspect(
      harness.status(),
      content="Scene load failed. Check browser console for details.",
    )
    let scene_status_result : Result[@editor_bridge.SceneDocumentLoadStatus, Error] =
      try? harness.read_scene_document_status("scenes/main.scene.json")
    match scene_status_result {
      Err(@editor_bridge.InvalidSceneDocument(_)) =>
        inspect(true, content="true")
      _ => fail("expected legacy scene decode to fail")
    }
  })
}

///|
async test "bdd recovery confirm/cancel migration are no-op without pending migration" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default(
        "Project",
        startup_scene="scenes/main.scene.json",
      ),
    )
    harness.given_text_file("scenes/main.scene.json", legacy_scene_json())

    harness.when_editor_initialized()
    inspect(harness.pending_scene_migration() is None, content="true")

    harness.when_pending_scene_migration_is_confirmed()
    harness.when_pending_scene_migration_is_cancelled()

    inspect(harness.scene() is None, content="true")
    inspect(harness.pending_scene_migration() is None, content="true")
    inspect(
      harness.status(),
      content="Scene load failed. Check browser console for details.",
    )
  })
}

///|
async test "bdd recovery invalid workspace blocks open with stable project error state" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default("Project"),
    )
    harness.given_scene_document(
      "scenes/project.scene.json",
      @editor_bridge.SceneDocument::default_main(),
    )
    harness.given_text_file(".selene-editor/workspace.json", "{\"version\":")

    harness.when_editor_initialized()

    inspect(harness.scene() is None, content="true")
    inspect(harness.selected_entity_id(), content="None")
    inspect(
      harness.status(),
      content="Project open failed. Check browser console for details.",
    )
    inspect(harness.logs().length() > 0, content="true")
  })
}

///|
async test "bdd recovery legacy project manifest is rejected on open" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_text_file(
      "selene.project.json", "{\n  \"version\": 2,\n  \"name\": \"Project\",\n  \"startup_scene\": \"scenes/main.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
    )
    harness.given_scene_document(
      "scenes/main.scene.json",
      @editor_bridge.SceneDocument::default_main(),
    )

    harness.when_editor_initialized()

    inspect(harness.scene() is None, content="true")
    inspect(harness.manifest() is None, content="true")
    inspect(
      harness.status(),
      content="Project open failed. Check browser console for details.",
    )
    let manifest_result : Result[@editor_bridge.ProjectManifest, Error] =
      try? @editor_bridge.decode_project_manifest(
        @json.parse(
          @fs.read_file(harness.project_root_path() + "/selene.project.json").text(),
        ),
      )
    match manifest_result {
      Err(@editor_bridge.InvalidProjectManifest(_)) =>
        inspect(true, content="true")
      _ => fail("expected legacy project manifest decode to fail")
    }
  })
}
