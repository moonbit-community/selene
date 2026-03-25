///|
async fn[T : FromJson] read_json_file(path : String) -> T {
  let content = @fs.read_file(path).text()
  let json = @json.parse(content)
  @json.from_json(json)
}

///|
async fn write_json_file(path : String, value : &ToJson) -> Unit {
  @fs.write_file(path, value.to_json().stringify(indent=2) + "\n")
}

///|
async fn ensure_dir(path : String) -> Unit {
  if !@fs.exists(path) {
    @fs.mkdir(path, permission=0o755, recursive=true)
  }
}

///|
async fn ensure_project_layout(root : String) -> Unit {
  ensure_dir(root)
  ensure_dir(path_join(root, "scenes"))
  ensure_dir(path_join(root, "assets"))
  ensure_dir(path_join(root, ".selene-editor"))
  ensure_dir(path_join(root, ".selene-editor/cache"))
}

///|
async fn load_project_manifest(root : String) -> @shared.ProjectManifest {
  let path = project_manifest_path(root)
  guard @fs.exists(path) else { raise MissingProjectManifest(path) }
  let manifest : @shared.ProjectManifest = read_json_file(path)
  let errors = @shared.validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise Failure("Invalid project manifest: " + errors.to_json().stringify())
  }
  manifest
}

///|
async fn save_project_manifest(
  root : String,
  manifest : @shared.ProjectManifest,
) -> Unit {
  write_json_file(project_manifest_path(root), manifest)
}

///|
async fn load_scene_document(
  root : String,
  relative_path : String,
) -> @shared.SceneDocument {
  let path = scene_path(root, relative_path)
  guard @fs.exists(path) else { raise SceneNotFound(relative_path) }
  let scene : @shared.SceneDocument = read_json_file(path)
  let errors = @shared.validate_scene_document(scene)
  guard errors.is_empty() else {
    raise Failure("Invalid scene document: " + errors.to_json().stringify())
  }
  scene
}

///|
async fn save_scene_document(
  root : String,
  relative_path : String,
  scene : @shared.SceneDocument,
) -> Unit {
  let path = scene_path(root, relative_path)
  let errors = @shared.validate_scene_document(scene)
  guard errors.is_empty() else {
    raise Failure("Invalid scene document: " + errors.to_json().stringify())
  }
  ensure_dir(path_join(root, "scenes"))
  write_json_file(path, scene)
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
async fn collect_assets(
  root : String,
  manifest : @shared.ProjectManifest,
) -> Array[@shared.AssetDocument] {
  let assets : Array[@shared.AssetDocument] = []
  for asset_root in manifest.asset_roots {
    let root_path = path_join(root, asset_root)
    if !@fs.exists(root_path) {
      continue
    }
    let files = list_files_recursive(root_path)
    for relative in files {
      let full_relative = path_join(asset_root, relative)
      let meta_relative = full_relative + ".meta.json"
      assets.push(
        @shared.asset_document(
          full_relative,
          @shared.infer_asset_kind(full_relative),
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
  manifest : @shared.ProjectManifest,
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
