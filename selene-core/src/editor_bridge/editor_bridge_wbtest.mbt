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
    content="scenes/main.scene.json",
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
test "scene runtime instantiates camera and mesh entities" {
  let scene = SceneDocument::{
    version: scene_schema_version,
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
