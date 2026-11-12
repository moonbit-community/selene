///|
fn with_pickable_test_world(action : (@ecs.World) -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action(world)
  @ecs.set_current_world(previous)
}

///|
fn reset_pickable_test_input() -> Unit {
  @inputs.mouse.pos = @math.Vec2::zero()
  @inputs.mouse.left_button = false
  @inputs.mouse.right_button = false
  @inputs.mouse.middle_button = false
  @inputs.just_pressed_mouse.left_button = false
  @inputs.just_pressed_mouse.right_button = false
  @inputs.just_pressed_mouse.middle_button = false
  @inputs.just_release_mouse.left_button = false
  @inputs.just_release_mouse.right_button = false
  @inputs.just_release_mouse.middle_button = false
  pointer_event_bus.clear()
}

///|
fn spawn_pickable_camera(
  world~ : @ecs.World,
  viewport : @math.Rect,
  order : Int32,
  layers : @visibility.RenderLayers,
) -> @ecs.Entity {
  let camera_entity_draft = world.spawn_draft()
  camera_entity_draft.add(
    (
      Camera(order~, viewport=Some(@camera.CameraViewport::from_rect(viewport))) :
      @camera.Camera),
  )
  camera_entity_draft.add((Camera2d() : @camera.Camera2d))
  camera_entity_draft.add(
    (
      Spatial(
        @transform.Transform::from_xyz(
          viewport.size.x * 0.5,
          viewport.size.y * 0.5,
          0.0,
        ),
      ) : @transform.Spatial),
  )
  camera_entity_draft.add((layers : @visibility.RenderLayers))
  let camera_entity = @ecs_test.spawn_draft(camera_entity_draft)
  camera_entity
}

///|
fn spawn_pickable_shape(
  world~ : @ecs.World,
  position : @math.Vec2,
  shape : CollisionShape,
  layers~ : @visibility.RenderLayers = RenderLayers(),
) -> @ecs.Entity {
  let entity_draft = world.spawn_draft()
  entity_draft.add((Pickable() : Pickable))
  entity_draft.add((shape : CollisionShape))
  entity_draft.add(
    (
      Spatial(@transform.Transform::from_xyz(position.x, position.y, 0.0)) :
      @transform.Spatial),
  )
  entity_draft.add((layers : @visibility.RenderLayers))
  let entity = @ecs_test.spawn_draft(entity_draft)
  entity
}

///|
fn click_left_mouse(position : @math.Vec2) -> Unit {
  @inputs.mouse.pos = position
  @inputs.mouse.left_button = true
  @inputs.just_pressed_mouse.left_button = true
}

///|
test "pickable click respects top-most camera render layers" {
  with_pickable_test_world(fn(world) raise {
    reset_pickable_test_input()
    @window.configure_display(100.0, 100.0, 1.0)
    let viewport : @math.Rect = {
      position: @math.Vec2::zero(),
      size: Vec2(100.0, 100.0),
    }
    ignore(spawn_pickable_camera(world~, viewport, 0, @visibility.layer(0U)))
    ignore(spawn_pickable_camera(world~, viewport, 1, @visibility.layer(1U)))
    let hidden_entity = spawn_pickable_shape(
      world~,
      Vec2(50.0, 50.0),
      Rect(size=Vec2(20.0, 20.0), offset=Vec2(-10.0, -10.0)),
      layers=@visibility.layer(0U),
    )
    let visible_entity = spawn_pickable_shape(
      world~,
      Vec2(50.0, 50.0),
      Rect(size=Vec2(20.0, 20.0), offset=Vec2(-10.0, -10.0)),
      layers=@visibility.layer(1U),
    )
    click_left_mouse(Vec2(50.0, 50.0))

    let reader = @event.EventReader()
    pickable_click_system(world~, 0.0)
    let events = pointer_event_bus.read(reader)
    let visible_id = visible_entity.id()
    let left_events = events.filter(fn(event) { event.button is Left })

    inspect(left_events.length(), content="2")
    inspect(
      left_events.all(fn(event) { event.entity.id() == visible_id }),
      content="true",
    )
    inspect(
      left_events.any(fn(event) { event.entity == hidden_entity }),
      content="false",
    )
  })
}

///|
test "pickable click supports ball shapes" {
  with_pickable_test_world(fn(world) raise {
    reset_pickable_test_input()
    @window.configure_display(100.0, 100.0, 1.0)
    ignore(
      spawn_pickable_camera(
        world~,
        { position: @math.Vec2::zero(), size: Vec2(100.0, 100.0), },
        0,
        @visibility.layer(0U),
      ),
    )
    let entity = spawn_pickable_shape(
      world~,
      Vec2(40.0, 40.0),
      Ball(radius=12.0, offset=@math.Vec2::zero()),
    )
    click_left_mouse(Vec2(48.0, 40.0))

    let reader = @event.EventReader()
    pickable_click_system(world~, 0.0)
    let events = pointer_event_bus.read(reader)
    let left_events = events.filter(fn(event) { event.button is Left })

    inspect(left_events.length(), content="2")
    inspect(
      left_events.all(fn(event) { event.entity == entity }),
      content="true",
    )
  })
}

///|
test "pickable uses the sheared world plane and rejects a collapsed shape" {
  with_pickable_test_world(fn(world) raise {
    let parent = @ecs_test.spawn1(
      world,
      @transform.Spatial(@transform.Transform::from_scale(Vec3(3.0, 1.0, 1.0))),
    )
    let child = @ecs_test.spawn(
      world,
      (
        Pickable(),
        CollisionShape::Rect(size=Vec2(10.0, 10.0), offset=@math.Vec2::zero()),
        @transform.Spatial(
          @transform.Transform::from_rotation(
            @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), 0.7),
          ),
        ),
      ),
      parent~,
    )
    @transform.transform_propagate_system(world~, 0.0)
    let pose = @transform.global_transform(world~, child).unwrap()
    let render = @camera.world_transform_2d(pose)
    let inside = render.transform_point(Vec2(9.0, 1.0))
    let outside = render.transform_point(Vec2(11.0, 1.0))
    assert_true(hit_test_pickable(world~, child, inside, inside, inside, None))
    assert_false(
      hit_test_pickable(world~, child, outside, outside, outside, None),
    )
    @transform.set_local_transform(
      world~,
      parent,
      @transform.Transform::from_scale(Vec3(0.0, 1.0, 1.0)),
    )
    let inside_old_fallback = @math.Vec2(1.0, 1.0)
    assert_false(
      hit_test_pickable(
        world~,
        child,
        inside_old_fallback,
        inside_old_fallback,
        inside_old_fallback,
        None,
      ),
    )
  })
}
