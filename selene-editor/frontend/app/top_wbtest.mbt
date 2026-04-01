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
test "clear selection closes inspector panel before deselecting" {
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
  let (close_effects, closed_panel) = update(msg_clear_selection(), model)
  inspect(close_effects.length(), content="0")
  inspect(closed_panel.selected_entity_id, content="Some(\"camera\")")
  inspect(
    closed_panel.selected_resource,
    content="Some(Image(\"assets/images/hero.png\"))",
  )
  inspect(closed_panel.add_component_panel_open, content="false")
  inspect(closed_panel.open_component_menu_kind, content="None")
  inspect(closed_panel.workspace.selected_entity_id, content="Some(\"camera\")")
  inspect(closed_panel.status, content="Inspector panel closed")

  let (effects, cleared) = update(msg_clear_selection(), closed_panel)
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
test "asset query updates status feedback" {
  let (_, filtering) = update(msg_set_asset_query("apple"), new_model())
  inspect(filtering.asset_query, content="apple")
  inspect(filtering.status, content="Filtering assets: apple")

  let (_, cleared) = update(msg_set_asset_query("   "), filtering)
  inspect(cleared.asset_query, content="   ")
  inspect(cleared.status, content="Asset filter cleared")
}

///|
test "asset query clears selection when selected resource is filtered out" {
  let model = {
    ..new_model(),
    assets: [
      @editor_bridge.asset_document(
        "assets/images/apple.png",
        @editor_bridge.infer_asset_kind("assets/images/apple.png"),
      ),
      @editor_bridge.asset_document(
        "assets/images/banana.png",
        @editor_bridge.infer_asset_kind("assets/images/banana.png"),
      ),
    ],
    selected_resource: Some(resource_selection_image("assets/images/apple.png")),
  }
  let (_, next) = update(msg_set_asset_query("banana"), model)
  inspect(next.selected_resource, content="None")
  inspect(next.status, content="Filtering assets: banana (selection cleared)")
}

///|
test "asset query keeps selected resource even when section is collapsed" {
  let model = {
    ..new_model(),
    images_section_expanded: false,
    assets: [
      @editor_bridge.asset_document(
        "assets/images/apple.png",
        @editor_bridge.infer_asset_kind("assets/images/apple.png"),
      ),
    ],
    selected_resource: Some(resource_selection_image("assets/images/apple.png")),
  }
  let (_, next) = update(msg_set_asset_query("apple"), model)
  inspect(
    next.selected_resource,
    content="Some(Image(\"assets/images/apple.png\"))",
  )
  inspect(next.status, content="Filtering assets: apple")
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
test "select entity updates status with entity name when available" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let model = { ..new_model(), scene: Some(scene), status: "Idle" }
  let (_, selected) = update(msg_select_entity(Some("camera")), model)
  inspect(selected.status, content="Selected entity: Camera2d")
  inspect(selected.selected_entity_id, content="Some(\"camera\")")

  let (_, fallback) = update(msg_select_entity(Some("missing-entity")), model)
  inspect(fallback.status, content="Selected entity: missing-entity")

  let (_, cleared) = update(msg_select_entity(None), selected)
  inspect(cleared.status, content="Entity selection cleared")
  inspect(cleared.selected_entity_id, content="None")
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
          [],
          Some(@editor_bridge.WorkspaceDocument::default()),
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
test "project load rejects missing workspace payload" {
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
          [],
          None,
          [],
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  inspect(
    next.status,
    content="Project open failed. Check browser console for details.",
  )
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
    images_section_expanded: false,
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
  inspect(next.status, content="Selected resource: hero")
  inspect(next.images_section_expanded, content="true")
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
  inspect(first.status, content="Selected resource 1/2: apple")

  let (_, second) = update(msg_move_selected_resource(1), first)
  inspect(
    second.selected_resource,
    content="Some(Image(\"assets/images/zebra.png\"))",
  )
  inspect(second.status, content="Selected resource 2/2: zebra")

  let (_, back) = update(msg_move_selected_resource(-1), second)
  inspect(
    back.selected_resource,
    content="Some(Image(\"assets/images/apple.png\"))",
  )
  inspect(back.status, content="Selected resource 1/2: apple")
}

///|
test "move selected resource clamps to first and last for large deltas" {
  let model = {
    ..new_model(),
    assets: [
      @editor_bridge.asset_document(
        "assets/images/c.png",
        @editor_bridge.infer_asset_kind("assets/images/c.png"),
      ),
      @editor_bridge.asset_document(
        "assets/images/a.png",
        @editor_bridge.infer_asset_kind("assets/images/a.png"),
      ),
      @editor_bridge.asset_document(
        "assets/images/b.png",
        @editor_bridge.infer_asset_kind("assets/images/b.png"),
      ),
    ],
  }
  let (_, first) = update(msg_move_selected_resource(1000000), model)
  inspect(
    first.selected_resource,
    content="Some(Image(\"assets/images/a.png\"))",
  )
  inspect(first.status, content="Selected resource 1/3: a")

  let (_, still_first) = update(msg_move_selected_resource(-1000000), first)
  inspect(
    still_first.selected_resource,
    content="Some(Image(\"assets/images/a.png\"))",
  )
  inspect(still_first.status, content="Selected resource 1/3: a")

  let (_, last) = update(msg_move_selected_resource(-1000000), model)
  inspect(
    last.selected_resource,
    content="Some(Image(\"assets/images/c.png\"))",
  )
  inspect(last.status, content="Selected resource 3/3: c")
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
  inspect(next.atlases_section_expanded, content="true")
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
    atlases_section_expanded: false,
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
  inspect(next.atlases_section_expanded, content="true")
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
test "editing a selected animation clip updates the clip document and save emits rpc" {
  let animation = @editor_bridge.AnimationClipAssetDocument::default(
    "hero", "assets/atlases/hero.atlas.json",
  ).with_frames(["idle_0", "idle_1"])
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    animation_clip_refs: [
      @editor_bridge.asset_ref("assets/animation_clips/hero.clip.json"),
    ],
    animation_clip_documents: {
      "assets/animation_clips/hero.clip.json": animation,
    },
    selected_resource: Some(
      resource_selection_animation_clip("assets/animation_clips/hero.clip.json"),
    ),
  }
  let (_, edited) = update(
    msg_update_selected_animation_clip_frames("run_0, run_1"),
    model,
  )
  let updated = edited.animation_clip_documents
    .get("assets/animation_clips/hero.clip.json")
    .unwrap()
  inspect(updated.frames.join(","), content="run_0,run_1")

  let (effects, saving) = update(msg_save_selected_animation_clip(), edited)
  inspect(effects.length(), content="1")
  inspect(saving.status, content="Saving animation clip...")
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
    msg_animation_clip_loaded(
      Err(
        "Animation clip document is invalid: assets/animation_clips/hero.clip.json",
      ),
    ),
    atlas_error,
  )
  inspect(
    animation_error.status,
    content="Animation clip load failed: Animation clip document is invalid: assets/animation_clips/hero.clip.json",
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
test "animation player typed edits update component fields including negative speed" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, seeded) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    ),
    model,
  )
  let (_, graph_path_updated) = update(
    msg_update_selected_animation_player_graph_path(
      "assets/animation_graphs/hero.graph.json",
    ),
    seeded,
  )
  let (_, start_node_updated) = update(
    msg_update_selected_animation_player_start_node("idle"),
    graph_path_updated,
  )
  let (_, repeat_updated) = update(
    msg_update_selected_animation_player_repeat_mode("count"),
    start_node_updated,
  )
  let (_, speed_updated) = update(
    msg_update_selected_animation_player_speed("-1.5"),
    repeat_updated,
  )
  let (_, autoplay_toggled) = update(
    msg_toggle_selected_animation_player_autoplay(),
    speed_updated,
  )
  let (_, committed) = update(
    msg_commit_scene_edit_transaction(),
    autoplay_toggled,
  )
  let camera = committed.scene.unwrap().entity("camera").unwrap()
  let player : @editor_bridge.AnimationPlayerComponent = component_of(
    camera, "AnimationPlayer",
  ).unwrap()
  inspect(
    player.graph_asset_path,
    content="Some(\"assets/animation_graphs/hero.graph.json\")",
  )
  inspect(player.start_node, content="Some(\"idle\")")
  inspect(player.repeat_mode, content="count:1")
  inspect(player.repeat_mode_doc(), content="Count(1)")
  inspect(player.speed, content="-1.5")
  inspect(player.autoplay, content="true")
  inspect(committed.undo_stack.length() > 0, content="true")
}

