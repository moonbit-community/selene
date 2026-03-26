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
fn legacy_tilemap_for_compare() -> TileMap {
  TileMap::from_json(tilemap)
}

///|
fn legacy_world_size() -> @math.Vec2D {
  let map = legacy_tilemap_for_compare()
  @math.Vec2D(
    map.map_width.to_double() * map.tile_size.to_double(),
    map.map_height.to_double() * map.tile_size.to_double(),
  )
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
fn legacy_terrain_segments() -> Array[String] {
  let rows : Map[Int, Array[Int]] = {}
  for tile in legacy_tilemap_for_compare().get_tiles("Grass") {
    rows.get_or_init(tile.y, fn() { [] }).push(tile.x)
  }
  collapse_terrain_rows(rows)
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
      segments.push(
        "\{y}:\{start_x}:\{end_x - start_x + 1}",
      )
    }
  }
  segments.sort()
  segments
}

///|
test "editor scene placement matches legacy tilemap counts" {
  let scene = pixeladventure_startup_scene_document()
  inspect(
    scene_component_count_for_compare(
      scene,
      pixeladventure_player_component_kind,
    ) == legacy_tilemap_for_compare().get_tiles_first("MaskDude").length(),
    content="true",
  )
  inspect(
    scene_component_count_for_compare(
      scene,
      pixeladventure_flag_component_kind,
    ) == legacy_tilemap_for_compare().get_tiles_first("Flag").length(),
    content="true",
  )
  inspect(
    scene_component_count_for_compare(
      scene,
      pixeladventure_apple_component_kind,
    ) == legacy_tilemap_for_compare().get_tiles_first("Apple").length(),
    content="true",
  )
  inspect(
    scene_component_count_for_compare(
      scene,
      pixeladventure_bird_component_kind,
    ) == legacy_tilemap_for_compare().get_tiles_first("Bird").length(),
    content="true",
  )
  inspect(
    scene_component_count_for_compare(
      scene,
      pixeladventure_terrain_component_kind,
    ) == legacy_tilemap_for_compare().get_tiles("Grass").length(),
    content="true",
  )
}

///|
test "scene terrain collider coverage matches legacy tilemap" {
  let scene = pixeladventure_startup_scene_document()
  inspect(
    scene_terrain_segments(scene) == legacy_terrain_segments(),
    content="true",
  )
}

///|
test "editor scene runtime registers gameplay entities through custom components" {
  with_pixeladventure_test_world(fn () raise {
    reset_pixeladventure_world_store()
    let loaded = load_level_scene()
    inspect(players().to_array().length() == 1, content="true")
    inspect(
      birds().to_array().length() ==
        legacy_tilemap_for_compare().get_tiles_first("Bird").length(),
      content="true",
    )
    inspect(
      apples().to_array().length() ==
        legacy_tilemap_for_compare().get_tiles_first("Apple").length(),
      content="true",
    )
    inspect(flags().to_array().length() == 1, content="true")
    inspect(
      loaded.world_size.to_string(),
      content=legacy_world_size().to_string(),
    )
    inspect(
      @transform.transforms().get(loaded.player_entity).unwrap().translation.z == PLAYER_Z,
      content="true",
    )
    inspect(
      @transform.transforms().get(loaded.camera_entity) is Some(_),
      content="true",
    )
  })
}
