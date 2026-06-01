///|
fn webgpu_shader_sources() -> Array[String] {
  [
    webgpu_shader2d_color_source(),
    webgpu_shader2d_texture_source(),
    webgpu_shader3d_color_source(),
    webgpu_shader3d_shadow_solid_source(),
    webgpu_shader3d_shadow_lit_source(),
    webgpu_shader3d_shadow_texture_source(),
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
