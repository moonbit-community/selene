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
/// 2D transformation matrix represented as:
/// [a  c  tx]
/// [b  d  ty]
/// [0  0  1 ]
/// where (tx, ty) is translation, and the 2x2 matrix handles rotation/scale/skew
///
pub(all) struct Transform {
  a : Double // scale_x * cos(rotation)
  b : Double // scale_x * sin(rotation) + skew_y
  c : Double // scale_y * -sin(rotation) + skew_x  
  d : Double // scale_y * cos(rotation)
  tx : Double // translation_x
  ty : Double // translation_y
}

///|
/// Creates a deep copy of the transform.
///
/// Parameters:
///
/// * `self` : The transform to clone.
///
/// Returns a new `Transform` instance with identical matrix values.
///
pub fn Transform::clone(self : Transform) -> Transform {
  { a: self.a, b: self.b, c: self.c, d: self.d, tx: self.tx, ty: self.ty }
}

///|
/// Create identity transform
/// 
pub fn Transform::identity() -> Transform {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0 }
}

///|
pub impl Default for Transform with default() -> Transform {
  Transform::identity()
}

///|
/// Create transform from matrix components
/// 
pub fn Transform::Transform(
  a? : Double = 1.0,
  b? : Double = 0.0,
  c? : Double = 0.0,
  d? : Double = 1.0,
  tx? : Double = 0.0,
  ty? : Double = 0.0,
) -> Transform {
  { a, b, c, d, tx, ty }
}

///|
/// Create translation transform
/// 
pub fn Transform::from_translation(tx : Double, ty : Double) -> Transform {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx, ty }
}

///|
/// Create scale transform
/// 
pub fn Transform::from_scale(sx : Double, sy : Double) -> Transform {
  { a: sx, b: 0.0, c: 0.0, d: sy, tx: 0.0, ty: 0.0 }
}

///|
/// Create rotation transform (degrees)
/// 
pub fn Transform::from_rotation_deg(deg : Double) -> Transform {
  Transform::from_rotation_rad(deg * @cmath.PI / 180.0)
}

///|
/// Create rotation transform (radians)
/// 
pub fn Transform::from_rotation_rad(rad : Double) -> Transform {
  let cos_r = @cmath.cos(rad)
  let sin_r = @cmath.sin(rad)
  { a: cos_r, b: sin_r, c: -sin_r, d: cos_r, tx: 0.0, ty: 0.0 }
}

///|
/// Create skew transform
/// 
pub fn Transform::from_skew(kx : Double, ky : Double) -> Transform {
  { a: 1.0, b: ky, c: kx, d: 1.0, tx: 0.0, ty: 0.0 }
}

