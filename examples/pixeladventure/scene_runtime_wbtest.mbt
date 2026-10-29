///|
fn restore_pixeladventure_test_world(previous : @ecs.World?) -> Unit {
  match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  }
}

///|
fn with_pixeladventure_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world()
  @ecs.set_current_world(@ecs.World())
  defer restore_pixeladventure_test_world(previous)
  action()
}

///|
test "level loading preserves gameplay entities and terrain" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn() raise {
      let loaded = load_level_scene()
      inspect(players().length(), content="1")
      inspect(birds().length(), content="2")
      inspect(apples().length(), content="7")
      inspect(flags().length(), content="1")
      let player_transform = @transform.transforms()
        .get(loaded.player_entity)
        .unwrap()
      inspect(player_transform.translation.x, content="80")
      inspect(player_transform.translation.y, content="496")
      inspect(player_transform.translation.z == PLAYER_Z, content="true")
      inspect(loaded.world_size == Vec2(928.0, 576.0), content="true")
      inspect(
        @camera.camera2ds().contains(loaded.camera_entity),
        content="true",
      )
      let mut terrain_count = 0
      for _, sprite in @sprite.sprites() {
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
    with_pixeladventure_test_world(fn() raise {
      ignore(load_level_scene())
      let flag_entity = flags().to_array()[0].0
      let flag_sprite = @sprite.sprites().get(flag_entity).unwrap()
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
        @animation.animation_players().contains(flag_entity),
        content="true",
      )
    })
  })
}
