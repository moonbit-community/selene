///|
test "restarting Cards replaces only its entities in the current World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let other_world_card = Ref(None)
  run_test_system(second, fn(world) {
    game_start(world)
    other_world_card.val = Some(game_state().chips_label)
    game_state().player.chips = 275
  })
  let old_entities = []
  let other_entity = Ref(None)
  let starting_chips = Ref(0)
  let alive_count = Ref(0)
  run_test_system(first, fn(world) {
    other_entity.val = Some(
      @ecs.commands(@ecs.require_current_world()).spawn(()),
    )
    game_start(world)
    old_entities.append(cards_runtime().entities)
    starting_chips.val = game_state().player.chips
    game_state().player.chips = 40
  })

  run_test_system(first, _ => alive_count.val = @ecs.alive_entity_count())
  run_test_system(first, game_start)
  let restarted_count = Ref(0)
  run_test_system(first, _ => restarted_count.val = @ecs.alive_entity_count())
  assert_eq(restarted_count.val, alive_count.val)
  assert_false(old_entities.is_empty())
  for entity in old_entities {
    assert_false(entity.is_valid_in(first))
  }
  assert_true(other_entity.val.unwrap().is_valid_in(first))
  assert_true(other_world_card.val.unwrap().is_valid_in(second))
  let first_game : CardsRuntime = first.resource()
  let second_game : CardsRuntime = second.resource()
  assert_eq(first_game.game.unwrap().player.chips, starting_chips.val)
  assert_eq(second_game.game.unwrap().player.chips, 275)
}

///|
test "injected Cards gameplay refreshes its resource after restart and across Worlds" {
  let first = @ecs.World()
  let second = @ecs.World()
  let app = cards_app()
  for world in [first, second, first] {
    app.with_world(world).run_frames(1)
    let runtime : CardsRuntime = world.resource()
    let game = runtime.game.unwrap()
    assert_true(game.waiting_for_player)
    let nodes : @ecs.Query[@ecs.Single[@ui.Node]] = world.query1()
    assert_true(nodes.get(game.call_button).unwrap().0.display == Flex)
    game.player.chips = 0
  }
}
