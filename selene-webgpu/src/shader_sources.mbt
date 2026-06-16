///|
fn webgpu_shader_sources() -> Array[String] {
  [
    webgpu_shader2d_color_source(),
    webgpu_shader2d_texture_source(),
    webgpu_shader3d_color_source(),
    webgpu_shader3d_shadow_solid_source(),
    webgpu_shader3d_shadow_lit_source(),
    webgpu_shader3d_shadow_texture_source(),
    webgpu_shader_light_shadow_structs_source(),
    webgpu_shader_shadow_sampling_source(),
    webgpu_shader3d_lit_color_source(),
    webgpu_shader3d_lit_texture_source(),
  ]
}

///|
fn webgpu_shader2d_color_source() -> String {
  (
    #|struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };
    #|@group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;
    #|struct VSIn {
    #|  @location(0) pos: vec2<f32>,
    #|  @location(1) color: vec4<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) color: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;
    #|  let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;
    #|  o.pos = vec4<f32>(nx, ny, 0.0, 1.0);
    #|  o.color = v.color;
    #|  return o;
    #|}
    #|@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
    #|  return v.color;
    #|}
    #|
  )
}

///|
fn webgpu_shader3d_color_source() -> String {
  (
    #|struct CameraUniform {
    #|  view_proj: mat4x4<f32>,
    #|};
    #|@group(0) @binding(0) var<uniform> u_camera: CameraUniform;
    #|struct VSIn {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(1) color: vec4<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) color: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
    #|  o.color = v.color;
    #|  return o;
    #|}
    #|@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
    #|  return v.color;
    #|}
    #|
  )
}

///|
fn webgpu_shader3d_shadow_solid_source() -> String {
  (
    #|struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
    #|@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
    #|struct VSIn { @location(0) pos: vec3<f32>, @location(1) color: vec4<f32>, };
    #|struct VSOut { @builtin(position) pos: vec4<f32>, };
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
    #|  return o;
    #|}
    #|
  )
}

///|
fn webgpu_shader3d_shadow_lit_source() -> String {
  (
    #|struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
    #|@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
    #|struct VSIn {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(2) color: vec4<f32>,
    #|  @location(4) material: vec4<f32>,
    #|};
    #|struct VSInInstanced {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(2) color: vec4<f32>,
    #|  @location(4) material: vec4<f32>,
    #|  @location(5) instance_translation: vec3<f32>,
    #|  @location(6) instance_rotation: vec4<f32>,
    #|  @location(7) instance_scale: vec3<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) color: vec4<f32>,
    #|  @location(1) material: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
    #|  o.color = v.color;
    #|  o.material = v.material;
    #|  return o;
    #|}
    #|
  ) +
  webgpu_shader_rotate_quat_source() +
  (
    #|@vertex fn vs_instanced(v: VSInInstanced) -> VSOut {
    #|  var o: VSOut;
    #|  let world_pos = rotate_quat(v.pos * v.instance_scale, v.instance_rotation) + v.instance_translation;
    #|  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(world_pos, 1.0);
    #|  o.color = v.color;
    #|  o.material = v.material;
    #|  return o;
    #|}
    #|@fragment fn fs_main(v: VSOut) {
    #|  let alpha_mode = i32(round(v.material.x));
    #|  let alpha_cutoff = v.material.y;
    #|  if (alpha_mode == 2) { discard; }
    #|  if (alpha_mode == 1 && v.color.a < alpha_cutoff) { discard; }
    #|}
    #|
  )
}

///|
fn webgpu_shader3d_shadow_texture_source() -> String {
  (
    #|struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };
    #|@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;
    #|@group(0) @binding(1) var u_shadow_base_sampler: sampler;
    #|@group(0) @binding(2) var u_shadow_base_texture: texture_2d<f32>;
    #|struct VSIn {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(2) base_uv: vec2<f32>,
    #|  @location(7) color: vec4<f32>,
    #|  @location(10) material: vec4<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) base_uv: vec2<f32>,
    #|  @location(1) color: vec4<f32>,
    #|  @location(2) material: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);
    #|  o.base_uv = v.base_uv;
    #|  o.color = v.color;
    #|  o.material = v.material;
    #|  return o;
    #|}
    #|@fragment fn fs_main(v: VSOut) {
    #|  let alpha_mode = i32(round(v.material.x));
    #|  let alpha_cutoff = v.material.y;
    #|  if (alpha_mode == 2) { discard; }
    #|  let albedo = textureSample(u_shadow_base_texture, u_shadow_base_sampler, v.base_uv) * v.color;
    #|  if (alpha_mode == 1 && albedo.a < alpha_cutoff) { discard; }
    #|}
    #|
  )
}

