///|
extern "js" fn webgpu_measure_text(
  text : String,
  family : String,
  size : Double,
) -> Array[Double] =
  #| (text, family, size) => {
  #|   const cvs = document.createElement('canvas');
  #|   const ctx = cvs.getContext('2d');
  #|   const fontSize = Number.isFinite(size) && size > 0 ? size : 16;
  #|   const fontFamily = family && family.length > 0 ? family : 'Arial';
  #|   ctx.font = `${fontSize}px ${fontFamily}`;
  #|   const m = ctx.measureText(text ?? '');
  #|   const width = Math.max(0, Number(m.width) || 0);
  #|   const ascent = Math.max(0, Number(m.actualBoundingBoxAscent) || fontSize * 0.8);
  #|   const descent = Math.max(0, Number(m.actualBoundingBoxDescent) || fontSize * 0.2);
  #|   const height = Math.max(1, Math.ceil(ascent + descent));
  #|   return [width, height];
  #| }

///|
extern "js" fn webgpu_begin_frame(
  clear_r : Double,
  clear_g : Double,
  clear_b : Double,
  clear_a : Double,
) -> Unit =
  #| (r, g, b, a) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.beginFrame(r, g, b, a);
  #|   }
  #| }

///|
extern "js" fn webgpu_end_frame() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.endFrame();
  #|   }
  #| }

///|
extern "js" fn webgpu_capture_frame_png_bytes() -> Array[Int] =
  #| () => {
  #|   try {
  #|     const rt = globalThis.__selene_webgpu_runtime;
  #|     const canvas = rt?.canvas;
  #|     if (!canvas || !canvas.toDataURL) return [];
  #|     const dataUrl = canvas.toDataURL("image/png");
  #|     const comma = dataUrl.indexOf(",");
  #|     if (comma < 0) return [];
  #|     const base64 = dataUrl.slice(comma + 1);
  #|     const binary = atob(base64);
  #|     const out = new Array(binary.length);
  #|     for (let i = 0; i < binary.length; i += 1) {
  #|       out[i] = binary.charCodeAt(i) & 0xff;
  #|     }
  #|     return out;
  #|   } catch (_err) {
  #|     return [];
  #|   }
  #| }

///|
extern "js" fn webgpu_preload_img(path : String) -> Unit =
  #| (path) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.ensureImage(path);
  #|   }
  #| }

///|
extern "js" fn webgpu_begin_2d_pass(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  load_op : Int,
  clear_r : Double,
  clear_g : Double,
  clear_b : Double,
  clear_a : Double,
  target_name : String,
) -> Unit =
  #| (x, y, width, height, loadOp, clearR, clearG, clearB, clearA, targetName) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.beginPass2d(x, y, width, height, loadOp, [clearR, clearG, clearB, clearA], targetName);
  #|   }
  #| }

///|
extern "js" fn webgpu_end_2d_pass() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.endPass2d();
  #|   }
  #| }

///|
extern "js" fn webgpu_push_clip_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit =
  #| (x, y, width, height) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushClip2d(x, y, width, height);
  #|   }
  #| }
