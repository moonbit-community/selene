///|
pub fn set_io(reader : (String) -> Bytes?) -> Unit {
  @platform_asset_io.set_reader(reader)
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @platform_asset_io.read_bytes(path)
}
