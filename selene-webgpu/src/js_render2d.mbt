///|
extern "js" fn webgpu_begin_3d(
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
  #| (px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.begin3d(px, py, pz, tx, ty, tz, ux, uy, uz, fovy, nearZ, farZ, orthographic, orthoWidth, orthoHeight);
  #|   }
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
  directional_data : Array[Double],
  point_data : Array[Double],
  spot_data : Array[Double],
  ambient_r : Double,
  ambient_g : Double,
  ambient_b : Double,
  directional_shadow_map_size : Double,
  point_shadow_map_size : Double,
) -> Unit =
  #| (directionalData, pointData, spotData, ar, ag, ab, directionalShadowMapSize, pointShadowMapSize) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (!rt) return;
  #|   const clamp01 = (x) => Math.max(0, Math.min(1, Number.isFinite(x) ? x : 0));
  #|   const clampSigned = (x) => Math.max(-1, Math.min(1, Number.isFinite(x) ? x : 0));
  #|   const safeDirectional = Array.isArray(directionalData) ? directionalData : [];
  #|   const safePoint = Array.isArray(pointData) ? pointData : [];
  #|   const safeSpot = Array.isArray(spotData) ? spotData : [];
  #|   const safeDirectionalShadowMapSize = Math.max(1, Math.round(Number(directionalShadowMapSize) || 2048));
  #|   const safePointShadowMapSize = Math.max(1, Math.round(Number(pointShadowMapSize) || 1024));
  #|   const directionalLights = [];
  #|   for (let i = 0; i + 16 < safeDirectional.length && directionalLights.length < 4; i += 17) {
  #|     let dx = Number(safeDirectional[i]) || 0;
  #|     let dy = Number(safeDirectional[i + 1]) || -1;
  #|     let dz = Number(safeDirectional[i + 2]) || 0;
  #|     const len = Math.hypot(dx, dy, dz);
  #|     if (len <= 1e-8) {
  #|       dx = 0;
  #|       dy = -1;
  #|       dz = 0;
  #|     } else {
  #|       dx /= len;
  #|       dy /= len;
  #|       dz /= len;
  #|     }
  #|     directionalLights.push({
  #|       direction: [dx, dy, dz],
  #|       intensity: Math.max(0, Number(safeDirectional[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safeDirectional[i + 4]),
  #|         clamp01(safeDirectional[i + 5]),
  #|         clamp01(safeDirectional[i + 6]),
  #|       ],
  #|       shadows: Number(safeDirectional[i + 7]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safeDirectional[i + 8]) || 0),
  #|       normalBias: Math.max(0, Number(safeDirectional[i + 9]) || 0),
  #|       cascadeConfig: (() => {
  #|         const cascadeCount = Math.max(1, Math.min(4, Math.round(Number(safeDirectional[i + 10]) || 1)));
  #|         const minimumDistance = Math.max(0, Number(safeDirectional[i + 11]) || 0);
  #|         const overlapProportion = clamp01(safeDirectional[i + 12]);
  #|         const bounds = [];
  #|         let fallbackBound = minimumDistance + 1.0;
  #|         for (let boundIndex = 0; boundIndex < 4; boundIndex += 1) {
  #|           const rawBound = Number(safeDirectional[i + 13 + boundIndex]);
  #|           const bound = Number.isFinite(rawBound) ? rawBound : fallbackBound;
  #|           fallbackBound = bound;
  #|           if (boundIndex < cascadeCount) {
  #|             bounds.push(bound);
  #|           }
  #|         }
  #|         return { minimumDistance, overlapProportion, bounds };
  #|       })(),
  #|     });
  #|   }
  #|   const pointLights = [];
  #|   for (let i = 0; i + 11 < safePoint.length && pointLights.length < 8; i += 12) {
  #|     pointLights.push({
  #|       position: [
  #|         Number(safePoint[i]) || 0,
  #|         Number(safePoint[i + 1]) || 0,
  #|         Number(safePoint[i + 2]) || 0,
  #|       ],
  #|       intensity: Math.max(0, Number(safePoint[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safePoint[i + 4]),
  #|         clamp01(safePoint[i + 5]),
  #|         clamp01(safePoint[i + 6]),
  #|       ],
  #|       range: Math.max(0.0001, Number(safePoint[i + 7]) || 0.0001),
  #|       shadows: Number(safePoint[i + 8]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safePoint[i + 9]) || 0),
  #|       normalBias: Math.max(0, Number(safePoint[i + 10]) || 0),
  #|       nearZ: Math.max(0.0001, Number(safePoint[i + 11]) || 0.0001),
  #|     });
  #|   }
  #|   const spotLights = [];
  #|   for (let i = 0; i + 16 < safeSpot.length && spotLights.length < 4; i += 17) {
  #|     let dx = Number(safeSpot[i + 8]) || 0;
  #|     let dy = Number(safeSpot[i + 9]) || -1;
  #|     let dz = Number(safeSpot[i + 10]) || 0;
  #|     const dlen = Math.hypot(dx, dy, dz);
  #|     if (dlen <= 1e-8) {
  #|       dx = 0;
  #|       dy = -1;
  #|       dz = 0;
  #|     } else {
  #|       dx /= dlen;
  #|       dy /= dlen;
  #|       dz /= dlen;
  #|     }
  #|     const innerCos = clampSigned(safeSpot[i + 11]);
  #|     const outerCos = clampSigned(safeSpot[i + 12]);
  #|     spotLights.push({
  #|       position: [
  #|         Number(safeSpot[i]) || 0,
  #|         Number(safeSpot[i + 1]) || 0,
  #|         Number(safeSpot[i + 2]) || 0,
  #|       ],
  #|       intensity: Math.max(0, Number(safeSpot[i + 3]) || 0),
  #|       color: [
  #|         clamp01(safeSpot[i + 4]),
  #|         clamp01(safeSpot[i + 5]),
  #|         clamp01(safeSpot[i + 6]),
  #|       ],
  #|       range: Math.max(0.0001, Number(safeSpot[i + 7]) || 0.0001),
  #|       direction: [dx, dy, dz],
  #|       innerCos,
  #|       outerCos,
  #|       innerAngle: Math.acos(innerCos),
  #|       outerAngle: Math.acos(outerCos),
  #|       shadows: Number(safeSpot[i + 13]) >= 0.5,
  #|       depthBias: Math.max(0, Number(safeSpot[i + 14]) || 0),
  #|       normalBias: Math.max(0, Number(safeSpot[i + 15]) || 0),
  #|       nearZ: Math.max(0.0001, Number(safeSpot[i + 16]) || 0.0001),
  #|     });
  #|   }
  #|   rt.light3d = {
  #|     directionalLights,
  #|     pointLights,
  #|     spotLights,
  #|     ambient: [
  #|       clamp01(ar),
  #|       clamp01(ag),
  #|       clamp01(ab),
  #|     ],
  #|     directionalShadowMapSize: safeDirectionalShadowMapSize,
  #|     pointShadowMapSize: safePointShadowMapSize,
  #|   };
  #| }

