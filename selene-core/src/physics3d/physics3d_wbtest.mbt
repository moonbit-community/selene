///|
fn with_physics3d_test_world(action : (@ecs.World) -> Unit raise) -> Unit raise {
  let previous_world = @ecs.current_world()
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action(world)
  match previous_world {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  }
}

///|
fn step_physics(world~ : @ecs.World, iterations : Int32) -> Unit {
  for _ in 0..<iterations {
    physics_step_system(world~, 1.0 / 60.0)
  }
}

///|
fn near(actual : Double, expected : Double, tolerance : Double) -> Bool {
  let delta = actual - expected
  delta < tolerance && delta > -tolerance
}

///|
test "same-entity collider uses body world transform only once" {
  with_physics3d_test_world(fn(world) raise {
    let body_draft = @ecs.require_current_world().spawn_draft()
    body_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(4.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    body_draft.add((Fixed : RigidBody))
    body_draft.add((Collider::ball(1.0) : Collider))
    let body = body_draft.spawn()

    step_physics(world~, 1)

    let hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis())
      .unwrap()
    inspect(hit.entity == body, content="true")
    inspect(hit.toi >= 2.9 && hit.toi <= 3.1, content="true")
  })
}

///|
test "child collider stays relative to its rigid-body ancestor" {
  with_physics3d_test_world(fn(world) raise {
    let body_draft = @ecs.require_current_world().spawn_draft()
    body_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(4.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    body_draft.add((Fixed : RigidBody))
    let body = body_draft.spawn()

    let child_draft = @ecs.require_current_world().spawn_draft()
    child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 2.0)) :
        @transform.Spatial),
    )
    child_draft.add((Collider::ball(0.5) : Collider))
    let child = child_draft.spawn(parent=body)

    step_physics(world~, 1)

    let collider = physics3d_world().colliders
      .get(collider_handle(child).unwrap())
      .unwrap()
    let local_translation = vec3_from_rapier(
      collider.local_position().translation,
    )
    inspect(
      local_translation.x == 0.0 &&
      local_translation.y == 0.0 &&
      local_translation.z == 2.0,
      content="true",
    )
    let hit = context()
      .cast_ray(Vec3(4.0, 0.0, 5.0), Vec3(0.0, 0.0, -1.0))
      .unwrap()
    inspect(hit.entity == child, content="true")
  })
}

///|
test "query filter groups and contact force events work in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let filtered_draft = @ecs.require_current_world().spawn_draft()
    filtered_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    filtered_draft.add((Fixed : RigidBody))
    filtered_draft.add((Collider::ball(0.5) : Collider))
    filtered_draft.add((CollisionGroups(0x1, 0xFFFF_FFFF) : CollisionGroups))
    let filtered = filtered_draft.spawn()

    let excluded_draft = @ecs.require_current_world().spawn_draft()
    excluded_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    excluded_draft.add((Fixed : RigidBody))
    excluded_draft.add((Collider::ball(0.5) : Collider))
    excluded_draft.add((CollisionGroups(0x2, 0xFFFF_FFFF) : CollisionGroups))
    let excluded = excluded_draft.spawn()

    step_physics(world~, 1)

    let hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis(), query_filter={
        ..QueryFilter::all(),
        groups: Some(CollisionGroups(0x1, 0x1)),
      })
      .unwrap()
    inspect(hit.entity == filtered, content="true")

    physics3d_world().event_handler.push_contact_force_event(
      ContactForceEvent3D(
        @collision.ColliderHandle3D::from_raw_parts(1, 0),
        @collision.ColliderHandle3D::from_raw_parts(2, 0),
        vec3_to_rapier(Vec3(0.0, 3.0, 0.0)),
        3.0,
        vec3_to_rapier(Vec3(0.0, 1.0, 0.0)),
        2.0,
      ),
    )
    collider_entities_by_key().set((1, 0), filtered)
    collider_entities_by_key().set((2, 0), excluded)
    collect_events()
    let reader : @event.EventReader[ContactForceEvent] = EventReader()
    let events = reader.read(contact_force_event_bus)
    inspect(events.length(), content="1")
    inspect(events[0].entity_a == filtered, content="true")
    inspect(events[0].entity_b == excluded, content="true")
  })
}

