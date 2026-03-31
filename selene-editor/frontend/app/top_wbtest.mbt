///|
test "initialize subscribes to service and preview channels" {
  let (effects, _) = update(msg_initialize(), new_model())
  inspect(effects.length(), content="4")
}

///|
test "pick project root result auto-opens the chosen directory" {
  let (_, model) = update(msg_pick_project_root(), new_model())
  let (effects, next) = update(
    msg_project_root_picked(
      Ok(@shared.directory_pick_result(Some("/tmp/demo-project"))),
    ),
    model,
  )
  inspect(effects.length(), content="1")
  inspect(next.project_root_input, content="/tmp/demo-project")
  inspect(next.status, content="Opening project...")
}

///|
test "cancelled folder picker keeps the editor in entry state" {
  let (_, model) = update(msg_pick_project_root(), new_model())
  let (effects, next) = update(
    msg_project_root_picked(Ok(@shared.directory_pick_result(None))),
    model,
  )
  inspect(effects.length(), content="0")
  inspect(next.status, content="Open a project to begin")
}

///|
test "open project asks the service for a directory" {
  let (effects, next) = update(msg_open_project(), new_model())
  inspect(effects.length(), content="1")
  inspect(next.status, content="Choose a project folder...")
}

///|
test "hover hint updates the shared info bar state" {
  let (_, hinted) = update(msg_set_hover_hint(Some("Save Scene")), new_model())
  inspect(hinted.hover_hint, content="Some(\"Save Scene\")")
  let (_, cleared) = update(msg_set_hover_hint(None), hinted)
  inspect(cleared.hover_hint, content="None")
}

///|
test "clear selection resets active inspector context" {
  let model = {
    ..new_model(),
    selected_entity_id: Some("camera"),
    selected_resource: Some(resource_selection_image("assets/images/hero.png")),
    add_component_panel_open: true,
    open_component_menu_kind: Some("Transform2d"),
    workspace: @editor_bridge.WorkspaceDocument::default().with_selected_entity_id(
      Some("camera"),
    ),
  }
  let (effects, cleared) = update(msg_clear_selection(), model)
  inspect(effects.length(), content="3")
  inspect(cleared.selected_entity_id, content="None")
  inspect(cleared.selected_resource, content="None")
  inspect(cleared.add_component_panel_open, content="false")
  inspect(cleared.open_component_menu_kind, content="None")
  inspect(cleared.workspace.selected_entity_id, content="None")
  inspect(cleared.status, content="Selection cleared")
}

///|
test "asset tree folder toggle is state-driven" {
  let model = new_model()
  inspect(model.asset_tree_folder_expanded("images:assets"), content="true")

  let (_, collapsed) = update(
    msg_toggle_asset_tree_folder("images:assets"),
    model,
  )
  inspect(
    collapsed.asset_tree_folder_expanded("images:assets"),
    content="false",
  )

  let (_, expanded) = update(
    msg_toggle_asset_tree_folder("images:assets"),
    collapsed,
  )
  inspect(expanded.asset_tree_folder_expanded("images:assets"), content="true")
}

///|
test "selecting nested asset auto-expands ancestor folders" {
  let model = {
    ..new_model(),
    assets: [
      @editor_bridge.asset_document(
        "assets/pixeladventure/Menu/Buttons/Volume.png",
        @editor_bridge.infer_asset_kind(
          "assets/pixeladventure/Menu/Buttons/Volume.png",
        ),
      ),
    ],
  }
  let (_, next) = update(
    msg_select_resource(
      Some(
        resource_selection_image(
          "assets/pixeladventure/Menu/Buttons/Volume.png",
        ),
      ),
    ),
    model,
  )
  inspect(
    next.asset_tree_folder_expanded("images:pixeladventure"),
    content="true",
  )
  inspect(
    next.asset_tree_folder_expanded("images:pixeladventure/Menu"),
    content="true",
  )
  inspect(
    next.asset_tree_folder_expanded("images:pixeladventure/Menu/Buttons"),
    content="true",
  )
}

