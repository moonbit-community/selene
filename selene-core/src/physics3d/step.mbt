///|
/// Component queries and Rapier state used by the physics step.
struct PhysicsStep3D {
  runtime : Physics3DWorldStore
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
  transforms : @transform.Transforms
  rigid_body : @ecs.Query[@ecs.Single[RigidBody]]
  collider : @ecs.Query[@ecs.Single[Collider]]
  impulse_joint : @ecs.Query[@ecs.Single[ImpulseJoint]]
  multibody_joint : @ecs.Query[@ecs.Single[MultibodyJoint]]
  sensor : @ecs.Query[@ecs.Single[Sensor]]
  friction : @ecs.Query[@ecs.Single[Friction]]
  restitution : @ecs.Query[@ecs.Single[Restitution]]
  collision_groups : @ecs.Query[@ecs.Single[CollisionGroups]]
  solver_groups : @ecs.Query[@ecs.Single[SolverGroups]]
  active_collision_types : @ecs.Query[@ecs.Single[ActiveCollisionTypes]]
  active_events : @ecs.Query[@ecs.Single[ActiveEvents]]
  active_hooks : @ecs.Query[@ecs.Single[ActiveHooks]]
  contact_force_event_threshold : @ecs.Query[
    @ecs.Single[ContactForceEventThreshold],
  ]
  collider_mass_properties : @ecs.Query[@ecs.Single[ColliderMassProperties]]
  velocity : @ecs.Query[@ecs.Single[Velocity]]
  ccd : @ecs.Query[@ecs.Single[Ccd]]
  damping : @ecs.Query[@ecs.Single[Damping]]
  gravity_scale : @ecs.Query[@ecs.Single[GravityScale]]
  locked_axes : @ecs.Query[@ecs.Single[LockedAxes]]
  dominance : @ecs.Query[@ecs.Single[Dominance]]
  additional_mass_properties : @ecs.Query[@ecs.Single[AdditionalMassProperties]]
  spatial : @ecs.Query[@ecs.Single[@transform.Spatial]]
  kinematic_character_controller : @ecs.Query[
    @ecs.Single[KinematicCharacterController],
  ]
  sensor_event_bus : @event.EventWriter[SensorEvent]
  collision_event_bus : @event.EventWriter[CollisionEvent]
  contact_force_event_bus : @event.EventWriter[ContactForceEvent]
}

///|
let physics_step_key : @ecs.ResourceKey[PhysicsStep3D] = ResourceKey()

///|
pub fn PhysicsStep3D::PhysicsStep3D(world : @ecs.World) -> PhysicsStep3D {
  physics_step_key.get_or_insert_with(world, world => {
    runtime: physics3d_world_store(world~),
    entities: Entities(world),
    hierarchy: Hierarchy(world),
    transforms: Transforms(world),
    rigid_body: world.query(),
    collider: world.query(),
    impulse_joint: world.query(),
    multibody_joint: world.query(),
    sensor: world.query(),
    friction: world.query(),
    restitution: world.query(),
    collision_groups: world.query(),
    solver_groups: world.query(),
    active_collision_types: world.query(),
    active_events: world.query(),
    active_hooks: world.query(),
    contact_force_event_threshold: world.query(),
    collider_mass_properties: world.query(),
    velocity: world.query(),
    ccd: world.query(),
    damping: world.query(),
    gravity_scale: world.query(),
    locked_axes: world.query(),
    dominance: world.query(),
    additional_mass_properties: world.query(),
    spatial: world.query(),
    kinematic_character_controller: world.query(),
    sensor_event_bus: sensor_event_bus.writer(world~),
    collision_event_bus: collision_event_bus.writer(world~),
    contact_force_event_bus: contact_force_event_bus.writer(world~),
  })
}

///|
pub impl @ecs.SystemParam for PhysicsStep3D with fn prepare(world) {
  let physics = PhysicsStep3D(world)
  _ => physics
}

///|
pub extend PhysicsStep3D with @ecs.SystemParam::{prepare}
