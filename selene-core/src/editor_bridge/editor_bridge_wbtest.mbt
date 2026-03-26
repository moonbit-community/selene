///|
test "project manifest round trip" {
  let manifest = ProjectManifest::default(
    "demo",
    startup_scene="scenes/demo.scene.json",
    asset_roots=["assets", "vendor"],
  )
  let decoded : ProjectManifest = @json.from_json(manifest.to_json())
  inspect(decoded == manifest, content="true")
}

///|
test "document file names are normalized from project names" {
  inspect(
    project_manifest_file_name("BDD Demo"),
    content="selene.project.json",
  )
  inspect(
    startup_scene_path_for_name("BDD Demo"),
    content="scenes/bdd-demo.scene.json",
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
test "validation rejects unsupported scene version and parent" {
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
  inspect(errors.length(), content="3")
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
test "legacy scene documents can be probed and migrated" {
  let temp_root = "_build/editor-bridge-migration"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }
  let path = temp_root + "/main.scene.json"
  @fs.write_string_to_file(
    path,
    "{\n  \"version\": 1,\n  \"entities\": [\n    {\n      \"id\": \"camera\",\n      \"name\": \"Camera2d\",\n      \"components\": [\n        {\n          \"kind\": \"Transform2d\",\n          \"data\": {\n            \"translation\": {\n              \"x\": 0,\n              \"y\": 0\n            },\n            \"rotation\": 0,\n            \"scale\": {\n              \"x\": 1,\n              \"y\": 1\n            }\n          }\n        },\n        {\n          \"kind\": \"Camera2d\",\n          \"data\": {\n            \"is_active\": true,\n            \"order\": 0,\n            \"scale\": 1\n          }\n        },\n        {\n          \"kind\": \"Visibility\",\n          \"data\": {\n            \"visible\": true\n          }\n        }\n      ]\n    }\n  ]\n}\n",
  )
  match read_scene_document_status(path) {
    MigrationRequired(preview) => {
      inspect(preview.path.has_suffix("main.scene.json"), content="true")
      inspect(preview.scene.name, content="Main")
      inspect(preview.scene.entities[0].parent, content="None")
      inspect(preview.changes.length(), content="2")
    }
    _ => fail("expected migration preview")
  }
  let migrated = migrate_scene_document(path)
  inspect(migrated.name, content="Main")
  inspect(read_scene_document(path).name, content="Main")
}

///|
test "legacy prefab documents can be probed and migrated" {
  let temp_root = "_build/editor-bridge-migration-prefab"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }
  let path = temp_root + "/enemy.prefab.json"
  @fs.write_string_to_file(
    path,
    "{\n  \"version\": 0,\n  \"entities\": [\n    {\n      \"id\": \"enemy\"\n    }\n  ]\n}\n",
  )
  match read_prefab_document_status(path) {
    MigrationRequired(preview) => {
      inspect(preview.prefab.name, content="Enemy")
      inspect(preview.prefab.entities[0].name, content="enemy")
      inspect(preview.prefab.entities[0].parent, content="None")
      inspect(preview.changes.length(), content="5")
    }
    _ => fail("expected prefab migration preview")
  }
  let migrated = migrate_prefab_document(path)
  inspect(migrated.version == prefab_schema_version, content="true")
  inspect(read_prefab_document(path).name, content="Enemy")
}

///|
test "legacy atlas documents can be probed and migrated" {
  let temp_root = "_build/editor-bridge-migration-atlas"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }
  let path = temp_root + "/hero.atlas.json"
  @fs.write_string_to_file(
    path,
    "{\n  \"version\": 0,\n  \"source_image\": \"assets/images/hero.png\",\n  \"tile_size\": {\"x\": 16, \"y\": 16},\n  \"columns\": 2,\n  \"rows\": 1\n}\n",
  )
  match read_atlas_asset_document_status(path) {
    MigrationRequired(preview) => {
      inspect(preview.atlas.name, content="Hero")
      inspect(preview.atlas.spacing, content="{x: 0, y: 0}")
      inspect(preview.atlas.default_anchor, content="{x: 0.5, y: 0.5}")
      inspect(preview.atlas.regions.length(), content="2")
      inspect(preview.changes.length(), content="6")
    }
    _ => fail("expected atlas migration preview")
  }
  let migrated = migrate_atlas_asset_document(path)
  inspect(migrated.version == atlas_asset_schema_version, content="true")
  inspect(read_atlas_asset_document(path).regions.length(), content="2")
}

