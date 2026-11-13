///|
fn remove_entity_physics(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> Unit {
  remove_joint_physics(physics~, entity)
  remove_multibody_joint_physics(physics~, entity)
  if physics.runtime.world.entity_colliders.get(entity) is Some(collider_handle) {
    physics.runtime.world.colliders.remove(
      collider_handle,
      physics.runtime.world.islands,
      physics.runtime.world.bodies,
      true,
    )
    physics.runtime.world.collider_entities.remove(
      collider_handle_key(collider_handle),
    )
    physics.runtime.world.entity_colliders.remove(entity)
  }
  if physics.runtime.world.entity_bodies.get(entity) is Some(body_handle) {
    physics.runtime.world.bodies.remove(
      body_handle,
      physics.runtime.world.islands,
      (),
      physics.runtime.world.impulse_joints,
      physics.runtime.world.multibody_joints,
      true,
    )
    |> ignore
    physics.runtime.world.entity_bodies.remove(entity)
  }
  physics.runtime.entity_physics_config_keys.remove(entity)
  physics.runtime.entity_multibody_joint_config_keys.remove(entity)
  physics.runtime.pending_body_rotations.remove(entity)
  physics.runtime.pending_body_linear_velocities.remove(entity)
  physics.runtime.pending_body_angular_velocities.remove(entity)
  consume_pending_body_actions(physics~, entity)
}

///|
fn consume_pending_body_controls(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
) -> Unit {
  physics.runtime.pending_body_rotations.remove(entity)
  physics.runtime.pending_body_linear_velocities.remove(entity)
  physics.runtime.pending_body_angular_velocities.remove(entity)
}

///|
fn sync_world_entities(physics~ : PhysicsStep2D) -> Unit {
  prune_pending_body_state(physics~)
  let stale = physics.runtime.world.entity_bodies
    .keys()
    .filter(entity => !should_have_physics(physics~, entity))
    .collect()
  for entity in stale {
    remove_entity_physics(physics~, entity)
  }

  for entity in physics.entities.iter() {
    guard should_have_physics(physics~, entity) else { continue }
    guard! entity_physics_snapshot(physics~, entity) is Some(snapshot)
    let config_key = entity_physics_config_key(physics~, entity, snapshot)
    let missing_physics = physics.runtime.world.entity_bodies.get(entity)
      is None ||
      physics.runtime.world.entity_colliders.get(entity) is None
    let has_pending_actions = has_pending_body_actions(physics~, entity)
    if missing_physics {
      insert_entity_physics(physics~, entity, snapshot)
    }
    if missing_physics ||
      physics.runtime.entity_physics_config_keys.get(entity) != Some(config_key) {
      sync_entity_physics(physics~, entity, snapshot)
      consume_pending_body_controls(physics~, entity)
    }
    if has_pending_actions {
      apply_pending_body_actions(physics~, entity)
    }
    if missing_physics ||
      physics.runtime.entity_physics_config_keys.get(entity) != Some(config_key) ||
      has_pending_actions {
      if entity_physics_snapshot(physics~, entity) is Some(next_snapshot) {
        physics.runtime.entity_physics_config_keys.set(
          entity,
          entity_physics_config_key(physics~, entity, next_snapshot),
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
    Dynamic => Dynamic
    Fixed => Fixed
    KinematicPositionBased => KinematicPositionBased
    KinematicVelocityBased => KinematicVelocityBased
  }
}

///|
fn insert_entity_physics(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> Unit {
  guard! collision_shape_to_rapier_shape(snapshot.shape)
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
  let body_handle = physics.runtime.world.bodies.insert(body_builder.build())
  let collider = @rapier_full.ColliderBuilder::ColliderBuilder(rapier_shape)
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
  let collider_handle = physics.runtime.world.colliders.insert_with_parent(
    collider,
    body_handle,
    physics.runtime.world.bodies,
  )
  physics.runtime.world.entity_bodies.set(entity, body_handle)
  physics.runtime.world.entity_colliders.set(entity, collider_handle)
  physics.runtime.world.collider_entities.set(
    collider_handle_key(collider_handle),
    entity,
  )
}

///|
fn sync_entity_physics(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  snapshot : EntityPhysicsSnapshot,
) -> Unit {
  guard! physics.runtime.world.entity_bodies.get(entity) is Some(body_handle)
  guard! physics.runtime.world.entity_colliders.get(entity)
    is Some(collider_handle)
  guard! collision_shape_to_rapier_shape(snapshot.shape)
    is Some((rapier_shape, translation))
  let active_hooks = if snapshot.collision.sensor {
    @rapier_collision.ActiveHooks::empty()
  } else {
    @rapier_collision.ActiveHooks::filter_contact_pairs()
  }

  if physics.runtime.world.bodies.get_mut(body_handle) is Some(body) {
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
      body.set_linvel(Vec2(0.0F, 0.0F), false) |> ignore
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

  if physics.runtime.world.colliders.get_mut(collider_handle) is Some(collider) {
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
  physics~ : PhysicsStep2D,
  handle : @rapier_collision.ColliderHandle,
) -> @ecs.Entity? {
  physics.runtime.world.collider_entities.get(collider_handle_key(handle))
}

///|
fn estimate_direction(
  physics~ : PhysicsStep2D,
  from : @ecs.Entity,
  to : @ecs.Entity,
) -> @math.Vec2 {
  if entity_translation(physics~, from) is Some(from_pos) &&
    entity_translation(physics~, to) is Some(to_pos) {
    let delta = to_pos - from_pos
    if delta.x.abs() >= delta.y.abs() {
      Vec2(if delta.x >= 0.0 { 1.0 } else { -1.0 }, 0.0)
    } else {
      Vec2(0.0, if delta.y >= 0.0 { 1.0 } else { -1.0 })
    }
  } else {
    @math.Vec2::zero()
  }
}

///|
fn move_without_collision(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  displacement : @math.Vec2,
  delta : Double,
  write_resolved : (@ecs.Entity, @math.Vec2) -> Unit,
) -> Unit {
  if entity_translation(physics~, entity) is Some(position) {
    let new_position = position + displacement
    set_entity_translation(physics~, entity, new_position)
    if physics.runtime.world.entity_bodies.get(entity) is Some(body_handle) {
      if physics.runtime.world.bodies.get_mut(body_handle) is Some(body) {
        body.set_translation(to_physics_vec2(new_position), true) |> ignore
      }
    }
  }
  if delta.abs() <= EPSILON {
    write_resolved(entity, @math.Vec2::zero())
  } else {
    write_resolved(entity, displacement.scalar_div(delta))
  }
  set_grounded(physics~, entity, false)
}

///|
fn move_with_kinematic_controller(
  physics~ : PhysicsStep2D,
  entity : @ecs.Entity,
  collider_handle : @rapier_collision.ColliderHandle,
  velocity : @math.Vec2,
  delta : Double,
  query_base : @rapier_collision.QueryPipeline,
  write_resolved : (@ecs.Entity, @math.Vec2) -> Unit,
) -> Unit {
  guard entity_translation(physics~, entity) is Some(position) else { return }
  guard entity_collision_shape(physics~, entity) is Some(shape) else {
    move_without_collision(
      physics~,
      entity,
      velocity.scalar_mul(delta),
      delta,
      write_resolved,
    )
    return
  }
  guard collision_shape_to_rapier_shape(shape)
    is Some((rapier_shape, translation)) else {
    move_without_collision(
      physics~,
      entity,
      velocity.scalar_mul(delta),
      delta,
      write_resolved,
    )
    return
  }
  guard physics.collider.get(entity).map(value => value.0) is Some(collider) else {
    move_without_collision(
      physics~,
      entity,
      velocity.scalar_mul(delta),
      delta,
      write_resolved,
    )
    return
  }
  let displacement = velocity.scalar_mul(delta)
  let query = query_base.with_filter(
    @rapier_collision.QueryFilter::QueryFilter()
    .exclude_collider(collider_handle)
    .exclude_sensors()
    .groups(to_rapier_groups(collider.filter)),
  )
  let controller = @rapier_control.KinematicCharacterController::default().with_up(
    Vec2(0.0F, -1.0F),
  )
  let effective = controller.move_shape(
    Float::from_double(delta),
    query,
    physics.runtime.world.bodies,
    physics.runtime.world.colliders,
    rapier_shape,
    @rapier_full.Isometry2::from_translation(
      to_physics_vec2(position + translation),
    ),
    to_physics_vec2(displacement),
    fn(_collision) {  },
  )
  let mut applied_displacement = from_physics_vec2(effective.translation())
  if effective.is_grounded() && applied_displacement.y.abs() < 0.05 {
    applied_displacement = Vec2(applied_displacement.x, 0.0)
  }
  let new_position = position + applied_displacement
  set_entity_translation(physics~, entity, new_position)
  if physics.runtime.world.entity_bodies.get(entity) is Some(body_handle) {
    if physics.runtime.world.bodies.get_mut(body_handle) is Some(body) {
      body.set_next_kinematic_translation(to_physics_vec2(new_position))
      |> ignore
      body.set_linvel(
        to_physics_vec2(applied_displacement.scalar_div(delta)),
        false,
      )
      |> ignore
    }
  }
  write_resolved(entity, applied_displacement.scalar_div(delta))
  set_grounded(physics~, entity, effective.is_grounded())
}

///|
fn process_contact_events(physics~ : PhysicsStep2D) -> Unit {
  let query_collider = physics.collider
  for event in physics.runtime.world.event_handler.take_collision_events() {
    guard entity_from_collider_handle(physics~, event.collider1())
      is Some(entity1) else {
      continue
    }
    guard entity_from_collider_handle(physics~, event.collider2())
      is Some(entity2) else {
      continue
    }
    guard query_collider.get(entity1).map(value => value.0) is Some(collider1) else {
      continue
    }
    guard query_collider.get(entity2).map(value => value.0) is Some(collider2) else {
      continue
    }
    guard collider1.active && collider2.active else { continue }
    let direction = estimate_direction(physics~, entity1, entity2)
    let started = event.started()
    push_contact_event(physics~, {
      entity: entity1,
      other: entity2,
      started,
      direction,
    })
    push_contact_event(physics~, {
      entity: entity2,
      other: entity1,
      started,
      direction: direction.scalar_mul(-1.0),
    })
  }
}

///|
fn update_area_contains(
  physics~ : PhysicsStep2D,
  area_entity : @ecs.Entity,
  other : @ecs.Entity,
  intersecting : Bool,
) -> Unit {
  guard physics.area.get(area_entity).map(value => value.0) is Some(area) else {
    return
  }
  guard area.active else { return }
  if !physics.entities.is_alive(other) {
    return
  }
  guard physics.collider.get(other).map(value => value.0)
    is Some(other_collider) else {
    return
  }
  guard other_collider.active else { return }
  guard area.filter.matches_group(other_collider.filter.group) else { return }
  if intersecting {
    if !area.contains.contains(other) {
      area.contains.add(other)
      push_trigger_event(physics~, { area: area_entity, other, entered: true, })
    }
  } else if area.contains.contains(other) {
    area.contains.remove(other)
    push_trigger_event(physics~, { area: area_entity, other, entered: false, })
  }
}

///|
fn prune_area_contains(physics~ : PhysicsStep2D) -> Unit {
  let query_collider = physics.collider
  let query_area = physics.area
  for _entity, Single(area) in query_area {
    let stale : Array[@ecs.Entity] = []
    for other in area.contains {
      if !area.active {
        stale.push(other)
        continue
      }
      if !physics.entities.is_alive(other) {
        stale.push(other)
        continue
      }
      if query_collider.get(other).map(value => value.0) is None {
        stale.push(other)
      }
    }
    for other in stale {
      area.contains.remove(other)
    }
  }
}

///|
fn clear_area_contains(
  physics~ : PhysicsStep2D,
  area_entity : @ecs.Entity,
  area : Area,
) -> Unit {
  let exiting : Array[@ecs.Entity] = []
  for other in area.contains {
    exiting.push(other)
  }
  area.contains.clear()
  for other in exiting {
    push_trigger_event(physics~, { area: area_entity, other, entered: false, })
  }
}

///|
fn process_trigger_events(physics~ : PhysicsStep2D) -> Unit {
  let query_area = physics.area
  let query_base = @rapier_collision.QueryPipeline::QueryPipeline(
    QueryFilter(),
    physics.runtime.world.bodies,
    physics.runtime.world.colliders,
  )
  for area_entity, Single(area) in query_area {
    guard physics.entities.is_alive(area_entity) else { continue }
    if !area.active {
      clear_area_contains(physics~, area_entity, area)
      continue
    }
    guard physics.runtime.world.entity_colliders.get(area_entity)
      is Some(area_handle) else {
      clear_area_contains(physics~, area_entity, area)
      continue
    }
    guard physics.runtime.world.colliders.get(area_handle)
      is Some(area_collider) else {
      clear_area_contains(physics~, area_entity, area)
      continue
    }
    let query = query_base.with_filter(
      @rapier_collision.QueryFilter::QueryFilter()
      .exclude_collider(area_handle)
      .exclude_sensors()
      .groups(to_rapier_groups(area.filter)),
    )
    let overlaps = query.intersect_shape(
      physics.runtime.world.bodies,
      physics.runtime.world.colliders,
      area_collider.position(),
      area_collider.shape(),
    )
    let intersecting_entities : Set[@ecs.Entity] = Set([])
    for handle in overlaps {
      guard entity_from_collider_handle(physics~, handle) is Some(other) else {
        continue
      }
      intersecting_entities.add(other)
      update_area_contains(physics~, area_entity, other, true)
    }
    let exiting_entities : Array[@ecs.Entity] = []
    for other in area.contains {
      if !intersecting_entities.contains(other) {
        exiting_entities.push(other)
      }
    }
    for other in exiting_entities {
      update_area_contains(physics~, area_entity, other, false)
    }
  }
  prune_area_contains(physics~)
}

///|
fn sync_body_outputs(
  physics~ : PhysicsStep2D,
  write_resolved : (@ecs.Entity, @math.Vec2) -> Unit,
) -> Unit {
  for entity, handle in physics.runtime.world.entity_bodies {
    guard entity_translation(physics~, entity) is Some(_) else { continue }
    if physics.runtime.world.bodies.get(handle) is Some(body) {
      let body_type = body.body_type()
      if body_type is Dynamic || body_type is KinematicVelocityBased {
        set_entity_translation(
          physics~,
          entity,
          from_physics_vec2(body.translation()),
        )
        set_entity_rotation(
          physics~,
          entity,
          from_physics_rotation(body.rotation()),
        )
        write_resolved(entity, from_physics_vec2(body.linvel()))
        set_grounded(physics~, entity, false)
      }
    }
  }
}

///|
fn step_rapier_pipeline(physics~ : PhysicsStep2D, delta : Double) -> Unit {
  physics.runtime.world.integration = physics.runtime.world.integration
    .with_dt(Float::from_double(delta))
    .set_length_unit(Float::from_double(physics_config.pixels_per_meter))
    .set_max_ccd_substeps(physics_config.max_ccd_substeps)
  ignore(physics.runtime.world.event_handler.take_collision_events())
  ignore(physics.runtime.world.event_handler.take_intersection_events())
  physics.runtime.world.pipeline.step(
    to_physics_vec2(physics_config.gravity),
    physics.runtime.world.integration,
    physics.runtime.world.islands,
    physics.runtime.world.broad_phase,
    physics.runtime.world.narrow_phase,
    physics.runtime.world.bodies,
    physics.runtime.world.colliders,
    physics.runtime.world.impulse_joints,
    physics.runtime.world.multibody_joints,
    physics.runtime.world.ccd_solver,
    PhysicsHooks(),
    physics.runtime.world.event_handler,
  )
}

///|
fn rapier_fixed_step(physics~ : PhysicsStep2D, delta : Double) -> Unit {
  let query_collider = physics.collider
  let query_velocity = physics.velocity
  if delta <= 0.0 {
    physics.collisions.grounded_entities.clear()
    physics.collisions.resolved_velocities.clear()
    return
  }
  sync_world_entities(physics~)
  sync_world_joints(physics~)
  sync_world_multibody_joints(physics~)
  physics.collisions.grounded_entities.clear()
  let resolved = physics.collisions.resolved_velocities
  resolved.clear()
  let write_resolved = (entity : @ecs.Entity, velocity : @math.Vec2) => {
    resolved.set(entity, velocity)
  }

  let query_base = @rapier_collision.QueryPipeline::QueryPipeline(
    QueryFilter(),
    physics.runtime.world.bodies,
    physics.runtime.world.colliders,
  )
  for entity, Single(velocity) in query_velocity {
    guard physics.entities.is_alive(entity) else { continue }
    let body_type = entity_rigid_body(physics~, entity).body_type
    guard body_type is KinematicPositionBased else { continue }
    let displacement = velocity.0.scalar_mul(delta)
    if physics.runtime.world.entity_colliders.get(entity)
      is Some(collider_handle) {
      if query_collider.get(entity).map(value => value.0) is Some(collider) &&
        collider.active {
        move_with_kinematic_controller(
          physics~,
          entity,
          collider_handle,
          velocity.0,
          delta,
          query_base,
          write_resolved,
        )
      } else {
        move_without_collision(
          physics~,
          entity,
          displacement,
          delta,
          write_resolved,
        )
      }
    } else {
      move_without_collision(
        physics~,
        entity,
        displacement,
        delta,
        write_resolved,
      )
    }
  }

  step_rapier_pipeline(physics~, delta)
  sync_body_outputs(physics~, write_resolved)
  process_contact_events(physics~)
  process_trigger_events(physics~)
}
