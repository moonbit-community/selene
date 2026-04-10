///|
async test "bdd error ux folder picker cancel leaves the editor unopened" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_project_folder_pick_is_cancelled()

    inspect(harness.current_root() is None, content="true")
    inspect(harness.scene() is None, content="true")
    inspect(harness.status(), content="Open a project to begin")
  })
}

///|
async test "bdd error ux invalid project manifest surfaces a clear project error" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_text_file(
      "selene.project.json", "{\n  \"version\": 1,\n  \"startup_scene\": \"scenes/main.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
    )

    harness.when_editor_initialized()

    inspect(
      harness.status(),
      content="Project open failed. Check browser console for details.",
    )
    inspect(harness.scene() is None, content="true")
  })
}

///|
async test "bdd error ux missing startup scene surfaces a stable not found message" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default(
        "Project",
        startup_scene="scenes/main.scene.json",
      ),
    )

    harness.when_editor_initialized()

    inspect(
      harness.status(),
      content="Scene load failed. Check browser console for details.",
    )
    inspect(harness.scene() is None, content="true")
  })
}

///|
async test "bdd error ux unrecoverable bad startup scene never leaks raw json decode errors" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default(
        "Project",
        startup_scene="scenes/main.scene.json",
      ),
    )
    harness.given_text_file(
      "scenes/main.scene.json", "{\"version\":1,\"entities\":",
    )

    harness.when_editor_initialized()

    inspect(
      harness.status(),
      content="Scene load failed. Check browser console for details.",
    )
    inspect(
      harness.status().contains("JsonDecodeError") == false,
      content="true",
    )
    inspect(harness.scene() is None, content="true")
  })
}

///|
async test "bdd error ux deleting the last scene is rejected without side effects" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    let before = harness.scene_path()

    harness.when_current_scene_is_deleted()

    inspect(harness.status(), content="Cannot delete the last scene")
    inspect(harness.scene_path(), content=before)
    inspect(harness.scene() is Some(_), content="true")
  })
}

///|
async test "bdd error ux invalid resource documents do not prevent opening the current scene" {
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
    harness.given_text_file(
      "prefabs/broken.prefab.json", "{\n  \"version\": 1,\n  \"name\": \"\",\n  \"entities\": []\n}\n",
    )
    harness.given_text_file(
      "assets/atlases/broken.atlas.json", "{\n  \"version\": 1,\n  \"name\": \"Broken\",\n  \"source_image\": \"assets/images/hero.png\",\n  \"tile_size\": {\"x\": 0, \"y\": 0},\n  \"columns\": 0,\n  \"rows\": 0,\n  \"spacing\": {\"x\": 0, \"y\": 0},\n  \"margin\": {\"x\": 0, \"y\": 0},\n  \"default_anchor\": {\"x\": 0.5, \"y\": 0.5},\n  \"regions\": []\n}\n",
    )
    harness.given_text_file(
      "assets/animation_clips/broken.clip.json", "{\n  \"version\": 3,\n  \"name\": \"Broken\"\n}\n",
    )

    harness.when_editor_initialized()

    inspect(harness.scene() is Some(_), content="true")
    inspect(
      harness.status(),
      content="Animation clip load failed: Animation clip document is invalid: assets/animation_clips/broken.clip.json",
    )
    inspect(harness.logs().length() >= 3, content="true")
  })
}

///|
async test "bdd error ux scenes with missing image references still open" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    let scene = @editor_bridge.SceneDocument::default_main().with_entity(
      @editor_bridge.entity_document("hero", "Hero", components=[
        @editor_bridge.transform2d_component(),
        @editor_bridge.visibility_component(),
        @editor_bridge.sprite_component(
          image_path=Some("assets/images/missing.png"),
        ),
      ]),
    )
    harness.given_project_manifest(
      @editor_bridge.ProjectManifest::default("Project"),
    )
    harness.given_scene_document("scenes/project.scene.json", scene)

    harness.when_editor_initialized()

    inspect(harness.scene() is Some(_), content="true")
    inspect(harness.preview_scene() == harness.scene(), content="true")
    inspect(harness.status(), content="Loaded scenes/project.scene.json")
  })
}

///|
async test "bdd error ux service stream failures keep the current scene stable" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    let loaded = harness.scene()

    harness.when_service_event_fails("connection dropped")

    inspect(harness.status(), content="SSE error")
    inspect(harness.scene() == loaded, content="true")
    inspect(harness.logs().length() >= 1, content="true")
  })
}
