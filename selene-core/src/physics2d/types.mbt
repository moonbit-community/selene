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
/// Rigid-body mode enum.
pub type RigidBodyType = @collision.RigidBodyType

///|
/// Explicit 2D rigid-body descriptor.
pub type RigidBody = @collision.RigidBody

///|
/// Native Rapier rigid-body handle.
pub type RigidBodyHandle = @collision.RigidBodyHandle

///|
/// Native Rapier collider handle.
pub type ColliderHandle = @collision.ColliderHandle

///|
/// Authored 2D joint motor model.
pub type JointMotorModel = @collision.JointMotorModel

///|
/// Optional scalar joint limits.
pub type JointLimits = @collision.JointLimits

///|
/// Optional joint softness coefficients.
pub type JointSoftness = @collision.JointSoftness

///|
/// Revolute joint motor descriptor.
pub type JointMotor = @collision.JointMotor

///|
/// 2D joint kind enum.
pub type JointKind = @collision.JointKind

///|
/// Authored 2D joint component.
pub type Joint = @collision.Joint

///|
/// Native Rapier impulse-joint handle.
pub type JointHandle = @collision.JointHandle

///|
/// 2D multibody joint kind enum.
pub type MultibodyJointKind = @collision.MultibodyJointKind

///|
/// Authored 2D multibody joint component.
pub type MultibodyJoint = @collision.MultibodyJoint

///|
/// Native Rapier multibody-joint handle.
pub type MultibodyJointHandle = @collision.MultibodyJointHandle

///|
/// Native Rapier multibody link identifier.
pub type MultibodyLinkId = @collision.MultibodyLinkId

///|
/// Spatial query body-type filter.
pub type SpatialQueryBodyFilter = @collision.SpatialQueryBodyFilter

///|
/// Spatial query filter translated to Rapier predicates.
pub type SpatialQueryFilter = @collision.SpatialQueryFilter

///|
/// 2D linear velocity component.
pub type LinearVelocity = @velocity.Velocity

///|
/// Backward-compatible velocity alias.
pub using @velocity {type Velocity}

///|
/// Collider component.
pub using @collision {type Collider}

///|
/// Sensor area component.
pub type Sensor = @collision.Area

///|
/// Backward-compatible area alias.
pub using @collision {type Area}

///|
/// Collision shape component.
pub type ColliderShape = @collision.CollisionShape

///|
/// Backward-compatible shape alias.
pub type CollisionShape = @collision.CollisionShape

///|
/// Collision layer/filter descriptor.
pub type CollisionLayers = @collision.CollisionFilter

///|
/// Backward-compatible filter alias.
pub using @collision {type CollisionFilter}

///|
/// Collision group id.
pub using @collision {type CollisionGroup}

///|
/// Physics config descriptor.
pub type PhysicsConfig = @collision.PhysicsConfig

///|
/// Collision event for frame-local contact data.
pub type CollisionEvent = @collision.ContactEvent

///|
/// Backward-compatible contact event alias.
pub type ContactEvent = @collision.ContactEvent

///|
/// Sensor enter/exit event.
pub type SensorEvent = @collision.TriggerEvent

///|
/// 2D raycast hit payload.
pub type RaycastHit = @collision.RaycastHit

///|
/// 2D shape-cast hit payload.
pub type ShapeCastHit = @collision.ShapeCastHit

///|
/// Backward-compatible trigger event alias.
pub type TriggerEvent = @collision.TriggerEvent

///|
/// Pointer interaction component.
pub type Pickable = @collision.Pickable

///|
/// Pointer phase enum.
pub type PointerPhase = @collision.PointerPhase

///|
/// Pointer event record.
pub type PointerEvent = @collision.PointerEvent

///|
pub type PhysicsMotion = @collision.PhysicsMotion

///|
pub type PhysicsStep2D = @collision.PhysicsStep2D

///|
pub type CollisionQueries = @collision.CollisionQueries
