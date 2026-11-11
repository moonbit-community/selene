///|
test "scale transform translation only" {
  @window.configure_display(480.0, 320.0, 2.0)
  let transformed = @window.scale_transform_translation(
    Affine2(a=1.2, b=0.3, c=0.4, d=1.1, tx=10.0, ty=20.0),
  )
  assert_eq(transformed.a, 1.2)
  assert_eq(transformed.b, 0.3)
  assert_eq(transformed.c, 0.4)
  assert_eq(transformed.d, 1.1)
  assert_eq(transformed.tx, 20.0)
  assert_eq(transformed.ty, 40.0)
}

///|
test "display configuration and coordinate conversion are World-local" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  @window.configure_display(100.0, 50.0, 2.0)

  @ecs.set_current_world(second)
  assert_eq(@window.get_zoom(), 1.0)
  @window.configure_display(640.0, 360.0, 0.0)
  assert_eq(@window.get_zoom(), 1.0)
  assert_eq(@window.get_screen_size(), Vec2(640.0, 360.0))

  @ecs.set_current_world(first)
  assert_eq(@window.get_viewport_size(), Vec2(100.0, 50.0))
  assert_eq(@window.get_screen_size(), Vec2(200.0, 100.0))
  assert_eq(@window.get_zoom(), 2.0)
  let virtual_position = @math.Vec2(3.0, 4.0)
  let screen_position = @math.Vec2(6.0, 8.0)
  assert_eq(@window.ui_virtual_to_screen(virtual_position), screen_position)
  assert_eq(@window.screen_to_ui_virtual(screen_position), virtual_position)
}
