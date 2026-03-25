///|
test "initialize immediately requests a project folder" {
  let (effects, _) = update(msg_initialize(), new_model())
  inspect(effects.length(), content="4")
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
  inspect(next.status, content="Choose a project folder to begin")
}

///|
test "project load refreshes both scene and asset list" {
  let (_, model) = update(msg_initialize(), new_model())
  let (effects, next) = update(
    msg_project_loaded(
      Ok({
        root: Some("/tmp/demo"),
        manifest: Some(@editor_bridge.ProjectManifest::default("demo")),
        recent_projects: [],
      }),
    ),
    model,
  )
  inspect(effects.length(), content="2")
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
    msg_select_asset(Some("assets/hero.png")),
    model,
  )
  inspect(next.selected_asset_path, content="Some(\"assets/hero.png\")")
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
