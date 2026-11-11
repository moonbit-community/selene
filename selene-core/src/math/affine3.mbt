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
#deprecated
pub extend Affine3 with Eq::{not_equal, equal}

///|
#deprecated
pub extend Affine3 with @moonbitlang/core/debug.Debug::{to_repr}

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
#deprecated
pub extend Affine3 with Default::{default}

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
    x_axis: Vec3(
      (1.0 - (yy + zz)) * scale.x,
      (xy + wz) * scale.x,
      (xz - wy) * scale.x,
    ),
    y_axis: Vec3(
      (xy - wz) * scale.y,
      (1.0 - (xx + zz)) * scale.y,
      (yz + wx) * scale.y,
    ),
    z_axis: Vec3(
      (xz + wy) * scale.z,
      (yz - wx) * scale.z,
      (1.0 - (xx + yy)) * scale.z,
    ),
    translation,
  }
}

///|
pub fn Affine3::transform_vector(self : Affine3, value : Vec3) -> Vec3 {
  Vec3(
    self.x_axis.x * value.x + self.y_axis.x * value.y + self.z_axis.x * value.z,
    self.x_axis.y * value.x + self.y_axis.y * value.y + self.z_axis.y * value.z,
    self.x_axis.z * value.x + self.y_axis.z * value.y + self.z_axis.z * value.z,
  )
}

///|
pub fn Affine3::transform_point(self : Affine3, value : Vec3) -> Vec3 {
  Vec3(
    self.translation.x +
    (
      self.x_axis.x * value.x +
      self.y_axis.x * value.y +
      self.z_axis.x * value.z
    ),
    self.translation.y +
    (
      self.x_axis.y * value.x +
      self.y_axis.y * value.y +
      self.z_axis.y * value.z
    ),
    self.translation.z +
    (
      self.x_axis.z * value.x +
      self.y_axis.z * value.y +
      self.z_axis.z * value.z
    ),
  )
}

///|
/// `a * b` applies `b` first and then `a`.
pub impl Mul for Affine3 with fn mul(self, other) {
  {
    x_axis: self.transform_vector(other.x_axis),
    y_axis: self.transform_vector(other.y_axis),
    z_axis: self.transform_vector(other.z_axis),
    translation: self.transform_point(other.translation),
  }
}

///|
#deprecated
pub extend Affine3 with Mul::{mul}

///|
/// A cached direction map for normals, including reflection handedness.
/// The cofactor basis also supports surviving tangent planes of singular transforms.
pub struct NormalTransform3 {
  priv x_axis : Vec3
  priv y_axis : Vec3
  priv z_axis : Vec3
  priv sign : Double
}

///|
/// Returns -1 for reflections and +1 otherwise, including collapsed bases.
pub fn NormalTransform3::handedness(self : NormalTransform3) -> Double {
  self.sign
}

///|
/// Applies the direction map and normalizes the result. Returns None if no
/// finite nonzero normal survives. Magnitudes are intentionally discarded.
pub fn NormalTransform3::transform_normal(
  self : NormalTransform3,
  normal : Vec3,
) -> Vec3? {
  Vec3(
    self.x_axis.x * normal.x +
    self.y_axis.x * normal.y +
    self.z_axis.x * normal.z,
    self.x_axis.y * normal.x +
    self.y_axis.y * normal.y +
    self.z_axis.y * normal.z,
    self.x_axis.z * normal.x +
    self.y_axis.z * normal.y +
    self.z_axis.z * normal.z,
  ).try_normalize()
}

///|
/// Precomputes a direction transform for normals. Reuse it across mesh vertices.
/// This operation scales cofactors to avoid overflow and preserves reflections.
pub fn Affine3::normal_transform(self : Affine3) -> NormalTransform3 {
  let scale = self.linear_scale()
  let scaled = if scale > 0.0 { scale } else { 1.0 }
  let x = self.x_axis.scalar_div(scaled)
  let y = self.y_axis.scalar_div(scaled)
  let z = self.z_axis.scalar_div(scaled)
  let nx = y.cross(z)
  let ny = z.cross(x)
  let nz = x.cross(y)
  let sign = if x.dot(nx) < 0.0 { -1.0 } else { 1.0 }
  {
    x_axis: nx.scalar_mul(sign),
    y_axis: ny.scalar_mul(sign),
    z_axis: nz.scalar_mul(sign),
    sign,
  }
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
  let translation = inverse.transform_vector(-self.translation)
  guard translation.is_finite() else { None }
  Some({ ..inverse, translation, })
}