///|
test "animation transitions typed edit updates duration" {
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    scene: Some(@editor_bridge.SceneDocument::default_main()),
    selected_entity_id: Some("camera"),
  }
  let (_, seeded) = update(
    msg_add_builtin_component(
      @editor_bridge.builtin_component_kind_from_string("AnimationTransitions").unwrap(),
    ),
    model,
  )
  let (_, duration_updated) = update(
    msg_update_selected_animation_transitions_duration("0.4"),
    seeded,
  )
  let (_, committed) = update(
    msg_commit_scene_edit_transaction(),
    duration_updated,
  )
  let camera = committed.scene.unwrap().entity("camera").unwrap()
  let transitions : @editor_bridge.AnimationTransitionsComponent = component_of(
    camera, "AnimationTransitions",
  ).unwrap()
  inspect(transitions.duration, content="0.4")
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

///|
test "add clip node appends a new graph node using first clip asset path" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let clip_path = "assets/animation_clips/hero.clip.json"
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": @editor_bridge.AnimationGraphAssetDocument::default(
        "Hero Graph", clip_path,
      ),
    },
    animation_clip_refs: [@editor_bridge.asset_ref(clip_path)],
  }
  let (_, next) = update(msg_add_selected_animation_graph_clip_node(), model)
  let graph = next.animation_graph_documents.get(graph_path).unwrap()
  inspect(graph.nodes.length(), content="2")
  match graph.nodes[1].kind {
    @editor_bridge.Clip(clip_asset_path~) =>
      inspect(clip_asset_path, content=clip_path)
    _ => inspect(false, content="true")
  }
}