///|
test "legacy animation documents can be probed and migrated" {
  let temp_root = "_build/editor-bridge-migration-animation"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }
  let path = temp_root + "/hero.anim.json"
  @fs.write_string_to_file(
    path,
    "{\n  \"version\": 0,\n  \"atlas_asset_path\": \"assets/atlases/hero.atlas.json\",\n  \"clips\": [\n    {\n      \"frames\": [\"frame_0\", \"frame_1\"]\n    }\n  ]\n}\n",
  )
  match read_animation_asset_document_status(path) {
    MigrationRequired(preview) => {
      inspect(preview.animation.name, content="Hero")
      inspect(preview.animation.default_clip, content="Some(\"clip_0\")")
      inspect(preview.animation.clips[0].name, content="clip_0")
      inspect(preview.animation.clips[0].fps, content="8")
      inspect(preview.changes.length(), content="6")
    }
    _ => fail("expected animation migration preview")
  }
  let migrated = migrate_animation_asset_document(path)
  inspect(migrated.version == animation_asset_schema_version, content="true")
  inspect(read_animation_asset_document(path).default_clip, content="Some(\"clip_0\")")
}

///|
test "invalid scene documents raise stable editor bridge errors" {
  let temp_root = "_build/editor-bridge-invalid-scene"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }
  let path = temp_root + "/broken.scene.json"
  @fs.write_string_to_file(path, "{\"version\":1,\"entities\":")
  let result : Result[SceneDocumentLoadStatus, Error] = try? read_scene_document_status(path)
  match result {
    Err(InvalidSceneDocument(_)) => inspect(true, content="true")
    _ => fail("expected InvalidSceneDocument")
  }
}

///|
test "invalid prefab, atlas, and animation documents raise stable editor bridge errors" {
  let temp_root = "_build/editor-bridge-invalid-assets"
  if !@fs.path_exists("_build") {
    @fs.create_dir("_build")
  }
  if !@fs.path_exists(temp_root) {
    @fs.create_dir(temp_root)
  }

  let prefab_path = temp_root + "/broken.prefab.json"
  @fs.write_string_to_file(
    prefab_path,
    "{\n  \"version\": 1,\n  \"name\": \"\",\n  \"entities\": []\n}\n",
  )
  let atlas_path = temp_root + "/broken.atlas.json"
  @fs.write_string_to_file(
    atlas_path,
    "{\n  \"version\": 1,\n  \"name\": \"Broken\",\n  \"source_image\": \"assets/images/hero.png\",\n  \"tile_size\": {\"x\": 0, \"y\": 0},\n  \"columns\": 0,\n  \"rows\": 0,\n  \"spacing\": {\"x\": 0, \"y\": 0},\n  \"margin\": {\"x\": 0, \"y\": 0},\n  \"default_anchor\": {\"x\": 0.5, \"y\": 0.5},\n  \"regions\": []\n}\n",
  )
  let animation_path = temp_root + "/broken.anim.json"
  @fs.write_string_to_file(
    animation_path,
    "{\n  \"version\": 1,\n  \"name\": \"Broken\",\n  \"atlas_asset_path\": \"assets/atlases/hero.atlas.json\",\n  \"clips\": [],\n  \"default_clip\": \"missing\"\n}\n",
  )

  let prefab_result : Result[PrefabDocument, Error] = try? read_prefab_document(prefab_path)
  let atlas_result : Result[AtlasAssetDocument, Error] = try? read_atlas_asset_document(atlas_path)
  let animation_result : Result[AnimationAssetDocument, Error] = try? read_animation_asset_document(animation_path)

  match prefab_result {
    Err(InvalidPrefabDocument(_)) => inspect(true, content="true")
    _ => fail("expected InvalidPrefabDocument")
  }
  match atlas_result {
    Err(InvalidAtlasAssetDocument(_)) => inspect(true, content="true")
    _ => fail("expected InvalidAtlasAssetDocument")
  }
  match animation_result {
    Err(InvalidAnimationAssetDocument(_)) => inspect(true, content="true")
    _ => fail("expected InvalidAnimationAssetDocument")
  }
}

///|
test "prefab, atlas, and animation documents round trip" {
  let prefab = PrefabDocument::empty("Enemy").with_entity(
    entity_document(
      "enemy",
      "Enemy",
      components=[name_component("Enemy"), transform2d_component()],
    ),
  )
  let atlas = AtlasAssetDocument::default("Hero Atlas", "assets/images/hero.png")
  let animation = AnimationAssetDocument::default(
    "Hero Animation",
    "assets/atlases/hero.atlas.json",
  )
  let decoded_prefab : PrefabDocument = @json.from_json(prefab.to_json())
  let decoded_atlas : AtlasAssetDocument = @json.from_json(atlas.to_json())
  let decoded_animation : AnimationAssetDocument = @json.from_json(
    animation.to_json(),
  )
  inspect(decoded_prefab == prefab, content="true")
  inspect(decoded_atlas == atlas, content="true")
  inspect(decoded_animation == animation, content="true")
}
