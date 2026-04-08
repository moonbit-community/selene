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
fn asset_test_load_state_is_loaded(state : LoadState) -> Bool {
  match state {
    Loaded => true
    NotLoaded | Loading | Failed(_) => false
  }
}

///|
fn asset_test_load_state_is_not_loaded(state : LoadState) -> Bool {
  match state {
    NotLoaded => true
    Loading | Loaded | Failed(_) => false
  }
}

///|
fn asset_test_event_kind_is_added(kind : AssetEventKind) -> Bool {
  match kind {
    Added => true
    Modified | Removed | Loaded | Failed(_) => false
  }
}

///|
fn asset_test_event_kind_is_modified(kind : AssetEventKind) -> Bool {
  match kind {
    Modified => true
    Added | Removed | Loaded | Failed(_) => false
  }
}

///|
fn asset_test_event_kind_is_removed(kind : AssetEventKind) -> Bool {
  match kind {
    Removed => true
    Added | Modified | Loaded | Failed(_) => false
  }
}

///|
fn asset_test_event_kind_is_loaded(kind : AssetEventKind) -> Bool {
  match kind {
    Loaded => true
    Added | Modified | Removed | Failed(_) => false
  }
}

///|
fn asset_test_event_kind_is_failed_with(
  kind : AssetEventKind,
  message : String,
) -> Bool {
  match kind {
    Failed(msg) => msg == message
    Added | Modified | Removed | Loaded => false
  }
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
    inspect(
      asset_test_load_state_is_loaded(image_load_state(handle)),
      content="true",
    )
    inspect(first_events.length(), content="2")
    inspect(
      asset_test_event_kind_is_added(first_events[0].kind),
      content="true",
    )
    inspect(
      asset_test_event_kind_is_loaded(first_events[1].kind),
      content="true",
    )

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
    inspect(
      asset_test_event_kind_is_modified(reload_events[0].kind),
      content="true",
    )
    inspect(
      asset_test_load_state_is_loaded(image_load_state(handle)),
      content="true",
    )

    remove_image(handle)
    let remove_events = reader.read(image_asset_events)
    inspect(remove_events.length(), content="1")
    inspect(
      asset_test_event_kind_is_removed(remove_events[0].kind),
      content="true",
    )
    inspect(
      asset_test_load_state_is_not_loaded(image_load_state(handle)),
      content="true",
    )
  })
}

///|
test "missing asset enters failed state and emits failed event" {
  with_asset_test_world(fn() raise {
    let reader = @event.EventReader::new()
    let handle = load_audio("assets/missing.wav")
    let events = reader.read(audio_asset_events)
    inspect(
      match audio_load_state(handle) {
        Failed(msg) => msg == "Missing audio asset: assets/missing.wav"
        NotLoaded | Loading | Loaded => false
      },
      content="true",
    )
    inspect(events.length(), content="2")
    inspect(asset_test_event_kind_is_added(events[0].kind), content="true")
    inspect(
      asset_test_event_kind_is_failed_with(
        events[1].kind,
        "Missing audio asset: assets/missing.wav",
      ),
      content="true",
    )
  })
}