///|
extern "js" fn webgpu_draw_cube_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  size_x : Double,
  size_y : Double,
  size_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCube3d(cx, cy, cz, sx, sy, sz, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_sphere_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  radius : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, radius, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushSphere3d(cx, cy, cz, radius, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_cylinder_3d(
  center_x : Double,
  center_y : Double,
  center_z : Double,
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (cx, cy, cz, rtTop, rtBottom, h, slices, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushCylinder3d(cx, cy, cz, rtTop, rtBottom, h, slices, qx, qy, qz, qw, r, g, b, a, emissiveR, emissiveG, emissiveB, alphaMode, alphaCutoff, unlit, castShadows, receiveShadows);
  #|   }
  #| }

///|
extern "js" fn webgpu_draw_colored_triangles_3d(
  vertices : Array[Double],
  translation_x : Double,
  translation_y : Double,
  translation_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushColoredTriangles3d(vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows);
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
  translation_x : Double,
  translation_y : Double,
  translation_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit =
  #| (basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows) => {
  #|   const rt = globalThis.__selene_webgpu_runtime;
  #|   if (rt) {
  #|     rt.pushTexturedTriangles3d(basePath, emissivePath, metallicRoughnessPath, occlusionPath, normalPath, baseSamplerCode, emissiveSamplerCode, metallicRoughnessSamplerCode, occlusionSamplerCode, normalSamplerCode, vertices, tx, ty, tz, qx, qy, qz, qw, doubleSided, castShadows, receiveShadows);
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
