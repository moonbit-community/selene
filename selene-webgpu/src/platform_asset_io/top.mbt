///|
pub fn set_reader(reader : (String) -> Bytes?) -> Unit {
  @impl.set_embedded_assets(reader)
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @impl.get_asset_bytes(path)
}
