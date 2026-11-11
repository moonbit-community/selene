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
pub(all) struct Vec3 {
  x : Double
  y : Double
  z : Double
}

///|
#deprecated
pub extend Vec3 with Eq::{not_equal, equal}

///|
#deprecated
pub extend Vec3 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn Vec3::Vec3(x : Double, y : Double, z : Double) -> Vec3 {
  { x, y, z, }
}

///|
pub fn Vec3::zero() -> Vec3 {
  { x: 0.0, y: 0.0, z: 0.0, }
}

///|
pub fn Vec3::one() -> Vec3 {
  { x: 1.0, y: 1.0, z: 1.0, }
}

///|
pub fn Vec3::x_axis() -> Vec3 {
  Vec3(1.0, 0.0, 0.0)
}

///|
pub fn Vec3::y_axis() -> Vec3 {
  Vec3(0.0, 1.0, 0.0)
}

///|
pub fn Vec3::z_axis() -> Vec3 {
  Vec3(0.0, 0.0, 1.0)
}

///|
pub impl Default for Vec3 with fn default() -> Vec3 {
  Vec3::zero()
}

///|
#deprecated
pub extend Vec3 with Default::{default}

///|
pub impl Add for Vec3 with fn add(self, other) {
  Vec3(self.x + other.x, self.y + other.y, self.z + other.z)
}

///|
#deprecated
pub extend Vec3 with Add::{add}

///|
pub impl Sub for Vec3 with fn sub(self, other) {
  Vec3(self.x - other.x, self.y - other.y, self.z - other.z)
}

///|
#deprecated
pub extend Vec3 with Sub::{sub}

///|
pub impl Neg for Vec3 with fn neg(self) {
  Vec3(-self.x, -self.y, -self.z)
}

///|
#deprecated
pub extend Vec3 with Neg::{neg}

///|
pub impl Mul for Vec3 with fn mul(self, other) {
  Vec3(self.x * other.x, self.y * other.y, self.z * other.z)
}

///|
#deprecated
pub extend Vec3 with Mul::{mul}

///|
pub fn Vec3::scalar_mul(self : Vec3, scalar : Double) -> Vec3 {
  Vec3(self.x * scalar, self.y * scalar, self.z * scalar)
}

///|
pub fn Vec3::scalar_div(self : Vec3, scalar : Double) -> Vec3 {
  Vec3(self.x / scalar, self.y / scalar, self.z / scalar)
}

///|
pub fn Vec3::dot(self : Vec3, other : Vec3) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z
}

///|
pub fn Vec3::cross(self : Vec3, other : Vec3) -> Vec3 {
  Vec3(
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x,
  )
}

///|
pub fn Vec3::length_squared(self : Vec3) -> Double {
  self.dot(self)
}

///|
fn Vec3::max_abs_component(self : Vec3) -> Double {
  @cmp.maximum(self.x.abs(), @cmp.maximum(self.y.abs(), self.z.abs()))
}

///|
pub fn Vec3::is_finite(self : Vec3) -> Bool {
  self.x.is_finite() && self.y.is_finite() && self.z.is_finite()
}

///|
pub fn Vec3::length(self : Vec3) -> Double {
  let squared = self.length_squared()
  if squared >= 1.0e-300 && squared.is_finite() {
    return squared.sqrt()
  }
  let scale = self.max_abs_component()
  if scale == 0.0 || !self.is_finite() {
    return squared.sqrt()
  }
  self.scalar_div(scale).length_squared().sqrt() * scale
}

///|
pub fn Vec3::distance_squared(self : Vec3, other : Vec3) -> Double {
  let dx = self.x - other.x
  let dy = self.y - other.y
  let dz = self.z - other.z
  dx * dx + dy * dy + dz * dz
}

///|
pub fn Vec3::distance(self : Vec3, other : Vec3) -> Double {
  (self - other).length()
}

///|
pub fn Vec3::try_normalize(self : Vec3) -> Vec3? {
  let squared = self.length_squared()
  if squared >= 1.0e-300 && squared.is_finite() {
    return Some(self.scalar_div(squared.sqrt()))
  }
  guard self.is_finite() else { None }
  let scale = self.max_abs_component()
  guard scale > 0.0 else { None }
  let scaled = self.scalar_div(scale)
  Some(scaled.scalar_div(scaled.length_squared().sqrt()))
}

///|
pub fn Vec3::normalize_or_zero(self : Vec3) -> Vec3 {
  self.try_normalize().unwrap_or_default()
}

///|
pub fn Vec3::lerp(self : Vec3, other : Vec3, alpha : Double) -> Vec3 {
  Vec3(
    self.x * (1.0 - alpha) + other.x * alpha,
    self.y * (1.0 - alpha) + other.y * alpha,
    self.z * (1.0 - alpha) + other.z * alpha,
  )
}
