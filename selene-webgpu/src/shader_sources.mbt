///|
fn webgpu_shader_sources() -> Array[String] {
  [
    webgpu_shader2d_color_source(),
    webgpu_shader2d_texture_source(),
    webgpu_shader3d_color_source(),
    webgpu_shader3d_shadow_solid_source(),
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
