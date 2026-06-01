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
extern "js" fn webgpu_push_color_vertices_2d(
  vertices : Array[Double],
  pipeline_code : Int,
) -> Unit =
  #| (vertices, pipelineCode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushColor2d(new Float32Array(vertices), pipelineCode);
  #|   }
  #| }

///|
extern "js" fn webgpu_image_dimensions(path : String) -> Array[Double] =
  #| (path) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return [0, 0, 0];
  #|   const rec = rt.ensureImage(path);
  #|   if (!rec || rec.state !== 'ready') return [0, 0, 0];
  #|   return [1, rec.width, rec.height];
  #| }

///|
extern "js" fn webgpu_push_texture_vertices_2d(
  path : String,
  sampler_code : Int,
  vertices : Array[Double],
  pipeline_code : Int,
) -> Unit =
  #| (path, samplerCode, vertices, pipelineCode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const rec = rt.ensureImage(path);
  #|   if (!rec || rec.state !== 'ready') return;
  #|   rt.pushTex2d(samplerCode, rec, new Float32Array(vertices), pipelineCode);
  #| }

///|
extern "js" fn webgpu_text_texture_dimensions(
  text : String,
  family : String,
  size : Double,
  color_r : Double,
  color_g : Double,
  color_b : Double,
  color_a : Double,
) -> Array[Double] =
  #| (text, family, size, r, g, bcol, alpha) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return [0, 0, 0];
  #|   const rec = rt.ensureTextTexture(text, family, size, r, g, bcol, alpha);
  #|   if (!rec) return [0, 0, 0];
  #|   return [1, rec.width, rec.height];
  #| }

///|
extern "js" fn webgpu_push_text_vertices_2d(
  text : String,
  family : String,
  size : Double,
  color_r : Double,
  color_g : Double,
  color_b : Double,
  color_a : Double,
  vertices : Array[Double],
  pipeline_code : Int,
) -> Unit =
  #| (text, family, size, r, g, bcol, alpha, vertices, pipelineCode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const rec = rt.ensureTextTexture(text, family, size, r, g, bcol, alpha);
  #|   if (!rec) return;
  #|   rt.pushTex2d(0, rec, new Float32Array(vertices), pipelineCode);
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
extern "js" fn webgpu_push_cached_text_vertices_2d(
  key : String,
  vertices : Array[Double],
  pipeline_code : Int,
) -> Unit =
  #| (key, vertices, pipelineCode) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const rec = rt.textCache.get(key);
  #|   if (!rec) return;
  #|   rt.pushTex2d(0, rec, new Float32Array(vertices), pipelineCode);
  #| }