///|
test "query filter exclude_entity and body filter work in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let dynamic_entity_draft = @ecs.require_current_world().spawn_draft()
    dynamic_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    dynamic_entity_draft.add((Dynamic : RigidBody))
    dynamic_entity_draft.add((Collider::ball(0.5) : Collider))
    let dynamic_entity = dynamic_entity_draft.spawn()

    let fixed_entity_draft = @ecs.require_current_world().spawn_draft()
    fixed_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    fixed_entity_draft.add((Fixed : RigidBody))
    fixed_entity_draft.add((Collider::ball(0.5) : Collider))
    let fixed_entity = fixed_entity_draft.spawn()

    step_physics(world~, 1)

    let all_hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis())
      .unwrap()
    inspect(all_hit.entity == dynamic_entity, content="true")

    let fixed_hit = context()
      .cast_ray(
        @math.Vec3::zero(),
        @math.Vec3::x_axis(),
        query_filter=QueryFilter::only_fixed(),
      )
      .unwrap()
    inspect(fixed_hit.entity == fixed_entity, content="true")

    let excluded_hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis(), query_filter={
        ..QueryFilter::all(),
        exclude_entity: Some(dynamic_entity),
      })
      .unwrap()
    inspect(excluded_hit.entity == fixed_entity, content="true")
  })
}

///|
test "query filter exclude_sensors and exclude_solids work in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let sensor_entity_draft = @ecs.require_current_world().spawn_draft()
    sensor_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    sensor_entity_draft.add((Collider::ball(0.5) : Collider))
    sensor_entity_draft.add((Sensor::{ } : Sensor))
    let sensor_entity = sensor_entity_draft.spawn()

    let solid_entity_draft = @ecs.require_current_world().spawn_draft()
    solid_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    solid_entity_draft.add((Collider::ball(0.5) : Collider))
    let solid_entity = solid_entity_draft.spawn()

    step_physics(world~, 1)

    let all_hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis())
      .unwrap()
    inspect(all_hit.entity == sensor_entity, content="true")

    let no_sensor_hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis(), query_filter={
        ..QueryFilter::all(),
        exclude_sensors: true,
      })
      .unwrap()
    inspect(no_sensor_hit.entity == solid_entity, content="true")

    let no_solid_hit = context()
      .cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis(), query_filter={
        ..QueryFilter::all(),
        exclude_solids: true,
      })
      .unwrap()
    inspect(no_solid_hit.entity == sensor_entity, content="true")
  })
}

///|
test "cast_shape respects body filter and exclude_entity in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let dynamic_entity_draft = @ecs.require_current_world().spawn_draft()
    dynamic_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    dynamic_entity_draft.add((Dynamic : RigidBody))
    dynamic_entity_draft.add((Collider::ball(0.5) : Collider))
    let dynamic_entity = dynamic_entity_draft.spawn()

    let fixed_entity_draft = @ecs.require_current_world().spawn_draft()
    fixed_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    fixed_entity_draft.add((Fixed : RigidBody))
    fixed_entity_draft.add((Collider::ball(0.5) : Collider))
    let fixed_entity = fixed_entity_draft.spawn()

    step_physics(world~, 1)

    let first_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
      )
      .unwrap()
    inspect(first_hit.entity == dynamic_entity, content="true")

    let fixed_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
        query_filter=QueryFilter::only_fixed(),
      )
      .unwrap()
    inspect(fixed_hit.entity == fixed_entity, content="true")

    let excluded_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
        query_filter={
          ..QueryFilter::all(),
          exclude_entity: Some(dynamic_entity),
        },
      )
      .unwrap()
    inspect(excluded_hit.entity == fixed_entity, content="true")
  })
}

///|
test "cast_shape respects exclude_sensors and exclude_solids in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let sensor_entity_draft = @ecs.require_current_world().spawn_draft()
    sensor_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    sensor_entity_draft.add((Collider::ball(0.5) : Collider))
    sensor_entity_draft.add((Sensor::{ } : Sensor))
    let sensor_entity = sensor_entity_draft.spawn()

    let solid_entity_draft = @ecs.require_current_world().spawn_draft()
    solid_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    solid_entity_draft.add((Collider::ball(0.5) : Collider))
    let solid_entity = solid_entity_draft.spawn()

    step_physics(world~, 1)

    let all_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
      )
      .unwrap()
    inspect(all_hit.entity == sensor_entity, content="true")

    let no_sensor_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
        query_filter={ ..QueryFilter::all(), exclude_sensors: true, },
      )
      .unwrap()
    inspect(no_sensor_hit.entity == solid_entity, content="true")

    let no_solid_hit = context()
      .cast_shape(
        Collider::ball(0.25),
        @math.Vec3::zero(),
        direction=@math.Vec3::x_axis(),
        query_filter={ ..QueryFilter::all(), exclude_solids: true, },
      )
      .unwrap()
    inspect(no_solid_hit.entity == sensor_entity, content="true")
  })
}

