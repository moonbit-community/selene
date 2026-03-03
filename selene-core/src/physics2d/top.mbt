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
pub let linear_velocities : Map[@entity.Entity, LinearVelocity] = @velocity.velocities

///|
/// Backward-compatible velocity store alias.
pub let velocities : Map[@entity.Entity, Velocity] = @velocity.velocities

///|
/// Collider components.
pub let colliders : Map[@entity.Entity, Collider] = @collision.colliders

///|
/// Sensor/area components.
pub let sensors : Map[@entity.Entity, Sensor] = @collision.areas

///|
/// Backward-compatible area store alias.
pub let areas : Map[@entity.Entity, Area] = @collision.areas

///|
/// Collider shape components.
pub let shapes : Map[@entity.Entity, ColliderShape] = @collision.shapes

///|
/// Frame-local resolved velocities after physics step.
pub let resolved_velocities : Map[@entity.Entity, LinearVelocity] = @collision.resolved_velocities

///|
/// Grounded entities from latest fixed step.
pub let grounded_entities : @set.Set[@entity.Entity] = @collision.grounded_entities

///|
/// Pointer-interactive components.
pub let pickables : Map[@entity.Entity, Pickable] = @collision.pickables

///|
/// Physics world config.
pub let physics_config : PhysicsConfig = @collision.physics_config

///|
pub fn make_velocity(value : @math.Vec2D) -> Velocity {
  @velocity.Velocity(value)
}

///|
pub fn make_linear_velocity(value : @math.Vec2D) -> LinearVelocity {
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
pub fn new_sensor(filter : CollisionLayers) -> Sensor {
  @collision.Area::new(filter)
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
  gravity? : @math.Vec2D,
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
pub fn collision_events() -> Array[CollisionEvent] {
  @collision.contact_events()
}

///|
pub fn contact_events() -> Array[ContactEvent] {
  @collision.contact_events()
}

///|
pub fn sensor_events() -> Array[SensorEvent] {
  @collision.trigger_events()
}

///|
pub fn trigger_events() -> Array[TriggerEvent] {
  @collision.trigger_events()
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
pub fn pointer_events() -> Array[PointerEvent] {
  @collision.pointer_events()
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
