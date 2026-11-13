///|
pub type FontHandle = @asset_types.FontHandle

///|
let fonts_by_path : Map[String, FontHandle] = Map([])

///|
let font_family_by_handle : Map[FontHandle, String] = Map([])

///|
let font_handle_by_family : Map[String, FontHandle] = Map([])

///|
let font_path_by_handle : Map[FontHandle, String] = Map([])

///|
let font_states : Map[FontHandle, LoadState] = Map([])

///|
pub let font_asset_events : @event.Events[AssetEvent[FontHandle]] = Events()

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
fn ensure_font_handle(path : String, family : String) -> FontHandle {
  if fonts_by_path.get(path) is Some(handle) && handle.is_alive() {
    return handle
  }
  let handle = fonts.reserve()
  fonts_by_path.set(path, handle)
  font_family_by_handle.set(handle, family)
  font_handle_by_family.set(family, handle)
  font_path_by_handle.set(handle, path)
  handle
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
    font_asset_events.send({ handle, kind: Added, })
  }
  font_states.set(handle, Loading)
  if read_bytes(path) is Some(bytes) {
    ignore(fonts.insert(handle, Font::from_bytes(bytes)))
    font_states.set(handle, Loaded)
    font_asset_events.send({ handle, kind: Loaded, })
  } else {
    let reason = "Missing font asset: \{path}"
    font_states.set(handle, Failed(reason))
    font_asset_events.send({ handle, kind: Failed(reason), })
  }
  handle
}

///|
pub fn font_path(handle : FontHandle) -> String? {
  font_path_by_handle.get(handle)
}

///|
pub fn font_family(handle : FontHandle) -> String? {
  if handle.is_alive() {
    font_family_by_handle.get(handle)
  } else {
    None
  }
}

///|
pub fn font_by_family(family : String) -> FontHandle? {
  font_handle_by_family.get(family).filter(handle => handle.is_alive())
}

///|
pub fn font_load_state(handle : FontHandle) -> LoadState {
  if !handle.is_alive() {
    NotLoaded
  } else {
    font_states
    .get(handle)
    .unwrap_or(if handle.get() is Some(_) { Loaded } else { NotLoaded })
  }
}

///|
pub fn reload_font(handle : FontHandle) -> Unit {
  guard handle.is_alive() else { return }
  match font_path(handle) {
    Some(path) => {
      font_states.set(handle, Loading)
      if read_bytes(path) is Some(bytes) {
        ignore(fonts.insert(handle, Font::from_bytes(bytes)))
        font_states.set(handle, Loaded)
        font_asset_events.send({ handle, kind: Modified, })
      } else {
        let reason = "Reload font failed: \{path}"
        font_states.set(handle, Failed(reason))
        font_asset_events.send({ handle, kind: Failed(reason), })
      }
    }
    None => ()
  }
}

///|
pub fn remove_font(handle : FontHandle) -> Unit {
  ignore(fonts.remove(handle))
  if font_states.get(handle) is Some(_) {
    font_states.remove(handle)
    font_asset_events.send({ handle, kind: Removed, })
  }
}
