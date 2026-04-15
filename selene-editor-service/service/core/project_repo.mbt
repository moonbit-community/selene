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
