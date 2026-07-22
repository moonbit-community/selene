///|
test "level up shows panel and buttons" {
  use_survivors_test_assets()
  @ecs.set_current_world(@ecs.bootstrap_world())
  setup_level_up_ui()
  game_state.pending_level_ups.clear()
  game_state.player_level = 1
  game_state.exp = 0

  add_exp(16)
  @ui.ui_layout_system(0.0)
  @ui.ui_extract_system(0.0)
  @ui.ui_prepare_system(0.0)

  inspect(@time.scale(), content="0")
  inspect(
    @ui.nodes().get(game_state.level_up_panel.panel_entity).unwrap().active,
    content="true",
  )
  inspect(levelup_buttons.length(), content="3")
  inspect(levelup_button_icons.length(), content="3")
  inspect(@ui.nodes().get(levelup_buttons[0]).unwrap().active, content="true")
  inspect(
    @ui.nodes().get(levelup_button_icons[0]).unwrap().active,
    content="true",
  )
  inspect(@ui.ui_images().contains(levelup_button_icons[0]), content="true")
  inspect(
    levelup_button_icons[0].get_parent() == Some(levelup_buttons[0]),
    content="true",
  )
  let button_rect = @ui.global_ui_nodes().get(levelup_buttons[0]).unwrap().screen_rect
  let icon_rect = @ui.global_ui_nodes().get(levelup_button_icons[0]).unwrap().screen_rect
  inspect(
    icon_rect.position[X] ==
    button_rect.position[X] + LEVELUP_BUTTON_ICON_OFFSET_X,
    content="true",
  )
  inspect(
    icon_rect.position[Y] ==
    button_rect.position[Y] + LEVELUP_BUTTON_ICON_OFFSET_Y,
    content="true",
  )
  inspect(game_state.level_up_panel.available_selections.length(), content="3")
}

///|
test "level up click resumes game" {
  use_survivors_test_assets()
  @ecs.set_current_world(@ecs.bootstrap_world())
  setup_level_up_ui()
  game_state.pending_level_ups.clear()
  game_state.player_level = 1
  game_state.exp = 0

  add_exp(16)
  @ui.click_event_bus.send({ entity: levelup_buttons[0], button: Left })
  survivors_ui_pointer_system(@ecs.bootstrap_world())

  inspect(@time.scale(), content="1")
  inspect(
    @ui.nodes().get(game_state.level_up_panel.panel_entity).unwrap().active,
    content="false",
  )
  inspect(
    @ui.nodes().get(levelup_button_icons[0]).unwrap().active,
    content="false",
  )
}
