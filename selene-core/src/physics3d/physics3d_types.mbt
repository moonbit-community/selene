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
pub(all) enum RigidBody {
  Dynamic
  Fixed
  KinematicPositionBased
  KinematicVelocityBased
} derive(Eq, Debug)

///|
pub(all) struct Velocity {
  linvel : @math.Vec3
  angvel : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct Damping {
  linear_damping : Double
  angular_damping : Double
} derive(Eq, Debug)

///|
pub(all) struct GravityScale(Double) derive(Eq, Debug)

///|
pub(all) struct LockedAxes {
  lock_translation_x : Bool
  lock_translation_y : Bool
  lock_translation_z : Bool
  lock_rotation_x : Bool
  lock_rotation_y : Bool
  lock_rotation_z : Bool
} derive(Eq, Debug)

///|
pub(all) struct Ccd {} derive(Eq, Debug)

///|
pub(all) struct Dominance(Int) derive(Eq, Debug)

///|
pub(all) enum AdditionalMassProperties {
  Mass(Double)
  MassProperties(@core.MassProperties3)
}

///|
pub(all) enum Collider {
  Cuboid(@math.Vec3)
  Ball(Double)
  CapsuleX(Double, Double)
  CapsuleY(Double, Double)
  CapsuleZ(Double, Double)
  Cylinder(Double, Double)
  Cone(Double, Double)
  RoundCylinder(Double, Double, Double)
  Halfspace(@math.Vec3)
  ConvexHull(Array[@math.Vec3])
  TriMesh(Array[@math.Vec3], Array[(Int, Int, Int)])
  Heightfield(Array[Double], Int, Int, @math.Vec3)
} derive(Eq, Debug)

///|
pub(all) struct Sensor {} derive(Eq, Debug)

///|
pub(all) struct Friction(Double) derive(Eq, Debug)

///|
pub(all) struct Restitution(Double) derive(Eq, Debug)

///|
pub(all) struct CollisionGroups {
  memberships : Int
  filters : Int
} derive(Eq, Debug)

///|
pub(all) struct SolverGroups {
  memberships : Int
  filters : Int
} derive(Eq, Debug)

///|
pub(all) struct ContactForceEventThreshold(Double) derive(Eq, Debug)

///|
pub(all) enum ColliderMassProperties {
  Density(Double)
} derive(Eq, Debug)

///|
pub type RapierRigidBodyHandle = @dynamics.RigidBodyHandle

///|
pub type RapierColliderHandle = @collision.ColliderHandle3D

///|
pub type RapierImpulseJointHandle = @dynamics.JointHandle3DReal

///|
pub type RapierMultibodyJointHandle = @dynamics.MultibodyJointHandle

///|
pub type JointAxis = @dynamics.JointAxis3DReal

///|
pub type JointAxesMask = @dynamics.JointAxesMask3DReal

///|
pub type MotorModel = @dynamics.MotorModel

///|
pub type CharacterLength = @control.CharacterLength

///|
pub type CharacterAutostep = @control.CharacterAutostep

///|
pub(all) enum QueryFilterBody {
  All
  Dynamic
  Fixed
  Kinematic
} derive(Eq, Debug)

///|
pub(all) struct QueryFilter {
  groups : CollisionGroups?
  exclude_entity : @entity.Entity?
  exclude_collider : RapierColliderHandle?
  exclude_rigid_body : RapierRigidBodyHandle?
  exclude_sensors : Bool
  exclude_solids : Bool
  body_filter : QueryFilterBody
}
