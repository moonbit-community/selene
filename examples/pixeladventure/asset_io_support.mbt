///|
fn read_file_bytes_if_exists(path : String) -> Bytes? {
  if !@fs.path_exists(path) {
    return None
  }
  Some(@fs.read_file_to_bytes(path)) catch {
    _ => None
  }
}

///|
let pixeladventure_test_asset_root : String = "pixeladventure"

///|
fn pixeladventure_test_asset_path(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized == "" {
    pixeladventure_test_asset_root
  } else {
    pixeladventure_test_asset_root + "/" + normalized
  }
}

///|
fn pixeladventure_test_asset_reader(path : String) -> Bytes? {
  read_file_bytes_if_exists(pixeladventure_test_asset_path(path))
}

///|
pub fn with_pixeladventure_test_asset_io(
  action : () -> Unit raise,
) -> Unit raise {
  @asset.set_io(pixeladventure_test_asset_reader)
  errdefer @asset.set_io(fn(_path : String) { None })
  action()
  @asset.set_io(fn(_path : String) { None })
}
