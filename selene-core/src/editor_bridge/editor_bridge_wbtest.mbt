fn json_string_bytes(value : String) -> Bytes {
  @utf8.encode(value)
}

///|
fn manifest_bytes(manifest : ProjectManifest) -> Bytes raise {
  json_string_bytes(encode_project_manifest_json(manifest))
}

///|
fn scene_bytes(scene : SceneDocument) -> Bytes raise {
  json_string_bytes(encode_scene_snf(scene))
}

///|
fn atlas_bytes(atlas : AtlasAssetDocument) -> Bytes raise {
  json_string_bytes(encode_atlas_asset_document_json(atlas))
}

///|
fn animation_clip_bytes(clip : AnimationClipAssetDocument) -> Bytes raise {
  json_string_bytes(encode_animation_clip_asset_document_json(clip))
}

///|
fn animation_graph_bytes(graph : AnimationGraphAssetDocument) -> Bytes raise {
  json_string_bytes(encode_animation_graph_asset_document_json(graph))
}

///|
fn source_with_documents(entries : Array[(String, Bytes)]) -> DocumentSource {
  let documents : Map[String, Bytes] = {}
  for _, entry in entries {
    let (path, bytes) = entry
    documents.set(path, bytes)
  }
  map_document_source(documents)
}

///|
test "project manifest round trip includes v2 indexes" {
  let manifest = ProjectManifest::default(
    "demo",
    startup_scene="scenes/demo.scene.json",
    scene_index=[scene_ref("scenes/demo.scene.json")],
    prefab_index=[prefab_ref("prefabs/enemy.prefab.json")],
    atlas_index=[asset_ref("assets/atlases/demo.atlas.json")],
    animation_clip_index=[asset_ref("assets/animation_clips/demo.clip.json")],
    animation_graph_index=[asset_ref("assets/animation_graphs/demo.graph.json")],
  )
  let decoded : ProjectManifest = @json.from_json(manifest.to_json())
  inspect(decoded == manifest, content="true")
}

///|
test "document file names are normalized from project names" {
  inspect(project_manifest_file_name("BDD Demo"), content="selene.project.json")
  inspect(
    startup_scene_path_for_name("BDD Demo"),
    content="scenes/bdd-demo.scene.json",
  )
}

///|
test "builtin component kind mapping and defaults stay aligned" {
  let kinds = builtin_component_kinds()
  let names = kinds.map(fn(kind) { builtin_component_kind_to_string(kind) })
  inspect(
    names.join(","),
    content="Name,Transform2d,Visibility,Sprite,TextureAtlas,AutoTileLayer2d,Text2d,Mesh2d,ColorMaterial,Camera2d,PhysicsBody2d,PhysicsCollider2d,AnimationPlayer,AnimationTransitions",
  )
  let mut round_trip_ok = true
  let mut defaults_ok = true
  for kind in kinds {
    let kind_name = builtin_component_kind_to_string(kind)
    if builtin_component_kind_from_string(kind_name) != Some(kind) {
      round_trip_ok = false
    }
    let default_component = default_component_document(kind)
    if default_component.kind != kind_name {
      defaults_ok = false
    }
    if builtin_component_kind_from_string(default_component.kind) is None {
      defaults_ok = false
    }
  }
  inspect(round_trip_ok, content="true")
  inspect(defaults_ok, content="true")
}

///|
test "builtin component dependencies and removability follow the inspector rules" {
  inspect(
    required_builtin_components(TextureAtlas)
    .map(fn(kind) { builtin_component_kind_to_string(kind) })
    .join(","),
    content="Sprite",
  )
  inspect(
    required_builtin_components(AnimationPlayer)
    .map(fn(kind) { builtin_component_kind_to_string(kind) })
    .join(","),
    content="TextureAtlas",
  )
  inspect(
    required_builtin_components(AnimationTransitions)
    .map(fn(kind) { builtin_component_kind_to_string(kind) })
    .join(","),
    content="AnimationPlayer",
  )
  inspect(
    required_builtin_components(ColorMaterial)
    .map(fn(kind) { builtin_component_kind_to_string(kind) })
    .join(","),
    content="Mesh2d",
  )
  inspect(removable_builtin_component(Transform2d), content="false")
  inspect(removable_builtin_component(Sprite), content="true")
}

