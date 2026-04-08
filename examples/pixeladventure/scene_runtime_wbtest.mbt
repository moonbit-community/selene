///|
fn with_pixeladventure_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world()
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  }
}

///|
fn scene_component_count_for_compare(
  scene : @editor_bridge.SceneDocument,
  kind : String,
) -> Int {
  let mut count = 0
  for entity in scene.entities {
    if entity.component(kind) is Some(_) {
      count += 1
    }
  }
  count
}

///|
fn expected_scene_world_size() -> @math.Vec2D {
  @math.Vec2D(928.0, 576.0)
}

///|
fn scene_terrain_segments(
  scene : @editor_bridge.SceneDocument,
) -> Array[String] {
  let rows : Map[Int, Array[Int]] = {}
  for placement in terrain_placements_from_scene(scene) {
    if !placement.solid || placement.collider_group != "grass" {
      continue
    }
    rows.get_or_init(placement.tile_y, fn() { [] }).push(placement.tile_x)
  }
  collapse_terrain_rows(rows)
}

///|
fn collapse_terrain_rows(rows : Map[Int, Array[Int]]) -> Array[String] {
  let segments : Array[String] = []
  for y, columns in rows {
    columns.sort()
    let mut cursor = 0
    while cursor < columns.length() {
      let start_x = columns[cursor]
      let mut end_x = start_x
      cursor += 1
      while cursor < columns.length() && columns[cursor] == end_x + 1 {
        end_x = columns[cursor]
        cursor += 1
      }
      segments.push("\{y}:\{start_x}:\{end_x - start_x + 1}")
    }
  }
  segments.sort()
  segments
}

///|
test "editor scene includes required gameplay markers" {
  with_pixeladventure_test_asset_io(fn() raise {
    let scene = pixeladventure_startup_scene_document()
    inspect(
      scene_component_count_for_compare(
        scene, pixeladventure_player_component_kind,
      ),
      content="1",
    )
    inspect(
      scene_component_count_for_compare(
        scene, pixeladventure_flag_component_kind,
      ),
      content="1",
    )
    inspect(
      scene_component_count_for_compare(
        scene, pixeladventure_apple_component_kind,
      ),
      content="7",
    )
    inspect(
      scene_component_count_for_compare(
        scene, pixeladventure_bird_component_kind,
      ),
      content="2",
    )
    inspect(
      scene_component_count_for_compare(
        scene, pixeladventure_terrain_component_kind,
      ),
      content="702",
    )
    inspect(scene_terrain_segments(scene).is_empty(), content="false")
  })
}

///|
test "editor scene runtime registers gameplay entities through custom components" {
  with_pixeladventure_test_asset_io(fn() raise {
    with_pixeladventure_test_world(fn() raise {
      reset_pixeladventure_world_store()
      let scene = pixeladventure_startup_scene_document()
      let loaded = load_level_scene()
      inspect(
        players().to_array().length() ==
        scene_component_count_for_compare(
          scene, pixeladventure_player_component_kind,
        ),
        content="true",
      )
      inspect(
        birds().to_array().length() ==
        scene_component_count_for_compare(
          scene, pixeladventure_bird_component_kind,
        ),
        content="true",
      )
      inspect(
        apples().to_array().length() ==
        scene_component_count_for_compare(
          scene, pixeladventure_apple_component_kind,
        ),
        content="true",
      )
      inspect(
        flags().to_array().length() ==
        scene_component_count_for_compare(
          scene, pixeladventure_flag_component_kind,
        ),
        content="true",
      )
      let runtime_flags = flags().to_array()
      inspect(runtime_flags.length() > 0, content="true")
      let flag_entity = runtime_flags[0].0
      let flag_sprite = @sprite.sprites().get(flag_entity).unwrap()
      inspect(
        flag_sprite.image.bind(@asset.image_path) ==
        Some(
          "assets/pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
        ),
        content="true",
      )
      inspect(
        match flag_sprite.texture_atlas {
          Some(atlas) =>
            match @sprite.texture_atlas_layout(atlas.layout) {
              Some(layout) => layout.rects.length() == 10
              None => false
            }
          None => false
        },
        content="true",
      )
      inspect(
        @animation.animation_players().get(flag_entity) is Some(_),
        content="true",
      )
      let expected_world_size = expected_scene_world_size()
      inspect(
        loaded.world_size[@math.X] == expected_world_size[@math.X] &&
        loaded.world_size[@math.Y] == expected_world_size[@math.Y],
        content="true",
      )
      inspect(
        @transform.transforms().get(loaded.player_entity).unwrap().translation.z ==
        PLAYER_Z,
        content="true",
      )
      inspect(
        @transform.transforms().get(loaded.camera_entity) is Some(_),
        content="true",
      )
    })
  })
}
