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
/// Coordinate axis in 2D space.
///
/// Constructors:
///
/// * `X` : The horizontal axis
/// * `Y` : The vertical axis
///
pub(all) enum Axis {
  X
  Y
} derive(Eq, Show)

///|
/// 2D vector with x and y components.
///
/// Fields:
///
/// * `0` : The x component of the vector.
/// * `1` : The y component of the vector.
///
/// Example:
///
/// ```moonbit
/// let v1 = @math.Vec2D(3.0, 4.0)
/// let v2 = @math.Vec2D::zero()
/// inspect(v1[X], content="3")
/// inspect(v1[Y], content="4")
/// inspect(v2[X], content="0")
/// inspect(v2[Y], content="0")
/// ```
///
pub(all) struct Vec2D(Double, Double) derive(Eq, Show)

///|
pub fn Vec2D::zero() -> Vec2D {
  Vec2D(0.0, 0.0)
}

///|
pub fn Vec2D::op_get(this : Vec2D, axis : Axis) -> Double {
  match axis {
    X => this.0
    Y => this.1
  }
}

///|
/// Creates a new vector with the specified component updated to a new value.
///
/// Parameters:
///
/// * `this` : The original vector to update.
/// * `axis` : The coordinate axis to update (`X` for horizontal, `Y` for
///   vertical).
/// * `value` : The new value to set for the specified axis.
///
/// Returns a new `Vec2D` with the specified component updated while keeping the
/// other component unchanged.
///
/// Example:
///
/// ```moonbit
/// let v = @math.Vec2D(3.0, 4.0)
/// let updated_x = v.update(X, 10.0)
/// let updated_y = v.update(Y, 20.0)
/// inspect(updated_x, content="Vec2D(10, 4)")
/// inspect(updated_y, content="Vec2D(3, 20)")
/// ```
///
pub fn Vec2D::update(this : Vec2D, axis : Axis, value : Double) -> Vec2D {
  match axis {
    X => Vec2D(value, this.1)
    Y => Vec2D(this.0, value)
  }
}

///|
pub fn Vec2D::clone(self : Vec2D) -> Vec2D {
  Vec2D(self.0, self.1)
}

///|
pub impl Add for Vec2D with add(this, other) {
  Vec2D(this.0 + other.0, this.1 + other.1)
}

///|
pub impl Mul for Vec2D with mul(this, other) {
  Vec2D(this.0 * other.0, this.1 * other.1)
}

///|
pub impl Neg for Vec2D with neg(this) {
  Vec2D(-this.0, -this.1)
}

///|
pub impl Sub for Vec2D with sub(this, other) {
  Vec2D(this.0 - other.0, this.1 - other.1)
}

///|
pub fn Vec2D::scalar_mul(this : Vec2D, scalar : Double) -> Vec2D {
  Vec2D(this.0 * scalar, this.1 * scalar)
}

///|
pub fn Vec2D::scalar_div(this : Vec2D, scalar : Double) -> Vec2D {
  Vec2D(this.0 / scalar, this.1 / scalar)
}

///|
/// Calculates the magnitude (length) of the vector.
///
/// Parameters:
///
/// * `this` : The vector to calculate the magnitude for.
///
/// Returns the magnitude of the vector as a `Double` value.
///
/// Example:
///
/// ```moonbit
/// let v = @math.Vec2D(3.0, 4.0)
/// inspect(v.distance(), content="5") // sqrt(3² + 4²) = 5
/// ```
///
pub fn Vec2D::distance(this : Vec2D) -> Double {
  (this.0 * this.0 + this.1 * this.1).sqrt()
}

///|
/// Calculates the dot product of two 2D vectors.
///
/// Parameters:
///
/// * `this` : The first vector.
/// * `other` : The second vector.
///
/// Returns the dot product as a `Double` value.
///
/// Example:
///
/// ```moonbit
/// let v1 = @math.Vec2D(3.0, 4.0)
/// let v2 = @math.Vec2D(2.0, 1.0)
/// inspect(v1.dot(v2), content="10") // 3*2 + 4*1 = 10
/// ```
///
pub fn Vec2D::dot(this : Vec2D, other : Vec2D) -> Double {
  this.0 * other.0 + this.1 * other.1
}

///|
/// Calculates the Euclidean distance between this vector and another vector.
///
/// Parameters:
///
/// * `this` : The first vector (starting point).
/// * `other` : The second vector (ending point).
///
/// Returns the Euclidean distance between the two vectors as a `Double`.
///
/// Example:
///
/// ```moonbit
/// let v1 = @math.Vec2D(0.0, 0.0)
/// let v2 = @math.Vec2D(3.0, 4.0)
/// inspect(v1.distance_to(v2), content="5")
/// ```
///
pub fn Vec2D::distance_to(this : Vec2D, other : Vec2D) -> Double {
  ((this.0 - other.0) * (this.0 - other.0) +
  (this.1 - other.1) * (this.1 - other.1)).sqrt()
}

///|
/// Normalizes the vector to a unit vector with magnitude 1.
///
/// Parameters:
///
/// * `this` : The vector to normalize.
///
/// Returns a new `Vec2D` representing the unit vector in the same direction as
/// the original vector. If the original vector has zero magnitude, returns a
/// zero vector `Vec2D(0.0, 0.0)`.
///
/// Example:
///
/// ```moonbit
/// let v = @math.Vec2D(3.0, 4.0)
/// let normalized = v.normalize()
/// inspect(normalized.distance(), content="1") // Unit vector has magnitude 1
/// ```
///
pub fn Vec2D::normalize(this : Vec2D) -> Vec2D {
  let mag = this.distance()
  if mag > 0.0 {
    Vec2D(this.0 / mag, this.1 / mag)
  } else {
    Vec2D(0.0, 0.0) // Default direction if magnitude is zero
  }
}
