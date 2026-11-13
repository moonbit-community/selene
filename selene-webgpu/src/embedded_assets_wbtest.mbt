///|
test "path reader caches and catalogue snapshots are replaced together" {
  let reads = Ref(0)
  let catalogue = ["assets/test.png", "assets/test.ttf"]
  set_embedded_assets(
    fn(_) {
      reads.val += 1
      Some(b"first")
    },
    paths=catalogue,
  )
  defer set_embedded_assets(fn(_) { None })
  catalogue.clear()
  assert_eq(embedded_asset_paths().length(), 2)
  embedded_asset_paths().clear()
  assert_eq(embedded_asset_paths().length(), 2)
  assert_eq(get_asset_bytes("assets/test.png"), Some(b"first"))
  assert_eq(get_asset_bytes("assets/test.png"), Some(b"first"))
  assert_eq(reads.val, 1)
  set_embedded_assets(fn(_) { Some(b"second") })
  assert_eq(embedded_asset_paths().length(), 0)
  assert_eq(get_asset_bytes("assets/test.png"), Some(b"second"))
  assert_eq(
    resolve_asset_path("https://example.test/image.png"),
    "https://example.test/image.png",
  )
}
