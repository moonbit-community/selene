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
pub(all) struct Physics3DConfig {
  mut gravity : @core.Vec3
}

///|
pub let config : Physics3DConfig = {
  gravity: @core.Vec3::new(0.0F, -9.81F, 0.0F),
}

///|
priv struct Physics3DWorld {
  pipeline : @pipeline.PhysicsPipeline3D
  mut integration : @dynamics.IntegrationParameters
  islands : @dynamics.IslandManager3D
  broad_phase : @collision.BroadPhase3D
  narrow_phase : @collision.NarrowPhase3D
  bodies : @dynamics.RigidBodySet3D
  colliders : @collision.ColliderSet3D
}

///|
let world : Physics3DWorld = {
  pipeline: @pipeline.PhysicsPipeline3D::new(),
  integration: @dynamics.IntegrationParameters::default(),
  islands: @dynamics.IslandManager3D::new(),
  broad_phase: @collision.BroadPhase3D::new(),
  narrow_phase: @collision.NarrowPhase3D::new(),
  bodies: @dynamics.RigidBodySet3D::new(),
  colliders: @collision.ColliderSet3D::new(),
}

///|
pub let rigid_bodies : @dynamics.RigidBodySet3D = world.bodies

///|
pub let colliders : @collision.ColliderSet3D = world.colliders

///|
pub fn set_gravity(gravity : @core.Vec3) -> Unit {
  config.gravity = gravity
}

///|
pub fn physics_step_system(delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  world.integration = world.integration.with_dt(Float::from_double(delta))
  world.pipeline.step(
    config.gravity,
    world.integration,
    world.islands,
    world.broad_phase,
    world.narrow_phase,
    world.bodies,
    world.colliders,
  )
}

///|
pub fn insert_rigid_body(
  body_builder : @dynamics.RigidBodyBuilder3D,
) -> @dynamics.RigidBodyHandle {
  world.bodies.insert(body_builder.build())
}

///|
pub fn insert_collider(
  collider_builder : @collision.ColliderBuilder3D,
  parent_body? : @dynamics.RigidBodyHandle,
) -> @collision.ColliderHandle3D {
  let collider = collider_builder.build()
  match parent_body {
    Some(parent) =>
      world.colliders.insert_with_parent(collider, parent, world.bodies)
    None => world.colliders.insert(collider)
  }
}
