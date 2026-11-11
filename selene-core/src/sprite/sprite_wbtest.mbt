///|
fn with_sprite_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn spawn_test_camera(viewport : @math.Rect) -> @ecs.Entity {
  let camera_entity_draft = @ecs.require_current_world().spawn_draft()
  camera_entity_draft.add_to(
    @camera.cameras(),
    Camera(viewport=Some(@camera.CameraViewport::from_rect(viewport))),
  )
  camera_entity_draft.add_to(@camera.camera2ds(), Camera2d())
  camera_entity_draft.add_to(
    @transform.spatials(),
    Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)),
  )
  let camera_entity = camera_entity_draft.spawn()
  camera_entity
}

///|
fn spawn_color_sprite(position : @math.Vec2) -> @ecs.Entity {
  let entity_draft = @ecs.require_current_world().spawn_draft()
  entity_draft.add_to(
    sprites(),
    Sprite::from_color({ r: 255U, g: 255U, b: 255U, a: 1.0, }, Vec2(16.0, 16.0)),
  )
  entity_draft.add_to(
    @transform.spatials(),
    Spatial(@transform.Transform::from_xyz(position.x, position.y, 0.0)),
  )
  let entity = entity_draft.spawn()
  entity
}

///|
test "sprite rendering skips cameras whose viewport does not intersect the sprite" {
  with_sprite_test_world(fn() raise {
    @window.configure_display(100.0, 100.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity = spawn_test_camera({
      position: @math.Vec2::zero(),
      size: Vec2(100.0, 100.0),
    })
    let sprite_entity = spawn_color_sprite(Vec2(200.0, 200.0))
    @visibility.visibility_propagate_system(0.0)

    render_sprite_system(0.0)

    inspect(
      @render2d.get_camera_world_commands_with_depth(camera_entity.id()).length(),
      content="0",
    )
    ignore(sprite_entity)
  })
}

///|
test "sprite rendering keeps visible sprites inside the camera viewport" {
  with_sprite_test_world(fn() raise {
    @window.configure_display(100.0, 100.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity = spawn_test_camera({
      position: @math.Vec2::zero(),
      size: Vec2(100.0, 100.0),
    })
    let sprite_entity = spawn_color_sprite(Vec2(50.0, 50.0))
    @visibility.visibility_propagate_system(0.0)

    render_sprite_system(0.0)

    inspect(
      @render2d.get_camera_world_commands_with_depth(camera_entity.id()).length(),
      content="1",
    )
    ignore(sprite_entity)
  })
}

///|
test "sprite draw ties keep spawn order after swap-removal" {
  with_sprite_test_world(fn() raise {
    @window.configure_display(100.0, 100.0, 1.0)
    let retired = spawn_color_sprite(Vec2(0.0, 0.0))
    let first = spawn_color_sprite(Vec2(0.0, 0.0))
    let second = spawn_color_sprite(Vec2(0.0, 0.0))
    assert_true(retired.delete())
    @render2d.begin_frame2d_system(0.0)
    render_sprite_system(0.0)
    let commands = @render2d.get_screen_world_commands_with_depth()
    assert_eq(commands.map(command => command.entity_id), [
      Some(first.id()),
      Some(second.id()),
    ])
  })
}

///|
test "sprite world transform preserves shear from its parent" {
  with_sprite_test_world(fn() raise {
    @window.configure_display(100.0, 100.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let world = @ecs.require_current_world()
    let parent = world.spawn1(
      @transform.Spatial(@transform.Transform::from_scale(Vec3(2.0, 1.0, 1.0))),
    )
    let child = world.spawn(
      (
        Sprite(
          custom_size=Some(Vec2(16.0, 16.0)),
          anchor=Anchor(Vec2(-0.5, 0.5)),
        ),
        @transform.Spatial(
          @transform.Transform::from_rotation(
            @math.Rotation3::from_axis_angle(
              @math.Vec3::z_axis(),
              0.7853981633974483,
            ),
          ).with_translation(Vec3(10.0, 20.0, 0.0)),
        ),
      ),
      parent~,
    )
    @transform.transform_propagate_system(0.0)
    @visibility.visibility_propagate_system(0.0)
    render_sprite_system(0.0)
    let commands = @render2d.get_screen_world_commands_with_depth()
    assert_eq(commands.length(), 1)
    guard commands[0].command is Rect(draw) else {
      fail("expected a sprite rectangle")
    }
    let world_point = @transform.global_transform(child)
      .unwrap()
      .transform_point(Vec3(3.0, 5.0, 0.0))
    let render_point = draw.rect.position +
      draw.transform.transform_point(Vec2(3.0, 5.0))
    assert_true(
      render_point.distance(Vec2(world_point.x, world_point.y)) < 1.0e-10,
    )
  })
}