///|
test "query filter only_kinematic targets kinematic bodies in 3d" {
  with_physics3d_test_world(fn(world) raise {
    let kinematic_entity_draft = @ecs.require_current_world().spawn_draft()
    kinematic_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    kinematic_entity_draft.add((KinematicPositionBased : RigidBody))
    kinematic_entity_draft.add((Collider::ball(0.5) : Collider))
    let kinematic_entity = kinematic_entity_draft.spawn()

    let dynamic_entity_draft = @ecs.require_current_world().spawn_draft()
    dynamic_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(5.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    dynamic_entity_draft.add((Dynamic : RigidBody))
    dynamic_entity_draft.add((Collider::ball(0.5) : Collider))
    let dynamic_entity = dynamic_entity_draft.spawn()

    step_physics(world~, 1)

    let kinematic_hit = context()
      .cast_ray(
        @math.Vec3::zero(),
        @math.Vec3::x_axis(),
        query_filter=QueryFilter::only_kinematic(),
      )
      .unwrap()
    inspect(kinematic_hit.entity == kinematic_entity, content="true")

    let dynamic_hit = context()
      .cast_ray(
        @math.Vec3::zero(),
        @math.Vec3::x_axis(),
        query_filter=QueryFilter::only_dynamic(),
      )
      .unwrap()
    inspect(dynamic_hit.entity == dynamic_entity, content="true")
  })
}

///|
test "collision and intersection events map to selene event buses" {
  with_physics3d_test_world(fn(world) raise {
    let sensor_entity_draft = @ecs.require_current_world().spawn_draft()
    sensor_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(10.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    sensor_entity_draft.add((Collider::ball(0.5) : Collider))
    sensor_entity_draft.add((Sensor::{ } : Sensor))
    let sensor_entity = sensor_entity_draft.spawn()

    let other_entity_draft = @ecs.require_current_world().spawn_draft()
    other_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(20.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    other_entity_draft.add((Collider::ball(0.5) : Collider))
    let other_entity = other_entity_draft.spawn()

    step_physics(world~, 1)

    let sensor_handle = collider_handle(sensor_entity).unwrap()
    let other_handle = collider_handle(other_entity).unwrap()
    let mut flags = @collision.CollisionEventFlags::empty()
    flags = flags.insert(@collision.CollisionEventFlags::sensor())
    physics3d_world().event_handler.push_collision_event(
      Started(sensor_handle, other_handle, flags),
    )
    physics3d_world().event_handler.push_intersection_event(
      IntersectionEvent3D(sensor_handle, other_handle, true),
    )
    collect_events()

    let collision_reader : @event.EventReader[CollisionEvent] = EventReader()
    let collisions = collision_reader.read(collision_event_bus)
    inspect(collisions.length(), content="1")
    inspect(collisions[0].entity_a == sensor_entity, content="true")
    inspect(collisions[0].entity_b == other_entity, content="true")
    inspect(collisions[0].sensor, content="true")
    inspect(collisions[0].started, content="true")

    let sensor_reader : @event.EventReader[SensorEvent] = EventReader()
    let sensor_events = sensor_reader.read(sensor_event_bus)
    inspect(sensor_events.length(), content="2")
    inspect(sensor_events[0].sensor == sensor_entity, content="true")
    inspect(sensor_events[0].other == other_entity, content="true")
    inspect(sensor_events[0].entered, content="true")
    inspect(sensor_events[1].sensor == sensor_entity, content="true")
    inspect(sensor_events[1].other == other_entity, content="true")
    inspect(sensor_events[1].entered, content="true")
  })
}

///|
test "rapier context project_point and intersections_with_shape work" {
  with_physics3d_test_world(fn(world) raise {
    let collider_entity_draft = @ecs.require_current_world().spawn_draft()
    collider_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(1.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    collider_entity_draft.add((Collider::ball(0.5) : Collider))
    let collider_entity = collider_entity_draft.spawn()

    step_physics(world~, 1)

    let projection = context().project_point(Vec3(1.3, 0.0, 0.0)).unwrap()
    inspect(projection.entity == collider_entity, content="true")
    let intersections = context().intersections_with_shape(
      Collider::ball(0.25),
      Vec3(1.1, 0.0, 0.0),
    )
    inspect(intersections.length(), content="1")
    inspect(intersections[0] == collider_entity, content="true")
  })
}

///|
test "impulse joint creates a rapier handle" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let child_draft = @ecs.require_current_world().spawn_draft()
    child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 1.0, 0.0)) :
        @transform.Spatial),
    )
    child_draft.add((Dynamic : RigidBody))
    child_draft.add((Collider::ball(0.5) : Collider))
    child_draft.add(
      (
        { parent, data: Fixed(FixedJoint()), contacts_enabled: false, } :
        ImpulseJoint),
    )
    let child = child_draft.spawn()

    step_physics(world~, 1)

    inspect(impulse_joint_handle(child) is Some(_), content="true")
  })
}

