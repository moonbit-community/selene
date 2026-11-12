///|
let embedded_paths : Ref[Array[String]] = Ref([])

///|
let embedded_asset_urls : Map[String, String] = Map([])

///|
pub fn embedded_asset_paths() -> Array[String] {
  embedded_paths.val.copy()
}

///|
// Existing browser decoders accept data URLs as well as network URLs.
// Cache the encoding because image paths are resolved on every draw.
fn resolve_asset_path(path : String) -> String {
  if embedded_asset_urls.get(path) is Some(url) {
    return url
  }
  guard get_embedded_asset(path) is Some(bytes) else {
    return resolve_external_asset_path(path)
  }
  let mime = if path.has_suffix(".png") {
    "image/png"
  } else if path.has_suffix(".ttf") {
    "font/ttf"
  } else {
    "application/octet-stream"
  }
  let url = "data:" + mime + ";base64," + @base64.encode(bytes)
  embedded_asset_urls[path] = url
  url
}