///|
test "expand and collapse all asset folders update tree state" {
  let model = {
    ..new_model(),
    assets: [
      @editor_bridge.asset_document(
        "assets/pixeladventure/Menu/Buttons/Volume.png",
        @editor_bridge.infer_asset_kind(
          "assets/pixeladventure/Menu/Buttons/Volume.png",
        ),
      ),
    ],
  }
  let (_, collapsed) = update(msg_collapse_all_asset_folders(), model)
  inspect(
    collapsed.asset_tree_folder_expanded("images:pixeladventure"),
    content="false",
  )
  inspect(
    collapsed.asset_tree_folder_expanded("images:pixeladventure/Menu"),
    content="false",
  )

  let (_, expanded) = update(msg_expand_all_asset_folders(), collapsed)
  inspect(
    expanded.asset_tree_folder_expanded("images:pixeladventure"),
    content="true",
  )
  inspect(
    expanded.asset_tree_folder_expanded("images:pixeladventure/Menu"),
    content="true",
  )
}

///|
test "project load refreshes both scene and asset list" {
  let (_, model) = update(msg_initialize(), new_model())
  let (effects, next) = update(
    msg_project_loaded(
      Ok(
        @shared.project_state_response(
          Some("/tmp/demo"),
          Some(@editor_bridge.ProjectManifest::default("demo")),
          [],
          [],
          [],
          [],
          None,
          [],
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="4")
  inspect(next.current_root, content="Some(\"/tmp/demo\")")
}

///|
test "project load applies persisted move-snap workspace settings" {
  let workspace = @editor_bridge.WorkspaceDocument::default()
    .with_move_snap_enabled(true)
    .with_move_snap_step(20.0)
  let (effects, next) = update(
    msg_project_loaded(
      Ok(
        @shared.project_state_response(
          Some("/tmp/demo"),
          Some(@editor_bridge.ProjectManifest::default("demo")),
          [],
          [],
          [],
          [],
          Some(workspace),
          [],
        ),
      ),
    ),
    new_model(),
  )
  inspect(effects.length(), content="4")
  inspect(next.move_snap_enabled, content="true")
  inspect(next.move_snap_step, content="16")
}

///|
test "scene migration confirmation gates legacy scene loading" {
  let preview = @editor_bridge.scene_migration_preview(
    "scenes/main.scene.json",
    @editor_bridge.SceneDocument::default_main(),
    [
      @editor_bridge.migration_field_change(
        "name", "Missing required scene name", "Main",
      ),
    ],
  )
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
  }
  let (effects, gated) = update(
    msg_scene_loaded(Ok(@shared.scene_load_outcome_migration_required(preview))),
    model,
  )
  inspect(effects.length(), content="1")
  inspect(gated.pending_scene_migration is Some(_), content="true")
  inspect(gated.scene is None, content="true")

  let (confirm_effects, confirming) = update(
    msg_confirm_scene_migration(),
    gated,
  )
  inspect(confirm_effects.length(), content="1")
  inspect(confirming.status, content="Migrating scenes/main.scene.json...")
}

///|
test "cancelling scene migration keeps the scene unloaded" {
  let preview = @editor_bridge.scene_migration_preview(
    "scenes/main.scene.json",
    @editor_bridge.SceneDocument::default_main(),
    [],
  )
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    pending_scene_migration: Some(preview),
  }
  let (effects, next) = update(msg_cancel_scene_migration(), model)
  inspect(effects.length(), content="1")
  inspect(next.scene is None, content="true")
  inspect(next.pending_scene_migration is None, content="true")
  inspect(next.status, content="Scene migration cancelled")
}

///|
test "selecting an asset does not create a scene entity" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(scene),
  }
  let (_effects, next) = update(
    msg_select_resource(Some(Image("assets/hero.png"))),
    model,
  )
  inspect(next.selected_resource, content="Some(Image(\"assets/hero.png\"))")
  inspect(next.scene.unwrap().entities.length(), content="1")
}

///|
test "move selected resource follows visible asset ordering" {
  let model = {
    ..new_model(),
    selected_entity_id: Some("camera"),
    assets: [
      @editor_bridge.asset_document(
        "assets/images/zebra.png",
        @editor_bridge.infer_asset_kind("assets/images/zebra.png"),
      ),
      @editor_bridge.asset_document(
        "assets/images/apple.png",
        @editor_bridge.infer_asset_kind("assets/images/apple.png"),
      ),
    ],
  }
  let (_, first) = update(msg_move_selected_resource(1), model)
  inspect(
    first.selected_resource,
    content="Some(Image(\"assets/images/apple.png\"))",
  )
  inspect(first.selected_entity_id, content="None")

  let (_, second) = update(msg_move_selected_resource(1), first)
  inspect(
    second.selected_resource,
    content="Some(Image(\"assets/images/zebra.png\"))",
  )

  let (_, back) = update(msg_move_selected_resource(-1), second)
  inspect(
    back.selected_resource,
    content="Some(Image(\"assets/images/apple.png\"))",
  )
}

