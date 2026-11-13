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

///|
test "registering byte assets does not invoke path IO or prepare backend resources" {
  @asset.set_io(fn(_) { abort("byte registration must not read paths") })
  defer @asset.set_io(fn(_) { None })
  let images : @asset.Assets[@asset.Image] = Assets()
  let image = images.add(@asset.Image::from_bytes(b"image"))
  defer ignore(images.remove(image))
  assert_eq(@asset.image_path(image), None)
  assert_true(@asset.image_preparation_state(image) is Unprepared)
  let audios : @asset.Assets[@asset.Audio] = Assets()
  let audio = audios.add(@asset.Audio::from_bytes(b"audio"))
  defer ignore(audios.remove(audio))
  assert_eq(@asset.audio_path(audio), None)
  assert_true(@asset.audio_preparation_state(audio) is Unprepared)
  let fonts : @asset.Assets[@asset.Font] = Assets()
  let font = fonts.add(@asset.Font::from_bytes(b"font"))
  defer ignore(fonts.remove(font))
  assert_eq(@asset.font_path(font), None)
  assert_eq(@asset.font_family(font), None)
  assert_true(@asset.font_preparation_state(font) is Unprepared)
}
