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
pub(all) enum Axis {
  X
  Y
} derive(Eq, Show)

///|
pub(all) struct Vec2D(Double,Double) derive(Eq, Show)

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
pub fn Vec2D::update(this : Vec2D, axis : Axis, value : Double) -> Vec2D {
  match axis {
    X => Vec2D(value, this.1)
    Y => Vec2D(this.0, value)
  }
}

///|
pub impl Add for Vec2D with op_add(this, other) {
  Vec2D(this.0 + other.0, this.1 + other.1)
}

///|
pub impl Mul for Vec2D with op_mul(this, other) {
  Vec2D(this.0 * other.0, this.1 * other.1)
}

///|
pub impl Neg for Vec2D with op_neg(this) {
  Vec2D(-this.0, -this.1)
}

///|
pub impl Sub for Vec2D with op_sub(this, other) {
  Vec2D(this.0 - other.0, this.1 - other.1)
}

///|
pub fn Vec2D::distance(this : Vec2D) -> Double {
  (this.0 * this.0 + this.1 * this.1).sqrt()
}

///|
pub fn Vec2D::dot(this : Vec2D, other : Vec2D) -> Double {
  this.0 * other.0 + this.1 * other.1
}

///|
pub fn Vec2D::distance_to(this : Vec2D, other : Vec2D) -> Double {
  ((this.0 - other.0) * (this.0 - other.0) +
  (this.1 - other.1) * (this.1 - other.1)).sqrt()
}

///|
pub fn Vec2D::normalize(this : Vec2D) -> Vec2D {
  let mag = this.distance()
  if mag > 0.0 {
    Vec2D(this.0 / mag, this.1 / mag)
  } else {
    Vec2D(1.0, 0.0) // Default direction if magnitude is zero
  }
}
