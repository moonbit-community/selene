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
pub(all) enum RigidBody {
  Dynamic
  Fixed
  KinematicPositionBased
  KinematicVelocityBased
} derive(Eq, Show)

///|
pub(all) struct Velocity {
  linvel : @math.Vec3
  angvel : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct Damping {
  linear_damping : Double
  angular_damping : Double
} derive(Eq, Show)

///|
pub(all) struct GravityScale(Double) derive(Eq, Show)

///|
pub(all) struct LockedAxes {
  lock_translation_x : Bool
  lock_translation_y : Bool
  lock_translation_z : Bool
  lock_rotation_x : Bool
  lock_rotation_y : Bool
  lock_rotation_z : Bool
} derive(Eq, Show)

///|
pub(all) struct Ccd {} derive(Eq, Show)

///|
pub(all) struct Dominance(Int) derive(Eq, Show)

///|
pub(all) enum AdditionalMassProperties {
  Mass(Double)
  MassProperties(@core.MassProperties3)
}

///|
pub(all) enum Collider {
  Cuboid(@math.Vec3)
  Ball(Double)
  CapsuleX(Double, Double)
  CapsuleY(Double, Double)
  CapsuleZ(Double, Double)
  Cylinder(Double, Double)
  Cone(Double, Double)
  RoundCylinder(Double, Double, Double)
  Halfspace(@math.Vec3)
  ConvexHull(Array[@math.Vec3])
  TriMesh(Array[@math.Vec3], Array[(Int, Int, Int)])
  Heightfield(Array[Double], Int, Int, @math.Vec3)
} derive(Eq, Show)

///|
pub(all) struct Sensor {} derive(Eq, Show)

///|
pub(all) struct Friction(Double) derive(Eq, Show)

///|
pub(all) struct Restitution(Double) derive(Eq, Show)

///|
pub(all) struct CollisionGroups {
  memberships : Int
  filters : Int
} derive(Eq, Show)

///|
pub(all) struct SolverGroups {
  memberships : Int
  filters : Int
} derive(Eq, Show)

///|
pub(all) struct ContactForceEventThreshold(Double) derive(Eq, Show)

///|
pub(all) enum ColliderMassProperties {
  Density(Double)
} derive(Eq, Show)

///|
pub type RapierRigidBodyHandle = @dynamics.RigidBodyHandle

///|
pub type RapierColliderHandle = @collision.ColliderHandle3D

///|
pub type RapierImpulseJointHandle = @dynamics.JointHandle3DReal

///|
pub type RapierMultibodyJointHandle = @dynamics.MultibodyJointHandle

///|
pub type JointAxis = @dynamics.JointAxis3DReal

///|
pub type JointAxesMask = @dynamics.JointAxesMask3DReal

///|
pub type MotorModel = @dynamics.MotorModel

///|
pub type CharacterLength = @control.CharacterLength

///|
pub type CharacterAutostep = @control.CharacterAutostep

///|
pub(all) enum QueryFilterBody {
  All
  Dynamic
  Fixed
  Kinematic
} derive(Eq, Show)

///|
pub(all) struct QueryFilter {
  groups : CollisionGroups?
  exclude_entity : @entity.Entity?
  exclude_collider : RapierColliderHandle?
  exclude_rigid_body : RapierRigidBodyHandle?
  exclude_sensors : Bool
  exclude_solids : Bool
  body_filter : QueryFilterBody
}

///|
pub(all) struct FixedJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  local_basis1 : @math.Quat
  local_basis2 : @math.Quat
} derive(Eq, Show)

///|
pub(all) struct RevoluteJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  axis : @math.Vec3
  limits : (Double, Double)?
  motor_model : MotorModel
  motor_position : (Double, Double, Double)?
  motor_velocity : (Double, Double)?
  max_force : Double?
  softness : @dynamics.SpringCoefficients?
}

///|
pub(all) struct PrismaticJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  axis : @math.Vec3
  limits : (Double, Double)?
  motor_position : (Double, Double, Double)?
  motor_velocity : (Double, Double)?
  max_force : Double?
} derive(Eq, Show)

///|
pub(all) struct RopeJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  max_distance : Double
} derive(Eq, Show)

///|
pub(all) struct SpringJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  rest_length : Double
  stiffness : Double
  damping : Double
} derive(Eq, Show)

///|
pub(all) struct SphericalJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  motor_target : (@math.Quat, Double, Double)?
} derive(Eq, Show)

///|
pub(all) enum Joint {
  Fixed(FixedJoint)
  Revolute(RevoluteJoint)
  Prismatic(PrismaticJoint)
  Rope(RopeJoint)
  Spring(SpringJoint)
  Spherical(SphericalJoint)
}

///|
pub(all) struct ImpulseJoint {
  parent : @entity.Entity
  data : Joint
  contacts_enabled : Bool
}

///|
pub(all) struct MultibodyJoint {
  parent : @entity.Entity
  data : Joint
  contacts_enabled : Bool
}

///|
pub(all) struct KinematicCharacterController {
  translation : @math.Vec3?
  offset : CharacterLength
  slide : Bool
  autostep : CharacterAutostep?
  max_slope_climb_angle : Double
  min_slope_slide_angle : Double
  snap_to_ground : CharacterLength?
  normal_nudge_factor : Double
  up : @math.Vec3
  apply_impulses_to_dynamic_bodies : Bool
}

///|
pub(all) struct KinematicCharacterControllerOutput {
  desired_translation : @math.Vec3
  effective_translation : @math.Vec3
  grounded : Bool
  is_sliding_down_slope : Bool
} derive(Eq, Show)

///|
pub(all) struct KinematicCharacterControllerCollision {
  entity : @entity.Entity?
  character_translation_applied : @math.Vec3
  character_translation_remaining : @math.Vec3
  toi : Double
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct KinematicCharacterControllerCollisions {
  collisions : Array[KinematicCharacterControllerCollision]
} derive(Eq, Show)

///|
pub(all) struct CollisionEvent {
  entity_a : @entity.Entity
  entity_b : @entity.Entity
  started : Bool
  stopped : Bool
  sensor : Bool
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct SensorEvent {
  sensor : @entity.Entity
  other : @entity.Entity
  entered : Bool
} derive(Eq, Show)

///|
pub(all) struct ContactForceEvent {
  entity_a : @entity.Entity
  entity_b : @entity.Entity
  total_force : @math.Vec3
  total_force_magnitude : Double
  max_force_direction : @math.Vec3
  max_force_magnitude : Double
} derive(Eq, Show)

///|
pub(all) struct RaycastHit {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct ShapeCastHit {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct PointProjection {
  entity : @entity.Entity
  point : @math.Vec3
  is_inside : Bool
} derive(Eq, Show)

///|
pub(all) struct RapierContext {}

///|
pub(all) struct Physics3DConfig {
  mut gravity : @math.Vec3
}

///|
pub let config : Physics3DConfig = { gravity: @math.Vec3::new(0.0, -9.81, 0.0) }

///|
priv struct RigidBodyDesc {
  body_type : RigidBody
  velocity : Velocity
  damping : Damping
  gravity_scale : GravityScale
  locked_axes : LockedAxes
  ccd_enabled : Bool
  dominance : Dominance?
  additional_mass_properties : AdditionalMassProperties?
}

///|
priv struct ColliderDesc {
  shape : Collider
  sensor : Bool
  friction : Friction
  restitution : Restitution
  collision_groups : CollisionGroups
  solver_groups : SolverGroups?
  active_collision_types : @collision.ActiveCollisionTypes
  active_events : @collision.ActiveEvents
  active_hooks : @collision.ActiveHooks
  contact_force_event_threshold : ContactForceEventThreshold
  mass_properties : ColliderMassProperties?
}

///|
pub fn Velocity::zero() -> Velocity {
  { linvel: @math.Vec3::zero(), angvel: @math.Vec3::zero() }
}

///|
pub fn Damping::default() -> Damping {
  { linear_damping: 0.0, angular_damping: 0.0 }
}

///|
pub fn GravityScale::default() -> GravityScale {
  GravityScale(1.0)
}

///|
pub fn LockedAxes::default() -> LockedAxes {
  {
    lock_translation_x: false,
    lock_translation_y: false,
    lock_translation_z: false,
    lock_rotation_x: false,
    lock_rotation_y: false,
    lock_rotation_z: false,
  }
}

///|
pub fn LockedAxes::lock_rotations() -> LockedAxes {
  {
    ..LockedAxes::default(),
    lock_rotation_x: true,
    lock_rotation_y: true,
    lock_rotation_z: true,
  }
}

///|
pub fn LockedAxes::lock_translations() -> LockedAxes {
  {
    ..LockedAxes::default(),
    lock_translation_x: true,
    lock_translation_y: true,
    lock_translation_z: true,
  }
}

///|
pub fn Dominance::new(group : Int) -> Dominance {
  Dominance(group)
}

///|
pub fn AdditionalMassProperties::mass(
  mass : Double,
) -> AdditionalMassProperties {
  Mass(mass)
}

///|
pub fn AdditionalMassProperties::mass_properties(
  props : @core.MassProperties3,
) -> AdditionalMassProperties {
  MassProperties(props)
}

///|
pub fn Collider::cuboid(half_extents : @math.Vec3) -> Collider {
  Cuboid(half_extents)
}

///|
pub fn Collider::ball(radius : Double) -> Collider {
  Ball(radius)
}

///|
pub fn Collider::capsule_x(half_height : Double, radius : Double) -> Collider {
  CapsuleX(half_height, radius)
}

///|
pub fn Collider::capsule_y(half_height : Double, radius : Double) -> Collider {
  CapsuleY(half_height, radius)
}

///|
pub fn Collider::capsule_z(half_height : Double, radius : Double) -> Collider {
  CapsuleZ(half_height, radius)
}

///|
pub fn Collider::cylinder(half_height : Double, radius : Double) -> Collider {
  Cylinder(half_height, radius)
}

///|
pub fn Collider::cone(half_height : Double, radius : Double) -> Collider {
  Cone(half_height, radius)
}

///|
pub fn Collider::round_cylinder(
  half_height : Double,
  radius : Double,
  border_radius : Double,
) -> Collider {
  RoundCylinder(half_height, radius, border_radius)
}

///|
pub fn Collider::halfspace(normal : @math.Vec3) -> Collider {
  Halfspace(normal)
}

///|
pub fn Collider::convex_hull(points : Array[@math.Vec3]) -> Collider {
  ConvexHull(points)
}

///|
pub fn Collider::trimesh(
  vertices : Array[@math.Vec3],
  indices : Array[(Int, Int, Int)],
) -> Collider {
  TriMesh(vertices, indices)
}

///|
pub fn Collider::heightfield(
  heights : Array[Double],
  nrows : Int,
  ncols : Int,
  scale : @math.Vec3,
) -> Collider {
  Heightfield(heights, nrows, ncols, scale)
}

///|
pub fn Friction::new(coefficient : Double) -> Friction {
  Friction(coefficient)
}

///|
pub fn Restitution::new(coefficient : Double) -> Restitution {
  Restitution(coefficient)
}

///|
pub fn CollisionGroups::new(
  memberships : Int,
  filters : Int,
) -> CollisionGroups {
  { memberships, filters }
}

///|
pub fn CollisionGroups::all() -> CollisionGroups {
  { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF }
}

///|
pub fn SolverGroups::new(memberships : Int, filters : Int) -> SolverGroups {
  { memberships, filters }
}

///|
pub fn SolverGroups::all() -> SolverGroups {
  { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF }
}

///|
pub fn ContactForceEventThreshold::default() -> ContactForceEventThreshold {
  ContactForceEventThreshold(1.0e30)
}

///|
pub fn ColliderMassProperties::density(
  density : Double,
) -> ColliderMassProperties {
  Density(density)
}

///|
pub fn QueryFilter::default() -> QueryFilter {
  {
    groups: None,
    exclude_entity: None,
    exclude_collider: None,
    exclude_rigid_body: None,
    exclude_sensors: false,
    exclude_solids: false,
    body_filter: All,
  }
}

///|
pub fn QueryFilter::all() -> QueryFilter {
  QueryFilter::default()
}

///|
pub fn QueryFilter::only_dynamic() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Dynamic }
}

///|
pub fn QueryFilter::only_fixed() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Fixed }
}

