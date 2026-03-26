///|
pub type DocumentSource = (String) -> Bytes?

///|
fn normalize_source_key(path : String) -> String {
  path.replace(old="\\", new="/").trim().to_string()
}

///|
pub fn map_document_source(documents : Map[String, Bytes]) -> DocumentSource {
  let normalized : Map[String, Bytes] = {}
  for path, bytes in documents {
    normalized.set(normalize_source_key(path), bytes)
  }
  fn(path : String) { normalized.get(normalize_source_key(path)) }
}
