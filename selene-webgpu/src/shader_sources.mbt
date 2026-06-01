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
  "struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };\n" +
  "@group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec2<f32>,\n" +
  "  @location(1) color: vec4<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) color: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;\n" +
  "  let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;\n" +
  "  o.pos = vec4<f32>(nx, ny, 0.0, 1.0);\n" +
  "  o.color = v.color;\n" +
  "  return o;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {\n" +
  "  return v.color;\n" +
  "}\n"
}

///|
fn webgpu_shader3d_color_source() -> String {
  "struct CameraUniform {\n" +
  "  view_proj: mat4x4<f32>,\n" +
  "};\n" +
  "@group(0) @binding(0) var<uniform> u_camera: CameraUniform;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(1) color: vec4<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) color: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  o.color = v.color;\n" +
  "  return o;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {\n" +
  "  return v.color;\n" +
  "}\n"
}

///|
fn webgpu_shader3d_shadow_solid_source() -> String {
  "struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };\n" +
  "@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;\n" +
  "struct VSIn { @location(0) pos: vec3<f32>, @location(1) color: vec4<f32>, };\n" +
  "struct VSOut { @builtin(position) pos: vec4<f32>, };\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  return o;\n" +
  "}\n"
}

///|
fn webgpu_shader3d_shadow_lit_source() -> String {
  "struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };\n" +
  "@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "  @location(4) material: vec4<f32>,\n" +
  "};\n" +
  "struct VSInInstanced {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "  @location(4) material: vec4<f32>,\n" +
  "  @location(5) instance_translation: vec3<f32>,\n" +
  "  @location(6) instance_rotation: vec4<f32>,\n" +
  "  @location(7) instance_scale: vec3<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) color: vec4<f32>,\n" +
  "  @location(1) material: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  o.color = v.color;\n" +
  "  o.material = v.material;\n" +
  "  return o;\n" +
  "}\n" +
  webgpu_shader_rotate_quat_source() +
  "@vertex fn vs_instanced(v: VSInInstanced) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  let world_pos = rotate_quat(v.pos * v.instance_scale, v.instance_rotation) + v.instance_translation;\n" +
  "  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(world_pos, 1.0);\n" +
  "  o.color = v.color;\n" +
  "  o.material = v.material;\n" +
  "  return o;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) {\n" +
  "  let alpha_mode = i32(round(v.material.x));\n" +
  "  let alpha_cutoff = v.material.y;\n" +
  "  if (alpha_mode == 2) { discard; }\n" +
  "  if (alpha_mode == 1 && v.color.a < alpha_cutoff) { discard; }\n" +
  "}\n"
}

///|
fn webgpu_shader3d_shadow_texture_source() -> String {
  "struct ShadowCameraUniform { light_view_proj: mat4x4<f32>, };\n" +
  "@group(0) @binding(0) var<uniform> u_shadow_camera: ShadowCameraUniform;\n" +
  "@group(0) @binding(1) var u_shadow_base_sampler: sampler;\n" +
  "@group(0) @binding(2) var u_shadow_base_texture: texture_2d<f32>;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(2) base_uv: vec2<f32>,\n" +
  "  @location(7) color: vec4<f32>,\n" +
  "  @location(10) material: vec4<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) base_uv: vec2<f32>,\n" +
  "  @location(1) color: vec4<f32>,\n" +
  "  @location(2) material: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_shadow_camera.light_view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  o.base_uv = v.base_uv;\n" +
  "  o.color = v.color;\n" +
  "  o.material = v.material;\n" +
  "  return o;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) {\n" +
  "  let alpha_mode = i32(round(v.material.x));\n" +
  "  let alpha_cutoff = v.material.y;\n" +
  "  if (alpha_mode == 2) { discard; }\n" +
  "  let albedo = textureSample(u_shadow_base_texture, u_shadow_base_sampler, v.base_uv) * v.color;\n" +
  "  if (alpha_mode == 1 && albedo.a < alpha_cutoff) { discard; }\n" +
  "}\n"
}

///|
fn webgpu_shader_rotate_quat_source() -> String {
  "fn rotate_quat(value: vec3<f32>, quat: vec4<f32>) -> vec3<f32> {\n" +
  "  let len = length(quat);\n" +
  "  var q = quat;\n" +
  "  if (len <= 0.00001) {\n" +
  "    q = vec4<f32>(0.0, 0.0, 0.0, 1.0);\n" +
  "  } else {\n" +
  "    q = quat / len;\n" +
  "  }\n" +
  "  let u = q.xyz;\n" +
  "  let s = q.w;\n" +
  "  return 2.0 * dot(u, value) * u + (s * s - dot(u, u)) * value + 2.0 * s * cross(u, value);\n" +
  "}\n"
}

