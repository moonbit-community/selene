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

/// Physics Components following Selene ECS pattern

///| Rigid body component - contains mass and body type
pub struct RigidBody {
  body_type : BodyType
  mass : Double
  inv_mass : Double
  inertia : Double
  inv_inertia : Double
  linear_damping : Double
  angular_damping : Double
  gravity_scale : Double
} derive(Show)

///| Physics velocity component (separate from regular velocity for physics-specific behavior)
pub struct PhysicsVelocity {
  linear : @smath.Vec2D
  angular : Double
} derive(Show)

///| Forces and torque component
pub struct Forces {
  force : @smath.Vec2D
  torque : Double
} derive(Show)

///| Angular position component (angle rotation)
pub struct AngularPosition(Double) derive(Show)

///| Global component maps following Selene pattern
pub let rigid_bodies : Map[@system.Entity, RigidBody] = Map::new()

///|
pub let physics_velocities : Map[@system.Entity, PhysicsVelocity] = Map::new()

///|
pub let forces : Map[@system.Entity, Forces] = Map::new()

///|
pub let angular_positions : Map[@system.Entity, AngularPosition] = Map::new()

///| Helper constructors
pub fn RigidBody::new(body_type : BodyType, mass : Double) -> RigidBody {
  let inv_mass = if body_type == Dynamic && mass > 0.0 {
    1.0 / mass
  } else {
    0.0
  }
  let inv_inertia = if body_type == Dynamic && mass > 0.0 {
    1.0 / mass
  } else {
    0.0
  }
  {
    body_type,
    mass,
    inv_mass,
    inertia: mass,
    inv_inertia,
    linear_damping: 0.0,
    angular_damping: 0.0,
    gravity_scale: 1.0,
  }
}

///|
test "RigidBody::new should create dynamic body correctly" {
  let body = RigidBody::new(Dynamic, 2.0)
  assert_true(body.body_type == Dynamic)
  assert_true(body.mass == 2.0)
  assert_true(body.inv_mass == 0.5)
  assert_true(body.inertia == 2.0)
  assert_true(body.inv_inertia == 0.5)
  assert_true(body.linear_damping == 0.0)
  assert_true(body.angular_damping == 0.0)
  assert_true(body.gravity_scale == 1.0)
}

///|
test "RigidBody::new should create static body correctly" {
  let body = RigidBody::new(Static, 1.0)
  assert_true(body.body_type == Static)
  assert_true(body.mass == 1.0)
  assert_true(body.inv_mass == 0.0) // Static bodies have zero inverse mass
  assert_true(body.inv_inertia == 0.0) // Static bodies have zero inverse inertia
}

///|
pub fn PhysicsVelocity::new(
  linear : @smath.Vec2D,
  angular : Double,
) -> PhysicsVelocity {
  { linear, angular }
}

///|
pub fn PhysicsVelocity::zero() -> PhysicsVelocity {
  { linear: @smath.Vec2D(0.0, 0.0), angular: 0.0 }
}

///|
test "PhysicsVelocity constructors should work correctly" {
  let vel = PhysicsVelocity::new(@smath.Vec2D(3.0, 4.0), 1.5)
  assert_true(vel.linear[X] == 3.0 && vel.linear[Y] == 4.0)
  assert_true(vel.angular == 1.5)
  let zero_vel = PhysicsVelocity::zero()
  assert_true(zero_vel.linear[X] == 0.0 && zero_vel.linear[Y] == 0.0)
  assert_true(zero_vel.angular == 0.0)
}

///|
pub fn Forces::new(force : @smath.Vec2D, torque : Double) -> Forces {
  { force, torque }
}

///|
pub fn Forces::zero() -> Forces {
  { force: @smath.Vec2D(0.0, 0.0), torque: 0.0 }
}

///|
pub fn AngularPosition::new(angle : Double) -> AngularPosition {
  AngularPosition(angle)
}

///|
pub fn AngularPosition::zero() -> AngularPosition {
  AngularPosition(0.0)
}

///|
pub fn AngularPosition::get(self : AngularPosition) -> Double {
  self.0
}

///|
test "AngularPosition should work correctly" {
  let pos = AngularPosition::new(1.57) // ~π/2
  assert_true(pos.get() == 1.57)
  let zero_pos = AngularPosition::zero()
  assert_true(zero_pos.get() == 0.0)
}
