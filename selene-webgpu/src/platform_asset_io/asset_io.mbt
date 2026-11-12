///|
pub fn set_reader(
  reader : (String) -> Bytes?,
  paths~ : Array[String] = [],
) -> Unit {
  @impl.set_embedded_assets(reader, paths~)
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @impl.get_asset_bytes(path)
}

///|
pub fn paths() -> Array[String] {
  @impl.embedded_asset_paths()
}