///|
test "impulse joint contacts_enabled disables body contact pairs" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let child_draft = @ecs.require_current_world().spawn_draft()
    child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 1.0, 0.0)) :
        @transform.Spatial),
    )
    child_draft.add((Dynamic : RigidBody))
    child_draft.add((Collider::ball(0.5) : Collider))
    child_draft.add(
      (
        { parent, data: Fixed(FixedJoint()), contacts_enabled: false, } :
        ImpulseJoint),
    )
    ignore(child_draft.spawn())

    step_physics(world~, 1)

    inspect(
      physics3d_world().impulse_joints.disabled_contact_pairs().length(),
      content="1",
    )
  })
}

///|
test "impulse rope and spring contacts_enabled disable body contact pairs" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let rope_child_draft = @ecs.require_current_world().spawn_draft()
    rope_child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 1.0, 0.0)) :
        @transform.Spatial),
    )
    rope_child_draft.add((Dynamic : RigidBody))
    rope_child_draft.add((Collider::ball(0.5) : Collider))
    rope_child_draft.add(
      (
        { parent, data: Rope(RopeJoint(2.0)), contacts_enabled: false, } :
        ImpulseJoint),
    )
    ignore(rope_child_draft.spawn())

    let spring_child_draft = @ecs.require_current_world().spawn_draft()
    spring_child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 2.0, 0.0)) :
        @transform.Spatial),
    )
    spring_child_draft.add((Dynamic : RigidBody))
    spring_child_draft.add((Collider::ball(0.5) : Collider))
    spring_child_draft.add(
      (
        {
          parent,
          data: Spring(SpringJoint(1.0, 8.0, 0.5)),
          contacts_enabled: false,
        } : ImpulseJoint),
    )
    ignore(spring_child_draft.spawn())

    step_physics(world~, 1)

    inspect(
      physics3d_world().impulse_joints.disabled_contact_pairs().length(),
      content="2",
    )
  })
}

///|
test "multibody joint creates a rapier handle" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let child_draft = @ecs.require_current_world().spawn_draft()
    child_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 1.0, 0.0)) :
        @transform.Spatial),
    )
    child_draft.add((Dynamic : RigidBody))
    child_draft.add((Collider::ball(0.5) : Collider))
    child_draft.add(
      (
        {
          parent,
          data: Revolute(RevoluteJoint(@math.Vec3::z_axis())),
          contacts_enabled: true,
        } : MultibodyJoint),
    )
    let child = child_draft.spawn()

    step_physics(world~, 1)

    inspect(multibody_joint_handle(child) is Some(_), content="true")
  })
}

///|
test "impulse joints expose generic handles for all 3d joint variants" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let spawn_child = fn(y : Double, joint : Joint) -> @ecs.Entity {
      let child_draft = @ecs.require_current_world().spawn_draft()
      child_draft.add(
        (
          Spatial(@transform.Transform::from_xyz(0.0, y, 0.0)) :
          @transform.Spatial),
      )
      child_draft.add((Dynamic : RigidBody))
      child_draft.add((Collider::ball(0.5) : Collider))
      child_draft.add(
        ({ parent, data: joint, contacts_enabled: true, } : ImpulseJoint),
      )
      let child = child_draft.spawn()
      child
    }

    let fixed_child = spawn_child(1.0, Fixed(FixedJoint()))
    let revolute_child = spawn_child(
      2.0,
      Revolute(RevoluteJoint(@math.Vec3::z_axis())),
    )
    let prismatic_child = spawn_child(
      3.0,
      Prismatic(PrismaticJoint(@math.Vec3::x_axis())),
    )
    let rope_child = spawn_child(4.0, Rope(RopeJoint(2.0)))
    let spring_child = spawn_child(5.0, Spring(SpringJoint(1.0, 8.0, 0.5)))
    let spherical_child = spawn_child(6.0, Spherical(SphericalJoint()))

    step_physics(world~, 1)

    inspect(impulse_joint_handle(fixed_child) is Some(_), content="true")
    inspect(impulse_joint_handle(revolute_child) is Some(_), content="true")
    inspect(impulse_joint_handle(prismatic_child) is Some(_), content="true")
    inspect(impulse_joint_handle(spring_child) is Some(_), content="true")
    inspect(impulse_joint_handle(spherical_child) is Some(_), content="true")
    inspect(impulse_joint_handle(rope_child) is Some(_), content="true")
    inspect(
      physics3d_world().rope_joints.interaction_pairs().length(),
      content="0",
    )
  })
}

