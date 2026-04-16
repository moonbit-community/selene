///|
extern "js" fn webgpu_pop_clip_rect() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.popClip2d();
  #|   }
  #| }

///|
extern "js" fn webgpu_reset_clip_stack() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.resetClip2d();
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_image(
  path : String,
  destination_x : Double,
  destination_y : Double,
  destination_width : Double,
  destination_height : Double,
  has_source : Bool,
  source_x : Double,
  source_y : Double,
  source_width : Double,
  source_height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  uv_transform_a : Double,
  uv_transform_b : Double,
  uv_transform_c : Double,
  uv_transform_d : Double,
  uv_transform_tx : Double,
  uv_transform_ty : Double,
  repeat_mode : Int,
  alpha_mode : Int,
  blend_mode : Int,
  tint_r : Double,
  tint_g : Double,
  tint_b : Double,
  tint_a : Double,
) -> Unit =
  #| (path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, ua, ub, uc, ud, utx, uty, repeatMode, alphaMode, blendMode, tr, tg, tb, ta) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushImage(path, dx, dy, dw, dh, hasSource, sx, sy, sw, sh, a, b, c, d, tx, ty, ua, ub, uc, ud, utx, uty, repeatMode, alphaMode, blendMode, tr, tg, tb, ta);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_text(
  text : String,
  x : Double,
  y : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  family : String,
  size : Double,
  align : Int,
  baseline : Int,
  blend_mode : Int,
  color_r : Double,
  color_g : Double,
  color_b : Double,
  color_a : Double,
) -> Unit =
  #| (text, x, y, a, b, c, d, tx, ty, family, size, align, baseline, blendMode, r, g, bcol, alpha) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushText(text, x, y, a, b, c, d, tx, ty, family, size, align, baseline, blendMode, r, g, bcol, alpha);
  #|   }
  #| }

///|
extern "js" fn webgpu_upload_text_texture(
  key : String,
  width : Int,
  height : Int,
  pixels : Array[Int],
) -> Bool =
  #| (key, width, height, pixels) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return false;
  #|   try {
  #|     return !!rt.uploadTextTexture?.(key, width, height, pixels);
  #|   } catch (_err) {
  #|     return false;
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_cached_text(
  key : String,
  x : Double,
  y : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  align : Int,
  baseline : Int,
  blend_mode : Int,
) -> Unit =
  #| (key, x, y, a, b, c, d, tx, ty, align, baseline, blendMode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCachedText?.(key, x, y, a, b, c, d, tx, ty, align, baseline, blendMode);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  alpha_mode : Int,
  blend_mode : Int,
  fill_r : Double,
  fill_g : Double,
  fill_b : Double,
  fill_a : Double,
  has_stroke : Bool,
  stroke_r : Double,
  stroke_g : Double,
  stroke_b : Double,
  stroke_a : Double,
) -> Unit =
  #| (x, y, w, h, a, b, c, d, tx, ty, alphaMode, blendMode, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushRect(x, y, w, h, a, b, c, d, tx, ty, alphaMode, blendMode, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_circle(
  center_x : Double,
  center_y : Double,
  radius : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  alpha_mode : Int,
  blend_mode : Int,
  fill_r : Double,
  fill_g : Double,
  fill_b : Double,
  fill_a : Double,
  has_stroke : Bool,
  stroke_r : Double,
  stroke_g : Double,
  stroke_b : Double,
  stroke_a : Double,
) -> Unit =
  #| (cx, cy, radius, a, b, c, d, tx, ty, alphaMode, blendMode, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCircle(cx, cy, radius, a, b, c, d, tx, ty, alphaMode, blendMode, fr, fg, fb, fa, hasStroke, sr, sg, sb, sa);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_gradient_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  transform_a : Double,
  transform_b : Double,
  transform_c : Double,
  transform_d : Double,
  transform_tx : Double,
  transform_ty : Double,
  alpha_mode : Int,
  blend_mode : Int,
  start_r : Double,
  start_g : Double,
  start_b : Double,
  start_a : Double,
  end_r : Double,
  end_g : Double,
  end_b : Double,
  end_a : Double,
) -> Unit =
  #| (x, y, w, h, a, b, c, d, tx, ty, alphaMode, blendMode, sr, sg, sb, sa, er, eg, eb, ea) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushGradientRect(x, y, w, h, a, b, c, d, tx, ty, alphaMode, blendMode, sr, sg, sb, sa, er, eg, eb, ea);
  #|   }
  #| }