///|
test "remove graph node prunes incoming edges and reassigns default node" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let clip_path = "assets/animation_clips/hero.clip.json"
  let node_a = @editor_bridge.animation_graph_node_document(
    "node-a",
    @editor_bridge.animation_graph_node_kind_blend(),
    edges=[@editor_bridge.animation_graph_edge_document("node-b", weight=1.0)],
  )
  let node_b = @editor_bridge.animation_graph_node_document(
    "node-b",
    @editor_bridge.animation_graph_node_kind_clip(clip_path),
  )
  let graph = @editor_bridge.animation_graph_asset_document(
    "Hero Graph",
    [node_a, node_b],
    Some("node-b"),
  )
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": graph,
    },
  }
  let (_, next) = update(
    msg_remove_selected_animation_graph_node("node-b"),
    model,
  )
  let updated = next.animation_graph_documents.get(graph_path).unwrap()
  inspect(updated.nodes.length(), content="1")
  inspect(updated.default_node, content="Some(\"node-a\")")
  inspect(updated.nodes[0].edges.length(), content="0")
}

///|
test "updating clip path only affects clip nodes" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let old_clip_path = "assets/animation_clips/idle.clip.json"
  let new_clip_path = "assets/animation_clips/run.clip.json"
  let node_clip = @editor_bridge.animation_graph_node_document(
    "node-clip",
    @editor_bridge.animation_graph_node_kind_clip(old_clip_path),
  )
  let node_blend = @editor_bridge.animation_graph_node_document(
    "node-blend",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let graph = @editor_bridge.animation_graph_asset_document(
    "Hero Graph",
    [node_clip, node_blend],
    Some("node-clip"),
  )
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": graph,
    },
  }
  let (_, next) = update(
    msg_update_selected_animation_graph_node_clip_path(
      "node-clip", new_clip_path,
    ),
    model,
  )
  let updated = next.animation_graph_documents.get(graph_path).unwrap()
  match updated.nodes[0].kind {
    @editor_bridge.Clip(clip_asset_path~) =>
      inspect(clip_asset_path, content=new_clip_path)
    _ => inspect(false, content="true")
  }
  match updated.nodes[1].kind {
    @editor_bridge.Blend => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "adding graph edge links to another available node" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let node_a = @editor_bridge.animation_graph_node_document(
    "node-a",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let node_b = @editor_bridge.animation_graph_node_document(
    "node-b",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let graph = @editor_bridge.animation_graph_asset_document(
    "Hero Graph",
    [node_a, node_b],
    Some("node-a"),
  )
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": graph,
    },
  }
  let (_, next) = update(msg_add_selected_animation_graph_edge("node-a"), model)
  let updated = next.animation_graph_documents.get(graph_path).unwrap()
  inspect(updated.nodes[0].edges.length(), content="1")
  inspect(updated.nodes[0].edges[0].to, content="node-b")
}

