// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
fn repeat_mode_to_code(repeat : @smath.RepeatMode) -> Int {
  match repeat {
    RepeatX => 0
    RepeatY => 1
    NoRepeat => 2
    Repeat => 3
  }
}

///|
fn h_align_to_code(align : @smath.HAlign) -> Int {
  match align {
    Left => 0
    Center => 1
    Right => 2
  }
}

///|
fn v_align_to_code(align : @smath.VAlign) -> Int {
  match align {
    Top => 0
    Center => 1
    Bottom => 2
  }
}

///|
fn color_rgba(color : @render.Color) -> (Double, Double, Double, Double) {
  (
    color.r.reinterpret_as_int().to_double(),
    color.g.reinterpret_as_int().to_double(),
    color.b.reinterpret_as_int().to_double(),
    color.a,
  )
}

///|
pub fn preload_img(path : String) -> Unit {
  webgpu_preload_img(resolve_asset_path(path))
}

///|
pub fn draw_image(command : @render.ImageDrawCommand) -> Unit {
  let transform = command.transform
  let mut source_x = 0.0
  let mut source_y = 0.0
  let mut source_width = 0.0
  let mut source_height = 0.0
  let mut has_source = false
  match command.source {
    Some(source) => {
      source_x = source.position[X]
      source_y = source.position[Y]
      source_width = source.size[X]
      source_height = source.size[Y]
      has_source = true
    }
    None => ()
  }
  webgpu_draw_image(
    resolve_asset_path(command.path),
    command.destination.position[X],
    command.destination.position[Y],
    command.destination.size[X],
    command.destination.size[Y],
    has_source,
    source_x,
    source_y,
    source_width,
    source_height,
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
    repeat_mode_to_code(command.repeat),
  )
}

///|
pub fn draw_text(command : @render.TextDrawCommand) -> Unit {
  if draw_text_with_cosmic(command) {
    return
  }
  let (r, g, b, a) = color_rgba(command.style.color)
  webgpu_draw_text(
    command.text,
    command.position[X],
    command.position[Y],
    command.style.family,
    command.style.size,
    h_align_to_code(command.style.align),
    v_align_to_code(command.style.baseline),
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_rect(command : @render.RectDrawCommand) -> Unit {
  let (fr, fg, fb, fa) = color_rgba(command.fill_color)
  let mut has_stroke = false
  let mut sr = 0.0
  let mut sg = 0.0
  let mut sb = 0.0
  let mut sa = 1.0
  match command.stroke_color {
    Some(stroke_color) => {
      has_stroke = true
      let (tr, tg, tb, ta) = color_rgba(stroke_color)
      sr = tr
      sg = tg
      sb = tb
      sa = ta
    }
    None => ()
  }
  webgpu_draw_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
    fr,
    fg,
    fb,
    fa,
    has_stroke,
    sr,
    sg,
    sb,
    sa,
  )
}

///|
pub fn draw_circle(command : @render.CircleDrawCommand) -> Unit {
  let (fr, fg, fb, fa) = color_rgba(command.fill_color)
  let mut has_stroke = false
  let mut sr = 0.0
  let mut sg = 0.0
  let mut sb = 0.0
  let mut sa = 1.0
  match command.stroke_color {
    Some(stroke_color) => {
      has_stroke = true
      let (tr, tg, tb, ta) = color_rgba(stroke_color)
      sr = tr
      sg = tg
      sb = tb
      sa = ta
    }
    None => ()
  }
  webgpu_draw_circle(
    command.center[X],
    command.center[Y],
    command.radius,
    fr,
    fg,
    fb,
    fa,
    has_stroke,
    sr,
    sg,
    sb,
    sa,
  )
}

///|
pub fn draw_gradient_rect(command : @render.GradientRectDrawCommand) -> Unit {
  let (sr, sg, sb, sa) = color_rgba(command.color_start)
  let (er, eg, eb, ea) = color_rgba(command.color_end)
  webgpu_draw_gradient_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
    sr,
    sg,
    sb,
    sa,
    er,
    eg,
    eb,
    ea,
  )
}

///|
pub fn begin_3d(camera : @render.Camera3D) -> Unit {
  webgpu_begin_3d(
    camera.position.x,
    camera.position.y,
    camera.position.z,
    camera.target.x,
    camera.target.y,
    camera.target.z,
    camera.up.x,
    camera.up.y,
    camera.up.z,
    camera.fovy,
  )
}

///|
pub fn end_3d() -> Unit {
  webgpu_end_3d()
}

///|
pub fn draw_cube_3d(command : @render.CubeDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cube_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.size.x,
    command.size.y,
    command.size.z,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_cube_wires_3d(command : @render.CubeDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cube_wires_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.size.x,
    command.size.y,
    command.size.z,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_sphere_3d(command : @render.SphereDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_sphere_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.radius,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_cylinder_3d(command : @render.CylinderDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cylinder_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.radius_top,
    command.radius_bottom,
    command.height,
    command.slices,
    r,
    g,
    b,
    a,
  )
}
