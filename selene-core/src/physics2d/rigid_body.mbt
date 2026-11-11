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
pub fn rigid_body_handle(entity : @ecs.Entity) -> RigidBodyHandle? {
  @collision.rigid_body_handle(entity)
}

///|
pub fn rigid_body_translation(entity : @ecs.Entity) -> @math.Vec2? {
  @collision.rigid_body_translation(entity)
}

///|
pub fn set_rigid_body_translation(
  entity : @ecs.Entity,
  translation : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_translation(entity, translation)
}

///|
pub fn rigid_body_rotation(entity : @ecs.Entity) -> Double? {
  @collision.rigid_body_rotation(entity)
}

///|
pub fn set_rigid_body_rotation(entity : @ecs.Entity, rotation : Double) -> Unit {
  @collision.set_rigid_body_rotation(entity, rotation)
}

///|
pub fn rigid_body_linear_velocity(entity : @ecs.Entity) -> @math.Vec2? {
  @collision.rigid_body_linear_velocity(entity)
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @ecs.Entity,
  linear_velocity : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_linear_velocity(entity, linear_velocity)
}

///|
pub fn rigid_body_angular_velocity(entity : @ecs.Entity) -> Double? {
  @collision.rigid_body_angular_velocity(entity)
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @ecs.Entity,
  angular_velocity : Double,
) -> Unit {
  @collision.set_rigid_body_angular_velocity(entity, angular_velocity)
}

///|
pub fn add_force(
  entity : @ecs.Entity,
  force : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_force(entity, force, wake_up~)
}

///|
pub fn add_force_at_point(
  entity : @ecs.Entity,
  force : @math.Vec2,
  point : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_force_at_point(entity, force, point, wake_up~)
}

///|
pub fn add_torque(
  entity : @ecs.Entity,
  torque : Double,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_torque(entity, torque, wake_up~)
}

///|
pub fn apply_impulse(
  entity : @ecs.Entity,
  impulse : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_impulse(entity, impulse, wake_up~)
}

///|
pub fn apply_impulse_at_point(
  entity : @ecs.Entity,
  impulse : @math.Vec2,
  point : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_impulse_at_point(entity, impulse, point, wake_up~)
}

///|
pub fn apply_torque_impulse(
  entity : @ecs.Entity,
  impulse : Double,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_torque_impulse(entity, impulse, wake_up~)
}

///|
pub fn reset_forces(entity : @ecs.Entity, wake_up~ : Bool = true) -> Unit {
  @collision.reset_forces(entity, wake_up~)
}

///|
pub fn reset_torques(entity : @ecs.Entity, wake_up~ : Bool = true) -> Unit {
  @collision.reset_torques(entity, wake_up~)
}