///|
fn webgpu_shader_light_shadow_structs_source() -> String {
  "struct LightUniform {\n" +
  "  ambient_directional_count: vec4<f32>,\n" +
  "  point_spot_count: vec4<f32>,\n" +
  "  view_position: vec4<f32>,\n" +
  "  view_forward: vec4<f32>,\n" +
  "  directional_data: array<vec4<f32>, 8>,\n" +
  "  point_data: array<vec4<f32>, 16>,\n" +
  "  spot_data: array<vec4<f32>, 16>,\n" +
  "};\n" +
  "struct ShadowUniform {\n" +
  "  directional_spot_texel: vec4<f32>,\n" +
  "  point_texel: vec4<f32>,\n" +
  "  directional_meta: array<vec4<f32>, 4>,\n" +
  "  directional_bounds: array<vec4<f32>, 16>,\n" +
  "  directional_rects: array<vec4<f32>, 16>,\n" +
  "  directional_matrices: array<mat4x4<f32>, 16>,\n" +
  "  spot_meta: array<vec4<f32>, 4>,\n" +
  "  spot_rects: array<vec4<f32>, 4>,\n" +
  "  spot_matrices: array<mat4x4<f32>, 4>,\n" +
  "  point_meta: array<vec4<f32>, 8>,\n" +
  "  point_rects: array<vec4<f32>, 48>,\n" +
  "  point_matrices: array<mat4x4<f32>, 48>,\n" +
  "};\n" +
  "\n"
}

