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
const EPSILON = 0.000000001

///|
pub(all) struct PhysicsConfig {
  mut gravity : @math.Vec2
  mut pixels_per_meter : Double
  mut max_ccd_substeps : Int32
}

///|
pub let physics_config : PhysicsConfig = {
  gravity: @math.Vec2::zero(),
  pixels_per_meter: 100.0,
  max_ccd_substeps: 1,
}

///|
pub fn configure_physics(
  gravity? : @math.Vec2,
  pixels_per_meter? : Double,
  max_ccd_substeps? : Int32,
) -> Unit {
  if gravity is Some(gravity) {
    physics_config.gravity = gravity
  }
  if pixels_per_meter is Some(ppm) && ppm > 0.0 {
    physics_config.pixels_per_meter = ppm
  }
  if max_ccd_substeps is Some(substeps) && substeps > 0 {
    physics_config.max_ccd_substeps = substeps
  }
}

///|
priv struct PhysicsWorld {
  pipeline : @rapier_pipeline.PhysicsPipeline
  mut integration : @rapier_dynamics.IntegrationParameters
  islands : @rapier_dynamics.IslandManager
  broad_phase : @rapier_collision.BroadPhaseBvh
  narrow_phase : @rapier_collision.NarrowPhase
  bodies : @rapier_dynamics.RigidBodySet
  colliders : @rapier_collision.ColliderSet
  impulse_joints : @rapier_dynamics.ImpulseJointSet
  multibody_joints : @rapier_dynamics.MultibodyJointSet
  ccd_solver : @rapier_dynamics_ccd.CCDSolver
  event_handler : @rapier_pipeline.EventHandler
  entity_bodies : @ecs.EntityTable[@rapier_dynamics.RigidBodyHandle]
  entity_colliders : @ecs.EntityTable[@rapier_collision.ColliderHandle]
  collider_entities : Map[(Int32, Int32), @ecs.Entity]
  entity_joints : @ecs.EntityTable[JointHandle]
  entity_multibody_joints : @ecs.EntityTable[MultibodyJointHandle]
}

///|
priv struct PhysicsWorldRuntime {
  world : PhysicsWorld
  entity_physics_config_keys : @ecs.EntityTable[EntityPhysicsConfigKey]
  pending_body_rotations : @ecs.EntityTable[Double]
  pending_body_linear_velocities : @ecs.EntityTable[@math.Vec2]
  pending_body_angular_velocities : @ecs.EntityTable[Double]
  pending_body_forces : @ecs.EntityTable[@math.Vec2]
  pending_body_force_points : @ecs.EntityTable[Array[(@math.Vec2, @math.Vec2)]]
  pending_body_torques : @ecs.EntityTable[Double]
  pending_body_impulses : @ecs.EntityTable[@math.Vec2]
  pending_body_impulse_points : @ecs.EntityTable[
    Array[(@math.Vec2, @math.Vec2)],
  ]
  pending_body_torque_impulses : @ecs.EntityTable[Double]
  entity_joint_config_keys : @ecs.EntityTable[EntityJointConfigKey]
  entity_multibody_joint_config_keys : @ecs.EntityTable[
    EntityMultibodyJointConfigKey,
  ]
}

///|
let physics_runtime_key : @ecs.ResourceKey[PhysicsWorldRuntime] = ResourceKey()

///|
fn physics_world_runtime() -> PhysicsWorldRuntime {
  physics_runtime_key.get_or_insert_with(@ecs.require_current_world(), world => {
    world: {
      pipeline: PhysicsPipeline(),
      integration: @rapier_dynamics.IntegrationParameters::default(),
      islands: IslandManager(),
      broad_phase: BroadPhaseBvh(),
      narrow_phase: NarrowPhase(),
      bodies: RigidBodySet(),
      colliders: ColliderSet(),
      impulse_joints: ImpulseJointSet(),
      multibody_joints: MultibodyJointSet(),
      ccd_solver: CCDSolver(),
      event_handler: EventHandler(),
      entity_bodies: EntityTable(world),
      entity_colliders: EntityTable(world),
      collider_entities: Map([]),
      entity_joints: EntityTable(world),
      entity_multibody_joints: EntityTable(world),
    },
    entity_physics_config_keys: EntityTable(world),
    pending_body_rotations: EntityTable(world),
    pending_body_linear_velocities: EntityTable(world),
    pending_body_angular_velocities: EntityTable(world),
    pending_body_forces: EntityTable(world),
    pending_body_force_points: EntityTable(world),
    pending_body_torques: EntityTable(world),
    pending_body_impulses: EntityTable(world),
    pending_body_impulse_points: EntityTable(world),
    pending_body_torque_impulses: EntityTable(world),
    entity_joint_config_keys: EntityTable(world),
    entity_multibody_joint_config_keys: EntityTable(world),
  })
}

///|
fn world() -> PhysicsWorld {
  physics_world_runtime().world
}

///|
#derive(Eq)
priv struct EntityCollisionConfig {
  filter : CollisionFilter
  sensor : Bool
  active : Bool
  friction : Double
  restitution : Double
}

///|
priv struct EntityPhysicsSnapshot {
  position : @math.Vec2
  rotation : Double
  shape : CollisionShape
  collision : EntityCollisionConfig
  body : RigidBody
  linear_velocity : @math.Vec2?
  angular_velocity : Double?
}

///|
#derive(Eq)
priv struct EntityPhysicsConfigKey {
  translation : @math.Vec2?
  rotation : Double?
  shape : CollisionShape
  collision : EntityCollisionConfig
  body : RigidBody
  linear_velocity : @math.Vec2?
  angular_velocity : Double?
}

///|
fn entity_physics_config_keys() -> @ecs.EntityTable[EntityPhysicsConfigKey] {
  physics_world_runtime().entity_physics_config_keys
}

///|
fn pending_body_rotations() -> @ecs.EntityTable[Double] {
  physics_world_runtime().pending_body_rotations
}

///|
fn pending_body_linear_velocities() -> @ecs.EntityTable[@math.Vec2] {
  physics_world_runtime().pending_body_linear_velocities
}

///|
fn pending_body_angular_velocities() -> @ecs.EntityTable[Double] {
  physics_world_runtime().pending_body_angular_velocities
}

///|
fn pending_body_forces() -> @ecs.EntityTable[@math.Vec2] {
  physics_world_runtime().pending_body_forces
}

///|
fn pending_body_force_points() -> @ecs.EntityTable[
  Array[(@math.Vec2, @math.Vec2)],
] {
  physics_world_runtime().pending_body_force_points
}
