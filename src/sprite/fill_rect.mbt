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
pub(all) struct FillRect {
  size : @math.Vec2D
  tile_path : String
}

///|
pub let fill_rects : Map[@system.Entity, FillRect] = Map::new()

///|
pub fn render_fill_rect(backend : &@system.Backend) -> Unit {
  for e, fill_rect in fill_rects {
    guard @position.positions.get(e) is Some(pos) else { continue }
    backend.draw_picture(
      fill_rect.tile_path,
      pos.x,
      pos.y,
      fill_rect.size.x,
      fill_rect.size.y,
      true,
    )
  }
}
