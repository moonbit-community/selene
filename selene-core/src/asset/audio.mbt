///|
pub type AudioHandle = @asset_types.AudioHandle

///|
let audios_by_path : Map[String, AudioHandle] = Map([])

///|
let audio_path_by_handle : Map[AudioHandle, String] = Map([])

///|
let audio_states : Map[AudioHandle, LoadState] = Map([])

///|
pub let audio_asset_events : @event.Events[AssetEvent[AudioHandle]] = Events()

///|
fn ensure_audio_handle(path : String) -> AudioHandle {
  if audios_by_path.get(path) is Some(handle) && handle.is_alive() {
    return handle
  }
  let handle = audios.reserve()
  audios_by_path.set(path, handle)
  audio_path_by_handle.set(handle, path)
  handle
}

///|
pub fn load_audio(path : String) -> AudioHandle {
  let handle = ensure_audio_handle(path)
  let state = audio_states.get(handle)
  if state == Some(Loading) || state == Some(Loaded) {
    return handle
  }
  if state is None {
    audio_asset_events.send({ handle, kind: Added, })
  }
  audio_states.set(handle, Loading)
  if read_bytes(path) is Some(bytes) {
    ignore(audios.insert(handle, Audio::from_bytes(bytes)))
    @platform_audio.preload(handle)
    audio_states.set(handle, Loaded)
    audio_asset_events.send({ handle, kind: Loaded, })
  } else {
    let reason = "Missing audio asset: \{path}"
    audio_states.set(handle, Failed(reason))
    audio_asset_events.send({ handle, kind: Failed(reason), })
  }
  handle
}

///|
pub fn audio_path(handle : AudioHandle) -> String? {
  audio_path_by_handle.get(handle)
}

///|
pub fn audio_load_state(handle : AudioHandle) -> LoadState {
  if !handle.is_alive() {
    NotLoaded
  } else {
    audio_states
    .get(handle)
    .unwrap_or(if handle.get() is Some(_) { Loaded } else { NotLoaded })
  }
}

///|
pub fn reload_audio(handle : AudioHandle) -> Unit {
  guard handle.is_alive() else { return }
  match audio_path(handle) {
    Some(path) => {
      audio_states.set(handle, Loading)
      if read_bytes(path) is Some(bytes) {
        ignore(audios.insert(handle, Audio::from_bytes(bytes)))
        @platform_audio.preload(handle)
        audio_states.set(handle, Loaded)
        audio_asset_events.send({ handle, kind: Modified, })
      } else {
        let reason = "Reload audio failed: \{path}"
        audio_states.set(handle, Failed(reason))
        audio_asset_events.send({ handle, kind: Failed(reason), })
      }
    }
    None => ()
  }
}

///|
pub fn remove_audio(handle : AudioHandle) -> Unit {
  ignore(audios.remove(handle))
  if audio_states.get(handle) is Some(_) {
    audio_states.remove(handle)
    audio_asset_events.send({ handle, kind: Removed, })
  }
}
