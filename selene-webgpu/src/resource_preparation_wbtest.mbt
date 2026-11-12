///|
test "image resources with equal bytes retain independent backend lifetimes" {
  let images : @asset_types.Assets[@asset_types.Image] = Assets()
  let first = images.add(@asset_types.Image::from_bytes(b"same"))
  let second = images.add(@asset_types.Image::from_bytes(b"same"))
  let first_url = image_url(first).unwrap()
  let second_url = image_url(second).unwrap()
  assert_true(first_url.has_prefix("blob:"))
  assert_true(first_url != second_url)
  assert_eq(image_url(first), Some(first_url))
  ignore(images.remove(first))
  assert_eq(image_url(first), None)
  assert_eq(image_url(second), Some(second_url))
  ignore(images.remove(second))
}

///|
test "ordinary collection updates invalidate prepared image sources" {
  let images : @asset_types.Assets[@asset_types.Image] = Assets()
  let image = images.add(@asset_types.Image::from_bytes(b"first"))
  assert_true(image_preparation_state(image) is Unprepared)
  let first = image_url(image)
  assert_true(images.insert(image, @asset_types.Image::from_bytes(b"second")))
  assert_true(image_preparation_state(image) is Unprepared)
  assert_true(image_url(image) != first)
  ignore(images.remove(image))
  assert_eq(image_url(image), None)
  assert_true(image_preparation_state(image) is Unprepared)
}

///|
test "3D materials use the same image resources as 2D rendering" {
  let images : @asset_types.Assets[@asset_types.Image] = Assets()
  let image = images.add(@asset_types.Image::from_bytes(b"shared image"))
  let binding = @render3d_types.TextureBinding3D(image)
  assert_eq(image_url(binding.image), image_url(image))
  ignore(images.remove(image))
}

///|
test "replacing path IO does not discard registered audio sources" {
  let audios : @asset_types.Assets[@asset_types.Audio] = Assets()
  let audio = audios.add(@asset_types.Audio::from_bytes(b"registered audio"))
  let url = create_object_url(b"registered audio", "application/octet-stream")
  cached_audio_sources[audio] = url
  defer {
    clear_cached_audio_source(audio)
    collect_retired_audio_sources()
  }
  defer ignore(audios.remove(audio))
  set_embedded_assets(fn(_) { None })
  assert_eq(cached_audio_sources.get(audio).unwrap(), url)
}

///|
test "invalid font bytes do not create a prepared Cosmic font" {
  assert_false(prepare_cosmic_font("__invalid_font__", b"not a font"))
  assert_false(cosmic_fonts.contains("__invalid_font__"))
}

///|
test "browser method calls use native argument arrays and preserve their receiver" {
  let values : FixedArray[String] = ["first"]
  let receiver = @js.Value::cast_from(values)
  let length : Int32 = call_browser_method(receiver, "push", ["second"])
  let joined : String = call_browser_method(receiver, "join", [","])
  assert_eq(length, 2)
  assert_eq(joined, "first,second")
  let last : String = call_browser_method(
    receiver,
    "pop",
    ([] : FixedArray[String]),
  )
  assert_eq(last, "second")
  let null : @js.Nullable[@js.Value] = @js.Nullable::null()
  assert_false(is_js_object(@js.Value::cast_from(null)))
}

///|
test "audio source preparation is idempotent until its asset is replaced" {
  let audios : @asset_types.Assets[@asset_types.Audio] = Assets()
  let audio = audios.add(@asset_types.Audio::from_bytes(b"first"))
  let first = resolved_audio_source(audio)
  assert_eq(resolved_audio_source(audio), first)
  assert_true(audios.insert(audio, @asset_types.Audio::from_bytes(b"second")))
  assert_true(resolved_audio_source(audio) != first)
  ignore(audios.remove(audio))
  assert_true(audio_preparation_state(audio) is Unprepared)
  collect_retired_audio_sources()
}