///|
test "animation repeat mode parsing and serialization stay stable" {
  inspect(
    match animation_repeat_mode_doc_from_string("forever") {
      Forever => true
      Never | Count(_) => false
    },
    content="true",
  )
  inspect(
    match animation_repeat_mode_doc_from_string("never") {
      Never => true
      Forever | Count(_) => false
    },
    content="true",
  )
  inspect(
    match animation_repeat_mode_doc_from_string("once") {
      Never => true
      Forever | Count(_) => false
    },
    content="true",
  )
  inspect(
    match animation_repeat_mode_doc_from_string("count") {
      Count(v) => v == 1
      Never | Forever => false
    },
    content="true",
  )
  inspect(
    match animation_repeat_mode_doc_from_string("count:3") {
      Count(v) => v == 3
      Never | Forever => false
    },
    content="true",
  )
  inspect(
    animation_repeat_mode_doc_to_string(animation_repeat_mode_count(5)),
    content="count:5",
  )
}

///|
test "animation player component constructor stores canonical repeat string" {
  let component = animation_player_component(
    graph_asset_path=Some("assets/animation_graphs/hero.graph.json"),
    repeat_mode=animation_repeat_mode_count(2),
    speed=-1.0,
  )
  let player : AnimationPlayerComponent = @json.from_json(component.data)
  inspect(player.repeat_mode, content="count:2")
  inspect(
    match player.repeat_mode_doc() {
      Count(v) => v == 2
      Never | Forever => false
    },
    content="true",
  )
}

///|
test "scene document round trip" {
  let scene = SceneDocument::{
    version: scene_schema_version,
    name: "Main",
    entities: [
      EntityDocument::{
        id: "hero",
        name: "Hero",
        parent: None,
        components: [
          transform2d_component(translation={ x: 8.0, y: 16.0 }, scale={
            x: 2.0,
            y: 2.0,
          }),
          sprite_component(image_path=Some("assets/hero.png")),
        ],
      },
    ],
  }
  let decoded : SceneDocument = @json.from_json(scene.to_json())
  inspect(decoded == scene, content="true")
}

///|
test "scene snf round trip and canonical encoding are stable" {
  let scene = SceneDocument::{
    version: scene_schema_version,
    name: "Main",
    entities: [
      EntityDocument::{
        id: "camera",
        name: "Camera2d",
        parent: None,
        components: [
          transform2d_component(),
          camera2d_component(),
          visibility_component(),
        ],
      },
      EntityDocument::{
        id: "hero",
        name: "Hero",
        parent: None,
        components: [
          transform2d_component(translation={ x: 16.0, y: 8.0 }),
          sprite_component(image_path=Some("assets/images/hero.png")),
        ],
      },
    ],
  }
  let encoded = encode_scene_snf(scene)
  let decoded = decode_scene_snf(@json.parse(encoded))
  inspect(decoded == scene, content="true")
  let encoded_again = encode_scene_snf(scene)
  inspect(encoded_again == encoded, content="true")
}

///|
test "scene patch applies in document space" {
  let scene = SceneDocument::default_main()
  let patch = ScenePatch::{
    ops: [
      PutEntity(EntityDocument::{
        id: "crate",
        name: "Crate",
        parent: None,
        components: [
          transform2d_component(translation={ x: 32.0, y: 24.0 }),
          sprite_component(color={ r: 255, g: 0, b: 0, a: 255 }),
        ],
      }),
      PutComponent(entity_id="camera", component=text2d_component("Editor")),
    ],
  }
  let patched = scene.apply_patch(patch)
  inspect(patched.entity("crate") is Some(_), content="true")
  inspect(
    patched.entity("camera").unwrap().component("Text2d") is Some(_),
    content="true",
  )
}

///|
test "validation rejects unsupported scene version and missing parent" {
  let scene = SceneDocument::{
    version: 999,
    name: "Broken",
    entities: [
      EntityDocument::{
        id: "child",
        name: "Child",
        parent: Some("missing"),
        components: [
          ComponentDocument::{ kind: "UnknownKind", data: Json::null() },
        ],
      },
    ],
  }
  let errors = validate_scene_document(scene)
  inspect(errors.length(), content="2")
}

///|
test "scene runtime instantiates camera and mesh entities" {
  let scene = SceneDocument::{
    version: scene_schema_version,
    name: "Runtime",
    entities: [
      EntityDocument::{
        id: "camera",
        name: "Camera",
        parent: None,
        components: [
          transform2d_component(),
          camera2d_component(scale=2.0),
          visibility_component(),
        ],
      },
      EntityDocument::{
        id: "shape",
        name: "Shape",
        parent: None,
        components: [
          transform2d_component(translation={ x: 24.0, y: 12.0 }),
          mesh2d_component("rectangle", size=Some(vec2_doc(40.0, 20.0))),
          color_material_component(color=color_doc(255, 0, 0)),
        ],
      },
    ],
  }
  let runtime = instantiate_scene_document(scene, identity_asset_path_resolver)
  inspect(runtime.entity("camera") is Some(_), content="true")
  inspect(runtime.entity("shape") is Some(_), content="true")
  let camera_entity = runtime.entity("camera").unwrap()
  let shape_entity = runtime.entity("shape").unwrap()
  inspect(@camera.cameras().contains(camera_entity), content="true")
  inspect(@mesh2d.mesh2ds().contains(shape_entity), content="true")
  runtime.destroy()
}

