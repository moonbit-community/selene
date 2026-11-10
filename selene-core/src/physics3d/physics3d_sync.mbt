///|
pub fn active_events() -> @ecs.ComponentStore[@collision.ActiveEvents] {
  physics3d_component_world_store().active_events
}

///|
pub fn active_hooks() -> @ecs.ComponentStore[@collision.ActiveHooks] {
  physics3d_component_world_store().active_hooks
}

///|
pub fn contact_force_event_thresholds() -> @ecs.ComponentStore[
  ContactForceEventThreshold,
] {
  @ecs.components()
}

///|
pub fn collider_mass_properties() -> @ecs.ComponentStore[ColliderMassProperties] {
  @ecs.components()
}

///|
pub fn impulse_joints() -> @ecs.ComponentStore[ImpulseJoint] {
  @ecs.components()
}

///|
pub fn multibody_joints() -> @ecs.ComponentStore[MultibodyJoint] {
  @ecs.components()
}

///|
pub fn kinematic_character_controllers() -> @ecs.ComponentStore[
  KinematicCharacterController,
] {
  @ecs.components()
}

///|
pub fn kinematic_character_controller_outputs() -> Map[
  @ecs.Entity,
  KinematicCharacterControllerOutput,
] {
  physics3d_world_store().controller_outputs
}

///|
pub fn kinematic_character_controller_collisions() -> Map[
  @ecs.Entity,
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
  body_handles : Map[@ecs.Entity, RapierRigidBodyHandle]
  collider_handles : Map[@ecs.Entity, RapierColliderHandle]
  impulse_joint_handles : Map[@ecs.Entity, RapierImpulseJointHandle]
  multibody_joint_handles : Map[@ecs.Entity, RapierMultibodyJointHandle]
  controller_outputs : Map[@ecs.Entity, KinematicCharacterControllerOutput]
  controller_collisions : Map[
    @ecs.Entity,
    KinematicCharacterControllerCollisions,
  ]
  collider_entities_by_key : Map[String, @ecs.Entity]
}

///|
let physics3d_world_stores : Map[UInt32, Physics3DWorldStore] = Map([])

///|
fn physics3d_world_store() -> Physics3DWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_world_stores.get_or_init(world_id, () => {
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
    body_handles: Map([]),
    collider_handles: Map([]),
    impulse_joint_handles: Map([]),
    multibody_joint_handles: Map([]),
    controller_outputs: {},
    controller_collisions: {},
    collider_entities_by_key: Map([]),
  })
}

///|
fn physics3d_world() -> Physics3DWorld {
  physics3d_world_store().world
}

///|
fn body_handles() -> Map[@ecs.Entity, RapierRigidBodyHandle] {
  physics3d_world_store().body_handles
}

///|
fn collider_handles() -> Map[@ecs.Entity, RapierColliderHandle] {
  physics3d_world_store().collider_handles
}

///|
fn collider_entities_by_key() -> Map[String, @ecs.Entity] {
  physics3d_world_store().collider_entities_by_key
}

///|
fn impulse_joint_handles() -> Map[@ecs.Entity, RapierImpulseJointHandle] {
  physics3d_world_store().impulse_joint_handles
}

///|
fn multibody_joint_handles() -> Map[@ecs.Entity, RapierMultibodyJointHandle] {
  physics3d_world_store().multibody_joint_handles
}

///|
pub let collision_event_bus : @event.Events[CollisionEvent] = Events()

///|
pub let sensor_event_bus : @event.Events[SensorEvent] = Events()

///|
pub let contact_force_event_bus : @event.Events[ContactForceEvent] = Events()

///|
#warnings("-unnecessary_annotation")
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
