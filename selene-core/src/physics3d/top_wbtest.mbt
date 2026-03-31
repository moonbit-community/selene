///|
fn with_physics3d_test_world(action : () -> Unit raise) -> Unit raise {
  let previous_world = @ecs.current_world()
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  match previous_world {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  }
}

///|
fn step_physics(iterations : Int) -> Unit {
  for _ in 0..<iterations {
    physics_step_system(1.0 / 60.0)
  }
}

///|
test "same-entity collider uses body world transform only once" {
  with_physics3d_test_world(fn() raise {
    let body = @entity.Entity::new()
    @transform.transforms().set(
      body,
      @transform.Transform::from_xyz(4.0, 0.0, 0.0),
    )
    rigid_bodies().set(body, Fixed)
    colliders().set(body, Collider::ball(1.0))

    step_physics(1)

    let hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis())
      .unwrap()
    inspect(hit.entity == body, content="true")
    inspect(hit.toi >= 2.9 && hit.toi <= 3.1, content="true")
  })
}

///|
test "child collider stays relative to its rigid-body ancestor" {
  with_physics3d_test_world(fn() raise {
    let body = @entity.Entity::new()
    @transform.transforms().set(
      body,
      @transform.Transform::from_xyz(4.0, 0.0, 0.0),
    )
    rigid_bodies().set(body, Fixed)

    let child = body.spawn_child()
    @transform.transforms().set(
      child,
      @transform.Transform::from_xyz(0.0, 0.0, 2.0),
    )
    colliders().set(child, Collider::ball(0.5))

    step_physics(1)

    let collider = physics3d_world().colliders
      .get(collider_handle(child).unwrap())
      .unwrap()
    inspect(
      @math.vec3_from_rapier(collider.local_position().translation),
      content="{x: 0, y: 0, z: 2}",
    )
    let hit = context()
      .cast_ray(@math.Vec3::new(4.0, 0.0, 5.0), @math.Vec3::new(0.0, 0.0, -1.0))
      .unwrap()
    inspect(hit.entity == child, content="true")
  })
}

///|
test "query filter groups and contact force events work in 3d" {
  with_physics3d_test_world(fn() raise {
    let filtered = @entity.Entity::new()
    @transform.transforms().set(
      filtered,
      @transform.Transform::from_xyz(5.0, 0.0, 0.0),
    )
    rigid_bodies().set(filtered, Fixed)
    colliders().set(filtered, Collider::ball(0.5))
    collision_groups().set(filtered, CollisionGroups::new(0x1, 0xFFFF_FFFF))

    let excluded = @entity.Entity::new()
    @transform.transforms().set(
      excluded,
      @transform.Transform::from_xyz(2.0, 0.0, 0.0),
    )
    rigid_bodies().set(excluded, Fixed)
    colliders().set(excluded, Collider::ball(0.5))
    collision_groups().set(excluded, CollisionGroups::new(0x2, 0xFFFF_FFFF))

    step_physics(1)

    let hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis(), query_filter={
        ..QueryFilter::all(),
        groups: Some(CollisionGroups::new(0x1, 0x1)),
      })
      .unwrap()
    inspect(hit.entity == filtered, content="true")

    physics3d_world().event_handler.push_contact_force_event(
      @collision.ContactForceEvent3D::new(
        @collision.ColliderHandle3D::from_raw_parts(1, 0),
        @collision.ColliderHandle3D::from_raw_parts(2, 0),
        @math.Vec3::new(0.0, 3.0, 0.0).to_rapier(),
        3.0,
        @math.Vec3::new(0.0, 1.0, 0.0).to_rapier(),
        2.0,
      ),
    )
    collider_entities_by_key().set("1:0", filtered)
    collider_entities_by_key().set("2:0", excluded)
    collect_events()
    let reader : @event.EventReader[ContactForceEvent] = @event.EventReader::new()
    let events = reader.read(contact_force_event_bus)
    inspect(events.length(), content="1")
    inspect(events[0].entity_a == filtered, content="true")
    inspect(events[0].entity_b == excluded, content="true")
  })
}

///|
test "rapier context project_point and intersections_with_shape work" {
  with_physics3d_test_world(fn() raise {
    let collider_entity = @entity.Entity::new()
    @transform.transforms().set(
      collider_entity,
      @transform.Transform::from_xyz(1.0, 0.0, 0.0),
    )
    colliders().set(collider_entity, Collider::ball(0.5))

    step_physics(1)

    let projection = context()
      .project_point(@math.Vec3::new(1.3, 0.0, 0.0))
      .unwrap()
    inspect(projection.entity == collider_entity, content="true")
    let intersections = context().intersections_with_shape(
      Collider::ball(0.25),
      @math.Vec3::new(1.1, 0.0, 0.0),
    )
    inspect(intersections.length(), content="1")
    inspect(intersections[0] == collider_entity, content="true")
  })
}

///|
test "impulse joint creates a rapier handle" {
  with_physics3d_test_world(fn() raise {
    let parent = @entity.Entity::new()
    @transform.transforms().set(
      parent,
      @transform.Transform::from_xyz(0.0, 0.0, 0.0),
    )
    rigid_bodies().set(parent, Fixed)
    colliders().set(parent, Collider::ball(0.5))

    let child = @entity.Entity::new()
    @transform.transforms().set(
      child,
      @transform.Transform::from_xyz(0.0, 1.0, 0.0),
    )
    rigid_bodies().set(child, Dynamic)
    colliders().set(child, Collider::ball(0.5))
    impulse_joints().set(child, {
      parent,
      data: Fixed(FixedJoint::new()),
      contacts_enabled: false,
    })

    step_physics(1)

    inspect(impulse_joint_handle(child) is Some(_), content="true")
  })
}

