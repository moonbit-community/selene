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
    inspect(harness.scene_path(), content="scenes/project.scene.json")
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
    inspect(harness.scene_path(), content="scenes/project.scene.json")
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

///|
async test "bdd image assets can be added into the scene" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_image_asset("assets/images/hero.png")
    harness.when_editor_initialized()

    inspect(harness.assets().length(), content="1")
    inspect(harness.assets()[0].path, content="assets/images/hero.png")

    harness.when_sprite_asset_is_dropped("assets/images/hero.png", 96.0, 144.0)

    let entity_id = harness.selected_entity_id().unwrap_or("")
    let entity = harness.entity(entity_id).unwrap()
    let sprite : @editor_bridge.SpriteComponent = @app.component_of(
      entity,
      "Sprite",
    ).unwrap()
    let transform : @editor_bridge.Transform2dComponent = @app.component_of(
      entity,
      "Transform2d",
    ).unwrap()

    inspect(sprite.image_path, content="Some(\"assets/images/hero.png\")")
    inspect(transform.translation.x, content="96")
    inspect(transform.translation.y, content="144")
    inspect(
      harness.preview_selected_entity_id() == Some(entity_id),
      content="true",
    )
  })
}

///|
async test "bdd image to atlas to animation to prefab flow persists through editor resources" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_image_asset("assets/images/hero.png")
    harness.when_editor_initialized()
    harness.when_image_resource_is_selected("assets/images/hero.png")
    harness.when_selected_image_creates_atlas()

    inspect(harness.atlas_refs().length(), content="1")
    inspect(
      harness.selected_resource_path(),
      content="Some(\"assets/atlases/hero.atlas.json\")",
    )

    harness.when_selected_atlas_creates_animation()
    inspect(harness.animation_refs().length(), content="1")
    inspect(
      harness.selected_resource_path(),
      content="Some(\"assets/animations/hero.anim.json\")",
    )

    harness.when_selected_resource_is_inserted()
    let entity_id = harness.selected_entity_id().unwrap_or("")
    inspect(harness.entity(entity_id) is Some(_), content="true")

    harness.when_selected_entity_is_saved_as_prefab()
    inspect(harness.prefab_refs().length(), content="1")
    inspect(
      harness.selected_resource_path(),
      content="Some(\"prefabs/hero.prefab.json\")",
    )

    harness.when_selected_resource_is_inserted()
    inspect(harness.scene().unwrap().entities.length() > 2, content="true")
  })
}

///|
async test "bdd atlas and animation inspector edits persist to asset documents" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_image_asset("assets/images/hero.png")
    harness.when_editor_initialized()
    harness.when_image_resource_is_selected("assets/images/hero.png")
    harness.when_selected_image_creates_atlas()
    harness.when_selected_atlas_columns_are_edited("2")
    harness.when_selected_atlas_is_saved()

    let atlas = @editor_bridge.read_atlas_asset_document(
      harness.project_root_path() + "/assets/atlases/hero.atlas.json",
    )
    inspect(atlas.columns, content="2")
    inspect(atlas.regions.length(), content="2")

    harness.when_selected_atlas_creates_animation()
    harness.when_selected_animation_frames_are_edited("run_0, run_1")
    harness.when_selected_animation_is_saved()

    let animation = @editor_bridge.read_animation_asset_document(
      harness.project_root_path() + "/assets/animations/hero.anim.json",
    )
    inspect(animation.clips[0].frames.join(","), content="run_0,run_1")
  })
}

///|
async test "bdd scene browser and prefab inspector edits persist" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_current_scene_is_renamed("Gameplay")
    let scene = @editor_bridge.read_scene_document(
      harness.project_root_path() + "/" + harness.scene_path(),
    )
    inspect(scene.name, content="Gameplay")

    harness.when_text_entity_is_added()
    harness.when_selected_entity_is_saved_as_prefab()
    harness.when_selected_prefab_name_is_edited("dialog_text")
    harness.when_selected_prefab_is_saved()

    let prefab = @editor_bridge.read_prefab_document(
      harness.project_root_path() + "/prefabs/text.prefab.json",
    )
    inspect(prefab.name, content="dialog_text")
  })
}
