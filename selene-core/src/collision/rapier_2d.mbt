// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
const EPSILON = 0.000000001

///|
pub(all) struct PhysicsConfig {
  mut gravity : @math.Vec2D
  mut pixels_per_meter : Double
  mut max_ccd_substeps : Int
}

///|
pub let physics_config : PhysicsConfig = {
  gravity: @math.Vec2D::zero(),
  pixels_per_meter: 100.0,
  max_ccd_substeps: 1,
}

///|
pub fn configure_physics(
  gravity? : @math.Vec2D,
  pixels_per_meter? : Double,
  max_ccd_substeps? : Int,
) -> Unit {
  if gravity is Some(gravity) {
    physics_config.gravity = gravity
  }
  if pixels_per_meter is Some(ppm) && ppm > 0.0 {
    physics_config.pixels_per_meter = ppm
  }
  if max_ccd_substeps is Some(substeps) && substeps > 0 {
    physics_config.max_ccd_substeps = substeps
  }
}

///|
priv struct PhysicsWorld {
  pipeline : @rapier_pipeline.PhysicsPipeline
  mut integration : @rapier_dynamics.IntegrationParameters
  islands : @rapier_dynamics.IslandManager
  broad_phase : @rapier_collision.BroadPhaseBvh
  narrow_phase : @rapier_collision.NarrowPhase
  bodies : @rapier_dynamics.RigidBodySet
  colliders : @rapier_collision.ColliderSet
  impulse_joints : @rapier_dynamics.ImpulseJointSet
  multibody_joints : @rapier_dynamics.MultibodyJointSet
  ccd_solver : @rapier_dynamics.CCDSolver
  event_handler : @rapier_pipeline.EventHandler
  entity_bodies : Map[@entity.Entity, @rapier_dynamics.RigidBodyHandle]
  entity_colliders : Map[@entity.Entity, @rapier_collision.ColliderHandle]
  collider_entities : Map[Int, @entity.Entity]
  entity_joints : Map[@entity.Entity, JointHandle]
  entity_multibody_joints : Map[@entity.Entity, MultibodyJointHandle]
}

///|
let world : PhysicsWorld = {
  pipeline: @rapier_pipeline.PhysicsPipeline::new(),
  integration: @rapier_dynamics.IntegrationParameters::default(),
  islands: @rapier_dynamics.IslandManager::new(),
  broad_phase: @rapier_collision.BroadPhaseBvh::new(),
  narrow_phase: @rapier_collision.NarrowPhase::new(),
  bodies: @rapier_dynamics.RigidBodySet::new(),
  colliders: @rapier_collision.ColliderSet::new(),
  impulse_joints: @rapier_dynamics.ImpulseJointSet::new(),
  multibody_joints: @rapier_dynamics.MultibodyJointSet::new(),
  ccd_solver: @rapier_dynamics.CCDSolver::new(),
  event_handler: @rapier_pipeline.EventHandler::new(),
  entity_bodies: Map::new(),
  entity_colliders: Map::new(),
  collider_entities: Map::new(),
  entity_joints: Map::new(),
  entity_multibody_joints: Map::new(),
}

///|
priv struct EntityCollisionConfig {
  filter : CollisionFilter
  sensor : Bool
  active : Bool
  friction : Double
  restitution : Double
} derive(Eq)

///|
priv struct EntityPhysicsSnapshot {
  position : @math.Vec2D
  rotation : Double
  shape : CollisionShape
  collision : EntityCollisionConfig
  body : RigidBody
  linear_velocity : @math.Vec2D?
  angular_velocity : Double?
}

///|
priv struct EntityPhysicsConfigKey {
  translation : @math.Vec2D?
  rotation : Double?
  shape : CollisionShape
  collision : EntityCollisionConfig
  body : RigidBody
  linear_velocity : @math.Vec2D?
  angular_velocity : Double?
} derive(Eq)

///|
let entity_physics_config_keys : Map[@entity.Entity, EntityPhysicsConfigKey] = Map::new()

///|
let pending_body_rotations : Map[@entity.Entity, Double] = Map::new()

///|
let pending_body_linear_velocities : Map[@entity.Entity, @math.Vec2D] = Map::new()

///|
let pending_body_angular_velocities : Map[@entity.Entity, Double] = Map::new()

///|
let pending_body_forces : Map[@entity.Entity, @math.Vec2D] = Map::new()

///|
let pending_body_force_points : Map[
  @entity.Entity,
  Array[(@math.Vec2D, @math.Vec2D)],
] = Map::new()

///|
let pending_body_torques : Map[@entity.Entity, Double] = Map::new()

///|
let pending_body_impulses : Map[@entity.Entity, @math.Vec2D] = Map::new()

///|
let pending_body_impulse_points : Map[
  @entity.Entity,
  Array[(@math.Vec2D, @math.Vec2D)],
] = Map::new()

///|
let pending_body_torque_impulses : Map[@entity.Entity, Double] = Map::new()

///|
priv struct EntityJointConfigKey {
  joint : Joint
  body1 : (Int, Int)
  body2 : (Int, Int)
} derive(Eq)

///|
let entity_joint_config_keys : Map[@entity.Entity, EntityJointConfigKey] = Map::new()

///|
priv struct EntityMultibodyJointConfigKey {
  joint : MultibodyJoint
  parent : (Int, Int)
  child : (Int, Int)
} derive(Eq)

