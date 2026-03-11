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
pub(all) enum RigidBodyType3D {
  Dynamic
  Fixed
  KinematicPositionBased
  KinematicVelocityBased
} derive(Eq, Show)

///|
pub(all) struct RigidBody3D {
  body_type : RigidBodyType3D
  gravity_scale : Double
  linear_damping : Double
  angular_damping : Double
  ccd_enabled : Bool
  lock_rotations : Bool
  lock_translations : Bool
} derive(Eq, Show)

///|
pub(all) enum ColliderShape3D {
  Cuboid(@math.Vec3)
  Ball(Double)
  CapsuleY(Double, Double)
  Cylinder(Double, Double)
} derive(Eq, Show)

///|
pub(all) struct CollisionLayers3D {
  memberships : Int
  filters : Int
} derive(Eq, Show)

///|
pub(all) struct Collider3D {
  shape : ColliderShape3D
  friction : Double
  restitution : Double
  sensor : Bool
  layers : CollisionLayers3D
} derive(Eq, Show)

///|
pub type Sensor3D = Collider3D

///|
pub(all) struct LinearVelocity3D(@math.Vec3) derive(Eq, Show)

///|
pub(all) struct AngularVelocity3D(@math.Vec3) derive(Eq, Show)

///|
pub(all) struct ContactEvent3D {
  entity_a : @entity.Entity
  entity_b : @entity.Entity
  started : Bool
  stopped : Bool
  sensor : Bool
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct TriggerEvent3D {
  sensor : @entity.Entity
  other : @entity.Entity
  entered : Bool
} derive(Eq, Show)

///|
pub(all) struct RaycastHit3D {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct ShapeCastHit3D {
  entity : @entity.Entity
  toi : Double
  normal : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct Physics3DConfig {
  mut gravity : @math.Vec3
}

///|
pub fn RigidBody3D::dynamic() -> RigidBody3D {
  {
    body_type: Dynamic,
    gravity_scale: 1.0,
    linear_damping: 0.0,
    angular_damping: 0.0,
    ccd_enabled: false,
    lock_rotations: false,
    lock_translations: false,
  }
}

///|
pub fn RigidBody3D::fixed() -> RigidBody3D {
  { ..RigidBody3D::dynamic(), body_type: Fixed }
}

///|
pub fn RigidBody3D::kinematic_position_based() -> RigidBody3D {
  { ..RigidBody3D::dynamic(), body_type: KinematicPositionBased }
}

///|
pub fn RigidBody3D::kinematic_velocity_based() -> RigidBody3D {
  { ..RigidBody3D::dynamic(), body_type: KinematicVelocityBased }
}

///|
pub fn Collider3D::cuboid(half_extents : @math.Vec3) -> Collider3D {
  {
    shape: Cuboid(half_extents),
    friction: 0.5,
    restitution: 0.0,
    sensor: false,
    layers: { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF },
  }
}

///|
pub fn Collider3D::ball(radius : Double) -> Collider3D {
  {
    shape: Ball(radius),
    friction: 0.5,
    restitution: 0.0,
    sensor: false,
    layers: { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF },
  }
}

///|
pub fn new_collision_layers3d(
  memberships : Int,
  filters : Int,
) -> CollisionLayers3D {
  { memberships, filters }
}

///|
pub let config : Physics3DConfig = { gravity: @math.Vec3::new(0.0, -9.81, 0.0) }

///|
priv struct Physics3DComponentWorldStore {
  rigid_bodies3d : Map[@entity.Entity, RigidBody3D]
  colliders3d : Map[@entity.Entity, Collider3D]
  sensors3d : Map[@entity.Entity, Sensor3D]
  linear_velocities3d : Map[@entity.Entity, LinearVelocity3D]
  angular_velocities3d : Map[@entity.Entity, AngularVelocity3D]
}

///|
let physics3d_component_world_stores : Map[UInt, Physics3DComponentWorldStore] = Map::new()

///|
fn physics3d_component_world_store() -> Physics3DComponentWorldStore {
  let world_id = @ecs.require_current_world().id()
  physics3d_component_world_stores.get_or_init(world_id, () => {
    rigid_bodies3d: Map::new(),
    colliders3d: Map::new(),
    sensors3d: Map::new(),
    linear_velocities3d: Map::new(),
    angular_velocities3d: Map::new(),
  })
}

///|
pub fn rigid_bodies3d() -> Map[@entity.Entity, RigidBody3D] {
  physics3d_component_world_store().rigid_bodies3d
}

///|
pub fn colliders3d() -> Map[@entity.Entity, Collider3D] {
  physics3d_component_world_store().colliders3d
}

///|
pub fn sensors3d() -> Map[@entity.Entity, Sensor3D] {
  physics3d_component_world_store().sensors3d
}

///|
pub fn linear_velocities3d() -> Map[@entity.Entity, LinearVelocity3D] {
  physics3d_component_world_store().linear_velocities3d
}

///|
pub fn angular_velocities3d() -> Map[@entity.Entity, AngularVelocity3D] {
  physics3d_component_world_store().angular_velocities3d
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
  event_handler : @pipeline.EventHandler3D
}

///|
priv struct Physics3DWorldStore {
  world : Physics3DWorld
  body_handles : Map[@entity.Entity, @dynamics.RigidBodyHandle]
  collider_handles : Map[@entity.Entity, @collision.ColliderHandle3D]
  collider_entities_by_key : Map[String, @entity.Entity]
}

///|
let physics3d_world_stores : Map[UInt, Physics3DWorldStore] = Map::new()

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
      event_handler: @pipeline.EventHandler3D::new(),
    },
    body_handles: Map::new(),
    collider_handles: Map::new(),
    collider_entities_by_key: Map::new(),
  })
}

