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
pub fn resolved_velocities() -> @ecs.ComponentStore[LinearVelocity] {
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
pub fn rigid_body_handle(entity : @ecs.Entity) -> RigidBodyHandle? {
  @collision.rigid_body_handle(entity)
}

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
pub fn raycast(
  origin : @math.Vec2,
  direction : @math.Vec2,
  max_toi~ : Double = 1000.0,
  solid~ : Bool = true,
  query_filter~ : SpatialQueryFilter = @collision.SpatialQueryFilter(),
) -> RaycastHit? {
  @collision.raycast(origin, direction, max_toi~, solid~, query_filter~)
}

///|
pub fn shape_cast(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  direction~ : @math.Vec2 = Vec2(0.0, -1.0),
  max_toi~ : Double = 1000.0,
  stop_at_penetration~ : Bool = false,
  query_filter~ : SpatialQueryFilter = @collision.SpatialQueryFilter(),
) -> ShapeCastHit? {
  @collision.shape_cast(
    shape,
    origin,
    rotation~,
    direction~,
    max_toi~,
    stop_at_penetration~,
    query_filter~,
  )
}

///|
pub fn intersect_point(
  point : @math.Vec2,
  query_filter~ : SpatialQueryFilter = @collision.SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  @collision.intersect_point(point, query_filter~)
}

///|
pub fn intersect_shape(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  query_filter~ : SpatialQueryFilter = @collision.SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  @collision.intersect_shape(shape, origin, rotation~, query_filter~)
}

///|
pub fn rigid_body_translation(entity : @ecs.Entity) -> @math.Vec2? {
  @collision.rigid_body_translation(entity)
}

///|
pub fn set_rigid_body_translation(
  entity : @ecs.Entity,
  translation : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_translation(entity, translation)
}

///|
pub fn rigid_body_rotation(entity : @ecs.Entity) -> Double? {
  @collision.rigid_body_rotation(entity)
}

///|
pub fn set_rigid_body_rotation(entity : @ecs.Entity, rotation : Double) -> Unit {
  @collision.set_rigid_body_rotation(entity, rotation)
}

///|
pub fn rigid_body_linear_velocity(entity : @ecs.Entity) -> @math.Vec2? {
  @collision.rigid_body_linear_velocity(entity)
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @ecs.Entity,
  linear_velocity : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_linear_velocity(entity, linear_velocity)
}

///|
pub fn rigid_body_angular_velocity(entity : @ecs.Entity) -> Double? {
  @collision.rigid_body_angular_velocity(entity)
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @ecs.Entity,
  angular_velocity : Double,
) -> Unit {
  @collision.set_rigid_body_angular_velocity(entity, angular_velocity)
}

///|
pub fn add_force(
  entity : @ecs.Entity,
  force : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_force(entity, force, wake_up~)
}

///|
pub fn add_force_at_point(
  entity : @ecs.Entity,
  force : @math.Vec2,
  point : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_force_at_point(entity, force, point, wake_up~)
}

///|
pub fn add_torque(
  entity : @ecs.Entity,
  torque : Double,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.add_torque(entity, torque, wake_up~)
}

///|
pub fn apply_impulse(
  entity : @ecs.Entity,
  impulse : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_impulse(entity, impulse, wake_up~)
}

///|
pub fn apply_impulse_at_point(
  entity : @ecs.Entity,
  impulse : @math.Vec2,
  point : @math.Vec2,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_impulse_at_point(entity, impulse, point, wake_up~)
}

///|
pub fn apply_torque_impulse(
  entity : @ecs.Entity,
  impulse : Double,
  wake_up~ : Bool = true,
) -> Unit {
  @collision.apply_torque_impulse(entity, impulse, wake_up~)
}

///|
pub fn reset_forces(entity : @ecs.Entity, wake_up~ : Bool = true) -> Unit {
  @collision.reset_forces(entity, wake_up~)
}

///|
pub fn reset_torques(entity : @ecs.Entity, wake_up~ : Bool = true) -> Unit {
  @collision.reset_torques(entity, wake_up~)
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
pub fn is_grounded(entity : @ecs.Entity) -> Bool {
  @collision.is_grounded(entity)
}

///|
pub fn get_contains(area : @ecs.Entity) -> @set.Set[@ecs.Entity] {
  @collision.get_contains(area)
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
