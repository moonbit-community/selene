///|
pub struct ProjectBundle {
  manifest : ProjectManifest
  scene_path : String
  scene : SceneDocument
  atlas_assets : Map[String, AtlasAssetDocument]
  animation_clip_assets : Map[String, AnimationClipAssetDocument]
  animation_graph_assets : Map[String, AnimationGraphAssetDocument]
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
  let status = decode_project_manifest_status(path, json) catch {
    InvalidProjectManifest(message) =>
      raise InvalidProjectManifest(path + ": " + message)
    err => raise err
  }
  match status {
    Ready(manifest) => manifest
    MigrationRequired(preview) => preview.manifest
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
  decode_scene_snf(json) catch {
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
fn load_animation_clip_asset_document_from_source(
  source : DocumentSource,
  path : String,
) -> AnimationClipAssetDocument raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidAnimationClipAssetDocument(message)
  })
  decode_animation_clip_asset_document(json) catch {
    InvalidAnimationClipAssetDocument(message) =>
      raise InvalidAnimationClipAssetDocument(path + ": " + message)
    err => raise err
  }
}

///|
fn load_animation_graph_asset_document_from_source(
  source : DocumentSource,
  path : String,
) -> AnimationGraphAssetDocument raise {
  let json = parse_json_document(source, path, fn(message) {
    InvalidAnimationGraphAssetDocument(message)
  })
  decode_animation_graph_asset_document(json) catch {
    InvalidAnimationGraphAssetDocument(message) =>
      raise InvalidAnimationGraphAssetDocument(path + ": " + message)
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
fn scene_referenced_animation_graph_assets(
  scene : SceneDocument,
) -> Array[String] {
  let paths : Array[String] = []
  for entity in scene.entities {
    if entity.component("AnimationPlayer") is Some(component) {
      let decoded : AnimationPlayerComponent? = decode_component(
        Some(component),
      )
      match decoded {
        Some(data) => push_unique_path(paths, data.graph_asset_path)
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
fn graph_referenced_clip_assets(
  graphs : Map[String, AnimationGraphAssetDocument],
) -> Array[String] {
  let paths : Array[String] = []
  for _, graph in graphs {
    for node in graph.nodes {
      match node.kind {
        Clip(clip_asset_path~) =>
          if clip_asset_path != "" && !paths.contains(clip_asset_path) {
            paths.push(clip_asset_path)
          }
        _ => ()
      }
    }
  }
  paths
}

///|
fn clip_referenced_atlas_assets(
  clips : Map[String, AnimationClipAssetDocument],
) -> Array[String] {
  let paths : Array[String] = []
  for _, clip in clips {
    if clip.atlas_asset_path != "" && !paths.contains(clip.atlas_asset_path) {
      paths.push(clip.atlas_asset_path)
    }
  }
  paths
}

///|
fn load_animation_graph_assets_for_scene(
  source : DocumentSource,
  scene : SceneDocument,
) -> Map[String, AnimationGraphAssetDocument] raise {
  let assets : Map[String, AnimationGraphAssetDocument] = {}
  for path in scene_referenced_animation_graph_assets(scene) {
    assets.set(
      path,
      load_animation_graph_asset_document_from_source(source, path),
    )
  }
  assets
}

///|
fn load_animation_clip_assets_for_scene(
  source : DocumentSource,
  graphs : Map[String, AnimationGraphAssetDocument],
) -> Map[String, AnimationClipAssetDocument] raise {
  let assets : Map[String, AnimationClipAssetDocument] = {}
  for path in graph_referenced_clip_assets(graphs) {
    assets.set(
      path,
      load_animation_clip_asset_document_from_source(source, path),
    )
  }
  assets
}

///|
fn load_atlas_assets_for_scene(
  source : DocumentSource,
  scene : SceneDocument,
  clips : Map[String, AnimationClipAssetDocument],
) -> Map[String, AtlasAssetDocument] raise {
  let assets : Map[String, AtlasAssetDocument] = {}
  let paths = scene_referenced_atlas_assets(scene)
  for path in clip_referenced_atlas_assets(clips) {
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
  let animation_graph_assets = load_animation_graph_assets_for_scene(
    source, scene,
  )
  let animation_clip_assets = load_animation_clip_assets_for_scene(
    source, animation_graph_assets,
  )
  let atlas_assets = load_atlas_assets_for_scene(
    source, scene, animation_clip_assets,
  )
  {
    manifest,
    scene_path: resolved_scene_path,
    scene,
    atlas_assets,
    animation_clip_assets,
    animation_graph_assets,
  }
}