///|
test "move selected resource respects section visibility" {
  let atlas = @editor_bridge.atlas_asset_document_from_image(
    "hero",
    "assets/images/hero.png",
    @editor_bridge.vec2_doc(32.0, 32.0),
  )
  let model = {
    ..new_model(),
    images_section_expanded: false,
    atlas_refs: [@editor_bridge.asset_ref("assets/atlases/hero.atlas.json")],
    atlas_documents: { "assets/atlases/hero.atlas.json": atlas },
  }
  let (_, next) = update(msg_move_selected_resource(1), model)
  inspect(
    next.selected_resource,
    content="Some(Atlas(\"assets/atlases/hero.atlas.json\"))",
  )
}

///|
test "adding a sprite from an asset uses the resolved asset size" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(scene),
    asset_sizes: { "assets/hero.png": @editor_bridge.vec2_doc(32.0, 48.0) },
  }
  let (_effects, next) = update(
    msg_add_sprite_from_asset("assets/hero.png"),
    model,
  )
  inspect(next.selected_entity_id, content="Some(\"entity-1\")")
  let entity = next.scene.unwrap().entity("entity-1").unwrap()
  let sprite : @editor_bridge.SpriteComponent = component_of(entity, "Sprite").unwrap()
  let transform : @editor_bridge.Transform2dComponent = component_of(
    entity, "Transform2d",
  ).unwrap()
  inspect(sprite.image_path, content="Some(\"assets/hero.png\")")
  inspect(sprite.custom_size, content="Some({x: 32, y: 48})")
  inspect(transform.translation.x, content="0")
  inspect(transform.translation.y, content="0")
}

///|
test "creating an atlas from a selected image updates resource state" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    assets: [
      @editor_bridge.asset_document(
        "assets/images/hero.png",
        @editor_bridge.infer_asset_kind("assets/images/hero.png"),
      ),
    ],
    asset_sizes: {
      "assets/images/hero.png": @editor_bridge.vec2_doc(32.0, 48.0),
    },
    selected_resource: Some(resource_selection_image("assets/images/hero.png")),
  }
  let (effects, next) = update(msg_create_atlas_from_selected_image(), model)
  inspect(effects.length(), content="1")
  inspect(next.atlas_refs.length(), content="1")
  inspect(
    next.selected_resource,
    content="Some(Atlas(\"assets/atlases/hero.atlas.json\"))",
  )
}

///|
test "editing a selected atlas updates the atlas document and save emits rpc" {
  let atlas = @editor_bridge.atlas_asset_document_from_image(
    "hero",
    "assets/images/hero.png",
    @editor_bridge.vec2_doc(32.0, 48.0),
  )
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    atlas_refs: [@editor_bridge.asset_ref("assets/atlases/hero.atlas.json")],
    atlas_documents: { "assets/atlases/hero.atlas.json": atlas },
    selected_resource: Some(
      resource_selection_atlas("assets/atlases/hero.atlas.json"),
    ),
  }
  let (_, edited) = update(msg_update_selected_atlas_columns("2"), model)
  let updated = edited.atlas_documents
    .get("assets/atlases/hero.atlas.json")
    .unwrap()
  inspect(updated.columns, content="2")
  inspect(updated.regions.length(), content="2")

  let (effects, saving) = update(msg_save_selected_atlas(), edited)
  inspect(effects.length(), content="1")
  inspect(saving.status, content="Saving atlas...")
}

///|
test "editing a selected animation updates the animation document and save emits rpc" {
  let animation = @editor_bridge.animation_asset_document_from_frames(
    "hero",
    "assets/atlases/hero.atlas.json",
    ["idle_0", "idle_1"],
  )
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    animation_refs: [
      @editor_bridge.asset_ref("assets/animations/hero.anim.json"),
    ],
    animation_documents: { "assets/animations/hero.anim.json": animation },
    selected_resource: Some(
      resource_selection_animation("assets/animations/hero.anim.json"),
    ),
  }
  let (_, edited) = update(
    msg_update_selected_animation_clip_frames("run_0, run_1"),
    model,
  )
  let updated = edited.animation_documents
    .get("assets/animations/hero.anim.json")
    .unwrap()
  inspect(updated.clips[0].frames.join(","), content="run_0,run_1")

  let (effects, saving) = update(msg_save_selected_animation(), edited)
  inspect(effects.length(), content="1")
  inspect(saving.status, content="Saving animation...")
}

