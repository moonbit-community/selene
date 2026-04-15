///|
fn path_join(base : String, child : String) -> String {
  let lhs : @path.Path = base
  let rhs : @path.Path = child
  @path.Path::join(lhs, rhs).to_string()
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
fn hex_nibble(char : Char) -> Int? {
  let code = char.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    Some(code - '0'.to_int())
  } else if code >= 'a'.to_int() && code <= 'f'.to_int() {
    Some(10 + code - 'a'.to_int())
  } else if code >= 'A'.to_int() && code <= 'F'.to_int() {
    Some(10 + code - 'A'.to_int())
  } else {
    None
  }
}

///|
fn percent_decode_path(path : String) -> String raise {
  let decoded = StringBuilder::new()
  let chars = path.to_array()
  let mut index = 0
  while index < chars.length() {
    let ch = chars[index]
    if ch == '%' {
      guard index + 2 < chars.length() else { raise InvalidEditorPath(path) }
      guard hex_nibble(chars[index + 1]) is Some(high) else {
        raise InvalidEditorPath(path)
      }
      guard hex_nibble(chars[index + 2]) is Some(low) else {
        raise InvalidEditorPath(path)
      }
      decoded.write_char((high * 16 + low).unsafe_to_char())
      index += 3
    } else {
      decoded.write_char(ch)
      index += 1
    }
  }
  decoded.to_string()
}

///|
fn normalize_relative_path(path : String) -> String raise {
  let decoded : @path.Path = percent_decode_path(path).replace(
    old="\\",
    new="/",
  )
  let normalized = strip_leading_slash(
    @path.Path::normalize(decoded).to_string(),
  )
  if normalized.contains("..") {
    raise InvalidEditorPath(path)
  }
  normalized
}

///|
fn extension_of(path : String) -> String? {
  let ext = @path.Path::extname(path).to_string().to_lower()
  if ext == "" {
    None
  } else if ext.has_prefix(".") {
    Some(ext[1:].to_string())
  } else {
    Some(ext)
  }
}

///|
fn basename_of(path : String) -> String {
  @path.Path::basename(path).to_string()
}

///|
fn inferred_project_name(root : String) -> String {
  let base = basename_of(root).trim().to_string()
  if base == "" {
    "Selene Project"
  } else {
    base
  }
}

///|
fn EditorService::public_path(self : EditorService, child : String) -> String {
  path_join(self.module_root, path_join("public", child))
}

///|
fn EditorService::editor_script_path(self : EditorService) -> String {
  self.public_path("editor.js")
}

///|
fn project_manifest_path(root : String, project_name : String) -> String {
  path_join(root, @editor_bridge.project_manifest_file_name(project_name))
}

///|
fn scene_path(root : String, relative_path : String) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}

///|
fn prefab_path(root : String, relative_path : String) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}

///|
fn atlas_asset_path(root : String, relative_path : String) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}

///|
fn animation_clip_asset_path(
  root : String,
  relative_path : String,
) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}

///|
fn animation_graph_asset_path(
  root : String,
  relative_path : String,
) -> String raise {
  path_join(root, normalize_relative_path(relative_path))
}

///|
fn workspace_path(root : String) -> String {
  path_join(root, ".selene-editor/workspace.json")
}