///|
fn physics3d_world() -> Physics3DWorld {
  physics3d_world_store().world
}

///|
fn body_handles() -> Map[@entity.Entity, @dynamics.RigidBodyHandle] {
  physics3d_world_store().body_handles
}

///|
fn collider_handles() -> Map[@entity.Entity, @collision.ColliderHandle3D] {
  physics3d_world_store().collider_handles
}

///|
fn collider_entities_by_key() -> Map[String, @entity.Entity] {
  physics3d_world_store().collider_entities_by_key
}

///|
pub let contact_event_bus3d : @event.Events[ContactEvent3D] = @event.Events::new()

///|
pub let trigger_event_bus3d : @event.Events[TriggerEvent3D] = @event.Events::new()

///|
fn init {
  contact_event_bus3d.register()
  trigger_event_bus3d.register()
}

///|
pub fn set_gravity(gravity : @math.Vec3) -> Unit {
  config.gravity = gravity
}

///|
pub fn rigid_body_handle(entity : @entity.Entity) -> @dynamics.RigidBodyHandle? {
  body_handles().get(entity)
}

///|
pub fn collider_handle(entity : @entity.Entity) -> @collision.ColliderHandle3D? {
  collider_handles().get(entity)
}

///|
pub fn physics_step_system(delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  cleanup_world_components()
  ensure_bodies_and_colliders()
  sync_components_to_rapier()

  let world = physics3d_world()
  world.integration = world.integration.with_dt(Float::from_double(delta))
  world.pipeline.step_with_events(
    config.gravity.to_rapier(),
    world.integration,
    world.islands,
    world.broad_phase,
    world.narrow_phase,
    world.bodies,
    world.colliders,
    world.event_handler,
  )

  collect_events()
  sync_rapier_to_components()
}

