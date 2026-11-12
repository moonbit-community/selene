///|
test "asset catalogue is a snapshot and reader replacement clears it" {
  let catalogue = ["maps/a.tmj", "maps/b.tmj"]
  @asset.set_io(
    fn(path) { if path == "maps/a.tmj" { Some(b"map") } else { None } },
    paths=catalogue,
  )
  defer @asset.set_io(fn(_) { None })
  catalogue.push("maps/not-registered.tmj")
  let snapshot = @asset.paths()
  assert_eq(snapshot.length(), 2)
  snapshot.clear()
  assert_eq(@asset.paths().length(), 2)
  assert_eq(@asset.read_bytes("maps/a.tmj"), Some(b"map"))
  @asset.set_io(fn(_) { None })
  assert_eq(@asset.paths().length(), 0)
}
