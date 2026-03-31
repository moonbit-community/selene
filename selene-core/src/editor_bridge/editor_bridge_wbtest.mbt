///|
fn json_bytes(value : &ToJson) -> Bytes {
  @utf8.encode(value.to_json().stringify(indent=2))
}

///|
fn json_string_bytes(value : String) -> Bytes {
  @utf8.encode(value)
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
    animation_index=[asset_ref("assets/animations/demo.anim.json")],
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
    content="Name,Transform2d,Visibility,Sprite,TextureAtlas,Text2d,Mesh2d,ColorMaterial,Camera2d,PhysicsBody2d,PhysicsCollider2d,AnimationPlayer,AnimationTransitions",
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
test "codec decodes valid project and scene documents" {
  let manifest = ProjectManifest::default("demo")
  let scene = SceneDocument::default_main()
  inspect(
    decode_project_manifest(manifest.to_json()) == manifest,
    content="true",
  )
  inspect(decode_scene_document(scene.to_json()) == scene, content="true")
}

///|
test "codec reports project manifest migration for missing v2 indexes" {
  let legacy_json = @json.parse(
    "{\n  \"version\": 2,\n  \"name\": \"Demo\",\n  \"startup_scene\": \"scenes/main.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
  )
  match decode_project_manifest_status("selene.project.json", legacy_json) {
    MigrationRequired(preview) => {
      inspect(preview.manifest.scene_index.length(), content="1")
      inspect(
        preview.manifest.scene_index[0].path,
        content="scenes/main.scene.json",
      )
      inspect(preview.manifest.prefab_index.length(), content="0")
      inspect(preview.changes.length(), content="4")
    }
    _ => fail("expected project manifest migration preview")
  }
}

///|
test "codec reports scene migration only for v2 recoverable inputs" {
  let recoverable_json = @json.parse(
    "{\n  \"version\": 2,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": { \"x\": 0, \"y\": 0 },\n            \"rotation\": 0,\n            \"scale\": { \"x\": 1, \"y\": 1 }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": { \"is_active\": true, \"order\": 0, \"scale\": 1 }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": { \"visible\": true }\n        }\n      ]\n    }\n  ]\n}\n",
  )
  match
    decode_scene_document_status("scenes/main.scene.json", recoverable_json) {
    MigrationRequired(preview) => {
      inspect(preview.scene.name, content="Main")
      inspect(preview.changes.length() > 0, content="true")
    }
    _ => fail("expected migration preview")
  }

  let unsupported_json = @json.parse(
    "{\n  \"version\": 1,\n  \"entities\": []\n}\n",
  )
  let result : Result[SceneDocumentLoadStatus, Error] = try? decode_scene_document_status(
    "scenes/main.scene.json", unsupported_json,
  )
  match result {
    Err(InvalidSceneDocument(_)) => inspect(true, content="true")
    _ => fail("expected non-migratable v1 scene to fail")
  }
}

///|
test "loader accepts legacy v2 project manifest by auto-migrating indexes" {
  let scene = SceneDocument::default_main()
  let source = source_with_documents([
    (
      "selene.project.json",
      json_string_bytes(
        "{\n  \"version\": 2,\n  \"name\": \"demo\",\n  \"startup_scene\": \"scenes/demo.scene.json\",\n  \"asset_roots\": [\"assets/images\"]\n}\n",
      ),
    ),
    ("scenes/demo.scene.json", json_bytes(scene)),
  ])
  let bundle = load_project_bundle(source)
  inspect(bundle.manifest.scene_index.length(), content="1")
  inspect(bundle.manifest.scene_index[0].path, content="scenes/demo.scene.json")
}

///|
test "loader builds a project bundle with atlas and animation dependencies" {
  let atlas_path = "assets/atlases/hero.atlas.json"
  let animation_path = "assets/animations/hero.anim.json"
  let scene_path = "scenes/main.scene.json"
  let manifest = ProjectManifest::default(
    "demo",
    startup_scene=scene_path,
    scene_index=[scene_ref(scene_path)],
    atlas_index=[asset_ref(atlas_path)],
    animation_index=[asset_ref(animation_path)],
  )
  let atlas = AtlasAssetDocument::default(
    "Hero Atlas", "assets/images/hero.png",
  )
  let animation = AnimationAssetDocument::default("Hero", atlas_path)
  let scene = SceneDocument::default_main().with_entity(
    entity_document("hero", "Hero", components=[
      transform2d_component(),
      sprite_component(),
      texture_atlas_component(atlas_asset_path=Some(atlas_path)),
      animation_player_component(animation_asset_path=Some(animation_path)),
    ]),
  )
  let source = source_with_documents([
    ("selene.project.json", json_bytes(manifest)),
    (scene_path, json_bytes(scene)),
    (atlas_path, json_bytes(atlas)),
    (animation_path, json_bytes(animation)),
  ])
  let bundle = load_project_bundle(source)
  inspect(bundle.scene_path, content="scenes/main.scene.json")
  inspect(bundle.scene.name, content="Main")
  inspect(bundle.atlas_assets.contains(atlas_path), content="true")
  inspect(bundle.animation_assets.contains(animation_path), content="true")
}

///|
test "loader fails clearly for missing and invalid dependency documents" {
  let source_missing = source_with_documents([
    ("selene.project.json", json_bytes(ProjectManifest::default("demo"))),
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
    ("selene.project.json", json_bytes(ProjectManifest::default("demo"))),
    ("scenes/demo.scene.json", json_bytes(scene)),
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
