///|
#derive(Eq, Debug)
pub(all) struct FixedJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  local_basis1 : @math.Rotation3
  local_basis2 : @math.Rotation3
}

///|
pub extend FixedJoint with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FixedJoint with Eq::{not_equal, equal}

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
#derive(Eq, Debug)
pub(all) struct PrismaticJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  axis : @math.Vec3
  limits : (Double, Double)?
  motor_position : (Double, Double, Double)?
  motor_velocity : (Double, Double)?
  max_force : Double?
}

///|
pub extend PrismaticJoint with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PrismaticJoint with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct RopeJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  max_distance : Double
}

///|
pub extend RopeJoint with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RopeJoint with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct SpringJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  rest_length : Double
  stiffness : Double
  damping : Double
}

///|
pub extend SpringJoint with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SpringJoint with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct SphericalJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  motor_target : (@math.Rotation3, Double, Double)?
}

///|
pub extend SphericalJoint with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SphericalJoint with Eq::{not_equal, equal}

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
#selene.component
pub(all) struct ImpulseJoint {
  parent : @ecs.Entity
  data : Joint
  contacts_enabled : Bool
}

///|
#selene.component
pub(all) struct MultibodyJoint {
  parent : @ecs.Entity
  data : Joint
  contacts_enabled : Bool
}

///|
#selene.component
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
#derive(Eq, Debug)
pub(all) struct KinematicCharacterControllerOutput {
  desired_translation : @math.Vec3
  effective_translation : @math.Vec3
  grounded : Bool
  is_sliding_down_slope : Bool
}

///|
pub extend KinematicCharacterControllerOutput with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend KinematicCharacterControllerOutput with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct KinematicCharacterControllerCollision {
  entity : @ecs.Entity?
  character_translation_applied : @math.Vec3
  character_translation_remaining : @math.Vec3
  toi : Double
  normal : @math.Vec3
}

///|
pub extend KinematicCharacterControllerCollision with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend KinematicCharacterControllerCollision with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct KinematicCharacterControllerCollisions {
  collisions : Array[KinematicCharacterControllerCollision]
}

///|
pub extend KinematicCharacterControllerCollisions with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend KinematicCharacterControllerCollisions with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct CollisionEvent {
  entity_a : @ecs.Entity
  entity_b : @ecs.Entity
  started : Bool
  stopped : Bool
  sensor : Bool
  normal : @math.Vec3
}

///|
pub extend CollisionEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CollisionEvent with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct SensorEvent {
  sensor : @ecs.Entity
  other : @ecs.Entity
  entered : Bool
}

///|
pub extend SensorEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SensorEvent with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct ContactForceEvent {
  entity_a : @ecs.Entity
  entity_b : @ecs.Entity
  total_force : @math.Vec3
  total_force_magnitude : Double
  max_force_direction : @math.Vec3
  max_force_magnitude : Double
}

///|
pub extend ContactForceEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ContactForceEvent with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct RaycastHit {
  entity : @ecs.Entity
  toi : Double
  normal : @math.Vec3
}

///|
pub extend RaycastHit with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RaycastHit with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct ShapeCastHit {
  entity : @ecs.Entity
  toi : Double
  normal : @math.Vec3
}

///|
pub extend ShapeCastHit with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ShapeCastHit with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct PointProjection {
  entity : @ecs.Entity
  point : @math.Vec3
  is_inside : Bool
}

///|
pub extend PointProjection with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PointProjection with Eq::{not_equal, equal}

///|
pub(all) struct RapierContext {}

///|
pub(all) struct Physics3DConfig {
  mut gravity : @math.Vec3
}

///|
pub let config : Physics3DConfig = { gravity: Vec3(0.0, -9.81, 0.0), }

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
  { linvel: @math.Vec3::zero(), angvel: @math.Vec3::zero(), }
}

///|
pub fn Damping::Damping() -> Damping {
  { linear_damping: 0.0, angular_damping: 0.0, }
}

///|
pub fn GravityScale::default() -> GravityScale {
  GravityScale(1.0)
}

///|
pub fn LockedAxes::LockedAxes() -> LockedAxes {
  {
    lock_translation_x: false,
    lock_translation_y: false,
    lock_translation_z: false,
    lock_rotation_x: false,
    lock_rotation_y: false,
    lock_rotation_z: false,
  }
}
