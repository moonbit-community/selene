///|
pub suberror EditorBridgeFileError {
  InvalidProjectManifest(String)
  InvalidSceneDocument(String)
}

///|
fn[T : FromJson] read_json_file(path : String) -> T raise {
  let content = @fs.read_file_to_string(path)
  let json = @json.parse(content)
  @json.from_json(json)
}

///|
fn write_json_file(path : String, value : &ToJson) -> Unit raise {
  @fs.write_string_to_file(path, value.to_json().stringify(indent=2) + "\n")
}

///|
fn parent_dir(path : String) -> String? {
  let normalized = path.replace(old="\\", new="/")
  let trimmed = if normalized.has_suffix("/") && normalized.length() > 1 {
    normalized[:normalized.length() - 1]
  } else {
    normalized
  }
  if trimmed == "" || trimmed == "." {
    return None
  }
  if trimmed.rev_find("/") is Some(index) {
    if index == 0 {
      Some("/")
    } else {
      Some(trimmed[:index].to_string())
    }
  } else {
    None
  }
}

///|
fn ensure_dir(path : String) -> Unit raise {
  if path == "" || path == "." || @fs.path_exists(path) {
    return
  }
  if parent_dir(path) is Some(parent) && parent != path {
    ensure_dir(parent)
  }
  if !@fs.path_exists(path) {
    @fs.create_dir(path)
  }
}

///|
pub fn ensure_project_layout(root : String) -> Unit raise {
  ensure_dir(root)
  ensure_dir(root + "/scenes")
  ensure_dir(root + "/assets")
  ensure_dir(root + "/.selene-editor")
  ensure_dir(root + "/.selene-editor/cache")
}

///|
pub fn project_manifest_candidates(root : String) -> Array[String] raise {
  let candidates : Array[String] = []
  if !@fs.path_exists(root) {
    return candidates
  }
  let path = root + "/" + project_manifest_file_name("")
  if @fs.path_exists(path) {
    if @fs.is_file(path) {
      candidates.push(path)
    }
  }
  candidates
}

///|
pub fn read_project_manifest(path : String) -> ProjectManifest raise {
  let manifest : ProjectManifest = read_json_file(path)
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(errors.to_json().stringify())
  }
  manifest
}

///|
pub fn write_project_manifest(
  path : String,
  manifest : ProjectManifest,
) -> Unit raise {
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(errors.to_json().stringify())
  }
  write_json_file(path, manifest)
}

///|
pub fn read_scene_document(path : String) -> SceneDocument raise {
  let scene : SceneDocument = read_json_file(path)
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(errors.to_json().stringify())
  }
  scene
}

///|
pub fn write_scene_document(path : String, scene : SceneDocument) -> Unit raise {
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(errors.to_json().stringify())
  }
  write_json_file(path, scene)
}

///|
fn list_files_recursive(root : String) -> Array[String] raise {
  let files : Array[String] = []
  if !@fs.path_exists(root) {
    return files
  }
  fn visit(path : String, prefix : String) -> Unit raise {
    guard @fs.is_dir(path) else {
      files.push(prefix)
      return
    }
    let entries = @fs.read_dir(path)
    entries.sort()
    for entry in entries {
      let child_path = if path.has_suffix("/") {
        path + entry
      } else {
        path + "/" + entry
      }
      let child_prefix = if prefix == "" {
        entry
      } else if prefix.has_suffix("/") {
        prefix + entry
      } else {
        prefix + "/" + entry
      }
      visit(child_path, child_prefix)
    }
  }
  visit(root, "")
  files
}

///|
pub fn collect_asset_documents(
  root : String,
  asset_roots : Array[String],
) -> Array[AssetDocument] raise {
  let assets : Array[AssetDocument] = []
  for asset_root in asset_roots {
    let root_path = root + "/" + asset_root
    if !@fs.path_exists(root_path) {
      continue
    }
    for relative in list_files_recursive(root_path) {
      let full_relative = asset_root + "/" + relative
      let meta_relative = full_relative + ".meta.json"
      assets.push(
        asset_document(
          full_relative,
          infer_asset_kind(full_relative),
          meta_path=if @fs.path_exists(root + "/" + meta_relative) {
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
