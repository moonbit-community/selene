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
  a : Double   // scale_x * cos(rotation)
  b : Double   // scale_x * sin(rotation) + skew_y
  c : Double   // scale_y * -sin(rotation) + skew_x  
  d : Double   // scale_y * cos(rotation)
  tx : Double  // translation_x
  ty : Double  // translation_y
}

///|
/// Create identity transform
pub fn Transform::identity() -> Transform {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0 }
}

///|
/// Create transform from matrix components
pub fn Transform::new(
  a~ : Double = 1.0,
  b~ : Double = 0.0, 
  c~ : Double = 0.0,
  d~ : Double = 1.0,
  tx~ : Double = 0.0,
  ty~ : Double = 0.0
) -> Transform {
  { a, b, c, d, tx, ty }
}

///|
/// Create translation transform
pub fn Transform::from_translation(tx : Double, ty : Double) -> Transform {
  { a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx, ty }
}

///|
/// Create scale transform
pub fn Transform::from_scale(sx : Double, sy : Double) -> Transform {
  { a: sx, b: 0.0, c: 0.0, d: sy, tx: 0.0, ty: 0.0 }
}

///|
/// Create rotation transform (degrees)
pub fn Transform::from_rotation_deg(deg : Double) -> Transform {
  Transform::from_rotation_rad(deg * @math.PI / 180.0)
}

///|
/// Create rotation transform (radians)
pub fn Transform::from_rotation_rad(rad : Double) -> Transform {
  let cos_r = @math.cos(rad)
  let sin_r = @math.sin(rad)
  { a: cos_r, b: sin_r, c: -sin_r, d: cos_r, tx: 0.0, ty: 0.0 }
}

///|
/// Create skew transform
pub fn Transform::from_skew(kx : Double, ky : Double) -> Transform {
  { a: 1.0, b: ky, c: kx, d: 1.0, tx: 0.0, ty: 0.0 }
}

///|
/// Multiply two transforms (this * other)
pub fn Transform::multiply(self : Transform, other : Transform) -> Transform {
  {
    a: self.a * other.a + self.c * other.b,
    b: self.b * other.a + self.d * other.b,
    c: self.a * other.c + self.c * other.d,
    d: self.b * other.c + self.d * other.d,
    tx: self.a * other.tx + self.c * other.ty + self.tx,
    ty: self.b * other.tx + self.d * other.ty + self.ty
  }
}

///|
/// Apply transform to a point
pub fn Transform::apply_to_point(self : Transform, x : Double, y : Double) -> (Double, Double) {
  let new_x = self.a * x + self.c * y + self.tx
  let new_y = self.b * x + self.d * y + self.ty
  (new_x, new_y)
}

///|
/// Get translation values
pub fn Transform::get_translation(self : Transform) -> (Double, Double) {
  (self.tx, self.ty)
}

///|
/// Set translation values
pub fn Transform::set_translation(self : Transform, tx : Double, ty : Double) -> Transform {
  { a: self.a, b: self.b, c: self.c, d: self.d, tx, ty }
}

///|
/// Get scale values (ignoring rotation)
pub fn Transform::get_scale(self : Transform) -> (Double, Double) {
  let sx = (self.a * self.a + self.b * self.b).sqrt()
  let sy = (self.c * self.c + self.d * self.d).sqrt()
  (sx, sy)
}

///|
/// Set scale values (preserving rotation)
pub fn Transform::set_scale(self : Transform, sx : Double, sy : Double) -> Transform {
  let current_rotation = self.get_rotation_rad()
  let cos_r = @math.cos(current_rotation)
  let sin_r = @math.sin(current_rotation)
  {
    a: sx * cos_r,
    b: sx * sin_r,
    c: -sy * sin_r,
    d: sy * cos_r,
    tx: self.tx,
    ty: self.ty
  }
}

///|
/// Get rotation angle in radians
pub fn Transform::get_rotation_rad(self : Transform) -> Double {
  @math.atan2(self.b, self.a)
}

///|
/// Set rotation angle (preserving scale)
pub fn Transform::set_rotation_rad(self : Transform, rad : Double) -> Transform {
  let (sx, sy) = self.get_scale()
  let cos_r = @math.cos(rad)
  let sin_r = @math.sin(rad)
  {
    a: sx * cos_r,
    b: sx * sin_r,
    c: -sy * sin_r,
    d: sy * cos_r,
    tx: self.tx,
    ty: self.ty
  }
}

///|
/// Calculate inverse transform
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
      ty: (self.b * self.tx - self.a * self.ty) * inv_det
    })
  }
}

///|
/// Flip transform horizontally
pub fn Transform::flip_x(width : Double) -> Transform {
  Transform::from_scale(-1.0, 1.0).multiply(Transform::from_translation(width, 0.0))
}

///|
/// Add two transforms (matrix addition)
pub impl Add for Transform with op_add(self : Transform, other : Transform) -> Transform {
  {
    a: self.a + other.a,
    b: self.b + other.b,
    c: self.c + other.c,
    d: self.d + other.d,
    tx: self.tx + other.tx,
    ty: self.ty + other.ty
  }
}

///|
/// Subtract two transforms (matrix subtraction)
pub impl Sub for Transform with op_sub(self : Transform, other : Transform) -> Transform {
  {
    a: self.a - other.a,
    b: self.b - other.b,
    c: self.c - other.c,
    d: self.d - other.d,
    tx: self.tx - other.tx,
    ty: self.ty - other.ty
  }
}

///|
/// Multiply two transforms (matrix multiplication, same as compose)
pub impl Mul for Transform with op_mul(self : Transform, other : Transform) -> Transform {
  self.multiply(other)
}
