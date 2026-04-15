///|
priv struct LegacyAnimationClipDocument {
  name : String?
  fps : Double?
  looping : Bool?
  frames : Array[String]?
} derive(FromJson)

///|
priv struct LegacyAnimationAssetDocument {
  name : String?
  atlas_asset_path : String?
  clips : Array[LegacyAnimationClipDocument]?
  default_clip : String?
} derive(FromJson)

///|
priv struct LegacyAnimationPlayerComponent {
  animation_asset_path : String?
  default_clip : String?
  autoplay : Bool?
  repeat_mode : String?
  speed : Double?
} derive(FromJson)

///|
fn normalized_clip_name(name : String?, index : Int) -> String {
  let fallback = "clip-\{index + 1}"
  match name {
    Some(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        fallback
      } else {
        trimmed
      }
    }
    None => fallback
  }
}

///|
fn graph_path_from_legacy_animation_path(
  path : String,
  fallback : String,
) -> String {
  let normalized = path.replace(old="\\", new="/")
  let stem = if normalized.has_suffix(".anim.json") {
    normalized[:normalized.length() - ".anim.json".length()].to_string()
  } else if normalized.has_suffix(".json") {
    normalized[:normalized.length() - ".json".length()].to_string()
  } else {
    normalized
  }
  let file_stem = if stem.rev_find("/") is Some(index) {
    stem[index + 1:].to_string()
  } else {
    stem
  }
  let base = @editor_bridge.normalized_document_stem(
    if file_stem == "" {
      fallback
    } else {
      file_stem
    },
  )
  "assets/animation_graphs/" +
  @editor_bridge.animation_graph_asset_file_name(base)
}

///|
fn inferred_graph_name(
  legacy : LegacyAnimationAssetDocument,
  fallback : String,
) -> String {
  match legacy.name {
    Some(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        fallback
      } else {
        trimmed
      }
    }
    None => fallback
  }
}

///|
fn legacy_animation_preview_for_scene(
  scene_path : String,
  scene : @editor_bridge.SceneDocument,
) -> @editor_bridge.SceneMigrationPreview? {
  let changes : Array[@editor_bridge.MigrationFieldChange] = []
  let mut migrated_scene = scene
  let mut touched = false
  for entity in scene.entities {
    guard entity.component("AnimationPlayer") is Some(player_component) else {
      continue
    }
    let legacy_result : Result[LegacyAnimationPlayerComponent, Error] = try? @json.from_json(
      player_component.data,
    )
    guard legacy_result is Ok(legacy) else { continue }
    guard legacy.animation_asset_path is Some(legacy_path) else { continue }
    let trimmed_legacy_path = legacy_path.trim().to_string()
    if trimmed_legacy_path == "" {
      continue
    }
    let graph_path = graph_path_from_legacy_animation_path(
      trimmed_legacy_path,
      entity.name,
    )
    let replacement = @editor_bridge.animation_player_component(
      graph_asset_path=Some(graph_path),
      start_node=legacy.default_clip,
      autoplay=legacy.autoplay.unwrap_or(false),
      repeat_mode=@editor_bridge.animation_repeat_mode_doc_from_string(
        legacy.repeat_mode.unwrap_or("forever"),
      ),
      speed=legacy.speed.unwrap_or(1.0),
    )
    migrated_scene = migrated_scene.with_entity(
      entity.with_component(replacement),
    )
    changes.push(
      @editor_bridge.migration_field_change(
        "entities[\{entity.id}].components[AnimationPlayer]",
        "Legacy animation player reference uses animation_asset_path",
        replacement.data.stringify(),
      ),
    )
    touched = true
  }
  if touched {
    Some(
      @editor_bridge.scene_migration_preview(
        scene_path, migrated_scene, changes,
      ),
    )
  } else {
    None
  }
}

///|
async fn migrate_legacy_animation_document(
  root : String,
  relative_path : String,
  scene_path : String,
) -> Unit {
  let legacy_path = path_join(root, normalize_relative_path(relative_path))
  guard @fs.exists(legacy_path) else { raise AnimationNotFound(relative_path) }
  let legacy_json = parse_json_file(legacy_path) catch {
    _ => raise Failure("Animation document is invalid: " + relative_path)
  }
  let legacy : LegacyAnimationAssetDocument = @json.from_json(legacy_json) catch {
    _ => raise Failure("Animation document is invalid: " + relative_path)
  }

  let graph_name = inferred_graph_name(
    legacy,
    @editor_bridge.normalized_document_stem(relative_path),
  )
  let graph_path = graph_path_from_legacy_animation_path(
    relative_path, graph_name,
  )
  let atlas_path = legacy.atlas_asset_path.unwrap_or("")
  let legacy_clips = legacy.clips.unwrap_or([])
  guard !legacy_clips.is_empty() else {
    raise Failure("Animation document is invalid: " + relative_path)
  }

  let clip_paths : Array[String] = []
  let mut index = 0
  for clip in legacy_clips {
    let clip_name = normalized_clip_name(clip.name, index)
    let clip_stem = @editor_bridge.normalized_document_stem(
      graph_name + "-" + clip_name,
    )
    let clip_path = "assets/animation_clips/" +
      @editor_bridge.animation_clip_asset_file_name(clip_stem)
    let clip_doc = @editor_bridge.animation_clip_asset_document(
      clip_name,
      atlas_path,
      clip.fps.unwrap_or(8.0),
      clip.looping.unwrap_or(true),
      clip.frames.unwrap_or(["frame_0"]),
    )
    save_animation_clip_asset_document(root, clip_path, clip_doc)
    clip_paths.push(clip_path)
    index += 1
  }

  let first_clip_path = clip_paths[0]
  let default_node = match legacy.default_clip {
    Some(name) =>
      Some(
        @editor_bridge.normalized_document_stem(
          if name.trim() == "" {
            legacy_clips[0].name.unwrap_or("default")
          } else {
            name
          },
        ),
      )
    None => Some("default")
  }
  let graph_doc = @editor_bridge.AnimationGraphAssetDocument::default(
    graph_name, first_clip_path,
  ).with_default_node(default_node)
  save_animation_graph_asset_document(root, graph_path, graph_doc)

  let status = load_scene_document(root, scene_path)
  let scene = match status {
    @editor_bridge.Ready(scene) => scene
    @editor_bridge.MigrationRequired(preview) => preview.scene
  }
  let migrated_preview = legacy_animation_preview_for_scene(scene_path, scene)
  guard migrated_preview is Some(preview) else { return }
  ignore(save_scene_document(root, scene_path, preview.scene))
}

