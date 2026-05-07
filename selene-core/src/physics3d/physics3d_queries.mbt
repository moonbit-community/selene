///|
pub fn QueryFilter::only_fixed() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Fixed }
}

///|
pub fn QueryFilter::only_kinematic() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Kinematic }
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
let physics3d_component_world_stores : Map[UInt, Physics3DComponentWorldStore] = Map([],
)

///|
fn physics3d_component_world_store() -> Physics3DComponentWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_component_world_stores.get_or_init(world_id, () => {
    rigid_bodies: Map::of([]),
    velocities: Map::of([]),
    dampings: Map::of([]),
    gravity_scales: Map::of([]),
    locked_axes: Map::of([]),
    ccds: Map::of([]),
    dominances: Map::of([]),
    additional_mass_properties: Map::of([]),
    colliders: Map::of([]),
    sensors: Map::of([]),
    frictions: Map::of([]),
    restitutions: Map::of([]),
    collision_groups: Map::of([]),
    solver_groups: Map::of([]),
    active_collision_types: Map::of([]),
    active_events: Map::of([]),
    active_hooks: Map::of([]),
    contact_force_event_thresholds: Map::of([]),
    collider_mass_properties: Map::of([]),
    impulse_joints: Map::of([]),
    multibody_joints: Map::of([]),
    kinematic_character_controllers: Map::of([]),
    kinematic_character_controller_outputs: Map::of([]),
    kinematic_character_controller_collisions: Map::of([]),
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
