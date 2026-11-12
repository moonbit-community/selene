///|
/// Registers an asset reader and the paths available from that reader.
/// Replacing the reader also replaces its catalogue; the array is copied.
/// Registered resource values and active playback are unaffected.
pub fn set_io(reader : (String) -> Bytes?, paths~ : Array[String] = []) -> Unit {
  @platform_asset_io.set_reader(reader, paths~)
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @platform_asset_io.read_bytes(path)
}

///|
/// Returns a snapshot of the registered asset paths.
pub fn paths() -> Array[String] {
  @platform_asset_io.paths()
}
