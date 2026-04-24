///|
pub type ImageHandle = @asset_types.ImageHandle

///|
pub type AudioHandle = @asset_types.AudioHandle

///|
pub type FontHandle = @asset_types.FontHandle

///|
pub(all) enum LoadState {
  NotLoaded
  Loading
  Loaded
  Failed(String)
} derive(Eq, Debug)

///|
pub(all) enum AssetEventKind {
  Added
  Modified
  Removed
  Loaded
  Failed(String)
} derive(Eq, Debug)

///|
pub(all) struct AssetEvent[T] {
  handle : T
  kind : AssetEventKind
} derive(Eq, Debug)

///|
let next_image_id : Ref[UInt] = Ref::new(0)

///|
let next_audio_id : Ref[UInt] = Ref::new(0)

///|
let next_font_id : Ref[UInt] = Ref::new(0)

///|
let images_by_path : Map[String, ImageHandle] = Map::new()

///|
let audios_by_path : Map[String, AudioHandle] = Map::new()

///|
let fonts_by_path : Map[String, FontHandle] = Map::new()

///|
let font_family_by_handle : Map[FontHandle, String] = Map::new()

///|
let font_handle_by_family : Map[String, FontHandle] = Map::new()

///|
let image_path_by_handle : Map[ImageHandle, String] = Map::new()

///|
let audio_path_by_handle : Map[AudioHandle, String] = Map::new()

///|
let font_path_by_handle : Map[FontHandle, String] = Map::new()

///|
let image_states : Map[ImageHandle, LoadState] = Map::new()

///|
let audio_states : Map[AudioHandle, LoadState] = Map::new()

///|
let font_states : Map[FontHandle, LoadState] = Map::new()

///|
pub let image_asset_events : @event.Events[AssetEvent[ImageHandle]] = @event.Events()

///|
pub let audio_asset_events : @event.Events[AssetEvent[AudioHandle]] = @event.Events()

///|
pub let font_asset_events : @event.Events[AssetEvent[FontHandle]] = @event.Events()

///|
fn normalize_font_family(path : String) -> String {
  let slash_idx = path.rev_find("/").unwrap_or(-1)
  let name = path.unsafe_substring(start=slash_idx + 1, end=path.length())
  if name.rev_find(".") is Some(dot_idx) {
    name.unsafe_substring(start=0, end=dot_idx)
  } else {
    name
  }
}

///|
pub fn set_io(reader : (String) -> Bytes?) -> Unit {
  @platform_asset_io.set_reader(reader)
}

///|
pub fn read_bytes(path : String) -> Bytes? {
  @platform_asset_io.read_bytes(path)
}

///|
fn ensure_image_handle(path : String) -> ImageHandle {
  if images_by_path.get(path) is Some(handle) {
    return handle
  }
  let handle = @asset_types.ImageHandle(next_image_id.val)
  next_image_id.val += 1
  images_by_path.set(path, handle)
  image_path_by_handle.set(handle, path)
  handle
}

///|
fn ensure_audio_handle(path : String) -> AudioHandle {
  if audios_by_path.get(path) is Some(handle) {
    return handle
  }
  let handle = @asset_types.AudioHandle(next_audio_id.val)
  next_audio_id.val += 1
  audios_by_path.set(path, handle)
  audio_path_by_handle.set(handle, path)
  handle
}

///|
fn ensure_font_handle(path : String, family : String) -> FontHandle {
  if fonts_by_path.get(path) is Some(handle) {
    return handle
  }
  let handle = @asset_types.FontHandle(next_font_id.val)
  next_font_id.val += 1
  fonts_by_path.set(path, handle)
  font_family_by_handle.set(handle, family)
  font_handle_by_family.set(family, handle)
  font_path_by_handle.set(handle, path)
  @platform_render.register_font(family, path)
  handle
}