///|
fn webgpu_shader_rotate_quat_source() -> String {
  (
    #|fn rotate_quat(value: vec3<f32>, quat: vec4<f32>) -> vec3<f32> {
    #|  let len = length(quat);
    #|  var q = quat;
    #|  if (len <= 0.00001) {
    #|    q = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    #|  } else {
    #|    q = quat / len;
    #|  }
    #|  let u = q.xyz;
    #|  let s = q.w;
    #|  return 2.0 * dot(u, value) * u + (s * s - dot(u, u)) * value + 2.0 * s * cross(u, value);
    #|}
    #|
  )
}

///|
fn webgpu_shader_light_shadow_structs_source() -> String {
  (
    #|struct LightUniform {
    #|  ambient_directional_count: vec4<f32>,
    #|  point_spot_count: vec4<f32>,
    #|  view_position: vec4<f32>,
    #|  view_forward: vec4<f32>,
    #|  directional_data: array<vec4<f32>, 8>,
    #|  point_data: array<vec4<f32>, 16>,
    #|  spot_data: array<vec4<f32>, 16>,
    #|};
    #|struct ShadowUniform {
    #|  directional_spot_texel: vec4<f32>,
    #|  point_texel: vec4<f32>,
    #|  directional_meta: array<vec4<f32>, 4>,
    #|  directional_bounds: array<vec4<f32>, 16>,
    #|  directional_rects: array<vec4<f32>, 16>,
    #|  directional_matrices: array<mat4x4<f32>, 16>,
    #|  spot_meta: array<vec4<f32>, 4>,
    #|  spot_rects: array<vec4<f32>, 4>,
    #|  spot_matrices: array<mat4x4<f32>, 4>,
    #|  point_meta: array<vec4<f32>, 8>,
    #|  point_rects: array<vec4<f32>, 48>,
    #|  point_matrices: array<mat4x4<f32>, 48>,
    #|};
    #|
    #|
  )
}