///|
test "autotile component round trip and scene validation" {
  let component = autotile_layer2d_component(
    atlas_asset_path="assets/atlases/world.atlas.json",
    palette=[
      autotile_palette_entry_document(1, "terrain_0", bitmask4_rules=[
        autotile_mask_rule_document(0, "terrain_0"),
      ]),
    ],
    cells=[autotile_cell_document(0, 0, 1)],
  )
  let decoded : AutoTileLayer2dComponent = @json.from_json(component.data)
  inspect(decoded.atlas_asset_path, content="assets/atlases/world.atlas.json")
  inspect(decoded.cells.length(), content="1")
  let scene = SceneDocument::default_main().with_entity(
    entity_document("autotile", "AutoTile", components=[
      transform2d_component(),
      component,
    ]),
  )
  let errors = validate_scene_document(scene)
  inspect(errors.is_empty(), content="true")
}

///|
test "autotile validation reports missing atlas and undefined terrain references" {
  let scene = SceneDocument::default_main().with_entity(
    entity_document("autotile", "AutoTile", components=[
      transform2d_component(),
      autotile_layer2d_component(
        atlas_asset_path="",
        palette=[autotile_palette_entry_document(1, "tile_0")],
        cells=[autotile_cell_document(1, 2, 99)],
      ),
    ]),
  )
  let errors = validate_scene_document(scene)
  inspect(errors.length() >= 2, content="true")
}

///|
test "runtime instantiation renders autotile layer tiles from source only" {
  let atlas_path = "assets/atlases/world.atlas.json"
  let atlas = AtlasAssetDocument::default("world", "assets/images/world.png")
    .with_tile_size(vec2_doc(16.0, 16.0))
    .with_regions([
      atlas_region_document("terrain_0", 0, rect_doc(0.0, 0.0, 16.0, 16.0)),
    ])
  let atlas_assets : Map[String, AtlasAssetDocument] = {}
  atlas_assets.set(atlas_path, atlas)
  let scene = SceneDocument::default_main().with_entity(
    entity_document("autotile", "AutoTile", components=[
      transform2d_component(),
      autotile_layer2d_component(
        atlas_asset_path=atlas_path,
        rule_set=autotile_rule_set_bitmask4(),
        palette=[
          autotile_palette_entry_document(1, "terrain_0", bitmask4_rules=[
            autotile_mask_rule_document(0, "terrain_0", atlas_index=0),
          ]),
        ],
        cells=[autotile_cell_document(0, 0, 1)],
      ),
    ]),
  )
  let before_count = {
    let mut count = 0
    for _, _ in @sprite.sprites() {
      count = count + 1
    }
    count
  }
  let runtime = instantiate_scene_document_with_context(
    scene,
    asset_instantiation_context(atlas_assets~),
  )
  let after_count = {
    let mut count = 0
    for _, _ in @sprite.sprites() {
      count = count + 1
    }
    count
  }
  inspect(after_count == before_count + 1, content="true")
  runtime.destroy()
}

///|
test "codec decodes valid project and scene documents" {
  let manifest = ProjectManifest::default("demo")
  let scene = SceneDocument::default_main()
  let manifest_json = @json.parse(encode_project_manifest_json(manifest))
  let scene_json = @json.parse(encode_scene_snf(scene))
  inspect(
    decode_project_manifest(manifest_json) == manifest,
    content="true",
  )
  inspect(decode_scene_snf(scene_json) == scene, content="true")
}

///|
test "codec rejects legacy project manifest without envelope" {
  let legacy_json = @json.parse(
    "{\n  \"version\": 2,\n  \"name\": \"Demo\",\n  \"startup_scene\": \"scenes/main.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
  )
  let result : Result[ProjectManifestLoadStatus, Error] =
    try? decode_project_manifest_status("selene.project.json", legacy_json)
  match result {
    Err(InvalidProjectManifest(_)) => inspect(true, content="true")
    _ => fail("expected invalid legacy project manifest")
  }
}

