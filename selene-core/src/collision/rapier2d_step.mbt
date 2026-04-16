///|
fn remove_entity_physics(entity : @entity.Entity) -> Unit {
  remove_joint_physics(entity)
  remove_multibody_joint_physics(entity)
  if world().entity_colliders.get(entity) is Some(collider_handle) {
    world().colliders.remove(
      collider_handle,
      world().islands,
      world().bodies,
      true,
    )
    world().collider_entities.remove(collider_handle_id(collider_handle))
    world().entity_colliders.remove(entity)
  }
  if world().entity_bodies.get(entity) is Some(body_handle) {
    world().bodies.remove(
      body_handle,
      world().islands,
      (),
      world().impulse_joints,
      world().multibody_joints,
      true,
    )
    |> ignore
    world().entity_bodies.remove(entity)
  }
  entity_physics_config_keys().remove(entity)
  entity_multibody_joint_config_keys().remove(entity)
  pending_body_rotations().remove(entity)
  pending_body_linear_velocities().remove(entity)
  pending_body_angular_velocities().remove(entity)
  consume_pending_body_actions(entity)
}

///|
fn consume_pending_body_controls(entity : @entity.Entity) -> Unit {
  pending_body_rotations().remove(entity)
  pending_body_linear_velocities().remove(entity)
  pending_body_angular_velocities().remove(entity)
}

