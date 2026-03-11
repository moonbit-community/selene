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
/// Motor model used by joint motors and springs.
pub enum JointMotorModel {
  AccelerationBased
  ForceBased
} derive(Eq, Show)

///|
pub fn JointMotorModel::acceleration_based() -> JointMotorModel {
  AccelerationBased
}

///|
pub fn JointMotorModel::force_based() -> JointMotorModel {
  ForceBased
}

///|
/// Optional scalar lower/upper limits for a 2D joint axis.
pub struct JointLimits {
  min : Double
  max : Double
} derive(Eq, Show)

///|
pub fn JointLimits::new(min : Double, max : Double) -> JointLimits {
  { min, max }
}

///|
/// Softness parameters forwarded to Rapier spring-style joints.
pub struct JointSoftness {
  damping_ratio : Double
  natural_frequency : Double
} derive(Eq, Show)

///|
pub fn JointSoftness::new(
  damping_ratio : Double,
  natural_frequency : Double,
) -> JointSoftness {
  { damping_ratio, natural_frequency }
}

///|
/// Motor parameters for revolute joints.
pub enum JointMotor {
  Position(
    target_position~ : Double,
    stiffness~ : Double,
    damping~ : Double,
    max_force~ : Double?,
    model~ : JointMotorModel
  )
  Velocity(
    target_velocity~ : Double,
    damping~ : Double,
    max_force~ : Double?,
    model~ : JointMotorModel
  )
} derive(Eq, Show)

///|
pub fn JointMotor::position(
  target_position : Double,
  stiffness : Double,
  damping : Double,
  max_force? : Double,
  model? : JointMotorModel = AccelerationBased,
) -> JointMotor {
  Position(target_position~, stiffness~, damping~, max_force~, model~)
}

///|
pub fn JointMotor::velocity(
  target_velocity : Double,
  damping : Double,
  max_force? : Double,
  model? : JointMotorModel = AccelerationBased,
) -> JointMotor {
  Velocity(target_velocity~, damping~, max_force~, model~)
}

///|
/// Supported 2D joint descriptors backed by Rapier impulse joints.
pub enum JointKind {
  Fixed(local_anchor1~ : @math.Vec2D, local_anchor2~ : @math.Vec2D)
  Revolute(
    local_anchor1~ : @math.Vec2D,
    local_anchor2~ : @math.Vec2D,
    limits~ : JointLimits?,
    motor~ : JointMotor?,
    softness~ : JointSoftness?
  )
  Prismatic(
    axis~ : @math.Vec2D,
    local_anchor1~ : @math.Vec2D,
    local_anchor2~ : @math.Vec2D,
    limits~ : JointLimits?
  )
  Rope(
    max_distance~ : Double,
    local_anchor1~ : @math.Vec2D,
    local_anchor2~ : @math.Vec2D
  )
  Spring(
    rest_length~ : Double,
    stiffness~ : Double,
    damping~ : Double,
    local_anchor1~ : @math.Vec2D,
    local_anchor2~ : @math.Vec2D,
    model~ : JointMotorModel
  )
} derive(Eq, Show)

///|
/// Authored 2D joint component that connects two rigid-body entities.
pub struct Joint {
  entity1 : @entity.Entity
  entity2 : @entity.Entity
  kind : JointKind
  active : Bool
  contacts_enabled : Bool
} derive(Eq, Show)

///|
/// Native Rapier impulse-joint handle.
pub type JointHandle = @rapier_dynamics.ImpulseJointHandle

///|
/// Supported 2D multibody-joint descriptors backed by Rapier articulations.
pub enum MultibodyJointKind {
  Revolute(
    local_anchor1~ : @math.Vec2D,
    local_anchor2~ : @math.Vec2D,
    limits~ : JointLimits?,
    motor~ : JointMotor?,
    softness~ : JointSoftness?
  )
} derive(Eq, Show)

