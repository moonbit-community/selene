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
/// The `Rect` struct represents a rectangle defined by its position and size.
pub(all) struct Rect {
  position : Vec2D
  size : Vec2D
}

///| 
/// Check if two rectangles intersect
pub fn Rect::intersects(a : Rect, b : Rect) -> Bool {
  a.position[X] < b.position[X] + b.size[X] &&
  a.position[X] + a.size[X] > b.position[X] &&
  a.position[Y] < b.position[Y] + b.size[Y] &&
  a.position[Y] + a.size[Y] > b.position[Y]
}

///|
/// Shift the rectangle by a given vector.
pub fn Rect::shift(self : Rect, dir : Vec2D) -> Rect {
  { position: self.position + dir, size: self.size }
}
