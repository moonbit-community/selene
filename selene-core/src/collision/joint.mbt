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
#derive(Eq, Debug)
pub enum JointMotorModel {
  AccelerationBased
  ForceBased
}

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
#derive(Eq, Debug)
pub struct JointLimits {
  min : Double
  max : Double
}

///|
pub fn JointLimits::JointLimits(min : Double, max : Double) -> JointLimits {
  { min, max, }
}

///|
/// Softness parameters forwarded to Rapier spring-style joints.
#derive(Eq, Debug)
pub struct JointSoftness {
  damping_ratio : Double
  natural_frequency : Double
}

///|
pub fn JointSoftness::JointSoftness(
  damping_ratio : Double,
  natural_frequency : Double,
) -> JointSoftness {
  { damping_ratio, natural_frequency, }
}

///|
/// Motor parameters for revolute joints.
#derive(Eq, Debug)
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
}

///|
pub fn JointMotor::position(
  target_position : Double,
  stiffness : Double,
  damping : Double,
  max_force? : Double,
  model~ : JointMotorModel = AccelerationBased,
) -> JointMotor {
  Position(target_position~, stiffness~, damping~, max_force~, model~)
}

///|
pub fn JointMotor::velocity(
  target_velocity : Double,
  damping : Double,
  max_force? : Double,
  model~ : JointMotorModel = AccelerationBased,
) -> JointMotor {
  Velocity(target_velocity~, damping~, max_force~, model~)
}

///|
/// Supported 2D joint descriptors backed by Rapier impulse joints.
#derive(Eq, Debug)
pub enum JointKind {
  Fixed(local_anchor1~ : @math.Vec2, local_anchor2~ : @math.Vec2)
  Revolute(
    local_anchor1~ : @math.Vec2,
    local_anchor2~ : @math.Vec2,
    limits~ : JointLimits?,
    motor~ : JointMotor?,
    softness~ : JointSoftness?
  )
  Prismatic(
    axis~ : @math.Vec2,
    local_anchor1~ : @math.Vec2,
    local_anchor2~ : @math.Vec2,
    limits~ : JointLimits?
  )
  Rope(
    max_distance~ : Double,
    local_anchor1~ : @math.Vec2,
    local_anchor2~ : @math.Vec2
  )
  Spring(
    rest_length~ : Double,
    stiffness~ : Double,
    damping~ : Double,
    local_anchor1~ : @math.Vec2,
    local_anchor2~ : @math.Vec2,
    model~ : JointMotorModel
  )
}

///|
/// Authored 2D joint component that connects two rigid-body entities.
#derive(Eq, Debug)
pub struct Joint {
  entity1 : @ecs.Entity
  entity2 : @ecs.Entity
  kind : JointKind
  active : Bool
  contacts_enabled : Bool
}

///|
/// Native Rapier impulse-joint handle.
pub type JointHandle = @rapier_dynamics.ImpulseJointHandle

///|
/// Supported 2D multibody-joint descriptors backed by Rapier articulations.
#derive(Eq, Debug)
pub enum MultibodyJointKind {
  Revolute(
    local_anchor1~ : @math.Vec2,
    local_anchor2~ : @math.Vec2,
    limits~ : JointLimits?,
    motor~ : JointMotor?,
    softness~ : JointSoftness?
  )
}

///|
/// Authored 2D multibody joint attached to the child rigid-body entity.
#derive(Eq, Debug)
pub struct MultibodyJoint {
  parent : @ecs.Entity
  kind : MultibodyJointKind
  active : Bool
}

///|
/// Native Rapier multibody-joint handle.
pub type MultibodyJointHandle = @rapier_dynamics.MultibodyJointHandle

///|
/// Native Rapier multibody link identifier for a rigid body in an articulation.
pub type MultibodyLinkId = @rapier_dynamics.MultibodyLinkId

///|
pub fn Joint::fixed(
  entity1 : @ecs.Entity,
  entity2 : @ecs.Entity,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  active~ : Bool = true,
  contacts_enabled~ : Bool = false,
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
  entity1 : @ecs.Entity,
  entity2 : @ecs.Entity,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  limits? : JointLimits,
  motor? : JointMotor,
  softness? : JointSoftness,
  active~ : Bool = true,
  contacts_enabled~ : Bool = false,
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
  entity1 : @ecs.Entity,
  entity2 : @ecs.Entity,
  axis : @math.Vec2,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  limits? : JointLimits,
  active~ : Bool = true,
  contacts_enabled~ : Bool = false,
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
  entity1 : @ecs.Entity,
  entity2 : @ecs.Entity,
  max_distance : Double,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  active~ : Bool = true,
  contacts_enabled~ : Bool = false,
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
  entity1 : @ecs.Entity,
  entity2 : @ecs.Entity,
  rest_length : Double,
  stiffness : Double,
  damping : Double,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  model~ : JointMotorModel = AccelerationBased,
  active~ : Bool = true,
  contacts_enabled~ : Bool = false,
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
  parent : @ecs.Entity,
  local_anchor1~ : @math.Vec2 = @math.Vec2::zero(),
  local_anchor2~ : @math.Vec2 = @math.Vec2::zero(),
  limits? : JointLimits,
  motor? : JointMotor,
  softness? : JointSoftness,
  active~ : Bool = true,
) -> MultibodyJoint {
  {
    parent,
    kind: Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~),
    active,
  }
}

///|
priv struct JointWorldStore {
  joints : @ecs.ComponentStore[Joint]
  multibody_joints : @ecs.ComponentStore[MultibodyJoint]
}

///|
let joint_world_store_key : @ecs.ResourceKey[JointWorldStore] = ResourceKey(world => {
  joints: ComponentStore(world),
  multibody_joints: ComponentStore(world),
})

///|
fn joint_world_store() -> JointWorldStore {
  joint_world_store_key.get()
}

///|
/// Authored 2D joint components.
pub fn joints() -> @ecs.ComponentStore[Joint] {
  joint_world_store().joints
}

///|
/// Authored 2D multibody joint components keyed by the child rigid-body entity.
pub fn multibody_joints() -> @ecs.ComponentStore[MultibodyJoint] {
  joint_world_store().multibody_joints
}