///|
pub fn load_image(path : String) -> ImageHandle {
  let handle = ensure_image_handle(path)
  let state = image_states.get(handle)
  if state == Some(Loading) || state == Some(Loaded) {
    return handle
  }
  if state is None {
    image_asset_events.send({ handle, kind: Added })
  }
  image_states.set(handle, Loading)
  if read_bytes(path) is Some(_) {
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
pub fn image_path(handle : ImageHandle) -> String? {
  image_path_by_handle.get(handle)
}

///|
pub fn load_audio(path : String) -> AudioHandle {
  let handle = ensure_audio_handle(path)
  let state = audio_states.get(handle)
  if state == Some(Loading) || state == Some(Loaded) {
    return handle
  }
  if state is None {
    audio_asset_events.send({ handle, kind: Added })
  }
  audio_states.set(handle, Loading)
  if read_bytes(path) is Some(_) {
    @platform_audio.preload(path)
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
pub fn audio_path(handle : AudioHandle) -> String? {
  audio_path_by_handle.get(handle)
}

///|
pub fn load_font(path : String, family? : String) -> FontHandle {
  let family = family.unwrap_or(normalize_font_family(path))
  let handle = ensure_font_handle(path, family)
  let state = font_states.get(handle)
  if state == Some(Loading) || state == Some(Loaded) {
    return handle
  }
  if state is None {
    font_asset_events.send({ handle, kind: Added })
  }
  font_states.set(handle, Loading)
  if read_bytes(path) is Some(_) {
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
pub fn font_path(handle : FontHandle) -> String? {
  font_path_by_handle.get(handle)
}

///|
pub fn font_family(handle : FontHandle) -> String? {
  font_family_by_handle.get(handle)
}

///|
pub fn font_by_family(family : String) -> FontHandle? {
  font_handle_by_family.get(family)
}

///|
pub fn image_load_state(handle : ImageHandle) -> LoadState {
  image_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn audio_load_state(handle : AudioHandle) -> LoadState {
  audio_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn font_load_state(handle : FontHandle) -> LoadState {
  font_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn reload_image(handle : ImageHandle) -> Unit {
  match image_path(handle) {
    Some(path) => {
      image_states.set(handle, Loading)
      if read_bytes(path) is Some(_) {
        image_states.set(handle, Loaded)
        image_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload image failed: \{path}"
        image_states.set(handle, Failed(reason))
        image_asset_events.send({ handle, kind: Failed(reason) })
      }
    }
    None => ()
  }
}

///|
pub fn reload_audio(handle : AudioHandle) -> Unit {
  match audio_path(handle) {
    Some(path) => {
      audio_states.set(handle, Loading)
      if read_bytes(path) is Some(_) {
        @platform_audio.preload(path)
        audio_states.set(handle, Loaded)
        audio_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload audio failed: \{path}"
        audio_states.set(handle, Failed(reason))
        audio_asset_events.send({ handle, kind: Failed(reason) })
      }
    }
    None => ()
  }
}

///|
pub fn reload_font(handle : FontHandle) -> Unit {
  match font_path(handle) {
    Some(path) => {
      font_states.set(handle, Loading)
      if read_bytes(path) is Some(_) {
        font_states.set(handle, Loaded)
        font_asset_events.send({ handle, kind: Modified })
      } else {
        let reason = "Reload font failed: \{path}"
        font_states.set(handle, Failed(reason))
        font_asset_events.send({ handle, kind: Failed(reason) })
      }
    }
    None => ()
  }
}

///|
pub fn remove_image(handle : ImageHandle) -> Unit {
  if image_states.get(handle) is Some(_) {
    image_states.remove(handle)
    image_asset_events.send({ handle, kind: Removed })
  }
}

///|
pub fn remove_audio(handle : AudioHandle) -> Unit {
  if audio_states.get(handle) is Some(_) {
    audio_states.remove(handle)
    audio_asset_events.send({ handle, kind: Removed })
  }
}

///|
pub fn remove_font(handle : FontHandle) -> Unit {
  if font_states.get(handle) is Some(_) {
    font_states.remove(handle)
    font_asset_events.send({ handle, kind: Removed })
  }
}
