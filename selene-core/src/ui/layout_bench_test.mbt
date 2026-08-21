///|
fn build_retained_layout_benchmark() -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  let root = @entity.Entity()
  entities.push(root)
  @ui.nodes()[root] = Node(
    width=@ui.Val::px(960.0),
    height=@ui.Val::px(540.0),
    padding=@ui.UiRectValues::all(12.0),
    flex_direction=Row,
    column_gap=8.0,
  )
  let grid = @entity.Entity()
  entities.push(grid)
  @ui.nodes()[grid] = Node(
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
  )
  grid.set_parent(root)
  for structural_index in 0..<24 {
    let structural = @entity.Entity()
    entities.push(structural)
    @ui.nodes()[structural] = Node(
      width=@ui.Val::px(8.0 + (structural_index % 3).to_double()),
      height=@ui.Val::px(8.0),
      flex_shrink=0.0,
    )
    structural.set_parent(root)
  }
  for slot_index in 0..<96 {
    let slot = @entity.Entity()
    entities.push(slot)
    @ui.nodes()[slot] = Node(
      height=@ui.Val::px(76.0),
      padding=@ui.UiRectValues::all(4.0),
      border=@ui.UiRectValues::all(1.0),
      row_gap=2.0,
    )
    slot.set_parent(grid)
    for child_index in 0..<3 {
      let child = @entity.Entity()
      entities.push(child)
      @ui.nodes()[child] = if child_index == 0 {
        Node(width=@ui.Val::px(40.0), height=@ui.Val::px(40.0))
      } else {
        Node(width=@ui.Val::percent(100.0))
      }
      if child_index > 0 {
        @ui.texts()[child] = Text(
          if child_index == 1 {
            "Inventory slot " + slot_index.to_string()
          } else {
            (slot_index + 1).to_string()
          },
        )
        @ui.text_fonts()[child] = TextFont(size=12.0)
      }
      child.set_parent(slot)
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
  @system.configure_display(960.0, 540.0, 1.0)
  let entities = build_retained_layout_benchmark()
  assert_eq(entities.length(), 410)

  // Build every layout cache before timing repeated unchanged frames.
  @ui.ui_layout_system(0.0)
  assert_eq(@ui.global_ui_nodes().length(), 410)
  b.bench(
    name="ui-layout/static/n=410",
    fn() {
      @ui.ui_layout_system(0.0)
      b.keep(@ui.global_ui_nodes().length())
    },
    count=20,
  )

  for entity in entities {
    if entity.is_alive() {
      entity.destroy()
    }
  }
  @ui.ui_layout_system(0.0)
}
