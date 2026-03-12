///|
test "level up shows panel and buttons" {
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
  inspect(game_state.level_up_panel.available_selections.length(), content="3")
}

///|
test "level up click resumes game" {
  @ecs.set_current_world(@ecs.bootstrap_world())
  setup_level_up_ui()
  game_state.pending_level_ups.clear()
  game_state.player_level = 1
  game_state.exp = 0

  add_exp(16)
  @ui.click_event_bus.send({
    entity: levelup_buttons[0],
    button: @inputs.MouseButton::Left,
  })
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
