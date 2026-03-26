///|
pub struct ProjectBundle {
  manifest : ProjectManifest
  scene_path : String
  scene : SceneDocument
  atlas_assets : Map[String, AtlasAssetDocument]
  animation_assets : Map[String, AnimationAssetDocument]
} derive(Show, Eq, ToJson, FromJson)

///|
fn parse_json_document(
  source : DocumentSource,
  path : String,
  invalid : (String) -> Error,
) -> Json raise {
  guard source(path) is Some(bytes) else { raise MissingDocument(path) }
  let text = @utf8.decode(bytes) catch {
    _ => raise invalid("Invalid UTF-8 at " + path)
  }
  @json.parse(text) catch {
    err => raise invalid("Invalid JSON at " + path + ": " + err.to_string())
  }
}

///|
fn load_project_manifest_from_source(
  source : DocumentSource,
  path : String,
) -> ProjectManifest raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidProjectManifest(message)
  })
  decode_project_manifest(json) catch {
    InvalidProjectManifest(message) =>
      raise InvalidProjectManifest(path + ": " + message)
    err => raise err
  }
}

///|
fn load_scene_document_from_source(
  source : DocumentSource,
  path : String,
) -> SceneDocument raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidSceneDocument(message)
  })
  decode_scene_document(json) catch {
    InvalidSceneDocument(message) =>
      raise InvalidSceneDocument(path + ": " + message)
    err => raise err
  }
}

///|
fn load_atlas_asset_document_from_source(
  source : DocumentSource,
  path : String,
) -> AtlasAssetDocument raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidAtlasAssetDocument(message)
  })
  decode_atlas_asset_document(json) catch {
    InvalidAtlasAssetDocument(message) =>
      raise InvalidAtlasAssetDocument(path + ": " + message)
    err => raise err
  }
}

///|
fn load_animation_asset_document_from_source(
  source : DocumentSource,
  path : String,
) -> AnimationAssetDocument raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidAnimationAssetDocument(message)
  })
  decode_animation_asset_document(json) catch {
    InvalidAnimationAssetDocument(message) =>
      raise InvalidAnimationAssetDocument(path + ": " + message)
    err => raise err
  }
}

///|
fn push_unique_path(paths : Array[String], path : String?) -> Unit {
  guard path is Some(value) else { return }
  guard value != "" && !paths.contains(value) else { return }
  paths.push(value)
}

///|
fn scene_referenced_animation_assets(scene : SceneDocument) -> Array[String] {
  let paths : Array[String] = []
  for entity in scene.entities {
    if entity.component("AnimationPlayer") is Some(component) {
      let decoded : AnimationPlayerComponent? = decode_component(
        Some(component),
      )
      match decoded {
        Some(data) => push_unique_path(paths, data.animation_asset_path)
        None => ()
      }
    }
  }
  paths
}

///|
fn scene_referenced_atlas_assets(scene : SceneDocument) -> Array[String] {
  let paths : Array[String] = []
  for entity in scene.entities {
    if entity.component("TextureAtlas") is Some(component) {
      let decoded : TextureAtlasComponent? = decode_component(Some(component))
      match decoded {
        Some(data) => push_unique_path(paths, data.atlas_asset_path)
        None => ()
      }
    }
  }
  paths
}

///|
fn animation_referenced_atlas_assets(
  animations : Map[String, AnimationAssetDocument],
) -> Array[String] {
  let paths : Array[String] = []
  for _, animation in animations {
    if animation.atlas_asset_path != "" &&
      !paths.contains(animation.atlas_asset_path) {
      paths.push(animation.atlas_asset_path)
    }
  }
  paths
}

///|
fn load_animation_assets_for_scene(
  source : DocumentSource,
  scene : SceneDocument,
) -> Map[String, AnimationAssetDocument] raise {
  let assets : Map[String, AnimationAssetDocument] = {}
  for path in scene_referenced_animation_assets(scene) {
    assets.set(path, load_animation_asset_document_from_source(source, path))
  }
  assets
}

///|
fn load_atlas_assets_for_scene(
  source : DocumentSource,
  scene : SceneDocument,
  animations : Map[String, AnimationAssetDocument],
) -> Map[String, AtlasAssetDocument] raise {
  let assets : Map[String, AtlasAssetDocument] = {}
  let paths = scene_referenced_atlas_assets(scene)
  for path in animation_referenced_atlas_assets(animations) {
    if !paths.contains(path) {
      paths.push(path)
    }
  }
  for path in paths {
    assets.set(path, load_atlas_asset_document_from_source(source, path))
  }
  assets
}

///|
pub fn load_project_bundle(
  source : DocumentSource,
  manifest_path? : String = "selene.project.json",
  scene_path? : String? = None,
) -> ProjectBundle raise {
  let manifest = load_project_manifest_from_source(source, manifest_path)
  let resolved_scene_path = scene_path.unwrap_or(manifest.startup_scene)
  let scene = load_scene_document_from_source(source, resolved_scene_path)
  let animation_assets = load_animation_assets_for_scene(source, scene)
  let atlas_assets = load_atlas_assets_for_scene(
    source, scene, animation_assets,
  )
  {
    manifest,
    scene_path: resolved_scene_path,
    scene,
    atlas_assets,
    animation_assets,
  }
}
