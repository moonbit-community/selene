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
pub(all) struct ColorRect {
  size : @math.Vec2D
  color : String
}

///|
pub fn ColorRect::new(size : @math.Vec2D, color : String) -> ColorRect {
  { size, color }
}

///|
fn render_color_rect(
  backend : &@system.Backend,
  color_rect : ColorRect,
  position : @math.Vec2D,
) -> Unit {
  backend.draw_color_rect(
    x=position[X],
    y=position[Y],
    width=color_rect.size[X],
    height=color_rect.size[Y],
    color=color_rect.color,
  )
}
