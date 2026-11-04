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
  rigid_bodies : @entity.ComponentStore[RigidBody]
  velocities : @entity.ComponentStore[Velocity]
  dampings : @entity.ComponentStore[Damping]
  gravity_scales : @entity.ComponentStore[GravityScale]
  locked_axes : @entity.ComponentStore[LockedAxes]
  ccds : @entity.ComponentStore[Ccd]
  dominances : @entity.ComponentStore[Dominance]
  additional_mass_properties : @entity.ComponentStore[AdditionalMassProperties]
  colliders : @entity.ComponentStore[Collider]
  sensors : @entity.ComponentStore[Sensor]
  frictions : @entity.ComponentStore[Friction]
  restitutions : @entity.ComponentStore[Restitution]
  collision_groups : @entity.ComponentStore[CollisionGroups]
  solver_groups : @entity.ComponentStore[SolverGroups]
  active_collision_types : @entity.ComponentStore[
    @collision.ActiveCollisionTypes,
  ]
  active_events : @entity.ComponentStore[@collision.ActiveEvents]
  active_hooks : @entity.ComponentStore[@collision.ActiveHooks]
  contact_force_event_thresholds : @entity.ComponentStore[
    ContactForceEventThreshold,
  ]
  collider_mass_properties : @entity.ComponentStore[ColliderMassProperties]
  impulse_joints : @entity.ComponentStore[ImpulseJoint]
  multibody_joints : @entity.ComponentStore[MultibodyJoint]
  kinematic_character_controllers : @entity.ComponentStore[
    KinematicCharacterController,
  ]
  kinematic_character_controller_outputs : @entity.ComponentStore[
    KinematicCharacterControllerOutput,
  ]
  kinematic_character_controller_collisions : @entity.ComponentStore[
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
pub fn rigid_bodies() -> @entity.ComponentStore[RigidBody] {
  physics3d_component_world_store().rigid_bodies
}

///|
pub fn velocities() -> @entity.ComponentStore[Velocity] {
  physics3d_component_world_store().velocities
}

///|
pub fn dampings() -> @entity.ComponentStore[Damping] {
  physics3d_component_world_store().dampings
}

///|
pub fn gravity_scales() -> @entity.ComponentStore[GravityScale] {
  physics3d_component_world_store().gravity_scales
}

///|
pub fn locked_axes() -> @entity.ComponentStore[LockedAxes] {
  physics3d_component_world_store().locked_axes
}

///|
pub fn ccds() -> @entity.ComponentStore[Ccd] {
  physics3d_component_world_store().ccds
}

///|
pub fn dominances() -> @entity.ComponentStore[Dominance] {
  physics3d_component_world_store().dominances
}

///|
pub fn additional_mass_properties() -> @entity.ComponentStore[
  AdditionalMassProperties,
] {
  physics3d_component_world_store().additional_mass_properties
}

///|
pub fn colliders() -> @entity.ComponentStore[Collider] {
  physics3d_component_world_store().colliders
}

///|
pub fn sensors() -> @entity.ComponentStore[Sensor] {
  physics3d_component_world_store().sensors
}

///|
pub fn frictions() -> @entity.ComponentStore[Friction] {
  physics3d_component_world_store().frictions
}

///|
pub fn restitutions() -> @entity.ComponentStore[Restitution] {
  physics3d_component_world_store().restitutions
}

///|
pub fn collision_groups() -> @entity.ComponentStore[CollisionGroups] {
  physics3d_component_world_store().collision_groups
}

///|
pub fn solver_groups() -> @entity.ComponentStore[SolverGroups] {
  physics3d_component_world_store().solver_groups
}

///|
pub fn active_collision_types() -> @entity.ComponentStore[
  @collision.ActiveCollisionTypes,
] {
  physics3d_component_world_store().active_collision_types
}
