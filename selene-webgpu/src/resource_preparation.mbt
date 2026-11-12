///|
// js-ffi 0.4.3 passes Array directly to JS spread. FixedArray is the native JS array.
fn[Arg, Result] call_browser_method(
  object : @js.Value,
  name : String,
  args : FixedArray[Arg],
) -> Result {
  let reflect : @js.Value = @js.globalThis.get_with_string("Reflect")
  let apply : (@js.Value, @js.Value, FixedArray[Arg]) -> Result = reflect.get_with_string(
    "apply",
  )
  let callable : @js.Value = object.get_with_string(name)
  apply(callable, object, args)
}

///|
fn is_js_object(value : @js.Value) -> Bool {
  value.is_object() && !value.is_null()
}

///|
let prepared_images : Map[@asset_types.ImageHandle, String] = Map([])

///|
let prepared_fonts : Map[@asset_types.FontHandle, String] = Map([])

///|
fn browser_runtime() -> @js.Value {
  @js.globalThis.get_with_string("__selene_webgpu_runtime")
}

///|
fn release_prepared_image(url : String) -> Unit {
  let runtime = browser_runtime()
  guard is_js_object(runtime) else { return }
  let cache : @js.Value = runtime.get_with_string("imageCache")
  let record : @js.Value = call_browser_method(cache, "get", [url])
  if is_js_object(record) {
    record.set_with_string("state", "cancelled")
    let texture : @js.Value = record.get_with_string("texture")
    if is_js_object(texture) {
      let result : @js.Value = call_browser_method(
        texture,
        "destroy",
        ([] : FixedArray[@js.Value]),
      )
      ignore(result)
    }
  }
  let removed : Bool = call_browser_method(cache, "delete", [url])
  ignore(removed)
}

///|
fn image_url(handle : @asset_types.ImageHandle) -> String? {
  guard handle.get() is Some(image) else { return None }
  if prepared_images.get(handle) is Some(url) {
    return Some(url)
  }
  let url = create_object_url(image.bytes, "application/octet-stream")
  prepared_images[handle] = url
  handle.on_invalidate(fn() {
    prepared_images.remove(handle)
    release_prepared_image(url)
    revoke_object_url(url)
  })
  Some(url)
}

///|
pub fn image_preparation_state(
  handle : @asset_types.ImageHandle,
) -> @asset_types.PreparationState {
  guard prepared_images.get(handle) is Some(url) else { return Unprepared }
  let runtime = browser_runtime()
  guard is_js_object(runtime) else { return Preparing }
  let cache : @js.Value = runtime.get_with_string("imageCache")
  let record : @js.Value = call_browser_method(cache, "get", [url])
  guard is_js_object(record) else { return Preparing }
  let state : String = record.get_with_string("state")
  match state {
    "ready" => Ready
    "error" => Failed("Image decoding or texture preparation failed")
    _ => Preparing
  }
}

///|
pub fn prepare_font(handle : @asset_types.FontHandle) -> String? {
  guard handle.get() is Some(font) else { return None }
  if prepared_fonts.get(handle) is Some(family) {
    return Some(family)
  }
  let family = "selene-font-\{handle.id()}"
  prepared_fonts[handle] = family
  let url = create_object_url(font.bytes, "application/octet-stream")
  load_font(family, font.bytes, url)
  handle.on_invalidate(fn() {
    prepared_fonts.remove(handle)
    revoke_object_url(url)
    cosmic_fonts.remove(family)
    if handle.is_alive() {
      ignore(begin_web_font_load(family))
    } else {
      web_font_runtimes.remove(family)
    }
    invalidate_web_font_metrics()
    let faces : @js.Value = @js.globalThis.get_with_string(
      "__selene_font_faces",
    )
    if is_js_object(faces) {
      let face : @js.Value = call_browser_method(faces, "get", [family])
      if is_js_object(face) {
        let document : @js.Value = @js.globalThis.get_with_string("document")
        let fonts : @js.Value = document.get_with_string("fonts")
        let removed : Bool = call_browser_method(fonts, "delete", [face])
        ignore(removed)
      }
      let removed : Bool = call_browser_method(faces, "delete", [family])
      ignore(removed)
    }
  })
  Some(family)
}

///|
pub fn font_preparation_state(
  handle : @asset_types.FontHandle,
) -> @asset_types.PreparationState {
  guard prepared_fonts.get(handle) is Some(family) else { return Unprepared }
  let runtime = web_font_runtime(family)
  if runtime.error is Some(message) {
    Failed(message)
  } else if runtime.dom_ready_generation == Some(runtime.generation) {
    Ready
  } else {
    Preparing
  }
}
