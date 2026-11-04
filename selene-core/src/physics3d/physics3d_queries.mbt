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
  rigid_bodies : @ecs.ComponentStore[RigidBody]
  velocities : @ecs.ComponentStore[Velocity]
  dampings : @ecs.ComponentStore[Damping]
  gravity_scales : @ecs.ComponentStore[GravityScale]
  locked_axes : @ecs.ComponentStore[LockedAxes]
  ccds : @ecs.ComponentStore[Ccd]
  dominances : @ecs.ComponentStore[Dominance]
  additional_mass_properties : @ecs.ComponentStore[AdditionalMassProperties]
  colliders : @ecs.ComponentStore[Collider]
  sensors : @ecs.ComponentStore[Sensor]
  frictions : @ecs.ComponentStore[Friction]
  restitutions : @ecs.ComponentStore[Restitution]
  collision_groups : @ecs.ComponentStore[CollisionGroups]
  solver_groups : @ecs.ComponentStore[SolverGroups]
  active_collision_types : @ecs.ComponentStore[@collision.ActiveCollisionTypes]
  active_events : @ecs.ComponentStore[@collision.ActiveEvents]
  active_hooks : @ecs.ComponentStore[@collision.ActiveHooks]
  contact_force_event_thresholds : @ecs.ComponentStore[
    ContactForceEventThreshold,
  ]
  collider_mass_properties : @ecs.ComponentStore[ColliderMassProperties]
  impulse_joints : @ecs.ComponentStore[ImpulseJoint]
  multibody_joints : @ecs.ComponentStore[MultibodyJoint]
  kinematic_character_controllers : @ecs.ComponentStore[
    KinematicCharacterController,
  ]
  kinematic_character_controller_outputs : @ecs.ComponentStore[
    KinematicCharacterControllerOutput,
  ]
  kinematic_character_controller_collisions : @ecs.ComponentStore[
    KinematicCharacterControllerCollisions,
  ]
}

///|
let physics3d_component_world_store_key : @ecs.ResourceKey[
  Physics3DComponentWorldStore,
] = ResourceKey(world => {
  rigid_bodies: ComponentStore(world),
  velocities: ComponentStore(world),
  dampings: ComponentStore(world),
  gravity_scales: ComponentStore(world),
  locked_axes: ComponentStore(world),
  ccds: ComponentStore(world),
  dominances: ComponentStore(world),
  additional_mass_properties: ComponentStore(world),
  colliders: ComponentStore(world),
  sensors: ComponentStore(world),
  frictions: ComponentStore(world),
  restitutions: ComponentStore(world),
  collision_groups: ComponentStore(world),
  solver_groups: ComponentStore(world),
  active_collision_types: ComponentStore(world),
  active_events: ComponentStore(world),
  active_hooks: ComponentStore(world),
  contact_force_event_thresholds: ComponentStore(world),
  collider_mass_properties: ComponentStore(world),
  impulse_joints: ComponentStore(world),
  multibody_joints: ComponentStore(world),
  kinematic_character_controllers: ComponentStore(world),
  kinematic_character_controller_outputs: ComponentStore(
    @ecs.require_current_world(),
  ),
  kinematic_character_controller_collisions: ComponentStore(
    @ecs.require_current_world(),
  ),
})

///|
fn physics3d_component_world_store() -> Physics3DComponentWorldStore {
  physics3d_component_world_store_key.get()
}

///|
pub fn rigid_bodies() -> @ecs.ComponentStore[RigidBody] {
  physics3d_component_world_store().rigid_bodies
}

///|
pub fn velocities() -> @ecs.ComponentStore[Velocity] {
  physics3d_component_world_store().velocities
}

///|
pub fn dampings() -> @ecs.ComponentStore[Damping] {
  physics3d_component_world_store().dampings
}

///|
pub fn gravity_scales() -> @ecs.ComponentStore[GravityScale] {
  physics3d_component_world_store().gravity_scales
}

///|
pub fn locked_axes() -> @ecs.ComponentStore[LockedAxes] {
  physics3d_component_world_store().locked_axes
}

///|
pub fn ccds() -> @ecs.ComponentStore[Ccd] {
  physics3d_component_world_store().ccds
}

///|
pub fn dominances() -> @ecs.ComponentStore[Dominance] {
  physics3d_component_world_store().dominances
}

///|
pub fn additional_mass_properties() -> @ecs.ComponentStore[
  AdditionalMassProperties,
] {
  physics3d_component_world_store().additional_mass_properties
}

///|
pub fn colliders() -> @ecs.ComponentStore[Collider] {
  physics3d_component_world_store().colliders
}

///|
pub fn sensors() -> @ecs.ComponentStore[Sensor] {
  physics3d_component_world_store().sensors
}

///|
pub fn frictions() -> @ecs.ComponentStore[Friction] {
  physics3d_component_world_store().frictions
}

///|
pub fn restitutions() -> @ecs.ComponentStore[Restitution] {
  physics3d_component_world_store().restitutions
}

///|
pub fn collision_groups() -> @ecs.ComponentStore[CollisionGroups] {
  physics3d_component_world_store().collision_groups
}

///|
pub fn solver_groups() -> @ecs.ComponentStore[SolverGroups] {
  physics3d_component_world_store().solver_groups
}

///|
pub fn active_collision_types() -> @ecs.ComponentStore[
  @collision.ActiveCollisionTypes,
] {
  physics3d_component_world_store().active_collision_types
}
