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
fn from_physics_vec2(value : @rapier_full.Vec2) -> @math.Vec2D {
  @math.Vec2D(
    from_physics_scalar(value.x.to_double()),
    from_physics_scalar(value.y.to_double()),
  )
}

///|
fn collider_handle_id(handle : @rapier_collision.ColliderHandle) -> Int {
  let (id, _generation) = handle.into_raw_parts()
  id
}

///|
fn world_entity(entity : @entity.Entity) -> Bool {
  @ui.uis.get(entity) is None
}

///|
fn entity_rect_shape(entity : @entity.Entity) -> (@math.Vec2D, @math.Vec2D)? {
  guard shapes.get(entity) is Some(shape) else { return None }
  match shape {
    Rect(size~, offset~) => Some((size, offset))
  }
}

///|
fn entity_collision_config(
  entity : @entity.Entity,
) -> (CollisionFilter, Bool, Bool)? {
  if areas.get(entity) is Some(area) {
    Some((area.filter, true, true))
  } else if colliders.get(entity) is Some(collider) {
    Some((collider.filter, false, collider.active))
  } else {
    None
  }
}

///|
fn should_have_physics(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  @position.positions.get(entity) is Some(_) &&
  entity_rect_shape(entity) is Some(_) &&
  entity_collision_config(entity) is Some(_)
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
    groups_from_mask(filter.mask),
    @rapier_dynamics.InteractionTestMode::And,
  )
}

///|
fn active_events() -> @rapier_collision.ActiveEvents {
  @rapier_collision.ActiveEvents::collision_events().union(
    @rapier_collision.ActiveEvents::intersection_events(),
  )
}

///|
fn remove_entity_physics(entity : @entity.Entity) -> Unit {
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
}

///|
fn sync_world_entities() -> Unit {
  for _idx, entry in world.entity_bodies.to_array() {
    let entity = entry.0
    if !should_have_physics(entity) {
      remove_entity_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard should_have_physics(entity) else { continue }
    let missing_physics = world.entity_bodies.get(entity) is None ||
      world.entity_colliders.get(entity) is None
    if missing_physics {
      insert_entity_physics(entity)
    }
    // Static colliders dominate map geometry. Re-syncing them every fixed step
    // (shape/groups/translation) is extremely expensive and unnecessary.
    if missing_physics || @velocity.velocities.contains(entity) {
      sync_entity_physics(entity)
    }
  }
}

///|
fn insert_entity_physics(entity : @entity.Entity) -> Unit {
  guard @position.positions.get(entity) is Some(position)
  guard entity_rect_shape(entity) is Some((size, offset))
  guard entity_collision_config(entity) is Some((filter, sensor, active))
  let active_hooks = if sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }
  let body_builder = if @velocity.velocities.contains(entity) {
    @rapier_full.RigidBodyBuilder::kinematic_position_based()
  } else {
    @rapier_full.RigidBodyBuilder::fixed()
  }
  let body_handle = world.bodies.insert(
    body_builder.translation(to_physics_vec2(position.0)).build(),
  )
  let local_center = offset + size.scalar_mul(0.5)
  let collider = @rapier_full.ColliderBuilder::cuboid(
      Float::from_double(to_physics_scalar(size[X] * 0.5)),
      Float::from_double(to_physics_scalar(size[Y] * 0.5)),
    )
    .translation(to_physics_vec2(local_center))
    .active_collision_types(@rapier_collision.ActiveCollisionTypes::all())
    .sensor(sensor)
    .active_hooks(active_hooks)
    .collision_groups(to_rapier_groups(filter))
    .solver_groups(to_rapier_groups(filter))
    .active_events(active_events())
    .enabled(active)
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
fn sync_entity_physics(entity : @entity.Entity) -> Unit {
  guard world.entity_bodies.get(entity) is Some(body_handle)
  guard world.entity_colliders.get(entity) is Some(collider_handle)
  guard @position.positions.get(entity) is Some(position)
  guard entity_rect_shape(entity) is Some((size, offset))
  guard entity_collision_config(entity) is Some((filter, sensor, active))
  let active_hooks = if sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }

  if world.bodies.get_mut(body_handle) is Some(body) {
    let body_type = if @velocity.velocities.contains(entity) {
      @rapier_dynamics.RigidBodyType::KinematicPositionBased
    } else {
      @rapier_dynamics.RigidBodyType::Fixed
    }
    body
    .set_body_type(body_type, false)
    .set_enabled(active)
    .set_translation(to_physics_vec2(position.0), true)
    |> ignore
  }

  if world.colliders.get_mut(collider_handle) is Some(collider) {
    let local_center = offset + size.scalar_mul(0.5)
    collider
    .set_sensor(sensor)
    .set_enabled(active)
    .set_active_collision_types(@rapier_collision.ActiveCollisionTypes::all())
    .set_active_hooks(active_hooks)
    .set_collision_groups(to_rapier_groups(filter))
    .set_solver_groups(to_rapier_groups(filter))
    .set_active_events(active_events())
    .set_translation_wrt_parent(to_physics_vec2(local_center))
    .set_shape(
      @rapier_collision.Shape::Cuboid(
        Float::from_double(to_physics_scalar(size[X] * 0.5)),
        Float::from_double(to_physics_scalar(size[Y] * 0.5)),
      ),
    )
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
  guard entity_rect_shape(entity) is Some((size, offset)) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  guard colliders.get(entity) is Some(collider) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  let displacement = velocity.scalar_mul(delta)

  let center = position.0 + offset + size.scalar_mul(0.5)
  let shape = @rapier_collision.Shape::Cuboid(
    Float::from_double(to_physics_scalar(size[X] * 0.5)),
    Float::from_double(to_physics_scalar(size[Y] * 0.5)),
  )
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
    shape,
    @rapier_full.Isometry2::from_translation(to_physics_vec2(center)),
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
fn process_trigger_events() -> Unit {
  let query_base = @rapier_collision.QueryPipeline::new(
    @rapier_collision.QueryFilter::new(),
    world.bodies,
    world.colliders,
  )
  for area_entity, area in areas {
    guard area_entity.is_alive() else { continue }
    guard world.entity_colliders.get(area_entity) is Some(area_handle) else {
      continue
    }
    guard world.colliders.get(area_handle) is Some(area_collider) else {
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
fn sync_positions_from_bodies() -> Unit {
  for entity, handle in world.entity_bodies {
    if !@velocity.velocities.contains(entity) {
      continue
    }
    guard @position.positions.get(entity) is Some(_) else { continue }
    if world.bodies.get(handle) is Some(body) {
      // KinematicPositionBased bodies are driven by ECS positions in
      // move_with_kinematic_controller; syncing body->ECS reintroduces tiny
      // floating-point noise and causes visible jitter.
      if body.body_type()
        is @rapier_dynamics.RigidBodyType::KinematicPositionBased {
        continue
      }
      @position.positions.set(entity, from_physics_vec2(body.translation()))
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
  grounded_entities.clear()
  resolved_velocities.clear()

  let query_base = @rapier_collision.QueryPipeline::new(
    @rapier_collision.QueryFilter::new(),
    world.bodies,
    world.colliders,
  )
  for entity, velocity in @velocity.velocities {
    guard entity.is_alive() else { continue }
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
  sync_positions_from_bodies()
  process_contact_events()
  process_trigger_events()
}