///|
pub fn QueryFilter::only_kinematic() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Kinematic }
}

///|
pub fn FixedJoint::new() -> FixedJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    local_basis1: @math.Quat::identity(),
    local_basis2: @math.Quat::identity(),
  }
}

///|
pub fn RevoluteJoint::new(axis : @math.Vec3) -> RevoluteJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    axis,
    limits: None,
    motor_model: AccelerationBased,
    motor_position: None,
    motor_velocity: None,
    max_force: None,
    softness: None,
  }
}

///|
pub fn PrismaticJoint::new(axis : @math.Vec3) -> PrismaticJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    axis,
    limits: None,
    motor_position: None,
    motor_velocity: None,
    max_force: None,
  }
}

///|
pub fn RopeJoint::new(max_distance : Double) -> RopeJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    max_distance,
  }
}

///|
pub fn SpringJoint::new(
  rest_length : Double,
  stiffness : Double,
  damping : Double,
) -> SpringJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    rest_length,
    stiffness,
    damping,
  }
}

///|
pub fn SphericalJoint::new() -> SphericalJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    motor_target: None,
  }
}

///|
pub fn KinematicCharacterController::default() -> KinematicCharacterController {
  {
    translation: None,
    offset: CharacterLength::absolute(0.01),
    slide: true,
    autostep: None,
    max_slope_climb_angle: 0.7853981633974483,
    min_slope_slide_angle: 0.5235987755982988,
    snap_to_ground: None,
    normal_nudge_factor: 0.001,
    up: @math.Vec3::y_axis(),
    apply_impulses_to_dynamic_bodies: false,
  }
}

///|
pub fn KinematicCharacterControllerCollisions::empty() -> KinematicCharacterControllerCollisions {
  { collisions: [] }
}

///|
priv struct Physics3DComponentWorldStore {
  rigid_bodies : Map[@entity.Entity, RigidBody]
  velocities : Map[@entity.Entity, Velocity]
  dampings : Map[@entity.Entity, Damping]
  gravity_scales : Map[@entity.Entity, GravityScale]
  locked_axes : Map[@entity.Entity, LockedAxes]
  ccds : Map[@entity.Entity, Ccd]
  dominances : Map[@entity.Entity, Dominance]
  additional_mass_properties : Map[@entity.Entity, AdditionalMassProperties]
  colliders : Map[@entity.Entity, Collider]
  sensors : Map[@entity.Entity, Sensor]
  frictions : Map[@entity.Entity, Friction]
  restitutions : Map[@entity.Entity, Restitution]
  collision_groups : Map[@entity.Entity, CollisionGroups]
  solver_groups : Map[@entity.Entity, SolverGroups]
  active_collision_types : Map[@entity.Entity, @collision.ActiveCollisionTypes]
  active_events : Map[@entity.Entity, @collision.ActiveEvents]
  active_hooks : Map[@entity.Entity, @collision.ActiveHooks]
  contact_force_event_thresholds : Map[
    @entity.Entity,
    ContactForceEventThreshold,
  ]
  collider_mass_properties : Map[@entity.Entity, ColliderMassProperties]
  impulse_joints : Map[@entity.Entity, ImpulseJoint]
  multibody_joints : Map[@entity.Entity, MultibodyJoint]
  kinematic_character_controllers : Map[
    @entity.Entity,
    KinematicCharacterController,
  ]
  kinematic_character_controller_outputs : Map[
    @entity.Entity,
    KinematicCharacterControllerOutput,
  ]
  kinematic_character_controller_collisions : Map[
    @entity.Entity,
    KinematicCharacterControllerCollisions,
  ]
}

///|
let physics3d_component_world_stores : Map[UInt, Physics3DComponentWorldStore] = Map::new()

///|
fn physics3d_component_world_store() -> Physics3DComponentWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_component_world_stores.get_or_init(world_id, () => {
    rigid_bodies: Map::new(),
    velocities: Map::new(),
    dampings: Map::new(),
    gravity_scales: Map::new(),
    locked_axes: Map::new(),
    ccds: Map::new(),
    dominances: Map::new(),
    additional_mass_properties: Map::new(),
    colliders: Map::new(),
    sensors: Map::new(),
    frictions: Map::new(),
    restitutions: Map::new(),
    collision_groups: Map::new(),
    solver_groups: Map::new(),
    active_collision_types: Map::new(),
    active_events: Map::new(),
    active_hooks: Map::new(),
    contact_force_event_thresholds: Map::new(),
    collider_mass_properties: Map::new(),
    impulse_joints: Map::new(),
    multibody_joints: Map::new(),
    kinematic_character_controllers: Map::new(),
    kinematic_character_controller_outputs: Map::new(),
    kinematic_character_controller_collisions: Map::new(),
  })
}

///|
pub fn rigid_bodies() -> Map[@entity.Entity, RigidBody] {
  physics3d_component_world_store().rigid_bodies
}

///|
pub fn velocities() -> Map[@entity.Entity, Velocity] {
  physics3d_component_world_store().velocities
}

///|
pub fn dampings() -> Map[@entity.Entity, Damping] {
  physics3d_component_world_store().dampings
}

///|
pub fn gravity_scales() -> Map[@entity.Entity, GravityScale] {
  physics3d_component_world_store().gravity_scales
}

///|
pub fn locked_axes() -> Map[@entity.Entity, LockedAxes] {
  physics3d_component_world_store().locked_axes
}

///|
pub fn ccds() -> Map[@entity.Entity, Ccd] {
  physics3d_component_world_store().ccds
}

///|
pub fn dominances() -> Map[@entity.Entity, Dominance] {
  physics3d_component_world_store().dominances
}

