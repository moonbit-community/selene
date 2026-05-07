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
/// Supported rigid-body modes for 2D physics.
pub(all) enum RigidBodyType {
  Dynamic
  Fixed
  KinematicPositionBased
  KinematicVelocityBased
} derive(Eq, Debug)

///|
/// 2D rigid-body configuration synchronized into Rapier.
pub(all) struct RigidBody {
  body_type : RigidBodyType
  gravity_scale : Double
  linear_damping : Double
  angular_damping : Double
  ccd_enabled : Bool
  lock_rotation : Bool
} derive(Eq, Debug)

///|
/// Native Rapier rigid-body handle.
pub type RigidBodyHandle = @rapier_dynamics.RigidBodyHandle

///|
/// Native Rapier collider handle.
pub type ColliderHandle = @rapier_collision.ColliderHandle

///|
pub fn RigidBody::dynamic() -> RigidBody {
  {
    body_type: Dynamic,
    gravity_scale: 1.0,
    linear_damping: 0.0,
    angular_damping: 0.0,
    ccd_enabled: false,
    // Selene 2D currently does not expose a dedicated rotation component, so
    // keep rotation locked by default for stable sprite/collider behavior.
    lock_rotation: true,
  }
}

///|
pub fn RigidBody::fixed() -> RigidBody {
  { ..RigidBody::dynamic(), body_type: Fixed }
}

///|
pub fn RigidBody::kinematic_position_based() -> RigidBody {
  { ..RigidBody::dynamic(), body_type: KinematicPositionBased }
}

///|
pub fn RigidBody::kinematic_velocity_based() -> RigidBody {
  { ..RigidBody::dynamic(), body_type: KinematicVelocityBased }
}

///|
priv struct RigidBodyWorldStore {
  rigid_bodies : Map[@entity.Entity, RigidBody]
}

///|
let rigid_body_world_stores : Map[UInt, RigidBodyWorldStore] = Map([])

///|
fn rigid_body_world_store() -> RigidBodyWorldStore {
  let world_id = @ecs.require_current_world().id()
  rigid_body_world_stores.get_or_init(world_id, () => { rigid_bodies: Map([]) })
}

///|
/// Explicit rigid-body descriptors for entities that participate in 2D physics.
pub fn rigid_bodies() -> Map[@entity.Entity, RigidBody] {
  rigid_body_world_store().rigid_bodies
}
