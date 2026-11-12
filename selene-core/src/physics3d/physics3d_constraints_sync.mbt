///|
fn sync_impulse_joints_to_rapier(world~ : @ecs.World) -> Unit {
  let query_impulse_joint : @ecs.Query[ImpulseJoint] = world.query()
  let physics_world = physics3d_world()
  physics_world.impulse_joints = JointSet3DReal()
  physics_world.rope_joints = RopeJointSet3DReal()
  impulse_joint_handles().clear()
  for entity, impulse_joint in query_impulse_joint {
    if !entity.is_alive() || !impulse_joint.parent.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(body_handle) else { continue }
    guard body_handles().get(impulse_joint.parent) is Some(parent_handle) else {
      continue
    }
    match impulse_joint.data {
      Fixed(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          fixed_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Revolute(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          revolute_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Prismatic(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          prismatic_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Spherical(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          spherical_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        if joint.motor_target is Some((target, stiffness, damping)) {
          physics_world.impulse_joints.insert_spherical_motor_rotation(
            body_handle,
            parent_handle,
            rotation_to_rapier(target),
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
        }
        impulse_joint_handles().set(entity, handle)
      }
      Spring(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          spring_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
      Rope(joint) => {
        let handle = physics_world.impulse_joints.insert_generic(
          body_handle,
          parent_handle,
          rope_joint_to_rapier(
            joint,
            contacts_enabled=impulse_joint.contacts_enabled,
          ),
          true,
        )
        impulse_joint_handles().set(entity, handle)
      }
    }
  }
}

///|
fn sync_multibody_joints_to_rapier(world~ : @ecs.World) -> Unit {
  let query_multibody_joint : @ecs.Query[MultibodyJoint] = world.query()
  let physics_world = physics3d_world()
  physics_world.multibody_joints = MultibodyJointSet3DReal()
  multibody_joint_handles().clear()
  for entity, multibody_joint in query_multibody_joint {
    if !entity.is_alive() || !multibody_joint.parent.is_alive() {
      continue
    }
    guard body_handles().get(entity) is Some(child_handle) else { continue }
    guard body_handles().get(multibody_joint.parent) is Some(parent_handle) else {
      continue
    }
    if child_handle.into_raw_parts() == parent_handle.into_raw_parts() {
      continue
    }
    guard multibody_joint_to_rapier(
        multibody_joint.data,
        contacts_enabled=multibody_joint.contacts_enabled,
      )
      is Some(rapier_joint) else {
      continue
    }
    if physics_world.multibody_joints.insert(
        parent_handle, child_handle, rapier_joint, true,
      )
      is Some(handle) {
      multibody_joint_handles().set(entity, handle)
    }
  }
}

///|
fn sync_character_controllers(world~ : @ecs.World, delta : Double) -> Unit {
  let query_collider : @ecs.Query[Collider] = world.query()
  let query_kinematic_character_controller : @ecs.Query[
    KinematicCharacterController,
  ] = world.query()
  if delta <= 0.0 {
    return
  }
  let physics_world = physics3d_world()
  let dt = Float::from_double(delta)
  for entity, controller in query_kinematic_character_controller {
    if !entity.is_alive() {
      continue
    }
    let desired_translation = controller.translation.unwrap_or(
      @math.Vec3::zero(),
    )
    let output = {
      desired_translation,
      effective_translation: @math.Vec3::zero(),
      grounded: false,
      is_sliding_down_slope: false,
    }
    guard query_collider.get(entity) is Some(shape) else {
      kinematic_character_controller_outputs().set(entity, output)
      controller_collisions().set(
        entity,
        KinematicCharacterControllerCollisions(),
      )
      continue
    }
    let query_filter = { ..QueryFilter::all(), exclude_entity: Some(entity), }
    let query = make_query_pipeline(query_filter~)
    let rapier_controller = controller_to_rapier(controller)
    guard current_world_transform(world~, entity) is Some(transform) else {
      continue
    }
    let (query_shape, shape_rotation) = to_query_shape_with_rotation(
      shape,
      transform.rotation,
    )
    let position = @core.Isometry3::Isometry3(
      vec3_to_rapier(transform.translation),
      rotation_to_rapier(shape_rotation),
    )
    let rapier_collisions : Array[@control.CharacterCollision3DReal] = []
    let movement = rapier_controller.move_shape(
      dt,
      query,
      physics_world.bodies,
      physics_world.colliders,
      query_shape,
      position,
      vec3_to_rapier(desired_translation),
      fn(collision) { rapier_collisions.push(collision) },
    )
    if controller.apply_impulses_to_dynamic_bodies {
      rapier_controller.solve_character_collision_impulses(
        dt,
        query,
        physics_world.bodies,
        physics_world.colliders,
        query_shape,
        1.0,
        rapier_collisions,
      )
    }
    let effective_translation = vec3_from_rapier(movement.translation())
    kinematic_character_controller_outputs().set(entity, {
      desired_translation,
      effective_translation,
      grounded: movement.is_grounded(),
      is_sliding_down_slope: movement.is_sliding_down_slope(),
    })
    controller_collisions().set(entity, {
      collisions: rapier_collisions.map(collision => {
        entity: resolve_collider_entity(collision.handle()),
        character_translation_applied: vec3_from_rapier(
          collision.translation_applied(),
        ),
        character_translation_remaining: vec3_from_rapier(
          collision.translation_remaining(),
        ),
        toi: collision.hit().toi().to_double(),
        normal: vec3_from_rapier(collision.hit().normal()),
      }),
    })
    apply_character_controller_translation(
      world~,
      entity,
      effective_translation,
      delta,
    )
    world.set_component(
      entity,
      ({ ..controller, translation: None, } : KinematicCharacterController),
    )
  }
}

///|
fn sync_collider_to_rapier(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  collider_desc : ColliderDesc,
) -> Unit {
  let physics_world = physics3d_world()
  guard collider_handles().get(entity) is Some(handle) else { return }
  guard physics_world.colliders.get_mut(handle) is Some(collider) else {
    return
  }
  let collision_groups = interaction_groups(
    collider_desc.collision_groups.memberships,
    collider_desc.collision_groups.filters,
  )
  let solver = collider_desc.solver_groups.unwrap_or(SolverGroups::all())
  let solver_groups = interaction_groups(solver.memberships, solver.filters)
  let active_events = effective_active_events(collider_desc)

  match attached_rigid_body_entity(world~, entity) {
    Some(body_entity) =>
      match body_handles().get(body_entity) {
        Some(parent_handle) => {
          let mut parent_changed = true
          match collider.parent() {
            Some(existing_parent) =>
              if existing_parent.into_raw_parts() ==
                parent_handle.into_raw_parts() {
                parent_changed = false
              }
            None => ()
          }
          if parent_changed {
            physics_world.colliders.set_parent(
              handle,
              Some(parent_handle),
              physics_world.bodies,
            )
          }
          guard collider_transform(world~, entity, Some(body_entity))
            is Some(relative_transform) else {
            return
          }
          collider.set_local_position(
            Isometry3(
              vec3_to_rapier(relative_transform.translation),
              rotation_to_rapier(relative_transform.rotation),
            ),
          )
        }
        None => set_standalone_collider_position(world~, collider, entity)
      }
    None => {
      if collider.parent() is Some(_) {
        physics_world.colliders.set_parent(handle, None, physics_world.bodies)
      }
      set_standalone_collider_position(world~, collider, entity)
    }
  }

  ignore(
    collider
    .set_collision_groups(collision_groups)
    .set_solver_groups(solver_groups)
    .set_enabled(true)
    .set_active_collision_types(collider_desc.active_collision_types)
    .set_active_events(active_events)
    .set_active_hooks(collider_desc.active_hooks)
    .set_contact_force_event_threshold(
      Float::from_double(collider_desc.contact_force_event_threshold.0),
    ),
  )
}

///|
fn ensure_rigid_body(world~ : @ecs.World, entity : @ecs.Entity) -> Unit {
  let physics_world = physics3d_world()
  let body_handles = body_handles()
  if body_handles.get(entity) is Some(handle) {
    if physics_world.bodies.get(handle) is Some(_) {
      return
    }
    body_handles.remove(entity)
  }

  let body_desc = rigid_body_desc(world~, entity)
  guard current_world_transform(world~, entity) is Some(transform) else {
    return
  }
  let mut builder = match body_desc.body_type {
    Dynamic => @dynamics.RigidBodyBuilder3D::dynamic()
    Fixed => @dynamics.RigidBodyBuilder3D::fixed()
    KinematicPositionBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_position_based()
    KinematicVelocityBased =>
      @dynamics.RigidBodyBuilder3D::kinematic_velocity_based()
  }
  builder = builder
    .translation(vec3_to_rapier(transform.translation))
    .rotation(rotation_to_rapier(transform.rotation))
    .gravity_scale(Float::from_double(body_desc.gravity_scale.0))
    .dominance_group(body_desc.dominance.map(d => d.0).unwrap_or(0))
    .linear_damping(Float::from_double(body_desc.damping.linear_damping))
    .angular_damping(Float::from_double(body_desc.damping.angular_damping))
    .ccd_enabled(body_desc.ccd_enabled)
    .linvel(vec3_to_rapier(body_desc.velocity.linvel))
    .angvel(vec3_to_rapier(body_desc.velocity.angvel))
    .enabled_rotations(
      !body_desc.locked_axes.lock_rotation_x,
      !body_desc.locked_axes.lock_rotation_y,
      !body_desc.locked_axes.lock_rotation_z,
    )
  if body_desc.locked_axes.lock_translation_x &&
    body_desc.locked_axes.lock_translation_y &&
    body_desc.locked_axes.lock_translation_z {
    builder = builder.lock_translations()
  }
  if body_desc.additional_mass_properties is Some(additional) {
    builder = builder.mass_properties(
      additional_mass_properties_to_rapier(additional),
    )
  }
  let handle = physics_world.bodies.insert(builder.build())
  body_handles.set(entity, handle)
}

///|
fn ensure_collider(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  collider_desc : ColliderDesc,
) -> Unit {
  let physics_world = physics3d_world()
  let body_handles = body_handles()
  let collider_handles = collider_handles()
  let collider_entities_by_key = collider_entities_by_key()
  if collider_handles.get(entity) is Some(handle) {
    if physics_world.colliders.get(handle) is Some(_) {
      return
    }
    collider_handles.remove(entity)
    collider_entities_by_key.remove(collider_key(handle))
  }

  let mut builder = collider_builder_from_desc(collider_desc)
  let body_entity = attached_rigid_body_entity(world~, entity)
  guard collider_transform(world~, entity, body_entity) is Some(transform) else {
    return
  }
  builder = builder
    .translation(vec3_to_rapier(transform.translation))
    .rotation(rotation_to_rapier(transform.rotation))
  let collider = builder.build()

  let handle = if body_entity is Some(body_entity) &&
    body_handles.get(body_entity) is Some(parent_handle) &&
    physics_world.bodies.get(parent_handle) is Some(_) {
    physics_world.colliders.insert_with_parent(
      collider,
      parent_handle,
      physics_world.bodies,
    )
  } else {
    physics_world.colliders.insert(collider)
  }

  collider_handles.set(entity, handle)
  collider_entities_by_key.set(collider_key(handle), entity)
}

///|
fn collider_builder_from_desc(
  collider_desc : ColliderDesc,
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
    CapsuleX(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_x(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleY(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_y(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    CapsuleZ(half_height, radius) =>
      @collision.ColliderBuilder3D::capsule_z(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cylinder(half_height, radius) =>
      @collision.ColliderBuilder3D::cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    Cone(half_height, radius) =>
      @collision.ColliderBuilder3D::cone(
        Float::from_double(half_height),
        Float::from_double(radius),
      )
    RoundCylinder(half_height, radius, border_radius) =>
      @collision.ColliderBuilder3D::round_cylinder(
        Float::from_double(half_height),
        Float::from_double(radius),
        Float::from_double(border_radius),
      )
    Halfspace(normal) =>
      @collision.ColliderBuilder3D::halfspace(
        vec3_to_rapier(normal.normalize_or_zero()),
      )
    ConvexHull(points) =>
      @collision.ColliderBuilder3D::convex_hull(
        points.map(point => vec3_to_rapier(point)),
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
    TriMesh(vertices, indices) =>
      @collision.ColliderBuilder3D::trimesh(
        vertices.map(point => vec3_to_rapier(point)),
        indices,
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
    Heightfield(heights, nrows, ncols, scale) =>
      @collision.ColliderBuilder3D::heightfield(
        heights.map(Float::from_double),
        nrows,
        ncols,
        vec3_to_rapier(scale),
      ).unwrap_or(@collision.ColliderBuilder3D::ball(0.0))
  }

  let groups = interaction_groups(
    collider_desc.collision_groups.memberships,
    collider_desc.collision_groups.filters,
  )
  let solver = collider_desc.solver_groups.unwrap_or(SolverGroups::all())
  let solver_groups = interaction_groups(solver.memberships, solver.filters)
  builder = builder
    .collision_groups(groups)
    .solver_groups(solver_groups)
    .friction(Float::from_double(collider_desc.friction.0))
    .restitution(Float::from_double(collider_desc.restitution.0))
    .sensor(collider_desc.sensor)
    .active_events(effective_active_events(collider_desc))
    .active_collision_types(collider_desc.active_collision_types)
    .active_hooks(collider_desc.active_hooks)
    .enabled(true)
    .contact_force_event_threshold(
      Float::from_double(collider_desc.contact_force_event_threshold.0),
    )
  if collider_desc.mass_properties is Some(Density(density)) {
    builder = builder.density(Float::from_double(density))
  }
  builder
}

///|
fn effective_active_events(
  collider_desc : ColliderDesc,
) -> @collision.ActiveEvents {
  let mut active_events = @collision.ActiveEvents::collision_events().union(
    @collision.ActiveEvents::intersection_events(),
  )
  if collider_desc.contact_force_event_threshold.0 < 1.0e29 {
    active_events = active_events.union(
      @collision.ActiveEvents::contact_force_events(),
    )
  }
  collider_desc.active_events.union(active_events)
}
