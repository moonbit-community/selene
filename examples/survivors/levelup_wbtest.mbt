///|
test "level up shows panel and buttons" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(@ecs.require_current_world())
  reset_survivors_runtime()
  setup_level_up_ui(ui=SurvivorsUi(world))
  flush_test_commands(world)
  game_state(world~).pending_level_ups.clear()
  game_state(world~).player_level = 1
  game_state(world~).exp = 0

  add_exp(ui=SurvivorsUi(world), 16)
  flush_test_commands(world)
  @ui.ui_layout_system(world~, 0.0)
  @ui.ui_extract_system()
  @ui.ui_prepare_system(world~, 0.0)

  inspect(@time.scale(), content="0")
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.Node]])
    .get(game_state(world~).level_up_panel.panel_entity)
    .map(value => value.0)
    .unwrap().active,
    content="true",
  )
  inspect(survivors_runtime().levelup_buttons.length(), content="3")
  inspect(survivors_runtime().levelup_button_icons.length(), content="3")
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.Node]])
    .get(survivors_runtime().levelup_buttons[0])
    .map(value => value.0)
    .unwrap().active,
    content="true",
  )
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.Node]])
    .get(survivors_runtime().levelup_button_icons[0])
    .map(value => value.0)
    .unwrap().active,
    content="true",
  )
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.UiImage]]).contains(
      survivors_runtime().levelup_button_icons[0],
    ),
    content="true",
  )
  inspect(
    survivors_runtime().levelup_button_icons[0].get_parent() ==
    Some(survivors_runtime().levelup_buttons[0]),
    content="true",
  )
  let button_rect = @ui.global_ui_node(survivors_runtime().levelup_buttons[0]).unwrap().screen_rect
  let icon_rect = @ui.global_ui_node(
      survivors_runtime().levelup_button_icons[0],
    ).unwrap().screen_rect
  inspect(
    icon_rect.position.x ==
    button_rect.position.x + LEVELUP_BUTTON_ICON_OFFSET_X,
    content="true",
  )
  inspect(
    icon_rect.position.y ==
    button_rect.position.y + LEVELUP_BUTTON_ICON_OFFSET_Y,
    content="true",
  )
  inspect(
    game_state(world~).level_up_panel.available_selections.length(),
    content="3",
  )
}

///|
test "level up click resumes game" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(@ecs.require_current_world())
  reset_survivors_runtime()
  setup_level_up_ui(ui=SurvivorsUi(world))
  flush_test_commands(world)
  game_state(world~).pending_level_ups.clear()
  game_state(world~).player_level = 1
  game_state(world~).exp = 0

  add_exp(ui=SurvivorsUi(world), 16)
  flush_test_commands(world)
  @ui.click_event_bus.send({
    entity: survivors_runtime().levelup_buttons[0],
    button: Left,
  })
  survivors_ui_pointer_system(SurvivorsUi(world))

  inspect(@time.scale(), content="1")
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.Node]])
    .get(game_state(world~).level_up_panel.panel_entity)
    .map(value => value.0)
    .unwrap().active,
    content="false",
  )
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@ui.Node]])
    .get(survivors_runtime().levelup_button_icons[0])
    .map(value => value.0)
    .unwrap().active,
    content="false",
  )
}
