///|
fn with_text2d_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn text2d_test_style() -> @render2d_types.TextStyle2D {
  {
    font: None,
    family: "Sans",
    size: 16.0,
    color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    align: Left,
    baseline: Top,
  }
}

///|
test "text2d layout cache reuses identical inputs" {
  with_text2d_test_world(fn() raise {
    let entity = @entity.Entity()
    let style = text2d_test_style()
    let layout = @ui.TextLayout(wrap=WordWrap, overflow=Ellipsis)
    let bounds = Some(TextBounds(60.0, 100.0))

    let first = cached_text_layout(entity, "hello world", style, layout, bounds)
    let second = cached_text_layout(
      entity, "hello world", style, layout, bounds,
    )

    inspect(text_layout_caches().length(), content="1")
    inspect(first.key == second.key, content="true")
    inspect(first.lines == second.lines, content="true")
  })
}

///|
test "text2d layout cache invalidates when text changes" {
  with_text2d_test_world(fn() raise {
    let entity = @entity.Entity()
    let style = text2d_test_style()
    let layout = @ui.TextLayout(wrap=WordWrap, overflow=Ellipsis)
    let bounds = Some(TextBounds(60.0, 100.0))

    let first = cached_text_layout(entity, "hello world", style, layout, bounds)
    let second = cached_text_layout(
      entity, "different text", style, layout, bounds,
    )

    inspect(first.key == second.key, content="false")
    inspect(first.lines == second.lines, content="false")
    inspect(
      text_layout_caches()
      .get(entity)
      .map(fn(cached) { cached.key == second.key })
      .unwrap_or(false),
      content="true",
    )
  })
}
