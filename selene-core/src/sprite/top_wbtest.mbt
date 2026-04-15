///|
fn with_sprite_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn spawn_test_camera(viewport : @math.Rect) -> @entity.Entity {
  let camera_entity = @entity.Entity::new()
  @camera.cameras().set(
    camera_entity,
    @camera.Camera::new(
      viewport=Some(@camera.CameraViewport::from_rect(viewport)),
    ),
  )
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @transform.global_transforms().set(
    camera_entity,
    @transform.GlobalTransform::from_transform(
      @transform.Transform::from_xyz(0.0, 0.0, 0.0),
    ),
  )
  camera_entity
}

///|
fn spawn_color_sprite(position : @math.Vec2) -> @entity.Entity {
  let entity = @entity.Entity::new()
  sprites().set(
    entity,
    Sprite::from_color(
      { r: 255U, g: 255U, b: 255U, a: 1.0 },
      @math.Vec2(16.0, 16.0),
    ),
  )
  @transform.global_transforms().set(
    entity,
    @transform.GlobalTransform::from_transform(
      @transform.Transform::from_xyz(position[X], position[Y], 0.0),
    ),
  )
  entity
}

///|
test "sprite rendering skips cameras whose viewport does not intersect the sprite" {
  with_sprite_test_world(fn() raise {
    @system.configure_display(100.0, 100.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity = spawn_test_camera({
      position: @math.Vec2::zero(),
      size: @math.Vec2(100.0, 100.0),
    })
    let sprite_entity = spawn_color_sprite(@math.Vec2(200.0, 200.0))
    @visibility.visibility_propagate_system(0.0)

    render_sprite_system(0.0)

    inspect(
      @render2d.get_camera_world_commands_with_depth(camera_entity.id()).length(),
      content="0",
    )
    inspect(
      @visibility.is_visible_to_camera(sprite_entity, camera_entity.id()),
      content="false",
    )
  })
}

///|
test "sprite rendering keeps visible sprites inside the camera viewport" {
  with_sprite_test_world(fn() raise {
    @system.configure_display(100.0, 100.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity = spawn_test_camera({
      position: @math.Vec2::zero(),
      size: @math.Vec2(100.0, 100.0),
    })
    let sprite_entity = spawn_color_sprite(@math.Vec2(50.0, 50.0))
    @visibility.visibility_propagate_system(0.0)

    render_sprite_system(0.0)

    inspect(
      @render2d.get_camera_world_commands_with_depth(camera_entity.id()).length(),
      content="1",
    )
    inspect(
      @visibility.is_visible_to_camera(sprite_entity, camera_entity.id()),
      content="true",
    )
  })
}
