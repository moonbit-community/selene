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
fn transform_image_point(
  base_x : Double,
  base_y : Double,
  transform : @smath.Transform,
  x : Double,
  y : Double,
) -> (Float, Float) {
  let world_x = base_x + transform.a * x + transform.c * y + transform.tx
  let world_y = base_y + transform.b * x + transform.d * y + transform.ty
  (to_float(world_x), to_float(world_y))
}

///|
fn can_use_texture_pro_path(transform : @smath.Transform) -> Bool {
  transform.b.abs() < 0.000001 && transform.c.abs() < 0.000001
}

///|
fn draw_axis_aligned_textured_quad(
  texture : @raylib.Texture,
  src_x0 : Double,
  src_y0 : Double,
  src_x1 : Double,
  src_y1 : Double,
  local_x0 : Double,
  local_y0 : Double,
  local_x1 : Double,
  local_y1 : Double,
  base_x : Double,
  base_y : Double,
  transform : @smath.Transform,
) -> Unit {
  let sx = transform.a
  let sy = transform.d
  if sx.abs() < 0.000001 || sy.abs() < 0.000001 {
    return
  }
  let x0 = base_x + transform.tx + sx * local_x0
  let y0 = base_y + transform.ty + sy * local_y0
  let x1 = base_x + transform.tx + sx * local_x1
  let y1 = base_y + transform.ty + sy * local_y1
  let dest_x = @cmp.minimum(x0, x1)
  let dest_y = @cmp.minimum(y0, y1)
  let dest_w = (x1 - x0).abs()
  let dest_h = (y1 - y0).abs()
  if dest_w <= 0.0 || dest_h <= 0.0 {
    return
  }
  let src_w = src_x1 - src_x0
  let src_h = src_y1 - src_y0
  // DrawTexturePro expects source.x to stay at the original left edge even when
  // source.width is negative (it applies horizontal flip internally).
  let src_x = src_x0
  let src_y = if sy >= 0.0 { src_y0 } else { src_y1 }
  let draw_src_w = if sx >= 0.0 { src_w } else { -src_w }
  let draw_src_h = if sy >= 0.0 { src_h } else { -src_h }
  @raylib.draw_texture_pro(
    texture,
    to_ray_rect(src_x, src_y, draw_src_w, draw_src_h),
    to_ray_rect(dest_x, dest_y, dest_w, dest_h),
    to_ray_vector2(0.0, 0.0),
    0.0,
    @raylib.white,
  )
}

///|
fn draw_affine_textured_quad(
  texture : @raylib.Texture,
  texture_width : Double,
  texture_height : Double,
  src_x0 : Double,
  src_y0 : Double,
  src_x1 : Double,
  src_y1 : Double,
  local_x0 : Double,
  local_y0 : Double,
  local_x1 : Double,
  local_y1 : Double,
  base_x : Double,
  base_y : Double,
  transform : @smath.Transform,
) -> Unit {
  if src_x1 <= src_x0 ||
    src_y1 <= src_y0 ||
    local_x1 <= local_x0 ||
    local_y1 <= local_y0 {
    return
  }
  let u0 = to_float(src_x0 / texture_width)
  let v0 = to_float(src_y0 / texture_height)
  let u1 = to_float(src_x1 / texture_width)
  let v1 = to_float(src_y1 / texture_height)
  let p00 = transform_image_point(base_x, base_y, transform, local_x0, local_y0)
  let p10 = transform_image_point(base_x, base_y, transform, local_x1, local_y0)
  let p11 = transform_image_point(base_x, base_y, transform, local_x1, local_y1)
  let p01 = transform_image_point(base_x, base_y, transform, local_x0, local_y1)
  ignore(@raylib.rl_check_render_batch_limit(4))
  @raylib.rl_set_texture(@raylib.get_texture_id(texture).reinterpret_as_uint())
  @raylib.rl_begin(@raylib.RlQuads)
  @raylib.rl_color4ub(b'\xFF', b'\xFF', b'\xFF', b'\xFF')
  @raylib.rl_normal3f(0.0, 0.0, 1.0)
  @raylib.rl_tex_coord2f(u0, v0)
  @raylib.rl_vertex2f(p00.0, p00.1)
  @raylib.rl_tex_coord2f(u0, v1)
  @raylib.rl_vertex2f(p01.0, p01.1)
  @raylib.rl_tex_coord2f(u1, v1)
  @raylib.rl_vertex2f(p11.0, p11.1)
  @raylib.rl_tex_coord2f(u1, v0)
  @raylib.rl_vertex2f(p10.0, p10.1)
  @raylib.rl_end()
  @raylib.rl_set_texture(0U)
}

