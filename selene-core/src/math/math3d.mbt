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
pub(all) struct Vec3 {
  x : Double
  y : Double
  z : Double

  fn new(x : Double, y : Double, z : Double) -> Vec3
} derive(Eq, Show)

///|
pub fn Vec3::new(x : Double, y : Double, z : Double) -> Vec3 {
  { x, y, z }
}

///|
pub fn Vec3::zero() -> Vec3 {
  { x: 0.0, y: 0.0, z: 0.0 }
}

///|
pub fn Vec3::one() -> Vec3 {
  { x: 1.0, y: 1.0, z: 1.0 }
}

///|
pub fn Vec3::x_axis() -> Vec3 {
  Vec3::new(1.0, 0.0, 0.0)
}

///|
pub fn Vec3::y_axis() -> Vec3 {
  Vec3::new(0.0, 1.0, 0.0)
}

///|
pub fn Vec3::z_axis() -> Vec3 {
  Vec3::new(0.0, 0.0, 1.0)
}

///|
pub impl Default for Vec3 with default() -> Vec3 {
  Vec3::zero()
}

///|
pub impl Add for Vec3 with add(self, other) {
  Vec3::new(self.x + other.x, self.y + other.y, self.z + other.z)
}

///|
pub impl Sub for Vec3 with sub(self, other) {
  Vec3::new(self.x - other.x, self.y - other.y, self.z - other.z)
}

///|
pub impl Neg for Vec3 with neg(self) {
  Vec3::new(-self.x, -self.y, -self.z)
}

///|
pub impl Mul for Vec3 with mul(self, other) {
  Vec3::new(self.x * other.x, self.y * other.y, self.z * other.z)
}

///|
pub fn Vec3::scalar_mul(self : Vec3, scalar : Double) -> Vec3 {
  Vec3::new(self.x * scalar, self.y * scalar, self.z * scalar)
}

///|
pub fn Vec3::scalar_div(self : Vec3, scalar : Double) -> Vec3 {
  Vec3::new(self.x / scalar, self.y / scalar, self.z / scalar)
}

///|
pub fn Vec3::dot(self : Vec3, other : Vec3) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z
}

