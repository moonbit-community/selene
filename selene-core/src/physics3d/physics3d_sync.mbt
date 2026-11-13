///|
fn kinematic_character_controller_outputs() -> @ecs.EntityTable[
  KinematicCharacterControllerOutput,
] {
  physics3d_world_store().controller_outputs
}

///|
fn controller_collisions() -> @ecs.EntityTable[
  KinematicCharacterControllerCollisions,
] {
  physics3d_world_store().controller_collisions
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
  body_handles : @ecs.EntityTable[RapierRigidBodyHandle]
  collider_handles : @ecs.EntityTable[RapierColliderHandle]
  impulse_joint_handles : @ecs.EntityTable[RapierImpulseJointHandle]
  multibody_joint_handles : @ecs.EntityTable[RapierMultibodyJointHandle]
  controller_outputs : @ecs.EntityTable[KinematicCharacterControllerOutput]
  controller_collisions : @ecs.EntityTable[
    KinematicCharacterControllerCollisions,
  ]
  collider_entities_by_key : Map[(Int32, Int32), @ecs.Entity]
}

///|
let physics3d_world_store_key : @ecs.ResourceKey[Physics3DWorldStore] = ResourceKey()

///|
fn physics3d_world_store(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> Physics3DWorldStore {
  physics3d_world_store_key.get_or_insert_with(world, world => {
    world: {
      pipeline: PhysicsPipeline3D(),
      integration: @dynamics.IntegrationParameters::default(),
      islands: IslandManager3D(),
      broad_phase: BroadPhase3D(),
      narrow_phase: NarrowPhase3D(),
      bodies: RigidBodySet3D(),
      colliders: ColliderSet3D(),
      impulse_joints: JointSet3DReal(),
      rope_joints: RopeJointSet3DReal(),
      multibody_joints: MultibodyJointSet3DReal(),
      event_handler: EventHandler3D(),
    },
    body_handles: EntityTable(world),
    collider_handles: EntityTable(world),
    impulse_joint_handles: EntityTable(world),
    multibody_joint_handles: EntityTable(world),
    controller_outputs: EntityTable(world),
    controller_collisions: EntityTable(world),
    collider_entities_by_key: Map([]),
  })
}

///|
fn physics3d_world() -> Physics3DWorld {
  physics3d_world_store().world
}

///|
fn body_handles() -> @ecs.EntityTable[RapierRigidBodyHandle] {
  physics3d_world_store().body_handles
}

///|
fn collider_handles() -> @ecs.EntityTable[RapierColliderHandle] {
  physics3d_world_store().collider_handles
}

///|
fn impulse_joint_handles() -> @ecs.EntityTable[RapierImpulseJointHandle] {
  physics3d_world_store().impulse_joint_handles
}

///|
fn multibody_joint_handles() -> @ecs.EntityTable[RapierMultibodyJointHandle] {
  physics3d_world_store().multibody_joint_handles
}

///|
pub let collision_event_bus : @event.Events[CollisionEvent] = Events()

///|
pub let sensor_event_bus : @event.Events[SensorEvent] = Events()

///|
pub let contact_force_event_bus : @event.Events[ContactForceEvent] = Events()

///|
pub fn context() -> RapierContext {
  RapierContext::{ }
}

///|
pub fn set_gravity(gravity : @math.Vec3) -> Unit {
  config.gravity = gravity
}

///|
pub fn rigid_body_handle(entity : @ecs.Entity) -> RapierRigidBodyHandle? {
  body_handles().get(entity)
}

///|
pub fn collider_handle(entity : @ecs.Entity) -> RapierColliderHandle? {
  collider_handles().get(entity)
}

///|
pub fn impulse_joint_handle(entity : @ecs.Entity) -> RapierImpulseJointHandle? {
  impulse_joint_handles().get(entity)
}

///|
pub fn multibody_joint_handle(
  entity : @ecs.Entity,
) -> RapierMultibodyJointHandle? {
  multibody_joint_handles().get(entity)
}

///|
/// Reads the character motion result from the latest physics step.
pub fn kinematic_character_controller_output(
  entity : @ecs.Entity,
) -> KinematicCharacterControllerOutput? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  kinematic_character_controller_outputs().get(entity)
}

///|
/// Reads character contacts from the latest physics step. The returned array
/// is a copy, so modifying it cannot change the stored physics result.
pub fn kinematic_character_controller_collisions(
  entity : @ecs.Entity,
) -> KinematicCharacterControllerCollisions? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  controller_collisions()
  .get(entity)
  .map(result => { collisions: result.collisions.copy(), })
}