///|
test "impulse joint contacts_enabled disables body contact pairs" {
  with_physics3d_test_world(fn() raise {
    let parent = @entity.Entity::new()
    rigid_bodies().set(parent, Fixed)
    colliders().set(parent, Collider::ball(0.5))

    let child = @entity.Entity::new()
    @transform.transforms().set(
      child,
      @transform.Transform::from_xyz(0.0, 1.0, 0.0),
    )
    rigid_bodies().set(child, Dynamic)
    colliders().set(child, Collider::ball(0.5))
    impulse_joints().set(child, {
      parent,
      data: Fixed(FixedJoint::new()),
      contacts_enabled: false,
    })

    step_physics(1)

    inspect(
      physics3d_world().impulse_joints.disabled_contact_pairs().length(),
      content="1",
    )
  })
}

///|
test "multibody joint creates a rapier handle" {
  with_physics3d_test_world(fn() raise {
    let parent = @entity.Entity::new()
    rigid_bodies().set(parent, Fixed)
    colliders().set(parent, Collider::ball(0.5))

    let child = @entity.Entity::new()
    @transform.transforms().set(
      child,
      @transform.Transform::from_xyz(0.0, 1.0, 0.0),
    )
    rigid_bodies().set(child, Dynamic)
    colliders().set(child, Collider::ball(0.5))
    multibody_joints().set(child, {
      parent,
      data: Revolute(RevoluteJoint::new(@math.Vec3::z_axis())),
      contacts_enabled: true,
    })

    step_physics(1)

    inspect(multibody_joint_handle(child) is Some(_), content="true")
  })
}

///|
test "dominance is forwarded to rapier rigid body" {
  with_physics3d_test_world(fn() raise {
    let body_entity = @entity.Entity::new()
    rigid_bodies().set(body_entity, Dynamic)
    dominances().set(body_entity, Dominance::new(5))

    step_physics(1)

    let body = physics3d_world().bodies
      .get(rigid_body_handle(body_entity).unwrap())
      .unwrap()
    inspect(body.dominance_group(), content="5")
  })
}

///|
test "solver groups are forwarded to rapier collider" {
  with_physics3d_test_world(fn() raise {
    let collider_entity = @entity.Entity::new()
    colliders().set(collider_entity, Collider::ball(0.5))
    solver_groups().set(collider_entity, SolverGroups::new(0x2, 0x4))

    step_physics(1)

    let collider = physics3d_world().colliders
      .get(collider_handle(collider_entity).unwrap())
      .unwrap()
    let groups = collider.solver_groups()
    inspect(groups.memberships().bits(), content="2")
    inspect(groups.filter().bits(), content="4")
  })
}

///|
test "kinematic character controller writes output and clears consumed translation" {
  with_physics3d_test_world(fn() raise {
    let floor = @entity.Entity::new()
    @transform.transforms().set(
      floor,
      @transform.Transform::from_xyz(0.0, -1.0, 0.0),
    )
    colliders().set(floor, Collider::cuboid(@math.Vec3::new(4.0, 0.5, 4.0)))

    let actor = @entity.Entity::new()
    @transform.transforms().set(
      actor,
      @transform.Transform::from_xyz(0.0, 0.5, 0.0),
    )
    rigid_bodies().set(actor, KinematicPositionBased)
    colliders().set(actor, Collider::ball(0.5))
    kinematic_character_controllers().set(actor, {
      ..KinematicCharacterController::default(),
      translation: Some(@math.Vec3::new(0.0, -1.0, 0.0)),
    })

    step_physics(1)

    let output = kinematic_character_controller_outputs().get(actor).unwrap()
    inspect(output.desired_translation.y < 0.0, content="true")
    inspect(
      kinematic_character_controller_collisions().get(actor).unwrap().collisions.length() >=
      0,
      content="true",
    )
    inspect(
      kinematic_character_controllers().get(actor).unwrap().translation is None,
      content="true",
    )
  })
}

///|
test "finite guards reject nan and extreme values" {
  let nan = 0.0 / 0.0
  inspect(finite_scalar(0.0), content="true")
  inspect(finite_scalar(nan), content="false")
  inspect(finite_scalar(1_000_001.0), content="false")
  inspect(finite_vec3(@math.Vec3::new(1.0, 2.0, 3.0)), content="true")
  inspect(finite_vec3(@math.Vec3::new(nan, 0.0, 0.0)), content="false")
}

///|
test "sync_rapier_to_components ignores invalid rapier transform writeback" {
  with_physics3d_test_world(fn() raise {
    let body_entity = @entity.Entity::new()
    @transform.transforms().set(
      body_entity,
      @transform.Transform::from_xyz(1.0, 2.0, 3.0),
    )
    rigid_bodies().set(body_entity, Dynamic)
    colliders().set(body_entity, Collider::ball(0.5))

    step_physics(1)
    let before = @transform.transforms().get(body_entity).unwrap().translation

    let handle = rigid_body_handle(body_entity).unwrap()
    let body = physics3d_world().bodies.get_mut(handle).unwrap()
    body.set_translation(@math.Vec3::new(0.0 / 0.0, 0.0, 0.0).to_rapier())

    sync_rapier_to_components()

    let transform = @transform.transforms().get(body_entity).unwrap()
    inspect(transform.translation, content="\{before}")
  })
}
