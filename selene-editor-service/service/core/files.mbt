///|
async fn ensure_dir(path : String) -> Unit {
  if !@fs.exists(path) {
    @fs.mkdir(path, permission=0o755, recursive=true)
  }
}

///|
async fn ensure_parent_dir(path : String) -> Unit {
  if path.rev_find("/") is Some(index) {
    let parent = path[:index].to_string()
    if parent != "" {
      ensure_dir(parent)
    }
  }
}

///|
async fn parse_json_file(path : String) -> Json {
  let content = @fs.read_file(path).text()
  @json.parse(content)
}

///|
async fn write_json_file(path : String, value : &ToJson) -> Unit {
  ensure_parent_dir(path)
  @fs.write_file(
    path,
    @utf8.encode(value.to_json().stringify(indent=2) + "\n"),
    create=0o644,
  )
}

///|
async fn write_text_file(path : String, content : String) -> Unit {
  ensure_parent_dir(path)
  @fs.write_file(path, @utf8.encode(content), create=0o644)
}

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
  save_scene_document(root, scene_path, preview.scene)
}

///|
async fn native_document_source(root : String) -> @editor_bridge.DocumentSource {
  let documents : Map[String, Bytes] = {}
  for relative_path in list_files_recursive(root) {
    let full_path = path_join(root, relative_path)
    let read_result : Result[&@io.Data, Error] = try? @fs.read_file(full_path)
    match read_result {
      Ok(data) => documents.set(relative_path, data.binary())
      Err(_) => ()
    }
  }
  @editor_bridge.map_document_source(documents)
}

///|
async fn ensure_project_layout(root : String) -> Unit {
  ensure_dir(root)
  ensure_dir(path_join(root, "scenes"))
  ensure_dir(path_join(root, "prefabs"))
  ensure_dir(path_join(root, "assets"))
  ensure_dir(path_join(root, "assets/images"))
  ensure_dir(path_join(root, "assets/audio"))
  ensure_dir(path_join(root, "assets/fonts"))
  ensure_dir(path_join(root, "assets/atlases"))
  ensure_dir(path_join(root, "assets/animation_clips"))
  ensure_dir(path_join(root, "assets/animation_graphs"))
  ensure_dir(path_join(root, ".selene-editor"))
  ensure_dir(path_join(root, ".selene-editor/cache"))
}

///|
async fn project_manifest_candidates(root : String) -> Array[String] {
  let candidates : Array[String] = []
  if !@fs.exists(root) {
    return candidates
  }
  let path = project_manifest_path(root, "")
  if @fs.exists(path) {
    if @fs.kind(path) != Directory {
      candidates.push(path)
    }
  }
  candidates
}

///|
async fn newer_path_by_mtime(left : String, right : String) -> String {
  let (left_sec, left_nano) = @fs.mtime(left)
  let (right_sec, right_nano) = @fs.mtime(right)
  if right_sec > left_sec || (right_sec == left_sec && right_nano > left_nano) {
    right
  } else {
    left
  }
}

///|
async fn project_manifest_path_to_load(root : String) -> String? {
  let candidates = project_manifest_candidates(root)
  if !candidates.is_empty() {
    let mut latest = candidates[0]
    for current in candidates[1:] {
      latest = newer_path_by_mtime(latest, current)
    }
    return Some(latest)
  }
  None
}

///|
async fn load_project_manifest(root : String) -> @editor_bridge.ProjectManifest {
  let maybe_path = project_manifest_path_to_load(root)
  guard maybe_path is Some(path) else {
    raise MissingProjectManifest(project_manifest_path(root, ""))
  }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Project manifest is invalid: selene.project.json")
  }
  let status = @editor_bridge.decode_project_manifest_status(
    @editor_bridge.project_manifest_file_name(""),
    json,
  ) catch {
    @editor_bridge.InvalidProjectManifest(_) =>
      raise Failure("Project manifest is invalid: selene.project.json")
    err => raise err
  }
  match status {
    @editor_bridge.Ready(manifest) => manifest
    @editor_bridge.MigrationRequired(preview) => {
      write_json_file(path, preview.manifest)
      preview.manifest
    }
  }
}

