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
pub(all) struct Rect {
  position : Vec2D
  size : Vec2D
}

///| Check if two rectangles intersect
pub fn Rect::intersects(a : Rect, b : Rect) -> Bool {
  a.position.x < b.position.x + b.size.x &&
  a.position.x + a.size.x > b.position.x &&
  a.position.y < b.position.y + b.size.y &&
  a.position.y + a.size.y > b.position.y
}

///|
pub fn Rect::shift(self : Rect, dir : Vec2D) -> Rect {
  { position: self.position + dir, size: self.size }
}