///|
fn webgpu_shader_shadow_sampling_source() -> String {
  (
    #|fn saturate(value: f32) -> f32 { return clamp(value, 0.0, 1.0); }
    #|fn point_light_attenuation(distance: f32, range: f32) -> f32 {
    #|  let safe_range = max(range, 0.0001);
    #|  return saturate(1.0 - distance / safe_range);
    #|}
    #|fn safe_normalize(value: vec3<f32>, fallback: vec3<f32>) -> vec3<f32> {
    #|  let len = length(value);
    #|  if (len <= 0.0001) { return fallback; }
    #|  return value / len;
    #|}
    #|fn shadow_local_uv(ndc: vec3<f32>) -> vec2<f32> {
    #|  return vec2<f32>(ndc.x * 0.5 + 0.5, 0.5 - ndc.y * 0.5);
    #|}
    #|fn sample_directional_shadow_compare(index: i32, uv: vec2<f32>, depth_ref: f32) -> f32 {
    #|  if (index == 0) { return textureSampleCompareLevel(u_directional_shadow0, u_shadow_sampler, uv, depth_ref); }
    #|  if (index == 1) { return textureSampleCompareLevel(u_directional_shadow1, u_shadow_sampler, uv, depth_ref); }
    #|  if (index == 2) { return textureSampleCompareLevel(u_directional_shadow2, u_shadow_sampler, uv, depth_ref); }
    #|  if (index == 3) { return textureSampleCompareLevel(u_directional_shadow3, u_shadow_sampler, uv, depth_ref); }
    #|  return 1.0;
    #|}
    #|fn sample_directional_shadow(light_index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {
    #|  if (!receive_shadows || light_index < 0 || light_index >= 4) { return 1.0; }
    #|  let shadow_meta = u_shadow.directional_meta[light_index];
    #|  if (shadow_meta.x < 0.5) { return 1.0; }
    #|  let cascade_count = clamp(i32(round(shadow_meta.y)), 0, 4);
    #|  if (cascade_count <= 0) { return 1.0; }
    #|  let view_depth = dot(world_pos - u_light.view_position.xyz, u_light.view_forward.xyz);
    #|  let base_index = light_index * 4;
    #|  let first_near = u_shadow.directional_bounds[base_index].x;
    #|  let last_far = u_shadow.directional_bounds[base_index + cascade_count - 1].y;
    #|  if (view_depth < first_near || view_depth > last_far) { return 1.0; }
    #|  var selected = cascade_count - 1;
    #|  for (var cascade_index = 0; cascade_index < 4; cascade_index = cascade_index + 1) {
    #|    if (cascade_index >= cascade_count) { continue; }
    #|    if (view_depth <= u_shadow.directional_bounds[base_index + cascade_index].y) {
    #|      selected = cascade_index;
    #|      break;
    #|    }
    #|  }
    #|  let texel = u_shadow.directional_spot_texel.xy;
    #|  let ndotl = max(dot(normal, light_dir), 0.0);
    #|  let bias = max(0.0, shadow_meta.z) + max(0.0, shadow_meta.w) * max(texel.x, texel.y) * (1.0 - ndotl);
    #|  let filter_radius = 1.25;
    #|  let matrix_index = base_index + selected;
    #|  let clip = u_shadow.directional_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);
    #|  if (abs(clip.w) <= 0.00001) { return 1.0; }
    #|  let ndc = clip.xyz / clip.w;
    #|  let local_uv = shadow_local_uv(ndc);
    #|  let depth = ndc.z;
    #|  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
    #|  let rect = u_shadow.directional_rects[matrix_index];
    #|  var lit = 0.0;
    #|  var total = 0.0;
    #|  for (var x = -1; x <= 1; x = x + 1) {
    #|    for (var y = -1; y <= 1; y = y + 1) {
    #|      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
    #|      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));
    #|      let atlas_uv = rect.xy + sample_uv * rect.zw;
    #|      lit = lit + sample_directional_shadow_compare(light_index, atlas_uv, depth - bias) * weight;
    #|      total = total + weight;
    #|    }
    #|  }
    #|  var shadow = select(1.0, lit / total, total > 0.00001);
    #|  if (selected > 0) {
    #|    let previous = selected - 1;
    #|    let overlap_near = u_shadow.directional_bounds[base_index + selected].x;
    #|    let overlap_far = u_shadow.directional_bounds[base_index + previous].y;
    #|    if (overlap_near < overlap_far && view_depth >= overlap_near && view_depth <= overlap_far) {
    #|      let prev_index = base_index + previous;
    #|      let prev_clip = u_shadow.directional_matrices[prev_index] * vec4<f32>(world_pos, 1.0);
    #|      if (abs(prev_clip.w) > 0.00001) {
    #|        let prev_ndc = prev_clip.xyz / prev_clip.w;
    #|        let prev_local_uv = shadow_local_uv(prev_ndc);
    #|        let prev_depth = prev_ndc.z;
    #|        if (!(prev_depth <= 0.0 || prev_depth >= 1.0 || any(prev_local_uv < vec2<f32>(0.0)) || any(prev_local_uv > vec2<f32>(1.0)))) {
    #|          let prev_rect = u_shadow.directional_rects[prev_index];
    #|          var prev_lit = 0.0;
    #|          var prev_total = 0.0;
    #|          for (var px = -1; px <= 1; px = px + 1) {
    #|            for (var py = -1; py <= 1; py = py + 1) {
    #|              let prev_weight = 1.0 / (1.0 + abs(f32(px)) + abs(f32(py)));
    #|              let prev_sample_uv = clamp(prev_local_uv + vec2<f32>(f32(px), f32(py)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));
    #|              let prev_atlas_uv = prev_rect.xy + prev_sample_uv * prev_rect.zw;
    #|              prev_lit = prev_lit + sample_directional_shadow_compare(light_index, prev_atlas_uv, prev_depth - bias) * prev_weight;
    #|              prev_total = prev_total + prev_weight;
    #|            }
    #|          }
    #|          let previous_shadow = select(1.0, prev_lit / prev_total, prev_total > 0.00001);
    #|          let blend = clamp((view_depth - overlap_near) / (overlap_far - overlap_near), 0.0, 1.0);
    #|          shadow = mix(previous_shadow, shadow, blend);
    #|        }
    #|      }
    #|    }
    #|  }
    #|  return shadow;
    #|}
    #|fn sample_spot_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {
    #|  if (!receive_shadows || index < 0 || index >= 4) { return 1.0; }
    #|  let shadow_meta = u_shadow.spot_meta[index];
    #|  if (shadow_meta.x < 0.5) { return 1.0; }
    #|  let clip = u_shadow.spot_matrices[index] * vec4<f32>(world_pos, 1.0);
    #|  if (abs(clip.w) <= 0.00001) { return 1.0; }
    #|  let ndc = clip.xyz / clip.w;
    #|  let local_uv = shadow_local_uv(ndc);
    #|  let depth = ndc.z;
    #|  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
    #|  let rect = u_shadow.spot_rects[index];
    #|  let texel = u_shadow.directional_spot_texel.zw;
    #|  let ndotl = max(dot(normal, light_dir), 0.0);
    #|  let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);
    #|  var lit = 0.0;
    #|  var total = 0.0;
    #|  for (var x = -1; x <= 1; x = x + 1) {
    #|    for (var y = -1; y <= 1; y = y + 1) {
    #|      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
    #|      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * 1.25, vec2<f32>(0.0), vec2<f32>(1.0));
    #|      let atlas_uv = rect.xy + sample_uv * rect.zw;
    #|      lit = lit + textureSampleCompareLevel(u_spot_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;
    #|      total = total + weight;
    #|    }
    #|  }
    #|  return select(1.0, lit / total, total > 0.00001);
    #|}
    #|fn select_point_shadow_face(dir: vec3<f32>) -> i32 {
    #|  let abs_dir = abs(dir);
    #|  if (abs_dir.x >= abs_dir.y && abs_dir.x >= abs_dir.z) { return select(1, 0, dir.x >= 0.0); }
    #|  if (abs_dir.y >= abs_dir.x && abs_dir.y >= abs_dir.z) { return select(3, 2, dir.y >= 0.0); }
    #|  return select(5, 4, dir.z >= 0.0);
    #|}
    #|fn sample_point_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, light_to_fragment: vec3<f32>, receive_shadows: bool) -> f32 {
    #|  if (!receive_shadows || index < 0 || index >= 8) { return 1.0; }
    #|  let shadow_meta = u_shadow.point_meta[index];
    #|  if (shadow_meta.x < 0.5) { return 1.0; }
    #|  let face = select_point_shadow_face(light_to_fragment);
    #|  let matrix_index = index * 6 + face;
    #|  let clip = u_shadow.point_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);
    #|  if (abs(clip.w) <= 0.00001) { return 1.0; }
    #|  let ndc = clip.xyz / clip.w;
    #|  let local_uv = shadow_local_uv(ndc);
    #|  let depth = ndc.z;
    #|  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }
    #|  let rect = u_shadow.point_rects[matrix_index];
    #|  let texel = u_shadow.point_texel.xy;
    #|  let ndotl = max(dot(normal, light_dir), 0.0);
    #|  let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);
    #|  var lit = 0.0;
    #|  var total = 0.0;
    #|  for (var x = -1; x <= 1; x = x + 1) {
    #|    for (var y = -1; y <= 1; y = y + 1) {
    #|      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));
    #|      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel, vec2<f32>(0.0), vec2<f32>(1.0));
    #|      let atlas_uv = rect.xy + sample_uv * rect.zw;
    #|      lit = lit + textureSampleCompareLevel(u_point_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;
    #|      total = total + weight;
    #|    }
    #|  }
    #|  return select(1.0, lit / total, total > 0.00001);
    #|}
    #|
    #|
  )
}

