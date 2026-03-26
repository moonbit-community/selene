///|
test "initialize immediately requests a project folder" {
  let (effects, _) = update(msg_initialize(), new_model())
  inspect(effects.length(), content="3")
}

///|
test "pick project root result auto-opens the chosen directory" {
  let (_, model) = update(msg_pick_project_root(), new_model())
  let (effects, next) = update(
    msg_project_root_picked(Ok(@shared.directory_pick_result(Some("/tmp/demo-project")))),
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
  inspect(effects.length(), content="3")
  inspect(next.current_root, content="Some(\"/tmp/demo\")")
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
    entity,
    "Transform2d",
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
    selected_resource: Some(resource_selection_atlas("assets/atlases/hero.atlas.json")),
  }
  let (_, edited) = update(msg_update_selected_atlas_columns("2"), model)
  let updated = edited.atlas_documents.get("assets/atlases/hero.atlas.json").unwrap()
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
    animation_refs: [@editor_bridge.asset_ref("assets/animations/hero.anim.json")],
    animation_documents: { "assets/animations/hero.anim.json": animation },
    selected_resource: Some(
      resource_selection_animation("assets/animations/hero.anim.json"),
    ),
  }
  let (_, edited) = update(msg_update_selected_animation_clip_frames("run_0, run_1"), model)
  let updated = edited.animation_documents.get("assets/animations/hero.anim.json").unwrap()
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
test "editing a selected prefab updates the prefab document and save emits rpc" {
  let prefab = @editor_bridge.prefab_document(
    "hero",
    [
      @editor_bridge.entity_document(
        "camera",
        "Camera2d",
        components=[
          @editor_bridge.name_component("Camera2d"),
          @editor_bridge.transform2d_component(),
          @editor_bridge.camera2d_component(),
          @editor_bridge.visibility_component(),
        ],
      ),
    ],
  )
  let model = {
    ..new_model(),
    current_root: Some("/tmp/demo"),
    manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
    prefab_refs: [@editor_bridge.prefab_ref("prefabs/hero.prefab.json")],
    prefab_documents: { "prefabs/hero.prefab.json": prefab },
    selected_resource: Some(resource_selection_prefab("prefabs/hero.prefab.json")),
  }
  let (_, edited) = update(msg_update_selected_prefab_name("hero-copy"), model)
  let updated = edited.prefab_documents.get("prefabs/hero.prefab.json").unwrap()
  inspect(updated.name, content="hero-copy")

  let (effects, saving) = update(msg_save_selected_prefab(), edited)
  inspect(effects.length(), content="1")
  inspect(saving.status, content="Saving prefab...")
}
