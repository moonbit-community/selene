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
  pos : Vec2D
  width : Double
  height : Double
  tile_path : String
}

///|
let fill_rects : Map[Entity, FillRect] = Map::new()

///|
pub impl Component for FillRect with get(entity) {
  fill_rects.get(entity)
}

///|
pub impl Component for FillRect with set(entity, fill_rect) {
  fill_rects.set(entity, fill_rect)
}

pub fn render_fill_rect(backend : &Backend) -> Unit {
  for _e, fill_rect in fill_rects {
    backend.render_picture(fill_rect.tile_path, fill_rect.pos.x, fill_rect.pos.y, fill_rect.width, fill_rect.height, true)
  }
}