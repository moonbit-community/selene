///|
test "BENCH-UI prepare borders in paint order" (b : @bench.T) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for stride in [1, 8] {
    let world = @ecs.World()
    @ecs.set_current_world(world)
    @window.configure_display(960.0, 540.0, 1.0)
    let root = @ecs.commands(world).spawn1(
      (Node(width=@ui.Val::px(960.0), height=@ui.Val::px(540.0)) : @ui.Node),
    )
    for i in 0..<512 {
      let node = @ui.Node(
        width=@ui.Val::px(80.0),
        height=@ui.Val::px(18.0),
        flex_shrink=0.0,
        border=@ui.UiRectValues::all(1.0),
      )
      if i % stride == 0 {
        ignore(
          @ecs.commands(world).spawn(
            (node, @ui.BorderColor(@ui.rgba(255, 255, 255, 1.0))),
            parent=root,
          ),
        )
      } else {
        ignore(@ecs.commands(world).spawn1(node, parent=root))
      }
    }
    try! @ecs.Schedule().run(world)
    @ui.ui_layout_system(UiNodes(world))
    @ui.ui_extract_system(UiExtraction(@ecs.require_current_world()))
    let frame = () => {
      @render2d.begin_frame2d_system(Frame2D(@ecs.require_current_world()))
      @ui.ui_prepare_system(Frame2D(world), UiNodes(world))
      @render2d.get_frame2d(world~).ui_commands.length()
    }
    assert_eq(frame(), 4 * (512 / stride))
    b.bench(name="ui-prepare/n=512/border-stride=\{stride}", count=20, () => {
      b.keep(frame())
    })
  }
}