///|
fn webgpu_shader_shadow_sampling_source() -> String {
  "fn saturate(value: f32) -> f32 { return clamp(value, 0.0, 1.0); }\n" +
  "fn point_light_attenuation(distance: f32, range: f32) -> f32 {\n" +
  "  let safe_range = max(range, 0.0001);\n" +
  "  return saturate(1.0 - distance / safe_range);\n" +
  "}\n" +
  "fn safe_normalize(value: vec3<f32>, fallback: vec3<f32>) -> vec3<f32> {\n" +
  "  let len = length(value);\n" +
  "  if (len <= 0.0001) { return fallback; }\n" +
  "  return value / len;\n" +
  "}\n" +
  "fn shadow_local_uv(ndc: vec3<f32>) -> vec2<f32> {\n" +
  "  return vec2<f32>(ndc.x * 0.5 + 0.5, 0.5 - ndc.y * 0.5);\n" +
  "}\n" +
  "fn sample_directional_shadow_compare(index: i32, uv: vec2<f32>, depth_ref: f32) -> f32 {\n" +
  "  if (index == 0) { return textureSampleCompareLevel(u_directional_shadow0, u_shadow_sampler, uv, depth_ref); }\n" +
  "  if (index == 1) { return textureSampleCompareLevel(u_directional_shadow1, u_shadow_sampler, uv, depth_ref); }\n" +
  "  if (index == 2) { return textureSampleCompareLevel(u_directional_shadow2, u_shadow_sampler, uv, depth_ref); }\n" +
  "  if (index == 3) { return textureSampleCompareLevel(u_directional_shadow3, u_shadow_sampler, uv, depth_ref); }\n" +
  "  return 1.0;\n" +
  "}\n" +
  "fn sample_directional_shadow(light_index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {\n" +
  "  if (!receive_shadows || light_index < 0 || light_index >= 4) { return 1.0; }\n" +
  "  let shadow_meta = u_shadow.directional_meta[light_index];\n" +
  "  if (shadow_meta.x < 0.5) { return 1.0; }\n" +
  "  let cascade_count = clamp(i32(round(shadow_meta.y)), 0, 4);\n" +
  "  if (cascade_count <= 0) { return 1.0; }\n" +
  "  let view_depth = dot(world_pos - u_light.view_position.xyz, u_light.view_forward.xyz);\n" +
  "  let base_index = light_index * 4;\n" +
  "  let first_near = u_shadow.directional_bounds[base_index].x;\n" +
  "  let last_far = u_shadow.directional_bounds[base_index + cascade_count - 1].y;\n" +
  "  if (view_depth < first_near || view_depth > last_far) { return 1.0; }\n" +
  "  var selected = cascade_count - 1;\n" +
  "  for (var cascade_index = 0; cascade_index < 4; cascade_index = cascade_index + 1) {\n" +
  "    if (cascade_index >= cascade_count) { continue; }\n" +
  "    if (view_depth <= u_shadow.directional_bounds[base_index + cascade_index].y) {\n" +
  "      selected = cascade_index;\n" +
  "      break;\n" +
  "    }\n" +
  "  }\n" +
  "  let texel = u_shadow.directional_spot_texel.xy;\n" +
  "  let ndotl = max(dot(normal, light_dir), 0.0);\n" +
  "  let bias = max(0.0, shadow_meta.z) + max(0.0, shadow_meta.w) * max(texel.x, texel.y) * (1.0 - ndotl);\n" +
  "  let filter_radius = 1.25;\n" +
  "  let matrix_index = base_index + selected;\n" +
  "  let clip = u_shadow.directional_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);\n" +
  "  if (abs(clip.w) <= 0.00001) { return 1.0; }\n" +
  "  let ndc = clip.xyz / clip.w;\n" +
  "  let local_uv = shadow_local_uv(ndc);\n" +
  "  let depth = ndc.z;\n" +
  "  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }\n" +
  "  let rect = u_shadow.directional_rects[matrix_index];\n" +
  "  var lit = 0.0;\n" +
  "  var total = 0.0;\n" +
  "  for (var x = -1; x <= 1; x = x + 1) {\n" +
  "    for (var y = -1; y <= 1; y = y + 1) {\n" +
  "      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));\n" +
  "      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));\n" +
  "      let atlas_uv = rect.xy + sample_uv * rect.zw;\n" +
  "      lit = lit + sample_directional_shadow_compare(light_index, atlas_uv, depth - bias) * weight;\n" +
  "      total = total + weight;\n" +
  "    }\n" +
  "  }\n" +
  "  var shadow = select(1.0, lit / total, total > 0.00001);\n" +
  "  if (selected > 0) {\n" +
  "    let previous = selected - 1;\n" +
  "    let overlap_near = u_shadow.directional_bounds[base_index + selected].x;\n" +
  "    let overlap_far = u_shadow.directional_bounds[base_index + previous].y;\n" +
  "    if (overlap_near < overlap_far && view_depth >= overlap_near && view_depth <= overlap_far) {\n" +
  "      let prev_index = base_index + previous;\n" +
  "      let prev_clip = u_shadow.directional_matrices[prev_index] * vec4<f32>(world_pos, 1.0);\n" +
  "      if (abs(prev_clip.w) > 0.00001) {\n" +
  "        let prev_ndc = prev_clip.xyz / prev_clip.w;\n" +
  "        let prev_local_uv = shadow_local_uv(prev_ndc);\n" +
  "        let prev_depth = prev_ndc.z;\n" +
  "        if (!(prev_depth <= 0.0 || prev_depth >= 1.0 || any(prev_local_uv < vec2<f32>(0.0)) || any(prev_local_uv > vec2<f32>(1.0)))) {\n" +
  "          let prev_rect = u_shadow.directional_rects[prev_index];\n" +
  "          var prev_lit = 0.0;\n" +
  "          var prev_total = 0.0;\n" +
  "          for (var px = -1; px <= 1; px = px + 1) {\n" +
  "            for (var py = -1; py <= 1; py = py + 1) {\n" +
  "              let prev_weight = 1.0 / (1.0 + abs(f32(px)) + abs(f32(py)));\n" +
  "              let prev_sample_uv = clamp(prev_local_uv + vec2<f32>(f32(px), f32(py)) * texel * filter_radius, vec2<f32>(0.0), vec2<f32>(1.0));\n" +
  "              let prev_atlas_uv = prev_rect.xy + prev_sample_uv * prev_rect.zw;\n" +
  "              prev_lit = prev_lit + sample_directional_shadow_compare(light_index, prev_atlas_uv, prev_depth - bias) * prev_weight;\n" +
  "              prev_total = prev_total + prev_weight;\n" +
  "            }\n" +
  "          }\n" +
  "          let previous_shadow = select(1.0, prev_lit / prev_total, prev_total > 0.00001);\n" +
  "          let blend = clamp((view_depth - overlap_near) / (overlap_far - overlap_near), 0.0, 1.0);\n" +
  "          shadow = mix(previous_shadow, shadow, blend);\n" +
  "        }\n" +
  "      }\n" +
  "    }\n" +
  "  }\n" +
  "  return shadow;\n" +
  "}\n" +
  "fn sample_spot_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, receive_shadows: bool) -> f32 {\n" +
  "  if (!receive_shadows || index < 0 || index >= 4) { return 1.0; }\n" +
  "  let shadow_meta = u_shadow.spot_meta[index];\n" +
  "  if (shadow_meta.x < 0.5) { return 1.0; }\n" +
  "  let clip = u_shadow.spot_matrices[index] * vec4<f32>(world_pos, 1.0);\n" +
  "  if (abs(clip.w) <= 0.00001) { return 1.0; }\n" +
  "  let ndc = clip.xyz / clip.w;\n" +
  "  let local_uv = shadow_local_uv(ndc);\n" +
  "  let depth = ndc.z;\n" +
  "  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }\n" +
  "  let rect = u_shadow.spot_rects[index];\n" +
  "  let texel = u_shadow.directional_spot_texel.zw;\n" +
  "  let ndotl = max(dot(normal, light_dir), 0.0);\n" +
  "  let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);\n" +
  "  var lit = 0.0;\n" +
  "  var total = 0.0;\n" +
  "  for (var x = -1; x <= 1; x = x + 1) {\n" +
  "    for (var y = -1; y <= 1; y = y + 1) {\n" +
  "      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));\n" +
  "      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel * 1.25, vec2<f32>(0.0), vec2<f32>(1.0));\n" +
  "      let atlas_uv = rect.xy + sample_uv * rect.zw;\n" +
  "      lit = lit + textureSampleCompareLevel(u_spot_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;\n" +
  "      total = total + weight;\n" +
  "    }\n" +
  "  }\n" +
  "  return select(1.0, lit / total, total > 0.00001);\n" +
  "}\n" +
  "fn select_point_shadow_face(dir: vec3<f32>) -> i32 {\n" +
  "  let abs_dir = abs(dir);\n" +
  "  if (abs_dir.x >= abs_dir.y && abs_dir.x >= abs_dir.z) { return select(1, 0, dir.x >= 0.0); }\n" +
  "  if (abs_dir.y >= abs_dir.x && abs_dir.y >= abs_dir.z) { return select(3, 2, dir.y >= 0.0); }\n" +
  "  return select(5, 4, dir.z >= 0.0);\n" +
  "}\n" +
  "fn sample_point_shadow(index: i32, world_pos: vec3<f32>, normal: vec3<f32>, light_dir: vec3<f32>, light_to_fragment: vec3<f32>, receive_shadows: bool) -> f32 {\n" +
  "  if (!receive_shadows || index < 0 || index >= 8) { return 1.0; }\n" +
  "  let shadow_meta = u_shadow.point_meta[index];\n" +
  "  if (shadow_meta.x < 0.5) { return 1.0; }\n" +
  "  let face = select_point_shadow_face(light_to_fragment);\n" +
  "  let matrix_index = index * 6 + face;\n" +
  "  let clip = u_shadow.point_matrices[matrix_index] * vec4<f32>(world_pos, 1.0);\n" +
  "  if (abs(clip.w) <= 0.00001) { return 1.0; }\n" +
  "  let ndc = clip.xyz / clip.w;\n" +
  "  let local_uv = shadow_local_uv(ndc);\n" +
  "  let depth = ndc.z;\n" +
  "  if (depth <= 0.0 || depth >= 1.0 || any(local_uv < vec2<f32>(0.0)) || any(local_uv > vec2<f32>(1.0))) { return 1.0; }\n" +
  "  let rect = u_shadow.point_rects[matrix_index];\n" +
  "  let texel = u_shadow.point_texel.xy;\n" +
  "  let ndotl = max(dot(normal, light_dir), 0.0);\n" +
  "  let bias = max(0.0, shadow_meta.y) + max(0.0, shadow_meta.z) * max(texel.x, texel.y) * (1.0 - ndotl);\n" +
  "  var lit = 0.0;\n" +
  "  var total = 0.0;\n" +
  "  for (var x = -1; x <= 1; x = x + 1) {\n" +
  "    for (var y = -1; y <= 1; y = y + 1) {\n" +
  "      let weight = 1.0 / (1.0 + abs(f32(x)) + abs(f32(y)));\n" +
  "      let sample_uv = clamp(local_uv + vec2<f32>(f32(x), f32(y)) * texel, vec2<f32>(0.0), vec2<f32>(1.0));\n" +
  "      let atlas_uv = rect.xy + sample_uv * rect.zw;\n" +
  "      lit = lit + textureSampleCompareLevel(u_point_shadow_atlas, u_shadow_sampler, atlas_uv, depth - bias) * weight;\n" +
  "      total = total + weight;\n" +
  "    }\n" +
  "  }\n" +
  "  return select(1.0, lit / total, total > 0.00001);\n" +
  "}\n" +
  "\n"
}

