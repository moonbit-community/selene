///|
test "state-driven Survivors restart replaces entities and cancels old timers" {
  let world = @ecs.World()
  let other_entity = @ecs.commands(world).spawn(())
  let old_callback_ran = Ref(false)
  let app = @app.App()
    .with_world(world)
    .init_state(GamePhase::Playing)
    .add_exclusive_on_enter(GamePhase::Playing, game_start)
    .add_on_enter(GamePhase::GameOver, show_game_over)
    .add_system(PostUpdate, fn(_ : Unit) { @time.timers_system(0.0) })
  app.run_frames(1)
  @state.set_next(world, GamePhase::GameOver)
  app.run_frames(1)

  let previous_entities = []
  @ecs.set_current_world(world)
  game_state(world~).score = 200
  previous_entities.append(survivors_runtime().entities)
  @time.set_scale(0.0)
  survivors_timeout(0.0, () => old_callback_ran.val = true)
  restart_game()
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

///|
test "injected Survivors gameplay fires and refreshes its parameters after a state restart" {
  let world = @ecs.World()
  let app = survivors_app().with_world(world).init_state(GamePhase::Playing)
  app.run_frames(1)
  let runtime : SurvivorsRuntime = world.resource()
  let game = runtime.game.unwrap()
  let enemies : @ecs.Query[(Enemy, @transform.Spatial)] = world.query()
  let (_, (_, enemy_spatial)) = enemies.iter().next().unwrap()
  let player = (world.get_component(game.player_entity) : @transform.Spatial?)
    .unwrap()
    .pose()
  enemy_spatial.set_local(
    player.with_translation(player.translation + Vec3(32.0, 0.0, 0.0)),
  )
  game.player_stats.attack_speed = 1.0
  runtime.weapon_timers.clear()
  app.run_frames(1)
  let bullets : @ecs.Query[@ecs.Single[PlayerBulletState]] = world.query1()
  assert_true(bullets.length() > 0)
  assert_true(runtime.weapon_timers[0] > 0.0)
  game.score = 123
  @state.set_next(world, GamePhase::GameOver)
  app.run_frames(1)
  @state.set_next(world, GamePhase::Playing)
  app.run_frames(1)
  let restarted : SurvivorsRuntime = world.resource()
  assert_eq(restarted.game.unwrap().score, 0)
  assert_true(restarted.game.unwrap().player_entity.is_valid_in(world))
  assert_true(enemies.length() > 0)
}
