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
/// Raw XYZW quaternion components, including non-unit animation derivatives.
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
/// Normalizes finite nonzero values, returning identity for invalid input.
pub fn Quat::normalize_or_identity(self : Quat) -> Quat {
  Rotation3::try_from_quat(self).unwrap_or_default().to_quat()
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
pub fn Rotation3::try_from_quat(value : Quat) -> Rotation3? {
  let squared = value.length_squared()
  if squared >= 1.0e-300 && squared.is_finite() {
    return Some(Rotation3::normalized(value.x, value.y, value.z, value.w))
  }
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
/// Returns None for a zero/non-finite axis or a non-finite angle. Angles are radians.
pub fn Rotation3::try_from_axis_angle(
  axis : Vec3,
  radians : Double,
) -> Rotation3? {
  guard radians.is_finite() && axis.try_normalize() is Some(axis) else { None }
  let half = radians * 0.5
  let sin_half = @cmath.sin(half)
  Some({
    value: Quat(
      axis.x * sin_half,
      axis.y * sin_half,
      axis.z * sin_half,
      @cmath.cos(half),
    ),
  })
}

///|
/// Constructs a rotation in radians. The axis must be finite and nonzero,
/// and the angle must be finite. Invalid input aborts.
pub fn Rotation3::from_axis_angle(axis : Vec3, radians : Double) -> Rotation3 {
  match Rotation3::try_from_axis_angle(axis, radians) {
    Some(rotation) => rotation
    None => abort("rotation requires a finite nonzero axis and finite angle")
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
  let left = self.value
  let right = other.value
  // Keep the product in scalars until constructing the normalized rotation.
  Rotation3::normalized(
    left.w * right.x + left.x * right.w + left.y * right.z - left.z * right.y,
    left.w * right.y - left.x * right.z + left.y * right.w + left.z * right.x,
    left.w * right.z + left.x * right.y - left.y * right.x + left.z * right.w,
    left.w * right.w - left.x * right.x - left.y * right.y - left.z * right.z,
  )
}

///|
#deprecated
pub extend Rotation3 with Mul::{mul}

///|
pub fn Rotation3::rotate_vec3(self : Rotation3, vector : Vec3) -> Vec3 {
  let q = self.value
  let tx = 2.0 * (q.y * vector.z - q.z * vector.y)
  let ty = 2.0 * (q.z * vector.x - q.x * vector.z)
  let tz = 2.0 * (q.x * vector.y - q.y * vector.x)
  Vec3(
    vector.x + q.w * tx + q.y * tz - q.z * ty,
    vector.y + q.w * ty + q.z * tx - q.x * tz,
    vector.z + q.w * tz + q.x * ty - q.y * tx,
  )
}

///|
/// Checks unit lengths, orthogonality and positive handedness. The tolerance
/// is dimensionless. Use a tolerance matching the precision of imported data.
pub fn Rotation3::try_from_basis(
  x_axis : Vec3,
  y_axis : Vec3,
  z_axis : Vec3,
  tolerance~ : Double = 1.0e-8,
) -> Rotation3? {
  guard tolerance.is_finite() && tolerance >= 0.0 else { None }
  let epsilon = tolerance
  guard (x_axis.length_squared() - 1.0).abs() <= epsilon &&
    (y_axis.length_squared() - 1.0).abs() <= epsilon &&
    (z_axis.length_squared() - 1.0).abs() <= epsilon &&
    x_axis.dot(y_axis).abs() <= epsilon &&
    x_axis.dot(z_axis).abs() <= epsilon &&
    y_axis.dot(z_axis).abs() <= epsilon &&
    x_axis.cross(y_axis).dot(z_axis) > 0.0 else {
    None
  }
  Rotation3::try_from_quat(quat_from_basis(x_axis, y_axis, z_axis))
}

///|
/// Shortest-path normalized linear interpolation. Alpha must be finite.
pub fn Rotation3::nlerp(
  self : Rotation3,
  other : Rotation3,
  alpha : Double,
) -> Rotation3 {
  guard alpha.is_finite() else {
    abort("rotation interpolation requires finite alpha")
  }
  let start = self.value
  let end = if start.dot(other.value) < 0.0 {
    other.value.negated()
  } else {
    other.value
  }
  if start == end {
    return self
  }
  let left = 1.0 - alpha
  let mixed = Quat(
    start.x * left + end.x * alpha,
    start.y * left + end.y * alpha,
    start.z * left + end.z * alpha,
    start.w * left + end.w * alpha,
  )
  match Rotation3::try_from_quat(mixed) {
    Some(rotation) => rotation
    None => {
      // Scale extrapolation weights before mixing to avoid overflow.
      let scale = @cmp.maximum(left.abs(), alpha.abs())
      let left = left / scale
      let right = alpha / scale
      Rotation3::try_from_quat(
        Quat(
          start.x * left + end.x * right,
          start.y * left + end.y * right,
          start.z * left + end.z * right,
          start.w * left + end.w * right,
        ),
      ).unwrap()
    }
  }
}

///|
/// Shortest-path spherical interpolation at constant angular speed.
/// Alpha must be finite. Values outside [0, 1] extrapolate.
pub fn Rotation3::slerp(
  self : Rotation3,
  other : Rotation3,
  alpha : Double,
) -> Rotation3 {
  guard alpha.is_finite() else {
    abort("rotation interpolation requires finite alpha")
  }
  let dot = self.value.dot(other.value)
  let end = if dot < 0.0 { other.value.negated() } else { other.value }
  let cosine = @cmp.minimum(dot.abs(), 1.0)
  if cosine > 1.0 - 1.0e-12 {
    return self.nlerp(other, alpha)
  }
  let angle = @cmath.acos(cosine)
  // Reducing alpha first also keeps extreme extrapolation weights finite.
  let phase = alpha % (2.0 * @cmath.PI / angle) * angle
  let right = @cmath.sin(phase)
  let left = @cmath.sin(angle - phase)
  let start = self.value
  // The common 1/sin(angle) factor disappears during normalization.
  Rotation3::normalized(
    start.x * left + end.x * right,
    start.y * left + end.y * right,
    start.z * left + end.z * right,
    start.w * left + end.w * right,
  )
}

///|
fn Quat::negated(self : Quat) -> Quat {
  Quat(-self.x, -self.y, -self.z, -self.w)
}

///|
/// For bounded, finite, nonzero quaternion components trusted by Rotation3.
fn Rotation3::normalized(
  x : Double,
  y : Double,
  z : Double,
  w : Double,
) -> Rotation3 {
  let reciprocal = 1.0 / (x * x + y * y + z * z + w * w).sqrt()
  {
    value: Quat(x * reciprocal, y * reciprocal, z * reciprocal, w * reciprocal),
  }
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
