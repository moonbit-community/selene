///|
pub(all) struct FixedJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  local_basis1 : @math.Quat
  local_basis2 : @math.Quat
} derive(Eq, Debug)

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
} derive(Eq, Debug)

///|
pub(all) struct RopeJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  max_distance : Double
} derive(Eq, Debug)

///|
pub(all) struct SpringJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  rest_length : Double
  stiffness : Double
  damping : Double
} derive(Eq, Debug)

///|
pub(all) struct SphericalJoint {
  local_anchor1 : @math.Vec3
  local_anchor2 : @math.Vec3
  motor_target : (@math.Quat, Double, Double)?
} derive(Eq, Debug)

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
} derive(Eq, Debug)

///|
pub(all) struct KinematicCharacterControllerCollision {
  entity : @entity.Entity?
  character_translation_applied : @math.Vec3
  character_translation_remaining : @math.Vec3
  toi : Double
  normal : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct KinematicCharacterControllerCollisions {
  collisions : Array[KinematicCharacterControllerCollision]
} derive(Eq, Debug)

///|
pub(all) struct CollisionEvent {
  entity_a : @entity.Entity
  entity_b : @entity.Entity
  started : Bool
  stopped : Bool
  sensor : Bool
  normal : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct SensorEvent {
  sensor : @entity.Entity
  other : @entity.Entity
  entered : Bool
} derive(Eq, Debug)

///|
pub(all) struct ContactForceEvent {
  entity_a : @entity.Entity
  entity_b : @entity.Entity
  total_force : @math.Vec3
  total_force_magnitude : Double
  max_force_direction : @math.Vec3
  max_force_magnitude : Double
} derive(Eq, Debug)

///|
pub(all) struct RaycastHit {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct ShapeCastHit {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct PointProjection {
  entity : @entity.Entity
  point : @math.Vec3
  is_inside : Bool
} derive(Eq, Debug)

///|
pub(all) struct RapierContext {}

///|
pub(all) struct Physics3DConfig {
  mut gravity : @math.Vec3
}

///|
pub let config : Physics3DConfig = { gravity: @math.Vec3(0.0, -9.81, 0.0) }

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