///|
let entity_multibody_joint_config_keys : Map[
  @entity.Entity,
  EntityMultibodyJointConfigKey,
] = Map::new()

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> RigidBodyHandle? {
  world.entity_bodies.get(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> ColliderHandle? {
  world.entity_colliders.get(entity)
}

///|
pub fn joint_handle(entity : @entity.Entity) -> JointHandle? {
  world.entity_joints.get(entity)
}

///|
pub fn multibody_joint_handle(
  entity : @entity.Entity,
) -> MultibodyJointHandle? {
  world.entity_multibody_joints.get(entity)
}

///|
pub fn multibody_link(entity : @entity.Entity) -> MultibodyLinkId? {
  guard world.entity_bodies.get(entity) is Some(handle) else {
    return None
  }
  world.multibody_joints.rigid_body_link(handle)
}

///|
pub fn raycast(
  origin : @math.Vec2D,
  direction : @math.Vec2D,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> RaycastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  let normalized = direction.normalize()
  let ray = @rapier_collision.Ray::new(
    to_physics_vec2(origin),
    to_physics_direction(normalized),
  )
  match
    query.cast_ray_and_get_normal(
      world.bodies,
      world.colliders,
      ray,
      Float::from_double(to_physics_scalar(max_toi)),
      solid,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(handle).map(fn(entity) {
        let toi = from_physics_scalar(hit.toi().to_double())
        {
          entity,
          toi,
          point: @math.Vec2D(
            origin[X] + normalized[X] * toi,
            origin[Y] + normalized[Y] * toi,
          ),
          normal: from_physics_direction(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn shape_cast(
  shape : CollisionShape,
  origin : @math.Vec2D,
  rotation? : Double = 0.0,
  direction? : @math.Vec2D = @math.Vec2D(0.0, -1.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> ShapeCastHit? {
  if vec2_length_squared(direction) <= EPSILON {
    return None
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return None
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  let options = @rapier_collision.ShapeCastOptions::new(
    Float::from_double(to_physics_scalar(max_toi)),
    stop_at_penetration,
  )
  match
    query.cast_shape(
      world.bodies,
      world.colliders,
      query_shape_isometry(origin, rotation, translation),
      to_physics_direction(direction.normalize()),
      rapier_shape,
      options,
    ) {
    Some((handle, hit)) =>
      entity_from_collider_handle(handle).map(fn(entity) {
        {
          entity,
          toi: from_physics_scalar(hit.toi().to_double()),
          point: from_physics_vec2(hit.point()),
          normal: from_physics_direction(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn intersect_point(
  point : @math.Vec2D,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_point(world.bodies, world.colliders, to_physics_vec2(point)),
  )
}

///|
pub fn intersect_shape(
  shape : CollisionShape,
  origin : @math.Vec2D,
  rotation? : Double = 0.0,
  query_filter? : SpatialQueryFilter = SpatialQueryFilter::default(),
) -> Array[@entity.Entity] {
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    return []
  }
  refresh_query_world()
  let query = make_query_pipeline(query_filter)
  intersecting_entities(
    query.intersect_shape(
      world.bodies,
      world.colliders,
      query_shape_isometry(origin, rotation, translation),
      rapier_shape,
    ),
  )
}

///|
pub fn rigid_body_translation(entity : @entity.Entity) -> @math.Vec2D? {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get(handle) is Some(body) {
    Some(from_physics_vec2(body.translation()))
  } else {
    @position.positions.get(entity).map(fn(position) { position.0 })
  }
}

///|
pub fn set_rigid_body_translation(
  entity : @entity.Entity,
  translation : @math.Vec2D,
) -> Unit {
  @position.positions.set(entity, translation)
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    match entity_rigid_body(entity).body_type {
      KinematicPositionBased => {
        body.set_translation(to_physics_vec2(translation), true) |> ignore
        body.set_next_kinematic_translation(to_physics_vec2(translation))
        |> ignore
      }
      _ => body.set_translation(to_physics_vec2(translation), true) |> ignore
    }
  }
}

///|
pub fn rigid_body_rotation(entity : @entity.Entity) -> Double? {
  entity_physics_snapshot(entity).map(fn(snapshot) { snapshot.rotation })
}

///|
pub fn set_rigid_body_rotation(
  entity : @entity.Entity,
  rotation : Double,
) -> Unit {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    match entity_rigid_body(entity).body_type {
      KinematicPositionBased => {
        body.set_rotation(to_physics_rotation(rotation), true) |> ignore
        body.set_next_kinematic_rotation(to_physics_rotation(rotation))
        |> ignore
      }
      _ => body.set_rotation(to_physics_rotation(rotation), true) |> ignore
    }
  } else {
    pending_body_rotations.set(entity, rotation)
  }
}

///|
pub fn rigid_body_linear_velocity(entity : @entity.Entity) -> @math.Vec2D? {
  entity_physics_snapshot(entity).map(fn(snapshot) {
    snapshot.linear_velocity.unwrap_or(@math.Vec2D::zero())
  })
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @entity.Entity,
  linear_velocity : @math.Vec2D,
) -> Unit {
  match entity_rigid_body(entity).body_type {
    Fixed => {
      @velocity.velocities.remove(entity)
      pending_body_linear_velocities.remove(entity)
      if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get_mut(handle) is Some(body) {
        body.set_linvel(@rapier_full.Vec2::zero(), false) |> ignore
      }
    }
    Dynamic =>
      if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get_mut(handle) is Some(body) {
        body.set_linvel(to_physics_vec2(linear_velocity), true) |> ignore
      } else {
        pending_body_linear_velocities.set(entity, linear_velocity)
      }
    KinematicPositionBased | KinematicVelocityBased => {
      @velocity.velocities.set(entity, linear_velocity)
      if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get_mut(handle) is Some(body) {
        body.set_linvel(to_physics_vec2(linear_velocity), true) |> ignore
      } else {
        pending_body_linear_velocities.set(entity, linear_velocity)
      }
    }
  }
}

///|
pub fn rigid_body_angular_velocity(entity : @entity.Entity) -> Double? {
  entity_physics_snapshot(entity).map(fn(snapshot) {
    snapshot.angular_velocity.unwrap_or(0.0)
  })
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @entity.Entity,
  angular_velocity : Double,
) -> Unit {
  match entity_rigid_body(entity).body_type {
    Dynamic | KinematicVelocityBased =>
      if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get_mut(handle) is Some(body) {
        body.set_angvel(Float::from_double(angular_velocity), true) |> ignore
      } else {
        pending_body_angular_velocities.set(entity, angular_velocity)
      }
    _ =>
      if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get_mut(handle) is Some(body) {
        body.set_angvel(0.0F, false) |> ignore
      } else {
        pending_body_angular_velocities.remove(entity)
      }
  }
}

///|
pub fn add_force(
  entity : @entity.Entity,
  force : @math.Vec2D,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(force) <= EPSILON {
    return
  }
  if !apply_force_now(entity, force, wake_up) {
    accumulate_pending_vec2(pending_body_forces, entity, force)
  }
}

///|
pub fn add_force_at_point(
  entity : @entity.Entity,
  force : @math.Vec2D,
  point : @math.Vec2D,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(force) <= EPSILON {
    return
  }
  if !apply_force_at_point_now(entity, force, point, wake_up) {
    push_pending_force_point(pending_body_force_points, entity, (force, point))
  }
}

///|
pub fn add_torque(
  entity : @entity.Entity,
  torque : Double,
  wake_up? : Bool = true,
) -> Unit {
  if torque.abs() <= EPSILON {
    return
  }
  if !apply_torque_now(entity, torque, wake_up) {
    accumulate_pending_scalar(pending_body_torques, entity, torque)
  }
}

///|
pub fn apply_impulse(
  entity : @entity.Entity,
  impulse : @math.Vec2D,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(impulse) <= EPSILON {
    return
  }
  if !apply_impulse_now(entity, impulse, wake_up) {
    accumulate_pending_vec2(pending_body_impulses, entity, impulse)
  }
}

///|
pub fn apply_impulse_at_point(
  entity : @entity.Entity,
  impulse : @math.Vec2D,
  point : @math.Vec2D,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(impulse) <= EPSILON {
    return
  }
  if !apply_impulse_at_point_now(entity, impulse, point, wake_up) {
    push_pending_force_point(
      pending_body_impulse_points,
      entity,
      (impulse, point),
    )
  }
}

///|
pub fn apply_torque_impulse(
  entity : @entity.Entity,
  impulse : Double,
  wake_up? : Bool = true,
) -> Unit {
  if impulse.abs() <= EPSILON {
    return
  }
  if !apply_torque_impulse_now(entity, impulse, wake_up) {
    accumulate_pending_scalar(pending_body_torque_impulses, entity, impulse)
  }
}

///|
pub fn reset_forces(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
  pending_body_forces.remove(entity)
  pending_body_force_points.remove(entity)
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.reset_forces(wake_up) |> ignore
  }
}

///|
pub fn reset_torques(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
  pending_body_torques.remove(entity)
  pending_body_torque_impulses.remove(entity)
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.reset_torques(wake_up) |> ignore
  }
}

///|
fn to_physics_scalar(value : Double) -> Double {
  value / physics_config.pixels_per_meter
}

///|
fn from_physics_scalar(value : Double) -> Double {
  value * physics_config.pixels_per_meter
}

///|
fn to_physics_vec2(value : @math.Vec2D) -> @rapier_full.Vec2 {
  @rapier_full.Vec2::new(
    Float::from_double(to_physics_scalar(value[X])),
    Float::from_double(to_physics_scalar(value[Y])),
  )
}

///|
fn to_physics_direction(value : @math.Vec2D) -> @rapier_full.Vec2 {
  @rapier_full.Vec2::new(
    Float::from_double(value[X]),
    Float::from_double(value[Y]),
  )
}

///|
fn from_physics_vec2(value : @rapier_full.Vec2) -> @math.Vec2D {
  @math.Vec2D(
    from_physics_scalar(value.x.to_double()),
    from_physics_scalar(value.y.to_double()),
  )
}

///|
fn from_physics_direction(value : @rapier_full.Vec2) -> @math.Vec2D {
  @math.Vec2D(value.x.to_double(), value.y.to_double())
}

///|
fn to_physics_rotation(value : Double) -> @rapier_full.Rot2 {
  @rapier_full.Rot2::from_angle(Float::from_double(value))
}

///|
fn from_physics_rotation(value : @rapier_full.Rot2) -> Double {
  value.angle().to_double()
}

///|
fn to_physics_isometry(
  translation : @math.Vec2D,
  rotation : Double,
) -> @rapier_full.Isometry2 {
  @rapier_full.Isometry2::new(
    to_physics_vec2(translation),
    to_physics_rotation(rotation),
  )
}

///|
fn rotate_vec2(value : @math.Vec2D, rotation : Double) -> @math.Vec2D {
  from_physics_direction(
    to_physics_rotation(rotation).rotate_vec2(to_physics_direction(value)),
  )
}

///|
fn vec2_length_squared(value : @math.Vec2D) -> Double {
  value[X] * value[X] + value[Y] * value[Y]
}

///|
fn collider_handle_id(handle : @rapier_collision.ColliderHandle) -> Int {
  let (id, _generation) = handle.into_raw_parts()
  id
}

///|
fn world_entity(entity : @entity.Entity) -> Bool {
  !@ui.nodes.contains(entity)
}

///|
fn entity_collision_shape(entity : @entity.Entity) -> CollisionShape? {
  shapes.get(entity)
}

///|
fn legacy_rigid_body(entity : @entity.Entity) -> RigidBody {
  if @velocity.velocities.contains(entity) {
    RigidBody::kinematic_position_based()
  } else {
    RigidBody::fixed()
  }
}

///|
fn entity_rigid_body(entity : @entity.Entity) -> RigidBody {
  rigid_bodies.get(entity).unwrap_or_else(fn() { legacy_rigid_body(entity) })
}

///|
fn entity_collision_config(entity : @entity.Entity) -> EntityCollisionConfig? {
  if areas.get(entity) is Some(area) {
    Some({
      filter: area.filter,
      sensor: true,
      active: area.active,
      friction: 0.0,
      restitution: 0.0,
    })
  } else if colliders.get(entity) is Some(collider) {
    Some({
      filter: collider.filter,
      sensor: false,
      active: collider.active,
      friction: collider.friction,
      restitution: collider.restitution,
    })
  } else {
    None
  }
}

///|
fn entity_rotation(entity : @entity.Entity) -> Double {
  if pending_body_rotations.get(entity) is Some(rotation) {
    rotation
  } else if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get(handle) is Some(body) {
    from_physics_rotation(body.rotation())
  } else {
    0.0
  }
}

///|
fn entity_linear_velocity_for_body(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> @math.Vec2D? {
  match body_type {
    Dynamic =>
      if pending_body_linear_velocities.get(entity) is Some(velocity) {
        Some(velocity)
      } else if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicVelocityBased =>
      if pending_body_linear_velocities.get(entity) is Some(velocity) {
        Some(velocity)
      } else if @velocity.velocities.get(entity) is Some(velocity) {
        Some(velocity.0)
      } else if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get(handle) is Some(body) {
        Some(from_physics_vec2(body.linvel()))
      } else {
        None
      }
    KinematicPositionBased =>
      @velocity.velocities.get(entity).map(fn(velocity) { velocity.0 })
    Fixed => None
  }
}

///|
fn entity_angular_velocity_for_body(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Double? {
  match body_type {
    Dynamic | KinematicVelocityBased =>
      if pending_body_angular_velocities.get(entity) is Some(angular_velocity) {
        Some(angular_velocity)
      } else if world.entity_bodies.get(entity) is Some(handle) &&
        world.bodies.get(handle) is Some(body) {
        Some(body.angvel().to_double())
      } else {
        None
      }
    _ => None
  }
}

///|
fn entity_has_command_rotation(entity : @entity.Entity) -> Bool {
  pending_body_rotations.contains(entity)
}

///|
fn entity_has_command_linear_velocity(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Bool {
  match body_type {
    Dynamic => pending_body_linear_velocities.contains(entity)
    KinematicVelocityBased =>
      pending_body_linear_velocities.contains(entity) ||
      @velocity.velocities.contains(entity)
    KinematicPositionBased => @velocity.velocities.contains(entity)
    Fixed => false
  }
}

///|
fn entity_has_command_angular_velocity(
  entity : @entity.Entity,
  body_type : RigidBodyType,
) -> Bool {
  match body_type {
    Dynamic | KinematicVelocityBased =>
      pending_body_angular_velocities.contains(entity)
    _ => false
  }
}

///|
fn entity_physics_snapshot(entity : @entity.Entity) -> EntityPhysicsSnapshot? {
  guard @position.positions.get(entity) is Some(position) else { return None }
  guard entity_collision_shape(entity) is Some(shape) else { return None }
  guard entity_collision_config(entity) is Some(collision) else { return None }
  let body = entity_rigid_body(entity)
  Some({
    position: position.0,
    rotation: entity_rotation(entity),
    shape,
    collision,
    body,
    linear_velocity: entity_linear_velocity_for_body(entity, body.body_type),
    angular_velocity: entity_angular_velocity_for_body(entity, body.body_type),
  })
}

///|
fn entity_physics_config_key(
  entity : @entity.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> EntityPhysicsConfigKey {
  let translation = match snapshot.body.body_type {
    Fixed | KinematicPositionBased => Some(snapshot.position)
    _ => None
  }
  let rotation = if entity_has_command_rotation(entity) {
    Some(snapshot.rotation)
  } else {
    None
  }
  {
    translation,
    rotation,
    shape: snapshot.shape,
    collision: snapshot.collision,
    body: snapshot.body,
    linear_velocity: if entity_has_command_linear_velocity(
        entity,
        snapshot.body.body_type,
      ) {
      snapshot.linear_velocity
    } else {
      None
    },
    angular_velocity: if entity_has_command_angular_velocity(
        entity,
        snapshot.body.body_type,
      ) {
      snapshot.angular_velocity
    } else {
      None
    },
  }
}

///|
fn should_have_physics(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  entity_physics_snapshot(entity) is Some(_)
}

///|
fn group_from_index(index : Int) -> @rapier_dynamics.Group {
  match index {
    0 => @rapier_dynamics.Group::group_1()
    1 => @rapier_dynamics.Group::group_2()
    2 => @rapier_dynamics.Group::group_3()
    3 => @rapier_dynamics.Group::group_4()
    4 => @rapier_dynamics.Group::group_5()
    5 => @rapier_dynamics.Group::group_6()
    6 => @rapier_dynamics.Group::group_7()
    7 => @rapier_dynamics.Group::group_8()
    8 => @rapier_dynamics.Group::group_9()
    9 => @rapier_dynamics.Group::group_10()
    10 => @rapier_dynamics.Group::group_11()
    11 => @rapier_dynamics.Group::group_12()
    12 => @rapier_dynamics.Group::group_13()
    13 => @rapier_dynamics.Group::group_14()
    14 => @rapier_dynamics.Group::group_15()
    15 => @rapier_dynamics.Group::group_16()
    16 => @rapier_dynamics.Group::group_17()
    17 => @rapier_dynamics.Group::group_18()
    18 => @rapier_dynamics.Group::group_19()
    19 => @rapier_dynamics.Group::group_20()
    20 => @rapier_dynamics.Group::group_21()
    21 => @rapier_dynamics.Group::group_22()
    22 => @rapier_dynamics.Group::group_23()
    23 => @rapier_dynamics.Group::group_24()
    24 => @rapier_dynamics.Group::group_25()
    25 => @rapier_dynamics.Group::group_26()
    26 => @rapier_dynamics.Group::group_27()
    27 => @rapier_dynamics.Group::group_28()
    28 => @rapier_dynamics.Group::group_29()
    29 => @rapier_dynamics.Group::group_30()
    30 => @rapier_dynamics.Group::group_31()
    _ => @rapier_dynamics.Group::group_32()
  }
}

///|
fn group_from_collision(group : CollisionGroup) -> @rapier_dynamics.Group {
  group_from_index(group.value.reinterpret_as_int() % 32)
}

///|
fn groups_from_mask(mask : Array[CollisionGroup]) -> @rapier_dynamics.Group {
  let mut result = @rapier_dynamics.Group::none()
  for group in mask {
    result = result.or(group_from_collision(group))
  }
  result
}

///|
fn to_rapier_groups(
  filter : CollisionFilter,
) -> @rapier_dynamics.InteractionGroups {
  @rapier_dynamics.InteractionGroups::new(
    group_from_collision(filter.group),
    if filter.match_all {
      @rapier_dynamics.Group::all()
    } else {
      groups_from_mask(filter.mask)
    },
    // Selene collision filters are configured as "opt-in on either side":
    // if A allows B or B allows A, they should interact.
    @rapier_dynamics.InteractionTestMode::Or,
  )
}

///|
fn active_events() -> @rapier_collision.ActiveEvents {
  @rapier_collision.ActiveEvents::collision_events().union(
    @rapier_collision.ActiveEvents::intersection_events(),
  )
}

///|
fn collision_shape_to_rapier_shape(
  shape : CollisionShape,
) -> (@rapier_collision.Shape, @math.Vec2D)? {
  match shape {
    Rect(size~, offset~) =>
      if size[X] <= 0.0 || size[Y] <= 0.0 {
        None
      } else {
        Some(
          (
            @rapier_collision.Shape::Cuboid(
              Float::from_double(to_physics_scalar(size[X] * 0.5)),
              Float::from_double(to_physics_scalar(size[Y] * 0.5)),
            ),
            offset + size.scalar_mul(0.5),
          ),
        )
      }
    Ball(radius~, offset~) =>
      if radius <= 0.0 {
        None
      } else {
        Some(
          (
            @rapier_collision.Shape::Ball(
              Float::from_double(to_physics_scalar(radius)),
            ),
            offset,
          ),
        )
      }
    Polygon(points~, offset~) =>
      collision_polygon_to_rapier_shape(points, offset)
    Polyline(points~, offset~, closed~) =>
      collision_polyline_to_rapier_shape(points, offset, closed)
  }
}

///|
fn collision_polygon_to_rapier_shape(
  points : Array[@math.Vec2D],
  offset : @math.Vec2D,
) -> (@rapier_collision.Shape, @math.Vec2D)? {
  let vertices = collision_shape_vertices(points, offset, true)
  if vertices.length() < 3 {
    return None
  }
  let triangles = triangulate_collision_polygon(vertices)
  if triangles.length() == 0 {
    return None
  }
  Some(
    (
      @rapier_collision.Shape::TriMesh(
        collision_shape_to_rapier_points(vertices),
        triangles,
      ),
      @math.Vec2D::zero(),
    ),
  )
}

///|
fn collision_polyline_to_rapier_shape(
  points : Array[@math.Vec2D],
  offset : @math.Vec2D,
  closed : Bool,
) -> (@rapier_collision.Shape, @math.Vec2D)? {
  let vertices = collision_shape_vertices(points, offset, false)
  if vertices.length() < 2 {
    return None
  }
  let segments : Array[(Int, Int)] = []
  for index in 0..<(vertices.length() - 1) {
    segments.push((index, index + 1))
  }
  if closed && vertices.length() > 2 {
    segments.push((vertices.length() - 1, 0))
  }
  if segments.length() == 0 {
    return None
  }
  Some(
    (
      @rapier_collision.Shape::Polyline(
        collision_shape_to_rapier_points(vertices),
        Some(segments),
      ),
      @math.Vec2D::zero(),
    ),
  )
}

///|
fn collision_shape_vertices(
  points : Array[@math.Vec2D],
  offset : @math.Vec2D,
  closed : Bool,
) -> Array[@math.Vec2D] {
  let vertices : Array[@math.Vec2D] = []
  for point in points {
    vertices.push(point + offset)
  }
  if closed &&
    vertices.length() > 1 &&
    collision_points_equal(vertices[0], vertices[vertices.length() - 1]) {
    ignore(vertices.pop())
  }
  vertices
}

///|
fn collision_shape_to_rapier_points(
  points : Array[@math.Vec2D],
) -> Array[@rapier_full.Vec2] {
  points.map(point => to_physics_vec2(point))
}

///|
fn triangulate_collision_polygon(
  points : Array[@math.Vec2D],
) -> Array[(Int, Int, Int)] {
  if points.length() < 3 {
    return []
  }
  let winding = if collision_polygon_signed_area(points) >= 0.0 {
    1.0
  } else {
    -1.0
  }
  let remaining : Array[Int] = []
  for index in 0..<points.length() {
    remaining.push(index)
  }
  let triangles : Array[(Int, Int, Int)] = []
  let mut guard_counter = 0
  while remaining.length() > 3 &&
        guard_counter < points.length() * points.length() {
    let mut ear_found = false
    for current_index in 0..<remaining.length() {
      let previous_index = if current_index == 0 {
        remaining.length() - 1
      } else {
        current_index - 1
      }
      let next_index = if current_index + 1 == remaining.length() {
        0
      } else {
        current_index + 1
      }
      let a_index = remaining[previous_index]
      let b_index = remaining[current_index]
      let c_index = remaining[next_index]
      if !collision_is_ear(
          points, remaining, a_index, b_index, c_index, winding,
        ) {
        continue
      }
      triangles.push((a_index, b_index, c_index))
      let next_remaining : Array[Int] = []
      for index, value in remaining {
        if index != current_index {
          next_remaining.push(value)
        }
      }
      remaining.clear()
      for value in next_remaining {
        remaining.push(value)
      }
      ear_found = true
      break
    }
    if !ear_found {
      return []
    }
    guard_counter += 1
  }
  if remaining.length() == 3 {
    triangles.push((remaining[0], remaining[1], remaining[2]))
  }
  triangles
}

///|
fn collision_is_ear(
  points : Array[@math.Vec2D],
  remaining : Array[Int],
  a_index : Int,
  b_index : Int,
  c_index : Int,
  winding : Double,
) -> Bool {
  let a = points[a_index]
  let b = points[b_index]
  let c = points[c_index]
  let area = collision_triangle_area(a, b, c)
  if winding * area <= EPSILON {
    return false
  }
  for index in remaining {
    if index == a_index || index == b_index || index == c_index {
      continue
    }
    if collision_point_in_triangle(points[index], a, b, c) {
      return false
    }
  }
  true
}

///|
fn collision_polygon_signed_area(points : Array[@math.Vec2D]) -> Double {
  let mut area = 0.0
  for index in 0..<points.length() {
    let next_index = if index + 1 == points.length() { 0 } else { index + 1 }
    area += points[index][X] * points[next_index][Y] -
      points[next_index][X] * points[index][Y]
  }
  area * 0.5
}

///|
fn collision_triangle_area(
  a : @math.Vec2D,
  b : @math.Vec2D,
  c : @math.Vec2D,
) -> Double {
  (b[X] - a[X]) * (c[Y] - a[Y]) - (b[Y] - a[Y]) * (c[X] - a[X])
}

///|
fn collision_point_in_triangle(
  point : @math.Vec2D,
  a : @math.Vec2D,
  b : @math.Vec2D,
  c : @math.Vec2D,
) -> Bool {
  let ab = collision_triangle_area(a, b, point)
  let bc = collision_triangle_area(b, c, point)
  let ca = collision_triangle_area(c, a, point)
  let has_negative = ab < -EPSILON || bc < -EPSILON || ca < -EPSILON
  let has_positive = ab > EPSILON || bc > EPSILON || ca > EPSILON
  !(has_negative && has_positive)
}

///|
fn collision_points_equal(left : @math.Vec2D, right : @math.Vec2D) -> Bool {
  (left[X] - right[X]).abs() <= EPSILON && (left[Y] - right[Y]).abs() <= EPSILON
}

///|
fn query_shape_isometry(
  origin : @math.Vec2D,
  rotation : Double,
  translation : @math.Vec2D,
) -> @rapier_full.Isometry2 {
  let rotated_translation = rotate_vec2(translation, rotation)
  to_physics_isometry(origin + rotated_translation, rotation)
}

///|
fn to_rapier_query_filter(
  query_filter : SpatialQueryFilter,
) -> @rapier_collision.QueryFilter {
  let mut filter = @rapier_collision.QueryFilter::new()
  if query_filter.groups is Some(groups) {
    filter = filter.groups(to_rapier_groups(groups))
  }
  if query_filter.exclude_sensors {
    filter = filter.exclude_sensors()
  }
  if query_filter.exclude_solids {
    filter = filter.exclude_solids()
  }
  filter = match query_filter.body_filter {
    All => filter
    Dynamic => filter.exclude_fixed().exclude_kinematic()
    Fixed => filter.exclude_dynamic().exclude_kinematic()
    Kinematic => filter.exclude_dynamic().exclude_fixed()
  }
  if query_filter.exclude_entity is Some(entity) {
    if world.entity_colliders.get(entity) is Some(handle) {
      filter = filter.exclude_collider(handle)
    } else if world.entity_bodies.get(entity) is Some(handle) {
      filter = filter.exclude_rigid_body(handle)
    }
  }
  filter
}

///|
fn make_query_pipeline(
  query_filter : SpatialQueryFilter,
) -> @rapier_collision.QueryPipeline {
  @rapier_collision.QueryPipeline::new(
    to_rapier_query_filter(query_filter),
    world.bodies,
    world.colliders,
  )
}

///|
fn intersecting_entities(
  handles : Array[@rapier_collision.ColliderHandle],
) -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  for handle in handles {
    guard entity_from_collider_handle(handle) is Some(entity) else { continue }
    if !entities.contains(entity) {
      entities.push(entity)
    }
  }
  entities
}

///|
fn refresh_query_world() -> Unit {
  sync_world_entities()
  world.bodies.propagate_modified_body_positions_to_colliders()
}

///|
fn accumulate_pending_vec2(
  pending : Map[@entity.Entity, @math.Vec2D],
  entity : @entity.Entity,
  value : @math.Vec2D,
) -> Unit {
  pending.set(
    entity,
    pending.get(entity).unwrap_or(@math.Vec2D::zero()) + value,
  )
}

///|
fn accumulate_pending_scalar(
  pending : Map[@entity.Entity, Double],
  entity : @entity.Entity,
  value : Double,
) -> Unit {
  pending.set(entity, pending.get(entity).unwrap_or(0.0) + value)
}

///|
fn push_pending_force_point(
  pending : Map[@entity.Entity, Array[(@math.Vec2D, @math.Vec2D)]],
  entity : @entity.Entity,
  value : (@math.Vec2D, @math.Vec2D),
) -> Unit {
  let values = pending.get(entity).unwrap_or([])
  values.push(value)
  pending.set(entity, values)
}

///|
fn apply_force_now(
  entity : @entity.Entity,
  force : @math.Vec2D,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.add_force(to_physics_vec2(force), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_force_at_point_now(
  entity : @entity.Entity,
  force : @math.Vec2D,
  point : @math.Vec2D,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.add_force_at_point(
      to_physics_vec2(force),
      to_physics_vec2(point),
      wake_up,
    )
    |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_torque_now(
  entity : @entity.Entity,
  torque : Double,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.add_torque(Float::from_double(torque), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_impulse_now(
  entity : @entity.Entity,
  impulse : @math.Vec2D,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.apply_impulse(to_physics_vec2(impulse), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_impulse_at_point_now(
  entity : @entity.Entity,
  impulse : @math.Vec2D,
  point : @math.Vec2D,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.apply_impulse_at_point(
      to_physics_vec2(impulse),
      to_physics_vec2(point),
      wake_up,
    )
    |> ignore
    true
  } else {
    false
  }
}

///|
fn apply_torque_impulse_now(
  entity : @entity.Entity,
  impulse : Double,
  wake_up : Bool,
) -> Bool {
  if world.entity_bodies.get(entity) is Some(handle) &&
    world.bodies.get_mut(handle) is Some(body) {
    body.apply_torque_impulse(Float::from_double(impulse), wake_up) |> ignore
    true
  } else {
    false
  }
}

///|
fn has_pending_body_actions(entity : @entity.Entity) -> Bool {
  pending_body_forces.contains(entity) ||
  pending_body_force_points.contains(entity) ||
  pending_body_torques.contains(entity) ||
  pending_body_impulses.contains(entity) ||
  pending_body_impulse_points.contains(entity) ||
  pending_body_torque_impulses.contains(entity)
}

///|
fn consume_pending_body_actions(entity : @entity.Entity) -> Unit {
  pending_body_forces.remove(entity)
  pending_body_force_points.remove(entity)
  pending_body_torques.remove(entity)
  pending_body_impulses.remove(entity)
  pending_body_impulse_points.remove(entity)
  pending_body_torque_impulses.remove(entity)
}

///|
fn apply_pending_body_actions(entity : @entity.Entity) -> Unit {
  if pending_body_forces.get(entity) is Some(force) {
    ignore(apply_force_now(entity, force, true))
  }
  if pending_body_force_points.get(entity) is Some(force_points) {
    for entry in force_points {
      ignore(apply_force_at_point_now(entity, entry.0, entry.1, true))
    }
  }
  if pending_body_torques.get(entity) is Some(torque) {
    ignore(apply_torque_now(entity, torque, true))
  }
  if pending_body_impulses.get(entity) is Some(impulse) {
    ignore(apply_impulse_now(entity, impulse, true))
  }
  if pending_body_impulse_points.get(entity) is Some(impulse_points) {
    for entry in impulse_points {
      ignore(apply_impulse_at_point_now(entity, entry.0, entry.1, true))
    }
  }
  if pending_body_torque_impulses.get(entity) is Some(torque_impulse) {
    ignore(apply_torque_impulse_now(entity, torque_impulse, true))
  }
  consume_pending_body_actions(entity)
}

///|
fn prune_pending_body_state() -> Unit {
  for _idx, entry in pending_body_rotations.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_rotations.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_linear_velocities.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_linear_velocities.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_angular_velocities.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_angular_velocities.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_forces.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_forces.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_force_points.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_force_points.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_torques.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_torques.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_impulses.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_impulses.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_impulse_points.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_impulse_points.remove(entry.0)
    }
  }
  for _idx, entry in pending_body_torque_impulses.to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_torque_impulses.remove(entry.0)
    }
  }
}

///|
fn motor_model_to_rapier(
  model : JointMotorModel,
) -> @rapier_dynamics.MotorModel {
  match model {
    AccelerationBased => @rapier_dynamics.MotorModel::AccelerationBased
    ForceBased => @rapier_dynamics.MotorModel::ForceBased
  }
}

///|
fn joint_softness_to_rapier(
  softness : JointSoftness,
) -> @rapier_dynamics.SpringCoefficients {
  @rapier_dynamics.SpringCoefficients::new(
    Float::from_double(softness.natural_frequency),
    Float::from_double(softness.damping_ratio),
  )
}

///|
fn body_handle_parts(handle : @rapier_dynamics.RigidBodyHandle) -> (Int, Int) {
  handle.into_raw_parts()
}

///|
fn joint_endpoint_handles(
  joint : Joint,
) -> (@rapier_dynamics.RigidBodyHandle, @rapier_dynamics.RigidBodyHandle)? {
  guard world.entity_bodies.get(joint.entity1) is Some(body1) else {
    return None
  }
  guard world.entity_bodies.get(joint.entity2) is Some(body2) else {
    return None
  }
  if body_handle_parts(body1) == body_handle_parts(body2) {
    None
  } else {
    Some((body1, body2))
  }
}

///|
fn entity_joint_config_key(
  joint : Joint,
  body1 : @rapier_dynamics.RigidBodyHandle,
  body2 : @rapier_dynamics.RigidBodyHandle,
) -> EntityJointConfigKey {
  { joint, body1: body_handle_parts(body1), body2: body_handle_parts(body2) }
}

///|
fn joint_to_rapier(joint : Joint) -> @rapier_dynamics.GenericJoint? {
  let generic = match joint.kind {
    Fixed(local_anchor1~, local_anchor2~) => {
      let builder = @rapier_dynamics.FixedJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      Some(@rapier_dynamics.GenericJoint::from_fixed(builder.build()))
    }
    Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~) => {
      let mut builder = @rapier_dynamics.RevoluteJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      if limits is Some(limits) {
        builder = builder.limits(
          Float::from_double(limits.min),
          Float::from_double(limits.max),
        )
      }
      if softness is Some(softness) {
        builder = builder.softness(joint_softness_to_rapier(softness))
      }
      if motor is Some(motor) {
        match motor {
          Position(target_position~, stiffness~, damping~, max_force~, model~) => {
            builder = builder
              .motor_position(
                Float::from_double(target_position),
                Float::from_double(stiffness),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
          Velocity(target_velocity~, damping~, max_force~, model~) => {
            builder = builder
              .motor_velocity(
                Float::from_double(target_velocity),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
        }
      }
      Some(@rapier_dynamics.GenericJoint::from_revolute(builder.build()))
    }
    Prismatic(axis~, local_anchor1~, local_anchor2~, limits~) =>
      if vec2_length_squared(axis) <= EPSILON {
        None
      } else {
        let mut builder = @rapier_dynamics.PrismaticJointBuilder::new(
            to_physics_direction(axis.normalize()),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
        if limits is Some(limits) {
          builder = builder.limits(
            Float::from_double(to_physics_scalar(limits.min)),
            Float::from_double(to_physics_scalar(limits.max)),
          )
        }
        Some(@rapier_dynamics.GenericJoint::from_prismatic(builder.build()))
      }
    Rope(max_distance~, local_anchor1~, local_anchor2~) =>
      if max_distance < 0.0 {
        None
      } else {
        let builder = @rapier_dynamics.RopeJointBuilder::new(
            Float::from_double(to_physics_scalar(max_distance)),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
        Some(@rapier_dynamics.GenericJoint::from_rope(builder.build()))
      }
    Spring(
      rest_length~,
      stiffness~,
      damping~,
      local_anchor1~,
      local_anchor2~,
      model~
    ) =>
      if rest_length < 0.0 {
        None
      } else {
        let spring = @rapier_dynamics.SpringJointBuilder::new(
            Float::from_double(to_physics_scalar(rest_length)),
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
          .contacts_enabled(joint.contacts_enabled)
          .spring_model(motor_model_to_rapier(model))
          .build()
        Some(spring.data())
      }
  }
  generic.map(fn(generic) {
    generic
    .set_contacts_enabled(joint.contacts_enabled)
    .set_enabled(joint.active)
  })
}

///|
fn multibody_joint_endpoint_handles(
  entity : @entity.Entity,
  joint : MultibodyJoint,
) -> (@rapier_dynamics.RigidBodyHandle, @rapier_dynamics.RigidBodyHandle)? {
  guard world.entity_bodies.get(joint.parent) is Some(parent) else {
    return None
  }
  guard world.entity_bodies.get(entity) is Some(child) else {
    return None
  }
  if body_handle_parts(parent) == body_handle_parts(child) {
    None
  } else {
    Some((parent, child))
  }
}

///|
fn entity_multibody_joint_config_key(
  entity : @entity.Entity,
  joint : MultibodyJoint,
  parent : @rapier_dynamics.RigidBodyHandle,
  child : @rapier_dynamics.RigidBodyHandle,
) -> EntityMultibodyJointConfigKey {
  entity |> ignore
  {
    joint,
    parent: body_handle_parts(parent),
    child: body_handle_parts(child),
  }
}

///|
fn multibody_joint_to_rapier(
  joint : MultibodyJoint,
) -> @rapier_dynamics.RevoluteJoint? {
  if !joint.active {
    return None
  }
  match joint.kind {
    Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~) => {
      let mut builder = @rapier_dynamics.RevoluteJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      if limits is Some(limits) {
        builder = builder.limits(
          Float::from_double(limits.min),
          Float::from_double(limits.max),
        )
      }
      if softness is Some(softness) {
        builder = builder.softness(joint_softness_to_rapier(softness))
      }
      if motor is Some(motor) {
        match motor {
          Position(target_position~, stiffness~, damping~, max_force~, model~) => {
            builder = builder
              .motor_position(
                Float::from_double(target_position),
                Float::from_double(stiffness),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
          Velocity(target_velocity~, damping~, max_force~, model~) => {
            builder = builder
              .motor_velocity(
                Float::from_double(target_velocity),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
        }
      }
      Some(builder.build())
    }
  }
}

///|
fn should_have_joint(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  joints.get(entity) is Some(joint) &&
  joint.entity1.is_alive() &&
  joint.entity2.is_alive() &&
  joint_endpoint_handles(joint) is Some(_)
}

///|
fn remove_joint_physics(entity : @entity.Entity) -> Unit {
  if world.entity_joints.get(entity) is Some(handle) &&
    world.impulse_joints.contains(handle) {
    world.impulse_joints.remove(handle, true) |> ignore
  }
  world.entity_joints.remove(entity)
  entity_joint_config_keys.remove(entity)
}

///|
fn should_have_multibody_joint(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  multibody_joints.get(entity) is Some(joint) &&
  joint.active &&
  joint.parent.is_alive() &&
  multibody_joint_endpoint_handles(entity, joint) is Some(_)
}

///|
fn remove_multibody_joint_physics(entity : @entity.Entity) -> Unit {
  if world.entity_multibody_joints.get(entity) is Some(handle) &&
    world.multibody_joints.get(handle) is Some(_) {
    world.multibody_joints.remove(handle, true)
  }
  world.entity_multibody_joints.remove(entity)
  entity_multibody_joint_config_keys.remove(entity)
}

///|
fn sync_world_joints() -> Unit {
  for _idx, entry in world.entity_joints.to_array() {
    let entity = entry.0
    let handle = entry.1
    if !should_have_joint(entity) || !world.impulse_joints.contains(handle) {
      remove_joint_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard world_entity(entity) else { continue }
    guard joints.get(entity) is Some(joint) else {
      remove_joint_physics(entity)
      continue
    }
    guard joint_endpoint_handles(joint) is Some((body1, body2)) else {
      remove_joint_physics(entity)
      continue
    }
    guard joint_to_rapier(joint) is Some(rapier_joint) else {
      remove_joint_physics(entity)
      continue
    }
    let config_key = entity_joint_config_key(joint, body1, body2)
    if world.entity_joints.get(entity) is Some(handle) &&
      world.impulse_joints.contains(handle) &&
      entity_joint_config_keys.get(entity) == Some(config_key) {
      continue
    }
    remove_joint_physics(entity)
    let handle = world.impulse_joints.insert(body1, body2, rapier_joint, true)
    world.entity_joints.set(entity, handle)
    entity_joint_config_keys.set(entity, config_key)
  }
}

///|
fn sync_world_multibody_joints() -> Unit {
  for _idx, entry in world.entity_multibody_joints.to_array() {
    let entity = entry.0
    let handle = entry.1
    if !should_have_multibody_joint(entity) ||
      world.multibody_joints.get(handle) is None {
      remove_multibody_joint_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard world_entity(entity) else { continue }
    guard multibody_joints.get(entity) is Some(joint) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    guard multibody_joint_endpoint_handles(entity, joint)
      is Some((parent, child)) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    guard multibody_joint_to_rapier(joint) is Some(rapier_joint) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    let config_key = entity_multibody_joint_config_key(
      entity,
      joint,
      parent,
      child,
    )
    if world.entity_multibody_joints.get(entity) is Some(handle) &&
      world.multibody_joints.get(handle) is Some(_) &&
      entity_multibody_joint_config_keys.get(entity) == Some(config_key) {
      continue
    }
    remove_multibody_joint_physics(entity)
    guard world.multibody_joints.insert(parent, child, rapier_joint, true)
      is Some(handle) else {
      continue
    }
    world.entity_multibody_joints.set(entity, handle)
    entity_multibody_joint_config_keys.set(entity, config_key)
  }
}

///|
fn remove_entity_physics(entity : @entity.Entity) -> Unit {
  remove_joint_physics(entity)
  remove_multibody_joint_physics(entity)
  if world.entity_colliders.get(entity) is Some(collider_handle) {
    world.colliders.remove(collider_handle, world.islands, world.bodies, true)
    world.collider_entities.remove(collider_handle_id(collider_handle))
    world.entity_colliders.remove(entity)
  }
  if world.entity_bodies.get(entity) is Some(body_handle) {
    world.bodies.remove(
      body_handle,
      world.islands,
      (),
      world.impulse_joints,
      world.multibody_joints,
      true,
    )
    |> ignore
    world.entity_bodies.remove(entity)
  }
  entity_physics_config_keys.remove(entity)
  entity_multibody_joint_config_keys.remove(entity)
  pending_body_rotations.remove(entity)
  pending_body_linear_velocities.remove(entity)
  pending_body_angular_velocities.remove(entity)
  consume_pending_body_actions(entity)
}

///|
fn consume_pending_body_controls(entity : @entity.Entity) -> Unit {
  pending_body_rotations.remove(entity)
  pending_body_linear_velocities.remove(entity)
  pending_body_angular_velocities.remove(entity)
}

///|
fn sync_world_entities() -> Unit {
  prune_pending_body_state()
  for _idx, entry in world.entity_bodies.to_array() {
    let entity = entry.0
    if !should_have_physics(entity) {
      remove_entity_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard should_have_physics(entity) else { continue }
    guard entity_physics_snapshot(entity) is Some(snapshot)
    let config_key = entity_physics_config_key(entity, snapshot)
    let missing_physics = world.entity_bodies.get(entity) is None ||
      world.entity_colliders.get(entity) is None
    let has_pending_actions = has_pending_body_actions(entity)
    if missing_physics {
      insert_entity_physics(entity, snapshot)
    }
    if missing_physics ||
      entity_physics_config_keys.get(entity) != Some(config_key) {
      sync_entity_physics(entity, snapshot)
      consume_pending_body_controls(entity)
    }
    if has_pending_actions {
      apply_pending_body_actions(entity)
    }
    if missing_physics ||
      entity_physics_config_keys.get(entity) != Some(config_key) ||
      has_pending_actions {
      if entity_physics_snapshot(entity) is Some(next_snapshot) {
        entity_physics_config_keys.set(
          entity,
          entity_physics_config_key(entity, next_snapshot),
        )
      }
    }
  }
}

///|
fn rigid_body_type_to_rapier(
  body_type : RigidBodyType,
) -> @rapier_dynamics.RigidBodyType {
  match body_type {
    Dynamic => @rapier_dynamics.RigidBodyType::Dynamic
    Fixed => @rapier_dynamics.RigidBodyType::Fixed
    KinematicPositionBased =>
      @rapier_dynamics.RigidBodyType::KinematicPositionBased
    KinematicVelocityBased =>
      @rapier_dynamics.RigidBodyType::KinematicVelocityBased
  }
}

///|
fn insert_entity_physics(
  entity : @entity.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> Unit {
  guard collision_shape_to_rapier_shape(snapshot.shape)
    is Some((rapier_shape, translation))
  let active_hooks = if snapshot.collision.sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }
  let mut body_builder = match snapshot.body.body_type {
    Dynamic => @rapier_full.RigidBodyBuilder::dynamic()
    Fixed => @rapier_full.RigidBodyBuilder::fixed()
    KinematicPositionBased =>
      @rapier_full.RigidBodyBuilder::kinematic_position_based()
    KinematicVelocityBased =>
      @rapier_full.RigidBodyBuilder::kinematic_velocity_based()
  }
  body_builder = body_builder
    .translation(to_physics_vec2(snapshot.position))
    .rotation(to_physics_rotation(snapshot.rotation))
    .gravity_scale(Float::from_double(snapshot.body.gravity_scale))
    .linear_damping(Float::from_double(snapshot.body.linear_damping))
    .angular_damping(Float::from_double(snapshot.body.angular_damping))
    .ccd_enabled(snapshot.body.ccd_enabled)
  if snapshot.body.lock_rotation {
    body_builder = body_builder.lock_rotations()
  }
  if snapshot.linear_velocity is Some(linear_velocity) &&
    snapshot.body.body_type != Fixed {
    body_builder = body_builder.linvel(to_physics_vec2(linear_velocity))
  }
  if snapshot.angular_velocity is Some(angular_velocity) &&
    snapshot.body.body_type != Fixed &&
    snapshot.body.body_type != KinematicPositionBased {
    body_builder = body_builder.angvel(Float::from_double(angular_velocity))
  }
  let body_handle = world.bodies.insert(body_builder.build())
  let collider = @rapier_full.ColliderBuilder::new(rapier_shape)
    .translation(to_physics_vec2(translation))
    .active_collision_types(@rapier_collision.ActiveCollisionTypes::all())
    .sensor(snapshot.collision.sensor)
    .active_hooks(active_hooks)
    .collision_groups(to_rapier_groups(snapshot.collision.filter))
    .solver_groups(to_rapier_groups(snapshot.collision.filter))
    .active_events(active_events())
    .friction(Float::from_double(snapshot.collision.friction))
    .restitution(Float::from_double(snapshot.collision.restitution))
    .enabled(snapshot.collision.active)
    .build()
  let collider_handle = world.colliders.insert_with_parent(
    collider,
    body_handle,
    world.bodies,
  )
  world.entity_bodies.set(entity, body_handle)
  world.entity_colliders.set(entity, collider_handle)
  world.collider_entities.set(collider_handle_id(collider_handle), entity)
}

///|
fn sync_entity_physics(
  entity : @entity.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> Unit {
  guard world.entity_bodies.get(entity) is Some(body_handle)
  guard world.entity_colliders.get(entity) is Some(collider_handle)
  guard collision_shape_to_rapier_shape(snapshot.shape)
    is Some((rapier_shape, translation))
  let active_hooks = if snapshot.collision.sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }

  if world.bodies.get_mut(body_handle) is Some(body) {
    body
    .set_body_type(rigid_body_type_to_rapier(snapshot.body.body_type), false)
    .set_enabled(snapshot.collision.active)
    .set_gravity_scale(Float::from_double(snapshot.body.gravity_scale), false)
    .set_linear_damping(Float::from_double(snapshot.body.linear_damping))
    .set_angular_damping(Float::from_double(snapshot.body.angular_damping))
    .enable_ccd(snapshot.body.ccd_enabled)
    .set_locked_rotations(snapshot.body.lock_rotation, false)
    |> ignore
    if snapshot.body.body_type is Fixed {
      body.set_linvel(@rapier_full.Vec2::new(0.0F, 0.0F), false) |> ignore
      body.set_angvel(0.0F, false) |> ignore
    } else if snapshot.linear_velocity is Some(linear_velocity) {
      body.set_linvel(to_physics_vec2(linear_velocity), false) |> ignore
    }
    if snapshot.body.body_type is KinematicPositionBased {
      body.set_angvel(0.0F, false) |> ignore
    } else if snapshot.angular_velocity is Some(angular_velocity) {
      body.set_angvel(Float::from_double(angular_velocity), false) |> ignore
    }
    match snapshot.body.body_type {
      Fixed =>
        body.set_position(
          to_physics_isometry(snapshot.position, snapshot.rotation),
          true,
        )
        |> ignore
      KinematicPositionBased => {
        body.set_translation(to_physics_vec2(snapshot.position), true) |> ignore
        body.set_rotation(to_physics_rotation(snapshot.rotation), true)
        |> ignore
        body.set_next_kinematic_translation(to_physics_vec2(snapshot.position))
        |> ignore
        body.set_next_kinematic_rotation(to_physics_rotation(snapshot.rotation))
        |> ignore
      }
      _ =>
        body.set_rotation(to_physics_rotation(snapshot.rotation), true)
        |> ignore
    }
  }

  if world.colliders.get_mut(collider_handle) is Some(collider) {
    collider
    .set_sensor(snapshot.collision.sensor)
    .set_enabled(snapshot.collision.active)
    .set_active_collision_types(@rapier_collision.ActiveCollisionTypes::all())
    .set_active_hooks(active_hooks)
    .set_collision_groups(to_rapier_groups(snapshot.collision.filter))
    .set_solver_groups(to_rapier_groups(snapshot.collision.filter))
    .set_active_events(active_events())
    .set_friction(Float::from_double(snapshot.collision.friction))
    .set_restitution(Float::from_double(snapshot.collision.restitution))
    .set_translation_wrt_parent(to_physics_vec2(translation))
    .set_shape(rapier_shape)
    |> ignore
  }
}

///|
fn entity_from_collider_handle(
  handle : @rapier_collision.ColliderHandle,
) -> @entity.Entity? {
  world.collider_entities.get(collider_handle_id(handle))
}

///|
fn estimate_direction(
  from : @entity.Entity,
  to : @entity.Entity,
) -> @math.Vec2D {
  if @position.positions.get(from) is Some(from_pos) &&
    @position.positions.get(to) is Some(to_pos) {
    let delta = to_pos.0 - from_pos.0
    if delta[X].abs() >= delta[Y].abs() {
      @math.Vec2D(if delta[X] >= 0.0 { 1.0 } else { -1.0 }, 0.0)
    } else {
      @math.Vec2D(0.0, if delta[Y] >= 0.0 { 1.0 } else { -1.0 })
    }
  } else {
    @math.Vec2D::zero()
  }
}

///|
fn move_without_collision(
  entity : @entity.Entity,
  displacement : @math.Vec2D,
  delta : Double,
) -> Unit {
  if @position.positions.get(entity) is Some(position) {
    let new_position = position.0 + displacement
    @position.positions.set(entity, new_position)
    if world.entity_bodies.get(entity) is Some(body_handle) {
      if world.bodies.get_mut(body_handle) is Some(body) {
        body.set_translation(to_physics_vec2(new_position), true) |> ignore
      }
    }
  }
  if delta.abs() <= EPSILON {
    resolved_velocities.set(entity, @math.Vec2D::zero())
  } else {
    resolved_velocities.set(entity, displacement.scalar_div(delta))
  }
  set_grounded(entity, false)
}

///|
fn move_with_kinematic_controller(
  entity : @entity.Entity,
  collider_handle : @rapier_collision.ColliderHandle,
  velocity : @math.Vec2D,
  delta : Double,
  query_base : @rapier_collision.QueryPipeline,
) -> Unit {
  guard @position.positions.get(entity) is Some(position) else { return }
  guard entity_collision_shape(entity) is Some(shape) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  guard colliders.get(entity) is Some(collider) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  let displacement = velocity.scalar_mul(delta)
  let query = query_base.with_filter(
    @rapier_collision.QueryFilter::new()
    .exclude_collider(collider_handle)
    .exclude_sensors()
    .groups(to_rapier_groups(collider.filter)),
  )
  let controller = @rapier_control.KinematicCharacterController::default().with_up(
    @rapier_full.Vec2::new(0.0F, -1.0F),
  )
  let effective = controller.move_shape(
    Float::from_double(delta),
    query,
    world.bodies,
    world.colliders,
    rapier_shape,
    @rapier_full.Isometry2::from_translation(
      to_physics_vec2(position.0 + translation),
    ),
    to_physics_vec2(displacement),
    fn(_collision) {  },
  )
  let mut applied_displacement = from_physics_vec2(effective.translation())
  if effective.is_grounded() && applied_displacement[Y].abs() < 0.05 {
    applied_displacement = applied_displacement.update(Y, 0.0)
  }
  let new_position = position.0 + applied_displacement
  @position.positions.set(entity, new_position)
  if world.entity_bodies.get(entity) is Some(body_handle) {
    if world.bodies.get_mut(body_handle) is Some(body) {
      body.set_next_kinematic_translation(to_physics_vec2(new_position))
      |> ignore
      body.set_linvel(
        to_physics_vec2(applied_displacement.scalar_div(delta)),
        false,
      )
      |> ignore
    }
  }
  resolved_velocities.set(entity, applied_displacement.scalar_div(delta))
  set_grounded(entity, effective.is_grounded())
}

///|
fn process_contact_events() -> Unit {
  for event in world.event_handler.take_collision_events() {
    guard entity_from_collider_handle(event.collider1()) is Some(entity1) else {
      continue
    }
    guard entity_from_collider_handle(event.collider2()) is Some(entity2) else {
      continue
    }
    guard colliders.get(entity1) is Some(collider1) else { continue }
    guard colliders.get(entity2) is Some(collider2) else { continue }
    guard collider1.active && collider2.active else { continue }
    let direction = estimate_direction(entity1, entity2)
    let started = event.started()
    push_contact_event({ entity: entity1, other: entity2, started, direction })
    push_contact_event({
      entity: entity2,
      other: entity1,
      started,
      direction: direction.scalar_mul(-1.0),
    })
  }
}

///|
fn update_area_contains(
  area_entity : @entity.Entity,
  other : @entity.Entity,
  intersecting : Bool,
) -> Unit {
  guard areas.get(area_entity) is Some(area) else { return }
  guard area.active else { return }
  if !other.is_alive() {
    return
  }
  guard colliders.get(other) is Some(other_collider) else { return }
  guard other_collider.active else { return }
  guard area.filter.matches_group(other_collider.filter.group) else { return }
  if intersecting {
    if !area.contains.contains(other) {
      area.contains.add(other)
      push_trigger_event({ area: area_entity, other, entered: true })
    }
  } else if area.contains.contains(other) {
    area.contains.remove(other)
    push_trigger_event({ area: area_entity, other, entered: false })
  }
}

///|
fn prune_area_contains() -> Unit {
  for _entity, area in areas {
    let stale : Array[@entity.Entity] = []
    for other in area.contains {
      if !area.active {
        stale.push(other)
        continue
      }
      if !other.is_alive() {
        stale.push(other)
        continue
      }
      if colliders.get(other) is None {
        stale.push(other)
      }
    }
    for other in stale {
      area.contains.remove(other)
    }
  }
}

///|
fn clear_area_contains(area_entity : @entity.Entity, area : Area) -> Unit {
  let exiting : Array[@entity.Entity] = []
  for other in area.contains {
    exiting.push(other)
  }
  area.contains.clear()
  for other in exiting {
    push_trigger_event({ area: area_entity, other, entered: false })
  }
}

///|
fn process_trigger_events() -> Unit {
  let query_base = @rapier_collision.QueryPipeline::new(
    @rapier_collision.QueryFilter::new(),
    world.bodies,
    world.colliders,
  )
  for area_entity, area in areas {
    guard area_entity.is_alive() else { continue }
    if !area.active {
      clear_area_contains(area_entity, area)
      continue
    }
    guard world.entity_colliders.get(area_entity) is Some(area_handle) else {
      clear_area_contains(area_entity, area)
      continue
    }
    guard world.colliders.get(area_handle) is Some(area_collider) else {
      clear_area_contains(area_entity, area)
      continue
    }
    let query = query_base.with_filter(
      @rapier_collision.QueryFilter::new()
      .exclude_collider(area_handle)
      .exclude_sensors()
      .groups(to_rapier_groups(area.filter)),
    )
    let overlaps = query.intersect_shape(
      world.bodies,
      world.colliders,
      area_collider.position(),
      area_collider.shape(),
    )
    let intersecting_entities : Set[@entity.Entity] = Set::new()
    for handle in overlaps {
      guard entity_from_collider_handle(handle) is Some(other) else { continue }
      intersecting_entities.add(other)
      update_area_contains(area_entity, other, true)
    }
    let exiting_entities : Array[@entity.Entity] = []
    for other in area.contains {
      if !intersecting_entities.contains(other) {
        exiting_entities.push(other)
      }
    }
    for other in exiting_entities {
      update_area_contains(area_entity, other, false)
    }
  }
  prune_area_contains()
}

///|
fn sync_body_outputs() -> Unit {
  for entity, handle in world.entity_bodies {
    guard @position.positions.get(entity) is Some(_) else { continue }
    if world.bodies.get(handle) is Some(body) {
      let body_type = body.body_type()
      if body_type is @rapier_dynamics.RigidBodyType::Dynamic ||
        body_type is @rapier_dynamics.RigidBodyType::KinematicVelocityBased {
        @position.positions.set(entity, from_physics_vec2(body.translation()))
        resolved_velocities.set(entity, from_physics_vec2(body.linvel()))
        set_grounded(entity, false)
      }
    }
  }
}

///|
fn step_rapier_pipeline(delta : Double) -> Unit {
  world.integration = world.integration
    .with_dt(Float::from_double(delta))
    .set_length_unit(Float::from_double(physics_config.pixels_per_meter))
    .set_max_ccd_substeps(physics_config.max_ccd_substeps)
  ignore(world.event_handler.take_collision_events())
  ignore(world.event_handler.take_intersection_events())
  world.pipeline.step(
    to_physics_vec2(physics_config.gravity),
    world.integration,
    world.islands,
    world.broad_phase,
    world.narrow_phase,
    world.bodies,
    world.colliders,
    world.impulse_joints,
    world.multibody_joints,
    world.ccd_solver,
    @rapier_pipeline.PhysicsHooks::new(),
    world.event_handler,
  )
}

///|
fn rapier_fixed_step(delta : Double) -> Unit {
  if delta <= 0.0 {
    grounded_entities.clear()
    resolved_velocities.clear()
    return
  }
  sync_world_entities()
  sync_world_joints()
  sync_world_multibody_joints()
  grounded_entities.clear()
  resolved_velocities.clear()

  let query_base = @rapier_collision.QueryPipeline::new(
    @rapier_collision.QueryFilter::new(),
    world.bodies,
    world.colliders,
  )
  for entity, velocity in @velocity.velocities {
    guard entity.is_alive() else { continue }
    let body_type = entity_rigid_body(entity).body_type
    guard body_type is KinematicPositionBased else { continue }
    let displacement = velocity.0.scalar_mul(delta)
    if world.entity_colliders.get(entity) is Some(collider_handle) {
      if colliders.get(entity) is Some(collider) && collider.active {
        move_with_kinematic_controller(
          entity,
          collider_handle,
          velocity.0,
          delta,
          query_base,
        )
      } else {
        move_without_collision(entity, displacement, delta)
      }
    } else {
      move_without_collision(entity, displacement, delta)
    }
  }

  step_rapier_pipeline(delta)
  sync_body_outputs()
  process_contact_events()
  process_trigger_events()
}