///|
test "editing graph edge target and weight persists values" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let node_a = @editor_bridge.animation_graph_node_document(
    "node-a",
    @editor_bridge.animation_graph_node_kind_blend(),
    edges=[@editor_bridge.animation_graph_edge_document("node-b")],
  )
  let node_b = @editor_bridge.animation_graph_node_document(
    "node-b",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let node_c = @editor_bridge.animation_graph_node_document(
    "node-c",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let graph = @editor_bridge.animation_graph_asset_document(
    "Hero Graph",
    [node_a, node_b, node_c],
    Some("node-a"),
  )
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": graph,
    },
  }
  let (_, target_updated) = update(
    msg_update_selected_animation_graph_edge_target("node-a", 0, "node-c"),
    model,
  )
  let (_, weight_updated) = update(
    msg_update_selected_animation_graph_edge_weight("node-a", 0, "2.5"),
    target_updated,
  )
  let updated = weight_updated.animation_graph_documents
    .get(graph_path)
    .unwrap()
  inspect(updated.nodes[0].edges[0].to, content="node-c")
  inspect(updated.nodes[0].edges[0].weight, content="2.5")
}

///|
test "removing graph edge deletes selected edge index" {
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let node_a = @editor_bridge.animation_graph_node_document(
    "node-a",
    @editor_bridge.animation_graph_node_kind_blend(),
    edges=[
      @editor_bridge.animation_graph_edge_document("node-b"),
      @editor_bridge.animation_graph_edge_document("node-c"),
    ],
  )
  let node_b = @editor_bridge.animation_graph_node_document(
    "node-b",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let node_c = @editor_bridge.animation_graph_node_document(
    "node-c",
    @editor_bridge.animation_graph_node_kind_blend(),
  )
  let graph = @editor_bridge.animation_graph_asset_document(
    "Hero Graph",
    [node_a, node_b, node_c],
    Some("node-a"),
  )
  let model = {
    ..new_model(),
    selected_resource: Some(resource_selection_animation_graph(graph_path)),
    animation_graph_documents: {
      "assets/animation_graphs/hero.graph.json": graph,
    },
  }
  let (_, next) = update(
    msg_remove_selected_animation_graph_edge("node-a", 0),
    model,
  )
  let updated = next.animation_graph_documents.get(graph_path).unwrap()
  inspect(updated.nodes[0].edges.length(), content="1")
  inspect(updated.nodes[0].edges[0].to, content="node-c")
}
