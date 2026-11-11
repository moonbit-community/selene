///|
pub type ImageHandle = @asset_types.ImageHandle

///|
let next_image_id : Ref[UInt32] = Ref(0)

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
  if read_bytes(path) is Some(_) {
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
  image_states.get(handle).unwrap_or(NotLoaded)
}

///|
pub fn reload_image(handle : ImageHandle) -> Unit {
  match image_path(handle) {
    Some(path) => {
      image_states.set(handle, Loading)
      if read_bytes(path) is Some(_) {
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
  if image_states.get(handle) is Some(_) {
    image_states.remove(handle)
    image_asset_events.send({ handle, kind: Removed, })
  }
}