///|
test "renaming the current scene updates the scene document and save emits rpc" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene_path: "scenes/demo.scene.json",
    scene: Some(scene),
  }
  let (effects, next) = update(msg_rename_current_scene("Gameplay"), model)
  inspect(effects.length() > 0, content="true")
  inspect(next.status, content="Renaming scene...")
  inspect(next.scene.unwrap().name, content="Gameplay")
}

///|
test "project and scene load errors update status and logs" {
  let (_, project_error) = update(
    msg_project_loaded(Err("Project manifest is invalid: selene.project.json")),
    new_model(),
  )
  inspect(
    project_error.status,
    content="Project open failed. Check browser console for details.",
  )
  inspect(project_error.logs.length(), content="1")

  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
  }
  let (_, scene_error) = update(
    msg_scene_loaded(Err("Scene document is invalid: scenes/main.scene.json")),
    model,
  )
  inspect(
    scene_error.status,
    content="Scene load failed. Check browser console for details.",
  )
  inspect(scene_error.logs.length(), content="1")
}

///|
test "delete current scene rejects deleting the last scene" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene_refs: [@editor_bridge.scene_ref("scenes/main.scene.json")],
    scene_path: "scenes/main.scene.json",
  }
  let (effects, next) = update(msg_delete_current_scene(), model)
  inspect(effects.length(), content="0")
  inspect(next.status, content="Cannot delete the last scene")
  inspect(next.logs.length(), content="1")
}

///|
test "asset and resource load errors remain user-facing and non-fatal" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
  }
  let (_, assets_error) = update(
    msg_assets_loaded(Err("Asset scan failed")),
    model,
  )
  inspect(assets_error.status, content="Assets load failed: Asset scan failed")

  let (_, prefab_error) = update(
    msg_prefab_loaded(
      Err("Prefab document is invalid: prefabs/hero.prefab.json"),
    ),
    assets_error,
  )
  inspect(
    prefab_error.status,
    content="Prefab load failed: Prefab document is invalid: prefabs/hero.prefab.json",
  )

  let (_, atlas_error) = update(
    msg_atlas_loaded(
      Err("Atlas document is invalid: assets/atlases/hero.atlas.json"),
    ),
    prefab_error,
  )
  inspect(
    atlas_error.status,
    content="Atlas load failed: Atlas document is invalid: assets/atlases/hero.atlas.json",
  )

  let (_, animation_error) = update(
    msg_animation_loaded(
      Err("Animation document is invalid: assets/animations/hero.anim.json"),
    ),
    atlas_error,
  )
  inspect(
    animation_error.status,
    content="Animation load failed: Animation document is invalid: assets/animations/hero.anim.json",
  )
  inspect(animation_error.scene is Some(_), content="true")
}

///|
test "service event stream errors do not destroy editor state" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
  }
  let (_, next) = update(msg_service_event(Err("connection dropped")), model)
  inspect(next.status, content="SSE error")
  inspect(next.scene is Some(_), content="true")
  inspect(next.logs.length(), content="1")
}

///|
test "editing a selected prefab updates the prefab document and save emits rpc" {
  let prefab = @editor_bridge.prefab_document("hero", [
    @editor_bridge.entity_document("camera", "Camera2d", components=[
      @editor_bridge.name_component("Camera2d"),
      @editor_bridge.transform2d_component(),
      @editor_bridge.camera2d_component(),
      @editor_bridge.visibility_component(),
    ]),
  ])
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    prefab_refs: [@editor_bridge.prefab_ref("prefabs/hero.prefab.json")],
    prefab_documents: { "prefabs/hero.prefab.json": prefab },
    selected_resource: Some(
      resource_selection_prefab("prefabs/hero.prefab.json"),
    ),
  }
  let (_, edited) = update(msg_update_selected_prefab_name("hero-copy"), model)
  let updated = edited.prefab_documents.get("prefabs/hero.prefab.json").unwrap()
  inspect(updated.name, content="hero-copy")

  let (effects, saving) = update(msg_save_selected_prefab(), edited)
  inspect(effects.length(), content="1")
  inspect(saving.status, content="Saving prefab...")
}

///|
test "undo and redo restore scene document changes" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, added) = update(msg_add_sprite_entity(), model)
  inspect(added.scene.unwrap().entities.length(), content="2")

  let (_, undone) = update(msg_undo_scene(), added)
  inspect(undone.scene.unwrap().entities.length(), content="1")
  inspect(undone.redo_stack.length(), content="1")

  let (_, redone) = update(msg_redo_scene(), undone)
  inspect(redone.scene.unwrap().entities.length(), content="2")
  inspect(redone.undo_stack.length() > 0, content="true")
}