///|
fn webgpu_shader3d_lit_color_source() -> String {
  "struct CameraUniform { view_proj: mat4x4<f32>, };\n" +
  webgpu_shader_light_shadow_structs_source() +
  "@group(0) @binding(0) var<uniform> u_camera: CameraUniform;\n" +
  "@group(0) @binding(1) var<uniform> u_light: LightUniform;\n" +
  "@group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;\n" +
  "@group(0) @binding(3) var u_shadow_sampler: sampler_comparison;\n" +
  "@group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;\n" +
  "@group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;\n" +
  "@group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;\n" +
  "@group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;\n" +
  "@group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;\n" +
  "@group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(1) normal: vec3<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "  @location(3) emissive: vec3<f32>,\n" +
  "  @location(4) material: vec4<f32>,\n" +
  "};\n" +
  "struct VSInInstanced {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(1) normal: vec3<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "  @location(3) emissive: vec3<f32>,\n" +
  "  @location(4) material: vec4<f32>,\n" +
  "  @location(5) instance_translation: vec3<f32>,\n" +
  "  @location(6) instance_rotation: vec4<f32>,\n" +
  "  @location(7) instance_scale: vec3<f32>,\n" +
  "  @location(8) instance_receive_shadows: f32,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) world_pos: vec3<f32>,\n" +
  "  @location(1) normal: vec3<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "  @location(3) emissive: vec3<f32>,\n" +
  "  @location(4) material: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  o.world_pos = v.pos;\n" +
  "  o.normal = normalize(v.normal);\n" +
  "  o.color = v.color;\n" +
  "  o.emissive = v.emissive;\n" +
  "  o.material = v.material;\n" +
  "  return o;\n" +
  "}\n" +
  webgpu_shader_rotate_quat_source() +
  "fn safe_scale_component(value: f32) -> f32 {\n" +
  "  return select(value, 1.0, abs(value) <= 0.00001);\n" +
  "}\n" +
  "@vertex fn vs_instanced(v: VSInInstanced) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  let scaled_pos = v.pos * v.instance_scale;\n" +
  "  let world_pos = rotate_quat(scaled_pos, v.instance_rotation) + v.instance_translation;\n" +
  "  let inverse_scale = vec3<f32>(\n" +
  "    safe_scale_component(v.instance_scale.x),\n" +
  "    safe_scale_component(v.instance_scale.y),\n" +
  "    safe_scale_component(v.instance_scale.z),\n" +
  "  );\n" +
  "  let scaled_normal = v.normal / inverse_scale;\n" +
  "  let world_normal = normalize(rotate_quat(scaled_normal, v.instance_rotation));\n" +
  "  var material = v.material;\n" +
  "  material.w = v.instance_receive_shadows;\n" +
  "  o.pos = u_camera.view_proj * vec4<f32>(world_pos, 1.0);\n" +
  "  o.world_pos = world_pos;\n" +
  "  o.normal = world_normal;\n" +
  "  o.color = v.color;\n" +
  "  o.emissive = v.emissive;\n" +
  "  o.material = material;\n" +
  "  return o;\n" +
  "}\n" +
  webgpu_shader_shadow_sampling_source() +
  "fn apply_lighting(world_pos: vec3<f32>, normal: vec3<f32>, receive_shadows: bool) -> vec3<f32> {\n" +
  "  let n = normalize(normal);\n" +
  "  var lit = u_light.ambient_directional_count.xyz;\n" +
  "  let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);\n" +
  "  for (var idx = 0; idx < 4; idx = idx + 1) {\n" +
  "    if (idx >= directional_count) { continue; }\n" +
  "    let base = idx * 2;\n" +
  "    let direction_intensity = u_light.directional_data[base];\n" +
  "    let color_data = u_light.directional_data[base + 1];\n" +
  "    let light_dir = normalize(-direction_intensity.xyz);\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let shadow = sample_directional_shadow(idx, world_pos, normal, light_dir, receive_shadows);\n" +
  "    lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;\n" +
  "  }\n" +
  "  let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);\n" +
  "  for (var idx = 0; idx < 8; idx = idx + 1) {\n" +
  "    if (idx >= point_count) { continue; }\n" +
  "    let base = idx * 2;\n" +
  "    let position_intensity = u_light.point_data[base];\n" +
  "    let color_range = u_light.point_data[base + 1];\n" +
  "    let offset = position_intensity.xyz - world_pos;\n" +
  "    let distance = length(offset);\n" +
  "    if (distance <= 0.0001) { continue; }\n" +
  "    let light_dir = offset / distance;\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let attenuation = point_light_attenuation(distance, color_range.w) *\n" +
  "      sample_point_shadow(idx, world_pos, normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);\n" +
  "    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;\n" +
  "  }\n" +
  "  let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);\n" +
  "  for (var idx = 0; idx < 4; idx = idx + 1) {\n" +
  "    if (idx >= spot_count) { continue; }\n" +
  "    let base = idx * 4;\n" +
  "    let position_intensity = u_light.spot_data[base];\n" +
  "    let color_range = u_light.spot_data[base + 1];\n" +
  "    let direction_inner = u_light.spot_data[base + 2];\n" +
  "    let outer_cos = u_light.spot_data[base + 3].x;\n" +
  "    let offset = position_intensity.xyz - world_pos;\n" +
  "    let distance = length(offset);\n" +
  "    if (distance <= 0.0001) { continue; }\n" +
  "    let light_dir = offset / distance;\n" +
  "    let to_fragment = -light_dir;\n" +
  "    let spot_direction = normalize(direction_inner.xyz);\n" +
  "    let spot_cos = dot(spot_direction, to_fragment);\n" +
  "    let inner_cos = direction_inner.w;\n" +
  "    let spot_denom = max(inner_cos - outer_cos, 0.0001);\n" +
  "    let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);\n" +
  "    if (spot_factor <= 0.0) { continue; }\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let attenuation = point_light_attenuation(distance, color_range.w) *\n" +
  "      spot_factor * sample_spot_shadow(idx, world_pos, normal, light_dir, receive_shadows);\n" +
  "    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;\n" +
  "  }\n" +
  "  return lit;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {\n" +
  "  var albedo = v.color;\n" +
  "  let alpha_mode = i32(round(v.material.x));\n" +
  "  let alpha_cutoff = v.material.y;\n" +
  "  let unlit = v.material.z >= 0.5;\n" +
  "  let receive_shadows = v.material.w >= 0.5;\n" +
  "  if (alpha_mode == 0) {\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (alpha_mode == 1) {\n" +
  "    if (albedo.a < alpha_cutoff) { discard; }\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (albedo.a <= 0.0001) {\n" +
  "    discard;\n" +
  "  }\n" +
  "  if (unlit) { return albedo; }\n" +
  "  let lit = apply_lighting(v.world_pos, v.normal, receive_shadows);\n" +
  "  return vec4<f32>(albedo.rgb * lit + v.emissive, albedo.a);\n" +
  "}\n"
}

