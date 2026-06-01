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
