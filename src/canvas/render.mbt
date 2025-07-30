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
pub impl @selene.Backend for CanvasBackend with render_picture(
  self,
  png,
  x,
  y,
  width,
  height,
  repeat,
) {
  let element = @dom.HTMLImageElement::new()
  element.set_src(png)
  let repeat_mode = if repeat { "repeat" } else { "no-repeat" }
  let pattern = self.context.create_pattern(@js.Union7::from0(element), repeat_mode)
  self.context.save()
  self.context.set_fill_style(@js.Union3::from2(pattern))
  self.context.fill_rect(x, y, width, height)
  self.context.restore()
}
