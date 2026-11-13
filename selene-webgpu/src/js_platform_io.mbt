///|
extern "js" fn resolve_asset_path(path : String) -> String =
  #| (path) => {
  #|   if (
  #|     path.startsWith("http://") ||
  #|     path.startsWith("https://") ||
  #|     path.startsWith("data:") ||
  #|     path.startsWith("blob:")
  #|   ) {
  #|     return path;
  #|   }
  #|   if (!path.startsWith("assets/")) {
  #|     return path;
  #|   }
  #|   try {
  #|     const href = globalThis.location?.href;
  #|     if (!href) return path;
  #|     return new URL(path, href).pathname;
  #|   } catch (_err) {
  #|     return path;
  #|   }
  #| }

///|
extern "js" fn webgpu_load_file_bytes_sync_ffi(
  path : String,
) -> FixedArray[Int32] =
  #| (path) => {
  #|   globalThis.__selene_webgpu_last_file_load_error = '';
  #|   try {
  #|     const xhr = new XMLHttpRequest();
  #|     xhr.open('GET', path, false);
  #|     // Browsers reject `responseType = "arraybuffer"` for synchronous XHR
  #|     // on document contexts. Use x-user-defined text decoding to preserve
  #|     // raw byte values for sync file reads.
  #|     xhr.overrideMimeType('text/plain; charset=x-user-defined');
  #|     xhr.send(null);
  #|     if (xhr.status >= 200 && xhr.status < 300) {
  #|       const text = xhr.responseText || '';
  #|       const out = new Array(text.length);
  #|       for (let i = 0; i < text.length; i += 1) {
  #|         out[i] = text.charCodeAt(i) & 0xff;
  #|       }
  #|       return out;
  #|     }
  #|     globalThis.__selene_webgpu_last_file_load_error =
  #|       `HTTP ${xhr.status || 0} ${xhr.statusText || 'File not found'}`;
  #|   } catch (err) {
  #|     globalThis.__selene_webgpu_last_file_load_error =
  #|       err && err.message ? String(err.message) : String(err);
  #|     return [];
  #|   }
  #|   return [];
  #| }

///|
extern "js" fn webgpu_last_file_load_error() -> String =
  #| () => String(globalThis.__selene_webgpu_last_file_load_error || '')

///|
extern "js" fn webgpu_gamepad_count() -> Int32 =
  #| () => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   return pads ? (pads.length | 0) : 0;
  #| }

///|
extern "js" fn webgpu_gamepad_connected(index : Int32) -> Bool =
  #| (index) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   if (!pads || index < 0 || index >= pads.length) return false;
  #|   const pad = pads[index];
  #|   return !!(pad && pad.connected);
  #| }

///|
extern "js" fn webgpu_gamepad_button_pressed(
  index : Int32,
  button : Int32,
) -> Bool =
  #| (index, button) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const b = pad?.buttons?.[button];
  #|   return !!(b && b.pressed);
  #| }

///|
extern "js" fn webgpu_gamepad_button_value(
  index : Int32,
  button : Int32,
) -> Double =
  #| (index, button) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const b = pad?.buttons?.[button];
  #|   if (!b) return 0;
  #|   const v = Number(b.value);
  #|   if (!Number.isFinite(v)) return 0;
  #|   if (v < 0) return 0;
  #|   if (v > 1) return 1;
  #|   return v;
  #| }

///|
extern "js" fn webgpu_gamepad_axis_value(index : Int32, axis : Int32) -> Double =
  #| (index, axis) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const a = pad?.axes?.[axis];
  #|   if (a == null) return 0;
  #|   const v = Number(a);
  #|   if (!Number.isFinite(v)) return 0;
  #|   if (v < -1) return -1;
  #|   if (v > 1) return 1;
  #|   return v;
  #| }

///|
fn webgpu_load_file_bytes_sync(path : String) -> Array[Int32] {
  Array::from_fixed_array(webgpu_load_file_bytes_sync_ffi(path))
}
