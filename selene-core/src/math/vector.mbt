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
pub(all) struct Vec2D {
  mut x : Double
  mut y : Double
} derive(Eq, Show)

///|
pub fn Vec2D::new(x : Double, y : Double) -> Vec2D {
  { x, y }
}

pub fn Vec2D::zero() -> Vec2D {
  Vec2D::new(0.0, 0.0)
}

///|
pub fn Vec2D::op_get(this : Vec2D, axis : Axis) -> Double {
  match axis {
    X => this.x
    Y => this.y
  }
}

///|
pub fn Vec2D::op_set(this : Vec2D, axis : Axis, value : Double) -> Unit {
  match axis {
    X => this.x = value
    Y => this.y = value
  }
}

///|
pub impl Add for Vec2D with op_add(this, other) {
  Vec2D::new(this.x + other.x, this.y + other.y)
}

///|
pub impl Mul for Vec2D with op_mul(this, other) {
  Vec2D::new(this.x * other.x, this.y * other.y)
}

///|
pub impl Neg for Vec2D with op_neg(this) {
  Vec2D::new(-this.x, -this.y)
}

///|
pub impl Sub for Vec2D with op_sub(this, other) {
  Vec2D::new(this.x - other.x, this.y - other.y)
}

///|
pub fn Vec2D::distance(this : Vec2D) -> Double {
  (this.x * this.x + this.y * this.y).sqrt()
}

///|
pub fn Vec2D::dot(this : Vec2D, other : Vec2D) -> Double {
  this.x * other.x + this.y * other.y
}

///|
pub fn Vec2D::distance_to(this : Vec2D, other : Vec2D) -> Double {
  ((this.x - other.x) * (this.x - other.x) +
  (this.y - other.y) * (this.y - other.y)).sqrt()
}

///|
pub fn Vec2D::normalize(this : Vec2D) -> Vec2D {
  let mag = this.distance()
  if mag > 0.0 {
    Vec2D::new(this.x / mag, this.y / mag)
  } else {
    Vec2D::new(1.0, 0.0) // Default direction if magnitude is zero
  }
}
