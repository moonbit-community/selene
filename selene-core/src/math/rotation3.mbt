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
pub(all) struct Quat {
  x : Double
  y : Double
  z : Double
  w : Double
}

///|
#deprecated
pub extend Quat with Eq::{not_equal, equal}

///|
#deprecated
pub extend Quat with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn Quat::Quat(x : Double, y : Double, z : Double, w : Double) -> Quat {
  { x, y, z, w, }
}

///|
pub fn Quat::identity() -> Quat {
  Quat(0.0, 0.0, 0.0, 1.0)
}

///|
pub impl Default for Quat with fn default() -> Quat {
  Quat::identity()
}

///|
#deprecated
pub extend Quat with Default::{default}

///|
fn Quat::conjugate(self : Quat) -> Quat {
  Quat(-self.x, -self.y, -self.z, self.w)
}

///|
pub fn Quat::length_squared(self : Quat) -> Double {
  self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
}

///|
pub fn Quat::normalize_or_identity(self : Quat) -> Quat {
  Rotation3::from_quat(self).unwrap_or_default().to_quat()
}

///|
pub impl Mul for Quat with fn mul(self, other) {
  Quat(
    self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y,
    self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x,
    self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w,
    self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z,
  )
}

///|
#deprecated
pub extend Quat with Mul::{mul}

///|
pub fn Quat::dot(self : Quat, other : Quat) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w
}

///|
pub fn Quat::nlerp(self : Quat, other : Quat, alpha : Double) -> Quat {
  let rhs = if self.dot(other) < 0.0 {
    Quat(-other.x, -other.y, -other.z, -other.w)
  } else {
    other
  }
  Quat(
    self.x * (1.0 - alpha) + rhs.x * alpha,
    self.y * (1.0 - alpha) + rhs.y * alpha,
    self.z * (1.0 - alpha) + rhs.z * alpha,
    self.w * (1.0 - alpha) + rhs.w * alpha,
  ).normalize_or_identity()
}

///|
/// A unit quaternion representing an orientation.
#derive(Eq, Debug)
pub struct Rotation3 {
  priv value : Quat
}

///|
#deprecated
pub extend Rotation3 with Eq::{not_equal, equal}

///|
#deprecated
pub extend Rotation3 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn Rotation3::identity() -> Rotation3 {
  { value: Quat::identity(), }
}

///|
pub impl Default for Rotation3 with fn default() -> Rotation3 {
  Rotation3::identity()
}

///|
#deprecated
pub extend Rotation3 with Default::{default}

///|
/// Rejects zero and non-finite quaternions.
pub fn Rotation3::from_quat(value : Quat) -> Rotation3? {
  guard value.x.is_finite() &&
    value.y.is_finite() &&
    value.z.is_finite() &&
    value.w.is_finite() else {
    None
  }
  let scale = @cmp.maximum(
    @cmp.maximum(value.x.abs(), value.y.abs()),
    @cmp.maximum(value.z.abs(), value.w.abs()),
  )
  guard scale > 0.0 else { None }
  let q = Quat(
    value.x / scale,
    value.y / scale,
    value.z / scale,
    value.w / scale,
  )
  let len = q.length_squared().sqrt()
  Some({ value: Quat(q.x / len, q.y / len, q.z / len, q.w / len), })
}

///|
pub fn Rotation3::to_quat(self : Rotation3) -> Quat {
  self.value
}

///|
/// Returns the identity for a zero or non-finite axis or non-finite angle.
pub fn Rotation3::from_axis_angle(axis : Vec3, radians : Double) -> Rotation3 {
  guard radians.is_finite() && axis.try_normalize() is Some(axis) else {
    return Rotation3::identity()
  }
  let half = radians * 0.5
  let sin_half = @cmath.sin(half)
  {
    value: Quat(
      axis.x * sin_half,
      axis.y * sin_half,
      axis.z * sin_half,
      @cmath.cos(half),
    ),
  }
}

///|
pub fn Rotation3::inverse(self : Rotation3) -> Rotation3 {
  { value: self.value.conjugate(), }
}

///|
/// `a * b` applies `b` first and then `a`.
pub impl Mul for Rotation3 with fn mul(self, other) {
  // Products of unit quaternions are nonzero and finite.
  Rotation3::from_quat(self.value * other.value).unwrap()
}

///|
#deprecated
pub extend Rotation3 with Mul::{mul}

///|
pub fn Rotation3::rotate_vec3(self : Rotation3, vector : Vec3) -> Vec3 {
  let q = self.value
  let axis = Vec3(q.x, q.y, q.z)
  let twice_cross = axis.cross(vector).scalar_mul(2.0)
  vector + twice_cross.scalar_mul(q.w) + axis.cross(twice_cross)
}

///|
pub fn Rotation3::from_basis(
  x_axis : Vec3,
  y_axis : Vec3,
  z_axis : Vec3,
) -> Rotation3? {
  let epsilon = 1.0e-8
  guard (x_axis.length_squared() - 1.0).abs() <= epsilon &&
    (y_axis.length_squared() - 1.0).abs() <= epsilon &&
    (z_axis.length_squared() - 1.0).abs() <= epsilon &&
    x_axis.dot(y_axis).abs() <= epsilon &&
    x_axis.dot(z_axis).abs() <= epsilon &&
    y_axis.dot(z_axis).abs() <= epsilon &&
    x_axis.cross(y_axis).dot(z_axis) > 0.0 else {
    None
  }
  Rotation3::from_quat(quat_from_basis(x_axis, y_axis, z_axis))
}

///|
fn quat_from_basis(x_axis : Vec3, y_axis : Vec3, z_axis : Vec3) -> Quat {
  let m00 = x_axis.x
  let m01 = y_axis.x
  let m02 = z_axis.x
  let m10 = x_axis.y
  let m11 = y_axis.y
  let m12 = z_axis.y
  let m20 = x_axis.z
  let m21 = y_axis.z
  let m22 = z_axis.z
  let trace = m00 + m11 + m22
  if trace > 0.0 {
    let s = (trace + 1.0).sqrt() * 2.0
    Quat((m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, 0.25 * s)
  } else if m00 > m11 && m00 > m22 {
    let s = (1.0 + m00 - m11 - m22).sqrt() * 2.0
    Quat(0.25 * s, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s)
  } else if m11 > m22 {
    let s = (1.0 + m11 - m00 - m22).sqrt() * 2.0
    Quat((m01 + m10) / s, 0.25 * s, (m12 + m21) / s, (m02 - m20) / s)
  } else {
    let s = (1.0 + m22 - m00 - m11).sqrt() * 2.0
    Quat((m02 + m20) / s, (m12 + m21) / s, 0.25 * s, (m10 - m01) / s)
  }
}
