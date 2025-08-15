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
pub fn debug_collide_system(backend : &@system.Backend) -> Unit {
  for e, collide in collides {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard collide.shape is Rect(size=Vec2D(width, height), offset~)
    backend.draw_color_rect(
      x=pos.inner()[X] + offset[X],
      y=pos.inner()[Y] + offset[Y],
      width~,
      height~,
      color="rgba(255, 0, 0, 0.5)",
    )
  }
  for e, area in areas {
    guard e.is_alive() else { continue }
    guard @position.positions.get(e) is Some(pos)
    guard area.shape is Rect(size=Vec2D(width, height), offset~)
    backend.draw_color_rect(
      x=pos.inner()[X] + offset[X],
      y=pos.inner()[Y] + offset[Y],
      width~,
      height~,
      color="rgba(0, 0, 255, 0.5)",
    )
  }
}