///|
pub fn additional_mass_properties() -> Map[
  @entity.Entity,
  AdditionalMassProperties,
] {
  physics3d_component_world_store().additional_mass_properties
}

///|
pub fn colliders() -> Map[@entity.Entity, Collider] {
  physics3d_component_world_store().colliders
}

///|
pub fn sensors() -> Map[@entity.Entity, Sensor] {
  physics3d_component_world_store().sensors
}

///|
pub fn frictions() -> Map[@entity.Entity, Friction] {
  physics3d_component_world_store().frictions
}

///|
pub fn restitutions() -> Map[@entity.Entity, Restitution] {
  physics3d_component_world_store().restitutions
}

///|
pub fn collision_groups() -> Map[@entity.Entity, CollisionGroups] {
  physics3d_component_world_store().collision_groups
}

///|
pub fn solver_groups() -> Map[@entity.Entity, SolverGroups] {
  physics3d_component_world_store().solver_groups
}

///|
pub fn active_collision_types() -> Map[
  @entity.Entity,
  @collision.ActiveCollisionTypes,
] {
  physics3d_component_world_store().active_collision_types
}

///|
pub fn active_events() -> Map[@entity.Entity, @collision.ActiveEvents] {
  physics3d_component_world_store().active_events
}

///|
pub fn active_hooks() -> Map[@entity.Entity, @collision.ActiveHooks] {
  physics3d_component_world_store().active_hooks
}

///|
pub fn contact_force_event_thresholds() -> Map[
  @entity.Entity,
  ContactForceEventThreshold,
] {
  physics3d_component_world_store().contact_force_event_thresholds
}

///|
pub fn collider_mass_properties() -> Map[@entity.Entity, ColliderMassProperties] {
  physics3d_component_world_store().collider_mass_properties
}

///|
pub fn impulse_joints() -> Map[@entity.Entity, ImpulseJoint] {
  physics3d_component_world_store().impulse_joints
}

///|
pub fn multibody_joints() -> Map[@entity.Entity, MultibodyJoint] {
  physics3d_component_world_store().multibody_joints
}

///|
pub fn kinematic_character_controllers() -> Map[
  @entity.Entity,
  KinematicCharacterController,
] {
  physics3d_component_world_store().kinematic_character_controllers
}

///|
pub fn kinematic_character_controller_outputs() -> Map[
  @entity.Entity,
  KinematicCharacterControllerOutput,
] {
  physics3d_component_world_store().kinematic_character_controller_outputs
}

///|
pub fn kinematic_character_controller_collisions() -> Map[
  @entity.Entity,
  KinematicCharacterControllerCollisions,
] {
  physics3d_component_world_store().kinematic_character_controller_collisions
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
  mut impulse_joints : @dynamics.JointSet3DReal
  mut rope_joints : @dynamics.RopeJointSet3DReal
  mut multibody_joints : @dynamics.MultibodyJointSet3DReal
  event_handler : @pipeline.EventHandler3D
}

///|
priv struct Physics3DWorldStore {
  world : Physics3DWorld
  body_handles : Map[@entity.Entity, RapierRigidBodyHandle]
  collider_handles : Map[@entity.Entity, RapierColliderHandle]
  impulse_joint_handles : Map[@entity.Entity, RapierImpulseJointHandle]
  multibody_joint_handles : Map[@entity.Entity, RapierMultibodyJointHandle]
  collider_entities_by_key : Map[String, @entity.Entity]
}

///|
let physics3d_world_stores : Map[UInt, Physics3DWorldStore] = Map::new()

///|
fn physics3d_world_store() -> Physics3DWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_world_stores.get_or_init(world_id, () => {
    world: {
      pipeline: @pipeline.PhysicsPipeline3D::new(),
      integration: @dynamics.IntegrationParameters::default(),
      islands: @dynamics.IslandManager3D::new(),
      broad_phase: @collision.BroadPhase3D::new(),
      narrow_phase: @collision.NarrowPhase3D::new(),
      bodies: @dynamics.RigidBodySet3D::new(),
      colliders: @collision.ColliderSet3D::new(),
      impulse_joints: @dynamics.JointSet3DReal::new(),
      rope_joints: @dynamics.RopeJointSet3DReal::new(),
      multibody_joints: @dynamics.MultibodyJointSet3DReal::new(),
      event_handler: @pipeline.EventHandler3D::new(),
    },
    body_handles: Map::new(),
    collider_handles: Map::new(),
    impulse_joint_handles: Map::new(),
    multibody_joint_handles: Map::new(),
    collider_entities_by_key: Map::new(),
  })
}

///|
fn physics3d_world() -> Physics3DWorld {
  physics3d_world_store().world
}

///|
fn body_handles() -> Map[@entity.Entity, RapierRigidBodyHandle] {
  physics3d_world_store().body_handles
}

///|
fn collider_handles() -> Map[@entity.Entity, RapierColliderHandle] {
  physics3d_world_store().collider_handles
}

///|
fn collider_entities_by_key() -> Map[String, @entity.Entity] {
  physics3d_world_store().collider_entities_by_key
}

///|
fn impulse_joint_handles() -> Map[@entity.Entity, RapierImpulseJointHandle] {
  physics3d_world_store().impulse_joint_handles
}

///|
fn multibody_joint_handles() -> Map[@entity.Entity, RapierMultibodyJointHandle] {
  physics3d_world_store().multibody_joint_handles
}

///|
pub let collision_event_bus : @event.Events[CollisionEvent] = @event.Events::new()

///|
pub let sensor_event_bus : @event.Events[SensorEvent] = @event.Events::new()

///|
pub let contact_force_event_bus : @event.Events[ContactForceEvent] = @event.Events::new()

///|
pub fn context() -> RapierContext {
  RapierContext::{  }
}

///|
pub fn set_gravity(gravity : @math.Vec3) -> Unit {
  config.gravity = gravity
}

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> RapierRigidBodyHandle? {
  body_handles().get(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> RapierColliderHandle? {
  collider_handles().get(entity)
}

///|
pub fn impulse_joint_handle(
  entity : @entity.Entity,
) -> RapierImpulseJointHandle? {
  impulse_joint_handles().get(entity)
}

///|
pub fn multibody_joint_handle(
  entity : @entity.Entity,
) -> RapierMultibodyJointHandle? {
  multibody_joint_handles().get(entity)
}

///|
pub fn rigid_body_translation(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.translation()))
    None => None
  }
}

///|
pub fn set_rigid_body_translation(
  entity : @entity.Entity,
  translation : @math.Vec3,
) -> Unit {
  let world_transform = {
    ..current_world_transform(entity).unwrap_or_default(),
    translation,
  }
  set_entity_world_transform(entity, world_transform)
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_translation(translation.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_rotation(entity : @entity.Entity) -> @math.Quat? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.quat_from_rapier(body.rotation()))
    None => None
  }
}

