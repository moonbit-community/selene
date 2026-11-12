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
  world~ : @ecs.World,
  entity : @ecs.Entity,
  translation : @math.Vec3,
) -> Unit {
  guard current_world_transform(world~, entity) is Some(transform) else {
    return
  }
  let world_transform = { ..transform, translation, }
  guard set_entity_world_transform(world~, entity, world_transform) else {
    return
  }
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
  world~ : @ecs.World,
  entity : @ecs.Entity,
  rotation : @math.Rotation3,
) -> Unit {
  guard current_world_transform(world~, entity) is Some(transform) else {
    return
  }
  let world_transform = { ..transform, rotation, }
  guard set_entity_world_transform(world~, entity, world_transform) else {
    return
  }
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
  world~ : @ecs.World,
  entity : @ecs.Entity,
  linear_velocity : @math.Vec3,
) -> Unit {
  let velocity = (world.get_component(entity) : Velocity?).unwrap_or(
    Velocity::zero(),
  )
  world.set_component(
    entity,
    ({ ..velocity, linvel: linear_velocity, } : Velocity),
  )
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
  world~ : @ecs.World,
  entity : @ecs.Entity,
  angular_velocity : @math.Vec3,
) -> Unit {
  let velocity = (world.get_component(entity) : Velocity?).unwrap_or(
    Velocity::zero(),
  )
  world.set_component(
    entity,
    ({ ..velocity, angvel: angular_velocity, } : Velocity),
  )
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
fn rigid_body_desc(world~ : @ecs.World, entity : @ecs.Entity) -> RigidBodyDesc {
  let query_ccd : @ecs.Query[Ccd] = world.query()
  {
    body_type: (world.get_component(entity) : RigidBody?).unwrap_or(Dynamic),
    velocity: (world.get_component(entity) : Velocity?).unwrap_or(
      Velocity::zero(),
    ),
    damping: (world.get_component(entity) : Damping?).unwrap_or(Damping()),
    gravity_scale: (world.get_component(entity) : GravityScale?).unwrap_or(
      GravityScale::default(),
    ),
    locked_axes: (world.get_component(entity) : LockedAxes?).unwrap_or(
      LockedAxes(),
    ),
    ccd_enabled: query_ccd.contains(entity),
    dominance: (world.get_component(entity) : Dominance?),
    additional_mass_properties: (
      world.get_component(entity) : AdditionalMassProperties?),
  }
}

///|
fn collider_desc(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  shape : Collider,
) -> ColliderDesc {
  let query_sensor : @ecs.Query[Sensor] = world.query()
  {
    shape,
    sensor: query_sensor.contains(entity),
    friction: (world.get_component(entity) : Friction?).unwrap_or(Friction(0.5)),
    restitution: (world.get_component(entity) : Restitution?).unwrap_or(
      Restitution(0.0),
    ),
    collision_groups: (world.get_component(entity) : CollisionGroups?).unwrap_or(
      CollisionGroups::all(),
    ),
    solver_groups: (world.get_component(entity) : SolverGroups?),
    active_collision_types: (world.get_component(entity) : ActiveCollisionTypes?)
    .map(flags => flags.0)
    .unwrap_or(@collision.ActiveCollisionTypes::default()),
    active_events: (world.get_component(entity) : ActiveEvents?)
    .map(flags => flags.0)
    .unwrap_or(
      @collision.ActiveEvents::collision_events().union(
        @collision.ActiveEvents::intersection_events(),
      ),
    ),
    active_hooks: (world.get_component(entity) : ActiveHooks?)
    .map(flags => flags.0)
    .unwrap_or(@collision.ActiveHooks::empty()),
    contact_force_event_threshold: (
      world.get_component(entity) : ContactForceEventThreshold?).unwrap_or(
      ContactForceEventThreshold::default(),
    ),
    mass_properties: (world.get_component(entity) : ColliderMassProperties?),
  }
}

///|
fn clear_controller_outputs() -> Unit {
  kinematic_character_controller_outputs().clear()
  controller_collisions().clear()
}

///|
pub fn physics_step_system(world~ : @ecs.World, delta : Double) -> Unit {
  if delta <= 0.0 {
    return
  }
  clear_controller_outputs()
  cleanup_world_components(world~)
  ensure_bodies_and_colliders(world~)
  sync_components_to_rapier(world~)
  sync_impulse_joints_to_rapier(world~)
  sync_multibody_joints_to_rapier(world~)
  sync_character_controllers(world~, delta)

  let physics_world = physics3d_world()
  physics_world.integration = physics_world.integration.with_dt(
    Float::from_double(delta),
  )
  physics_world.pipeline.step_with_events(
    vec3_to_rapier(config.gravity),
    physics_world.integration,
    physics_world.islands,
    physics_world.broad_phase,
    physics_world.narrow_phase,
    physics_world.bodies,
    physics_world.colliders,
    physics_world.event_handler,
  )
  physics_world.impulse_joints.solve(
    physics_world.bodies,
    Float::from_double(delta),
    physics_world.integration.num_solver_iterations,
  )
  physics_world.rope_joints.solve(
    physics_world.bodies,
    Float::from_double(delta),
  )
  physics_world.multibody_joints.sync_rigid_bodies_from_multibodies(
    physics_world.bodies,
  )

  collect_events()
  sync_rapier_to_components(world~)
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
  let physics_world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let ray = @collision.Ray3::Ray3(
    vec3_to_rapier(origin),
    vec3_to_rapier(direction.normalize_or_zero()),
  )
  match
    query.cast_ray_and_get_normal(
      physics_world.bodies,
      physics_world.colliders,
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
  let physics_world = physics3d_world()
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
      physics_world.bodies,
      physics_world.colliders,
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
  let physics_world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  let entities : Array[@ecs.Entity] = []
  for
    handle in query.intersect_point(
      physics_world.bodies,
      physics_world.colliders,
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
  let physics_world = physics3d_world()
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
      physics_world.bodies,
      physics_world.colliders,
      query_aabb,
    ) {
    guard resolve_collider_entity(handle) is Some(entity) else { continue }
    guard physics_world.colliders.get(handle) is Some(collider) else {
      continue
    }
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
  let physics_world = physics3d_world()
  let query = make_query_pipeline(query_filter~)
  match
    query.project_point(
      physics_world.bodies,
      physics_world.colliders,
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
fn ensure_bodies_and_colliders(world~ : @ecs.World) -> Unit {
  let query_rigid_body : @ecs.Query[RigidBody] = world.query()
  let query_collider : @ecs.Query[Collider] = world.query()
  for entity, _ in query_rigid_body {
    if !entity.is_alive() {
      continue
    }
    ensure_rigid_body(world~, entity)
  }

  for entity, collider in query_collider {
    if !entity.is_alive() {
      continue
    }
    ensure_collider(world~, entity, collider_desc(world~, entity, collider))
  }
}

///|
fn sync_components_to_rapier(world~ : @ecs.World) -> Unit {
  let query_rigid_body : @ecs.Query[RigidBody] = world.query()
  let query_collider : @ecs.Query[Collider] = world.query()
  let physics_world = physics3d_world()
  for entity, _ in query_rigid_body {
    if !entity.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(handle) else { continue }
    guard physics_world.bodies.get_mut(handle) is Some(body) else { continue }
    let body_desc = rigid_body_desc(world~, entity)

    body.set_linvel(vec3_to_rapier(body_desc.velocity.linvel))
    body.set_angvel(vec3_to_rapier(body_desc.velocity.angvel))
    body.set_dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))

    match body_desc.body_type {
      KinematicPositionBased =>
        if current_world_transform(world~, entity) is Some(transform) {
          body.set_next_kinematic_translation(
            vec3_to_rapier(transform.translation),
          )
          body.set_next_kinematic_rotation(
            rotation_to_rapier(transform.rotation),
          )
        }
      Fixed =>
        if current_world_transform(world~, entity) is Some(transform) {
          body.set_translation(vec3_to_rapier(transform.translation))
          body.set_rotation(rotation_to_rapier(transform.rotation))
        }
      _ => ()
    }
  }

  for entity, collider in query_collider {
    if !entity.is_alive() {
      continue
    }
    sync_collider_to_rapier(
      world~,
      entity,
      collider_desc(world~, entity, collider),
    )
  }
}

///|
fn sync_rapier_to_components(world~ : @ecs.World) -> Unit {
  let query_velocity : @ecs.Query[Velocity] = world.query()
  let physics_world = physics3d_world()
  for entity, handle in body_handles() {
    if !entity.is_alive() {
      continue
    }
    guard physics_world.bodies.get(handle) is Some(body) else { continue }
    guard current_world_transform(world~, entity) is Some(transform) else {
      continue
    }
    let world_transform = {
      ..transform,
      translation: vec3_from_rapier(body.translation()),
      rotation: rotation_from_rapier(body.rotation()),
    }
    guard set_entity_world_transform(world~, entity, world_transform) else {
      // A simulated rotation can introduce local shear under a scaled parent.
      // Keep the body at the last pose the hierarchy can represent.
      if physics_world.bodies.get_mut(handle) is Some(body) {
        body.set_translation(vec3_to_rapier(transform.translation))
        body.set_rotation(rotation_to_rapier(transform.rotation))
      }
      continue
    }
    if query_velocity.contains(entity) {
      world.set_component(
        entity,
        (
          {
            linvel: vec3_from_rapier(body.linvel()),
            angvel: vec3_from_rapier(body.angvel()),
          } : Velocity),
      )
    }
  }
}