///|
/// Multiply two transforms (this * other)
/// 
pub fn Transform::multiply(self : Transform, other : Transform) -> Transform {
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
/// Compose two transforms in left-to-right order (`self * other`).
/// This is equivalent to `multiply`.
pub fn Transform::compose(self : Transform, other : Transform) -> Transform {
  self.multiply(other)
}

///|
/// Prepend a transform (`other * self`).
///
/// This means `other` is applied after `self` in point space.
pub fn Transform::prepend(self : Transform, other : Transform) -> Transform {
  other * self
}

///|
/// Append a transform (`self * other`).
///
/// This means `other` is applied before `self` in point space.
pub fn Transform::append(self : Transform, other : Transform) -> Transform {
  self * other
}

///|
/// Apply transform to a point
/// 
pub fn Transform::apply_to_point(
  self : Transform,
  x : Double,
  y : Double,
) -> (Double, Double) {
  let new_x = self.a * x + self.c * y + self.tx
  let new_y = self.b * x + self.d * y + self.ty
  (new_x, new_y)
}

///|
pub fn Transform::apply_to_vec2(self : Transform, vec : Vec2) -> Vec2 {
  let p = self.apply_to_point(vec.0, vec.1)
  Vec2(p.0, p.1)
}

///|
/// Get translation values
/// 
pub fn Transform::get_translation(self : Transform) -> (Double, Double) {
  (self.tx, self.ty)
}

///|
/// Return a new transform with updated translation, keeping linear terms.
pub fn Transform::with_translation(
  self : Transform,
  tx : Double,
  ty : Double,
) -> Transform {
  { ..self, tx, ty }
}

///|
/// Alias of `with_translation`.
pub fn Transform::set_translation(
  self : Transform,
  tx : Double,
  ty : Double,
) -> Transform {
  self.with_translation(tx, ty)
}

///|
/// Prepend translation (`T * self`).
pub fn Transform::prepend_translation(
  self : Transform,
  tx : Double,
  ty : Double,
) -> Transform {
  Transform::from_translation(tx, ty) * self
}

///|
/// Append translation (`self * T`).
pub fn Transform::append_translation(
  self : Transform,
  tx : Double,
  ty : Double,
) -> Transform {
  self * Transform::from_translation(tx, ty)
}

///|
/// Get scale values (ignoring rotation)
/// 
pub fn Transform::get_scale(self : Transform) -> (Double, Double) {
  let sx = (self.a * self.a + self.b * self.b).sqrt()
  let sy = (self.c * self.c + self.d * self.d).sqrt()
  (sx, sy)
}

///|
/// Prepend scale (`S * self`).
pub fn Transform::prepend_scale(
  self : Transform,
  sx : Double,
  sy : Double,
) -> Transform {
  Transform::from_scale(sx, sy) * self
}

///|
/// Append scale (`self * S`).
pub fn Transform::append_scale(
  self : Transform,
  sx : Double,
  sy : Double,
) -> Transform {
  self * Transform::from_scale(sx, sy)
}

///|
/// Get rotation angle in radians
/// 
pub fn Transform::get_rotation_rad(self : Transform) -> Double {
  @cmath.atan2(self.b, self.a)
}

///|
/// Prepend rotation (`R * self`).
pub fn Transform::prepend_rotation_rad(
  self : Transform,
  rad : Double,
) -> Transform {
  Transform::from_rotation_rad(rad) * self
}

///|
/// Append rotation (`self * R`).
pub fn Transform::append_rotation_rad(
  self : Transform,
  rad : Double,
) -> Transform {
  self * Transform::from_rotation_rad(rad)
}

///|
/// Prepend rotation in degrees.
pub fn Transform::prepend_rotation_deg(
  self : Transform,
  deg : Double,
) -> Transform {
  self.prepend_rotation_rad(deg * @cmath.PI / 180.0)
}

///|
/// Append rotation in degrees.
pub fn Transform::append_rotation_deg(
  self : Transform,
  deg : Double,
) -> Transform {
  self.append_rotation_rad(deg * @cmath.PI / 180.0)
}

///|
/// Prepend skew (`K * self`).
pub fn Transform::prepend_skew(
  self : Transform,
  kx : Double,
  ky : Double,
) -> Transform {
  Transform::from_skew(kx, ky) * self
}

///|
/// Append skew (`self * K`).
pub fn Transform::append_skew(
  self : Transform,
  kx : Double,
  ky : Double,
) -> Transform {
  self * Transform::from_skew(kx, ky)
}

///|
/// Calculate inverse transform
/// 
pub fn Transform::inverse(self : Transform) -> Transform? {
  let det = self.a * self.d - self.b * self.c
  if det.abs() < 0.0000000001 {
    None
  } else {
    let inv_det = 1.0 / det
    Some({
      a: self.d * inv_det,
      b: -self.b * inv_det,
      c: -self.c * inv_det,
      d: self.a * inv_det,
      tx: (self.c * self.ty - self.d * self.tx) * inv_det,
      ty: (self.b * self.tx - self.a * self.ty) * inv_det,
    })
  }
}

///|
/// Flip transform horizontally
/// 
pub fn Transform::flip_x(width : Double) -> Transform {
  Transform::from_translation(width, 0.0) * Transform::from_scale(-1.0, 1.0)
}

///|
/// Flip transform vertically
/// 
pub fn Transform::flip_y(height : Double) -> Transform {
  Transform::from_translation(0.0, height) * Transform::from_scale(1.0, -1.0)
}

///|
/// Multiply two transforms (matrix multiplication, same as compose)
/// 
pub impl Mul for Transform with mul(self : Transform, other : Transform) -> Transform {
  self.multiply(other)
}

// Helper function to check if two doubles are approximately equal

///|
fn approx_eq(a : Double, b : Double, epsilon? : Double = 0.000001) -> Bool {
  (a - b).abs() < epsilon
}

// Helper function to check if two transforms are approximately equal

///|
fn transform_approx_eq(
  t1 : Transform,
  t2 : Transform,
  epsilon? : Double = 0.000001,
) -> Bool {
  approx_eq(t1.a, t2.a, epsilon~) &&
  approx_eq(t1.b, t2.b, epsilon~) &&
  approx_eq(t1.c, t2.c, epsilon~) &&
  approx_eq(t1.d, t2.d, epsilon~) &&
  approx_eq(t1.tx, t2.tx, epsilon~) &&
  approx_eq(t1.ty, t2.ty, epsilon~)
}

// Test identity transform

///|
test "Transform::identity creates identity matrix" {
  let identity = Transform::identity()
  let expected = Transform(a=1.0, b=0.0, c=0.0, d=1.0, tx=0.0, ty=0.0)
  assert_true(transform_approx_eq(identity, expected))
}

// Test translation transform

///|
test "Transform::from_translation creates correct translation matrix" {
  let translation = Transform::from_translation(10.0, 20.0)
  let expected = Transform(a=1.0, b=0.0, c=0.0, d=1.0, tx=10.0, ty=20.0)
  assert_true(transform_approx_eq(translation, expected))
}

// Test scale transform

///|
test "Transform::from_scale creates correct scale matrix" {
  let scale = Transform::from_scale(2.0, 3.0)
  let expected = Transform(a=2.0, b=0.0, c=0.0, d=3.0, tx=0.0, ty=0.0)
  assert_true(transform_approx_eq(scale, expected))
}

// Test rotation transform (90 degrees)

///|
test "Transform::from_rotation_deg creates correct rotation matrix" {
  let rotation = Transform::from_rotation_deg(90.0)
  // 90 degrees: cos(90°) = 0, sin(90°) = 1
  let expected = Transform(a=0.0, b=1.0, c=-1.0, d=0.0, tx=0.0, ty=0.0)
  assert_true(transform_approx_eq(rotation, expected))
}

// Test rotation transform (π/2 radians)

///|
test "Transform::from_rotation_rad creates correct rotation matrix" {
  let rotation = Transform::from_rotation_rad(@cmath.PI / 2.0)
  // π/2 radians: cos(π/2) = 0, sin(π/2) = 1
  let expected = Transform(a=0.0, b=1.0, c=-1.0, d=0.0, tx=0.0, ty=0.0)
  assert_true(transform_approx_eq(rotation, expected))
}

// Test skew transform

///|
test "Transform::from_skew creates correct skew matrix" {
  let skew = Transform::from_skew(0.5, 0.3)
  let expected = Transform(a=1.0, b=0.3, c=0.5, d=1.0, tx=0.0, ty=0.0)
  assert_true(transform_approx_eq(skew, expected))
}

// Test point transformation

///|
test "Transform::apply_to_point transforms points correctly" {
  let translation = Transform::from_translation(5.0, 10.0)
  let (x, y) = translation.apply_to_point(1.0, 2.0)
  assert_true(approx_eq(x, 6.0))
  assert_true(approx_eq(y, 12.0))
}

// Test scale point transformation

///|
test "Transform::apply_to_point with scale" {
  let scale = Transform::from_scale(2.0, 3.0)
  let (x, y) = scale.apply_to_point(4.0, 5.0)
  assert_true(approx_eq(x, 8.0))
  assert_true(approx_eq(y, 15.0))
}

// Test rotation point transformation (90 degrees)

///|
test "Transform::apply_to_point with rotation" {
  let rotation = Transform::from_rotation_deg(90.0)
  let (x, y) = rotation.apply_to_point(1.0, 0.0)
  assert_true(approx_eq(x, 0.0))
  assert_true(approx_eq(y, 1.0))
}

// Test matrix multiplication

///|
test "Transform::multiply composes transformations correctly" {
  let translation = Transform::from_translation(10.0, 20.0)
  let scale = Transform::from_scale(2.0, 3.0)
  let composed = translation.multiply(scale)

  // Test that composed transform applies both operations
  let (x, y) = composed.apply_to_point(1.0, 1.0)
  assert_true(approx_eq(x, 12.0)) // (1 * 2) + 10
  assert_true(approx_eq(y, 23.0)) // (1 * 3) + 20
}

// Test operator overloading - multiplication

///|
test "Transform * operator works correctly" {
  let translation = Transform::from_translation(5.0, 10.0)
  let scale = Transform::from_scale(2.0, 2.0)
  let composed1 = translation * scale
  let composed2 = translation.multiply(scale)
  assert_true(transform_approx_eq(composed1, composed2))
}

// Test explicit prepend/append order

///|
test "Transform::prepend and Transform::append have explicit order" {
  let base = Transform::from_scale(2.0, 2.0)
  let prepended = base.prepend_translation(10.0, 0.0)
  let appended = base.append_translation(10.0, 0.0)
  let (x1, y1) = prepended.apply_to_point(1.0, 0.0)
  let (x2, y2) = appended.apply_to_point(1.0, 0.0)
  assert_true(approx_eq(x1, 12.0))
  assert_true(approx_eq(y1, 0.0))
  assert_true(approx_eq(x2, 22.0))
  assert_true(approx_eq(y2, 0.0))
}

// Test direct translation update API

///|
test "Transform::with_translation updates translation only" {
  let base = Transform(a=1.2, b=0.3, c=0.4, d=1.5, tx=9.0, ty=8.0)
  let updated = base.with_translation(3.0, 4.0)
  assert_true(approx_eq(updated.a, 1.2))
  assert_true(approx_eq(updated.b, 0.3))
  assert_true(approx_eq(updated.c, 0.4))
  assert_true(approx_eq(updated.d, 1.5))
  assert_true(approx_eq(updated.tx, 3.0))
  assert_true(approx_eq(updated.ty, 4.0))
}

// Test get/set translation

///|
test "Transform get/set translation works correctly" {
  let transform = Transform::from_scale(2.0, 3.0)
  let (tx, ty) = transform.get_translation()
  assert_true(approx_eq(tx, 0.0))
  assert_true(approx_eq(ty, 0.0))
  let new_transform = transform.prepend_translation(10.0, 20.0)
  let (new_tx, new_ty) = new_transform.get_translation()
  assert_true(approx_eq(new_tx, 10.0))
  assert_true(approx_eq(new_ty, 20.0))

  // Ensure scale is preserved
  let (sx, sy) = new_transform.get_scale()
  assert_true(approx_eq(sx, 2.0))
  assert_true(approx_eq(sy, 3.0))
}

// Test get/set scale

///|
test "Transform get/set scale works correctly" {
  let transform = Transform::from_translation(10.0, 20.0)
  let (sx, sy) = transform.get_scale()
  assert_true(approx_eq(sx, 1.0))
  assert_true(approx_eq(sy, 1.0))
  let new_transform = transform.prepend_scale(2.0, 3.0)
  let (new_sx, new_sy) = new_transform.get_scale()
  assert_true(approx_eq(new_sx, 2.0))
  assert_true(approx_eq(new_sy, 3.0))
  let (tx, ty) = new_transform.get_translation()
  assert_true(approx_eq(tx, 20.0))
  assert_true(approx_eq(ty, 60.0))
}

// Test get/set rotation

///|
test "Transform get/set rotation works correctly" {
  let transform = Transform::from_scale(2.0, 3.0)
  let rotation = transform.get_rotation_rad()
  assert_true(approx_eq(rotation, 0.0))
  let new_transform = transform.prepend_rotation_rad(@cmath.PI / 4.0) // 45 degrees
  let new_rotation = new_transform.get_rotation_rad()
  assert_true(approx_eq(new_rotation, @cmath.PI / 4.0))

  // Ensure scale is preserved (approximately)
  let (sx, sy) = new_transform.get_scale()
  assert_true(approx_eq(sx, 2.0))
  assert_true(approx_eq(sy, 3.0))
}

// Test inverse transform

///|
test "Transform::inverse calculates correct inverse" {
  let translation = Transform::from_translation(10.0, 20.0)
  let inverse = translation.inverse()
  match inverse {
    Some(inv) => {
      let composed = translation * inv
      let identity = Transform::identity()
      assert_true(transform_approx_eq(composed, identity))
    }
    None => abort("Translation transform should be invertible")
  }
}

// Test inverse of rotation

///|
test "Transform::inverse with rotation" {
  let rotation = Transform::from_rotation_deg(45.0)
  let inverse = rotation.inverse()
  match inverse {
    Some(inv) => {
      let composed = rotation * inv
      let identity = Transform::identity()
      assert_true(transform_approx_eq(composed, identity))
    }
    None => abort("Rotation transform should be invertible")
  }
}

// Test inverse of non-invertible matrix

///|
test "Transform::inverse returns None for non-invertible matrix" {
  // Create a matrix with zero determinant (not invertible)
  let non_invertible = Transform(a=0.0, b=0.0, c=0.0, d=0.0, tx=0.0, ty=0.0)
  let inverse = non_invertible.inverse()
  match inverse {
    Some(_) => abort("Non-invertible matrix should return None")
    None => assert_true(true)
  }
}

// Test complex composition

///|
test "Complex transform composition" {
  let translation = Transform::from_translation(10.0, 5.0)
  let rotation = Transform::from_rotation_deg(90.0)
  let scale = Transform::from_scale(2.0, 3.0)

  // Compose: translate, then rotate, then scale
  let composed = translation * rotation * scale

  // Test with a point
  let (x, y) = composed.apply_to_point(1.0, 0.0)

  // Manual calculation:
  // 1. Scale 2x, 3x (1,0) -> (2,0)
  // 2. Rotate 90° (2,0) -> (0,2)
  // 3. Translate (0,2) -> (10,7)
  assert_true(approx_eq(x, 10.0))
  assert_true(approx_eq(y, 7.0))
}

// Test flip_x functionality

///|
test "Transform::flip_x creates correct horizontal flip" {
  let flip = Transform::flip_x(100.0)

  // Test a point transformation
  let (x, y) = flip.apply_to_point(10.0, 20.0)
  assert_true(approx_eq(x, 90.0)) // 100 - 10 = 90
  assert_true(approx_eq(y, 20.0)) // y unchanged
}

// Test flip_y functionality

///|
test "Transform::flip_y creates correct vertical flip" {
  let flip = Transform::flip_y(200.0)

  // Test a point transformation
  let (x, y) = flip.apply_to_point(30.0, 40.0)
  assert_true(approx_eq(x, 30.0)) // x unchanged
  assert_true(approx_eq(y, 160.0)) // 200 - 40 = 160
}
