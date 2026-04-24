///|
fn with_pickable_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action()
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
  viewport : @math.Rect,
  order : Int,
  layers : @visibility.RenderLayers,
) -> @entity.Entity {
  let camera_entity = @entity.Entity()
  @camera.cameras().set(
    camera_entity,
    @camera.Camera(
      order~,
      viewport=Some(@camera.CameraViewport::from_rect(viewport)),
    ),
  )
  @camera.camera2ds().set(camera_entity, @camera.Camera2d())
  @transform.global_transforms().set(
    camera_entity,
    @transform.GlobalTransform::from_transform(
      @transform.Transform::from_xyz(0.0, 0.0, 0.0),
    ),
  )
  @visibility.render_layers().set(camera_entity, layers)
  camera_entity
}

///|
fn spawn_pickable_shape(
  position : @math.Vec2,
  shape : CollisionShape,
  layers? : @visibility.RenderLayers = @visibility.default_render_layers(),
) -> @entity.Entity {
  let entity = @entity.Entity()
  pickables().set(entity, Pickable())
  shapes().set(entity, shape)
  @transform.global_transforms().set(
    entity,
    @transform.GlobalTransform::from_transform(
      @transform.Transform::from_xyz(position[X], position[Y], 0.0),
    ),
  )
  @visibility.render_layers().set(entity, layers)
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
  with_pickable_test_world(fn() raise {
    reset_pickable_test_input()
    @system.configure_display(100.0, 100.0, 1.0)
    let viewport : @math.Rect = {
      position: @math.Vec2::zero(),
      size: @math.Vec2(100.0, 100.0),
    }
    ignore(spawn_pickable_camera(viewport, 0, @visibility.layer(0U)))
    ignore(spawn_pickable_camera(viewport, 1, @visibility.layer(1U)))
    let hidden_entity = spawn_pickable_shape(
      @math.Vec2(50.0, 50.0),
      Rect(size=@math.Vec2(20.0, 20.0), offset=@math.Vec2(-10.0, -10.0)),
      layers=@visibility.layer(0U),
    )
    let visible_entity = spawn_pickable_shape(
      @math.Vec2(50.0, 50.0),
      Rect(size=@math.Vec2(20.0, 20.0), offset=@math.Vec2(-10.0, -10.0)),
      layers=@visibility.layer(1U),
    )
    click_left_mouse(@math.Vec2(50.0, 50.0))

    let reader = @event.EventReader()
    pickable_click_system(0.0)
    let events = pointer_event_bus.read(reader)
    let visible_id = visible_entity.id()
    let left_events = events.filter(fn(event) {
      event.button is @inputs.MouseButton::Left
    })

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
  with_pickable_test_world(fn() raise {
    reset_pickable_test_input()
    @system.configure_display(100.0, 100.0, 1.0)
    ignore(
      spawn_pickable_camera(
        { position: @math.Vec2::zero(), size: @math.Vec2(100.0, 100.0) },
        0,
        @visibility.layer(0U),
      ),
    )
    let entity = spawn_pickable_shape(
      @math.Vec2(40.0, 40.0),
      Ball(radius=12.0, offset=@math.Vec2::zero()),
    )
    click_left_mouse(@math.Vec2(48.0, 40.0))

    let reader = @event.EventReader()
    pickable_click_system(0.0)
    let events = pointer_event_bus.read(reader)
    let left_events = events.filter(fn(event) {
      event.button is @inputs.MouseButton::Left
    })

    inspect(left_events.length(), content="2")
    inspect(
      left_events.all(fn(event) { event.entity == entity }),
      content="true",
    )
  })
}
