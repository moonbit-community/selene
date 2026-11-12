///|
let embedded_paths : Ref[Array[String]] = Ref([])

///|
pub fn embedded_asset_paths() -> Array[String] {
  embedded_paths.val.copy()
}
