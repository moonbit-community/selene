///|
async test "bdd project flow creates a startup scene and syncs preview" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()

    inspect(
      harness.current_root() == Some(harness.project_root_path()),
      content="true",
    )
    inspect(harness.scene_path(), content="scenes/main.scene.json")
    inspect(
      @fs.exists(
        harness.project_root_path() +
        "/" +
        @editor_bridge.project_manifest_file_name("anything"),
      ),
      content="true",
    )
    inspect(harness.selected_entity_id() == Some("camera"), content="true")
    inspect(harness.preview_bootstrapped(), content="true")
    inspect(harness.preview_scene() == harness.scene(), content="true")
    inspect(
      harness.preview_selected_entity_id() == Some("camera"),
      content="true",
    )
  })
}

///|
async test "bdd opening an empty folder auto-creates a project" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()

    inspect(
      harness.current_root() == Some(harness.project_root_path()),
      content="true",
    )
    inspect(harness.scene_path(), content="scenes/main.scene.json")
    inspect(harness.preview_scene() == harness.scene(), content="true")
    inspect(
      harness.preview_selected_entity_id() == Some("camera"),
      content="true",
    )
  })
}

///|
async test "bdd selection syncs between scene tree and preview" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    ignore(harness.take_preview_commands())

    harness.when_text_entity_is_added()
    let text_id = harness.selected_entity_id().unwrap_or("")

    inspect(
      harness.preview_selected_entity_id() == Some(text_id),
      content="true",
    )

    harness.when_scene_tree_selects_entity(Some("camera"))
    inspect(
      harness.preview_selected_entity_id() == Some("camera"),
      content="true",
    )

    harness.when_preview_picks_entity(Some(text_id))
    inspect(harness.selected_entity_id() == Some(text_id), content="true")
  })
}

///|
async test "bdd inspector edits persist after save" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_text_entity_is_added()
    let entity_id = harness.selected_entity_id().unwrap_or("")

    harness.when_selected_translate_x_is_edited("128")
    harness.when_selected_translate_y_is_edited("72")
    harness.when_selected_text_is_edited("Hello from BDD")
    harness.when_selected_visibility_is_toggled()
    harness.when_scene_is_saved()

    let persisted = @editor_bridge.read_scene_document(
      harness.project_root_path() + "/" + harness.scene_path(),
    )
    let entity = persisted.entity(entity_id).unwrap()
    let transform : @editor_bridge.Transform2dComponent = @app.component_of(
      entity, "Transform2d",
    ).unwrap_or(@editor_bridge.transform2d_value())
    let text_value : @editor_bridge.Text2dComponent? = @app.component_of(
      entity, "Text2d",
    )
    let visibility_value : @editor_bridge.VisibilityComponent? = @app.component_of(
      entity, "Visibility",
    )

    inspect(text_value is Some(_), content="true")
    inspect(visibility_value is Some(_), content="true")
    inspect(transform.translation.x, content="128")
    inspect(transform.translation.y, content="72")
    inspect(text_value.unwrap().content, content="Hello from BDD")
    inspect(visibility_value.unwrap().visible, content="false")
  })
}

///|
async test "bdd adding and deleting entities updates scene and selection" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    ignore(harness.take_preview_commands())

    harness.when_sprite_entity_is_added()
    let entity_id = harness.selected_entity_id().unwrap_or("")

    inspect(harness.entity(entity_id) is Some(_), content="true")
    inspect(
      harness.preview_selected_entity_id() == Some(entity_id),
      content="true",
    )

    harness.when_selected_entity_is_deleted()

    inspect(harness.entity(entity_id) is None, content="true")
    inspect(harness.selected_entity_id() is None, content="true")
    inspect(harness.preview_selected_entity_id() is None, content="true")
  })
}
