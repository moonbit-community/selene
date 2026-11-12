///|
test "state-driven Survivors restart replaces entities and cancels old timers" {
  use_survivors_test_assets()
  defer @asset.set_io(fn(_path) { None })
  let world = @ecs.World()
  let other_entity = world.spawn(())
  let old_callback_ran = Ref(false)
  let app = @app.App()
    .with_world(world)
    .init_state(GamePhase::Playing)
    .add_on_enter(GamePhase::Playing, game_start)
    .add_on_enter(GamePhase::GameOver, show_game_over)
    .add_system(PostUpdate, _ => @time.timers_system(0.0))
  app.run_frames(1)
  @state.set_next(world, GamePhase::GameOver)
  app.run_frames(1)

  let previous_entities = []
  @ecs.run_schedule(world, _ => {
    game_state(world~).score = 200
    previous_entities.append(survivors_runtime().entities)
    @time.set_scale(0.0)
    survivors_timeout(0.0, () => old_callback_ran.val = true)
    restart_game()
  })
  let before : GamePhase = @state.current(world)
  assert_true(before == GameOver)
  app.run_frames(1)

  assert_false(previous_entities.is_empty())
  for entity in previous_entities {
    assert_false(entity.is_valid_in(world))
  }
  assert_true(other_entity.is_valid_in(world))
  assert_false(old_callback_ran.val)
  let runtime : SurvivorsRuntime = world.resource()
  assert_eq(runtime.timers.length(), 1)
  assert_eq(runtime.game.unwrap().score, 0)
  let after : GamePhase = @state.current(world)
  assert_true(after == Playing)
}