///|
test "multibody joints expose generic handles for all 3d joint variants" {
  with_physics3d_test_world(fn(world) raise {
    let parent_draft = @ecs.require_current_world().spawn_draft()
    parent_draft.add((Fixed : RigidBody))
    parent_draft.add((Collider::ball(0.5) : Collider))
    let parent = parent_draft.spawn()

    let spawn_child = fn(y : Double, joint : Joint) -> @ecs.Entity {
      let child_draft = @ecs.require_current_world().spawn_draft()
      child_draft.add(
        (
          Spatial(@transform.Transform::from_xyz(0.0, y, 0.0)) :
          @transform.Spatial),
      )
      child_draft.add((Dynamic : RigidBody))
      child_draft.add((Collider::ball(0.5) : Collider))
      child_draft.add(
        ({ parent, data: joint, contacts_enabled: true, } : MultibodyJoint),
      )
      let child = child_draft.spawn()
      child
    }

    let fixed_child = spawn_child(1.0, Fixed(FixedJoint()))
    let revolute_child = spawn_child(
      2.0,
      Revolute(RevoluteJoint(@math.Vec3::z_axis())),
    )
    let prismatic_child = spawn_child(
      3.0,
      Prismatic(PrismaticJoint(@math.Vec3::x_axis())),
    )
    let rope_child = spawn_child(4.0, Rope(RopeJoint(2.0)))
    let spring_child = spawn_child(5.0, Spring(SpringJoint(1.0, 8.0, 0.5)))
    let spherical_child = spawn_child(6.0, Spherical(SphericalJoint()))

    step_physics(world~, 1)

    inspect(multibody_joint_handle(fixed_child) is Some(_), content="true")
    inspect(multibody_joint_handle(revolute_child) is Some(_), content="true")
    inspect(multibody_joint_handle(prismatic_child) is Some(_), content="true")
    inspect(multibody_joint_handle(spherical_child) is Some(_), content="true")
    inspect(multibody_joint_handle(rope_child) is Some(_), content="true")
    inspect(multibody_joint_handle(spring_child) is Some(_), content="true")
    inspect(
      physics3d_world().rope_joints.interaction_pairs().length(),
      content="0",
    )
  })
}

///|
test "revolute joint forwards limits motor model and softness" {
  let expected_softness = @dynamics.SpringCoefficients::SpringCoefficients(
    0.35F, 6.0F,
  )
  let joint = {
    ..RevoluteJoint(@math.Vec3::z_axis()),
    limits: Some((-0.5, 0.75)),
    motor_model: ForceBased,
    motor_position: Some((0.2, 4.0, 0.7)),
    motor_velocity: Some((1.3, 0.8)),
    max_force: Some(25.0),
    softness: Some(expected_softness),
  }
  let generic_joint = revolute_joint_to_generic(joint)
  inspect(
    match generic_joint.limits_axis(AngX) {
      Some(limits) =>
        near(limits.min().to_double(), -0.5, 0.0001) &&
        near(limits.max().to_double(), 0.75, 0.0001)
      None => false
    },
    content="true",
  )
  inspect(
    match generic_joint.motor_model(AngX) {
      Some(ForceBased) => true
      _ => false
    },
    content="true",
  )
  inspect(generic_joint.motor(AngX) is Some(_), content="true")
  let actual_softness = generic_joint.softness()
  inspect(
    near(
      actual_softness.cfm_coeff(1.0F).to_double(),
      expected_softness.cfm_coeff(1.0F).to_double(),
      0.000001,
    ),
    content="true",
  )
  inspect(
    near(
      actual_softness.erp(1.0F).to_double(),
      expected_softness.erp(1.0F).to_double(),
      0.000001,
    ),
    content="true",
  )
  // The current 3d-real backend preserves limits and motor state, but not every generic-joint
  // metadata field. Keep explicit round-trip coverage for what is currently retained.
  let roundtrip_joint = revolute_joint_to_rapier(joint).to_generic_joint()
  inspect(
    match roundtrip_joint.limits_axis(AngX) {
      Some(limits) =>
        near(limits.min().to_double(), -0.5, 0.0001) &&
        near(limits.max().to_double(), 0.75, 0.0001)
      None => false
    },
    content="true",
  )
  inspect(roundtrip_joint.motor(AngX) is Some(_), content="true")
}

