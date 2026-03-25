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
    content="bdd-demo.project.json",
  )
  inspect(
    startup_scene_path_for_name("BDD Demo"),
    content="scenes/bdd-demo.scene.json",
  )
  inspect(
    project_manifest_file_name("  项目 A  "),
    content="项目-a.project.json",
  )
}

///|
test "scene document round trip" {
  let scene = SceneDocument::{
    version: scene_schema_version,
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
test "rpc success and failure round trip" {
  let success : RpcSuccess = @json.from_json(
    rpc_success(7, { "ok": true.to_json() }),
  )
  let failure : RpcFailure = @json.from_json(
    rpc_failure(Some(9), "broken", "Something failed"),
  )
  let ok = match success.result {
    Json::Object(fields) => fields["ok"]
    _ => Json::null()
  }
  inspect(success.id, content="7")
  inspect(ok, content="True")
  inspect(failure.id, content="Some(9)")
  inspect(failure.error.details, content="Null")
}
