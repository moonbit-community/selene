///|
fn with_render_submit_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
test "build_frame2d keeps clear-only camera passes" {
  with_render_submit_test_world(fn() raise {
    @system.configure_display(200.0, 120.0, 1.0)
    let camera_entity = @entity.Entity::new()
    @camera.cameras().set(
      camera_entity,
      @camera.Camera::new(
        viewport=Some(
          @camera.CameraViewport::new(
            @math.Vec2(20.0, 10.0),
            @math.Vec2(80.0, 40.0),
          ),
        ),
        pass=@camera.CameraPass2D::new(load_op=Clear, clear_color={
          r: 12U,
          g: 24U,
          b: 48U,
          a: 1.0,
        }),
      ),
    )
    @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
    @transform.global_transforms().set(
      camera_entity,
      @transform.GlobalTransform::from_transform(
        @transform.Transform::from_xyz(0.0, 0.0, 0.0),
      ),
    )

    let (frame, _) = build_frame2d(@camera.active_camera2d_views())
    inspect(frame.passes.length(), content="1")
    inspect(
      match frame.passes[0].load_op {
        @render2d_types.RenderPassLoadOp2D::Clear => true
        _ => false
      },
      content="true",
    )
    inspect(frame.passes[0].world_commands.length(), content="0")
    inspect(
      frame.passes[0].viewport.position[X] == 20.0 &&
      frame.passes[0].viewport.position[Y] == 10.0 &&
      frame.passes[0].viewport.size[X] == 80.0 &&
      frame.passes[0].viewport.size[Y] == 40.0,
      content="true",
    )
    inspect(
      frame.passes[0].clear_color.r.reinterpret_as_int() == 12 &&
      frame.passes[0].clear_color.g.reinterpret_as_int() == 24,
      content="true",
    )
    inspect(
      match frame.passes[0].target {
        @render2d_types.RenderPassTarget2D::Screen => true
        _ => false
      },
      content="true",
    )
  })
}

///|
test "build_frame2d maps camera offscreen pass target" {
  with_render_submit_test_world(fn() raise {
    @system.configure_display(200.0, 120.0, 1.0)
    let camera_entity = @entity.Entity::new()
    @camera.cameras().set(
      camera_entity,
      @camera.Camera::new(
        pass=@camera.CameraPass2D::new(
          load_op=Clear,
          clear_color={ r: 0U, g: 0U, b: 0U, a: 1.0 },
          target=@camera.CameraPassTarget2D::Offscreen("minimap"),
        ),
      ),
    )
    @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
    @transform.global_transforms().set(
      camera_entity,
      @transform.GlobalTransform::from_transform(
        @transform.Transform::from_xyz(0.0, 0.0, 0.0),
      ),
    )

    let (frame, _) = build_frame2d(@camera.active_camera2d_views())
    inspect(frame.passes.length(), content="1")
    inspect(
      match frame.passes[0].target {
        @render2d_types.RenderPassTarget2D::Offscreen(name) => name == "minimap"
        _ => false
      },
      content="true",
    )
  })
}