///|
fn sync_world_entities() -> Unit {
  prune_pending_body_state()
  for _idx, entry in world().entity_bodies.to_array() {
    let entity = entry.0
    if !should_have_physics(entity) {
      remove_entity_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard should_have_physics(entity) else { continue }
    guard entity_physics_snapshot(entity) is Some(snapshot)
    let config_key = entity_physics_config_key(entity, snapshot)
    let missing_physics = world().entity_bodies.get(entity) is None ||
      world().entity_colliders.get(entity) is None
    let has_pending_actions = has_pending_body_actions(entity)
    if missing_physics {
      insert_entity_physics(entity, snapshot)
    }
    if missing_physics ||
      entity_physics_config_keys().get(entity) != Some(config_key) {
      sync_entity_physics(entity, snapshot)
      consume_pending_body_controls(entity)
    }
    if has_pending_actions {
      apply_pending_body_actions(entity)
    }
    if missing_physics ||
      entity_physics_config_keys().get(entity) != Some(config_key) ||
      has_pending_actions {
      if entity_physics_snapshot(entity) is Some(next_snapshot) {
        entity_physics_config_keys().set(
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
  let body_handle = world().bodies.insert(body_builder.build())
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
  let collider_handle = world().colliders.insert_with_parent(
    collider,
    body_handle,
    world().bodies,
  )
  world().entity_bodies.set(entity, body_handle)
  world().entity_colliders.set(entity, collider_handle)
  world().collider_entities.set(collider_handle_id(collider_handle), entity)
}

///|
fn sync_entity_physics(
  entity : @entity.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> Unit {
  guard world().entity_bodies.get(entity) is Some(body_handle)
  guard world().entity_colliders.get(entity) is Some(collider_handle)
  guard collision_shape_to_rapier_shape(snapshot.shape)
    is Some((rapier_shape, translation))
  let active_hooks = if snapshot.collision.sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }

  if world().bodies.get_mut(body_handle) is Some(body) {
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

  if world().colliders.get_mut(collider_handle) is Some(collider) {
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
  world().collider_entities.get(collider_handle_id(handle))
}

///|
fn estimate_direction(from : @entity.Entity, to : @entity.Entity) -> @math.Vec2 {
  if entity_translation(from) is Some(from_pos) &&
    entity_translation(to) is Some(to_pos) {
    let delta = to_pos - from_pos
    if delta[X].abs() >= delta[Y].abs() {
      @math.Vec2(if delta[X] >= 0.0 { 1.0 } else { -1.0 }, 0.0)
    } else {
      @math.Vec2(0.0, if delta[Y] >= 0.0 { 1.0 } else { -1.0 })
    }
  } else {
    @math.Vec2::zero()
  }
}

///|
fn move_without_collision(
  entity : @entity.Entity,
  displacement : @math.Vec2,
  delta : Double,
) -> Unit {
  if entity_translation(entity) is Some(position) {
    let new_position = position + displacement
    set_entity_translation(entity, new_position)
    if world().entity_bodies.get(entity) is Some(body_handle) {
      if world().bodies.get_mut(body_handle) is Some(body) {
        body.set_translation(to_physics_vec2(new_position), true) |> ignore
      }
    }
  }
  if delta.abs() <= EPSILON {
    resolved_velocities().set(entity, @math.Vec2::zero())
  } else {
    resolved_velocities().set(entity, displacement.scalar_div(delta))
  }
  set_grounded(entity, false)
}

///|
fn move_with_kinematic_controller(
  entity : @entity.Entity,
  collider_handle : @rapier_collision.ColliderHandle,
  velocity : @math.Vec2,
  delta : Double,
  query_base : @rapier_collision.QueryPipeline,
) -> Unit {
  guard entity_translation(entity) is Some(position) else { return }
  guard entity_collision_shape(entity) is Some(shape) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    move_without_collision(entity, velocity.scalar_mul(delta), delta)
    return
  }
  guard colliders().get(entity) is Some(collider) else {
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
    world().bodies,
    world().colliders,
    rapier_shape,
    @rapier_full.Isometry2::from_translation(
      to_physics_vec2(position + translation),
    ),
    to_physics_vec2(displacement),
    fn(_collision) {  },
  )
  let mut applied_displacement = from_physics_vec2(effective.translation())
  if effective.is_grounded() && applied_displacement[Y].abs() < 0.05 {
    applied_displacement = applied_displacement.update(Y, 0.0)
  }
  let new_position = position + applied_displacement
  set_entity_translation(entity, new_position)
  if world().entity_bodies.get(entity) is Some(body_handle) {
    if world().bodies.get_mut(body_handle) is Some(body) {
      body.set_next_kinematic_translation(to_physics_vec2(new_position))
      |> ignore
      body.set_linvel(
        to_physics_vec2(applied_displacement.scalar_div(delta)),
        false,
      )
      |> ignore
    }
  }
  resolved_velocities().set(entity, applied_displacement.scalar_div(delta))
  set_grounded(entity, effective.is_grounded())
}

///|
fn process_contact_events() -> Unit {
  for event in world().event_handler.take_collision_events() {
    guard entity_from_collider_handle(event.collider1()) is Some(entity1) else {
      continue
    }
    guard entity_from_collider_handle(event.collider2()) is Some(entity2) else {
      continue
    }
    guard colliders().get(entity1) is Some(collider1) else { continue }
    guard colliders().get(entity2) is Some(collider2) else { continue }
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
  guard areas().get(area_entity) is Some(area) else { return }
  guard area.active else { return }
  if !other.is_alive() {
    return
  }
  guard colliders().get(other) is Some(other_collider) else { return }
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
  for _entity, area in areas() {
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
      if colliders().get(other) is None {
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
    world().bodies,
    world().colliders,
  )
  for area_entity, area in areas() {
    guard area_entity.is_alive() else { continue }
    if !area.active {
      clear_area_contains(area_entity, area)
      continue
    }
    guard world().entity_colliders.get(area_entity) is Some(area_handle) else {
      clear_area_contains(area_entity, area)
      continue
    }
    guard world().colliders.get(area_handle) is Some(area_collider) else {
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
      world().bodies,
      world().colliders,
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
  for entity, handle in world().entity_bodies {
    guard entity_translation(entity) is Some(_) else { continue }
    if world().bodies.get(handle) is Some(body) {
      let body_type = body.body_type()
      if body_type is @rapier_dynamics.RigidBodyType::Dynamic ||
        body_type is @rapier_dynamics.RigidBodyType::KinematicVelocityBased {
        set_entity_translation(entity, from_physics_vec2(body.translation()))
        set_entity_rotation(entity, from_physics_rotation(body.rotation()))
        resolved_velocities().set(entity, from_physics_vec2(body.linvel()))
        set_grounded(entity, false)
      }
    }
  }
}

///|
fn step_rapier_pipeline(delta : Double) -> Unit {
  world().integration = world().integration
    .with_dt(Float::from_double(delta))
    .set_length_unit(Float::from_double(physics_config.pixels_per_meter))
    .set_max_ccd_substeps(physics_config.max_ccd_substeps)
  ignore(world().event_handler.take_collision_events())
  ignore(world().event_handler.take_intersection_events())
  world().pipeline.step(
    to_physics_vec2(physics_config.gravity),
    world().integration,
    world().islands,
    world().broad_phase,
    world().narrow_phase,
    world().bodies,
    world().colliders,
    world().impulse_joints,
    world().multibody_joints,
    world().ccd_solver,
    @rapier_pipeline.PhysicsHooks::new(),
    world().event_handler,
  )
}

///|
fn rapier_fixed_step(delta : Double) -> Unit {
  if delta <= 0.0 {
    grounded_entities().clear()
    resolved_velocities().clear()
    return
  }
  sync_world_entities()
  sync_world_joints()
  sync_world_multibody_joints()
  grounded_entities().clear()
  resolved_velocities().clear()

  let query_base = @rapier_collision.QueryPipeline::new(
    @rapier_collision.QueryFilter::new(),
    world().bodies,
    world().colliders,
  )
  for entity, velocity in @velocity.velocities() {
    guard entity.is_alive() else { continue }
    let body_type = entity_rigid_body(entity).body_type
    guard body_type is KinematicPositionBased else { continue }
    let displacement = velocity.0.scalar_mul(delta)
    if world().entity_colliders.get(entity) is Some(collider_handle) {
      if colliders().get(entity) is Some(collider) && collider.active {
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
