///|
extern "js" fn webgpu_preload_font_bytes(font : String, path : String) -> Unit =
  #| (font, path) => {
  #|   const g = globalThis;
  #|   if (!g.__selene_font_bytes_states) {
  #|     g.__selene_font_bytes_states = new Map();
  #|   }
  #|   const states = g.__selene_font_bytes_states;
  #|   const rec = states.get(font);
  #|   if (rec && (rec.status === 0 || rec.status === 1)) {
  #|     return;
  #|   }
  #|   states.set(font, { status: 0, bytes: [] });
  #|   fetch(path)
  #|     .then((res) => {
  #|       if (!res.ok) throw new Error('failed to fetch font');
  #|       return res.arrayBuffer();
  #|     })
  #|     .then((buf) => {
  #|       states.set(font, { status: 1, bytes: Array.from(new Uint8Array(buf)) });
  #|     })
  #|     .catch(() => {
  #|       states.set(font, { status: 2, bytes: [] });
  #|     });
  #| }

///|
extern "js" fn webgpu_font_bytes_status(font : String) -> Int =
  #| (font) => {
  #|   const states = globalThis.__selene_font_bytes_states;
  #|   if (!states) return -1;
  #|   const rec = states.get(font);
  #|   if (!rec) return -1;
  #|   return rec.status | 0;
  #| }

///|
extern "js" fn webgpu_take_font_bytes(font : String) -> Array[Int] =
  #| (font) => {
  #|   const states = globalThis.__selene_font_bytes_states;
  #|   if (!states) return [];
  #|   const rec = states.get(font);
  #|   if (!rec || rec.status !== 1) return [];
  #|   states.set(font, { status: 3, bytes: [] });
  #|   return rec.bytes || [];
  #| }

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
extern "js" fn webgpu_load_file_bytes_sync(path : String) -> Array[Int] =
  #| (path) => {
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
  #|   } catch (_err) {
  #|     return [];
  #|   }
  #|   return [];
  #| }

///|
extern "js" fn webgpu_gamepad_count() -> Int =
  #| () => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   return pads ? (pads.length | 0) : 0;
  #| }

///|
extern "js" fn webgpu_gamepad_connected(index : Int) -> Bool =
  #| (index) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   if (!pads || index < 0 || index >= pads.length) return false;
  #|   const pad = pads[index];
  #|   return !!(pad && pad.connected);
  #| }

///|
extern "js" fn webgpu_gamepad_button_pressed(index : Int, button : Int) -> Bool =
  #| (index, button) => {
  #|   const pads = globalThis.navigator?.getGamepads?.();
  #|   const pad = pads?.[index];
  #|   const b = pad?.buttons?.[button];
  #|   return !!(b && b.pressed);
  #| }

///|
extern "js" fn webgpu_gamepad_button_value(index : Int, button : Int) -> Double =
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
extern "js" fn webgpu_gamepad_axis_value(index : Int, axis : Int) -> Double =
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
