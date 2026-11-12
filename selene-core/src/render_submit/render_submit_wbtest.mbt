///|
fn with_render_submit_test_world(
  action : (@ecs.World) -> Unit raise,
) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action(world)
  @ecs.set_current_world(previous)
}

///|
fn test_rect_command(
  position : @math.Vec2,
) -> @render2d_types.RectDrawCommand2D {
  {
    rect: { position, size: Vec2(8.0, 8.0), },
    transform: @math.Affine2::identity(),
    alpha_mode: Opaque,
    blend_mode: Alpha,
    fill_color: { r: 255U, g: 255U, b: 255U, a: 1.0, },
    stroke_color: None,
  }
}

///|
test "build_frame2d keeps clear-only camera passes" {
  with_render_submit_test_world(fn(world) raise {
    @window.configure_display(200.0, 120.0, 1.0)
    let camera_entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
    camera_entity_draft.add(
      (
        Camera(
          viewport=Some(CameraViewport(Vec2(20.0, 10.0), Vec2(80.0, 40.0))),
          pass=CameraPass2D(load_op=Clear, clear_color={
            r: 12U,
            g: 24U,
            b: 48U,
            a: 1.0,
          }),
        ) : @camera.Camera),
    )
    camera_entity_draft.add((Camera2d() : @camera.Camera2d))
    camera_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    ignore(@ecs_test.spawn_draft(camera_entity_draft))

    let (frame, _) = build_frame2d(@camera.active_camera2d_views(world~))
    inspect(frame.passes.length(), content="1")
    inspect(
      match frame.passes[0].load_op {
        Clear => true
        _ => false
      },
      content="true",
    )
    inspect(frame.passes[0].world_commands.length(), content="0")
    inspect(
      frame.passes[0].viewport.position.x == 20.0 &&
      frame.passes[0].viewport.position.y == 10.0 &&
      frame.passes[0].viewport.size.x == 80.0 &&
      frame.passes[0].viewport.size.y == 40.0,
      content="true",
    )
    inspect(
      frame.passes[0].clear_color.r.reinterpret_as_int() == 12 &&
      frame.passes[0].clear_color.g.reinterpret_as_int() == 24,
      content="true",
    )
    inspect(
      match frame.passes[0].target {
        Screen => true
        _ => false
      },
      content="true",
    )
  })
}

///|
test "build_frame2d normalizes offscreen viewport and command coordinates" {
  with_render_submit_test_world(fn(world) raise {
    @window.configure_display(200.0, 120.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
    camera_entity_draft.add(
      (
        Camera(
          viewport=Some(CameraViewport(Vec2(20.0, 10.0), Vec2(80.0, 40.0))),
          pass=CameraPass2D(
            load_op=Clear,
            clear_color={ r: 0U, g: 0U, b: 0U, a: 1.0, },
            target=Offscreen("minimap"),
          ),
        ) : @camera.Camera),
    )
    camera_entity_draft.add((Camera2d() : @camera.Camera2d))
    camera_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    let camera_entity = @ecs_test.spawn_draft(camera_entity_draft)
    @render2d.push_rect_with_depth_to_camera(
      camera_entity.id(),
      0.0,
      test_rect_command(Vec2(30.0, 22.0)),
      entity_id=Some(7U),
    )

    let (frame, _) = build_frame2d(@camera.active_camera2d_views(world~))
    inspect(
      frame.passes[0].viewport.position.x == 0.0 &&
      frame.passes[0].viewport.position.y == 0.0 &&
      frame.passes[0].viewport.size.x == 80.0 &&
      frame.passes[0].viewport.size.y == 40.0,
      content="true",
    )
    inspect(
      match frame.passes[0].world_commands[0] {
        Rect(command) =>
          command.rect.position.x == 10.0 && command.rect.position.y == 12.0
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
  with_render_submit_test_world(fn(world) raise {
    @window.configure_display(200.0, 120.0, 1.0)
    @render2d.begin_frame2d_system(0.0)
    let camera_entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
    camera_entity_draft.add((Camera() : @camera.Camera))
    camera_entity_draft.add((Camera2d() : @camera.Camera2d))
    camera_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    let camera_entity = @ecs_test.spawn_draft(camera_entity_draft)

    @render2d.push_ui_clip_for_camera(
      { position: Vec2(0.0, 0.0), size: Vec2(20.0, 20.0), },
      Some(camera_entity.id()),
    )
    @render2d.push_ui_rect_to_camera(
      Some(camera_entity.id()),
      test_rect_command(Vec2(1.0, 1.0)),
    )
    @render2d.push_ui_rect_to_camera(
      Some(camera_entity.id()),
      test_rect_command(Vec2(2.0, 2.0)),
    )
    @render2d.pop_ui_clip_for_camera(Some(camera_entity.id()))
    @render2d.push_ui_rect_to_camera(
      Some(camera_entity.id()),
      test_rect_command(Vec2(3.0, 3.0)),
    )

    let (frame, _) = build_frame2d(@camera.active_camera2d_views(world~))
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
  with_render_submit_test_world(fn(world) raise {
    @window.configure_display(200.0, 120.0, 1.0)
    let camera_entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
    camera_entity_draft.add(
      (
        Camera(
          pass=CameraPass2D(
            load_op=Clear,
            clear_color={ r: 0U, g: 0U, b: 0U, a: 1.0, },
            target=Offscreen("minimap"),
          ),
        ) : @camera.Camera),
    )
    camera_entity_draft.add((Camera2d() : @camera.Camera2d))
    camera_entity_draft.add(
      (
        Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)) :
        @transform.Spatial),
    )
    ignore(@ecs_test.spawn_draft(camera_entity_draft))

    let (frame, _) = build_frame2d(@camera.active_camera2d_views(world~))
    inspect(frame.passes.length(), content="1")
    inspect(
      match frame.passes[0].target {
        Offscreen(name) => name == "minimap"
        _ => false
      },
      content="true",
    )
  })
}
