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
/// A column-vector affine transform with rows `[a, c, tx]` and `[b, d, ty]`.
pub(all) struct Affine2 {
  a : Double
  b : Double
  c : Double
  d : Double
  tx : Double
  ty : Double
}

///|
pub fn Affine2::identity() -> Affine2 {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0, }
}

///|
pub fn Affine2::Affine2(
  a~ : Double = 1.0,
  b~ : Double = 0.0,
  c~ : Double = 0.0,
  d~ : Double = 1.0,
  tx~ : Double = 0.0,
  ty~ : Double = 0.0,
) -> Affine2 {
  { a, b, c, d, tx, ty, }
}

///|
pub fn Affine2::from_translation(tx : Double, ty : Double) -> Affine2 {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx, ty, }
}

///|
pub fn Affine2::from_scale(sx : Double, sy : Double) -> Affine2 {
  { a: sx, b: 0.0, c: 0.0, d: sy, tx: 0.0, ty: 0.0, }
}

///|
pub fn Affine2::from_rotation_deg(deg : Double) -> Affine2 {
  Affine2::from_rotation_rad(deg / 180.0 * @cmath.PI)
}

///|
pub fn Affine2::from_rotation_rad(rad : Double) -> Affine2 {
  let cos_r = @cmath.cos(rad)
  let sin_r = @cmath.sin(rad)
  { a: cos_r, b: sin_r, c: -sin_r, d: cos_r, tx: 0.0, ty: 0.0, }
}

///|
pub fn Affine2::from_skew(kx : Double, ky : Double) -> Affine2 {
  { a: 1.0, b: ky, c: kx, d: 1.0, tx: 0.0, ty: 0.0, }
}

///|
pub fn Affine2::with_translation(
  self : Affine2,
  tx : Double,
  ty : Double,
) -> Affine2 {
  { ..self, tx, ty, }
}

///|
pub fn Affine2::flip_x(width : Double) -> Affine2 {
  Affine2::from_translation(width, 0.0) * Affine2::from_scale(-1.0, 1.0)
}

///|
pub fn Affine2::flip_y(height : Double) -> Affine2 {
  Affine2::from_translation(0.0, height) * Affine2::from_scale(1.0, -1.0)
}

///|
pub impl Default for Affine2 with fn default() -> Affine2 {
  Affine2::identity()
}

///|
#deprecated
pub extend Affine2 with Default::{default}

///|
/// `a * b` applies `b` first and then `a`.
pub impl Mul for Affine2 with fn mul(self : Affine2, other : Affine2) -> Affine2 {
  {
    a: self.a * other.a + self.c * other.b,
    b: self.b * other.a + self.d * other.b,
    c: self.a * other.c + self.c * other.d,
    d: self.b * other.c + self.d * other.d,
    tx: self.a * other.tx + self.c * other.ty + self.tx,
    ty: self.b * other.tx + self.d * other.ty + self.ty,
  }
}

///|
#deprecated
pub extend Affine2 with Mul::{mul}

///|
pub fn Affine2::transform_vector(self : Affine2, value : Vec2) -> Vec2 {
  Vec2(self.a * value.x + self.c * value.y, self.b * value.x + self.d * value.y)
}

///|
pub fn Affine2::transform_point(self : Affine2, point : Vec2) -> Vec2 {
  self.transform_vector(point) + Vec2(self.tx, self.ty)
}

///|
/// Returns None for a singular, ill-conditioned, or non-finite transform.
pub fn Affine2::inverse(self : Affine2) -> Affine2? {
  guard self.a.is_finite() &&
    self.b.is_finite() &&
    self.c.is_finite() &&
    self.d.is_finite() else {
    None
  }
  let scale = @cmp.maximum(
    @cmp.maximum(self.a.abs(), self.b.abs()),
    @cmp.maximum(self.c.abs(), self.d.abs()),
  )
  guard scale > 0.0 else { None }
  let scaled_a = self.a / scale
  let scaled_b = self.b / scale
  let scaled_c = self.c / scale
  let scaled_d = self.d / scale
  let det = scaled_a * scaled_d - scaled_b * scaled_c
  guard det.abs() > 1.0e-12 else { None }
  let a = scaled_d / det / scale
  let b = -scaled_b / det / scale
  let c = -scaled_c / det / scale
  let d = scaled_a / det / scale
  let tx = -(a * self.tx + c * self.ty)
  let ty = -(b * self.tx + d * self.ty)
  guard tx.is_finite() && ty.is_finite() else { None }
  Some({ a, b, c, d, tx, ty, })
}

///|
test "affine composition distinguishes points from vectors" {
  let transform = Affine2::from_translation(10.0, 20.0) *
    Affine2::from_scale(2.0, 3.0)
  assert_eq(transform.transform_point(Vec2(1.0, 2.0)), Vec2(12.0, 26.0))
  assert_eq(transform.transform_vector(Vec2(1.0, 2.0)), Vec2(2.0, 6.0))
}

///|
test "affine inverse handles small reflected transforms" {
  let transform = Affine2::from_scale(-1.0e-20, 1.0e-20) *
    Affine2::from_skew(0.5, 0.0)
  let point = Vec2(3.0, 5.0)
  let actual = transform
    .inverse()
    .unwrap()
    .transform_point(transform.transform_point(point))
  assert_true(actual.distance(point) < 1.0e-10)
  assert_true(Affine2::from_scale(0.0, 1.0).inverse() is None)
}

///|
test "affine rotation composes with scale and translation" {
  let transform = Affine2::from_translation(10.0, 20.0) *
    Affine2::from_rotation_deg(90.0) *
    Affine2::from_scale(2.0, 3.0)
  let point = Vec2(2.0, 3.0)
  assert_true(
    transform.transform_point(point).distance(Vec2(1.0, 24.0)) < 1.0e-12,
  )
  assert_true(
    transform
    .inverse()
    .unwrap()
    .transform_point(Vec2(1.0, 24.0))
    .distance(point) <
    1.0e-12,
  )
  assert_eq(
    transform.with_translation(0.0, 0.0).transform_point(point),
    transform.transform_vector(point),
  )
}

///|
test "affine flips reflect around the middle of their extent" {
  assert_eq(
    Affine2::flip_x(100.0).transform_point(Vec2(10.0, 20.0)),
    Vec2(90.0, 20.0),
  )
  assert_eq(
    Affine2::flip_y(200.0).transform_point(Vec2(30.0, 40.0)),
    Vec2(30.0, 160.0),
  )
}
