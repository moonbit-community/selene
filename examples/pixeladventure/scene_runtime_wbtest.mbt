///|
fn restore_pixeladventure_test_world(previous : @ecs.World?) -> Unit {
  match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  }
}

///|
fn with_pixeladventure_test_world(
  action : (@ecs.World) -> Unit raise,
) -> Unit raise {
  let previous = @ecs.current_world()
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @ecs.require_current_world().insert_resource(PixelAdventureWorldState())
  defer restore_pixeladventure_test_world(previous)
  action(world)
}

///|
test "level loading preserves gameplay entities and terrain" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn(world) raise {
      let loaded = load_level_scene(world~)
      flush_test_commands(world)
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[PlayerController]]).length(),
        content="1",
      )
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[BirdController]]).length(),
        content="2",
      )
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[AppleTag]]).length(),
        content="7",
      )
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[FlagTag]]).length(),
        content="1",
      )
      let player_transform = @transform.local_transform(
        world~,
        loaded.player_entity,
      ).unwrap()
      inspect(player_transform.translation.x, content="80")
      inspect(player_transform.translation.y, content="496")
      inspect(player_transform.translation.z == PLAYER_Z, content="true")
      inspect(loaded.world_size == Vec2(928.0, 576.0), content="true")
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[@camera.Camera2d]]).contains(
          loaded.camera_entity,
        ),
        content="true",
      )
      let mut terrain_count = 0
      for
        _, Single(sprite) in (
          world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]]) {
        if sprite.image.bind(@asset.image_path) ==
          Some("assets/pixeladventure/Terrain/Terrain (16x16).png") {
          terrain_count += 1
        }
      }
      inspect(terrain_count, content="702")
    })
  })
}

///|
test "level flag retains its animated sprite" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn(world) raise {
      ignore(load_level_scene(world~))
      flush_test_commands(world)
      let flag_entity = (world.query() : @ecs.Query[@ecs.Single[FlagTag]]).to_array()[0].0
      let flag_sprite = (world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]])
        .get(flag_entity)
        .map(value => value.0)
        .unwrap()
      inspect(
        flag_sprite.image.bind(@asset.image_path) == Some(FLAG_IDLE_PATH),
        content="true",
      )
      let atlas = flag_sprite.texture_atlas.unwrap()
      inspect(
        @sprite.texture_atlas_layout(atlas.layout).unwrap().rects.length(),
        content="10",
      )
      inspect(
        (world.query() : @ecs.Query[@ecs.Single[@animation.AnimationPlayer]]).contains(
          flag_entity,
        ),
        content="true",
      )
    })
  })
}

///|
test "restarting Pixel Adventure replaces its session and game entities" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn(world) raise {
      let other = @ecs.commands(@ecs.require_current_world()).spawn(())
      game_start(world)
      flush_test_commands(world)
      let previous_session : GameSession = world.resource()
      previous_session.score = 100
      previous_session.health = 1
      previous_session.volume_on = false
      previous_session.result = Some(Win)
      let previous_entities = pixeladventure_world_state().entities.copy()
      let entity_count = @ecs.alive_entity_count()
      assert_false(previous_entities.is_empty())

      game_start(world)
      flush_test_commands(world)

      assert_eq(@ecs.alive_entity_count(), entity_count)
      assert_true(other.is_alive())
      let session : GameSession = world.resource()
      assert_true(session.player != previous_session.player)
      assert_eq(session.score, 0)
      assert_eq(session.health, 3)
      assert_true(session.volume_on)
      assert_true(session.result is None)
      for entity in previous_entities {
        assert_false(entity.is_valid_in(world))
      }
    })
  })
}
