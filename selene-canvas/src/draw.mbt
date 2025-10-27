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
let element_cache : Map[String, @dom.HTMLImageElement] = Map::new()

///|
fn get_image_element(png : String) -> @dom.HTMLImageElement {
  if element_cache.get(png) is Some(element) {
    return element
  }
  let element = @dom.HTMLImageElement::new()
  element.set_src(png)
  element_cache.set(png, element)
  return element
}

///|
pub fn preload_img(path : String) -> Unit {
  get_image_element(path) |> ignore
}

///|
pub fn draw_picture(
  png~ : String,
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  transform~ : @smath.Transform,
  repeat~ : @smath.RepeatMode,
) -> Unit {
  let element = get_image_element(png)
  let repeat_mode = match repeat {
    NoRepeat => "no-repeat"
    RepeatY => "repeat-y"
    RepeatX => "repeat-x"
    Repeat => "repeat"
  }
  let context = canvas_backend.context
  let pattern = context.create_pattern(@js.Union7::from0(element), repeat_mode)
  context.save()
  context.set_fill_style(@js.Union3::from2(pattern))
  context.translate(x, y)
  context.transform(
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
  )
  context.fill_rect(0, 0, width, height)
  context.restore()
}

///|
pub fn draw_sprite(
  sprite_path~ : String,
  x~ : Double,
  y~ : Double,
  offset_x~ : Double,
  offset_y~ : Double,
  width~ : Double,
  height~ : Double,
  transform~ : @smath.Transform,
) -> Unit {
  let context = canvas_backend.context
  context.save()
  context.translate(x, y)
  context.transform(
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
  )
  let element = get_image_element(sprite_path)
  context.draw_image_with_src_and_dst_size(
    element |> @js.Value::cast_from |> @js.Value::cast,
    offset_x,
    offset_y,
    width,
    height,
    0,
    0,
    width,
    height,
  )
  context.restore()
}

///|
pub fn draw_text(
  text~ : String,
  x~ : Double,
  y~ : Double,
  font~ : String,
  color~ : String,
  align~ : @smath.HAlign,
  baseline~ : @smath.VAlign,
) -> Unit {
  let context = canvas_backend.context
  context.save()
  context.set_font(font)
  let align = match align {
    Left => "left"
    Center => "center"
    Right => "right"
  }
  set_text_align(context, align)
  let baseline = match baseline {
    Top => "top"
    Center => "center"
    Bottom => "bottom"
  }
  set_text_baseline(context, baseline)
  context.set_fill_style(@js.Union3::from0(color))
  context.fill_text(text, x, y)
  context.restore()
}

///|
pub fn draw_color_rect(
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color~ : String,
  stroke_color~ : String,
) -> Unit {
  let context = canvas_backend.context
  context.save()
  context.set_stroke_style(@js.Union3::from0(stroke_color))
  context.stroke_rect(x, y, width, height)
  context.set_fill_style(@js.Union3::from0(color))
  context.fill_rect(x, y, width, height)
  context.restore()
}

///|
pub fn draw_color_circle(
  x~ : Double,
  y~ : Double,
  radius~ : Double,
  color~ : String,
  stroke_color~ : String,
) -> Unit {
  let context = canvas_backend.context
  begin_path(context)
  context.arc(x, y, radius, 0, @math.PI * 2)
  context.set_fill_style(@js.Union3::from0(color))
  context.fill()
  context.set_stroke_style(@js.Union3::from0(stroke_color))
  context.stroke()
  context.restore()
}

///|
pub fn draw_gradient_rect(
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  color_start~ : String,
  color_end~ : String,
) -> Unit {
  let context = canvas_backend.context
  context.save()
  let gradient = context.create_linear_gradient(x, y, x + width, y + height)
  gradient.add_color_stop(0.0, color_start)
  gradient.add_color_stop(1.0, color_end)
  context.set_fill_style(@js.Union3::from1(gradient))
  context.fill_rect(x, y, width, height)
  context.restore()
}
