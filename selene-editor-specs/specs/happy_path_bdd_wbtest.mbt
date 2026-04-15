///|
async test "bdd happy path creates a startup scene and syncs preview" {
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
  })
}

///|
async test "bdd happy path keeps selection synchronized between scene tree and preview" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    ignore(harness.take_preview_commands())

    harness.when_text_entity_is_added()
    let text_id = harness.selected_entity_id().unwrap_or("")
    inspect(
      harness.preview_selected_entity_id(),
      content="Some(\"\{text_id}\")",
    )

    harness.when_scene_tree_selects_entity(Some("camera"))
    inspect(harness.preview_selected_entity_id(), content="Some(\"camera\")")

    harness.when_preview_picks_entity(Some(text_id))
    inspect(harness.selected_entity_id(), content="Some(\"\{text_id}\")")
  })
}

///|
async test "bdd happy path persists inspector edits after save" {
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

    let persisted = harness.read_scene_document(harness.scene_path())
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
async test "bdd happy path adding and deleting entities updates scene and selection" {
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
async test "bdd happy path places image assets into the scene" {
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
      entity, "Sprite",
    ).unwrap()
    let transform : @editor_bridge.Transform2dComponent = @app.component_of(
      entity, "Transform2d",
    ).unwrap()

    inspect(sprite.image_path, content="Some(\"assets/images/hero.png\")")
    inspect(transform.translation.x, content="96")
    inspect(transform.translation.y, content="144")
  })
}

///|
async test "bdd happy path persists image to atlas to animation to prefab flow" {
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
    inspect(
      harness.selected_resource_path(),
      content="Some(\"assets/animation_clips/hero-clip.clip.json\")",
    )
    inspect(harness.animation_refs().length(), content="0")

    harness.when_selected_animation_clip_creates_graph()
    inspect(harness.animation_refs().length(), content="1")

    harness.when_selected_resource_is_inserted()
    let entity_id = harness.selected_entity_id().unwrap_or("")
    inspect(harness.entity(entity_id) is Some(_), content="true")

    harness.when_selected_entity_is_saved_as_prefab()
    inspect(harness.prefab_refs().length(), content="1")

    harness.when_selected_resource_is_inserted()
    inspect(harness.scene().unwrap().entities.length() > 2, content="true")
  })
}

///|
async test "bdd happy path persists atlas and animation inspector edits" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.given_image_asset("assets/images/hero.png")
    harness.when_editor_initialized()
    harness.when_image_resource_is_selected("assets/images/hero.png")
    harness.when_selected_image_creates_atlas()
    harness.when_selected_atlas_columns_are_edited("2")
    harness.when_selected_atlas_is_saved()

    let atlas = harness.read_atlas_document("assets/atlases/hero.atlas.json")
    inspect(atlas.columns, content="2")
    inspect(atlas.regions.length(), content="2")

    harness.when_selected_atlas_creates_animation()
    harness.when_selected_animation_frames_are_edited("run_0, run_1")
    harness.when_selected_animation_is_saved()

    let animation = harness.read_animation_document(
      "assets/animation_clips/hero-clip.clip.json",
    )
    inspect(animation.frames.join(","), content="run_0,run_1")
  })
}

///|
async test "bdd happy path persists scene browser and prefab inspector edits" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_current_scene_is_renamed("Gameplay")
    let scene = harness.read_scene_document(harness.scene_path())
    inspect(scene.name, content="Gameplay")

    harness.when_text_entity_is_added()
    harness.when_selected_entity_is_saved_as_prefab()
    harness.when_selected_prefab_name_is_edited("dialog_text")
    harness.when_selected_prefab_is_saved()

    let prefab = harness.read_prefab_document("prefabs/text.prefab.json")
    inspect(prefab.name, content="dialog_text")
  })
}

///|
async test "bdd happy path add component auto-fills dependencies and survives reopen" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_scene_tree_selects_entity(Some("camera"))
    harness.when_builtin_component_is_added(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    )

    inspect(harness.entity_has_component("camera", "Sprite"), content="true")
    inspect(
      harness.entity_has_component("camera", "TextureAtlas"),
      content="true",
    )
    inspect(
      harness.entity_has_component("camera", "AnimationPlayer"),
      content="true",
    )
    inspect(
      harness.entity_has_component("camera", "AnimationTransitions"),
      content="true",
    )

    harness.when_scene_is_saved()
    harness.when_project_opened()

    inspect(harness.entity_has_component("camera", "Sprite"), content="true")
    inspect(
      harness.entity_has_component("camera", "AnimationTransitions"),
      content="true",
    )
  })
}