///|
pub fn raycast3d(
  origin : @math.Vec3,
  direction : @math.Vec3,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
) -> RaycastHit3D? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline()
  let ray = @collision.Ray3::new(
    origin.to_rapier(),
    direction.normalize().to_rapier(),
  )
  match
    query.cast_ray_and_get_normal(
      world.bodies,
      world.colliders,
      ray,
      Float::from_double(max_toi),
      solid,
    ) {
    Some((handle, hit)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          toi: hit.toi().to_double(),
          normal: @math.vec3_from_rapier(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn shape_cast3d(
  shape : ColliderShape3D,
  origin : @math.Vec3,
  rotation? : @math.Quat = @math.Quat::identity(),
  direction? : @math.Vec3 = @math.Vec3::new(0.0, -1.0, 0.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
) -> ShapeCastHit3D? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline()
  let options = @collision.ShapeCastOptions3::new(
    Float::from_double(max_toi),
    stop_at_penetration,
  )
  match
    query.cast_shape(
      world.bodies,
      world.colliders,
      @core.Isometry3::new(origin.to_rapier(), rotation.to_rapier()),
      direction.normalize().to_rapier(),
      to_query_shape(shape),
      options,
    ) {
    Some((handle, hit)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          toi: hit.toi().to_double(),
          normal: @math.vec3_from_rapier(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn character_controller3d_move(
  entity : @entity.Entity,
  desired_delta : @math.Vec3,
) -> @math.Vec3 {
  guard rigid_bodies3d().get(entity) is Some(body_desc) else {
    let transform = @transform3d.transforms3d().get(entity).unwrap_or_default()
    @transform3d.transforms3d().set(entity, {
      ..transform,
      translation: transform.translation + desired_delta,
    })
    return desired_delta
  }
  guard body_handles().get(entity) is Some(handle) else { return desired_delta }
  let world = physics3d_world()
  guard world.bodies.get_mut(handle) is Some(body) else { return desired_delta }
  match body_desc.body_type {
    KinematicPositionBased => {
      let transform = @transform3d.transforms3d()
        .get(entity)
        .unwrap_or_default()
      let target = transform.translation + desired_delta
      body.set_next_kinematic_translation(target.to_rapier())
      @transform3d.transforms3d().set(entity, {
        ..transform,
        translation: target,
      })
      desired_delta
    }
    Dynamic | KinematicVelocityBased => {
      body.set_linvel(desired_delta.to_rapier())
      linear_velocities3d().set(entity, LinearVelocity3D(desired_delta))
      desired_delta
    }
    Fixed => @math.Vec3::zero()
  }
}

///|
fn ensure_bodies_and_colliders() -> Unit {
  for entity, _body_desc in rigid_bodies3d() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_rigid_body(entity))
  }

  for entity, collider in colliders3d() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_collider(entity, collider))
  }

  for entity, sensor in sensors3d() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_collider(entity, { ..sensor, sensor: true }))
  }
}

///|
fn sync_components_to_rapier() -> Unit {
  let world = physics3d_world()
  for entity, body_desc in rigid_bodies3d() {
    if !entity.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(handle) else { continue }
    guard world.bodies.get_mut(handle) is Some(body) else { continue }

    if linear_velocities3d().get(entity) is Some(linear_velocity) {
      body.set_linvel(linear_velocity.0.to_rapier())
    }
    if angular_velocities3d().get(entity) is Some(angular_velocity) {
      body.set_angvel(angular_velocity.0.to_rapier())
    }

    match body_desc.body_type {
      KinematicPositionBased =>
        if @transform3d.transforms3d().get(entity) is Some(transform) {
          body.set_next_kinematic_translation(transform.translation.to_rapier())
          body.set_next_kinematic_rotation(transform.rotation.to_rapier())
        }
      Fixed =>
        if @transform3d.transforms3d().get(entity) is Some(transform) {
          body.set_translation(transform.translation.to_rapier())
          body.set_rotation(transform.rotation.to_rapier())
        }
      _ => ()
    }
  }
}

///|
fn sync_rapier_to_components() -> Unit {
  let world = physics3d_world()
  for entity, handle in body_handles() {
    if !entity.is_alive() {
      continue
    }
    guard world.bodies.get(handle) is Some(body) else { continue }
    let transform = @transform3d.transforms3d().get(entity).unwrap_or_default()
    @transform3d.transforms3d().set(entity, {
      ..transform,
      translation: @math.vec3_from_rapier(body.translation()),
      rotation: @math.quat_from_rapier(body.rotation()),
    })
    linear_velocities3d().set(
      entity,
      LinearVelocity3D(@math.vec3_from_rapier(body.linvel())),
    )
    angular_velocities3d().set(
      entity,
      AngularVelocity3D(@math.vec3_from_rapier(body.angvel())),
    )
  }
}

///|
fn ensure_rigid_body(entity : @entity.Entity) -> @dynamics.RigidBodyHandle {
  let world = physics3d_world()
  let body_handles = body_handles()
  if body_handles.get(entity) is Some(handle) {
    if world.bodies.get(handle) is Some(_) {
      return handle
    }
    body_handles.remove(entity)
  }

  let body_desc = rigid_bodies3d().get(entity).unwrap_or(RigidBody3D::dynamic())
  let transform = @transform3d.transforms3d().get(entity).unwrap_or_default()
  let mut builder = match body_desc.body_type {
    Dynamic => @dynamics.RigidBodyBuilder3D::dynamic()
    Fixed => @dynamics.RigidBodyBuilder3D::fixed()
    KinematicPositionBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_position_based()
    KinematicVelocityBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_velocity_based()
  }
  builder = builder
    .translation(transform.translation.to_rapier())
    .rotation(transform.rotation.to_rapier())
    .gravity_scale(Float::from_double(body_desc.gravity_scale))
    .linear_damping(Float::from_double(body_desc.linear_damping))
    .angular_damping(Float::from_double(body_desc.angular_damping))
    .ccd_enabled(body_desc.ccd_enabled)
  if linear_velocities3d().get(entity) is Some(linear_velocity) {
    builder = builder.linvel(linear_velocity.0.to_rapier())
  }
  if angular_velocities3d().get(entity) is Some(angular_velocity) {
    builder = builder.angvel(angular_velocity.0.to_rapier())
  }
  if body_desc.lock_rotations {
    builder = builder.lock_rotations()
  }
  if body_desc.lock_translations {
    builder = builder.lock_translations()
  }
  let handle = world.bodies.insert(builder.build())
  body_handles.set(entity, handle)
  handle
}

///|
fn ensure_collider(
  entity : @entity.Entity,
  collider_desc : Collider3D,
) -> @collision.ColliderHandle3D {
  let world = physics3d_world()
  let body_handles = body_handles()
  let collider_handles = collider_handles()
  let collider_entities_by_key = collider_entities_by_key()
  if collider_handles.get(entity) is Some(handle) {
    if world.colliders.get(handle) is Some(_) {
      return handle
    }
    collider_handles.remove(entity)
    collider_entities_by_key.remove(collider_key(handle))
  }

  let mut builder = collider_builder_from_desc(collider_desc)
  if @transform3d.transforms3d().get(entity) is Some(transform) {
    builder = builder
      .translation(transform.translation.to_rapier())
      .rotation(transform.rotation.to_rapier())
  }
  let collider = builder.build()

  let handle = if body_handles.get(entity) is Some(parent_handle) &&
    world.bodies.get(parent_handle) is Some(_) {
    world.colliders.insert_with_parent(collider, parent_handle, world.bodies)
  } else {
    world.colliders.insert(collider)
  }

  collider_handles.set(entity, handle)
  collider_entities_by_key.set(collider_key(handle), entity)
  handle
}

///|
fn collider_builder_from_desc(
  collider_desc : Collider3D,
) -> @collision.ColliderBuilder3D {
  let mut builder = match collider_desc.shape {
    Cuboid(half_extents) =>
      @collision.ColliderBuilder3D::cuboid(
        Float::from_double(half_extents.x),
        Float::from_double(half_extents.y),
        Float::from_double(half_extents.z),
      )
    Ball(radius) =>
      @collision.ColliderBuilder3D::ball(Float::from_double(radius))
    CapsuleY(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.ColliderBuilder3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
  }

  let groups = @dynamics.InteractionGroups::new(
    @dynamics.Group::new(collider_desc.layers.memberships),
    @dynamics.Group::new(collider_desc.layers.filters),
    And,
  )
  let active_events = @collision.ActiveEvents::collision_events().union(
    @collision.ActiveEvents::intersection_events(),
  )

  builder = builder
    .collision_groups(groups)
    .friction(Float::from_double(collider_desc.friction))
    .restitution(Float::from_double(collider_desc.restitution))
    .sensor(collider_desc.sensor)
    .active_events(active_events)
  builder
}

///|
fn cleanup_world_components() -> Unit {
  let world = physics3d_world()
  let collider_handles = collider_handles()
  let body_handles = body_handles()
  let collider_entities_by_key = collider_entities_by_key()
  for pair in collider_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    let missing_component = !colliders3d().contains(entity) &&
      !sensors3d().contains(entity)
    if !entity.is_alive() || missing_component {
      world.colliders.remove(handle) |> ignore
      collider_handles.remove(entity)
      collider_entities_by_key.remove(collider_key(handle))
    }
  }

  for pair in body_handles.to_array() {
    let entity = pair.0
    let handle = pair.1
    if !entity.is_alive() || !rigid_bodies3d().contains(entity) {
      world.bodies.remove(handle) |> ignore
      body_handles.remove(entity)
    }
  }
}

///|
fn collect_events() -> Unit {
  let world = physics3d_world()
  for collision_event in world.event_handler.take_collision_events() {
    let collider1 = collision_event.collider1()
    let collider2 = collision_event.collider2()
    guard resolve_collider_entity(collider1) is Some(entity_a) else { continue }
    guard resolve_collider_entity(collider2) is Some(entity_b) else { continue }
    if collision_event.sensor() {
      trigger_event_bus3d.send({
        sensor: entity_a,
        other: entity_b,
        entered: collision_event.started(),
      })
    }
    contact_event_bus3d.send({
      entity_a,
      entity_b,
      started: collision_event.started(),
      stopped: collision_event.stopped(),
      sensor: collision_event.sensor(),
      normal: @math.Vec3::zero(),
    })
  }

  for intersection_event in world.event_handler.take_intersection_events() {
    guard resolve_collider_entity(intersection_event.collider1())
      is Some(sensor_entity) else {
      continue
    }
    guard resolve_collider_entity(intersection_event.collider2())
      is Some(other_entity) else {
      continue
    }
    trigger_event_bus3d.send({
      sensor: sensor_entity,
      other: other_entity,
      entered: intersection_event.intersecting(),
    })
  }
}

///|
fn make_query_pipeline() -> @collision.QueryPipeline3DReal {
  let world = physics3d_world()
  @collision.QueryPipeline3DReal::new(
    @collision.QueryFilter3DReal::new(),
    world.bodies,
    world.colliders,
  )
}

///|
fn to_query_shape(shape : ColliderShape3D) -> @collision.Shape3D {
  match shape {
    Cuboid(half_extents) =>
      @collision.Shape3D::cuboid(
        Float::from_double(half_extents.x),
        Float::from_double(half_extents.y),
        Float::from_double(half_extents.z),
      )
    Ball(radius) => @collision.Shape3D::ball(Float::from_double(radius))
    CapsuleY(half_height, radius) =>
      @collision.Shape3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.Shape3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
  }
}

///|
fn resolve_collider_entity(
  handle : @collision.ColliderHandle3D,
) -> @entity.Entity? {
  collider_entities_by_key().get(collider_key(handle))
}

///|
fn collider_key(handle : @collision.ColliderHandle3D) -> String {
  let (id, generation) = handle.into_raw_parts()
  "\{id}:\{generation}"
}
