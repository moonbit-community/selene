///|
fn player_motion_at_refresh_rate(refresh : Int32) -> Array[@math.Vec2] raise {
  let positions = []
  with_pixeladventure_test_world(fn(world) raise {
    let snapshot = @inputs.InputSnapshot()
    snapshot.pressed_keys.add(ArrowRight)
    let frames = refresh * 2
    for _ in 0..<frames {
      @runtime_debug.queue_input_snapshot(snapshot)
    }
    pixeladventure_app()
    .with_world(world)
    .with_fixed_hz(60)
    .add_exclusive_system(Startup, world => {
      @inputs.apply_input_snapshot(snapshot)
      @input_action.input_action_system()
      @ecs.commands(world).add(world => {
        @ecs.args2(player_input_system)(test_params(world))
      })
    })
    .add_exclusive_system(FixedFirst, world => {
      if world.fixed_step_index() == 12U {
        let session : GameSession = world.resource()
        (world.query() : @ecs.Query[@ecs.Single[PlayerController]])
        .get(session.player)
        .map(value => value.0)
        .unwrap().jump_requested
        = true
      }
    })
    .add_exclusive_system(FixedLast, world => {
      if positions.length() < 60 {
        let session : GameSession = world.resource()
        let translation = @transform.local_transform(world~, session.player).unwrap().translation
        positions.push(@math.Vec2(translation.x, translation.y))
      }
    })
    .run_frames(refresh * 2, raw_delta=1.0 / refresh.to_double())
    assert_eq(positions.length(), 60)
  })
  positions
}

///|
test "player movement follows identical fixed steps at 60 120 and 144 Hz" {
  with_pixeladventure_test_asset_io(fn() raise {
    let baseline = player_motion_at_refresh_rate(60)
    assert_true(baseline.iter().any(position => position.y < 450.0))
    for refresh in [120, 144] {
      assert_eq(player_motion_at_refresh_rate(refresh), baseline)
    }
  })
}

///|
test "a jump press survives render frames without a physics step" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn(world) raise {
      @time.initialize(world)
      game_start(world)
      flush_test_commands(world)
      let session : GameSession = world.resource()
      let pressed = @inputs.InputSnapshot()
      pressed.pressed_keys.add(ArrowUp)
      @inputs.apply_input_snapshot(pressed)
      @input_action.input_action_system()
      @ecs.args2(player_input_system)(test_params(world))
      @inputs.apply_input_snapshot(InputSnapshot())
      @input_action.input_action_system()
      @ecs.args2(player_input_system)(test_params(world))
      let controller = (
          world.query() : @ecs.Query[@ecs.Single[PlayerController]])
        .get(session.player)
        .map(value => value.0)
        .unwrap()
      assert_true(controller.jump_requested)
      @physics2d.grounded_entities().add(session.player)
      @time.use_fixed_delta(1.0 / 60.0)
      @ecs.args4(player_controller_system)(test_params(world))
      assert_false(controller.jump_requested)
      let velocity = (
          world.query() : @ecs.Query[@ecs.Single[@physics2d.LinearVelocity]])
        .get(session.player)
        .map(value => value.0)
        .unwrap()
      assert_true((velocity.0.y - (-JUMP_V + GRAVITY / 60.0)).abs() < 0.000001)
    })
  })
}
