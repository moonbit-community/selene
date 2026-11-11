///|
pub fn rigid_body_translation(entity : @ecs.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => vec3_from_rapier(body.translation()))
    None => None
  }
}

///|
pub fn set_rigid_body_translation(
  entity : @ecs.Entity,
  translation : @math.Vec3,
) -> Unit {
  guard current_world_transform(entity) is Some(transform) else { return }
  let world_transform = { ..transform, translation, }
  guard set_entity_world_transform(entity, world_transform) else { return }
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_translation(vec3_to_rapier(translation))
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_rotation(entity : @ecs.Entity) -> @math.Rotation3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => rotation_from_rapier(body.rotation()))
    None => None
  }
}

///|
pub fn set_rigid_body_rotation(
  entity : @ecs.Entity,
  rotation : @math.Rotation3,
) -> Unit {
  guard current_world_transform(entity) is Some(transform) else { return }
  let world_transform = { ..transform, rotation, }
  guard set_entity_world_transform(entity, world_transform) else { return }
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_rotation(rotation_to_rapier(rotation))
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_linear_velocity(entity : @ecs.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => vec3_from_rapier(body.linvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @ecs.Entity,
  linear_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, linvel: linear_velocity, })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_linvel(vec3_to_rapier(linear_velocity))
        None => ()
      }
    None => ()
  }
}

///|
pub fn rigid_body_angular_velocity(entity : @ecs.Entity) -> @math.Vec3? {
  match body_handles().get(entity) {
    Some(handle) =>
      physics3d_world().bodies
      .get(handle)
      .map(body => vec3_from_rapier(body.angvel()))
    None => None
  }
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @ecs.Entity,
  angular_velocity : @math.Vec3,
) -> Unit {
  let velocity = velocities().get(entity).unwrap_or(Velocity::zero())
  velocities().set(entity, { ..velocity, angvel: angular_velocity, })
  match body_handles().get(entity) {
    Some(handle) =>
      match physics3d_world().bodies.get_mut(handle) {
        Some(body) => body.set_angvel(vec3_to_rapier(angular_velocity))
        None => ()
      }
    None => ()
  }
}

///|
fn rigid_body_desc(entity : @ecs.Entity) -> RigidBodyDesc {
  {
    body_type: rigid_bodies().get(entity).unwrap_or(Dynamic),
    velocity: velocities().get(entity).unwrap_or(Velocity::zero()),
    damping: dampings().get(entity).unwrap_or(Damping()),
    gravity_scale: gravity_scales()
    .get(entity)
    .unwrap_or(GravityScale::default()),
    locked_axes: locked_axes().get(entity).unwrap_or(LockedAxes()),
    ccd_enabled: ccds().contains(entity),
    dominance: dominances().get(entity),
    additional_mass_properties: additional_mass_properties().get(entity),
  }
}

///|
fn collider_desc(entity : @ecs.Entity, shape : Collider) -> ColliderDesc {
  {
    shape,
    sensor: sensors().contains(entity),
    friction: frictions().get(entity).unwrap_or(Friction(0.5)),
    restitution: restitutions().get(entity).unwrap_or(Restitution(0.0)),
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
  kinematic_character_controller_outputs().clear()
  kinematic_character_controller_collisions().clear()
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
    vec3_to_rapier(config.gravity),
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
  max_toi~ : Double = 1000.0,
  solid~ : Bool = true,
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> RaycastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let ray = @collision.Ray3::Ray3(
    vec3_to_rapier(origin),
    vec3_to_rapier(direction.normalize_or_zero()),
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
          normal: vec3_from_rapier(hit.normal()),
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
  rotation~ : @math.Rotation3 = @math.Rotation3::identity(),
  direction~ : @math.Vec3 = Vec3(0.0, -1.0, 0.0),
  max_toi~ : Double = 1000.0,
  stop_at_penetration~ : Bool = false,
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> ShapeCastHit? {
  if direction.length_squared() <= 0.000000001 {
    return None
  }
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let options = @collision.ShapeCastOptions3::ShapeCastOptions3(
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
      Isometry3(vec3_to_rapier(origin), rotation_to_rapier(shape_rotation)),
      vec3_to_rapier(direction.normalize_or_zero()),
      query_shape,
      options,
    ) {
    Some((handle, hit)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          toi: hit.toi().to_double(),
          normal: vec3_from_rapier(hit.normal()),
        }
      })
    None => None
  }
}

///|
pub fn RapierContext::intersections_with_point(
  _self : RapierContext,
  point : @math.Vec3,
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> Array[@ecs.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@ecs.Entity] = []
  for
    handle in query.intersect_point(
      world.bodies,
      world.colliders,
      vec3_to_rapier(point),
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
  rotation~ : @math.Rotation3 = @math.Rotation3::identity(),
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> Array[@ecs.Entity] {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@ecs.Entity] = []
  let (query_shape, shape_rotation) = to_query_shape_with_rotation(
    shape, rotation,
  )
  let query_iso = @core.Isometry3::Isometry3(
    vec3_to_rapier(origin),
    rotation_to_rapier(shape_rotation),
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
  solid~ : Bool = true,
  query_filter~ : QueryFilter = QueryFilter::all(),
) -> PointProjection? {
  let world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  match
    query.project_point(
      world.bodies,
      world.colliders,
      vec3_to_rapier(point),
      1.0e30,
      solid,
    ) {
    Some((handle, projection)) =>
      resolve_collider_entity(handle).map(fn(entity) {
        {
          entity,
          point: vec3_from_rapier(projection.point()),
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
    ensure_rigid_body(entity)
  }

  for entity, collider in colliders() {
    if !entity.is_alive() {
      continue
    }
    ensure_collider(entity, collider_desc(entity, collider))
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

    body.set_linvel(vec3_to_rapier(body_desc.velocity.linvel))
    body.set_angvel(vec3_to_rapier(body_desc.velocity.angvel))
    body.set_dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))

    match body_desc.body_type {
      KinematicPositionBased =>
        if current_world_transform(entity) is Some(transform) {
          body.set_next_kinematic_translation(
            vec3_to_rapier(transform.translation),
          )
          body.set_next_kinematic_rotation(
            rotation_to_rapier(transform.rotation),
          )
        }
      Fixed =>
        if current_world_transform(entity) is Some(transform) {
          body.set_translation(vec3_to_rapier(transform.translation))
          body.set_rotation(rotation_to_rapier(transform.rotation))
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
    guard current_world_transform(entity) is Some(transform) else { continue }
    let world_transform = {
      ..transform,
      translation: vec3_from_rapier(body.translation()),
      rotation: rotation_from_rapier(body.rotation()),
    }
    guard set_entity_world_transform(entity, world_transform) else {
      // A simulated rotation can introduce local shear under a scaled parent.
      // Keep the body at the last pose the hierarchy can represent.
      if world.bodies.get_mut(handle) is Some(body) {
        body.set_translation(vec3_to_rapier(transform.translation))
        body.set_rotation(rotation_to_rapier(transform.rotation))
      }
      continue
    }
    if velocities().contains(entity) {
      velocities().set(entity, {
        linvel: vec3_from_rapier(body.linvel()),
        angvel: vec3_from_rapier(body.angvel()),
      })
    }
  }
}
