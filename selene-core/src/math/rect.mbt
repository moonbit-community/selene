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
/// 
pub(all) struct Rect {
  position : Vec2D
  size : Vec2D
}

///|
/// Check if two rectangles intersect
/// 
pub fn Rect::intersects(a : Rect, b : Rect) -> Bool {
  a.position[X] < b.position[X] + b.size[X] &&
  a.position[X] + a.size[X] > b.position[X] &&
  a.position[Y] < b.position[Y] + b.size[Y] &&
  a.position[Y] + a.size[Y] > b.position[Y]
}

///|
test "Rect::intersects" {
  // Test basic intersection - rectangles overlap
  let rect1 = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(10.0, 10.0) }
  let rect2 = Rect::{ position: Vec2D(5.0, 5.0), size: Vec2D(10.0, 10.0) }
  inspect(Rect::intersects(rect1, rect2), content="true")

  // Test no intersection - rectangles are separate
  let rect3 = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(5.0, 5.0) }
  let rect4 = Rect::{ position: Vec2D(10.0, 10.0), size: Vec2D(5.0, 5.0) }
  inspect(Rect::intersects(rect3, rect4), content="false")

  // Test edge case - rectangles touch but don't overlap
  let rect5 = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(5.0, 5.0) }
  let rect6 = Rect::{ position: Vec2D(5.0, 0.0), size: Vec2D(5.0, 5.0) }
  inspect(Rect::intersects(rect5, rect6), content="false")
}

///|
test "Rect::intersects/edge_cases" {
  // Test complete containment - one rectangle inside another
  let outer = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(20.0, 20.0) }
  let inner = Rect::{ position: Vec2D(5.0, 5.0), size: Vec2D(5.0, 5.0) }
  inspect(Rect::intersects(outer, inner), content="true")
  inspect(Rect::intersects(inner, outer), content="true")
  let zero_rect = Rect::{ position: Vec2D(5.0, 5.0), size: Vec2D(1.0, 1.0) }
  let normal_rect = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(1.0, 1.0) }
  inspect(Rect::intersects(zero_rect, normal_rect), content="false")
}

///|
test "Rect::intersects/partial_overlap" {
  // Test partial overlap in X direction only
  let rect1 = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(10.0, 5.0) }
  let rect2 = Rect::{ position: Vec2D(5.0, 10.0), size: Vec2D(10.0, 5.0) }
  inspect(Rect::intersects(rect1, rect2), content="false")

  // Test partial overlap in Y direction only  
  let rect3 = Rect::{ position: Vec2D(0.0, 0.0), size: Vec2D(5.0, 10.0) }
  let rect4 = Rect::{ position: Vec2D(10.0, 5.0), size: Vec2D(5.0, 10.0) }
  inspect(Rect::intersects(rect3, rect4), content="false")
}

///|
/// Shift the rectangle by a given vector.
/// 
pub fn Rect::shift(self : Rect, dir : Vec2D) -> Rect {
  { position: self.position + dir, size: self.size }
}
