///|
pub fn active_events() -> Map[@entity.Entity, @collision.ActiveEvents] {
  physics3d_component_world_store().active_events
}

///|
pub fn active_hooks() -> Map[@entity.Entity, @collision.ActiveHooks] {
  physics3d_component_world_store().active_hooks
}

///|
pub fn contact_force_event_thresholds() -> Map[
  @entity.Entity,
  ContactForceEventThreshold,
] {
  physics3d_component_world_store().contact_force_event_thresholds
}

///|
pub fn collider_mass_properties() -> Map[@entity.Entity, ColliderMassProperties] {
  physics3d_component_world_store().collider_mass_properties
}

///|
pub fn impulse_joints() -> Map[@entity.Entity, ImpulseJoint] {
  physics3d_component_world_store().impulse_joints
}

///|
pub fn multibody_joints() -> Map[@entity.Entity, MultibodyJoint] {
  physics3d_component_world_store().multibody_joints
}

///|
pub fn kinematic_character_controllers() -> Map[
  @entity.Entity,
  KinematicCharacterController,
] {
  physics3d_component_world_store().kinematic_character_controllers
}

///|
pub fn kinematic_character_controller_outputs() -> Map[
  @entity.Entity,
  KinematicCharacterControllerOutput,
] {
  physics3d_component_world_store().kinematic_character_controller_outputs
}

///|
pub fn kinematic_character_controller_collisions() -> Map[
  @entity.Entity,
  KinematicCharacterControllerCollisions,
] {
  physics3d_component_world_store().kinematic_character_controller_collisions
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
  body_handles : Map[@entity.Entity, RapierRigidBodyHandle]
  collider_handles : Map[@entity.Entity, RapierColliderHandle]
  impulse_joint_handles : Map[@entity.Entity, RapierImpulseJointHandle]
  multibody_joint_handles : Map[@entity.Entity, RapierMultibodyJointHandle]
  collider_entities_by_key : Map[String, @entity.Entity]
}

///|
let physics3d_world_stores : Map[UInt, Physics3DWorldStore] = Map([])

///|
fn physics3d_world_store() -> Physics3DWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_world_stores.get_or_init(world_id, () => {
    world: {
      pipeline: @pipeline.PhysicsPipeline3D::new(),
      integration: @dynamics.IntegrationParameters::default(),
      islands: @dynamics.IslandManager3D::new(),
      broad_phase: @collision.BroadPhase3D::new(),
      narrow_phase: @collision.NarrowPhase3D::new(),
      bodies: @dynamics.RigidBodySet3D::new(),
      colliders: @collision.ColliderSet3D::new(),
      impulse_joints: @dynamics.JointSet3DReal::new(),
      rope_joints: @dynamics.RopeJointSet3DReal::new(),
      multibody_joints: @dynamics.MultibodyJointSet3DReal::new(),
      event_handler: @pipeline.EventHandler3D::new(),
    },
    body_handles: Map([]),
    collider_handles: Map([]),
    impulse_joint_handles: Map([]),
    multibody_joint_handles: Map([]),
    collider_entities_by_key: Map([]),
  })
}

///|
fn physics3d_world() -> Physics3DWorld {
  physics3d_world_store().world
}

///|
fn body_handles() -> Map[@entity.Entity, RapierRigidBodyHandle] {
  physics3d_world_store().body_handles
}

///|
fn collider_handles() -> Map[@entity.Entity, RapierColliderHandle] {
  physics3d_world_store().collider_handles
}

///|
fn collider_entities_by_key() -> Map[String, @entity.Entity] {
  physics3d_world_store().collider_entities_by_key
}

///|
fn impulse_joint_handles() -> Map[@entity.Entity, RapierImpulseJointHandle] {
  physics3d_world_store().impulse_joint_handles
}

///|
fn multibody_joint_handles() -> Map[@entity.Entity, RapierMultibodyJointHandle] {
  physics3d_world_store().multibody_joint_handles
}

///|
pub let collision_event_bus : @event.Events[CollisionEvent] = @event.Events()

///|
pub let sensor_event_bus : @event.Events[SensorEvent] = @event.Events()

///|
pub let contact_force_event_bus : @event.Events[ContactForceEvent] = @event.Events()

///|
pub fn context() -> RapierContext {
  RapierContext::{  }
}

///|
pub fn set_gravity(gravity : @math.Vec3) -> Unit {
  config.gravity = gravity
}

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> RapierRigidBodyHandle? {
  body_handles().get(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> RapierColliderHandle? {
  collider_handles().get(entity)
}

///|
pub fn impulse_joint_handle(
  entity : @entity.Entity,
) -> RapierImpulseJointHandle? {
  impulse_joint_handles().get(entity)
}

///|
pub fn multibody_joint_handle(
  entity : @entity.Entity,
) -> RapierMultibodyJointHandle? {
  multibody_joint_handles().get(entity)
}
