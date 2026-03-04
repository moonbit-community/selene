///|
pub type ImageHandle = @asset_types.ImageHandle

///|
pub type AudioHandle = @asset_types.AudioHandle

///|
pub type FontHandle = @asset_types.FontHandle

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
pub fn load_image(path : String) -> ImageHandle {
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
pub fn image_path(handle : ImageHandle) -> String? {
  image_path_by_handle.get(handle)
}

///|
pub fn load_audio(path : String) -> AudioHandle {
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
pub fn audio_path(handle : AudioHandle) -> String? {
  audio_path_by_handle.get(handle)
}

///|
pub fn load_font(path : String, family? : String) -> FontHandle {
  if fonts_by_path.get(path) is Some(handle) {
    return handle
  }
  let handle = @asset_types.FontHandle(next_font_id.val)
  next_font_id.val += 1
  let family = family.unwrap_or(normalize_font_family(path))
  fonts_by_path.set(path, handle)
  font_family_by_handle.set(handle, family)
  font_handle_by_family.set(family, handle)
  font_path_by_handle.set(handle, path)
  @platform_render.register_font(family, path)
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
