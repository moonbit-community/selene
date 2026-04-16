///|
pub fn rigid_body_translation(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.translation()))
    None => None
  }
}

///|
pub fn set_rigid_body_translation(
  entity : @entity.Entity,
  translation : @math.Vec3,
) -> Unit {
  let world_transform = {
    ..current_world_transform(entity).unwrap_or_default(),
    translation,
  }
  set_entity_world_transform(entity, world_transform)
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_translation(translation.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_rotation(entity : @entity.Entity) -> @math.Quat? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.quat_from_rapier(body.rotation()))
    None => None
  }
}

///|
pub fn set_rigid_body_rotation(
  entity : @entity.Entity,
  rotation : @math.Quat,
) -> Unit {
  let world_transform = {
    ..current_world_transform(entity).unwrap_or_default(),
    rotation,
  }
  set_entity_world_transform(entity, world_transform)
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_rotation(rotation.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_linear_velocity(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.linvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @entity.Entity,
  linear_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, linvel: linear_velocity })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_linvel(linear_velocity.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_angular_velocity(entity : @entity.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => @math.vec3_from_rapier(body.angvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @entity.Entity,
  angular_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, angvel: angular_velocity })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_angvel(angular_velocity.to_rapier())
        None => ()
      }
    None => ()
  }
}

///|
fn rigid_body_desc(entity : @entity.Entity) -> RigidBodyDesc {
  {
    body_type: rigid_bodies().get(entity).unwrap_or(Dynamic),
    velocity: velocities().get(entity).unwrap_or(Velocity::zero()),
    damping: dampings().get(entity).unwrap_or(Damping::default()),
    gravity_scale: gravity_scales()
    .get(entity)
    .unwrap_or(GravityScale::default()),
    locked_axes: locked_axes().get(entity).unwrap_or(LockedAxes::default()),
    ccd_enabled: ccds().contains(entity),
    dominance: dominances().get(entity),
    additional_mass_properties: additional_mass_properties().get(entity),
  }
}

///|
fn collider_desc(entity : @entity.Entity, shape : Collider) -> ColliderDesc {
  {
    shape,
    sensor: sensors().contains(entity),
    friction: frictions().get(entity).unwrap_or(Friction::new(0.5)),
    restitution: restitutions().get(entity).unwrap_or(Restitution::new(0.0)),
    collision_groups: collision_groups()
    .get(entity)
    .unwrap_or(CollisionGroups::all()),
    solver_groups: solver_groups().get(entity),
    active_collision_types: active_collision_types()
    .get(entity)
    .unwrap_or(@collision.ActiveCollisionTypes::default()),
    active_events: active_events()
    .get(entity)
    .unwrap_or(
      @collision.ActiveEvents::collision_events().union(
        @collision.ActiveEvents::intersection_events(),
      ),
    ),
    active_hooks: active_hooks()
    .get(entity)
    .unwrap_or(@collision.ActiveHooks::empty()),
    contact_force_event_threshold: contact_force_event_thresholds()
    .get(entity)
    .unwrap_or(ContactForceEventThreshold::default()),
    mass_properties: collider_mass_properties().get(entity),
  }
}

///|
fn clear_controller_outputs() -> Unit {
  for pair in kinematic_character_controller_outputs().to_array() {
    kinematic_character_controller_outputs().remove(pair.0)
  }
  for pair in kinematic_character_controller_collisions().to_array() {
    kinematic_character_controller_collisions().remove(pair.0)
  }
}

///|
pub fn physics_step_system(delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  clear_controller_outputs()
  cleanup_world_components()
  ensure_bodies_and_colliders()
  sync_components_to_rapier()
  sync_impulse_joints_to_rapier()
  sync_multibody_joints_to_rapier()
  sync_character_controllers(delta)

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
  world.impulse_joints.solve(
    world.bodies,
    Float::from_double(delta),
    world.integration.num_solver_iterations,
  )
  world.rope_joints.solve(world.bodies, Float::from_double(delta))
  world.multibody_joints.sync_rigid_bodies_from_multibodies(world.bodies)

  collect_events()
  sync_rapier_to_components()
}