///|
async fn synced_manifest_with_indexes(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> @editor_bridge.ProjectManifest {
  manifest.with_indexes(
    list_scene_documents(root),
    list_prefab_documents(root),
    list_atlas_asset_documents(root),
    list_animation_clip_asset_documents(root),
    list_animation_graph_asset_documents(root),
  )
}

///|
async fn save_project_manifest(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Unit {
  let synced = synced_manifest_with_indexes(root, manifest)
  ignore(@editor_bridge.decode_project_manifest(synced.to_json()))
  write_json_file(project_manifest_path(root, ""), synced)
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
  save_scene_document(root, relative_path, scene)
  scene
}

///|
fn scene_bundle_response_of_bundle(
  bundle : @editor_bridge.ProjectBundle,
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
  @shared.scene_bundle_response(bundle.scene_path, bundle.scene).with_assets(
    atlas_assets, animation_clip_assets, animation_graph_assets,
  )
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
  scene_bundle_response_of_bundle(bundle)
}

///|
async fn save_scene_document(
  root : String,
  relative_path : String,
  scene : @editor_bridge.SceneDocument,
) -> Unit {
  ignore(@editor_bridge.decode_scene_snf(scene.to_json()))
  let scene_snf = @editor_bridge.encode_scene_snf(scene)
  let path = scene_path(root, relative_path)
  ensure_dir(path_join(root, "scenes"))
  write_text_file(path, scene_snf)
}

///|
async fn list_files_recursive(root : String) -> Array[String] {
  let files : Array[String] = []
  if !@fs.exists(root) {
    return files
  }
  async fn visit(path : String, prefix : String) -> Unit {
    match @fs.kind(path) {
      Directory => {
        let entries = @fs.readdir(path, sort=true)
        for entry in entries {
          let child_path = path_join(path, entry)
          let child_prefix = if prefix == "" {
            entry
          } else {
            path_join(prefix, entry)
          }
          visit(child_path, child_prefix)
        }
      }
      _ => files.push(prefix)
    }
  }
  visit(root, "")
  files
}

///|
async fn list_scene_documents(root : String) -> Array[@editor_bridge.SceneRef] {
  let refs : Array[@editor_bridge.SceneRef] = []
  let scenes_root = path_join(root, "scenes")
  for relative in list_files_recursive(scenes_root) {
    if relative.has_suffix(".scene.json") {
      refs.push(@editor_bridge.scene_ref("scenes/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
async fn load_prefab_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.PrefabDocument {
  let path = prefab_path(root, relative_path)
  guard @fs.exists(path) else { raise PrefabNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Prefab document is invalid: " + relative_path)
  }
  @editor_bridge.decode_prefab_document(json) catch {
    @editor_bridge.InvalidPrefabDocument(_) =>
      raise Failure("Prefab document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_prefab_document(
  root : String,
  relative_path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> Unit {
  ignore(@editor_bridge.decode_prefab_document(prefab.to_json()))
  let path = prefab_path(root, relative_path)
  ensure_dir(path_join(root, "prefabs"))
  write_json_file(path, prefab)
}

///|
async fn list_prefab_documents(
  root : String,
) -> Array[@editor_bridge.PrefabRef] {
  let refs : Array[@editor_bridge.PrefabRef] = []
  let prefabs_root = path_join(root, "prefabs")
  for relative in list_files_recursive(prefabs_root) {
    if relative.has_suffix(".prefab.json") {
      refs.push(@editor_bridge.prefab_ref("prefabs/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
async fn load_atlas_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AtlasAssetDocument {
  let path = atlas_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AtlasNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Atlas document is invalid: " + relative_path)
  }
  @editor_bridge.decode_atlas_asset_document(json) catch {
    @editor_bridge.InvalidAtlasAssetDocument(_) =>
      raise Failure("Atlas document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_atlas_asset_document(
  root : String,
  relative_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Unit {
  ignore(@editor_bridge.decode_atlas_asset_document(atlas.to_json()))
  let path = atlas_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/atlases"))
  write_json_file(path, atlas)
}

///|
async fn list_atlas_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let refs : Array[@editor_bridge.AssetRef] = []
  let assets_root = path_join(root, "assets/atlases")
  for relative in list_files_recursive(assets_root) {
    if relative.has_suffix(".atlas.json") {
      refs.push(@editor_bridge.asset_ref("assets/atlases/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
async fn load_animation_clip_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AnimationClipAssetDocument {
  let path = animation_clip_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AnimationNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Animation clip document is invalid: " + relative_path)
  }
  @editor_bridge.decode_animation_clip_asset_document(json) catch {
    @editor_bridge.InvalidAnimationClipAssetDocument(_) =>
      raise Failure("Animation clip document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_animation_clip_asset_document(
  root : String,
  relative_path : String,
  clip : @editor_bridge.AnimationClipAssetDocument,
) -> Unit {
  ignore(@editor_bridge.decode_animation_clip_asset_document(clip.to_json()))
  let path = animation_clip_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/animation_clips"))
  write_json_file(path, clip)
}

///|
async fn list_animation_clip_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let refs : Array[@editor_bridge.AssetRef] = []
  let assets_root = path_join(root, "assets/animation_clips")
  for relative in list_files_recursive(assets_root) {
    if relative.has_suffix(".clip.json") {
      refs.push(@editor_bridge.asset_ref("assets/animation_clips/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
async fn load_animation_graph_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AnimationGraphAssetDocument {
  let path = animation_graph_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AnimationNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Animation graph document is invalid: " + relative_path)
  }
  @editor_bridge.decode_animation_graph_asset_document(json) catch {
    @editor_bridge.InvalidAnimationGraphAssetDocument(_) =>
      raise Failure("Animation graph document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_animation_graph_asset_document(
  root : String,
  relative_path : String,
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> Unit {
  ignore(@editor_bridge.decode_animation_graph_asset_document(graph.to_json()))
  let path = animation_graph_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/animation_graphs"))
  write_json_file(path, graph)
}

///|
async fn list_animation_graph_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let refs : Array[@editor_bridge.AssetRef] = []
  let assets_root = path_join(root, "assets/animation_graphs")
  for relative in list_files_recursive(assets_root) {
    if relative.has_suffix(".graph.json") {
      refs.push(@editor_bridge.asset_ref("assets/animation_graphs/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
async fn load_workspace_document(
  root : String,
) -> @editor_bridge.WorkspaceDocument {
  let path = workspace_path(root)
  if !@fs.exists(path) {
    return @editor_bridge.WorkspaceDocument::default()
  }
  let json = parse_json_file(path) catch {
    _ =>
      raise Failure(
        "Workspace document is invalid: .selene-editor/workspace.json",
      )
  }
  @editor_bridge.decode_workspace_document(json) catch {
    @editor_bridge.InvalidWorkspaceDocument(_) =>
      raise Failure(
        "Workspace document is invalid: .selene-editor/workspace.json",
      )
    err => raise err
  }
}

///|
async fn save_workspace_document(
  root : String,
  workspace : @editor_bridge.WorkspaceDocument,
) -> Unit {
  ignore(@editor_bridge.decode_workspace_document(workspace.to_json()))
  ensure_dir(path_join(root, ".selene-editor"))
  write_json_file(workspace_path(root), workspace)
}

///|
async fn collect_assets(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Array[@editor_bridge.AssetDocument] {
  let assets : Array[@editor_bridge.AssetDocument] = []
  for asset_root in manifest.asset_roots {
    let root_path = path_join(root, asset_root)
    if !@fs.exists(root_path) {
      continue
    }
    for relative in list_files_recursive(root_path) {
      let full_relative = path_join(asset_root, relative)
      let meta_relative = full_relative + ".meta.json"
      assets.push(
        @editor_bridge.asset_document(
          full_relative,
          @editor_bridge.infer_asset_kind(full_relative),
          meta_path=if @fs.exists(path_join(root, meta_relative)) {
            Some(meta_relative)
          } else {
            None
          },
        ),
      )
    }
  }
  assets.sort_by(fn(left, right) { left.path.compare(right.path) })
  assets
}

///|
async fn snapshot_project_files(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Map[String, String] {
  let snapshot : Map[String, String] = {}
  let tracked_roots = [".", "scenes"] + manifest.asset_roots
  for tracked in tracked_roots {
    let dir_path = if tracked == "." { root } else { path_join(root, tracked) }
    if !@fs.exists(dir_path) {
      continue
    }
    let files = list_files_recursive(dir_path)
    for relative in files {
      let full_path = if tracked == "." {
        path_join(root, relative)
      } else {
        path_join(dir_path, relative)
      }
      let key = if tracked == "." {
        relative
      } else {
        path_join(tracked, relative)
      }
      let (sec, nano) = @fs.mtime(full_path)
      snapshot.set(key, "\{sec}:\{nano}")
    }
  }
  snapshot
}
