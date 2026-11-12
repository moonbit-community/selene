///|
fn build_retained_layout_benchmark() -> Array[@ecs.Entity] {
  let world = @ecs.require_current_world()
  let entities : Array[@ecs.Entity] = []
  let root = @ecs_runtime.spawn1(
    world,
    @ui.Node(
      width=@ui.Val::px(960.0),
      height=@ui.Val::px(540.0),
      padding=@ui.UiRectValues::all(12.0),
      flex_direction=Row,
      column_gap=8.0,
    ),
  )
  entities.push(root)
  let grid = @ecs_runtime.spawn1(
    world,
    @ui.Node(
      width=@ui.Val::px(720.0),
      height=@ui.Val::percent(100.0),
      padding=@ui.UiRectValues::all(8.0),
      display=Grid,
      row_gap=6.0,
      column_gap=6.0,
      grid_template_columns=[
        @ui.grid_fr(1.0),
        @ui.grid_fr(1.0),
        @ui.grid_fr(1.0),
        @ui.grid_fr(1.0),
      ],
      overflow_y=Scroll,
    ),
    parent=root,
  )
  entities.push(grid)
  for structural_index in 0..<24 {
    entities.push(
      @ecs_runtime.spawn1(
        world,
        @ui.Node(
          width=@ui.Val::px(8.0 + (structural_index % 3).to_double()),
          height=@ui.Val::px(8.0),
          flex_shrink=0.0,
        ),
        parent=root,
      ),
    )
  }
  for slot_index in 0..<96 {
    let slot = @ecs_runtime.spawn1(
      world,
      @ui.Node(
        height=@ui.Val::px(76.0),
        padding=@ui.UiRectValues::all(4.0),
        border=@ui.UiRectValues::all(1.0),
        row_gap=2.0,
      ),
      parent=grid,
    )
    entities.push(slot)
    entities.push(
      @ecs_runtime.spawn1(
        world,
        @ui.Node(width=@ui.Val::px(40.0), height=@ui.Val::px(40.0)),
        parent=slot,
      ),
    )
    for
      text in [
        "Inventory slot " + slot_index.to_string(),
        (slot_index + 1).to_string(),
      ] {
      entities.push(
        @ecs_runtime.spawn(
          world,
          (
            @ui.Node(width=@ui.Val::percent(100.0)),
            @ui.Text(text),
            @ui.TextFont(size=12.0),
          ),
          parent=slot,
        ),
      )
    }
  }
  entities
}

///|
test "BENCH-UI retained static layout" (b : @bench.T) {
  let previous_world = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  defer @ecs.set_current_world(previous_world)
  @window.configure_display(960.0, 540.0, 1.0)
  let entities = build_retained_layout_benchmark()
  assert_eq(entities.length(), 410)

  // Build every layout cache before timing repeated unchanged frames.
  @ui.ui_layout_system(world~, 0.0)
  assert_true(
    entities.iter().all(entity => @ui.global_ui_node(entity) is Some(_)),
  )
  b.bench(
    name="ui-layout/static/n=410",
    fn() {
      @ui.ui_layout_system(world~, 0.0)
      b.keep(@ui.global_ui_node(entities[0]))
    },
    count=20,
  )

  for entity in entities {
    if entity.is_alive() {
      @ecs_runtime.destroy(entity)
    }
  }
  @ui.ui_layout_system(world~, 0.0)
}
