///|
test "UI parameters use their owning geometry, display and event queues" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  @window.configure_display(100.0, 80.0, 2.0)
  @ui.set_ui_scale_mode(Viewport)
  let panel = @ecs.commands(first).spawn(
    (
      @ui.Node(width=Px(20.0), height=Px(10.0)),
      @ui.BackgroundColor::from_css("red"),
    ),
  )
  @ecs.Schedule().run(first)
  let nodes = @ui.UiNodes(first)
  let geometry = @ui.UiGeometryView(first)
  let input = @ui.UiInput(first)
  let frame = @render2d.Frame2D(first)
  let focus_reader : @event.EventReader[@ui.UiFocusInEvent] = EventReader()
  let first_focus = focus_reader.bind(first, @ui.focus_in_event_bus)
  let second_focus = focus_reader.bind(second, @ui.focus_in_event_bus)
  @ecs.set_current_world(second)
  @window.configure_display(300.0, 300.0, 1.0)
  @ui.ui_layout_system(nodes)
  assert_eq(
    geometry.global_node(panel).unwrap().screen_rect.size,
    Vec2(40.0, 20.0),
  )
  @ui.ui_extract_system(UiExtraction(first))
  @ui.ui_prepare_system(frame, nodes)
  assert_true(frame.get_screen_ui_commands().length() > 0)
  assert_eq(@render2d.Frame2D(second).get_screen_ui_commands().length(), 0)
  @ecs.clear_current_world()
  input.focus(panel)
  assert_eq(input.focused_entity(), Some(panel))
  assert_eq(first_focus.read().map(event => event.entity), [panel])
  assert_eq(second_focus.read().length(), 0)
}