///|
fn webgpu_shader3d_lit_color_source() -> String {
  (
    #|struct CameraUniform { view_proj: mat4x4<f32>, };
    #|
  ) +
  webgpu_shader_light_shadow_structs_source() +
  (
    #|@group(0) @binding(0) var<uniform> u_camera: CameraUniform;
    #|@group(0) @binding(1) var<uniform> u_light: LightUniform;
    #|@group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;
    #|@group(0) @binding(3) var u_shadow_sampler: sampler_comparison;
    #|@group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;
    #|@group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;
    #|@group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;
    #|@group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;
    #|@group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;
    #|@group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;
    #|struct VSIn {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(1) normal: vec3<f32>,
    #|  @location(2) color: vec4<f32>,
    #|  @location(3) emissive: vec3<f32>,
    #|  @location(4) material: vec4<f32>,
    #|};
    #|struct VSInInstanced {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(1) normal: vec3<f32>,
    #|  @location(2) color: vec4<f32>,
    #|  @location(3) emissive: vec3<f32>,
    #|  @location(4) material: vec4<f32>,
    #|  @location(5) instance_translation: vec3<f32>,
    #|  @location(6) instance_rotation: vec4<f32>,
    #|  @location(7) instance_scale: vec3<f32>,
    #|  @location(8) instance_receive_shadows: f32,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) world_pos: vec3<f32>,
    #|  @location(1) normal: vec3<f32>,
    #|  @location(2) color: vec4<f32>,
    #|  @location(3) emissive: vec3<f32>,
    #|  @location(4) material: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
    #|  o.world_pos = v.pos;
    #|  o.normal = normalize(v.normal);
    #|  o.color = v.color;
    #|  o.emissive = v.emissive;
    #|  o.material = v.material;
    #|  return o;
    #|}
    #|
  ) +
  webgpu_shader_rotate_quat_source() +
  (
    #|fn safe_scale_component(value: f32) -> f32 {
    #|  return select(value, 1.0, abs(value) <= 0.00001);
    #|}
    #|@vertex fn vs_instanced(v: VSInInstanced) -> VSOut {
    #|  var o: VSOut;
    #|  let scaled_pos = v.pos * v.instance_scale;
    #|  let world_pos = rotate_quat(scaled_pos, v.instance_rotation) + v.instance_translation;
    #|  let inverse_scale = vec3<f32>(
    #|    safe_scale_component(v.instance_scale.x),
    #|    safe_scale_component(v.instance_scale.y),
    #|    safe_scale_component(v.instance_scale.z),
    #|  );
    #|  let scaled_normal = v.normal / inverse_scale;
    #|  let world_normal = normalize(rotate_quat(scaled_normal, v.instance_rotation));
    #|  var material = v.material;
    #|  material.w = v.instance_receive_shadows;
    #|  o.pos = u_camera.view_proj * vec4<f32>(world_pos, 1.0);
    #|  o.world_pos = world_pos;
    #|  o.normal = world_normal;
    #|  o.color = v.color;
    #|  o.emissive = v.emissive;
    #|  o.material = material;
    #|  return o;
    #|}
    #|
  ) +
  webgpu_shader_shadow_sampling_source() +
  (
    #|fn apply_lighting(world_pos: vec3<f32>, normal: vec3<f32>, receive_shadows: bool) -> vec3<f32> {
    #|  let n = normalize(normal);
    #|  var lit = u_light.ambient_directional_count.xyz;
    #|  let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);
    #|  for (var idx = 0; idx < 4; idx = idx + 1) {
    #|    if (idx >= directional_count) { continue; }
    #|    let base = idx * 2;
    #|    let direction_intensity = u_light.directional_data[base];
    #|    let color_data = u_light.directional_data[base + 1];
    #|    let light_dir = normalize(-direction_intensity.xyz);
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let shadow = sample_directional_shadow(idx, world_pos, normal, light_dir, receive_shadows);
    #|    lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;
    #|  }
    #|  let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);
    #|  for (var idx = 0; idx < 8; idx = idx + 1) {
    #|    if (idx >= point_count) { continue; }
    #|    let base = idx * 2;
    #|    let position_intensity = u_light.point_data[base];
    #|    let color_range = u_light.point_data[base + 1];
    #|    let offset = position_intensity.xyz - world_pos;
    #|    let distance = length(offset);
    #|    if (distance <= 0.0001) { continue; }
    #|    let light_dir = offset / distance;
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let attenuation = point_light_attenuation(distance, color_range.w) *
    #|      sample_point_shadow(idx, world_pos, normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);
    #|    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
    #|  }
    #|  let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);
    #|  for (var idx = 0; idx < 4; idx = idx + 1) {
    #|    if (idx >= spot_count) { continue; }
    #|    let base = idx * 4;
    #|    let position_intensity = u_light.spot_data[base];
    #|    let color_range = u_light.spot_data[base + 1];
    #|    let direction_inner = u_light.spot_data[base + 2];
    #|    let outer_cos = u_light.spot_data[base + 3].x;
    #|    let offset = position_intensity.xyz - world_pos;
    #|    let distance = length(offset);
    #|    if (distance <= 0.0001) { continue; }
    #|    let light_dir = offset / distance;
    #|    let to_fragment = -light_dir;
    #|    let spot_direction = normalize(direction_inner.xyz);
    #|    let spot_cos = dot(spot_direction, to_fragment);
    #|    let inner_cos = direction_inner.w;
    #|    let spot_denom = max(inner_cos - outer_cos, 0.0001);
    #|    let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);
    #|    if (spot_factor <= 0.0) { continue; }
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let attenuation = point_light_attenuation(distance, color_range.w) *
    #|      spot_factor * sample_spot_shadow(idx, world_pos, normal, light_dir, receive_shadows);
    #|    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
    #|  }
    #|  return lit;
    #|}
    #|@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
    #|  var albedo = v.color;
    #|  let alpha_mode = i32(round(v.material.x));
    #|  let alpha_cutoff = v.material.y;
    #|  let unlit = v.material.z >= 0.5;
    #|  let receive_shadows = v.material.w >= 0.5;
    #|  if (alpha_mode == 0) {
    #|    albedo.a = 1.0;
    #|  } else if (alpha_mode == 1) {
    #|    if (albedo.a < alpha_cutoff) { discard; }
    #|    albedo.a = 1.0;
    #|  } else if (albedo.a <= 0.0001) {
    #|    discard;
    #|  }
    #|  if (unlit) { return albedo; }
    #|  let lit = apply_lighting(v.world_pos, v.normal, receive_shadows);
    #|  return vec4<f32>(albedo.rgb * lit + v.emissive, albedo.a);
    #|}
    #|
  )
}

