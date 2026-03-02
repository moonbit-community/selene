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
  let resolved_png = resolve_asset_path(png)
  if element_cache.get(resolved_png) is Some(element) {
    return element
  }
  let element = @dom.HTMLImageElement::new()
  element.set_src(resolved_png)
  element_cache.set(resolved_png, element)
  return element
}

///|
pub fn preload_img(path : String) -> Unit {
  get_image_element(path) |> ignore
}

///|
fn repeat_mode_to_css(repeat : @smath.RepeatMode) -> String {
  match repeat {
    NoRepeat => "no-repeat"
    RepeatY => "repeat-y"
    RepeatX => "repeat-x"
    Repeat => "repeat"
  }
}

///|
fn color_to_css(color : @render.Color) -> String {
  "rgba(\{color.r.reinterpret_as_int()}, \{color.g.reinterpret_as_int()}, \{color.b.reinterpret_as_int()}, \{color.a})"
}

///|
fn text_align_to_css(align : @smath.HAlign) -> String {
  match align {
    Left => "left"
    Center => "center"
    Right => "right"
  }
}

///|
fn text_baseline_to_css(baseline : @smath.VAlign) -> String {
  match baseline {
    Top => "top"
    Center => "center"
    Bottom => "bottom"
  }
}

///|
fn text_style_to_css(style : @render.TextStyle) -> String {
  "\{style.size}px \{style.family}"
}

///|
pub fn draw_image(command : @render.ImageDrawCommand) -> Unit {
  let element = get_image_element(command.path)
  let x = command.destination.position[X]
  let y = command.destination.position[Y]
  let width = command.destination.size[X]
  let height = command.destination.size[Y]
  let context = canvas_backend.context
  context.save()
  context.translate(x, y)
  let transform = command.transform
  context.transform(
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
  )
  match command.source {
    Some(source) =>
      context.draw_image_with_src_and_dst_size(
        element |> @js.Value::cast_from |> @js.Value::cast,
        source.position[X],
        source.position[Y],
        source.size[X],
        source.size[Y],
        0,
        0,
        width,
        height,
      )
    None => {
      let pattern = context.create_pattern(
        @js.Union7::from0(element),
        repeat_mode_to_css(command.repeat),
      )
      context.set_fill_style(@js.Union3::from2(pattern))
      context.fill_rect(0, 0, width, height)
    }
  }
  context.restore()
}

///|
pub fn draw_text(command : @render.TextDrawCommand) -> Unit {
  let context = canvas_backend.context
  context.save()
  context.set_font(text_style_to_css(command.style))
  set_text_align(context, text_align_to_css(command.style.align))
  set_text_baseline(context, text_baseline_to_css(command.style.baseline))
  context.set_fill_style(@js.Union3::from0(color_to_css(command.style.color)))
  context.fill_text(command.text, command.position[X], command.position[Y])
  context.restore()
}

///|
pub fn draw_rect(command : @render.RectDrawCommand) -> Unit {
  let x = command.rect.position[X]
  let y = command.rect.position[Y]
  let width = command.rect.size[X]
  let height = command.rect.size[Y]
  let context = canvas_backend.context
  context.save()
  if command.stroke_color is Some(stroke_color) {
    context.set_stroke_style(@js.Union3::from0(color_to_css(stroke_color)))
    context.stroke_rect(x, y, width, height)
  }
  context.set_fill_style(@js.Union3::from0(color_to_css(command.fill_color)))
  context.fill_rect(x, y, width, height)
  context.restore()
}

///|
pub fn draw_circle(command : @render.CircleDrawCommand) -> Unit {
  let context = canvas_backend.context
  context.save()
  begin_path(context)
  context.arc(
    command.center[X],
    command.center[Y],
    command.radius,
    0,
    @math.PI * 2,
  )
  context.set_fill_style(@js.Union3::from0(color_to_css(command.fill_color)))
  context.fill()
  if command.stroke_color is Some(stroke_color) {
    context.set_stroke_style(@js.Union3::from0(color_to_css(stroke_color)))
    context.stroke()
  }
  context.restore()
}

///|
pub fn draw_gradient_rect(command : @render.GradientRectDrawCommand) -> Unit {
  let x = command.rect.position[X]
  let y = command.rect.position[Y]
  let width = command.rect.size[X]
  let height = command.rect.size[Y]
  let context = canvas_backend.context
  context.save()
  let gradient = context.create_linear_gradient(x, y, x + width, y + height)
  gradient.add_color_stop(0.0, color_to_css(command.color_start))
  gradient.add_color_stop(1.0, color_to_css(command.color_end))
  context.set_fill_style(@js.Union3::from1(gradient))
  context.fill_rect(x, y, width, height)
  context.restore()
}