///|
async fn load_scene_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.SceneDocumentLoadStatus {
  let path = scene_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Scene document is invalid: " + relative_path)
  }
  @editor_bridge.decode_scene_snf_status(relative_path, json) catch {
    @editor_bridge.InvalidSceneDocument(_) =>
      raise Failure("Scene document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn migrate_scene_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.SceneDocument {
  let path = scene_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Scene document is invalid: " + relative_path)
  }
  let scene = @editor_bridge.migrate_scene_to_snf(relative_path, json) catch {
    @editor_bridge.InvalidSceneDocument(_) =>
      raise Failure("Scene document is invalid: " + relative_path)
    err => raise err
  }
  ignore(save_scene_document(root, relative_path, scene))
  scene
}

///|
fn scene_bundle_response_of_bundle(
  bundle : @editor_bridge.ProjectBundle,
  disk_state : SceneDiskState,
) -> @shared.SceneBundleResponse {
  let atlas_assets : Array[@shared.SceneBundleAtlasEntry] = []
  let animation_clip_assets : Array[@shared.SceneBundleAnimationClipEntry] = []
  let animation_graph_assets : Array[@shared.SceneBundleAnimationGraphEntry] = []
  for path, atlas in bundle.atlas_assets {
    atlas_assets.push(@shared.scene_bundle_atlas_entry(path, atlas))
  }
  for path, clip in bundle.animation_clip_assets {
    animation_clip_assets.push(
      @shared.scene_bundle_animation_clip_entry(path, clip),
    )
  }
  for path, graph in bundle.animation_graph_assets {
    animation_graph_assets.push(
      @shared.scene_bundle_animation_graph_entry(path, graph),
    )
  }
  @shared.scene_bundle_response(
    bundle.scene_path,
    bundle.scene,
    disk_hash=disk_state.hash,
    disk_revision=disk_state.revision,
  ).with_assets(atlas_assets, animation_clip_assets, animation_graph_assets)
}

///|
async fn load_scene_bundle(
  root : String,
  relative_path : String,
) -> @shared.SceneBundleResponse {
  let source = native_document_source(root)
  let bundle = @editor_bridge.load_project_bundle(
    source,
    manifest_path=@editor_bridge.project_manifest_file_name(""),
    scene_path=Some(relative_path),
  ) catch {
    @editor_bridge.InvalidSceneDocument(_) =>
      raise Failure("Scene document is invalid: " + relative_path)
    @editor_bridge.InvalidAtlasAssetDocument(_) =>
      raise Failure("Atlas document is invalid: " + relative_path)
    @editor_bridge.InvalidAnimationClipAssetDocument(_) =>
      raise Failure("Animation clip document is invalid: " + relative_path)
    @editor_bridge.InvalidAnimationGraphAssetDocument(_) =>
      raise Failure("Animation graph document is invalid: " + relative_path)
    @editor_bridge.MissingDocument(path) =>
      raise Failure("Missing document dependency: " + path)
    err => raise err
  }
  scene_bundle_response_of_bundle(bundle, scene_disk_state(root, relative_path))
}

///|
async fn save_scene_document(
  root : String,
  relative_path : String,
  scene : @editor_bridge.SceneDocument,
) -> SceneDiskState {
  ignore(@editor_bridge.decode_scene_snf(scene.to_json()))
  let scene_snf = @editor_bridge.encode_scene_snf(scene)
  let path = scene_path(root, relative_path)
  ensure_dir(path_join(root, "scenes"))
  write_text_file(path, scene_snf)
  scene_disk_state(root, relative_path)
}

///|
async fn list_scene_documents(root : String) -> Array[@editor_bridge.SceneRef] {
  let scenes_root = path_join(root, "scenes")
  list_document_refs(
    scenes_root,
    "scenes/",
    ".scene.json",
    fn(path) { @editor_bridge.scene_ref(path) },
    fn(scene_ref) { scene_ref.path },
  )
}
