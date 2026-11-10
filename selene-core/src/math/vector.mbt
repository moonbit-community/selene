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
#derive(Eq, Debug)
pub(all) struct Vec2 {
  x : Double
  y : Double
}

///|
pub fn Vec2::Vec2(x : Double, y : Double) -> Vec2 {
  { x, y, }
}

///|
pub fn Vec2::zero() -> Vec2 {
  Vec2(0.0, 0.0)
}

///|
pub impl Default for Vec2 with fn default() -> Vec2 {
  Vec2::zero()
}

///|
pub impl Add for Vec2 with fn add(self, other) {
  Vec2(self.x + other.x, self.y + other.y)
}

///|
pub impl Sub for Vec2 with fn sub(self, other) {
  Vec2(self.x - other.x, self.y - other.y)
}

///|
pub impl Mul for Vec2 with fn mul(self, other) {
  Vec2(self.x * other.x, self.y * other.y)
}

///|
pub impl Neg for Vec2 with fn neg(self) {
  Vec2(-self.x, -self.y)
}

///|
pub fn Vec2::scalar_mul(self : Vec2, scalar : Double) -> Vec2 {
  Vec2(self.x * scalar, self.y * scalar)
}

///|
pub fn Vec2::scalar_div(self : Vec2, scalar : Double) -> Vec2 {
  Vec2(self.x / scalar, self.y / scalar)
}

///|
pub fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.x * other.x + self.y * other.y
}

///|
pub fn Vec2::length_squared(self : Vec2) -> Double {
  self.dot(self)
}

///|
pub fn Vec2::length(self : Vec2) -> Double {
  let squared = self.length_squared()
  if squared >= 1.0e-300 && squared.is_finite() {
    return squared.sqrt()
  }
  let scale = @cmp.maximum(self.x.abs(), self.y.abs())
  if scale == 0.0 || !scale.is_finite() {
    return squared.sqrt()
  }
  self.scalar_div(scale).length_squared().sqrt() * scale
}

///|
pub fn Vec2::distance(self : Vec2, other : Vec2) -> Double {
  (self - other).length()
}

///|
pub fn Vec2::try_normalize(self : Vec2) -> Vec2? {
  let squared = self.length_squared()
  if squared >= 1.0e-300 && squared.is_finite() {
    return Some(self.scalar_div(squared.sqrt()))
  }
  guard self.x.is_finite() && self.y.is_finite() else { None }
  let scale = @cmp.maximum(self.x.abs(), self.y.abs())
  guard scale > 0.0 else { None }
  let scaled = self.scalar_div(scale)
  Some(scaled.scalar_div(scaled.length_squared().sqrt()))
}

///|
pub fn Vec2::normalize_or_zero(self : Vec2) -> Vec2 {
  self.try_normalize().unwrap_or_default()
}
