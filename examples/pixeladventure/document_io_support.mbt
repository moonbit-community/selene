///|
fn read_file_bytes_if_exists(path : String) -> Bytes? {
  if !@fs.path_exists(path) {
    return None
  }
  let result : Result[Bytes, Error] = try? @fs.read_file_to_bytes(path)
  match result {
    Ok(bytes) => Some(bytes)
    Err(_) => None
  }
}

///|
let pixeladventure_test_project_root : String = "pixeladventure"

///|
fn pixeladventure_test_document_path(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized == "" {
    pixeladventure_test_project_root
  } else {
    pixeladventure_test_project_root + "/" + normalized
  }
}

///|
fn pixeladventure_test_asset_reader(path : String) -> Bytes? {
  read_file_bytes_if_exists(pixeladventure_test_document_path(path))
}

///|
pub fn pixeladventure_test_document_source() -> @editor_bridge.DocumentSource {
  fn(path : String) { pixeladventure_test_asset_reader(path) }
}

///|
pub fn with_pixeladventure_test_asset_io(
  action : () -> Unit raise,
) -> Unit raise {
  @asset.set_io(pixeladventure_test_asset_reader)
  try {
    action()
    @asset.set_io(fn(_path : String) { None })
  } catch {
    err => {
      @asset.set_io(fn(_path : String) { None })
      raise err
    }
  }
}
