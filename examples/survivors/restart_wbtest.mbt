///|
test "restarting Survivors replaces its entities and cancels its old timers" {
  use_survivors_test_assets()
  defer @asset.set_io(fn(_path) { None })
  let world = @ecs.World()
  let previous_entities = []
  let old_callback_ran = Ref(false)
  let other_entity = Ref(None)
  @ecs.run_schedule(world, fn(world) {
    other_entity.val = Some(@ecs.require_current_world().spawn(()))
    game_start(world)
    spawn_enemy_system(world)
    previous_entities.append(survivors_runtime().entities)
    game_state().score = 200
    @time.set_scale(0.0)
    survivors_timeout(0.0, () => old_callback_ran.val = true)
  })

  @ecs.run_schedule(world, fn(_world) {
    restart_game()
    @system.timers_system(0.0)
  })

  assert_false(previous_entities.is_empty())
  for entity in previous_entities {
    assert_false(entity.is_valid_in(world))
  }
  assert_true(other_entity.val.unwrap().is_valid_in(world))
  assert_false(old_callback_ran.val)
  let runtime : SurvivorsRuntime = world.resource()
  assert_eq(runtime.timers.length(), 1)
  assert_eq(runtime.game.unwrap().score, 0)
}
