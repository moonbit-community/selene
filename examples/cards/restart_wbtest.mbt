///|
test "restarting Cards replaces only its entities in the current World" {
  @asset.set_io(fn(_path) { Some(Bytes::from_array([1U.to_byte()])) })
  defer @asset.set_io(fn(_path) { None })
  let first = @ecs.World()
  let second = @ecs.World()
  let other_world_card = Ref(None)
  @ecs.run_schedule(second, fn(world) {
    game_start(world)
    other_world_card.val = Some(game_state().chips_label)
    game_state().player.chips = 275
  })
  let old_entities = []
  let other_entity = Ref(None)
  let starting_chips = Ref(0)
  let alive_count = Ref(0)
  @ecs.run_schedule(first, fn(world) {
    other_entity.val = Some(@ecs.Entity())
    game_start(world)
    old_entities.append(cards_runtime().entities)
    starting_chips.val = game_state().player.chips
    game_state().player.chips = 40
  })

  @ecs.run_schedule(first, _ => alive_count.val = @ecs.alive_entity_count())
  @ecs.run_schedule(first, game_start)
  let restarted_count = Ref(0)
  @ecs.run_schedule(first, _ => restarted_count.val = @ecs.alive_entity_count())
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
