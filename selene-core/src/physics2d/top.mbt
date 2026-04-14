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
pub type Velocity = @velocity.Velocity

///|
/// Collider component.
pub type Collider = @collision.Collider

///|
/// Sensor area component.
pub type Sensor = @collision.Area

///|
/// Backward-compatible area alias.
pub type Area = @collision.Area

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
pub type CollisionFilter = @collision.CollisionFilter

///|
/// Collision group id.
pub type CollisionGroup = @collision.CollisionGroup

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
pub fn linear_velocities() -> Map[@entity.Entity, LinearVelocity] {
  @velocity.velocities()
}

///|
/// Backward-compatible velocity store alias.
pub fn velocities() -> Map[@entity.Entity, Velocity] {
  @velocity.velocities()
}

///|
/// Collider components.
pub fn colliders() -> Map[@entity.Entity, Collider] {
  @collision.colliders()
}

///|
/// Explicit rigid-body descriptors.
pub fn rigid_bodies() -> Map[@entity.Entity, RigidBody] {
  @collision.rigid_bodies()
}

///|
/// Authored 2D joint descriptors.
pub fn joints() -> Map[@entity.Entity, Joint] {
  @collision.joints()
}

///|
/// Authored 2D multibody joint descriptors keyed by the child rigid-body entity.
pub fn multibody_joints() -> Map[@entity.Entity, MultibodyJoint] {
  @collision.multibody_joints()
}

///|
/// Sensor/area components.
pub fn sensors() -> Map[@entity.Entity, Sensor] {
  @collision.areas()
}

///|
/// Backward-compatible area store alias.
pub fn areas() -> Map[@entity.Entity, Area] {
  @collision.areas()
}

///|
/// Collider shape components.
pub fn shapes() -> Map[@entity.Entity, ColliderShape] {
  @collision.shapes()
}

///|
/// Frame-local resolved velocities after physics step.
pub fn resolved_velocities() -> Map[@entity.Entity, LinearVelocity] {
  @collision.resolved_velocities()
}

///|
/// Grounded entities from latest fixed step.
pub fn grounded_entities() -> @set.Set[@entity.Entity] {
  @collision.grounded_entities()
}

///|
/// Pointer-interactive components.
pub fn pickables() -> Map[@entity.Entity, Pickable] {
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
pub fn make_velocity(value : @math.Vec2) -> Velocity {
  @velocity.Velocity(value)
}

///|
pub fn make_linear_velocity(value : @math.Vec2) -> LinearVelocity {
  make_velocity(value)
}

///|
pub fn new_collision_layers(
  memberships : CollisionGroup,
  filters : Array[CollisionGroup],
) -> CollisionLayers {
  @collision.CollisionFilter::new(memberships, filters)
}

///|
pub fn empty_collision_layers(memberships : CollisionGroup) -> CollisionLayers {
  @collision.CollisionFilter::empty(memberships)
}

///|
pub fn all_collision_layers(memberships : CollisionGroup) -> CollisionLayers {
  @collision.CollisionFilter::all(memberships)
}

///|
pub fn new_sensor(filter : CollisionLayers) -> Sensor {
  @collision.Area::new(filter)
}

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> RigidBodyHandle? {
  @collision.rigid_body_handle(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> ColliderHandle? {
  @collision.collider_handle(entity)
}

///|
pub fn joint_handle(entity : @entity.Entity) -> JointHandle? {
  @collision.joint_handle(entity)
}

///|
pub fn multibody_joint_handle(entity : @entity.Entity) -> MultibodyJointHandle? {
  @collision.multibody_joint_handle(entity)
}

///|
pub fn multibody_link(entity : @entity.Entity) -> MultibodyLinkId? {
  @collision.multibody_link(entity)
}

///|
pub fn raycast(
  origin : @math.Vec2,
  direction : @math.Vec2,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
  query_filter? : SpatialQueryFilter = @collision.SpatialQueryFilter::default(),
) -> RaycastHit? {
  @collision.raycast(origin, direction, max_toi~, solid~, query_filter~)
}

///|
pub fn shape_cast(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation? : Double = 0.0,
  direction? : @math.Vec2 = @math.Vec2(0.0, -1.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
  query_filter? : SpatialQueryFilter = @collision.SpatialQueryFilter::default(),
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
  query_filter? : SpatialQueryFilter = @collision.SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  @collision.intersect_point(point, query_filter~)
}

///|
pub fn intersect_shape(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation? : Double = 0.0,
  query_filter? : SpatialQueryFilter = @collision.SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  @collision.intersect_shape(shape, origin, rotation~, query_filter~)
}

///|
pub fn rigid_body_translation(entity : @entity.Entity) -> @math.Vec2? {
  @collision.rigid_body_translation(entity)
}

///|
pub fn set_rigid_body_translation(
  entity : @entity.Entity,
  translation : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_translation(entity, translation)
}

///|
pub fn rigid_body_rotation(entity : @entity.Entity) -> Double? {
  @collision.rigid_body_rotation(entity)
}

///|
pub fn set_rigid_body_rotation(
  entity : @entity.Entity,
  rotation : Double,
) -> Unit {
  @collision.set_rigid_body_rotation(entity, rotation)
}

///|
pub fn rigid_body_linear_velocity(entity : @entity.Entity) -> @math.Vec2? {
  @collision.rigid_body_linear_velocity(entity)
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @entity.Entity,
  linear_velocity : @math.Vec2,
) -> Unit {
  @collision.set_rigid_body_linear_velocity(entity, linear_velocity)
}

///|
pub fn rigid_body_angular_velocity(entity : @entity.Entity) -> Double? {
  @collision.rigid_body_angular_velocity(entity)
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @entity.Entity,
  angular_velocity : Double,
) -> Unit {
  @collision.set_rigid_body_angular_velocity(entity, angular_velocity)
}

///|
pub fn add_force(
  entity : @entity.Entity,
  force : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  @collision.add_force(entity, force, wake_up~)
}

///|
pub fn add_force_at_point(
  entity : @entity.Entity,
  force : @math.Vec2,
  point : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  @collision.add_force_at_point(entity, force, point, wake_up~)
}

///|
pub fn add_torque(
  entity : @entity.Entity,
  torque : Double,
  wake_up? : Bool = true,
) -> Unit {
  @collision.add_torque(entity, torque, wake_up~)
}

///|
pub fn apply_impulse(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  @collision.apply_impulse(entity, impulse, wake_up~)
}

///|
pub fn apply_impulse_at_point(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  point : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  @collision.apply_impulse_at_point(entity, impulse, point, wake_up~)
}

///|
pub fn apply_torque_impulse(
  entity : @entity.Entity,
  impulse : Double,
  wake_up? : Bool = true,
) -> Unit {
  @collision.apply_torque_impulse(entity, impulse, wake_up~)
}

///|
pub fn reset_forces(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
  @collision.reset_forces(entity, wake_up~)
}

///|
pub fn reset_torques(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
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
  max_ccd_substeps? : Int,
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
pub fn is_grounded(entity : @entity.Entity) -> Bool {
  @collision.is_grounded(entity)
}

///|
pub fn get_contains(area : @entity.Entity) -> @set.Set[@entity.Entity] {
  @collision.get_contains(area)
}

///|
pub fn emit_pickable_just_pressed(
  entity : @entity.Entity,
  button? : @inputs.MouseButton = @inputs.MouseButton::Left,
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
