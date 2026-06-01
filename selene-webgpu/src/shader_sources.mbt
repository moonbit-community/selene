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