///|
pub fn set_rigid_body_rotation(
  entity : @entity.Entity,
  rotation : @math.Quat,
) -> Unit {
  let world_transform = {
    ..current_world_transform(entity).unwrap_or_default(),
    rotation,
  }
  set_entity_world_transform(entity, world_transform)
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_rotation(rotation.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_linear_velocity(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.linvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @entity.Entity,
  linear_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, linvel: linear_velocity })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_linvel(linear_velocity.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_angular_velocity(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.angvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @entity.Entity,
  angular_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, angvel: angular_velocity })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_angvel(angular_velocity.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
fn rigid_body_desc(entity : @entity.Entity) -> RigidBodyDesc {
  {
    body_type: rigid_bodies().get(entity).unwrap_or(Dynamic),
    velocity: velocities().get(entity).unwrap_or(Velocity::zero()),
    damping: dampings().get(entity).unwrap_or(Damping::default()),
    gravity_scale: gravity_scales()
    .get(entity)
    .unwrap_or(GravityScale::default()),
    locked_axes: locked_axes().get(entity).unwrap_or(LockedAxes::default()),
    ccd_enabled: ccds().contains(entity),
    dominance: dominances().get(entity),
    additional_mass_properties: additional_mass_properties().get(entity),
  }
}

///|
fn collider_desc(entity : @entity.Entity, shape : Collider) -> ColliderDesc {
  {
    shape,
    sensor: sensors().contains(entity),
    friction: frictions().get(entity).unwrap_or(Friction::new(0.5)),
    restitution: restitutions().get(entity).unwrap_or(Restitution::new(0.0)),
    collision_groups: collision_groups()
    .get(entity)
    .unwrap_or(CollisionGroups::all()),
    solver_groups: solver_groups().get(entity),
    active_collision_types: active_collision_types()
    .get(entity)
    .unwrap_or(@collision.ActiveCollisionTypes::default()),
    active_events: active_events()
    .get(entity)
    .unwrap_or(
      @collision.ActiveEvents::collision_events().union(
        @collision.ActiveEvents::intersection_events(),
      ),
    ),
    active_hooks: active_hooks()
    .get(entity)
    .unwrap_or(@collision.ActiveHooks::empty()),
    contact_force_event_threshold: contact_force_event_thresholds()
    .get(entity)
    .unwrap_or(ContactForceEventThreshold::default()),
    mass_properties: collider_mass_properties().get(entity),
  }
}

///|
fn clear_controller_outputs() -> Unit {
  for pair in kinematic_character_controller_outputs().to_array() {
    kinematic_character_controller_outputs().remove(pair.0)
  }
  for pair in kinematic_character_controller_collisions().to_array() {
    kinematic_character_controller_collisions().remove(pair.0)
  }
}

///|
fn finite_scalar(value : Double) -> Bool {
  value == value && value < 1_000_000.0 && value > -1_000_000.0
}

///|
fn finite_vec3(value : @math.Vec3) -> Bool {
  finite_scalar(value.x) && finite_scalar(value.y) && finite_scalar(value.z)
}

///|
fn finite_quat(value : @math.Quat) -> Bool {
  finite_scalar(value.x) &&
  finite_scalar(value.y) &&
  finite_scalar(value.z) &&
  finite_scalar(value.w)
}

///|
pub fn physics_step_system(delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  clear_controller_outputs()
  cleanup_world_components()
  ensure_bodies_and_colliders()
  sync_components_to_rapier()
  sync_impulse_joints_to_rapier()
  sync_multibody_joints_to_rapier()
  sync_character_controllers(delta)

  let world = physics3d_world()
  world.integration = world.integration.with_dt(Float::from_double(delta))
  world.pipeline.step_with_events(
    config.gravity.to_rapier(),
    world.integration,
    world.islands,
    world.broad_phase,
    world.narrow_phase,
    world.bodies,
    world.colliders,
    world.event_handler,
  )
  world.impulse_joints.solve(world.bodies, Float::from_double(delta))
  world.rope_joints.solve(world.bodies, Float::from_double(delta))
  world.multibody_joints.sync_rigid_bodies_from_multibodies(world.bodies)

  collect_events()
  sync_rapier_to_components()
}

///|
pub fn RapierContext::cast_ray(
  _self : RapierContext,
  origin : @math.Vec3,
  direction : @math.Vec3,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> RaycastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let ray = @collision.Ray3::new(
    origin.to_rapier(),
    direction.normalize().to_rapier(),
  )
  match
    query.cast_ray_and_get_normal(
      world.bodies,
      world.colliders,
      ray,
      Float::from_double(max_toi),
      solid,
    ) {
    Some((handle, hit)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          toi: hit.toi().to_double(),
          normal: @math.vec3_from_rapier(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn RapierContext::cast_shape(
  _self : RapierContext,
  shape : Collider,
  origin : @math.Vec3,
  rotation? : @math.Quat = @math.Quat::identity(),
  direction? : @math.Vec3 = @math.Vec3::new(0.0, -1.0, 0.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> ShapeCastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let options = @collision.ShapeCastOptions3::new(
    Float::from_double(max_toi),
    stop_at_penetration,
  )
  let (query_shape, shape_rotation) = to_query_shape_with_rotation(
    shape, rotation,
  )
  match
    query.cast_shape(
      world.bodies,
      world.colliders,
      @core.Isometry3::new(origin.to_rapier(), shape_rotation.to_rapier()),
      direction.normalize().to_rapier(),
      query_shape,
      options,
    ) {
    Some((handle, hit)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          toi: hit.toi().to_double(),
          normal: @math.vec3_from_rapier(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn RapierContext::intersections_with_point(
  _self : RapierContext,
  point : @math.Vec3,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> Array[@entity.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@entity.Entity] = []
  for
    handle in query.intersect_point(
      world.bodies,
      world.colliders,
      point.to_rapier(),
    ) {
    match resolve_collider_entity(handle) {
      Some(entity) => entities.push(entity)
      None => ()
    }
  }
  entities
}

///|
pub fn RapierContext::intersections_with_shape(
  _self : RapierContext,
  shape : Collider,
  origin : @math.Vec3,
  rotation? : @math.Quat = @math.Quat::identity(),
  query_filter? : QueryFilter = QueryFilter::all(),
) -> Array[@entity.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@entity.Entity] = []
  let (query_shape, shape_rotation) = to_query_shape_with_rotation(
    shape, rotation,
  )
  let query_iso = @core.Isometry3::new(
    origin.to_rapier(),
    shape_rotation.to_rapier(),
  )
  let query_aabb = shape_world_aabb(query_shape, origin, shape_rotation)
  for
    handle in query.intersect_aabb_conservative(
      world.bodies,
      world.colliders,
      query_aabb,
    ) {
    guard resolve_collider_entity(handle) is Some(entity) else { continue }
    guard world.colliders.get(handle) is Some(collider) else { continue }
    if shapes_intersect(
        query_shape,
        query_iso,
        collider.shape(),
        collider.position(),
      ) {
      entities.push(entity)
    }
  }
  entities
}

///|
pub fn RapierContext::project_point(
  _self : RapierContext,
  point : @math.Vec3,
  solid? : Bool = true,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> PointProjection? {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  match
    query.project_point(
      world.bodies,
      world.colliders,
      point.to_rapier(),
      1.0e30,
      solid,
    ) {
    Some((handle, projection)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          point: @math.vec3_from_rapier(projection.point()),
          is_inside: projection.is_inside(),
        }
      })
    None => None
  }
}

///|
fn ensure_bodies_and_colliders() -> Unit {
  for entity, _ in rigid_bodies() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_rigid_body(entity))
  }

  for entity, collider in colliders() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_collider(entity, collider_desc(entity, collider)))
  }
}

///|
fn sync_components_to_rapier() -> Unit {
  let world = physics3d_world()
  for entity, _ in rigid_bodies() {
    if !entity.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(handle) else { continue }
    guard world.bodies.get_mut(handle) is Some(body) else { continue }
    let body_desc = rigid_body_desc(entity)

    body.set_linvel(body_desc.velocity.linvel.to_rapier())
    body.set_angvel(body_desc.velocity.angvel.to_rapier())
    body.set_dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))

    match body_desc.body_type {
      KinematicPositionBased =>
        if current_world_transform(entity) is Some(transform) {
          body.set_next_kinematic_translation(transform.translation.to_rapier())
          body.set_next_kinematic_rotation(transform.rotation.to_rapier())
        }
      Fixed =>
        if current_world_transform(entity) is Some(transform) {
          body.set_translation(transform.translation.to_rapier())
          body.set_rotation(transform.rotation.to_rapier())
        }
      _ => ()
    }
  }

  for entity, collider in colliders() {
    if !entity.is_alive() {
      continue
    }
    sync_collider_to_rapier(entity, collider_desc(entity, collider))
  }
}

///|
fn sync_rapier_to_components() -> Unit {
  let world = physics3d_world()
  for entity, handle in body_handles() {
    if !entity.is_alive() {
      continue
    }
    guard world.bodies.get(handle) is Some(body) else { continue }
    let translation = @math.vec3_from_rapier(body.translation())
    let rotation = @math.quat_from_rapier(body.rotation())
    let linvel = @math.vec3_from_rapier(body.linvel())
    let angvel = @math.vec3_from_rapier(body.angvel())
    if !finite_vec3(translation) ||
      !finite_quat(rotation) ||
      !finite_vec3(linvel) ||
      !finite_vec3(angvel) {
      continue
    }
    let world_transform : @transform.Transform = {
      ..current_world_transform(entity).unwrap_or_default(),
      translation,
      rotation,
    }
    let local_transform = match entity.get_parent() {
      Some(parent) =>
        match @transform.compute_global_transform(parent) {
          Some(parent_global) =>
            @transform.GlobalTransform::from_transform(world_transform).reparented_to(
              parent_global,
            )
          None => world_transform
        }
      None => world_transform
    }
    @transform.transforms().set(entity, local_transform)
    velocities().set(entity, { linvel, angvel })
  }
}

///|
fn sync_impulse_joints_to_rapier() -> Unit {
  let world = physics3d_world()
  world.impulse_joints = @dynamics.JointSet3DReal::new()
  world.rope_joints = @dynamics.RopeJointSet3DReal::new()
  for pair in impulse_joint_handles().to_array() {
    impulse_joint_handles().remove(pair.0)
  }
  for entity, impulse_joint in impulse_joints() {
    if !entity.is_alive() || !impulse_joint.parent.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(body_handle) else { continue }
    guard body_handles().get(impulse_joint.parent) is Some(parent_handle) else {
      continue
    }
    match impulse_joint.data {
      Fixed(joint) => {
        let handle = world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          fixed_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Revolute(joint) => {
        let handle = world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          revolute_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Prismatic(joint) => {
        let handle = world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          prismatic_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Spherical(joint) => {
        let handle = world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          spherical_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        if joint.motor_target is Some((target, stiffness, damping)) {
          world.impulse_joints.insert_spherical_motor_rotation(
            body_handle,
            parent_handle,
            target.to_rapier(),
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
        }
        impulse_joint_handles().set(entity, handle)
      }
      Spring(joint) =>
        world.impulse_joints.insert_spring(
          body_handle,
          parent_handle,
          joint.local_anchor1.to_rapier(),
          joint.local_anchor2.to_rapier(),
          Float::from_double(joint.rest_length),
          Float::from_double(joint.stiffness),
          Float::from_double(joint.damping),
          impulse_joint.contacts_enabled,
        )
      Rope(joint) =>
        world.rope_joints.insert(
          body_handle,
          parent_handle,
          Float::from_double(joint.max_distance),
        )
    }
  }
}

///|
fn sync_multibody_joints_to_rapier() -> Unit {
  let world = physics3d_world()
  world.multibody_joints = @dynamics.MultibodyJointSet3DReal::new()
  for pair in multibody_joint_handles().to_array() {
    multibody_joint_handles().remove(pair.0)
  }
  for entity, multibody_joint in multibody_joints() {
    if !entity.is_alive() || !multibody_joint.parent.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(child_handle) else { continue }
    guard body_handles().get(multibody_joint.parent) is Some(parent_handle) else {
      continue
    }
    if child_handle.into_raw_parts() == parent_handle.into_raw_parts() {
      continue
    }
    guard multibody_joint_to_rapier(
        multibody_joint.data,
        contacts_enabled=multibody_joint.contacts_enabled,
      )
      is Some(rapier_joint) else {
      continue
    }
    if world.multibody_joints.insert(
        parent_handle, child_handle, rapier_joint, true,
      )
      is Some(handle) {
      multibody_joint_handles().set(entity, handle)
    }
  }
}

///|
fn sync_character_controllers(delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  let world = physics3d_world()
  let dt = Float::from_double(delta)
  for pair in kinematic_character_controllers().to_array() {
    let entity = pair.0
    let controller = pair.1
    if !entity.is_alive() {
      continue
    }
    let desired_translation = controller.translation.unwrap_or(
      @math.Vec3::zero(),
    )
    let output = {
      desired_translation,
      effective_translation: @math.Vec3::zero(),
      grounded: false,
      is_sliding_down_slope: false,
    }
    guard colliders().get(entity) is Some(shape) else {
      kinematic_character_controller_outputs().set(entity, output)
      kinematic_character_controller_collisions().set(
        entity,
        KinematicCharacterControllerCollisions::empty(),
      )
      continue
    }
    let query_filter = { ..QueryFilter::all(), exclude_entity: Some(entity) }
    let query = make_query_pipeline(query_filter~)
    let rapier_controller = controller_to_rapier(controller)
    let transform = current_world_transform(entity).unwrap_or_default()
    let (query_shape, shape_rotation) = to_query_shape_with_rotation(
      shape,
      transform.rotation,
    )
    let position = @core.Isometry3::new(
      transform.translation.to_rapier(),
      shape_rotation.to_rapier(),
    )
    let rapier_collisions : Array[@control.CharacterCollision3DReal] = []
    let movement = rapier_controller.move_shape(
      dt,
      query,
      world.bodies,
      world.colliders,
      query_shape,
      position,
      desired_translation.to_rapier(),
      fn(collision) { rapier_collisions.push(collision) },
    )
    if controller.apply_impulses_to_dynamic_bodies {
      rapier_controller.solve_character_collision_impulses(
        dt,
        query,
        world.bodies,
        world.colliders,
        query_shape,
        1.0,
        rapier_collisions,
      )
    }
    let effective_translation = @math.vec3_from_rapier(movement.translation())
    kinematic_character_controller_outputs().set(entity, {
      desired_translation,
      effective_translation,
      grounded: movement.is_grounded(),
      is_sliding_down_slope: movement.is_sliding_down_slope(),
    })
    kinematic_character_controller_collisions().set(entity, {
      collisions: rapier_collisions.map(collision => {
        entity: resolve_collider_entity(collision.handle()),
        character_translation_applied: @math.vec3_from_rapier(
          collision.translation_applied(),
        ),
        character_translation_remaining: @math.vec3_from_rapier(
          collision.translation_remaining(),
        ),
        toi: collision.hit().toi().to_double(),
        normal: @math.vec3_from_rapier(collision.hit().normal()),
      }),
    })
    apply_character_controller_translation(entity, effective_translation, delta)
    kinematic_character_controllers().set(entity, {
      ..controller,
      translation: None,
    })
  }
}

///|
fn sync_collider_to_rapier(
  entity : @entity.Entity,
  collider_desc : ColliderDesc,
) -> Unit {
  let world = physics3d_world()
  guard collider_handles().get(entity) is Some(handle) else { return }
  guard world.colliders.get_mut(handle) is Some(collider) else { return }
  let collision_groups = interaction_groups(
    collider_desc.collision_groups.memberships,
    collider_desc.collision_groups.filters,
  )
  let solver = collider_desc.solver_groups.unwrap_or(SolverGroups::all())
  let solver_groups = interaction_groups(solver.memberships, solver.filters)

  match attached_rigid_body_entity(entity) {
    Some(body_entity) =>
      match body_handles().get(body_entity) {
        Some(parent_handle) => {
          let mut parent_changed = true
          match collider.parent() {
            Some(existing_parent) =>
              if existing_parent.into_raw_parts() ==
                parent_handle.into_raw_parts() {
                parent_changed = false
              }
            None => ()
          }
          if parent_changed {
            world.colliders.set_parent(
              handle,
              Some(parent_handle),
              world.bodies,
            )
          }
          let relative_transform = collider_relative_transform(
            entity, body_entity,
          )
          collider.set_local_position(
            @core.Isometry3::new(
              relative_transform.translation.to_rapier(),
              relative_transform.rotation.to_rapier(),
            ),
          )
        }
        None => set_standalone_collider_position(collider, entity)
      }
    None => {
      if collider.parent() is Some(_) {
        world.colliders.set_parent(handle, None, world.bodies)
      }
      set_standalone_collider_position(collider, entity)
    }
  }

  ignore(
    collider
    .set_collision_groups(collision_groups)
    .set_solver_groups(solver_groups)
    .set_enabled(true)
    .set_active_collision_types(collider_desc.active_collision_types)
    .set_active_events(collider_desc.active_events)
    .set_active_hooks(collider_desc.active_hooks)
    .set_contact_force_event_threshold(
      Float::from_double(collider_desc.contact_force_event_threshold.0),
    ),
  )
}

///|
fn ensure_rigid_body(entity : @entity.Entity) -> RapierRigidBodyHandle {
  let world = physics3d_world()
  let body_handles = body_handles()
  if body_handles.get(entity) is Some(handle) {
    if world.bodies.get(handle) is Some(_) {
      return handle
    }
    body_handles.remove(entity)
  }

  let body_desc = rigid_body_desc(entity)
  let transform = current_world_transform(entity).unwrap_or_default()
  let mut builder = match body_desc.body_type {
    Dynamic => @dynamics.RigidBodyBuilder3D::dynamic()
    Fixed => @dynamics.RigidBodyBuilder3D::fixed()
    KinematicPositionBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_position_based()
    KinematicVelocityBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_velocity_based()
  }
  builder = builder
    .translation(transform.translation.to_rapier())
    .rotation(transform.rotation.to_rapier())
    .gravity_scale(Float::from_double(body_desc.gravity_scale.0))
    .dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))
    .linear_damping(Float::from_double(body_desc.damping.linear_damping))
    .angular_damping(Float::from_double(body_desc.damping.angular_damping))
    .ccd_enabled(body_desc.ccd_enabled)
    .linvel(body_desc.velocity.linvel.to_rapier())
    .angvel(body_desc.velocity.angvel.to_rapier())
    .enabled_rotations(
      !body_desc.locked_axes.lock_rotation_x,
      !body_desc.locked_axes.lock_rotation_y,
      !body_desc.locked_axes.lock_rotation_z,
    )
  if body_desc.locked_axes.lock_translation_x &&
    body_desc.locked_axes.lock_translation_y &&
    body_desc.locked_axes.lock_translation_z {
    builder = builder.lock_translations()
  }
  if body_desc.additional_mass_properties is Some(additional) {
    builder = builder.mass_properties(
      additional_mass_properties_to_rapier(additional),
    )
  }
  let handle = world.bodies.insert(builder.build())
  body_handles.set(entity, handle)
  handle
}

///|
fn ensure_collider(
  entity : @entity.Entity,
  collider_desc : ColliderDesc,
) -> RapierColliderHandle {
  let world = physics3d_world()
  let body_handles = body_handles()
  let collider_handles = collider_handles()
  let collider_entities_by_key = collider_entities_by_key()
  if collider_handles.get(entity) is Some(handle) {
    if world.colliders.get(handle) is Some(_) {
      return handle
    }
    collider_handles.remove(entity)
    collider_entities_by_key.remove(collider_key(handle))
  }

  let mut builder = collider_builder_from_desc(collider_desc)
  let body_entity = attached_rigid_body_entity(entity)
  let transform = match body_entity {
    Some(parent_entity) => collider_relative_transform(entity, parent_entity)
    None => current_world_transform(entity).unwrap_or_default()
  }
  builder = builder
    .translation(transform.translation.to_rapier())
    .rotation(transform.rotation.to_rapier())
  let collider = builder.build()

  let handle = if body_entity is Some(body_entity) &&
    body_handles.get(body_entity) is Some(parent_handle) &&
    world.bodies.get(parent_handle) is Some(_) {
    world.colliders.insert_with_parent(collider, parent_handle, world.bodies)
  } else {
    world.colliders.insert(collider)
  }

  collider_handles.set(entity, handle)
  collider_entities_by_key.set(collider_key(handle), entity)
  handle
}

///|
fn collider_builder_from_desc(
  collider_desc : ColliderDesc,
) -> @collision.ColliderBuilder3D {
  let mut builder = match collider_desc.shape {
    Cuboid(half_extents) =>
      @collision.ColliderBuilder3D::cuboid(
        Float::from_double(half_extents.x),
        Float::from_double(half_extents.y),
        Float::from_double(half_extents.z),
      )
    Ball(radius) =>
      @collision.ColliderBuilder3D::ball(Float::from_double(radius))
    CapsuleX(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_x(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleY(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleZ(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_z(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.ColliderBuilder3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cone(half_height, radius) =>
      @collision.ColliderBuilder3D::cone(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    RoundCylinder(half_height, radius, border_radius) =>
      @collision.ColliderBuilder3D::round_cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
        Float::from_double(border_radius),
      )
    Halfspace(normal) =>
      @collision.ColliderBuilder3D::halfspace(normal.normalize().to_rapier())
    ConvexHull(points) =>
      @collision.ColliderBuilder3D::convex_hull(
        points.map(point => point.to_rapier()),
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
    TriMesh(vertices, indices) =>
      @collision.ColliderBuilder3D::trimesh(
        vertices.map(point => point.to_rapier()),
        indices,
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
    Heightfield(heights, nrows, ncols, scale) =>
      @collision.ColliderBuilder3D::heightfield(
        heights.map(Float::from_double),
        nrows,
        ncols,
        scale.to_rapier(),
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
  }

  let groups = interaction_groups(
    collider_desc.collision_groups.memberships,
    collider_desc.collision_groups.filters,
  )
  let solver = collider_desc.solver_groups.unwrap_or(SolverGroups::all())
  let solver_groups = interaction_groups(solver.memberships, solver.filters)
  let mut active_events = @collision.ActiveEvents::collision_events().union(
    @collision.ActiveEvents::intersection_events(),
  )
  if collider_desc.contact_force_event_threshold.0 < 1.0e29 {
    active_events = active_events.union(
      @collision.ActiveEvents::contact_force_events(),
    )
  }

  builder = builder
    .collision_groups(groups)
    .solver_groups(solver_groups)
    .friction(Float::from_double(collider_desc.friction.0))
    .restitution(Float::from_double(collider_desc.restitution.0))
    .sensor(collider_desc.sensor)
    .active_events(collider_desc.active_events.union(active_events))
    .active_collision_types(collider_desc.active_collision_types)
    .active_hooks(collider_desc.active_hooks)
    .enabled(true)
    .contact_force_event_threshold(
      Float::from_double(collider_desc.contact_force_event_threshold.0),
    )
  if collider_desc.mass_properties is Some(Density(density)) {
    builder = builder.density(Float::from_double(density))
  }
  builder
}

///|
fn interaction_groups(
  memberships : Int,
  filters : Int,
) -> @dynamics.InteractionGroups {
  @dynamics.InteractionGroups::new(
    @dynamics.Group::new(memberships),
    @dynamics.Group::new(filters),
    And,
  )
}

///|
fn cleanup_world_components() -> Unit {
  let world = physics3d_world()
  let collider_handles = collider_handles()
  let body_handles = body_handles()
  let impulse_joint_handles = impulse_joint_handles()
  let multibody_joint_handles = multibody_joint_handles()
  let collider_entities_by_key = collider_entities_by_key()
  for pair in collider_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    let missing_component = !colliders().contains(entity)
    if !entity.is_alive() || missing_component {
      world.colliders.remove(handle) |> ignore
      collider_handles.remove(entity)
      collider_entities_by_key.remove(collider_key(handle))
    }
  }

  for pair in body_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    if !entity.is_alive() || !rigid_bodies().contains(entity) {
      world.bodies.remove(handle) |> ignore
      body_handles.remove(entity)
    }
  }

  for pair in impulse_joint_handles.to_array() {
    let entity = pair.0
    if !entity.is_alive() || !impulse_joints().contains(entity) {
      impulse_joint_handles.remove(entity)
    }
  }

  for pair in multibody_joint_handles.to_array() {
    let entity = pair.0
    if !entity.is_alive() || !multibody_joints().contains(entity) {
      multibody_joint_handles.remove(entity)
    }
  }
}

///|
fn collect_events() -> Unit {
  let world = physics3d_world()
  for collision_event in world.event_handler.take_collision_events() {
    let collider1 = collision_event.collider1()
    let collider2 = collision_event.collider2()
    guard resolve_collider_entity(collider1) is Some(entity_a) else { continue }
    guard resolve_collider_entity(collider2) is Some(entity_b) else { continue }
    if collision_event.sensor() {
      sensor_event_bus.send({
        sensor: entity_a,
        other: entity_b,
        entered: collision_event.started(),
      })
    }
    collision_event_bus.send({
      entity_a,
      entity_b,
      started: collision_event.started(),
      stopped: collision_event.stopped(),
      sensor: collision_event.sensor(),
      normal: @math.Vec3::zero(),
    })
  }

  for intersection_event in world.event_handler.take_intersection_events() {
    guard resolve_collider_entity(intersection_event.collider1())
      is Some(sensor_entity) else {
      continue
    }
    guard resolve_collider_entity(intersection_event.collider2())
      is Some(other_entity) else {
      continue
    }
    sensor_event_bus.send({
      sensor: sensor_entity,
      other: other_entity,
      entered: intersection_event.intersecting(),
    })
  }

  for contact_force_event in world.event_handler.take_contact_force_events() {
    guard resolve_collider_entity(contact_force_event.collider1())
      is Some(entity_a) else {
      continue
    }
    guard resolve_collider_entity(contact_force_event.collider2())
      is Some(entity_b) else {
      continue
    }
    contact_force_event_bus.send({
      entity_a,
      entity_b,
      total_force: @math.vec3_from_rapier(contact_force_event.total_force()),
      total_force_magnitude: contact_force_event
      .total_force_magnitude()
      .to_double(),
      max_force_direction: @math.vec3_from_rapier(
        contact_force_event.max_force_direction(),
      ),
      max_force_magnitude: contact_force_event.max_force_magnitude().to_double(),
    })
  }
}

///|
fn fixed_joint_to_rapier(
  joint : FixedJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  @dynamics.GenericJoint3DRealBuilder::new(@dynamics.JointAxesMask3DReal::all())
  .contacts_enabled(contacts_enabled)
  .local_anchor1(joint.local_anchor1.to_rapier())
  .local_anchor2(joint.local_anchor2.to_rapier())
  .local_basis1(joint.local_basis1.to_rapier())
  .local_basis2(joint.local_basis2.to_rapier())
  .build()
}

///|
fn revolute_joint_to_rapier(
  joint : RevoluteJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let locked = @dynamics.JointAxesMask3DReal::lin_axes()
    .or(@dynamics.JointAxesMask3DReal::ang_y())
    .or(@dynamics.JointAxesMask3DReal::ang_z())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(locked)
    .contacts_enabled(contacts_enabled)
    .local_axis1(joint.axis.to_rapier())
    .local_axis2(joint.axis.to_rapier())
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      JointAxis::AngX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      JointAxis::AngX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      JointAxis::AngX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(
      JointAxis::AngX,
      Float::from_double(max_force),
    )
  }
  builder.build()
}

///|
fn prismatic_joint_to_rapier(
  joint : PrismaticJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let locked = @dynamics.JointAxesMask3DReal::lin_y()
    .or(@dynamics.JointAxesMask3DReal::lin_z())
    .or(@dynamics.JointAxesMask3DReal::ang_axes())
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(locked)
    .contacts_enabled(contacts_enabled)
    .local_axis1(joint.axis.to_rapier())
    .local_axis2(joint.axis.to_rapier())
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  if joint.limits is Some((min, max)) {
    builder = builder.limits(
      JointAxis::LinX,
      Float::from_double(min),
      Float::from_double(max),
    )
  }
  if joint.motor_position is Some((target, stiffness, damping)) {
    builder = builder.motor_position(
      JointAxis::LinX,
      Float::from_double(target),
      Float::from_double(stiffness),
      Float::from_double(damping),
    )
  }
  if joint.motor_velocity is Some((target, factor)) {
    builder = builder.motor_velocity(
      JointAxis::LinX,
      Float::from_double(target),
      Float::from_double(factor),
    )
  }
  if joint.max_force is Some(max_force) {
    builder = builder.motor_max_force(
      JointAxis::LinX,
      Float::from_double(max_force),
    )
  }
  builder.build()
}

///|
fn spherical_joint_to_rapier(
  joint : SphericalJoint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint3DReal {
  let mut builder = @dynamics.GenericJoint3DRealBuilder::new(
    @dynamics.JointAxesMask3DReal::lin_axes(),
  ).contacts_enabled(contacts_enabled)
  builder = builder
    .local_anchor1(joint.local_anchor1.to_rapier())
    .local_anchor2(joint.local_anchor2.to_rapier())
  builder.build()
}

///|
fn multibody_joint_to_rapier(
  joint : Joint,
  contacts_enabled? : Bool = true,
) -> @dynamics.GenericJoint? {
  match joint {
    Fixed(fixed_joint) => {
      let anchor1 = fixed_joint.local_anchor1.to_rapier()
      let anchor2 = fixed_joint.local_anchor2.to_rapier()
      let frame1 = @core.Isometry2::new(
        @core.Vec2::new(anchor1.x, anchor1.y),
        @core.Rot2::from_angle(
          fixed_joint.local_basis1.to_rapier().to_scaled_axis().z,
        ),
      )
      let frame2 = @core.Isometry2::new(
        @core.Vec2::new(anchor2.x, anchor2.y),
        @core.Rot2::from_angle(
          fixed_joint.local_basis2.to_rapier().to_scaled_axis().z,
        ),
      )
      Some(
        @dynamics.GenericJoint::default()
        .set_local_frame1(frame1)
        .set_local_frame2(frame2)
        .set_locked_axes(@dynamics.JointAxesMask::all())
        .set_contacts_enabled(contacts_enabled),
      )
    }
    Revolute(revolute_joint) => {
      let mut builder = @dynamics.RevoluteJointBuilder3::new(
        revolute_joint.axis.to_rapier(),
      )
      builder = builder
        .local_anchor1(revolute_joint.local_anchor1.to_rapier())
        .local_anchor2(revolute_joint.local_anchor2.to_rapier())
      if revolute_joint.limits is Some((min, max)) {
        builder = builder.limits(
          Float::from_double(min),
          Float::from_double(max),
        )
      }
      if revolute_joint.motor_position is Some((target, stiffness, damping)) {
        builder = builder.motor_position(
          Float::from_double(target),
          Float::from_double(stiffness),
          Float::from_double(damping),
        )
      }
      if revolute_joint.motor_velocity is Some((target, factor)) {
        builder = builder.motor_velocity(
          Float::from_double(target),
          Float::from_double(factor),
        )
      }
      if revolute_joint.max_force is Some(max_force) {
        builder = builder.motor_max_force(Float::from_double(max_force))
      }
      Some(
        @dynamics.GenericJoint::from_revolute(builder.build()).set_contacts_enabled(
          contacts_enabled,
        ),
      )
    }
    Prismatic(prismatic_joint) => {
      let mut builder = @dynamics.PrismaticJointBuilder3::new(
        prismatic_joint.axis.to_rapier(),
      )
      builder = builder
        .local_anchor1(prismatic_joint.local_anchor1.to_rapier())
        .local_anchor2(prismatic_joint.local_anchor2.to_rapier())
      if prismatic_joint.limits is Some((min, max)) {
        builder = builder.limits(
          Float::from_double(min),
          Float::from_double(max),
        )
      }
      if prismatic_joint.motor_position is Some((target, stiffness, damping)) {
        builder = builder.motor_position(
          Float::from_double(target),
          Float::from_double(stiffness),
          Float::from_double(damping),
        )
      }
      if prismatic_joint.motor_velocity is Some((target, factor)) {
        builder = builder.motor_velocity(
          Float::from_double(target),
          Float::from_double(factor),
        )
      }
      if prismatic_joint.max_force is Some(max_force) {
        builder = builder.motor_max_force(Float::from_double(max_force))
      }
      Some(
        @dynamics.GenericJoint::from_prismatic(builder.build()).set_contacts_enabled(
          contacts_enabled,
        ),
      )
    }
    Rope(rope_joint) => {
      let builder = @dynamics.RopeJointBuilder3::new(
          Float::from_double(rope_joint.max_distance),
        )
        .local_anchor1(rope_joint.local_anchor1.to_rapier())
        .local_anchor2(rope_joint.local_anchor2.to_rapier())
      Some(
        @dynamics.GenericJoint::from_rope(builder.build()).set_contacts_enabled(
          contacts_enabled,
        ),
      )
    }
    Spherical(spherical_joint) => {
      let anchor1 = spherical_joint.local_anchor1.to_rapier()
      let anchor2 = spherical_joint.local_anchor2.to_rapier()
      let mut data = @dynamics.GenericJoint::new(
          @dynamics.JointAxesMask::locked_spherical_axes(),
        )
        .set_contacts_enabled(contacts_enabled)
        .set_local_anchor1(@core.Vec2::new(anchor1.x, anchor1.y))
        .set_local_anchor2(@core.Vec2::new(anchor2.x, anchor2.y))
      if spherical_joint.motor_target is Some((target, stiffness, damping)) {
        let axis = target.to_rapier().to_scaled_axis()
        data = data
          .set_motor_position(
            @dynamics.JointAxis::AngX,
            axis.x,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .set_motor_position(
            @dynamics.JointAxis::AngY,
            axis.y,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .set_motor_position(
            @dynamics.JointAxis::AngZ,
            axis.z,
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
      }
      Some(data)
    }
    Spring(spring_joint) => {
      // Moon Rapier multibody insert expects GenericJoint; we map spring semantics
      // to a rope joint with spring motor targeting the configured rest length.
      let builder = @dynamics.RopeJointBuilder3::new(
          Float::from_double(spring_joint.rest_length),
        )
        .local_anchor1(spring_joint.local_anchor1.to_rapier())
        .local_anchor2(spring_joint.local_anchor2.to_rapier())
        .motor_position(
          Float::from_double(spring_joint.rest_length),
          Float::from_double(spring_joint.stiffness),
          Float::from_double(spring_joint.damping),
        )
      Some(
        @dynamics.GenericJoint::from_rope(builder.build()).set_contacts_enabled(
          contacts_enabled,
        ),
      )
    }
  }
}

///|
fn controller_to_rapier(
  controller : KinematicCharacterController,
) -> @control.KinematicCharacterController3DReal {
  @control.KinematicCharacterController3DReal::new()
  .with_offset(controller.offset)
  .with_slide(controller.slide)
  .with_autostep(controller.autostep)
  .with_max_slope_climb_angle(
    Float::from_double(controller.max_slope_climb_angle),
  )
  .with_min_slope_slide_angle(
    Float::from_double(controller.min_slope_slide_angle),
  )
  .with_snap_to_ground(controller.snap_to_ground)
  .with_normal_nudge_factor(Float::from_double(controller.normal_nudge_factor))
  .with_up(controller.up.to_rapier())
}

///|
fn apply_character_controller_translation(
  entity : @entity.Entity,
  translation : @math.Vec3,
  delta : Double,
) -> Unit {
  if translation.length_squared() <= 0.000000001 {
    return
  }
  let transform = current_world_transform(entity).unwrap_or_default()
  let target = transform.translation + translation
  let target_world_transform = { ..transform, translation: target }
  set_entity_world_transform(entity, target_world_transform)
  match rigid_bodies().get(entity) {
    Some(KinematicPositionBased) =>
      match body_handles().get(entity) {
        Some(handle) =>
          match physics3d_world().bodies.get_mut(handle) {
            Some(body) =>
              body.set_next_kinematic_translation(target.to_rapier())
            None => ()
          }
        None => ()
      }
    Some(KinematicVelocityBased) =>
      if delta > 0.0 {
        let velocity = @math.Vec3::new(
          translation.x / delta,
          translation.y / delta,
          translation.z / delta,
        )
        velocities().set(entity, {
          ..velocities().get(entity).unwrap_or(Velocity::zero()),
          linvel: velocity,
        })
      }
    _ => ()
  }
}

///|
fn make_query_pipeline(
  query_filter? : QueryFilter = QueryFilter::all(),
) -> @collision.QueryPipeline3DReal {
  let world = physics3d_world()
  @collision.QueryPipeline3DReal::new(
    to_query_filter(query_filter),
    world.bodies,
    world.colliders,
  )
}

///|
fn to_query_shape(shape : Collider) -> @collision.Shape3D {
  match shape {
    Cuboid(half_extents) =>
      @collision.Shape3D::cuboid(
        Float::from_double(half_extents.x),
        Float::from_double(half_extents.y),
        Float::from_double(half_extents.z),
      )
    Ball(radius) => @collision.Shape3D::ball(Float::from_double(radius))
    CapsuleX(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleY(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleZ(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.Shape3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cone(half_height, radius) =>
      @collision.Shape3D::cone(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    RoundCylinder(half_height, radius, border_radius) =>
      @collision.Shape3D::round_cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
        Float::from_double(border_radius),
      )
    Halfspace(normal) =>
      @collision.Shape3D::halfspace(normal.normalize().to_rapier())
    ConvexHull(points) =>
      @collision.Shape3D::ConvexHull(
        points.map(point => point.to_rapier()),
        0.0,
      )
    TriMesh(vertices, indices) =>
      @collision.Shape3D::TriMesh(
        vertices.map(point => point.to_rapier()),
        indices,
      )
    Heightfield(heights, nrows, ncols, scale) =>
      @collision.ColliderBuilder3D::heightfield(
        heights.map(Float::from_double),
        nrows,
        ncols,
        scale.to_rapier(),
      )
      .map(builder => builder.build().shape())
      .unwrap_or(@collision.Shape3D::ball(0.0))
  }
}

///|
fn to_query_shape_with_rotation(
  shape : Collider,
  rotation : @math.Quat,
) -> (@collision.Shape3D, @math.Quat) {
  match shape {
    CapsuleX(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Quat::from_axis_angle(@math.Vec3::z_axis(), -1.5707963267948966),
      )
    CapsuleZ(_, _) =>
      (
        to_query_shape(shape),
        rotation *
        @math.Quat::from_axis_angle(@math.Vec3::x_axis(), 1.5707963267948966),
      )
    _ => (to_query_shape(shape), rotation)
  }
}

///|
fn to_query_filter(query_filter : QueryFilter) -> @collision.QueryFilter3DReal {
  let mut filter = match query_filter.body_filter {
    All => @collision.QueryFilter3DReal::new()
    Dynamic => @collision.QueryFilter3DReal::only_dynamic()
    Fixed => @collision.QueryFilter3DReal::only_fixed()
    Kinematic => @collision.QueryFilter3DReal::only_kinematic()
  }
  if query_filter.groups is Some(groups) {
    filter = filter.groups(
      @dynamics.InteractionGroups::new(
        @dynamics.Group::new(groups.memberships),
        @dynamics.Group::new(groups.filters),
        And,
      ),
    )
  }
  if query_filter.exclude_collider is Some(collider_handle) {
    filter = filter.exclude_collider(collider_handle)
  }
  if query_filter.exclude_rigid_body is Some(body_handle) {
    filter = filter.exclude_rigid_body(body_handle)
  }
  if query_filter.exclude_entity is Some(entity) {
    if collider_handles().get(entity) is Some(collider_handle) {
      filter = filter.exclude_collider(collider_handle)
    }
    if body_handles().get(entity) is Some(body_handle) {
      filter = filter.exclude_rigid_body(body_handle)
    }
  }
  if query_filter.exclude_sensors {
    filter = filter.exclude_sensors()
  }
  if query_filter.exclude_solids {
    filter = filter.exclude_solids()
  }
  filter
}

///|
fn shape_world_aabb(
  shape : @collision.Shape3D,
  translation : @math.Vec3,
  rotation : @math.Quat,
) -> @core.Aabb3 {
  let local_aabb = shape.local_aabb()
  let mins = local_aabb.mins
  let maxs = local_aabb.maxs
  let corners = [
    @math.Vec3::new(mins.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(mins.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), mins.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), mins.y.to_double(), maxs.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), maxs.y.to_double(), mins.z.to_double()),
    @math.Vec3::new(maxs.x.to_double(), maxs.y.to_double(), maxs.z.to_double()),
  ]
  let world_points = corners.map(point => {
    rotation.rotate_vec3(point) + translation
  })
  let mut min_point = world_points[0]
  let mut max_point = world_points[0]
  for point in world_points {
    min_point = @math.Vec3::new(
      Double::min(min_point.x, point.x),
      Double::min(min_point.y, point.y),
      Double::min(min_point.z, point.z),
    )
    max_point = @math.Vec3::new(
      Double::max(max_point.x, point.x),
      Double::max(max_point.y, point.y),
      Double::max(max_point.z, point.z),
    )
  }
  @core.Aabb3::from_points(min_point.to_rapier(), max_point.to_rapier())
}

///|
fn shapes_intersect(
  shape_a : @collision.Shape3D,
  iso_a : @core.Isometry3,
  shape_b : @collision.Shape3D,
  iso_b : @core.Isometry3,
) -> Bool {
  match shape_a {
    @collision.Ball(radius_a) =>
      match shape_b {
        @collision.Ball(radius_b) =>
          @collision.compute_ball_ball_contact(
            iso_a.translation,
            radius_a,
            iso_b.translation,
            radius_b,
          )
          is Some(_)
        @collision.Cuboid(half_extents) =>
          @collision.compute_ball_cuboid_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_extents,
          )
          is Some(_)
        @collision.CapsuleY(half_height, capsule_radius) =>
          @collision.compute_ball_capsule_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            capsule_radius,
          )
          is Some(_)
        @collision.Cylinder(half_height, cylinder_radius) =>
          @collision.compute_ball_cylinder_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cylinder_radius,
          )
          is Some(_)
        @collision.Cone(half_height, cone_radius) =>
          @collision.compute_ball_cone_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cone_radius,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_ball_trimesh_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            vertices,
            indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_ball_heightfield_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            points,
            nrows,
            ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Cuboid(half_extents_a) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cuboid(half_extents_b) =>
          @collision.compute_cuboid_cuboid_contact(
            iso_a, half_extents_a, iso_b, half_extents_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cuboid_trimesh_contact(
            iso_a, half_extents_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cuboid_heightfield_contact(
            iso_a, half_extents_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.CapsuleY(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.CapsuleY(half_height_b, radius_b) =>
          @collision.compute_capsule_capsule_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_capsule_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_capsule_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Cylinder(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) | @collision.Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cylinder(half_height_b, radius_b) =>
          @collision.compute_cylinder_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cylinder_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cylinder_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Cone(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cylinder(half_height_b, radius_b) =>
          @collision.compute_cone_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.Cone(half_height_b, radius_b) =>
          @collision.compute_cone_cone_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cone_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cone_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.RoundCylinder(half_height, radius, border_radius) =>
      match shape_b {
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_round_cylinder_trimesh_contact(
            iso_a, half_height, radius, border_radius, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_round_cylinder_heightfield_contact(
            iso_a, half_height, radius, border_radius, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.HalfSpace(normal) =>
      @collision.compute_halfspace_contact(iso_a, normal, iso_b, shape_b)
      is Some(_)
    @collision.TriMesh(_, _) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.Cuboid(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _)
        | @collision.RoundCylinder(_, _, _)
        | @collision.HalfSpace(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Heightfield(_, _, _, _, _) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.Cuboid(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _)
        | @collision.RoundCylinder(_, _, _)
        | @collision.HalfSpace(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    _ =>
      @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
      is Some(_)
  }
}

///|
fn additional_mass_properties_to_rapier(
  props : AdditionalMassProperties,
) -> @core.MassProperties3 {
  match props {
    Mass(mass) =>
      @core.MassProperties3::default().set_mass(Float::from_double(mass), true)
    MassProperties(mass_properties) => mass_properties
  }
}

///|
fn current_world_transform(entity : @entity.Entity) -> @transform.Transform? {
  @transform.compute_global_transform(entity).map(global => {
    global.compute_transform()
  })
}

///|
fn set_entity_world_transform(
  entity : @entity.Entity,
  world_transform : @transform.Transform,
) -> Unit {
  let local_transform = match entity.get_parent() {
    Some(parent) =>
      match @transform.compute_global_transform(parent) {
        Some(parent_global) =>
          @transform.GlobalTransform::from_transform(world_transform).reparented_to(
            parent_global,
          )
        None => world_transform
      }
    None => world_transform
  }
  @transform.transforms().set(entity, local_transform)
}

///|
fn attached_rigid_body_entity(entity : @entity.Entity) -> @entity.Entity? {
  if rigid_bodies().contains(entity) {
    return Some(entity)
  }
  let mut current = entity.get_parent()
  while current is Some(parent) {
    if rigid_bodies().contains(parent) {
      return Some(parent)
    }
    current = parent.get_parent()
  }
  None
}

///|
fn collider_relative_transform(
  entity : @entity.Entity,
  body_entity : @entity.Entity,
) -> @transform.Transform {
  if entity == body_entity {
    return @transform.Transform::identity()
  }
  match
    (
      current_world_transform(entity),
      @transform.compute_global_transform(body_entity),
    ) {
    (Some(entity_world), Some(body_global)) =>
      @transform.GlobalTransform::from_transform(entity_world).reparented_to(
        body_global,
      )
    _ => @transform.transforms().get(entity).unwrap_or_default()
  }
}

///|
fn set_standalone_collider_position(
  collider : @collision.Collider3D,
  entity : @entity.Entity,
) -> Unit {
  match current_world_transform(entity) {
    Some(transform) =>
      collider.set_position(
        @core.Isometry3::new(
          transform.translation.to_rapier(),
          transform.rotation.to_rapier(),
        ),
      )
    None => ()
  }
}

///|
fn resolve_collider_entity(
  handle : @collision.ColliderHandle3D,
) -> @entity.Entity? {
  collider_entities_by_key().get(collider_key(handle))
}

///|
fn collider_key(handle : @collision.ColliderHandle3D) -> String {
  let (id, generation) = handle.into_raw_parts()
  "\{id}:\{generation}"
}