///|
test "codec rejects legacy scene document without envelope" {
  let legacy_json = @json.parse(
    "{\n  \"version\": 2,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": { \"x\": 0, \"y\": 0 },\n            \"rotation\": 0,\n            \"scale\": { \"x\": 1, \"y\": 1 }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": { \"is_active\": true, \"order\": 0, \"scale\": 1 }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": { \"visible\": true }\n        }\n      ]\n    }\n  ]\n}\n",
  )
  let result : Result[SceneDocumentLoadStatus, Error] = try? decode_scene_snf_status(
    "scenes/main.scene.json", legacy_json,
  )
  match result {
    Err(InvalidSceneDocument(_)) => inspect(true, content="true")
    _ => fail("expected invalid legacy scene document")
  }
}

///|
test "loader rejects legacy project manifest without envelope" {
  let scene = SceneDocument::default_main()
  let source = source_with_documents([
    (
      "selene.project.json",
      json_string_bytes(
        "{\n  \"version\": 2,\n  \"name\": \"demo\",\n  \"startup_scene\": \"scenes/demo.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
      ),
    ),
    ("scenes/demo.scene.json", scene_bytes(scene)),
  ])
  let result : Result[ProjectBundle, Error] = try? load_project_bundle(source)
  match result {
    Err(InvalidProjectManifest(_)) => inspect(true, content="true")
    _ => fail("expected invalid legacy project manifest")
  }
}

///|
test "loader builds a project bundle with atlas and animation dependencies" {
  let atlas_path = "assets/atlases/hero.atlas.json"
  let clip_path = "assets/animation_clips/hero-default.clip.json"
  let graph_path = "assets/animation_graphs/hero.graph.json"
  let scene_path = "scenes/main.scene.json"
  let manifest = ProjectManifest::default(
    "demo",
    startup_scene=scene_path,
    scene_index=[scene_ref(scene_path)],
    atlas_index=[asset_ref(atlas_path)],
    animation_clip_index=[asset_ref(clip_path)],
    animation_graph_index=[asset_ref(graph_path)],
  )
  let atlas = AtlasAssetDocument::default(
    "Hero Atlas", "assets/images/hero.png",
  )
  let clip = AnimationClipAssetDocument::default("Hero Default", atlas_path)
  let graph = AnimationGraphAssetDocument::default("Hero Graph", clip_path)
  let scene = SceneDocument::default_main().with_entity(
    entity_document("hero", "Hero", components=[
      transform2d_component(),
      sprite_component(),
      texture_atlas_component(atlas_asset_path=Some(atlas_path)),
      animation_player_component(graph_asset_path=Some(graph_path)),
    ]),
  )
  let source = source_with_documents([
    ("selene.project.json", manifest_bytes(manifest)),
    (scene_path, scene_bytes(scene)),
    (atlas_path, atlas_bytes(atlas)),
    (clip_path, animation_clip_bytes(clip)),
    (graph_path, animation_graph_bytes(graph)),
  ])
  let bundle = load_project_bundle(source)
  inspect(bundle.scene_path, content="scenes/main.scene.json")
  inspect(bundle.scene.name, content="Main")
  inspect(bundle.atlas_assets.contains(atlas_path), content="true")
  inspect(bundle.animation_clip_assets.contains(clip_path), content="true")
  inspect(bundle.animation_graph_assets.contains(graph_path), content="true")
}

///|
test "loader fails clearly for missing and invalid dependency documents" {
  let source_missing = source_with_documents([
    ("selene.project.json", manifest_bytes(ProjectManifest::default("demo"))),
  ])
  let missing_result : Result[ProjectBundle, Error] = try? load_project_bundle(
    source_missing,
  )
  match missing_result {
    Err(MissingDocument("scenes/demo.scene.json")) =>
      inspect(true, content="true")
    _ => fail("expected missing startup scene")
  }

  let atlas_path = "assets/atlases/hero.atlas.json"
  let scene = SceneDocument::default_main().with_entity(
    entity_document("hero", "Hero", components=[
      transform2d_component(),
      texture_atlas_component(atlas_asset_path=Some(atlas_path)),
    ]),
  )
  let source_invalid = source_with_documents([
    ("selene.project.json", manifest_bytes(ProjectManifest::default("demo"))),
    ("scenes/demo.scene.json", scene_bytes(scene)),
    (atlas_path, json_string_bytes("{\"version\":2,\"name\":")),
  ])
  let invalid_result : Result[ProjectBundle, Error] = try? load_project_bundle(
    source_invalid,
  )
  match invalid_result {
    Err(InvalidAtlasAssetDocument(_)) => inspect(true, content="true")
    _ => fail("expected invalid atlas dependency error")
  }
}