///|
fn draw_textured_quad(
  texture : @raylib.Texture,
  texture_width : Double,
  texture_height : Double,
  src_x0 : Double,
  src_y0 : Double,
  src_x1 : Double,
  src_y1 : Double,
  local_x0 : Double,
  local_y0 : Double,
  local_x1 : Double,
  local_y1 : Double,
  base_x : Double,
  base_y : Double,
  transform : @smath.Transform,
) -> Unit {
  if can_use_texture_pro_path(transform) {
    draw_axis_aligned_textured_quad(
      texture, src_x0, src_y0, src_x1, src_y1, local_x0, local_y0, local_x1, local_y1,
      base_x, base_y, transform,
    )
    return
  }
  draw_affine_textured_quad(
    texture, texture_width, texture_height, src_x0, src_y0, src_x1, src_y1, local_x0,
    local_y0, local_x1, local_y1, base_x, base_y, transform,
  )
}

///|
fn draw_image_repeat_transform(
  texture : @raylib.Texture,
  command : @render.ImageDrawCommand,
) -> Unit {
  let texture_width = @raylib.get_texture_width(texture).to_double()
  let texture_height = @raylib.get_texture_height(texture).to_double()
  if texture_width <= 0.0 || texture_height <= 0.0 {
    return
  }
  let (src_x, src_y, src_w, src_h, has_source) = match command.source {
    Some(source) =>
      (
        source.position[X],
        source.position[Y],
        source.size[X],
        source.size[Y],
        true,
      )
    None => (0.0, 0.0, texture_width, texture_height, false)
  }
  let dest_w = command.destination.size[X]
  let dest_h = command.destination.size[Y]
  if src_w <= 0.0 || src_h <= 0.0 || dest_w <= 0.0 || dest_h <= 0.0 {
    return
  }
  let base_x = command.destination.position[X]
  let base_y = command.destination.position[Y]
  if has_source && command.repeat is NoRepeat {
    draw_textured_quad(
      texture,
      texture_width,
      texture_height,
      src_x,
      src_y,
      src_x + src_w,
      src_y + src_h,
      0.0,
      0.0,
      dest_w,
      dest_h,
      base_x,
      base_y,
      command.transform,
    )
    return
  }
  let tile_w = src_w
  let tile_h = src_h
  let repeat_x = command.repeat is Repeat || command.repeat is RepeatX
  let repeat_y = command.repeat is Repeat || command.repeat is RepeatY
  let span_x = if repeat_x { dest_w } else { @cmp.minimum(dest_w, tile_w) }
  let span_y = if repeat_y { dest_h } else { @cmp.minimum(dest_h, tile_h) }
  let mut ox = 0.0
  while ox < span_x {
    let mut oy = 0.0
    while oy < span_y {
      let x0 = ox
      let y0 = oy
      let x1 = @cmp.minimum(ox + tile_w, span_x)
      let y1 = @cmp.minimum(oy + tile_h, span_y)
      let local_w = x1 - x0
      let local_h = y1 - y0
      draw_textured_quad(
        texture,
        texture_width,
        texture_height,
        src_x,
        src_y,
        src_x + local_w,
        src_y + local_h,
        x0,
        y0,
        x1,
        y1,
        base_x,
        base_y,
        command.transform,
      )
      oy += tile_h
    }
    ox += tile_w
  }
}
