///|
fn player_motion_at_refresh_rate(refresh : Int32) -> Array[@math.Vec2] raise {
  let positions = []
  with_pixeladventure_test_world(fn() raise {
    let world = @ecs.require_current_world()
    let snapshot = @inputs.empty_input_snapshot()
    snapshot.pressed_keys.add(ArrowRight)
    let frames = refresh * 2
    for _ in 0..<frames {
      @runtime_debug.queue_input_snapshot(snapshot)
    }
    pixeladventure_app()
    .with_world(world)
    .with_fixed_hz(60)
    .add_system(Startup, world => {
      @inputs.apply_input_snapshot(snapshot)
      @input_action.input_action_system(0.0)
      player_input_system(world)
    })
    .add_system(FixedFirst, world => {
      if world.fixed_step_index() == 12U {
        let session : GameSession = world.resource()
        players().get(session.player).unwrap().jump_requested = true
      }
    })
    .add_system(FixedLast, world => {
      if positions.length() < 60 {
        let session : GameSession = world.resource()
        let translation = @transform.transforms().get(session.player).unwrap().translation
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
    assert_true(baseline.iter().any(position => position[Y] < 450.0))
    for refresh in [120, 144] {
      assert_eq(player_motion_at_refresh_rate(refresh), baseline)
    }
  })
}

///|
test "a jump press survives render frames without a physics step" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn() raise {
      let world = @ecs.require_current_world()
      @time.initialize(world)
      game_start(world)
      let session : GameSession = world.resource()
      let pressed = @inputs.empty_input_snapshot()
      pressed.pressed_keys.add(ArrowUp)
      @inputs.apply_input_snapshot(pressed)
      @input_action.input_action_system(0.0)
      player_input_system(world)
      @inputs.apply_input_snapshot(@inputs.empty_input_snapshot())
      @input_action.input_action_system(0.0)
      player_input_system(world)
      let controller = players().get(session.player).unwrap()
      assert_true(controller.jump_requested)
      @physics2d.grounded_entities().add(session.player)
      @time.use_fixed_delta(1.0 / 60.0)
      player_controller_system(world)
      assert_false(controller.jump_requested)
      let velocity = @physics2d.linear_velocities().get(session.player).unwrap()
      assert_true((velocity.0[Y] - (-JUMP_V + GRAVITY / 60.0)).abs() < 0.000001)
    })
  })
}