///|
test "inspector transform typing is coalesced into one undo entry after commit" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, x1) = update(msg_update_selected_translate_x("1"), model)
  let (_, x2) = update(msg_update_selected_translate_x("12"), x1)
  inspect(x2.undo_stack.length(), content="0")
  inspect(x2.active_scene_edit_transaction is Some(_), content="true")

  let (_, committed) = update(msg_commit_scene_edit_transaction(), x2)
  inspect(committed.undo_stack.length(), content="1")
  inspect(committed.active_scene_edit_transaction is Some(_), content="false")

  let (_, undone) = update(msg_undo_scene(), committed)
  let camera = undone.scene.unwrap().entity("camera").unwrap()
  let transform : @editor_bridge.Transform2dComponent = component_of(
    camera, "Transform2d",
  ).unwrap()
  inspect(transform.translation.x, content="0")
}

///|
test "adding an existing built-in component is a no-op" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (effects, next) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("Transform2d").unwrap(),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  inspect(next.undo_stack.length(), content="0")
  inspect(next.status, content="Transform2d already exists on this entity")
}

///|
test "opening add component panel requires a selected entity" {
  let without_selection = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
  }
  let (_none_effects, none_selected) = update(
    msg_open_add_component_panel(),
    without_selection,
  )
  inspect(none_selected.add_component_panel_open, content="false")

  let with_selection = {
    ..without_selection,
    selected_entity_id: Some("camera"),
  }
  let (_open_effects, opened) = update(
    msg_open_add_component_panel(),
    with_selection,
  )
  inspect(opened.add_component_panel_open, content="true")
  inspect(opened.component_search_query, content="")
}

///|
test "adding animation transitions auto-adds required dependency chain" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_effects, next) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    ),
    model,
  )
  let camera = next.scene.unwrap().entity("camera").unwrap()
  inspect(camera.component("Sprite") is Some(_), content="true")
  inspect(camera.component("TextureAtlas") is Some(_), content="true")
  inspect(camera.component("AnimationPlayer") is Some(_), content="true")
  inspect(camera.component("AnimationTransitions") is Some(_), content="true")
  inspect(next.undo_stack.length(), content="1")
}

///|
test "removing a required built-in component is blocked with a stable message" {
  let seeded = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_effects, with_animation) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    ),
    seeded,
  )
  let (_remove_effects, blocked) = update(
    msg_remove_component("Sprite"),
    with_animation,
  )
  let camera = blocked.scene.unwrap().entity("camera").unwrap()
  inspect(camera.component("Sprite") is Some(_), content="true")
  inspect(blocked.status.contains("Cannot remove Sprite"), content="true")
}

///|
test "removing a built-in component supports undo and redo" {
  let seeded = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_effects, with_text) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("Text2d").unwrap(),
    ),
    seeded,
  )
  let (_remove_effects, removed) = update(
    msg_remove_component("Text2d"),
    with_text,
  )
  inspect(
    removed.scene.unwrap().entity("camera").unwrap().component("Text2d") is None,
    content="true",
  )

  let (_undo_effects, undone) = update(msg_undo_scene(), removed)
  inspect(
    undone.scene.unwrap().entity("camera").unwrap().component("Text2d")
    is Some(_),
    content="true",
  )

  let (_redo_effects, redone) = update(msg_redo_scene(), undone)
  inspect(
    redone.scene.unwrap().entity("camera").unwrap().component("Text2d") is None,
    content="true",
  )
}

///|
test "custom component add and commit validates kind and json" {
  let seeded = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_conflict_effects, conflict) = update(
    msg_add_custom_component("Transform2d"),
    seeded,
  )
  inspect(
    conflict.status,
    content="Custom kind conflicts with a built-in component",
  )

  let (_add_effects, added) = update(
    msg_add_custom_component("GameplayTag"),
    conflict,
  )
  inspect(
    added.scene.unwrap().entity("camera").unwrap().component("GameplayTag")
    is Some(_),
    content="true",
  )

  let (_invalid_edit_effects, invalid_draft) = update(
    msg_update_custom_component_json("GameplayTag", "{\"hp\":"),
    added,
  )
  let (_invalid_commit_effects, invalid_commit) = update(
    msg_commit_custom_component_json("GameplayTag"),
    invalid_draft,
  )
  inspect(invalid_commit.status.contains("Invalid JSON"), content="true")

  let (_valid_edit_effects, valid_draft) = update(
    msg_update_custom_component_json("GameplayTag", "{\"hp\":10}"),
    invalid_commit,
  )
  let (_valid_commit_effects, committed) = update(
    msg_commit_custom_component_json("GameplayTag"),
    valid_draft,
  )
  let component = committed.scene
    .unwrap()
    .entity("camera")
    .unwrap()
    .component("GameplayTag")
    .unwrap()
  inspect(component.data == @json.parse("{\"hp\":10}"), content="true")
}

