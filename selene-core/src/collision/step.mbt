///|
/// Component queries and Rapier state used by the physics step.
struct PhysicsStep2D {
  runtime : PhysicsWorldRuntime
  entities : @ecs.Entities
  transforms : @transform.Transforms
  collisions : ColliderWorldStore
  collider : @ecs.Query[@ecs.Single[Collider]]
  velocity : @ecs.Query[@ecs.Single[@velocity.Velocity]]
  multibody_joint : @ecs.Query[@ecs.Single[MultibodyJoint]]
  joint : @ecs.Query[@ecs.Single[Joint]]
  node : @ecs.Query[@ecs.Single[@ui.Node]]
  area : @ecs.Query[@ecs.Single[Area]]
  collision_shape : @ecs.Query[@ecs.Single[CollisionShape]]
  rigid_body : @ecs.Query[@ecs.Single[RigidBody]]
  contact_event_bus : @event.EventWriter[ContactEvent]
  trigger_event_bus : @event.EventWriter[TriggerEvent]
}

///|
let physics_step_key : @ecs.ResourceKey[PhysicsStep2D] = ResourceKey()

///|
pub fn PhysicsStep2D::PhysicsStep2D(world : @ecs.World) -> PhysicsStep2D {
  physics_step_key.get_or_insert_with(world, world => {
    runtime: physics_world_runtime(world~),
    entities: Entities(world),
    transforms: Transforms(world),
    collisions: collider_world_store(world~),
    collider: world.query(),
    velocity: world.query(),
    multibody_joint: world.query(),
    joint: world.query(),
    node: world.query(),
    area: world.query(),
    collision_shape: world.query(),
    rigid_body: world.query(),
    contact_event_bus: contact_event_bus.writer(world~),
    trigger_event_bus: trigger_event_bus.writer(world~),
  })
}

///|
pub impl @ecs.SystemParam for PhysicsStep2D with fn prepare(world) {
  let physics = PhysicsStep2D(world)
  _ => physics
}

///|
pub extend PhysicsStep2D with @ecs.SystemParam::{prepare}
