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

///| Physics constants
pub let gravity_scale : Double = 1.0

///|
pub let linear_slop : Double = 0.005

///|
pub let angular_slop : Double = 2.0 / 180.0 * @math.PI

///|
pub let max_linear_velocity : Double = 200.0

///|
pub let max_angular_velocity : Double = 250.0

///| 2x2 Matrix for physics calculations
pub struct Mat22 {
  ex : @smath.Vec2D // first column
  ey : @smath.Vec2D // second column
} derive(Show)

///|
pub fn Mat22::new(ex : @smath.Vec2D, ey : @smath.Vec2D) -> Mat22 {
  { ex, ey }
}

///|
pub fn Mat22::from_angle(angle : Double) -> Mat22 {
  let c = @math.cos(angle)
  let s = @math.sin(angle)
  { ex: @smath.Vec2D(c, s), ey: @smath.Vec2D(-s, c) }
}

///|
pub fn Mat22::identity() -> Mat22 {
  { ex: @smath.Vec2D(1.0, 0.0), ey: @smath.Vec2D(0.0, 1.0) }
}

///|
pub fn Mat22::transpose(self : Mat22) -> Mat22 {
  {
    ex: @smath.Vec2D(self.ex[X], self.ey[X]),
    ey: @smath.Vec2D(self.ex[Y], self.ey[Y]),
  }
}

///|
test "Mat22::transpose should transpose matrix correctly" {
  let m = Mat22::new(@smath.Vec2D(1.0, 2.0), @smath.Vec2D(3.0, 4.0))
  let transposed = m.transpose()
  assert_true(
    transposed.ex[X] == 1.0 &&
    transposed.ex[Y] == 3.0 &&
    transposed.ey[X] == 2.0 &&
    transposed.ey[Y] == 4.0,
  )
}

///|
pub fn Mat22::mul_vec(self : Mat22, v : @smath.Vec2D) -> @smath.Vec2D {
  @smath.Vec2D(
    self.ex[X] * v[X] + self.ey[X] * v[Y],
    self.ex[Y] * v[X] + self.ey[Y] * v[Y],
  )
}

///|
test "Mat22::mul_vec should multiply matrix by vector correctly" {
  let m = Mat22::new(@smath.Vec2D(2.0, 0.0), @smath.Vec2D(0.0, 3.0))
  let v = @smath.Vec2D(1.0, 2.0)
  let result = m.mul_vec(v)
  assert_true(result[X] == 2.0 && result[Y] == 6.0)
}

///|
pub fn Mat22::mul_mat(self : Mat22, other : Mat22) -> Mat22 {
  { ex: self.mul_vec(other.ex), ey: self.mul_vec(other.ey) }
}

///| Rotation represented as complex number (cos + i*sin)
pub struct Rot {
  s : Double // sin
  c : Double // cos
} derive(Show)

///|
pub fn Rot::new(angle : Double) -> Rot {
  { s: @math.sin(angle), c: @math.cos(angle) }
}

///|
test "Rot::new should create rotation from angle correctly" {
  let rot = Rot::new(0.0)
  assert_true(rot.c == 1.0 && rot.s == 0.0)
  let rot90 = Rot::new(@math.PI / 2.0)
  assert_true(rot90.c * rot90.c < 0.0001) // cos(π/2) ≈ 0
  assert_true((rot90.s - 1.0) * (rot90.s - 1.0) < 0.0001) // sin(π/2) ≈ 1
}

///|
pub fn Rot::identity() -> Rot {
  { s: 0.0, c: 1.0 }
}

///|
pub fn Rot::get_angle(self : Rot) -> Double {
  @math.atan2(self.s, self.c)
}

///|
pub fn Rot::get_x_axis(self : Rot) -> @smath.Vec2D {
  @smath.Vec2D(self.c, self.s)
}

///|
pub fn Rot::get_y_axis(self : Rot) -> @smath.Vec2D {
  @smath.Vec2D(-self.s, self.c)
}

///|
pub fn Rot::mul_vec(self : Rot, v : @smath.Vec2D) -> @smath.Vec2D {
  @smath.Vec2D(self.c * v[X] - self.s * v[Y], self.s * v[X] + self.c * v[Y])
}

///|
pub fn Rot::mul_rot(self : Rot, other : Rot) -> Rot {
  {
    s: self.s * other.c + self.c * other.s,
    c: self.c * other.c - self.s * other.s,
  }
}

///| Physics transform (translation + rotation)
pub struct PhysicsTransform {
  p : @smath.Vec2D // position
  q : Rot // rotation
} derive(Show)

///|
pub fn PhysicsTransform::new(
  position : @smath.Vec2D,
  rotation : Rot,
) -> PhysicsTransform {
  { p: position, q: rotation }
}

///|
pub fn PhysicsTransform::identity() -> PhysicsTransform {
  { p: @smath.Vec2D(0.0, 0.0), q: Rot::identity() }
}

///|
pub fn PhysicsTransform::mul_vec(
  self : PhysicsTransform,
  v : @smath.Vec2D,
) -> @smath.Vec2D {
  self.q.mul_vec(v) + self.p
}

///|
pub fn PhysicsTransform::mul_transform(
  self : PhysicsTransform,
  other : PhysicsTransform,
) -> PhysicsTransform {
  { p: self.mul_vec(other.p), q: self.q.mul_rot(other.q) }
}

///| Mass data for a shape
pub struct MassData {
  mass : Double
  center : @smath.Vec2D
  inertia : Double // rotational inertia about center
} derive(Show)

///| Cross product helpers for 2D
pub fn cross_vec_vec(a : @smath.Vec2D, b : @smath.Vec2D) -> Double {
  a[X] * b[Y] - a[Y] * b[X]
}

///|
test "cross_vec_vec should compute 2D cross product correctly" {
  let a = @smath.Vec2D(2.0, 3.0)
  let b = @smath.Vec2D(4.0, 5.0)
  let result = cross_vec_vec(a, b)
  assert_true(result == -2.0) // 2*5 - 3*4 = 10 - 12 = -2
  let x_axis = @smath.Vec2D(1.0, 0.0)
  let y_axis = @smath.Vec2D(0.0, 1.0)
  assert_true(cross_vec_vec(x_axis, y_axis) == 1.0)
}

///|
pub fn cross_vec_scalar(a : @smath.Vec2D, s : Double) -> @smath.Vec2D {
  @smath.Vec2D(s * a[Y], -s * a[X])
}

///|
pub fn cross_scalar_vec(s : Double, a : @smath.Vec2D) -> @smath.Vec2D {
  @smath.Vec2D(-s * a[Y], s * a[X])
}

///| Clamp value between min and max
pub fn clamp(value : Double, min : Double, max : Double) -> Double {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///| Linear interpolation
pub fn lerp(a : Double, b : Double, t : Double) -> Double {
  a + t * (b - a)
}