///|
fn webgpu_shader3d_lit_texture_source() -> String {
  "struct CameraUniform { view_proj: mat4x4<f32>, };\n" +
  webgpu_shader_light_shadow_structs_source() +
  "@group(0) @binding(0) var<uniform> u_camera: CameraUniform;\n" +
  "@group(0) @binding(1) var<uniform> u_light: LightUniform;\n" +
  "@group(0) @binding(2) var<uniform> u_shadow: ShadowUniform;\n" +
  "@group(0) @binding(3) var u_shadow_sampler: sampler_comparison;\n" +
  "@group(0) @binding(4) var u_directional_shadow0: texture_depth_2d;\n" +
  "@group(0) @binding(5) var u_directional_shadow1: texture_depth_2d;\n" +
  "@group(0) @binding(6) var u_directional_shadow2: texture_depth_2d;\n" +
  "@group(0) @binding(7) var u_directional_shadow3: texture_depth_2d;\n" +
  "@group(0) @binding(8) var u_spot_shadow_atlas: texture_depth_2d;\n" +
  "@group(0) @binding(9) var u_point_shadow_atlas: texture_depth_2d;\n" +
  "@group(0) @binding(10) var u_base_sampler: sampler;\n" +
  "@group(0) @binding(11) var u_texture: texture_2d<f32>;\n" +
  "@group(0) @binding(12) var u_emissive_sampler: sampler;\n" +
  "@group(0) @binding(13) var u_emissive_texture: texture_2d<f32>;\n" +
  "@group(0) @binding(14) var u_metallic_roughness_sampler: sampler;\n" +
  "@group(0) @binding(15) var u_metallic_roughness_texture: texture_2d<f32>;\n" +
  "@group(0) @binding(16) var u_occlusion_sampler: sampler;\n" +
  "@group(0) @binding(17) var u_occlusion_texture: texture_2d<f32>;\n" +
  "@group(0) @binding(18) var u_normal_sampler: sampler;\n" +
  "@group(0) @binding(19) var u_normal_texture: texture_2d<f32>;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec3<f32>,\n" +
  "  @location(1) normal: vec3<f32>,\n" +
  "  @location(2) base_uv: vec2<f32>,\n" +
  "  @location(3) emissive_uv: vec2<f32>,\n" +
  "  @location(4) metallic_roughness_uv: vec2<f32>,\n" +
  "  @location(5) occlusion_uv: vec2<f32>,\n" +
  "  @location(6) normal_uv: vec2<f32>,\n" +
  "  @location(7) color: vec4<f32>,\n" +
  "  @location(8) emissive: vec3<f32>,\n" +
  "  @location(9) tangent: vec4<f32>,\n" +
  "  @location(10) material: vec4<f32>,\n" +
  "  @location(11) surface: vec4<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) world_pos: vec3<f32>,\n" +
  "  @location(1) normal: vec3<f32>,\n" +
  "  @location(2) base_uv: vec2<f32>,\n" +
  "  @location(3) emissive_uv: vec2<f32>,\n" +
  "  @location(4) metallic_roughness_uv: vec2<f32>,\n" +
  "  @location(5) occlusion_uv: vec2<f32>,\n" +
  "  @location(6) normal_uv: vec2<f32>,\n" +
  "  @location(7) color: vec4<f32>,\n" +
  "  @location(8) emissive: vec3<f32>,\n" +
  "  @location(9) tangent: vec4<f32>,\n" +
  "  @location(10) material: vec4<f32>,\n" +
  "  @location(11) surface: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  o.pos = u_camera.view_proj * vec4<f32>(v.pos, 1.0);\n" +
  "  o.world_pos = v.pos;\n" +
  "  o.normal = normalize(v.normal);\n" +
  "  o.base_uv = v.base_uv;\n" +
  "  o.emissive_uv = v.emissive_uv;\n" +
  "  o.metallic_roughness_uv = v.metallic_roughness_uv;\n" +
  "  o.occlusion_uv = v.occlusion_uv;\n" +
  "  o.normal_uv = v.normal_uv;\n" +
  "  o.color = v.color;\n" +
  "  o.emissive = v.emissive;\n" +
  "  o.tangent = v.tangent;\n" +
  "  o.material = v.material;\n" +
  "  o.surface = v.surface;\n" +
  "  return o;\n" +
  "}\n" +
  webgpu_shader_shadow_sampling_source() +
  "fn apply_lighting(world_pos: vec3<f32>, shading_normal: vec3<f32>, geometric_normal: vec3<f32>, view_dir: vec3<f32>, roughness: f32, metallic: f32, receive_shadows: bool) -> vec3<f32> {\n" +
  "  let n = normalize(shading_normal);\n" +
  "  var lit = u_light.ambient_directional_count.xyz;\n" +
  "  var specular = vec3<f32>(0.0);\n" +
  "  let shininess = mix(96.0, 8.0, clamp(roughness, 0.0, 1.0));\n" +
  "  let specular_strength = mix(0.04, 1.0, clamp(metallic, 0.0, 1.0));\n" +
  "  let directional_count = clamp(i32(round(u_light.ambient_directional_count.w)), 0, 4);\n" +
  "  for (var idx = 0; idx < 4; idx = idx + 1) {\n" +
  "    if (idx >= directional_count) { continue; }\n" +
  "    let base = idx * 2;\n" +
  "    let direction_intensity = u_light.directional_data[base];\n" +
  "    let color_data = u_light.directional_data[base + 1];\n" +
  "    let light_dir = normalize(-direction_intensity.xyz);\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let shadow = sample_directional_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);\n" +
  "    lit = lit + color_data.xyz * direction_intensity.w * lambert * shadow;\n" +
  "    if (lambert > 0.0) {\n" +
  "      let halfway = safe_normalize(light_dir + view_dir, view_dir);\n" +
  "      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;\n" +
  "      specular = specular + color_data.xyz * direction_intensity.w * spec * shadow;\n" +
  "    }\n" +
  "  }\n" +
  "  let point_count = clamp(i32(round(u_light.point_spot_count.x)), 0, 8);\n" +
  "  for (var idx = 0; idx < 8; idx = idx + 1) {\n" +
  "    if (idx >= point_count) { continue; }\n" +
  "    let base = idx * 2;\n" +
  "    let position_intensity = u_light.point_data[base];\n" +
  "    let color_range = u_light.point_data[base + 1];\n" +
  "    let offset = position_intensity.xyz - world_pos;\n" +
  "    let distance = length(offset);\n" +
  "    if (distance <= 0.0001) { continue; }\n" +
  "    let light_dir = offset / distance;\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let shadow = sample_point_shadow(idx, world_pos, geometric_normal, light_dir, world_pos - position_intensity.xyz, receive_shadows);\n" +
  "    let attenuation = point_light_attenuation(distance, color_range.w) * shadow;\n" +
  "    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;\n" +
  "    if (lambert > 0.0 && attenuation > 0.0) {\n" +
  "      let halfway = safe_normalize(light_dir + view_dir, view_dir);\n" +
  "      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;\n" +
  "      specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;\n" +
  "    }\n" +
  "  }\n" +
  "  let spot_count = clamp(i32(round(u_light.point_spot_count.y)), 0, 4);\n" +
  "  for (var idx = 0; idx < 4; idx = idx + 1) {\n" +
  "    if (idx >= spot_count) { continue; }\n" +
  "    let base = idx * 4;\n" +
  "    let position_intensity = u_light.spot_data[base];\n" +
  "    let color_range = u_light.spot_data[base + 1];\n" +
  "    let direction_inner = u_light.spot_data[base + 2];\n" +
  "    let outer_cos = u_light.spot_data[base + 3].x;\n" +
  "    let offset = position_intensity.xyz - world_pos;\n" +
  "    let distance = length(offset);\n" +
  "    if (distance <= 0.0001) { continue; }\n" +
  "    let light_dir = offset / distance;\n" +
  "    let to_fragment = -light_dir;\n" +
  "    let spot_direction = normalize(direction_inner.xyz);\n" +
  "    let spot_cos = dot(spot_direction, to_fragment);\n" +
  "    let inner_cos = direction_inner.w;\n" +
  "    let spot_denom = max(inner_cos - outer_cos, 0.0001);\n" +
  "    let spot_factor = saturate((spot_cos - outer_cos) / spot_denom);\n" +
  "    if (spot_factor <= 0.0) { continue; }\n" +
  "    let lambert = max(dot(n, light_dir), 0.0);\n" +
  "    let shadow = sample_spot_shadow(idx, world_pos, geometric_normal, light_dir, receive_shadows);\n" +
  "    let attenuation = point_light_attenuation(distance, color_range.w) * spot_factor * shadow;\n" +
  "    lit = lit + color_range.xyz * position_intensity.w * lambert * attenuation;\n" +
  "    if (lambert > 0.0 && attenuation > 0.0) {\n" +
  "      let halfway = safe_normalize(light_dir + view_dir, view_dir);\n" +
  "      let spec = pow(max(dot(n, halfway), 0.0), shininess) * specular_strength;\n" +
  "      specular = specular + color_range.xyz * position_intensity.w * spec * attenuation;\n" +
  "    }\n" +
  "  }\n" +
  "  return lit + specular;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {\n" +
  "  var albedo = textureSample(u_texture, u_base_sampler, v.base_uv) * v.color;\n" +
  "  let emissive_sample = textureSample(u_emissive_texture, u_emissive_sampler, v.emissive_uv).rgb;\n" +
  "  let mr_sample = textureSample(u_metallic_roughness_texture, u_metallic_roughness_sampler, v.metallic_roughness_uv);\n" +
  "  let occlusion_sample = textureSample(u_occlusion_texture, u_occlusion_sampler, v.occlusion_uv);\n" +
  "  let normal_sample = textureSample(u_normal_texture, u_normal_sampler, v.normal_uv).xyz * 2.0 - vec3<f32>(1.0, 1.0, 1.0);\n" +
  "  let alpha_mode = i32(round(v.material.x));\n" +
  "  let alpha_cutoff = v.material.y;\n" +
  "  let unlit = v.surface.z >= 0.5;\n" +
  "  let receive_shadows = v.surface.w >= 0.5;\n" +
  "  if (alpha_mode == 0) {\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (alpha_mode == 1) {\n" +
  "    if (albedo.a < alpha_cutoff) { discard; }\n" +
  "    albedo.a = 1.0;\n" +
  "  } else if (albedo.a <= 0.0001) {\n" +
  "    discard;\n" +
  "  }\n" +
  "  if (unlit) { return albedo; }\n" +
  "  let tangent = safe_normalize(v.tangent.xyz - v.normal * dot(v.tangent.xyz, v.normal), vec3<f32>(1.0, 0.0, 0.0));\n" +
  "  let bitangent = safe_normalize(cross(v.normal, tangent) * v.tangent.w, vec3<f32>(0.0, 1.0, 0.0));\n" +
  "  let tangent_normal = normalize(vec3<f32>(normal_sample.xy * v.surface.y, normal_sample.z));\n" +
  "  let geometric_normal = normalize(v.normal);\n" +
  "  let mapped_normal = safe_normalize(\n" +
  "    tangent * tangent_normal.x + bitangent * tangent_normal.y + v.normal * tangent_normal.z,\n" +
  "    geometric_normal,\n" +
  "  );\n" +
  "  let metallic = clamp(v.material.z * mr_sample.b, 0.0, 1.0);\n" +
  "  let roughness = clamp(v.material.w * mr_sample.g, 0.0, 1.0);\n" +
  "  let view_dir = safe_normalize(u_light.view_position.xyz - v.world_pos, vec3<f32>(0.0, 0.0, 1.0));\n" +
  "  let lit = apply_lighting(v.world_pos, mapped_normal, geometric_normal, view_dir, roughness, metallic, receive_shadows);\n" +
  "  let occlusion = mix(1.0, occlusion_sample.r, clamp(v.surface.x, 0.0, 1.0));\n" +
  "  let emissive = emissive_sample * v.emissive;\n" +
  "  return vec4<f32>(albedo.rgb * lit * occlusion + emissive, albedo.a);\n" +
  "}\n"
}