///|
test "prismatic joint forwards limits and motor state" {
  let joint = {
    ..PrismaticJoint(@math.Vec3::x_axis()),
    limits: Some((-2.0, 3.0)),
    motor_position: Some((0.4, 2.0, 0.3)),
    motor_velocity: Some((1.5, 0.2)),
    max_force: Some(9.0),
  }
  let generic_joint = prismatic_joint_to_rapier(joint).to_generic_joint()
  inspect(
    match generic_joint.limits_axis(LinX) {
      Some(limits) =>
        near(limits.min().to_double(), -2.0, 0.0001) &&
        near(limits.max().to_double(), 3.0, 0.0001)
      None => false
    },
    content="true",
  )
  inspect(generic_joint.motor(LinX) is Some(_), content="true")
}

///|
test "dominance is forwarded to rapier rigid body" {
  with_physics3d_test_world(fn(world) raise {
    let body_entity_draft = @ecs.require_current_world().spawn_draft()
    body_entity_draft.add((Dynamic : RigidBody))
    body_entity_draft.add((Dominance(5) : Dominance))
    let body_entity = body_entity_draft.spawn()

    step_physics(world~, 1)

    let body = physics3d_world().bodies
      .get(rigid_body_handle(body_entity).unwrap())
      .unwrap()
    inspect(body.dominance_group(), content="5")
  })
}

///|
test "solver groups are forwarded to rapier collider" {
  with_physics3d_test_world(fn(world) raise {
    let collider_entity_draft = @ecs.require_current_world().spawn_draft()
    collider_entity_draft.add((Collider::ball(0.5) : Collider))
    collider_entity_draft.add((SolverGroups(0x2, 0x4) : SolverGroups))
    let collider_entity = collider_entity_draft.spawn()

    step_physics(world~, 1)

    let collider = physics3d_world().colliders
      .get(collider_handle(collider_entity).unwrap())
      .unwrap()
    let groups = collider.solver_groups()
    inspect(groups.memberships().bits(), content="2")
    inspect(groups.filter().bits(), content="4")
  })
}

///|
test "contact force threshold toggles contact-force active events" {
  with_physics3d_test_world(fn(world) raise {
    let default_entity = world.spawn1(Collider::ball(0.5))

    let low_threshold_entity_draft = @ecs.require_current_world().spawn_draft()
    low_threshold_entity_draft.add((Collider::ball(0.5) : Collider))
    low_threshold_entity_draft.add(
      (ContactForceEventThreshold(0.5) : ContactForceEventThreshold),
    )
    let low_threshold_entity = low_threshold_entity_draft.spawn()

    step_physics(world~, 1)

    let default_collider = physics3d_world().colliders
      .get(collider_handle(default_entity).unwrap())
      .unwrap()
    inspect(
      !default_collider
      .active_events()
      .contains(@collision.ActiveEvents::contact_force_events()),
      content="true",
    )
    inspect(
      default_collider.contact_force_event_threshold() > 1.0e29,
      content="true",
    )

    let low_collider = physics3d_world().colliders
      .get(collider_handle(low_threshold_entity).unwrap())
      .unwrap()
    inspect(
      low_collider
      .active_events()
      .contains(@collision.ActiveEvents::contact_force_events()),
      content="true",
    )
    inspect(
      low_collider.contact_force_event_threshold() == 0.5F,
      content="true",
    )
  })
}

///|
test "kinematic character controller writes output and clears consumed translation" {
  with_physics3d_test_world(fn(world) raise {
    let floor_draft = @ecs.require_current_world().spawn_draft()
    floor_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, -1.0, 0.0)) :
        @transform.Spatial),
    )
    floor_draft.add((Collider::cuboid(Vec3(4.0, 0.5, 4.0)) : Collider))
    ignore(floor_draft.spawn())

    let actor_draft = @ecs.require_current_world().spawn_draft()
    actor_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.5, 0.0)) :
        @transform.Spatial),
    )
    actor_draft.add((KinematicPositionBased : RigidBody))
    actor_draft.add((Collider::ball(0.5) : Collider))
    actor_draft.add(
      (
        {
          ..KinematicCharacterController(),
          translation: Some(Vec3(0.0, -1.0, 0.0)),
        } : KinematicCharacterController),
    )
    let actor = actor_draft.spawn()

    step_physics(world~, 1)

    let output = kinematic_character_controller_output(actor).unwrap()
    inspect(output.desired_translation.y < 0.0, content="true")
    inspect(
      kinematic_character_controller_collisions(actor).unwrap().collisions.length() >=
      0,
      content="true",
    )
    inspect(
      (world.query() : @ecs.Query[KinematicCharacterController])
      .get(actor)
      .unwrap().translation
      is None,
      content="true",
    )
  })
}

