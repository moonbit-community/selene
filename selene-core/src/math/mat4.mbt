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
/// A column-vector matrix. Field `mRC` is row R, column C.
#derive(Eq, Debug)
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
}

///|
/// Decodes a 16-element column-major matrix (glTF and WebGPU order).
pub fn Mat4::from_column_major(values : ArrayView[Double]) -> Mat4? {
  guard values.length() == 16 else { None }
  Some({
    m00: values[0],
    m01: values[4],
    m02: values[8],
    m03: values[12],
    m10: values[1],
    m11: values[5],
    m12: values[9],
    m13: values[13],
    m20: values[2],
    m21: values[6],
    m22: values[10],
    m23: values[14],
    m30: values[3],
    m31: values[7],
    m32: values[11],
    m33: values[15],
  })
}

///|
pub fn Mat4::to_column_major(self : Mat4) -> Array[Double] {
  [
    self.m00,
    self.m10,
    self.m20,
    self.m30,
    self.m01,
    self.m11,
    self.m21,
    self.m31,
    self.m02,
    self.m12,
    self.m22,
    self.m32,
    self.m03,
    self.m13,
    self.m23,
    self.m33,
  ]
}

///|
/// Converts a matrix with affine last row `[0, 0, 0, 1]`.
pub fn Mat4::try_to_affine(self : Mat4) -> Affine3? {
  guard self.m30 == 0.0 && self.m31 == 0.0 && self.m32 == 0.0 && self.m33 == 1.0 else {
    None
  }
  Some(self.affine_part())
}

///|
/// Extracts the first three rows, including the translation column.
pub fn Mat4::affine_part(self : Mat4) -> Affine3 {
  {
    x_axis: Vec3(self.m00, self.m10, self.m20),
    y_axis: Vec3(self.m01, self.m11, self.m21),
    z_axis: Vec3(self.m02, self.m12, self.m22),
    translation: Vec3(self.m03, self.m13, self.m23),
  }
}

///|
/// Returns an orthonormal (right, up, forward) basis for a right-handed view.
pub fn view_basis_rh(forward : Vec3, up : Vec3) -> (Vec3, Vec3, Vec3) {
  let forward = forward.try_normalize().unwrap_or(-Vec3::z_axis())
  let fallback_up = if forward.y.abs() < 0.9 {
    Vec3::y_axis()
  } else {
    Vec3::x_axis()
  }
  let right = forward.cross(up.normalize_or_zero())
  let right = if right.length_squared() > 1.0e-16 {
    right.normalize_or_zero()
  } else {
    forward.cross(fallback_up).normalize_or_zero()
  }
  (right, right.cross(forward), forward)
}

///|
/// Right-handed view with a negative-Z forward axis.
pub fn Mat4::look_at_rh(eye : Vec3, target : Vec3, up : Vec3) -> Mat4 {
  let (x, y, forward) = view_basis_rh(target - eye, up)
  let z = -forward
  {
    m00: x.x,
    m01: x.y,
    m02: x.z,
    m03: -x.dot(eye),
    m10: y.x,
    m11: y.y,
    m12: y.z,
    m13: -y.dot(eye),
    m20: z.x,
    m21: z.y,
    m22: z.z,
    m23: -z.dot(eye),
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 1.0,
  }
}

///|
/// Right-handed perspective with depth in [0, 1] and vertical FOV in radians.
pub fn Mat4::perspective_rh_zo(
  fov_y_radians : Double,
  aspect : Double,
  near : Double,
  far : Double,
) -> Mat4 {
  let f = 1.0 / @cmath.tan(fov_y_radians * 0.5)
  let depth = near - far
  {
    m00: f / aspect,
    m01: 0.0,
    m02: 0.0,
    m03: 0.0,
    m10: 0.0,
    m11: f,
    m12: 0.0,
    m13: 0.0,
    m20: 0.0,
    m21: 0.0,
    m22: far / depth,
    m23: near * (far / depth),
    m30: 0.0,
    m31: 0.0,
    m32: -1.0,
    m33: 0.0,
  }
}

