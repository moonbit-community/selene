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
  mut max_ccd_substeps : Int
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
  max_ccd_substeps? : Int,
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
  entity_bodies : Map[@entity.Entity, @rapier_dynamics.RigidBodyHandle]
  entity_colliders : Map[@entity.Entity, @rapier_collision.ColliderHandle]
  collider_entities : Map[Int, @entity.Entity]
  entity_joints : Map[@entity.Entity, JointHandle]
  entity_multibody_joints : Map[@entity.Entity, MultibodyJointHandle]
}

///|
priv struct PhysicsWorldRuntime {
  world : PhysicsWorld
  entity_physics_config_keys : Map[@entity.Entity, EntityPhysicsConfigKey]
  pending_body_rotations : Map[@entity.Entity, Double]
  pending_body_linear_velocities : Map[@entity.Entity, @math.Vec2]
  pending_body_angular_velocities : Map[@entity.Entity, Double]
  pending_body_forces : Map[@entity.Entity, @math.Vec2]
  pending_body_force_points : Map[
    @entity.Entity,
    Array[(@math.Vec2, @math.Vec2)],
  ]
  pending_body_torques : Map[@entity.Entity, Double]
  pending_body_impulses : Map[@entity.Entity, @math.Vec2]
  pending_body_impulse_points : Map[
    @entity.Entity,
    Array[(@math.Vec2, @math.Vec2)],
  ]
  pending_body_torque_impulses : Map[@entity.Entity, Double]
  entity_joint_config_keys : Map[@entity.Entity, EntityJointConfigKey]
  entity_multibody_joint_config_keys : Map[
    @entity.Entity,
    EntityMultibodyJointConfigKey,
  ]
}

///|
let physics_world_runtimes : Map[UInt, PhysicsWorldRuntime] = Map::of([])

///|
fn physics_world_runtime() -> PhysicsWorldRuntime {
  let world_id = @ecs.require_current_world().id()
  physics_world_runtimes.get_or_init(world_id, () => {
    world: {
      pipeline: @rapier_pipeline.PhysicsPipeline::new(),
      integration: @rapier_dynamics.IntegrationParameters::default(),
      islands: @rapier_dynamics.IslandManager::new(),
      broad_phase: @rapier_collision.BroadPhaseBvh::new(),
      narrow_phase: @rapier_collision.NarrowPhase::new(),
      bodies: @rapier_dynamics.RigidBodySet::new(),
      colliders: @rapier_collision.ColliderSet::new(),
      impulse_joints: @rapier_dynamics.ImpulseJointSet::new(),
      multibody_joints: @rapier_dynamics.MultibodyJointSet::new(),
      ccd_solver: @rapier_dynamics_ccd.CCDSolver::new(),
      event_handler: @rapier_pipeline.EventHandler::new(),
      entity_bodies: Map::of([]),
      entity_colliders: Map::of([]),
      collider_entities: Map::of([]),
      entity_joints: Map::of([]),
      entity_multibody_joints: Map::of([]),
    },
    entity_physics_config_keys: Map::of([]),
    pending_body_rotations: Map::of([]),
    pending_body_linear_velocities: Map::of([]),
    pending_body_angular_velocities: Map::of([]),
    pending_body_forces: Map::of([]),
    pending_body_force_points: Map::of([]),
    pending_body_torques: Map::of([]),
    pending_body_impulses: Map::of([]),
    pending_body_impulse_points: Map::of([]),
    pending_body_torque_impulses: Map::of([]),
    entity_joint_config_keys: Map::of([]),
    entity_multibody_joint_config_keys: Map::of([]),
  })
}

///|
fn world() -> PhysicsWorld {
  physics_world_runtime().world
}

///|
priv struct EntityCollisionConfig {
  filter : CollisionFilter
  sensor : Bool
  active : Bool
  friction : Double
  restitution : Double
} derive(Eq)

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
priv struct EntityPhysicsConfigKey {
  translation : @math.Vec2?
  rotation : Double?
  shape : CollisionShape
  collision : EntityCollisionConfig
  body : RigidBody
  linear_velocity : @math.Vec2?
  angular_velocity : Double?
} derive(Eq)

///|
fn entity_physics_config_keys() -> Map[@entity.Entity, EntityPhysicsConfigKey] {
  physics_world_runtime().entity_physics_config_keys
}

///|
fn pending_body_rotations() -> Map[@entity.Entity, Double] {
  physics_world_runtime().pending_body_rotations
}

///|
fn pending_body_linear_velocities() -> Map[@entity.Entity, @math.Vec2] {
  physics_world_runtime().pending_body_linear_velocities
}

///|
fn pending_body_angular_velocities() -> Map[@entity.Entity, Double] {
  physics_world_runtime().pending_body_angular_velocities
}

///|
fn pending_body_forces() -> Map[@entity.Entity, @math.Vec2] {
  physics_world_runtime().pending_body_forces
}

///|
fn pending_body_force_points() -> Map[
  @entity.Entity,
  Array[(@math.Vec2, @math.Vec2)],
] {
  physics_world_runtime().pending_body_force_points
}
