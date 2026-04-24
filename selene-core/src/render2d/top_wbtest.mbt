///|
fn test_rect_command(
  alpha_mode : @render.AlphaMode2D,
  alpha : Double,
) -> @render2d_types.RectDrawCommand2D {
  {
    rect: { position: @math.Vec2::zero(), size: @math.Vec2(8.0, 8.0) },
    transform: @math.Transform::identity(),
    alpha_mode,
    blend_mode: @render.BlendMode2D::Alpha,
    fill_color: { r: 255U, g: 255U, b: 255U, a: alpha },
    stroke_color: None,
  }
}

///|
test "render2d world sorting honors layer and depth order" {
  begin_frame2d_system(0.0)

  push_rect_with_depth_for_entity(
    10.0,
    Some(1U),
    test_rect_command(@render.AlphaMode2D::Blend, 0.5),
    sorting=Sorting2d(),
  )
  push_rect_with_depth_for_entity(
    20.0,
    Some(2U),
    test_rect_command(@render.AlphaMode2D::Opaque, 1.0),
    sorting=Sorting2d(),
  )
  push_rect_with_depth_for_entity(
    5.0,
    Some(3U),
    test_rect_command(@render.AlphaMode2D::Opaque, 1.0),
    sorting=Sorting2d(layer=-1),
  )

  let order = get_screen_world_commands_with_depth().map(fn(command) {
    command.entity_id.unwrap_or(0U).reinterpret_as_int()
  })
  inspect(order, content="[3, 1, 2]")
}

///|
test "render2d world sorting honors explicit sorting groups" {
  begin_frame2d_system(0.0)

  push_rect_with_depth_for_entity(
    1.0,
    Some(1U),
    test_rect_command(@render.AlphaMode2D::Opaque, 1.0),
    sorting=Sorting2d(group=2),
  )
  push_rect_with_depth_for_entity(
    100.0,
    Some(2U),
    test_rect_command(@render.AlphaMode2D::Opaque, 1.0),
    sorting=Sorting2d(group=0),
  )
  push_rect_with_depth_for_entity(
    50.0,
    Some(3U),
    test_rect_command(@render.AlphaMode2D::Opaque, 1.0),
    sorting=Sorting2d(group=1),
  )

  let order = get_screen_world_commands_with_depth().map(fn(command) {
    command.entity_id.unwrap_or(0U).reinterpret_as_int()
  })
  inspect(order, content="[2, 3, 1]")
}