///|
pub fn Vec3::cross(self : Vec3, other : Vec3) -> Vec3 {
  Vec3::new(
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
pub fn Vec3::length(self : Vec3) -> Double {
  self.length_squared().sqrt()
}

///|
pub fn Vec3::normalize(self : Vec3) -> Vec3 {
  let len = self.length()
  if len <= 0.000000001 {
    Vec3::zero()
  } else {
    self.scalar_div(len)
  }
}

///|
pub fn Vec3::lerp(self : Vec3, other : Vec3, alpha : Double) -> Vec3 {
  self.scalar_mul(1.0 - alpha) + other.scalar_mul(alpha)
}

///|
pub fn Vec3::to_rapier(self : Vec3) -> @rcore.Vec3 {
  @rcore.Vec3::new(
    Float::from_double(self.x),
    Float::from_double(self.y),
    Float::from_double(self.z),
  )
}

///|
pub fn vec3_from_rapier(value : @rcore.Vec3) -> Vec3 {
  Vec3::new(value.x.to_double(), value.y.to_double(), value.z.to_double())
}

///|
pub(all) struct Quat {
  x : Double
  y : Double
  z : Double
  w : Double

  fn new(x : Double, y : Double, z : Double, w : Double) -> Quat
} derive(Eq, Show)

///|
pub fn Quat::new(x : Double, y : Double, z : Double, w : Double) -> Quat {
  { x, y, z, w }
}

///|
pub fn Quat::identity() -> Quat {
  Quat::new(0.0, 0.0, 0.0, 1.0)
}

///|
pub impl Default for Quat with default() -> Quat {
  Quat::identity()
}

///|
pub fn Quat::from_axis_angle(axis : Vec3, radians : Double) -> Quat {
  let normalized_axis = axis.normalize()
  let half = radians * 0.5
  let sin_half = @cmath.sin(half)
  let cos_half = @cmath.cos(half)
  Quat::new(
    normalized_axis.x * sin_half,
    normalized_axis.y * sin_half,
    normalized_axis.z * sin_half,
    cos_half,
  )
}

///|
pub fn Quat::conjugate(self : Quat) -> Quat {
  Quat::new(-self.x, -self.y, -self.z, self.w)
}

///|
pub fn Quat::inverse(self : Quat) -> Quat {
  let len_sq = self.length_squared()
  if len_sq <= 0.000000001 {
    Quat::identity()
  } else {
    let conjugate = self.conjugate()
    Quat::new(
      conjugate.x / len_sq,
      conjugate.y / len_sq,
      conjugate.z / len_sq,
      conjugate.w / len_sq,
    )
  }
}

///|
pub fn Quat::length_squared(self : Quat) -> Double {
  self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
}

///|
pub fn Quat::normalize(self : Quat) -> Quat {
  let len = self.length_squared().sqrt()
  if len <= 0.000000001 {
    Quat::identity()
  } else {
    Quat::new(self.x / len, self.y / len, self.z / len, self.w / len)
  }
}

///|
pub fn Quat::multiply(self : Quat, other : Quat) -> Quat {
  Quat::new(
    self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y,
    self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x,
    self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w,
    self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z,
  )
}

///|
pub fn Quat::dot(self : Quat, other : Quat) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w
}

///|
pub impl Mul for Quat with mul(self, other) {
  self.multiply(other)
}

///|
pub fn Quat::rotate_vec3(self : Quat, vec : Vec3) -> Vec3 {
  let q = self.normalize()
  let qv = Quat::new(vec.x, vec.y, vec.z, 0.0)
  let rotated = q * qv * q.conjugate()
  Vec3::new(rotated.x, rotated.y, rotated.z)
}

///|
pub fn Quat::nlerp(self : Quat, other : Quat, alpha : Double) -> Quat {
  let rhs = if self.dot(other) < 0.0 {
    Quat::new(-other.x, -other.y, -other.z, -other.w)
  } else {
    other
  }
  Quat::new(
    self.x * (1.0 - alpha) + rhs.x * alpha,
    self.y * (1.0 - alpha) + rhs.y * alpha,
    self.z * (1.0 - alpha) + rhs.z * alpha,
    self.w * (1.0 - alpha) + rhs.w * alpha,
  ).normalize()
}

///|
pub fn Quat::from_basis(x_axis : Vec3, y_axis : Vec3, z_axis : Vec3) -> Quat {
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
    Quat::new((m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, 0.25 * s).normalize()
  } else if m00 > m11 && m00 > m22 {
    let s = (1.0 + m00 - m11 - m22).sqrt() * 2.0
    Quat::new(0.25 * s, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s).normalize()
  } else if m11 > m22 {
    let s = (1.0 + m11 - m00 - m22).sqrt() * 2.0
    Quat::new((m01 + m10) / s, 0.25 * s, (m12 + m21) / s, (m02 - m20) / s).normalize()
  } else {
    let s = (1.0 + m22 - m00 - m11).sqrt() * 2.0
    Quat::new((m02 + m20) / s, (m12 + m21) / s, 0.25 * s, (m10 - m01) / s).normalize()
  }
}

///|
pub fn Quat::to_rapier(self : Quat) -> @rcore.Quat {
  @rcore.Quat::new(
    Float::from_double(self.x),
    Float::from_double(self.y),
    Float::from_double(self.z),
    Float::from_double(self.w),
  )
}

///|
pub fn quat_from_rapier(value : @rcore.Quat) -> Quat {
  Quat::new(
    value.x.to_double(),
    value.y.to_double(),
    value.z.to_double(),
    value.w.to_double(),
  )
}

///|
pub(all) struct Mat4 {
  m00 : Double
  m01 : Double
  m02 : Double
  m03 : Double
  m10 : Double
  m11 : Double
  m12 : Double
  m13 : Double
  m20 : Double
  m21 : Double
  m22 : Double
  m23 : Double
  m30 : Double
  m31 : Double
  m32 : Double
  m33 : Double
} derive(Eq, Show)

///|
pub fn Mat4::identity() -> Mat4 {
  {
    m00: 1.0,
    m01: 0.0,
    m02: 0.0,
    m03: 0.0,
    m10: 0.0,
    m11: 1.0,
    m12: 0.0,
    m13: 0.0,
    m20: 0.0,
    m21: 0.0,
    m22: 1.0,
    m23: 0.0,
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 1.0,
  }
}

///|
pub impl Default for Mat4 with default() -> Mat4 {
  Mat4::identity()
}

///|
pub fn Mat4::from_trs(
  translation : Vec3,
  rotation : Quat,
  scale : Vec3,
) -> Mat4 {
  let q = rotation.normalize()
  let x2 = q.x + q.x
  let y2 = q.y + q.y
  let z2 = q.z + q.z
  let xx = q.x * x2
  let yy = q.y * y2
  let zz = q.z * z2
  let xy = q.x * y2
  let xz = q.x * z2
  let yz = q.y * z2
  let wx = q.w * x2
  let wy = q.w * y2
  let wz = q.w * z2
  {
    m00: (1.0 - (yy + zz)) * scale.x,
    m01: (xy - wz) * scale.y,
    m02: (xz + wy) * scale.z,
    m03: translation.x,
    m10: (xy + wz) * scale.x,
    m11: (1.0 - (xx + zz)) * scale.y,
    m12: (yz - wx) * scale.z,
    m13: translation.y,
    m20: (xz - wy) * scale.x,
    m21: (yz + wx) * scale.y,
    m22: (1.0 - (xx + yy)) * scale.z,
    m23: translation.z,
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 1.0,
  }
}

///|
pub fn Mat4::mul(self : Mat4, other : Mat4) -> Mat4 {
  {
    m00: self.m00 * other.m00 +
    self.m01 * other.m10 +
    self.m02 * other.m20 +
    self.m03 * other.m30,
    m01: self.m00 * other.m01 +
    self.m01 * other.m11 +
    self.m02 * other.m21 +
    self.m03 * other.m31,
    m02: self.m00 * other.m02 +
    self.m01 * other.m12 +
    self.m02 * other.m22 +
    self.m03 * other.m32,
    m03: self.m00 * other.m03 +
    self.m01 * other.m13 +
    self.m02 * other.m23 +
    self.m03 * other.m33,
    m10: self.m10 * other.m00 +
    self.m11 * other.m10 +
    self.m12 * other.m20 +
    self.m13 * other.m30,
    m11: self.m10 * other.m01 +
    self.m11 * other.m11 +
    self.m12 * other.m21 +
    self.m13 * other.m31,
    m12: self.m10 * other.m02 +
    self.m11 * other.m12 +
    self.m12 * other.m22 +
    self.m13 * other.m32,
    m13: self.m10 * other.m03 +
    self.m11 * other.m13 +
    self.m12 * other.m23 +
    self.m13 * other.m33,
    m20: self.m20 * other.m00 +
    self.m21 * other.m10 +
    self.m22 * other.m20 +
    self.m23 * other.m30,
    m21: self.m20 * other.m01 +
    self.m21 * other.m11 +
    self.m22 * other.m21 +
    self.m23 * other.m31,
    m22: self.m20 * other.m02 +
    self.m21 * other.m12 +
    self.m22 * other.m22 +
    self.m23 * other.m32,
    m23: self.m20 * other.m03 +
    self.m21 * other.m13 +
    self.m22 * other.m23 +
    self.m23 * other.m33,
    m30: self.m30 * other.m00 +
    self.m31 * other.m10 +
    self.m32 * other.m20 +
    self.m33 * other.m30,
    m31: self.m30 * other.m01 +
    self.m31 * other.m11 +
    self.m32 * other.m21 +
    self.m33 * other.m31,
    m32: self.m30 * other.m02 +
    self.m31 * other.m12 +
    self.m32 * other.m22 +
    self.m33 * other.m32,
    m33: self.m30 * other.m03 +
    self.m31 * other.m13 +
    self.m32 * other.m23 +
    self.m33 * other.m33,
  }
}

///|
pub fn Mat4::transform_point(self : Mat4, point : Vec3) -> Vec3 {
  Vec3::new(
    self.m00 * point.x + self.m01 * point.y + self.m02 * point.z + self.m03,
    self.m10 * point.x + self.m11 * point.y + self.m12 * point.z + self.m13,
    self.m20 * point.x + self.m21 * point.y + self.m22 * point.z + self.m23,
  )
}

///|
pub(all) struct Affine3 {
  x_axis : Vec3
  y_axis : Vec3
  z_axis : Vec3
  translation : Vec3
} derive(Eq, Show)

///|
pub fn Affine3::identity() -> Affine3 {
  {
    x_axis: Vec3::x_axis(),
    y_axis: Vec3::y_axis(),
    z_axis: Vec3::z_axis(),
    translation: Vec3::zero(),
  }
}

///|
pub impl Default for Affine3 with default() -> Affine3 {
  Affine3::identity()
}

///|
pub fn Affine3::from_scale_rotation_translation(
  scale : Vec3,
  rotation : Quat,
  translation : Vec3,
) -> Affine3 {
  {
    x_axis: rotation.rotate_vec3(Vec3::x_axis().scalar_mul(scale.x)),
    y_axis: rotation.rotate_vec3(Vec3::y_axis().scalar_mul(scale.y)),
    z_axis: rotation.rotate_vec3(Vec3::z_axis().scalar_mul(scale.z)),
    translation,
  }
}

///|
pub fn Affine3::transform_vector3(self : Affine3, value : Vec3) -> Vec3 {
  self.x_axis.scalar_mul(value.x) +
  self.y_axis.scalar_mul(value.y) +
  self.z_axis.scalar_mul(value.z)
}

///|
pub fn Affine3::transform_point3(self : Affine3, value : Vec3) -> Vec3 {
  self.translation + self.transform_vector3(value)
}

///|
pub fn Affine3::mul(self : Affine3, other : Affine3) -> Affine3 {
  {
    x_axis: self.transform_vector3(other.x_axis),
    y_axis: self.transform_vector3(other.y_axis),
    z_axis: self.transform_vector3(other.z_axis),
    translation: self.transform_point3(other.translation),
  }
}

///|
pub impl Mul for Affine3 with mul(self, other) {
  self.mul(other)
}

///|
pub fn Affine3::inverse(self : Affine3) -> Affine3? {
  let a00 = self.x_axis.x
  let a10 = self.x_axis.y
  let a20 = self.x_axis.z
  let a01 = self.y_axis.x
  let a11 = self.y_axis.y
  let a21 = self.y_axis.z
  let a02 = self.z_axis.x
  let a12 = self.z_axis.y
  let a22 = self.z_axis.z

  let c00 = a11 * a22 - a12 * a21
  let c01 = a02 * a21 - a01 * a22
  let c02 = a01 * a12 - a02 * a11
  let c10 = a12 * a20 - a10 * a22
  let c11 = a00 * a22 - a02 * a20
  let c12 = a02 * a10 - a00 * a12
  let c20 = a10 * a21 - a11 * a20
  let c21 = a01 * a20 - a00 * a21
  let c22 = a00 * a11 - a01 * a10
  let det = a00 * c00 + a01 * c10 + a02 * c20
  if det.abs() <= 0.000000001 {
    return None
  }
  let inv_det = 1.0 / det
  let inverse = {
    x_axis: Vec3::new(c00 * inv_det, c10 * inv_det, c20 * inv_det),
    y_axis: Vec3::new(c01 * inv_det, c11 * inv_det, c21 * inv_det),
    z_axis: Vec3::new(c02 * inv_det, c12 * inv_det, c22 * inv_det),
    translation: Vec3::zero(),
  }
  Some({ ..inverse, translation: inverse.transform_vector3(-self.translation) })
}
