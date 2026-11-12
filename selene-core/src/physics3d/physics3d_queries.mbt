///|
pub fn QueryFilter::only_fixed() -> QueryFilter {
  { ..QueryFilter(), body_filter: Fixed, }
}

///|
pub fn QueryFilter::only_kinematic() -> QueryFilter {
  { ..QueryFilter(), body_filter: Kinematic, }
}

///|
pub fn FixedJoint::FixedJoint() -> FixedJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    local_basis1: @math.Rotation3::identity(),
    local_basis2: @math.Rotation3::identity(),
  }
}

///|
pub fn RevoluteJoint::RevoluteJoint(axis : @math.Vec3) -> RevoluteJoint {
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
pub fn PrismaticJoint::PrismaticJoint(axis : @math.Vec3) -> PrismaticJoint {
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
pub fn RopeJoint::RopeJoint(max_distance : Double) -> RopeJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    max_distance,
  }
}

///|
pub fn SpringJoint::SpringJoint(
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
pub fn SphericalJoint::SphericalJoint() -> SphericalJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    motor_target: None,
  }
}

///|
pub fn KinematicCharacterController::KinematicCharacterController() -> KinematicCharacterController {
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
pub fn KinematicCharacterControllerCollisions::KinematicCharacterControllerCollisions() -> KinematicCharacterControllerCollisions {
  { collisions: [], }
}