///|
/// Authored 2D multibody joint attached to the child rigid-body entity.
pub struct MultibodyJoint {
  parent : @entity.Entity
  kind : MultibodyJointKind
  active : Bool
} derive(Eq, Show)

///|
/// Native Rapier multibody-joint handle.
pub type MultibodyJointHandle = @rapier_dynamics.MultibodyJointHandle

///|
/// Native Rapier multibody link identifier for a rigid body in an articulation.
pub type MultibodyLinkId = @rapier_dynamics.MultibodyLinkId

///|
pub fn Joint::fixed(
  entity1 : @entity.Entity,
  entity2 : @entity.Entity,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  active? : Bool = true,
  contacts_enabled? : Bool = false,
) -> Joint {
  {
    entity1,
    entity2,
    kind: Fixed(local_anchor1~, local_anchor2~),
    active,
    contacts_enabled,
  }
}

///|
pub fn Joint::revolute(
  entity1 : @entity.Entity,
  entity2 : @entity.Entity,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  limits? : JointLimits,
  motor? : JointMotor,
  softness? : JointSoftness,
  active? : Bool = true,
  contacts_enabled? : Bool = false,
) -> Joint {
  {
    entity1,
    entity2,
    kind: Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~),
    active,
    contacts_enabled,
  }
}

///|
pub fn Joint::prismatic(
  entity1 : @entity.Entity,
  entity2 : @entity.Entity,
  axis : @math.Vec2D,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  limits? : JointLimits,
  active? : Bool = true,
  contacts_enabled? : Bool = false,
) -> Joint {
  {
    entity1,
    entity2,
    kind: Prismatic(axis~, local_anchor1~, local_anchor2~, limits~),
    active,
    contacts_enabled,
  }
}

///|
pub fn Joint::rope(
  entity1 : @entity.Entity,
  entity2 : @entity.Entity,
  max_distance : Double,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  active? : Bool = true,
  contacts_enabled? : Bool = false,
) -> Joint {
  {
    entity1,
    entity2,
    kind: Rope(max_distance~, local_anchor1~, local_anchor2~),
    active,
    contacts_enabled,
  }
}

///|
pub fn Joint::spring(
  entity1 : @entity.Entity,
  entity2 : @entity.Entity,
  rest_length : Double,
  stiffness : Double,
  damping : Double,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  model? : JointMotorModel = AccelerationBased,
  active? : Bool = true,
  contacts_enabled? : Bool = false,
) -> Joint {
  {
    entity1,
    entity2,
    kind: Spring(
      rest_length~,
      stiffness~,
      damping~,
      local_anchor1~,
      local_anchor2~,
      model~,
    ),
    active,
    contacts_enabled,
  }
}

///|
pub fn MultibodyJoint::revolute(
  parent : @entity.Entity,
  local_anchor1? : @math.Vec2D = @math.Vec2D::zero(),
  local_anchor2? : @math.Vec2D = @math.Vec2D::zero(),
  limits? : JointLimits,
  motor? : JointMotor,
  softness? : JointSoftness,
  active? : Bool = true,
) -> MultibodyJoint {
  {
    parent,
    kind: Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~),
    active,
  }
}

///|
priv struct JointWorldStore {
  joints : Map[@entity.Entity, Joint]
  multibody_joints : Map[@entity.Entity, MultibodyJoint]
}

///|
let joint_world_stores : Map[UInt, JointWorldStore] = Map::new()

///|
fn joint_world_store() -> JointWorldStore {
  let world_id = @ecs.require_current_world().id()
  joint_world_stores.get_or_init(world_id, () => {
    joints: Map::new(),
    multibody_joints: Map::new(),
  })
}

///|
/// Authored 2D joint components.
pub fn joints() -> Map[@entity.Entity, Joint] {
  joint_world_store().joints
}

///|
/// Authored 2D multibody joint components keyed by the child rigid-body entity.
pub fn multibody_joints() -> Map[@entity.Entity, MultibodyJoint] {
  joint_world_store().multibody_joints
}
