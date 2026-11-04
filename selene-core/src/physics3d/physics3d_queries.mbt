///|
pub fn QueryFilter::only_fixed() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Fixed, }
}

///|
pub fn QueryFilter::only_kinematic() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Kinematic, }
}

///|
pub fn FixedJoint::FixedJoint() -> FixedJoint {
  {
    local_anchor1: @math.Vec3::zero(),
    local_anchor2: @math.Vec3::zero(),
    local_basis1: @math.Quat::identity(),
    local_basis2: @math.Quat::identity(),
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
  { collisions: [], }
}

///|
priv struct Physics3DComponentWorldStore {
  active_collision_types : @ecs.ComponentStore[@collision.ActiveCollisionTypes]
  active_events : @ecs.ComponentStore[@collision.ActiveEvents]
  active_hooks : @ecs.ComponentStore[@collision.ActiveHooks]
}

///|
let physics3d_component_world_store_key : @ecs.ResourceKey[
  Physics3DComponentWorldStore,
] = ResourceKey(world => {
  active_collision_types: ComponentStore(world),
  active_events: ComponentStore(world),
  active_hooks: ComponentStore(world),
})

///|
fn physics3d_component_world_store() -> Physics3DComponentWorldStore {
  physics3d_component_world_store_key.get()
}

///|
pub fn rigid_bodies() -> @ecs.ComponentStore[RigidBody] {
  @ecs.components()
}

///|
pub fn velocities() -> @ecs.ComponentStore[Velocity] {
  @ecs.components()
}

///|
pub fn dampings() -> @ecs.ComponentStore[Damping] {
  @ecs.components()
}

///|
pub fn gravity_scales() -> @ecs.ComponentStore[GravityScale] {
  @ecs.components()
}

///|
pub fn locked_axes() -> @ecs.ComponentStore[LockedAxes] {
  @ecs.components()
}

///|
pub fn ccds() -> @ecs.ComponentStore[Ccd] {
  @ecs.components()
}

///|
pub fn dominances() -> @ecs.ComponentStore[Dominance] {
  @ecs.components()
}

///|
pub fn additional_mass_properties() -> @ecs.ComponentStore[
  AdditionalMassProperties,
] {
  @ecs.components()
}

///|
pub fn colliders() -> @ecs.ComponentStore[Collider] {
  @ecs.components()
}

///|
pub fn sensors() -> @ecs.ComponentStore[Sensor] {
  @ecs.components()
}

///|
pub fn frictions() -> @ecs.ComponentStore[Friction] {
  @ecs.components()
}

///|
pub fn restitutions() -> @ecs.ComponentStore[Restitution] {
  @ecs.components()
}

///|
pub fn collision_groups() -> @ecs.ComponentStore[CollisionGroups] {
  @ecs.components()
}

///|
pub fn solver_groups() -> @ecs.ComponentStore[SolverGroups] {
  @ecs.components()
}

///|
pub fn active_collision_types() -> @ecs.ComponentStore[
  @collision.ActiveCollisionTypes,
] {
  physics3d_component_world_store().active_collision_types
}
