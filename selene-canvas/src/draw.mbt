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
pub impl @system.Backend for CanvasBackend with preload_img(
  _self,
  path : String,
) -> Unit {
  get_image_element(path) |> ignore
}

///|
pub impl @system.Backend for CanvasBackend with draw_picture(
  self,
  png,
  x~,
  y~,
  width~,
  height~,
  transform~,
  repeat~,
) {
  let element = get_image_element(png)
  let repeat_mode = match repeat {
    NoRepeat => "no-repeat"
    RepeatY => "repeat-y"
    RepeatX => "repeat-x"
    Repeat => "repeat"
  }
  let pattern = self.context.create_pattern(
    @js.Union7::from0(element),
    repeat_mode,
  )
  self.context.save()
  set_image_smoothing_enabled(self.context, self.image_smooth)
  self.context.set_fill_style(@js.Union3::from2(pattern))
  self.context.translate(x, y)
  self.context.transform(
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
  )
  self.context.fill_rect(0, 0, width, height)
  self.context.restore()
}

///|
pub impl @system.Backend for CanvasBackend with draw_sprite(
  self,
  sprite_path,
  x~,
  y~,
  offset_x~,
  offset_y~,
  width~,
  height~,
  transform~,
) {
  self.context.save()
  set_image_smoothing_enabled(self.context, self.image_smooth)
  self.context.translate(x, y)
  self.context.transform(
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
  )
  let element = get_image_element(sprite_path)
  self.context.draw_image_with_src_and_dst_size(
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
  self.context.restore()
}

///|
pub impl @system.Backend for CanvasBackend with draw_stroke_rect(
  self,
  x~,
  y~,
  width~,
  height~,
  color~,
) {
  self.context.save()
  self.context.set_stroke_style(@js.Union3::from0(color))
  self.context.stroke_rect(x, y, width, height)
  self.context.restore()
}

///|
pub impl @system.Backend for CanvasBackend with draw_text(
  self,
  text,
  x~,
  y~,
  font~,
  color~,
) {
  self.context.save()
  self.context.set_font(font)
  self.context.set_fill_style(@js.Union3::from0(color))
  self.context.fill_text(text, x, y)
  self.context.restore()
}

///|
pub impl @system.Backend for CanvasBackend with draw_color_rect(
  self,
  x~,
  y~,
  width~,
  height~,
  color~,
) {
  self.context.save()
  self.context.set_fill_style(@js.Union3::from0(color))
  self.context.fill_rect(x, y, width, height)
  self.context.restore()
}

///|
pub impl @system.Backend for CanvasBackend with draw_gradient_rect(
  self,
  x~,
  y~,
  width~,
  height~,
  color_start~,
  color_end~,
) {
  self.context.save()
  let gradient = self.context.create_linear_gradient(
    x,
    y,
    x + width,
    y + height,
  )
  gradient.add_color_stop(0.0, color_start)
  gradient.add_color_stop(1.0, color_end)
  self.context.set_fill_style(@js.Union3::from1(gradient))
  self.context.fill_rect(x, y, width, height)
  self.context.restore()
}