///|
test "character controller options are forwarded to rapier controller" {
  let autostep = CharacterAutostep::CharacterAutostep(
    CharacterLength::absolute(0.6),
    CharacterLength::absolute(1.2),
  ).with_include_dynamic_bodies(false)
  let controller = {
    ..KinematicCharacterController(),
    offset: CharacterLength::absolute(0.02),
    slide: false,
    autostep: Some(autostep),
    max_slope_climb_angle: 1.1,
    min_slope_slide_angle: 0.4,
    snap_to_ground: Some(CharacterLength::absolute(0.35)),
    normal_nudge_factor: 0.015,
    up: Vec3(0.0, 0.0, 1.0),
  }
  let rapier_controller = controller_to_rapier(controller)
  inspect(rapier_controller.slide, content="false")
  inspect(
    match rapier_controller.offset {
      Absolute(value) => value.to_double() > 0.019 && value.to_double() < 0.021
      _ => false
    },
    content="true",
  )
  inspect(
    match rapier_controller.autostep {
      Some(actual_autostep) => {
        let max_height_ok = match actual_autostep.max_height() {
          Absolute(value) =>
            value.to_double() > 0.59 && value.to_double() < 0.61
          _ => false
        }
        let min_width_ok = match actual_autostep.min_width() {
          Absolute(value) =>
            value.to_double() > 1.19 && value.to_double() < 1.21
          _ => false
        }
        actual_autostep.include_dynamic_bodies() ==
        autostep.include_dynamic_bodies() &&
        max_height_ok &&
        min_width_ok
      }
      None => false
    },
    content="true",
  )
  inspect(
    match rapier_controller.snap_to_ground {
      Some(Absolute(value)) =>
        value.to_double() > 0.34 && value.to_double() < 0.36
      _ => false
    },
    content="true",
  )
  inspect(
    rapier_controller.max_slope_climb_angle.to_double() > 1.09 &&
    rapier_controller.max_slope_climb_angle.to_double() < 1.11,
    content="true",
  )
  inspect(
    rapier_controller.min_slope_slide_angle.to_double() > 0.39 &&
    rapier_controller.min_slope_slide_angle.to_double() < 0.41,
    content="true",
  )
  inspect(
    rapier_controller.normal_nudge_factor.to_double() > 0.014 &&
    rapier_controller.normal_nudge_factor.to_double() < 0.016,
    content="true",
  )
  let up = vec3_from_rapier(rapier_controller.up)
  inspect(up.x == 0.0 && up.y == 0.0 && up.z == 1.0, content="true")
}

///|
test "collider3d debug wire builds expected primitive edges" {
  inspect(
    collider_wire_segments(Collider::cuboid(Vec3(1.0, 2.0, 3.0))).length(),
    content="12",
  )
  inspect(
    collider_wire_segments(
      Collider::trimesh(
        [Vec3(0.0, 0.0, 0.0), Vec3(1.0, 0.0, 0.0), Vec3(0.0, 1.0, 0.0)],
        [(0, 1, 2)],
      ),
    ).length(),
    content="3",
  )
  inspect(
    collider_wire_segments(
      Collider::heightfield([0.0, 1.0, 2.0, 3.0], 2, 2, @math.Vec3::one()),
    ).length(),
    content="4",
  )
}

///|
test "collider3d debug wire supports every collider shape" {
  let shapes = [
    Collider::cuboid(Vec3(1.0, 1.0, 1.0)),
    Collider::ball(1.0),
    Collider::capsule_x(1.0, 0.25),
    Collider::capsule_y(1.0, 0.25),
    Collider::capsule_z(1.0, 0.25),
    Collider::cylinder(1.0, 0.5),
    Collider::cone(1.0, 0.5),
    Collider::round_cylinder(1.0, 0.5, 0.1),
    Collider::halfspace(@math.Vec3::y_axis()),
    Collider::convex_hull([Vec3(-1.0, -1.0, -1.0), Vec3(1.0, 1.0, 1.0)]),
    Collider::trimesh(
      [Vec3(0.0, 0.0, 0.0), Vec3(1.0, 0.0, 0.0), Vec3(0.0, 1.0, 0.0)],
      [(0, 1, 2)],
    ),
    Collider::heightfield([0.0, 1.0, 2.0, 3.0], 2, 2, @math.Vec3::one()),
  ]
  let mut supported = true
  for shape in shapes {
    supported = supported && collider_wire_segments(shape).length() > 0
  }
  inspect(supported, content="true")
}