///|
pub fn RapierContext::cast_ray(
  _self : RapierContext,
  origin : @math.Vec3,
  direction : @math.Vec3,
  max_toi? : Double = 1000.0,
  solid? : Bool = true,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> RaycastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
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
pub fn RapierContext::cast_shape(
  _self : RapierContext,
  shape : Collider,
  origin : @math.Vec3,
  rotation? : @math.Quat = @math.Quat::identity(),
  direction? : @math.Vec3 = @math.Vec3::new(0.0, -1.0, 0.0),
  max_toi? : Double = 1000.0,
  stop_at_penetration? : Bool = false,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> ShapeCastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let options = @collision.ShapeCastOptions3::new(
    Float::from_double(max_toi),
    stop_at_penetration,
  )
  let (query_shape, shape_rotation) = to_query_shape_with_rotation(
    shape, rotation,
  )
  match
    query.cast_shape(
      world.bodies,
      world.colliders,
      @core.Isometry3::new(origin.to_rapier(), shape_rotation.to_rapier()),
      direction.normalize().to_rapier(),
      query_shape,
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
pub fn RapierContext::intersections_with_point(
  _self : RapierContext,
  point : @math.Vec3,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> Array[@entity.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@entity.Entity] = []
  for
    handle in query.intersect_point(
      world.bodies,
      world.colliders,
      point.to_rapier(),
    ) {
    match resolve_collider_entity(handle) {
      Some(entity) => entities.push(entity)
      None => ()
    }
  }
  entities
}

///|
pub fn RapierContext::intersections_with_shape(
  _self : RapierContext,
  shape : Collider,
  origin : @math.Vec3,
  rotation? : @math.Quat = @math.Quat::identity(),
  query_filter? : QueryFilter = QueryFilter::all(),
) -> Array[@entity.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@entity.Entity] = []
  let (query_shape, shape_rotation) = to_query_shape_with_rotation(
    shape, rotation,
  )
  let query_iso = @core.Isometry3::new(
    origin.to_rapier(),
    shape_rotation.to_rapier(),
  )
  let query_aabb = shape_world_aabb(query_shape, origin, shape_rotation)
  for
    handle in query.intersect_aabb_conservative(
      world.bodies,
      world.colliders,
      query_aabb,
    ) {
    guard resolve_collider_entity(handle) is Some(entity) else { continue }
    guard world.colliders.get(handle) is Some(collider) else { continue }
    if shapes_intersect(
        query_shape,
        query_iso,
        collider.shape(),
        collider.position(),
      ) {
      entities.push(entity)
    }
  }
  entities
}

///|
pub fn RapierContext::project_point(
  _self : RapierContext,
  point : @math.Vec3,
  solid? : Bool = true,
  query_filter? : QueryFilter = QueryFilter::all(),
) -> PointProjection? {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  match
    query.project_point(
      world.bodies,
      world.colliders,
      point.to_rapier(),
      1.0e30,
      solid,
    ) {
    Some((handle, projection)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          point: @math.vec3_from_rapier(projection.point()),
          is_inside: projection.is_inside(),
        }
      })
    None => None
  }
}

///|
fn ensure_bodies_and_colliders() -> Unit {
  for entity, _ in rigid_bodies() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_rigid_body(entity))
  }

  for entity, collider in colliders() {
    if !entity.is_alive() {
      continue
    }
    ignore(ensure_collider(entity, collider_desc(entity, collider)))
  }
}

///|
fn sync_components_to_rapier() -> Unit {
  let world = physics3d_world()
  for entity, _ in rigid_bodies() {
    if !entity.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(handle) else { continue }
    guard world.bodies.get_mut(handle) is Some(body) else { continue }
    let body_desc = rigid_body_desc(entity)

    body.set_linvel(body_desc.velocity.linvel.to_rapier())
    body.set_angvel(body_desc.velocity.angvel.to_rapier())
    body.set_dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))

    match body_desc.body_type {
      KinematicPositionBased =>
        if current_world_transform(entity) is Some(transform) {
          body.set_next_kinematic_translation(transform.translation.to_rapier())
          body.set_next_kinematic_rotation(transform.rotation.to_rapier())
        }
      Fixed =>
        if current_world_transform(entity) is Some(transform) {
          body.set_translation(transform.translation.to_rapier())
          body.set_rotation(transform.rotation.to_rapier())
        }
      _ => ()
    }
  }

  for entity, collider in colliders() {
    if !entity.is_alive() {
      continue
    }
    sync_collider_to_rapier(entity, collider_desc(entity, collider))
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
    let world_transform : @transform.Transform = {
      ..current_world_transform(entity).unwrap_or_default(),
      translation: @math.vec3_from_rapier(body.translation()),
      rotation: @math.quat_from_rapier(body.rotation()),
    }
    let local_transform = match entity.get_parent() {
      Some(parent) =>
        match @transform.compute_global_transform(parent) {
          Some(parent_global) =>
            @transform.GlobalTransform::from_transform(world_transform).reparented_to(
              parent_global,
            )
          None => world_transform
        }
      None => world_transform
    }
    @transform.transforms().set(entity, local_transform)
    velocities().set(entity, {
      linvel: @math.vec3_from_rapier(body.linvel()),
      angvel: @math.vec3_from_rapier(body.angvel()),
    })
  }
}
