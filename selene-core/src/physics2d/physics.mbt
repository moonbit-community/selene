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
/// Linear velocities in world space.
pub fn linear_velocities() -> @ecs.ComponentStore[LinearVelocity] {
  @velocity.velocities()
}

///|
/// Backward-compatible velocity store alias.
pub fn velocities() -> @ecs.ComponentStore[Velocity] {
  @velocity.velocities()
}

///|
/// Collider components.
pub fn colliders() -> @ecs.ComponentStore[Collider] {
  @collision.colliders()
}

///|
/// Explicit rigid-body descriptors.
pub fn rigid_bodies() -> @ecs.ComponentStore[RigidBody] {
  @collision.rigid_bodies()
}

///|
/// Authored 2D joint descriptors.
pub fn joints() -> @ecs.ComponentStore[Joint] {
  @collision.joints()
}

///|
/// Authored 2D multibody joint descriptors keyed by the child rigid-body entity.
pub fn multibody_joints() -> @ecs.ComponentStore[MultibodyJoint] {
  @collision.multibody_joints()
}

///|
/// Sensor/area components.
pub fn sensors() -> @ecs.ComponentStore[Sensor] {
  @collision.areas()
}

///|
/// Backward-compatible area store alias.
pub fn areas() -> @ecs.ComponentStore[Area] {
  @collision.areas()
}

///|
/// Collider shape components.
pub fn shapes() -> @ecs.ComponentStore[ColliderShape] {
  @collision.shapes()
}

///|
/// Frame-local resolved velocities after physics step.
pub fn resolved_velocities() -> Map[@ecs.Entity, LinearVelocity] {
  @collision.resolved_velocities()
}

///|
/// Grounded entities from latest fixed step.
pub fn grounded_entities() -> @set.Set[@ecs.Entity] {
  @collision.grounded_entities()
}

///|
/// Pointer-interactive components.
pub fn pickables() -> @ecs.ComponentStore[Pickable] {
  @collision.pickables()
}

///|
/// Physics world config.
pub let physics_config : PhysicsConfig = @collision.physics_config

///|
pub let contact_event_bus : @event.Events[ContactEvent] = @collision.contact_event_bus

///|
pub let trigger_event_bus : @event.Events[TriggerEvent] = @collision.trigger_event_bus

///|
pub let pointer_event_bus : @event.Events[PointerEvent] = @collision.pointer_event_bus

///|
pub fn collider_handle(entity : @ecs.Entity) -> ColliderHandle? {
  @collision.collider_handle(entity)
}

///|
pub fn joint_handle(entity : @ecs.Entity) -> JointHandle? {
  @collision.joint_handle(entity)
}

///|
pub fn multibody_joint_handle(entity : @ecs.Entity) -> MultibodyJointHandle? {
  @collision.multibody_joint_handle(entity)
}

///|
pub fn multibody_link(entity : @ecs.Entity) -> MultibodyLinkId? {
  @collision.multibody_link(entity)
}

///|
pub fn physics_step_system(delta : Double) -> Unit {
  @collision.move_system(delta)
}

///|
pub fn move_system(delta : Double) -> Unit {
  @collision.move_system(delta)
}

///|
pub fn configure_physics(
  gravity? : @math.Vec2,
  pixels_per_meter? : Double,
  max_ccd_substeps? : Int32,
) -> Unit {
  if gravity is Some(gravity) {
    @collision.configure_physics(gravity~)
  }
  if pixels_per_meter is Some(pixels_per_meter) {
    @collision.configure_physics(pixels_per_meter~)
  }
  if max_ccd_substeps is Some(max_ccd_substeps) {
    @collision.configure_physics(max_ccd_substeps~)
  }
}

///|
pub fn emit_pickable_just_pressed(
  entity : @ecs.Entity,
  button~ : @inputs.MouseButton = Left,
) -> Unit {
  @collision.emit_pickable_just_pressed(entity, button~)
}

///|
pub fn pickable_click_system(delta : Double) -> Unit {
  @collision.pickable_click_system(delta)
}

///|
pub fn debug_colliders_system(delta : Double) -> Unit {
  @collision.debug_collide_system(delta)
}
