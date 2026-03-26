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
fn pixeladventure_test_asset_reader(path : String) -> Bytes? {
  let normalized = path.replace(old="\\", new="/")
  let candidates = [normalized, "pixeladventure/" + normalized]
  for candidate in candidates {
    if read_file_bytes_if_exists(candidate) is Some(bytes) {
      return Some(bytes)
    }
  }
  None
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
