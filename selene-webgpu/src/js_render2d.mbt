///|
extern "js" fn webgpu_begin_3d(
  view_projection : Array[Double],
  position_x : Double,
  position_y : Double,
  position_z : Double,
  target_x : Double,
  target_y : Double,
  target_z : Double,
  up_x : Double,
  up_y : Double,
  up_z : Double,
  fovy : Double,
  near_z : Double,
  far_z : Double,
  orthographic : Double,
  orthographic_width : Double,
  orthographic_height : Double,
) -> Unit =
  #| (viewProjection, px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.begin3d(viewProjection, px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight);
  #|   }
  #| }

///|
extern "js" fn webgpu_canvas_size() -> Array[Double] =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt?.canvas) return [1, 1];
  #|   return [
  #|     Math.max(1, Math.floor(rt.canvas.width || 1)),
  #|     Math.max(1, Math.floor(rt.canvas.height || 1)),
  #|   ];
  #| }

///|
extern "js" fn webgpu_end_3d() -> Unit =
  #| () => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.end3d();
  #|   }
  #| }

///|
extern "js" fn webgpu_set_lighting_3d(
  light_uniform : Array[Double],
  directional_shadow_data : Array[Double],
  point_shadow_data : Array[Double],
  spot_shadow_data : Array[Double],
  directional_shadow_map_size : Double,
  point_shadow_map_size : Double,
) -> Unit =
  #| (lightUniform, directionalShadowData, pointShadowData, spotShadowData, directionalShadowMapSize, pointShadowMapSize) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const safeLightUniform = Array.isArray(lightUniform) ? lightUniform : [];
  #|   const safeDirectionalShadowMapSize = Math.max(1, Math.round(Number(directionalShadowMapSize) || 2048));
  #|   const safePointShadowMapSize = Math.max(1, Math.round(Number(pointShadowMapSize) || 1024));
  #|   rt.shadow3d = {
  #|     directional: new Float32Array(Array.isArray(directionalShadowData) ? directionalShadowData : []),
  #|     point: new Float32Array(Array.isArray(pointShadowData) ? pointShadowData : []),
  #|     spot: new Float32Array(Array.isArray(spotShadowData) ? spotShadowData : []),
  #|     directionalShadowMapSize: safeDirectionalShadowMapSize,
  #|     pointShadowMapSize: safePointShadowMapSize,
  #|   };
  #|   rt.lightUniform3d = new Float32Array(safeLightUniform);
  #| }

///|
extern "js" fn webgpu_set_shadow_view_projection_3d(
  directional_cascades : Array[Double],
  spot_matrices : Array[Double],
  point_matrices : Array[Double],
) -> Unit =
  #| (directionalCascades, spotMatrices, pointMatrices) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   rt.shadowViewProjection3d = {
  #|     directional: new Float32Array(Array.isArray(directionalCascades) ? directionalCascades : []),
  #|     spot: new Float32Array(Array.isArray(spotMatrices) ? spotMatrices : []),
  #|     point: new Float32Array(Array.isArray(pointMatrices) ? pointMatrices : []),
  #|   };
  #| }

///|
extern "js" fn webgpu_upload_lit_primitive_mesh_resource(
  cache_key : String,
  vertices : Array[Double],
) -> Unit =
  #| (cacheKey, vertices) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.uploadLitPrimitiveMeshResource(cacheKey, vertices);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_lit_primitive_mesh_batch_3d(
  cache_key : String,
  retained_key : String,
  instances : Array[Double],
  double_sided : Bool,
  cast_shadows : Bool,
) -> Unit =
  #| (cacheKey, retainedKey, instances, doubleSided, castShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushLitPrimitiveMeshBatch3d(cacheKey, retainedKey, instances, doubleSided, castShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_release_primitive_mesh_resource(
  cache_key : String,
) -> Unit =
  #| (cacheKey) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.releasePrimitiveMeshResource(cacheKey);
  #|   }
  #| }

///|
extern "js" fn webgpu_release_retained_instance_buffer_3d(
  retained_key : String,
) -> Unit =
  #| (retainedKey) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.releaseRetainedInstanceBuffer3d(retainedKey);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_colored_triangles_3d(
  vertices : Array[Double],
  double_sided : Bool,
  cast_shadows : Bool,
) -> Unit =
  #| (vertices, doubleSided, castShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushColoredTriangles3d(vertices, doubleSided, castShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_lines_3d(vertices : Array[Double]) -> Unit =
  #| (vertices) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushLines3d(vertices);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_textured_triangles_3d(
  base_path : String,
  emissive_path : String,
  metallic_roughness_path : String,
  occlusion_path : String,
  normal_path : String,
  base_sampler_code : Int,
  emissive_sampler_code : Int,
  metallic_roughness_sampler_code : Int,
  occlusion_sampler_code : Int,
  normal_sampler_code : Int,
  vertices : Array[Double],
  double_sided : Bool,
  cast_shadows : Bool,
) -> Unit =
  #| (basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, doubleSided, castShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushTexturedTriangles3d(basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, doubleSided, castShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_skybox_textured_triangles_3d(
  base_path : String,
  vertices : Array[Double],
) -> Unit =
  #| (basePath, vertices) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushSkyboxTexturedTriangles3d(basePath, vertices);
  #|   }
  #| }

///|
pub extern "js" fn Audio::new(path : String) -> Audio =
  #| (path) => {
  #|   const init = globalThis.__selene_init_audio_element || (
  #|     globalThis.__selene_init_audio_element = (audio) => {
  #|       if (audio.__seleneAudioInitialized) {
  #|         return audio;
  #|       }
  #|       audio.__seleneAudioInitialized = true;
  #|       audio.preload = 'auto';
  #|       audio.__selenePlayState = 0;
  #|       audio.__selenePlayAttemptEpoch = -1;
  #|       audio.addEventListener('playing', () => {
  #|         audio.__selenePlayState = 1;
  #|       });
  #|       audio.addEventListener('pause', () => {
  #|         if (!audio.ended) {
  #|           audio.__selenePlayState = 0;
  #|         }
  #|       });
  #|       audio.addEventListener('error', () => {
  #|         audio.__selenePlayState = 3;
  #|       });
  #|       return audio;
  #|     }
  #|   );
  #|   return init(new Audio(path));
  #| }
