///|
fn cleanup_interaction_test_entity(entity : @entity.Entity) -> Unit {
  nodes().remove(entity)
  computed_ui_nodes().remove(entity)
  global_ui_nodes().remove(entity)
  calculated_clips().remove(entity)
  layout_configs().remove(entity)
  z_indexes().remove(entity)
  global_zindexes().remove(entity)
  scroll_positions().remove(entity)
  tab_indexes().remove(entity)
  focus_policies().remove(entity)
  focusables().remove(entity)
  focuseds().remove(entity)
  override_clips().remove(entity)
  relative_cursor_positions().remove(entity)
  background_colors().remove(entity)
  border_colors().remove(entity)
  border_radii().remove(entity)
  box_shadows().remove(entity)
  outlines().remove(entity)
  material_nodes().remove(entity)
  ui_images().remove(entity)
  texts().remove(entity)
  text_fonts().remove(entity)
  text_colors().remove(entity)
  text_layouts().remove(entity)
  buttons().remove(entity)
  interactions().remove(entity)
  tree_orders().remove(entity)
  entity.destroy()
}

///|
fn reset_interaction_test_state() -> Unit {
  let runtime = ui_interaction_runtime()
  runtime.hovered_entity = None
  runtime.pressed_entity = None
  runtime.focused_entity = None
  @inputs.apply_input_snapshot(@inputs.empty_input_snapshot())
}

///|
fn interaction_test_global_node(rect : @math.Rect) -> GlobalUiNode {
  {
    logical_rect: rect,
    screen_rect: rect,
    logical_content_rect: rect,
    screen_content_rect: rect,
  }
}

///|
test "ui relative cursor positions use centered normalized coordinates" {
  reset_interaction_test_state()
  let entity = @entity.Entity::new()
  let rect : @math.Rect = {
    position: @math.Vec2D(100.0, 50.0),
    size: @math.Vec2D(40.0, 20.0),
  }
  nodes().set(entity, Node::new())
  global_ui_nodes().set(entity, interaction_test_global_node(rect))
  relative_cursor_positions().set(entity, RelativeCursorPosition::new())
  @inputs.mouse.pos = @math.Vec2D(130.0, 60.0)

  ui_interaction_system(0.0)

  let relative = relative_cursor_positions().get(entity).unwrap()
  inspect(relative.mouse_over(), content="true")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized[X] == 0.25, content="true")
  inspect(normalized[Y] == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}

///|
test "ui relative cursor positions keep normalized values outside calculated clip" {
  reset_interaction_test_state()
  let entity = @entity.Entity::new()
  let rect : @math.Rect = {
    position: @math.Vec2D(100.0, 50.0),
    size: @math.Vec2D(40.0, 20.0),
  }
  nodes().set(entity, Node::new())
  global_ui_nodes().set(entity, interaction_test_global_node(rect))
  calculated_clips().set(
    entity,
    CalculatedClip::new({
      position: @math.Vec2D(100.0, 50.0),
      size: @math.Vec2D(10.0, 20.0),
    }),
  )
  relative_cursor_positions().set(entity, RelativeCursorPosition::new())
  @inputs.mouse.pos = @math.Vec2D(130.0, 60.0)

  ui_interaction_system(0.0)

  let relative = relative_cursor_positions().get(entity).unwrap()
  inspect(relative.mouse_over(), content="false")
  inspect(relative.normalized is Some(_), content="true")
  let normalized = relative.normalized.unwrap()
  inspect(normalized[X] == 0.25, content="true")
  inspect(normalized[Y] == 0.0, content="true")

  cleanup_interaction_test_entity(entity)
  reset_interaction_test_state()
}
