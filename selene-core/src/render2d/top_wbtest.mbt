///|
fn test_rect_command(
  alpha_mode : @render.AlphaMode2D,
  alpha : Double,
) -> @render2d_types.RectDrawCommand2D {
  {
    rect: { position: @math.Vec2::zero(), size: Vec2(8.0, 8.0) },
    transform: @math.Transform::identity(),
    alpha_mode,
    blend_mode: Alpha,
    fill_color: { r: 255U, g: 255U, b: 255U, a: alpha },
    stroke_color: None,
  }
}

///|
fn int_array_matches(values : Array[Int], expected : Array[Int]) -> Bool {
  let mut matches = values.length() == expected.length()
  if matches {
    for index in 0..<values.length() {
      if values[index] != expected[index] {
        matches = false
      }
    }
  }
  matches
}

///|
test "render2d world sorting honors layer and depth order" {
  begin_frame2d_system(0.0)

  push_rect_with_depth_for_entity(
    10.0,
    Some(1U),
    test_rect_command(Blend, 0.5),
    sorting=Sorting2d(),
  )
  push_rect_with_depth_for_entity(
    20.0,
    Some(2U),
    test_rect_command(Opaque, 1.0),
    sorting=Sorting2d(),
  )
  push_rect_with_depth_for_entity(
    5.0,
    Some(3U),
    test_rect_command(Opaque, 1.0),
    sorting=Sorting2d(layer=-1),
  )

  let order = get_screen_world_commands_with_depth().map(fn(command) {
    command.entity_id.unwrap_or(0U).reinterpret_as_int()
  })
  inspect(int_array_matches(order, [3, 1, 2]), content="true")
}

///|
test "render2d world sorting honors explicit sorting groups" {
  begin_frame2d_system(0.0)

  push_rect_with_depth_for_entity(
    1.0,
    Some(1U),
    test_rect_command(Opaque, 1.0),
    sorting=Sorting2d(group=2),
  )
  push_rect_with_depth_for_entity(
    100.0,
    Some(2U),
    test_rect_command(Opaque, 1.0),
    sorting=Sorting2d(group=0),
  )
  push_rect_with_depth_for_entity(
    50.0,
    Some(3U),
    test_rect_command(Opaque, 1.0),
    sorting=Sorting2d(group=1),
  )

  let order = get_screen_world_commands_with_depth().map(fn(command) {
    command.entity_id.unwrap_or(0U).reinterpret_as_int()
  })
  inspect(int_array_matches(order, [2, 3, 1]), content="true")
}
