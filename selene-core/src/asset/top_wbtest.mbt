///|
fn with_asset_test_world(action : () -> Unit raise) -> Unit raise {
  image_asset_events.clear()
  audio_asset_events.clear()
  font_asset_events.clear()
  set_io(fn(_path : String) -> Bytes? { None })
  action()
  image_asset_events.clear()
  audio_asset_events.clear()
  font_asset_events.clear()
  set_io(fn(_path : String) -> Bytes? { None })
}

///|
fn asset_test_bytes() -> Bytes {
  Bytes::from_array([1U.to_byte()])
}

///|
test "load_image emits added and loaded only once for a cached handle" {
  with_asset_test_world(fn() raise {
    set_io(fn(path : String) -> Bytes? {
      if path == "assets/test.png" {
        Some(asset_test_bytes())
      } else {
        None
      }
    })
    let reader = @event.EventReader::new()
    let handle = load_image("assets/test.png")
    let first_events = reader.read(image_asset_events)
    inspect(image_load_state(handle), content="Loaded")
    inspect(first_events.length(), content="2")
    inspect(first_events[0].kind, content="Added")
    inspect(first_events[1].kind, content="Loaded")

    let cached = load_image("assets/test.png")
    let second_events = reader.read(image_asset_events)
    inspect(cached == handle, content="true")
    inspect(second_events.length(), content="0")
  })
}

///|
test "reload_image emits modified and remove_image resets load state" {
  with_asset_test_world(fn() raise {
    set_io(fn(path : String) -> Bytes? {
      if path == "assets/reload.png" {
        Some(asset_test_bytes())
      } else {
        None
      }
    })
    let handle = load_image("assets/reload.png")
    let reader = @event.EventReader::new()
    ignore(reader.read(image_asset_events))

    reload_image(handle)
    let reload_events = reader.read(image_asset_events)
    inspect(reload_events.length(), content="1")
    inspect(reload_events[0].kind, content="Modified")
    inspect(image_load_state(handle), content="Loaded")

    remove_image(handle)
    let remove_events = reader.read(image_asset_events)
    inspect(remove_events.length(), content="1")
    inspect(remove_events[0].kind, content="Removed")
    inspect(image_load_state(handle), content="NotLoaded")
  })
}

///|
test "missing asset enters failed state and emits failed event" {
  with_asset_test_world(fn() raise {
    let reader = @event.EventReader::new()
    let handle = load_audio("assets/missing.wav")
    let events = reader.read(audio_asset_events)
    inspect(
      audio_load_state(handle),
      content="Failed(\"Missing audio asset: assets/missing.wav\")",
    )
    inspect(events.length(), content="2")
    inspect(events[0].kind, content="Added")
    inspect(
      events[1].kind,
      content="Failed(\"Missing audio asset: assets/missing.wav\")",
    )
  })
}