///|
async test "bdd happy path remove component enforces dependency guardrails" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_scene_tree_selects_entity(Some("camera"))
    harness.when_builtin_component_is_added(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    )

    harness.when_component_is_removed("Sprite")

    inspect(harness.entity_has_component("camera", "Sprite"), content="true")
    inspect(harness.status().contains("Cannot remove Sprite"), content="true")
  })
}

///|
async test "bdd happy path custom json component persists after save and reopen" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_scene_tree_selects_entity(Some("camera"))
    harness.when_custom_component_is_added("GameplayTag")
    harness.when_custom_component_json_is_edited("GameplayTag", "{\"hp\":10}")
    harness.when_custom_component_json_is_committed("GameplayTag")
    harness.when_scene_is_saved()
    harness.when_project_opened()

    let scene = harness.read_scene_document(harness.scene_path())
    let camera = scene.entity("camera").unwrap()
    let gameplay_tag = camera.component("GameplayTag").unwrap()
    inspect(gameplay_tag.data == @json.parse("{\"hp\":10}"), content="true")
  })
}

///|
async test "bdd happy path autotile paint undo redo and save-reopen stay consistent" {
  @async.with_task_group(group => {
    let harness = given_editor_harness()
    group.add_defer(() => harness.cleanup())

    harness.when_editor_initialized()
    harness.when_scene_tree_selects_entity(Some("camera"))
    harness.when_builtin_component_is_added(
      @editor_bridge.builtin_component_kind_from_string("AutoTileLayer2d").unwrap(),
    )
    harness.when_selected_autotile_atlas_path_is_edited(
      "assets/atlases/world.atlas.json",
    )

    harness.when_selected_autotile_rule_set_is_edited("bitmask4")
    harness.when_selected_autotile_palette_json_is_edited(
      "[{\"terrain\":1,\"fallback_region_name\":\"terrain_0\",\"fallback_atlas_index\":0,\"bitmask4_rules\":[{\"mask\":0,\"region_name\":\"terrain_0\",\"atlas_index\":0}],\"bitmask8_rules\":[],\"wang_rules\":[]}]",
    )
    harness.when_selected_autotile_palette_json_is_committed()

    let configured_layer = harness.autotile_layer_component("camera").unwrap()
    inspect(
      configured_layer.rule_set == @editor_bridge.autotile_rule_set_bitmask4(),
      content="true",
    )
    inspect(configured_layer.palette.length(), content="1")

    harness.when_tool_is_set(@shared.preview_tool_autotile_paint())
    let commands = harness.take_preview_commands()
    inspect(commands.length() > 0, content="true")

    let painted : @editor_bridge.AutoTileLayer2dComponent = @json.from_json(
      @editor_bridge.autotile_layer2d_component(
        tile_size=configured_layer.tile_size,
        origin=configured_layer.origin,
        atlas_asset_path=configured_layer.atlas_asset_path,
        rule_set=configured_layer.rule_set,
        palette=configured_layer.palette,
        cells=[@editor_bridge.autotile_cell_document(0, 0, 1)],
      ).data,
    )
    harness.when_preview_updates_autotile_layer("camera", painted)

    inspect(
      harness.autotile_layer_component("camera").unwrap().cells.length(),
      content="1",
    )

    harness.when_scene_undo_is_requested()
    inspect(
      harness.autotile_layer_component("camera").unwrap().cells.length(),
      content="0",
    )

    harness.when_scene_redo_is_requested()
    inspect(
      harness.autotile_layer_component("camera").unwrap().cells.length(),
      content="1",
    )

    harness.when_scene_is_saved()
    harness.when_project_opened()

    let persisted = harness.read_scene_document(harness.scene_path())
    let camera = persisted.entity("camera").unwrap()
    let persisted_layer : @editor_bridge.AutoTileLayer2dComponent = @app.component_of(
      camera, "AutoTileLayer2d",
    ).unwrap()
    inspect(persisted_layer.cells.length(), content="1")
    inspect(
      persisted_layer.rule_set == @editor_bridge.autotile_rule_set_bitmask4(),
      content="true",
    )
  })
}
