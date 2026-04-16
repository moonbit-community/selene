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
async fn write_text_file(path : String, content : String) -> Unit {
  ensure_parent_dir(path)
  @fs.write_file(path, @utf8.encode(content), create=0o644)
}

///|
priv struct SceneDiskState {
  hash : String
  revision : Int
}

///|
fn scene_hash_int(content : String) -> Int {
  let mut value = 146959810
  for ch in content.to_array() {
    value = (value ^ ch.to_int()) * 16777619 % 2147483647
  }
  value
}

///|
fn scene_hash(content : String) -> String {
  scene_hash_int(content).to_string()
}

///|
async fn scene_disk_state(
  root : String,
  relative_path : String,
) -> SceneDiskState {
  let path = scene_path(root, relative_path)
  guard @fs.exists(path) else { return { hash: "", revision: 0 } }
  let content = @fs.read_file(path).text()
  { hash: scene_hash(content), revision: scene_hash_int(content) }
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
async fn[T] list_document_refs(
  root : String,
  prefix : String,
  suffix : String,
  to_ref : (String) -> T,
  path_of : (T) -> String,
) -> Array[T] {
  let refs : Array[T] = []
  for relative in list_files_recursive(root) {
    if relative.has_suffix(suffix) {
      refs.push(to_ref(prefix + relative))
    }
  }
  refs.sort_by(fn(left, right) { path_of(left).compare(path_of(right)) })
  refs
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
