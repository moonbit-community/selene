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

///|
async test "bdd error ux unsaved scene is not rolled back when toggling snap" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_sprite_entity_is_added()

    let before_toggle = harness.scene()
    inspect(harness.scene_dirty(), content="true")

    harness.when_move_snap_is_toggled()

    inspect(harness.scene_dirty(), content="true")
    inspect(harness.scene() == before_toggle, content="true")
  })
}

///|
async test "bdd error ux workspace delta never reloads dirty scene session" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_sprite_entity_is_added()
    let before_delta = harness.scene()

    harness.when_workspace_delta_is_received()

    inspect(harness.scene_dirty(), content="true")
    inspect(harness.scene() == before_delta, content="true")
    inspect(harness.status(), content="Workspace settings updated")
  })
}

///|
async test "bdd error ux dirty scene file delta enters explicit conflict state" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_sprite_entity_is_added()

    harness.when_scene_file_delta_is_received(
      harness.scene_path(),
      "disk-hash",
      22,
    )

    inspect(harness.scene_dirty(), content="true")
    inspect(
      harness.status(),
      content="Scene changed on disk while local edits are unsaved",
    )
    match harness.scene_conflict_state() {
      Some(@app.ExternalSceneChanged(path~, disk_hash~, disk_revision~)) => {
        inspect(path, content=harness.scene_path())
        inspect(disk_hash, content="disk-hash")
        inspect(disk_revision, content="22")
      }
      _ => fail("expected external scene conflict state")
    }
  })
}

///|
async test "bdd error ux keep mine clears conflict without dropping local edits" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_sprite_entity_is_added()
    let before = harness.scene()

    harness.when_scene_file_delta_is_received(
      harness.scene_path(),
      "disk-hash",
      22,
    )
    harness.when_conflict_keep_mine_is_selected()

    inspect(harness.scene() == before, content="true")
    inspect(harness.scene_dirty(), content="true")
    inspect(harness.status(), content="Keeping local scene edits")
    match harness.scene_conflict_state() {
      Some(@app.NoConflict) => inspect(true, content="true")
      _ => fail("expected conflict state to be cleared")
    }
  })
}

///|
async test "bdd error ux reload disk resolves conflict and restores clean session" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_sprite_entity_is_added()
    let disk_scene = @editor_bridge.SceneDocument::default_main().with_name(
      "Disk Version",
    )
    harness.given_scene_document(harness.scene_path(), disk_scene)

    harness.when_scene_file_delta_is_received(
      harness.scene_path(),
      "disk-hash",
      22,
    )
    harness.when_conflict_reload_disk_is_selected()

    inspect(harness.scene_dirty(), content="false")
    inspect(harness.scene().unwrap().name, content="Disk Version")
    inspect(harness.status(), content="Loaded " + harness.scene_path())
    match harness.scene_conflict_state() {
      Some(@app.NoConflict) => inspect(true, content="true")
      _ => fail("expected conflict state to be cleared")
    }
  })
}
