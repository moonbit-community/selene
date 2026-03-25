///|
fn path_join(base : String, child : String) -> String {
  if child.has_prefix("/") {
    child
  } else if base == "" {
    child
  } else if base.has_suffix("/") {
    base + child
  } else {
    base + "/" + child
  }
}

///|
fn strip_leading_slash(path : String) -> String {
  if path.has_prefix("/") {
    path[1:].to_string()
  } else {
    path
  }
}

///|
fn normalize_relative_path(path : String) -> String raise {
  let normalized = strip_leading_slash(path.replace(old="\\", new="/"))
  if normalized.contains("..") {
    raise InvalidEditorPath(path)
  }
  normalized
}

///|
fn extension_of(path : String) -> String? {
  if path.rev_find(".") is Some(index) {
    Some(path[index + 1:].to_string().to_lower())
  } else {
    None
  }
}

///|
fn basename_of(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn EditorService::public_path(self : EditorService, child : String) -> String {
  path_join(self.module_root, path_join("public", child))
}

///|
fn EditorService::frontend_bundle_path(self : EditorService) -> String {
  path_join(self.module_root, "_build/js/release/build/frontend/web/web.js")
}

///|
fn project_manifest_path(root : String, project_name : String) -> String {
  path_join(root, @shared.project_manifest_file_name(project_name))
}

///|
fn scene_path(root : String, relative_path : String) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}