///|
/// Centered right-handed orthographic projection with depth in [0, 1].
pub fn Mat4::orthographic_rh_zo(
  width : Double,
  height : Double,
  near : Double,
  far : Double,
) -> Mat4 {
  let depth = near - far
  {
    m00: 2.0 / width,
    m01: 0.0,
    m02: 0.0,
    m03: 0.0,
    m10: 0.0,
    m11: 2.0 / height,
    m12: 0.0,
    m13: 0.0,
    m20: 0.0,
    m21: 0.0,
    m22: 1.0 / depth,
    m23: near / depth,
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 1.0,
  }
}

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
pub impl Default for Mat4 with fn default() -> Mat4 {
  Mat4::identity()
}

///|
pub fn Mat4::from_affine(affine : Affine3) -> Mat4 {
  {
    m00: affine.x_axis.x,
    m01: affine.y_axis.x,
    m02: affine.z_axis.x,
    m03: affine.translation.x,
    m10: affine.x_axis.y,
    m11: affine.y_axis.y,
    m12: affine.z_axis.y,
    m13: affine.translation.y,
    m20: affine.x_axis.z,
    m21: affine.y_axis.z,
    m22: affine.z_axis.z,
    m23: affine.translation.z,
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
fn Mat4::transform_xyz(self : Mat4, point : Vec3) -> Vec3 {
  Vec3(
    self.m00 * point.x + self.m01 * point.y + self.m02 * point.z + self.m03,
    self.m10 * point.x + self.m11 * point.y + self.m12 * point.z + self.m13,
    self.m20 * point.x + self.m21 * point.y + self.m22 * point.z + self.m23,
  )
}

///|
/// Transforms a point and divides by its homogeneous coordinate.
pub fn Mat4::project_point(self : Mat4, point : Vec3) -> Vec3? {
  let w = self.m30 * point.x +
    self.m31 * point.y +
    self.m32 * point.z +
    self.m33
  guard w != 0.0 && w.is_finite() else { None }
  let projected = self.transform_xyz(point).scalar_div(w)
  guard projected.is_finite() else { None }
  Some(projected)
}

///|
pub fn Mat4::zero() -> Mat4 {
  {
    m00: 0.0,
    m01: 0.0,
    m02: 0.0,
    m03: 0.0,
    m10: 0.0,
    m11: 0.0,
    m12: 0.0,
    m13: 0.0,
    m20: 0.0,
    m21: 0.0,
    m22: 0.0,
    m23: 0.0,
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 0.0,
  }
}

///|
pub fn Mat4::scalar_mul(matrix : Mat4, scalar : Double) -> Mat4 {
  {
    m00: matrix.m00 * scalar,
    m01: matrix.m01 * scalar,
    m02: matrix.m02 * scalar,
    m03: matrix.m03 * scalar,
    m10: matrix.m10 * scalar,
    m11: matrix.m11 * scalar,
    m12: matrix.m12 * scalar,
    m13: matrix.m13 * scalar,
    m20: matrix.m20 * scalar,
    m21: matrix.m21 * scalar,
    m22: matrix.m22 * scalar,
    m23: matrix.m23 * scalar,
    m30: matrix.m30 * scalar,
    m31: matrix.m31 * scalar,
    m32: matrix.m32 * scalar,
    m33: matrix.m33 * scalar,
  }
}

///|
pub impl Add for Mat4 with fn add(lhs, rhs) {
  {
    m00: lhs.m00 + rhs.m00,
    m01: lhs.m01 + rhs.m01,
    m02: lhs.m02 + rhs.m02,
    m03: lhs.m03 + rhs.m03,
    m10: lhs.m10 + rhs.m10,
    m11: lhs.m11 + rhs.m11,
    m12: lhs.m12 + rhs.m12,
    m13: lhs.m13 + rhs.m13,
    m20: lhs.m20 + rhs.m20,
    m21: lhs.m21 + rhs.m21,
    m22: lhs.m22 + rhs.m22,
    m23: lhs.m23 + rhs.m23,
    m30: lhs.m30 + rhs.m30,
    m31: lhs.m31 + rhs.m31,
    m32: lhs.m32 + rhs.m32,
    m33: lhs.m33 + rhs.m33,
  }
}