///|
test "preview transform events apply translation, rotation, and scale" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, next) = update(
    msg_preview_event(
      @bridge.preview_event_transform_changed(
        "camera",
        @editor_bridge.vec2_doc(12.0, -8.0),
        1.2,
        @editor_bridge.vec2_doc(2.0, 3.0),
      ),
    ),
    model,
  )
  let camera = next.scene.unwrap().entity("camera").unwrap()
  let transform : @editor_bridge.Transform2dComponent = component_of(
    camera, "Transform2d",
  ).unwrap()
  inspect(transform.translation.x, content="12")
  inspect(transform.translation.y, content="-8")
  inspect(transform.rotation, content="1.2")
  inspect(transform.scale.x, content="2")
  inspect(transform.scale.y, content="3")
}

///|
test "preview transform gesture records a single undo entry" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }

  let (_, started) = update(
    msg_preview_event(@bridge.preview_event_transform_gesture_started("camera")),
    model,
  )
  inspect(started.active_scene_edit_transaction is Some(_), content="true")

  let (_, dragging) = update(
    msg_preview_event(
      @bridge.preview_event_transform_changed(
        "camera",
        @editor_bridge.vec2_doc(12.0, -8.0),
        0.0,
        @editor_bridge.vec2_doc(1.0, 1.0),
      ),
    ),
    started,
  )
  inspect(dragging.undo_stack.length(), content="0")

  let (_, finished) = update(
    msg_preview_event(
      @bridge.preview_event_transform_gesture_finished("camera"),
    ),
    dragging,
  )
  inspect(finished.undo_stack.length(), content="1")
  inspect(finished.active_scene_edit_transaction is Some(_), content="false")

  let (_, undone) = update(msg_undo_scene(), finished)
  let camera = undone.scene.unwrap().entity("camera").unwrap()
  let transform : @editor_bridge.Transform2dComponent = component_of(
    camera, "Transform2d",
  ).unwrap()
  inspect(transform.translation.x, content="0")
  inspect(transform.translation.y, content="0")
}

///|
test "setting drag-canvas tool updates editor state and emits preview sync effects" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
  }
  let (effects, next) = update(
    msg_set_tool(@shared.preview_tool_drag_canvas()),
    model,
  )
  inspect(next.active_tool, content="DragCanvas")
  inspect(effects.length() > 0, content="true")
  inspect(next.status, content="Tool: Drag Canvas")
}

///|
test "toggling and adjusting move snap emits workspace save rpc" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
  }
  let (toggle_effects, toggled) = update(msg_toggle_move_snap(), model)
  let mut toggle_has_workspace_save = false
  for effect in toggle_effects {
    match effect {
      Rpc(target~, ..) if target == WorkspaceSaved =>
        toggle_has_workspace_save = true
      _ => ()
    }
  }
  inspect(toggle_has_workspace_save, content="true")
  inspect(toggled.move_snap_enabled, content="true")
  inspect(toggled.workspace.move_snap_enabled, content="Some(true)")

  let (step_effects, stepped) = update(msg_adjust_move_snap_step(1), toggled)
  let mut step_has_workspace_save = false
  for effect in step_effects {
    match effect {
      Rpc(target~, ..) if target == WorkspaceSaved =>
        step_has_workspace_save = true
      _ => ()
    }
  }
  inspect(step_has_workspace_save, content="true")
  inspect(stepped.move_snap_step, content="32")
  inspect(stepped.workspace.move_snap_step, content="Some(32)")
}

///|
test "transform gesture without change does not push undo history" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, started) = update(
    msg_preview_event(@bridge.preview_event_transform_gesture_started("camera")),
    model,
  )
  let (_, finished) = update(
    msg_preview_event(
      @bridge.preview_event_transform_gesture_finished("camera"),
    ),
    started,
  )
  inspect(finished.undo_stack.length(), content="0")
}
