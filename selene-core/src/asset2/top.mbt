///|
pub(all) enum AssetState {
  NotLoaded
  Loading
  Loaded
  Failed(String)
} derive(Eq, Show)

///|
pub(all) enum AssetEventKind {
  Added
  Modified
  Removed
  Loaded
  Failed(String)
} derive(Eq, Show)

///|
pub(all) struct AssetEvent[T] {
  handle : T
  kind : AssetEventKind
} derive(Eq, Show)

///|
let image_states : Map[@asset.ImageHandle, AssetState] = Map::new()

///|
let audio_states : Map[@asset.AudioHandle, AssetState] = Map::new()

///|
let font_states : Map[@asset.FontHandle, AssetState] = Map::new()

///|
pub let image_asset_events : @event.Events[AssetEvent[@asset.ImageHandle]] = @event.Events::new()

///|
pub let audio_asset_events : @event.Events[AssetEvent[@asset.AudioHandle]] = @event.Events::new()

///|
pub let font_asset_events : @event.Events[AssetEvent[@asset.FontHandle]] = @event.Events::new()

///|
fn init {
  image_asset_events.register()
  audio_asset_events.register()
  font_asset_events.register()
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @asset.read_bytes(path)
}

///|
pub fn load_image(path : String) -> @asset.ImageHandle {
  let handle = @asset.load_image(path)
  image_states.set(handle, Loading)
  image_asset_events.send({ handle, kind: Added })
  if @asset.read_bytes(path) is Some(_) {
    image_states.set(handle, Loaded)
    image_asset_events.send({ handle, kind: Loaded })
  } else {
    let reason = "Missing image asset: \{path}"
    image_states.set(handle, Failed(reason))
    image_asset_events.send({ handle, kind: Failed(reason) })
  }
  handle
}

///|
pub fn load_audio(path : String) -> @asset.AudioHandle {
  let handle = @asset.load_audio(path)
  audio_states.set(handle, Loading)
  audio_asset_events.send({ handle, kind: Added })
  if @asset.read_bytes(path) is Some(_) {
    audio_states.set(handle, Loaded)
    audio_asset_events.send({ handle, kind: Loaded })
  } else {
    let reason = "Missing audio asset: \{path}"
    audio_states.set(handle, Failed(reason))
    audio_asset_events.send({ handle, kind: Failed(reason) })
  }
  handle
}

///|
pub fn load_font(path : String, family? : String) -> @asset.FontHandle {
  let handle = match family {
    Some(name) => @asset.load_font(path, family=name)
    None => @asset.load_font(path)
  }
  font_states.set(handle, Loading)
  font_asset_events.send({ handle, kind: Added })
  if @asset.read_bytes(path) is Some(_) {
    font_states.set(handle, Loaded)
    font_asset_events.send({ handle, kind: Loaded })
  } else {
    let reason = "Missing font asset: \{path}"
    font_states.set(handle, Failed(reason))
    font_asset_events.send({ handle, kind: Failed(reason) })
  }
  handle
}

///|
pub fn image_state(handle : @asset.ImageHandle) -> AssetState {
  image_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn audio_state(handle : @asset.AudioHandle) -> AssetState {
  audio_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn font_state(handle : @asset.FontHandle) -> AssetState {
  font_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn reload_image(handle : @asset.ImageHandle) -> Unit {
  match @asset.image_path(handle) {
    Some(path) =>
      if @asset.read_bytes(path) is Some(_) {
        image_states.set(handle, Loaded)
        image_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload image failed: \{path}"
        image_states.set(handle, Failed(reason))
        image_asset_events.send({ handle, kind: Failed(reason) })
      }
    None => ()
  }
}

///|
pub fn reload_audio(handle : @asset.AudioHandle) -> Unit {
  match @asset.audio_path(handle) {
    Some(path) =>
      if @asset.read_bytes(path) is Some(_) {
        audio_states.set(handle, Loaded)
        audio_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload audio failed: \{path}"
        audio_states.set(handle, Failed(reason))
        audio_asset_events.send({ handle, kind: Failed(reason) })
      }
    None => ()
  }
}

///|
pub fn reload_font(handle : @asset.FontHandle) -> Unit {
  match @asset.font_path(handle) {
    Some(path) =>
      if @asset.read_bytes(path) is Some(_) {
        font_states.set(handle, Loaded)
        font_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload font failed: \{path}"
        font_states.set(handle, Failed(reason))
        font_asset_events.send({ handle, kind: Failed(reason) })
      }
    None => ()
  }
}

///|
pub fn remove_image(handle : @asset.ImageHandle) -> Unit {
  image_states.remove(handle)
  image_asset_events.send({ handle, kind: Removed })
}

///|
pub fn remove_audio(handle : @asset.AudioHandle) -> Unit {
  audio_states.remove(handle)
  audio_asset_events.send({ handle, kind: Removed })
}

///|
pub fn remove_font(handle : @asset.FontHandle) -> Unit {
  font_states.remove(handle)
  font_asset_events.send({ handle, kind: Removed })
}
