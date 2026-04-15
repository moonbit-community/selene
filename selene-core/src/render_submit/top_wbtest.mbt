///|
fn with_render_submit_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn test_rect_command(position : @math.Vec2) -> @render2d_types.RectDrawCommand2D {
  {
    rect: { position, size: @math.Vec2(8.0, 8.0) },
    transform: @math.Transform::identity(),
    alpha_mode: @render.AlphaMode2D::Opaque,
    blend_mode: @render.BlendMode2D::Alpha,
    fill_color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    stroke_color: None,
  }
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
test "build_frame2d normalizes offscreen viewport and command coordinates" {
  with_render_submit_test_world(fn() raise {
    @system.configure_display(200.0, 120.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
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
    @render2d.push_rect_with_depth_to_camera(
      camera_entity.id(),
      0.0,
      test_rect_command(@math.Vec2(30.0, 22.0)),
      entity_id=Some(7U),
    )

    let (frame, _) = build_frame2d(@camera.active_camera2d_views())
    inspect(
      frame.passes[0].viewport.position[X] == 0.0 &&
      frame.passes[0].viewport.position[Y] == 0.0 &&
      frame.passes[0].viewport.size[X] == 80.0 &&
      frame.passes[0].viewport.size[Y] == 40.0,
      content="true",
    )
    inspect(
      match frame.passes[0].world_commands[0] {
        Rect(command) =>
          command.rect.position[X] == 10.0 &&
          command.rect.position[Y] == 12.0
        _ => false
      },
      content="true",
    )
    inspect(frame.passes[0].world_batches.length(), content="1")
    inspect(frame.passes[0].world_batches[0].length(), content="1")
  })
}

///|
test "build_frame2d batches camera ui commands with clip barriers" {
  with_render_submit_test_world(fn() raise {
    @system.configure_display(200.0, 120.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity = @entity.Entity::new()
    @camera.cameras().set(camera_entity, @camera.Camera::new())
    @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
    @transform.global_transforms().set(
      camera_entity,
      @transform.GlobalTransform::from_transform(
        @transform.Transform::from_xyz(0.0, 0.0, 0.0),
      ),
    )

    @render2d.set_ui_camera_target(Some(camera_entity.id()))
    @render2d.push_ui_clip({
      position: @math.Vec2(0.0, 0.0),
      size: @math.Vec2(20.0, 20.0),
    })
    @render2d.push_ui_rect(test_rect_command(@math.Vec2(1.0, 1.0)))
    @render2d.push_ui_rect(test_rect_command(@math.Vec2(2.0, 2.0)))
    @render2d.pop_ui_clip()
    @render2d.push_ui_rect(test_rect_command(@math.Vec2(3.0, 3.0)))
    @render2d.set_ui_camera_target(None)

    let (frame, _) = build_frame2d(@camera.active_camera2d_views())
    inspect(frame.passes.length(), content="1")
    inspect(frame.passes[0].ui_batches.length(), content="4")
    inspect(frame.passes[0].ui_batches[0].length(), content="1")
    inspect(frame.passes[0].ui_batches[1].length(), content="2")
    inspect(frame.passes[0].ui_batches[2].length(), content="1")
    inspect(frame.passes[0].ui_batches[3].length(), content="1")
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
