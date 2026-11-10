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
/// A column-vector affine transform stored as three basis columns and a translation.
#derive(Eq, Debug)
pub(all) struct Affine3 {
  x_axis : Vec3
  y_axis : Vec3
  z_axis : Vec3
  translation : Vec3
}

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
pub impl Default for Affine3 with fn default() -> Affine3 {
  Affine3::identity()
}

///|
pub fn Affine3::from_scale_rotation_translation(
  scale : Vec3,
  rotation : Rotation3,
  translation : Vec3,
) -> Affine3 {
  let q = rotation.to_quat()
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
    x_axis: Vec3(1.0 - (yy + zz), xy + wz, xz - wy).scalar_mul(scale.x),
    y_axis: Vec3(xy - wz, 1.0 - (xx + zz), yz + wx).scalar_mul(scale.y),
    z_axis: Vec3(xz + wy, yz - wx, 1.0 - (xx + yy)).scalar_mul(scale.z),
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
pub impl Mul for Affine3 with fn mul(self, other) {
  {
    x_axis: self.transform_vector3(other.x_axis),
    y_axis: self.transform_vector3(other.y_axis),
    z_axis: self.transform_vector3(other.z_axis),
    translation: self.transform_point3(other.translation),
  }
}

///|
/// Returns a linear map for normals and the handedness of the original basis.
/// Normalize the transformed normal. For a singular basis this uses its
/// cofactors, which can still give the normal of a surviving tangent plane.
pub fn Affine3::normal_matrix(self : Affine3) -> (Affine3, Double) {
  let scale = self.linear_scale()
  let scaled = if scale > 0.0 { scale } else { 1.0 }
  let x = self.x_axis.scalar_div(scaled)
  let y = self.y_axis.scalar_div(scaled)
  let z = self.z_axis.scalar_div(scaled)
  let nx = y.cross(z)
  let ny = z.cross(x)
  let nz = x.cross(y)
  let sign = if x.dot(nx) < 0.0 { -1.0 } else { 1.0 }
  (
    {
      x_axis: nx.scalar_mul(sign),
      y_axis: ny.scalar_mul(sign),
      z_axis: nz.scalar_mul(sign),
      translation: Vec3::zero(),
    },
    sign,
  )
}

///|
fn Affine3::linear_scale(self : Affine3) -> Double {
  @cmp.maximum(
    self.x_axis.max_abs_component(),
    @cmp.maximum(
      self.y_axis.max_abs_component(),
      self.z_axis.max_abs_component(),
    ),
  )
}

///|
/// Projects the affine transform onto XY with local Z equal to zero.
pub fn Affine3::project_xy(self : Affine3) -> Affine2 {
  Affine2(
    a=self.x_axis.x,
    b=self.x_axis.y,
    c=self.y_axis.x,
    d=self.y_axis.y,
    tx=self.translation.x,
    ty=self.translation.y,
  )
}

///|
/// Returns None for a singular, ill-conditioned, or non-finite transform.
pub fn Affine3::inverse(self : Affine3) -> Affine3? {
  guard self.x_axis.is_finite() &&
    self.y_axis.is_finite() &&
    self.z_axis.is_finite() else {
    None
  }
  let scale = self.linear_scale()
  guard scale > 0.0 else { None }
  let x = self.x_axis.scalar_div(scale)
  let y = self.y_axis.scalar_div(scale)
  let z = self.z_axis.scalar_div(scale)
  let row_x = y.cross(z)
  let row_y = z.cross(x)
  let row_z = x.cross(y)
  let det = x.dot(row_x)
  let cofactor_scale = @cmp.maximum(
    row_x.max_abs_component(),
    @cmp.maximum(row_y.max_abs_component(), row_z.max_abs_component()),
  )
  guard det.abs() > 1.0e-12 * cofactor_scale else { None }
  let inverse : Affine3 = {
    x_axis: Vec3(row_x.x, row_y.x, row_z.x).scalar_div(det).scalar_div(scale),
    y_axis: Vec3(row_x.y, row_y.y, row_z.y).scalar_div(det).scalar_div(scale),
    z_axis: Vec3(row_x.z, row_y.z, row_z.z).scalar_div(det).scalar_div(scale),
    translation: Vec3::zero(),
  }
  let translation = inverse.transform_vector3(-self.translation)
  guard translation.is_finite() else { None }
  Some({ ..inverse, translation, })
}
