///|
pub type ImageHandle = @asset_types.ImageHandle

///|
let images_by_path : Map[String, ImageHandle] = Map([])

///|
let image_path_by_handle : Map[ImageHandle, String] = Map([])

///|
let image_states : Map[ImageHandle, LoadState] = Map([])

///|
pub let image_asset_events : @event.Events[AssetEvent[ImageHandle]] = Events()

///|
fn ensure_image_handle(path : String) -> ImageHandle {
  if images_by_path.get(path) is Some(handle) && handle.is_alive() {
    return handle
  }
  let handle = images.reserve()
  images_by_path.set(path, handle)
  image_path_by_handle.set(handle, path)
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
    image_asset_events.send({ handle, kind: Added, })
  }
  image_states.set(handle, Loading)
  if read_bytes(path) is Some(bytes) {
    ignore(images.insert(handle, Image::from_bytes(bytes)))
    image_states.set(handle, Loaded)
    image_asset_events.send({ handle, kind: Loaded, })
  } else {
    let reason = "Missing image asset: \{path}"
    image_states.set(handle, Failed(reason))
    image_asset_events.send({ handle, kind: Failed(reason), })
  }
  handle
}

///|
pub fn image_path(handle : ImageHandle) -> String? {
  image_path_by_handle.get(handle)
}

///|
pub fn image_load_state(handle : ImageHandle) -> LoadState {
  if !handle.is_alive() {
    NotLoaded
  } else {
    image_states
    .get(handle)
    .unwrap_or(if handle.get() is Some(_) { Loaded } else { NotLoaded })
  }
}

///|
pub fn reload_image(handle : ImageHandle) -> Unit {
  guard handle.is_alive() else { return }
  match image_path(handle) {
    Some(path) => {
      image_states.set(handle, Loading)
      if read_bytes(path) is Some(bytes) {
        ignore(images.insert(handle, Image::from_bytes(bytes)))
        image_states.set(handle, Loaded)
        image_asset_events.send({ handle, kind: Modified, })
      } else {
        let reason = "Reload image failed: \{path}"
        image_states.set(handle, Failed(reason))
        image_asset_events.send({ handle, kind: Failed(reason), })
      }
    }
    None => ()
  }
}

///|
pub fn remove_image(handle : ImageHandle) -> Unit {
  ignore(images.remove(handle))
  if image_states.get(handle) is Some(_) {
    image_states.remove(handle)
    image_asset_events.send({ handle, kind: Removed, })
  }
}