///|
test "collider3d debug color distinguishes body and sensor types" {
  with_physics3d_test_world(fn(world) raise {
    let dynamic_entity = world.spawn1((Dynamic : RigidBody))
    let fixed_entity = world.spawn1((Fixed : RigidBody))
    let kinematic_entity = world.spawn1((KinematicPositionBased : RigidBody))
    let sensor_entity = world.spawn(((Dynamic : RigidBody), Sensor::{ }))
    let disabled_entity = world.spawn(
      ((Dynamic : RigidBody), Collider::ball(1.0)),
    )
    step_physics(world~, 1)
    match collider_handle(disabled_entity) {
      Some(handle) =>
        match physics3d_world().colliders.get(handle) {
          Some(collider) => ignore(collider.set_enabled(false))
          None => ()
        }
      None => ()
    }
    inspect(
      debug_collider_color(world~, dynamic_entity) == debug_dynamic_color(),
      content="true",
    )
    inspect(
      debug_collider_color(world~, fixed_entity) == debug_fixed_color(),
      content="true",
    )
    inspect(
      debug_collider_color(world~, kinematic_entity) == debug_kinematic_color(),
      content="true",
    )
    inspect(
      debug_collider_color(world~, sensor_entity) == debug_sensor_color(),
      content="true",
    )
    inspect(
      debug_collider_color(world~, disabled_entity) == debug_disabled_color(),
      content="true",
    )
  })
}

///|
test "collider3d debug system appends wire lines to render3d pipeline" {
  with_physics3d_test_world(fn(world) raise {
    let entity_draft = @ecs.require_current_world().spawn_draft()
    entity_draft.add((Collider::cuboid(Vec3(1.0, 1.0, 1.0)) : Collider))
    entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    ignore(entity_draft.spawn())
    debug_colliders_system(world~, 0.0)
    let frame = @render3d_pipeline.get_prepared_frame3d()
    inspect(frame.lines.length(), content="12")
    inspect(frame.lines[0].start.x == 1.0, content="true")
  })
}

///|
test "3D physics removes sheared poses and restores valid colliders" {
  with_physics3d_test_world(fn(world) raise {
    let parent = world.spawn1(
      @transform.Spatial(@transform.Transform::identity()),
    )
    let child = world.spawn(
      (
        RigidBody::Fixed,
        Collider::ball(1.0),
        @transform.Spatial(
          @transform.Transform::from_rotation(
            @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), 0.5),
          ).with_translation(Vec3(4.0, 0.0, 0.0)),
        ),
      ),
      parent~,
    )
    let cast = () => {
      context().cast_ray(@math.Vec3::zero(), @math.Vec3::x_axis())
    }
    step_physics(world~, 1)
    assert_eq(cast().unwrap().entity, child)
    @transform.set_local_transform(
      world~,
      parent,
      @transform.Transform::from_scale(Vec3(2.0, 1.0, 1.0)),
    )
    step_physics(world~, 1)
    assert_true(cast() is None)
    @transform.set_local_transform(
      world~,
      parent,
      @transform.Transform::identity(),
    )
    step_physics(world~, 1)
    assert_eq(cast().unwrap().entity, child)
  })
}

///|
test "character contacts expose snapshots instead of mutable output storage" {
  with_physics3d_test_world(fn(world) raise {
    let entity = world.spawn(())
    controller_collisions().set(entity, {
      collisions: [
        {
          entity: None,
          character_translation_applied: @math.Vec3::zero(),
          character_translation_remaining: @math.Vec3::zero(),
          toi: 0.0,
          normal: @math.Vec3::y_axis(),
        },
      ],
    })
    let snapshot = kinematic_character_controller_collisions(entity).unwrap()
    snapshot.collisions.clear()
    assert_eq(
      kinematic_character_controller_collisions(entity).unwrap().collisions.length(),
      1,
    )
    ignore(entity.delete())
    let replacement = world.spawn(())
    assert_true(kinematic_character_controller_collisions(entity) is None)
    assert_true(kinematic_character_controller_collisions(replacement) is None)
  })
}
