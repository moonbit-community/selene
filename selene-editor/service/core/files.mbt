///|
async fn ensure_dir(path : String) -> Unit {
  if !@fs.exists(path) {
    @fs.mkdir(path, permission=0o755, recursive=true)
  }
}

///|
fn ensure_project_layout(root : String) -> Unit raise {
  @editor_bridge.ensure_project_layout(root)
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
  @editor_bridge.read_project_manifest(path)
}

///|
fn save_project_manifest(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Unit raise {
  @editor_bridge.write_project_manifest(
    project_manifest_path(root, manifest.name),
    manifest,
  )
}

///|
async fn load_scene_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.SceneDocument {
  let path = scene_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  @editor_bridge.read_scene_document(path)
}

///|
async fn save_scene_document(
  root : String,
  relative_path : String,
  scene : @editor_bridge.SceneDocument,
) -> Unit {
  let path = scene_path(root, relative_path)
  ensure_dir(path_join(root, "scenes"))
  @editor_bridge.write_scene_document(path, scene)
}

///|
fn list_scene_documents(
  root : String,
) -> Array[@editor_bridge.SceneRef] raise {
  @editor_bridge.list_scene_documents(root)
}

///|
async fn load_prefab_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.PrefabDocument {
  let path = prefab_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  @editor_bridge.read_prefab_document(path)
}

///|
async fn save_prefab_document(
  root : String,
  relative_path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> Unit {
  let path = prefab_path(root, relative_path)
  ensure_dir(path_join(root, "prefabs"))
  @editor_bridge.write_prefab_document(path, prefab)
}

///|
fn list_prefab_documents(
  root : String,
) -> Array[@editor_bridge.PrefabRef] raise {
  @editor_bridge.list_prefab_documents(root)
}

///|
async fn load_atlas_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AtlasAssetDocument {
  let path = atlas_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  @editor_bridge.read_atlas_asset_document(path)
}

///|
async fn save_atlas_asset_document(
  root : String,
  relative_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Unit {
  let path = atlas_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/atlases"))
  @editor_bridge.write_atlas_asset_document(path, atlas)
}

///|
fn list_atlas_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] raise {
  @editor_bridge.list_atlas_assets(root)
}

///|
async fn load_animation_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AnimationAssetDocument {
  let path = animation_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  @editor_bridge.read_animation_asset_document(path)
}

///|
async fn save_animation_asset_document(
  root : String,
  relative_path : String,
  animation : @editor_bridge.AnimationAssetDocument,
) -> Unit {
  let path = animation_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/animations"))
  @editor_bridge.write_animation_asset_document(path, animation)
}

///|
fn list_animation_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] raise {
  @editor_bridge.list_animation_assets(root)
}

///|
async fn load_workspace_document(root : String) -> @editor_bridge.WorkspaceDocument {
  let path = workspace_path(root)
  if !@fs.exists(path) {
    return @editor_bridge.WorkspaceDocument::default()
  }
  @editor_bridge.read_workspace_document(path)
}

///|
fn save_workspace_document(
  root : String,
  workspace : @editor_bridge.WorkspaceDocument,
) -> Unit raise {
  @editor_bridge.write_workspace_document(workspace_path(root), workspace)
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
fn collect_assets(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Array[@editor_bridge.AssetDocument] raise {
  @editor_bridge.collect_asset_documents(root, manifest.asset_roots)
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