///|
fn webgpu_shader3d_lit_texture_source() -> String {
  (
    #|struct CameraUniform { view_proj: mat4x4<f32>, };
    #|
  ) +
  webgpu_shader_light_shadow_structs_source() +
  (
    #|@group(0) @binding(0) var<uniform> u_camera: CameraUniform;
    #|@group(0) @binding(1) var<uniform> u_light: LightUniform;
    #|@group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;
    #|@group(0) @binding(3) var u_shadow_sampler: sampler_comparison;
    #|@group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;
    #|@group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;
    #|@group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;
    #|@group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;
    #|@group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;
    #|@group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;
    #|@group(0) @binding(10) var u_base_sampler: sampler;
    #|@group(0) @binding(11) var u_texture: texture_2d<f32>;
    #|@group(0) @binding(12) var u_emissive_sampler: sampler;
    #|@group(0) @binding(13) var u_emissive_texture: texture_2d<f32>;
    #|@group(0) @binding(14) var u_metallic_roughness_sampler: sampler;
    #|@group(0) @binding(15) var u_metallic_roughness_texture: texture_2d<f32>;
    #|@group(0) @binding(16) var u_occlusion_sampler: sampler;
    #|@group(0) @binding(17) var u_occlusion_texture: texture_2d<f32>;
    #|@group(0) @binding(18) var u_normal_sampler: sampler;
    #|@group(0) @binding(19) var u_normal_texture: texture_2d<f32>;
    #|struct VSIn {
    #|  @location(0) pos: vec3<f32>,
    #|  @location(1) normal: vec3<f32>,
    #|  @location(2) base_uv: vec2<f32>,
    #|  @location(3) emissive_uv: vec2<f32>,
    #|  @location(4) metallic_roughness_uv: vec2<f32>,
    #|  @location(5) occlusion_uv: vec2<f32>,
    #|  @location(6) normal_uv: vec2<f32>,
    #|  @location(7) color: vec4<f32>,
    #|  @location(8) emissive: vec3<f32>,
    #|  @location(9) tangent: vec4<f32>,
    #|  @location(10) material: vec4<f32>,
    #|  @location(11) surface: vec4<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) world_pos: vec3<f32>,
    #|  @location(1) normal: vec3<f32>,
    #|  @location(2) base_uv: vec2<f32>,
    #|  @location(3) emissive_uv: vec2<f32>,
    #|  @location(4) metallic_roughness_uv: vec2<f32>,
    #|  @location(5) occlusion_uv: vec2<f32>,
    #|  @location(6) normal_uv: vec2<f32>,
    #|  @location(7) color: vec4<f32>,
    #|  @location(8) emissive: vec3<f32>,
    #|  @location(9) tangent: vec4<f32>,
    #|  @location(10) material: vec4<f32>,
    #|  @location(11) surface: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);
    #|  o.world_pos = v.pos;
    #|  o.normal = normalize(v.normal);
    #|  o.base_uv = v.base_uv;
    #|  o.emissive_uv = v.emissive_uv;
    #|  o.metallic_roughness_uv = v.metallic_roughness_uv;
    #|  o.occlusion_uv = v.occlusion_uv;
    #|  o.normal_uv = v.normal_uv;
    #|  o.color = v.color;
    #|  o.emissive = v.emissive;
    #|  o.tangent = v.tangent;
    #|  o.material = v.material;
    #|  o.surface = v.surface;
    #|  return o;
    #|}
    #|
  ) +
  webgpu_shader_shadow_sampling_source() +
  (
    #|fn apply_lighting(world_pos: vec3<f32>, shading_normal: vec3<f32>, geometric_normal: vec3<f32>, view_dir: vec3<f32>, roughness: f32, metallic: f32, receive_shadows: bool) -> vec3<f32> {
    #|  let n = normalize(shading_normal);
    #|  var lit = u_light.ambient_directional_count.xyz;
    #|  var specular = vec3<f32>(0.0);
    #|  let shininess = mix(96.0, 8.0, clamp(roughness, 0.0, 1.0));
    #|  let specular_strength = mix(0.04, 1.0, clamp(metallic, 0.0, 1.0));
    #|  let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);
    #|  for (var idx = 0; idx < 4; idx = idx + 1) {
    #|    if (idx >= directional_count) { continue; }
    #|    let base = idx * 2;
    #|    let direction_intensity = u_light.directional_data[base];
    #|    let color_data = u_light.directional_data[base + 1];
    #|    let light_dir = normalize(-direction_intensity.xyz);
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let shadow = sample_directional_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);
    #|    lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;
    #|    if (lambert > 0.0) {
    #|      let halfway = safe_normalize(light_dir + view_dir, view_dir);
    #|      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
    #|      specular = specular + color_data.xyz * direction_intensity.w * spec * shadow;
    #|    }
    #|  }
    #|  let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);
    #|  for (var idx = 0; idx < 8; idx = idx + 1) {
    #|    if (idx >= point_count) { continue; }
    #|    let base = idx * 2;
    #|    let position_intensity = u_light.point_data[base];
    #|    let color_range = u_light.point_data[base + 1];
    #|    let offset = position_intensity.xyz - world_pos;
    #|    let distance = length(offset);
    #|    if (distance <= 0.0001) { continue; }
    #|    let light_dir = offset / distance;
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let shadow = sample_point_shadow(idx, world_pos, geometric_normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);
    #|    let attenuation = point_light_attenuation(distance, color_range.w) * shadow;
    #|    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
    #|    if (lambert > 0.0 && attenuation > 0.0) {
    #|      let halfway = safe_normalize(light_dir + view_dir, view_dir);
    #|      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
    #|      specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;
    #|    }
    #|  }
    #|  let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);
    #|  for (var idx = 0; idx < 4; idx = idx + 1) {
    #|    if (idx >= spot_count) { continue; }
    #|    let base = idx * 4;
    #|    let position_intensity = u_light.spot_data[base];
    #|    let color_range = u_light.spot_data[base + 1];
    #|    let direction_inner = u_light.spot_data[base + 2];
    #|    let outer_cos = u_light.spot_data[base + 3].x;
    #|    let offset = position_intensity.xyz - world_pos;
    #|    let distance = length(offset);
    #|    if (distance <= 0.0001) { continue; }
    #|    let light_dir = offset / distance;
    #|    let to_fragment = -light_dir;
    #|    let spot_direction = normalize(direction_inner.xyz);
    #|    let spot_cos = dot(spot_direction, to_fragment);
    #|    let inner_cos = direction_inner.w;
    #|    let spot_denom = max(inner_cos - outer_cos, 0.0001);
    #|    let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);
    #|    if (spot_factor <= 0.0) { continue; }
    #|    let lambert = max(dot(n, light_dir), 0.0);
    #|    let shadow = sample_spot_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);
    #|    let attenuation = point_light_attenuation(distance, color_range.w) * spot_factor * shadow;
    #|    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;
    #|    if (lambert > 0.0 && attenuation > 0.0) {
    #|      let halfway = safe_normalize(light_dir + view_dir, view_dir);
    #|      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;
    #|      specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;
    #|    }
    #|  }
    #|  return lit + specular;
    #|}
    #|@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
    #|  var albedo = textureSample(u_texture, u_base_sampler, v.base_uv) * v.color;
    #|  let emissive_sample = textureSample(u_emissive_texture, u_emissive_sampler, v.emissive_uv).rgb;
    #|  let mr_sample = textureSample(u_metallic_roughness_texture, u_metallic_roughness_sampler, v.metallic_roughness_uv);
    #|  let occlusion_sample = textureSample(u_occlusion_texture, u_occlusion_sampler, v.occlusion_uv);
    #|  let normal_sample = textureSample(u_normal_texture, u_normal_sampler, v.normal_uv).xyz * 2.0 - vec3<f32>(1.0, 1.0, 1.0);
    #|  let alpha_mode = i32(round(v.material.x));
    #|  let alpha_cutoff = v.material.y;
    #|  let unlit = v.surface.z >= 0.5;
    #|  let receive_shadows = v.surface.w >= 0.5;
    #|  if (alpha_mode == 0) {
    #|    albedo.a = 1.0;
    #|  } else if (alpha_mode == 1) {
    #|    if (albedo.a < alpha_cutoff) { discard; }
    #|    albedo.a = 1.0;
    #|  } else if (albedo.a <= 0.0001) {
    #|    discard;
    #|  }
    #|  if (unlit) { return albedo; }
    #|  let tangent = safe_normalize(v.tangent.xyz - v.normal * dot(v.tangent.xyz, v.normal), vec3<f32>(1.0, 0.0, 0.0));
    #|  let bitangent = safe_normalize(cross(v.normal, tangent) * v.tangent.w, vec3<f32>(0.0, 1.0, 0.0));
    #|  let tangent_normal = normalize(vec3<f32>(normal_sample.xy * v.surface.y, normal_sample.z));
    #|  let geometric_normal = normalize(v.normal);
    #|  let mapped_normal = safe_normalize(
    #|    tangent * tangent_normal.x + bitangent * tangent_normal.y + v.normal * tangent_normal.z,
    #|    geometric_normal,
    #|  );
    #|  let metallic = clamp(v.material.z * mr_sample.b, 0.0, 1.0);
    #|  let roughness = clamp(v.material.w * mr_sample.g, 0.0, 1.0);
    #|  let view_dir = safe_normalize(u_light.view_position.xyz - v.world_pos, vec3<f32>(0.0, 0.0, 1.0));
    #|  let lit = apply_lighting(v.world_pos, mapped_normal, geometric_normal, view_dir, roughness, metallic, receive_shadows);
    #|  let occlusion = mix(1.0, occlusion_sample.r, clamp(v.surface.x, 0.0, 1.0));
    #|  let emissive = emissive_sample * v.emissive;
    #|  return vec4<f32>(albedo.rgb * lit * occlusion + emissive, albedo.a);
    #|}
    #|
  )
}

///|
fn webgpu_shader2d_texture_source() -> String {
  (
    #|struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };
    #|@group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;
    #|@group(0) @binding(1) var u_sampler: sampler;
    #|@group(0) @binding(2) var u_texture: texture_2d<f32>;
    #|struct VSIn {
    #|  @location(0) pos: vec2<f32>,
    #|  @location(1) uv: vec2<f32>,
    #|  @location(2) color: vec4<f32>,
    #|};
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|  @location(0) uv: vec2<f32>,
    #|  @location(1) color: vec4<f32>,
    #|};
    #|@vertex fn vs_main(v: VSIn) -> VSOut {
    #|  var o: VSOut;
    #|  let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;
    #|  let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;
    #|  o.pos = vec4<f32>(nx, ny, 0.0, 1.0);
    #|  o.uv = v.uv;
    #|  o.color = v.color;
    #|  return o;
    #|}
    #|@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {
    #|  return textureSample(u_texture, u_sampler, v.uv) * v.color;
    #|}
    #|
  )
}