///|
fn webgpu_shader2d_texture_source() -> String {
  "struct CanvasUniform { size: vec2<f32>, _pad: vec2<f32> };\n" +
  "@group(0) @binding(0) var<uniform> u_canvas: CanvasUniform;\n" +
  "@group(0) @binding(1) var u_sampler: sampler;\n" +
  "@group(0) @binding(2) var u_texture: texture_2d<f32>;\n" +
  "struct VSIn {\n" +
  "  @location(0) pos: vec2<f32>,\n" +
  "  @location(1) uv: vec2<f32>,\n" +
  "  @location(2) color: vec4<f32>,\n" +
  "};\n" +
  "struct VSOut {\n" +
  "  @builtin(position) pos: vec4<f32>,\n" +
  "  @location(0) uv: vec2<f32>,\n" +
  "  @location(1) color: vec4<f32>,\n" +
  "};\n" +
  "@vertex fn vs_main(v: VSIn) -> VSOut {\n" +
  "  var o: VSOut;\n" +
  "  let nx = (v.pos.x / u_canvas.size.x) * 2.0 - 1.0;\n" +
  "  let ny = 1.0 - (v.pos.y / u_canvas.size.y) * 2.0;\n" +
  "  o.pos = vec4<f32>(nx, ny, 0.0, 1.0);\n" +
  "  o.uv = v.uv;\n" +
  "  o.color = v.color;\n" +
  "  return o;\n" +
  "}\n" +
  "@fragment fn fs_main(v: VSOut) -> @location(0) vec4<f32> {\n" +
  "  return textureSample(u_texture, u_sampler, v.uv) * v.color;\n" +
  "}\n"
}
