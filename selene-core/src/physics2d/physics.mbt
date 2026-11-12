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
/// Frame-local resolved velocities after physics step.
pub fn resolved_velocity(entity : @ecs.Entity) -> LinearVelocity? {
  @collision.resolved_velocity(entity)
}

///|
/// Grounded entities from latest fixed step.
pub fn grounded_entities() -> @set.Set[@ecs.Entity] {
  @collision.grounded_entities()
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
pub fn physics_step_system(world~ : @ecs.World, delta : Double) -> Unit {
  @collision.move_system(world~, delta)
}

///|
pub fn move_system(world~ : @ecs.World, delta : Double) -> Unit {
  @collision.move_system(world~, delta)
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
pub fn pickable_click_system(world~ : @ecs.World, delta : Double) -> Unit {
  @collision.pickable_click_system(world~, delta)
}

///|
pub fn debug_colliders_system(world~ : @ecs.World, delta : Double) -> Unit {
  @collision.debug_collide_system(world~, delta)
}
