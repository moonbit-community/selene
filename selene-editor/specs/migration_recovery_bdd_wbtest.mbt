///|
fn legacy_scene_json() -> String {
  "{\n  \"version\": 1,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"name\": \"Camera2d\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": {\n              \"x\": 0,\n              \"y\": 0\n            },\n            \"rotation\": 0,\n            \"scale\": {\n              \"x\": 1,\n              \"y\": 1\n            }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": {\n            \"is_active\": true,\n            \"order\": 0,\n            \"scale\": 1\n          }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": {\n            \"visible\": true\n          }\n        }\n      ]\n    }\n  ]\n}\n"
}

///|
async test "bdd recovery legacy startup scene asks for confirmation and cancel keeps file unchanged" {
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
    inspect(harness.pending_scene_migration() is Some(_), content="true")
    inspect(harness.status(), content="Legacy scene requires migration")

    harness.when_pending_scene_migration_is_cancelled()

    inspect(harness.scene() is None, content="true")
    inspect(harness.pending_scene_migration() is None, content="true")
    inspect(harness.preview_scene() is None, content="true")
    inspect(
      harness.read_scene_document_status("scenes/main.scene.json")
      is @editor_bridge.MigrationRequired(_),
      content="true",
    )
  })
}

///|
async test "bdd recovery legacy startup scene can be confirmed migrated and loaded" {
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
    inspect(harness.pending_scene_migration() is Some(_), content="true")

    harness.when_pending_scene_migration_is_confirmed()

    inspect(harness.scene() is Some(_), content="true")
    inspect(harness.pending_scene_migration() is None, content="true")
    inspect(harness.preview_scene() == harness.scene(), content="true")
    inspect(
      harness.read_scene_document("scenes/main.scene.json").name,
      content="Main",
    )
  })
}

///|
async test "bdd recovery invalid workspace falls back to defaults and still opens the project" {
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

    inspect(harness.scene() is Some(_), content="true")
    inspect(harness.selected_entity_id(), content="Some(\"camera\")")
    inspect(harness.status(), content="Loaded scenes/project.scene.json")
  })
}
