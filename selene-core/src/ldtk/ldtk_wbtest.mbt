///|
fn ascii_bytes(source : String) -> Bytes {
  let bytes : Array[Byte] = []
  for ch in source.to_array() {
    let code = ch.to_int()
    bytes.push((code & 0xFF).to_byte())
    bytes.push((code >> 8).to_byte())
  }
  Bytes::from_array(bytes[:])
}

///|
fn with_fake_asset_io(
  files : Map[String, Bytes],
  body : () -> Unit raise,
) -> Unit raise {
  @asset.set_io(fn(path) { files.get(path) })
  body()
  @asset.set_io(fn(_path) { None })
}

///|
fn reset_ldtk_runtime() -> Unit {
  for pair in ldtk_world_instances().to_array() {
    ldtk_world_instances().remove(pair.0)
  }
  for pair in ldtk_level_instances().to_array() {
    ldtk_level_instances().remove(pair.0)
  }
  for pair in ldtk_layer_metadata().to_array() {
    ldtk_layer_metadata().remove(pair.0)
  }
  for pair in ldtk_level_backgrounds().to_array() {
    ldtk_level_backgrounds().remove(pair.0)
  }
  for pair in ldtk_level_iids().to_array() {
    ldtk_level_iids().remove(pair.0)
  }
  for pair in ldtk_entity_iids().to_array() {
    ldtk_entity_iids().remove(pair.0)
  }
  for pair in ldtk_grid_coords().to_array() {
    ldtk_grid_coords().remove(pair.0)
  }
  for pair in ldtk_int_grid_cells().to_array() {
    let entity = pair.0
    @physics2d.areas().remove(entity)
    @physics2d.colliders().remove(entity)
    @physics2d.shapes().remove(entity)
    @physics2d.rigid_bodies().remove(entity)
    ldtk_int_grid_cells().remove(entity)
  }
  for pair in ldtk_tile_metadata().to_array() {
    ldtk_tile_metadata().remove(pair.0)
  }
  for pair in ldtk_int_grid_colliders().to_array() {
    let entity = pair.0
    @physics2d.areas().remove(entity)
    @physics2d.colliders().remove(entity)
    @physics2d.shapes().remove(entity)
    @physics2d.rigid_bodies().remove(entity)
    ldtk_int_grid_colliders().remove(entity)
  }
  for pair in ldtk_worldly_entities().to_array() {
    ldtk_worldly_entities().remove(pair.0)
  }
  for pair in ldtk_respawns().to_array() {
    ldtk_respawns().remove(pair.0)
  }
  for pair in ldtk_spawned_layer_instances().to_array() {
    ldtk_spawned_layer_instances().remove(pair.0)
  }
  for pair in ldtk_spawned_tile_instances().to_array() {
    ldtk_spawned_tile_instances().remove(pair.0)
  }
  for pair in ldtk_spawned_entity_instances().to_array() {
    ldtk_spawned_entity_instances().remove(pair.0)
  }
  for pair in ldtk_spawned_int_grid_cells().to_array() {
    ldtk_spawned_int_grid_cells().remove(pair.0)
  }
  for pair in ldtk_pending_transformed_level_iids().to_array() {
    ldtk_pending_transformed_level_iids().remove(pair.0)
  }
  for pair in ldtk_entity_spawn_hooks().to_array() {
    ldtk_entity_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_entity_layer_spawn_hooks().to_array() {
    ldtk_entity_layer_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_entity_layer_identifier_spawn_hooks().to_array() {
    ldtk_entity_layer_identifier_spawn_hooks().remove(pair.0)
  }
  ldtk_entity_default_spawn_hook().val = None
  for pair in ldtk_int_grid_layer_spawn_hooks().to_array() {
    ldtk_int_grid_layer_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_int_grid_cell_spawn_hooks().to_array() {
    ldtk_int_grid_cell_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_int_grid_value_spawn_hooks().to_array() {
    ldtk_int_grid_value_spawn_hooks().remove(pair.0)
  }
  ldtk_int_grid_default_spawn_hook().val = None
  for pair in ldtk_entity_typed_registrations().to_array() {
    ldtk_entity_typed_registrations().remove(pair.0)
  }
  for pair in ldtk_int_cell_typed_registrations().to_array() {
    ldtk_int_cell_typed_registrations().remove(pair.0)
  }
  ldtk_world_spawned_event_bus.clear()
  ldtk_level_spawned_event_bus.clear()
  ldtk_layer_spawned_event_bus.clear()
  ldtk_tile_spawned_event_bus.clear()
  ldtk_entity_spawned_event_bus.clear()
  ldtk_int_grid_cell_spawned_event_bus.clear()
  ldtk_int_grid_collider_spawned_event_bus.clear()
  ldtk_level_event_bus.clear()
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_int_grid_physics_settings(default_ldtk_int_grid_physics_settings())
  set_ldtk_level_selection(default_ldtk_level_selection())
}

///|
fn cleanup_ldtk_entity(entity : @entity.Entity) -> Unit {
  if entity.is_alive() {
    despawn_ldtk_tree(entity)
  }
  @entity.entity_flush_system(0.0)
  reset_ldtk_runtime()
}

///|
fn json_literal(source : String) -> Json {
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  parsed.unwrap()
}

///|
fn test_entity_layer_with_identifier(
  identifier : String,
  entity_instances : Array[LdtkEntityInstance],
) -> LdtkLayerInstance {
  {
    iid: "layer-\{identifier}",
    identifier,
    layer_type: "Entities",
    level_id: 1,
    layer_def_uid: 0,
    c_wid: 4,
    c_hei: 4,
    grid_size: 16,
    opacity: 1.0,
    visible: true,
    optional_rules: [],
    override_tileset_uid: None,
    px_offset_x: 0,
    px_offset_y: 0,
    px_total_offset_x: 0,
    px_total_offset_y: 0,
    seed: 0,
    tileset_def_uid: None,
    tileset_rel_path: None,
    int_grid_csv: [],
    auto_layer_tiles: [],
    grid_tiles: [],
    entity_instances,
  }
}

///|
fn test_entity_layer(
  entity_instances : Array[LdtkEntityInstance],
) -> LdtkLayerInstance {
  test_entity_layer_with_identifier("Entities", entity_instances)
}

///|
fn test_project_with_layers(
  level_iid : String,
  layer_instances : Array[LdtkLayerInstance],
) -> LdtkProject {
  {
    source_path: None,
    external_levels: false,
    world_layout: None,
    bg_color: None,
    default_level_width: Some(4),
    default_level_height: Some(4),
    defs: empty_ldtk_project_definitions(),
    levels: [
      {
        ..empty_ldtk_level(),
        identifier: "Main",
        iid: level_iid,
        uid: 1,
        layer_instances,
      },
    ],
    worlds: [],
  }
}

///|
fn test_int_grid_layer(
  identifier : String,
  c_wid : Int,
  c_hei : Int,
  int_grid_csv : Array[Int],
) -> LdtkLayerInstance {
  {
    iid: "layer-int-\{identifier}",
    identifier,
    layer_type: "IntGrid",
    level_id: 1,
    layer_def_uid: 0,
    c_wid,
    c_hei,
    grid_size: 16,
    opacity: 1.0,
    visible: true,
    optional_rules: [],
    override_tileset_uid: None,
    px_offset_x: 0,
    px_offset_y: 0,
    px_total_offset_x: 0,
    px_total_offset_y: 0,
    seed: 0,
    tileset_def_uid: None,
    tileset_rel_path: None,
    int_grid_csv,
    auto_layer_tiles: [],
    grid_tiles: [],
    entity_instances: [],
  }
}

///|
fn count_transformed_events(
  events : Array[LdtkLevelEvent],
  iid : String,
) -> Int {
  let mut count = 0
  for event in events {
    match event {
      Transformed(event_iid) => if event_iid == iid { count += 1 }
      _ => ()
    }
  }
  count
}

///|
fn spawned_entity_by_iid_in_level(
  iid : String,
  level_entity : @entity.Entity,
) -> @entity.Entity? {
  for pair in ldtk_spawned_entity_instances().to_array() {
    let runtime = pair.1
    if runtime.instance.iid == iid && runtime.level_entity == level_entity {
      return Some(pair.0)
    }
  }
  None
}

///|
fn worldly_count(world_entity : @entity.Entity) -> Int {
  let mut count = 0
  for pair in ldtk_worldly_entities().to_array() {
    if pair.1.world_entity == world_entity {
      count += 1
    }
  }
  count
}

///|
fn level_background_count(level_iid : String) -> Int {
  let mut count = 0
  for pair in ldtk_level_backgrounds().to_array() {
    if pair.1.level_iid == level_iid {
      count += 1
    }
  }
  count
}

///|
fn level_background_image_count(level_iid : String) -> Int {
  let mut count = 0
  for pair in ldtk_level_backgrounds().to_array() {
    if pair.1.level_iid == level_iid && pair.1.rel_path is Some(_) {
      count += 1
    }
  }
  count
}

///|
test "load_ldtk_project parses level selection and neighbor set" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":false,\"levels\":[{\"identifier\":\"A\",\"iid\":\"iid-a\",\"uid\":1,\"worldX\":12,\"worldY\":34,\"pxWid\":320,\"pxHei\":240,\"__neighbours\":[{\"levelIid\":\"iid-b\"}],\"layerInstances\":[]},{\"identifier\":\"B\",\"iid\":\"iid-b\",\"uid\":2,\"worldX\":512,\"worldY\":34,\"pxWid\":320,\"pxHei\":240,\"__neighbours\":[],\"layerInstances\":[]}],\"defs\":{\"tilesets\":[]}}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    inspect(project.levels.length(), content="2")
    inspect(
      project.find_level_by_selection(Identifier("A")).unwrap().level.iid,
      content="iid-a",
    )
    let level_set = project.level_set_for_selection(
      ldtk_level_selection_index(0),
      UseWorldTranslation(true),
    )
    inspect(level_set.iids.length(), content="2")
    inspect(level_set.contains("iid-a"), content="true")
    inspect(level_set.contains("iid-b"), content="true")
  })
}

///|
test "load_ldtk_project resolves external level files" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":true,\"levels\":[{\"identifier\":\"Root\",\"iid\":\"iid-root\",\"uid\":100,\"worldX\":0,\"worldY\":0,\"pxWid\":320,\"pxHei\":240,\"externalRelPath\":\"external/level-root.ldtkl\",\"layerInstances\":[]}],\"defs\":{\"tilesets\":[]}}",
    ),
  )
  files.set(
    "levels/external/level-root.ldtkl",
    ascii_bytes(
      "{\"identifier\":\"RootExternal\",\"iid\":\"iid-root\",\"uid\":100,\"worldX\":64,\"worldY\":96,\"pxWid\":320,\"pxHei\":240,\"layerInstances\":[{\"iid\":\"layer-a\",\"__identifier\":\"Tiles\",\"__type\":\"Tiles\",\"__gridSize\":16,\"__cWid\":20,\"__cHei\":15,\"visible\":true,\"intGridCsv\":[],\"autoLayerTiles\":[],\"gridTiles\":[],\"entityInstances\":[]}]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    let level = project.levels[0]
    inspect(level.identifier, content="RootExternal")
    inspect(level.world_x, content="64")
    inspect(level.layer_instances.length(), content="1")
    inspect(level.layer_instances[0].identifier, content="Tiles")
    let raw_level = project.raw_level_by_iid("iid-root").unwrap()
    inspect(raw_level.identifier, content="Root")
    inspect(raw_level.world_x, content="0")
    inspect(raw_level.layer_instances.length(), content="0")
    inspect(
      project
      .raw_find_level_by_selection(ldtk_level_selection_iid("iid-root"))
      .unwrap().level.identifier,
      content="Root",
    )
  })
}

///|
test "load_ldtk_project parses defs entities enums and typed entity field helpers" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":false,\"defs\":{\"tilesets\":[],\"layers\":[],\"entities\":[{\"uid\":10,\"identifier\":\"Enemy\",\"width\":16,\"height\":24,\"color\":\"#ff00ff\",\"tags\":[\"hostile\"],\"fieldDefs\":[{\"uid\":101,\"identifier\":\"Target\",\"type\":\"EntityRef\",\"canBeNull\":true}]}],\"enums\":[{\"uid\":20,\"identifier\":\"EnemyState\",\"values\":[{\"id\":\"Idle\",\"color\":\"#ffffff\"},{\"id\":\"Run\",\"color\":\"#00ff00\"}]}]},\"levels\":[{\"identifier\":\"Main\",\"iid\":\"level-main\",\"uid\":1,\"worldX\":0,\"worldY\":0,\"pxWid\":64,\"pxHei\":64,\"layerInstances\":[{\"iid\":\"layer-entities\",\"__identifier\":\"Entities\",\"__type\":\"Entities\",\"__gridSize\":16,\"__cWid\":4,\"__cHei\":4,\"visible\":true,\"intGridCsv\":[],\"autoLayerTiles\":[],\"gridTiles\":[],\"entityInstances\":[{\"iid\":\"enemy-1\",\"__identifier\":\"Enemy\",\"defUid\":10,\"width\":16,\"height\":16,\"px\":[16,16],\"__grid\":[1,1],\"__pivot\":[0,0],\"fieldInstances\":[{\"__identifier\":\"HP\",\"__type\":\"Int\",\"__value\":3},{\"__identifier\":\"Speed\",\"__type\":\"Float\",\"__value\":1.5},{\"__identifier\":\"Spawn\",\"__type\":\"Point\",\"__value\":[5,6]},{\"__identifier\":\"Checkpoints\",\"__type\":\"Array<Int>\",\"__value\":[1,2,3]},{\"__identifier\":\"Tags\",\"__type\":\"Array<String>\",\"__value\":[\"a\",\"b\"]},{\"__identifier\":\"Flags\",\"__type\":\"Array<Bool>\",\"__value\":[true,false,1,\"true\"]},{\"__identifier\":\"Target\",\"__type\":\"EntityRef\",\"__value\":{\"entityIid\":\"enemy-2\"}},{\"__identifier\":\"Targets\",\"__type\":\"Array<EntityRef>\",\"__value\":[{\"entityIid\":\"enemy-2\"},{\"entityIid\":\"enemy-3\"}]}]}]}]}],\"worlds\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    inspect(project.defs.entities.length(), content="1")
    inspect(project.defs.enums.length(), content="1")
    inspect(
      project.entity_definition_by_identifier("Enemy") is Some(_),
      content="true",
    )
    inspect(project.entity_definition_by_uid(10) is Some(_), content="true")
    inspect(
      project.enum_definition_by_identifier("EnemyState").unwrap().values.length(),
      content="2",
    )
    inspect(
      project.enum_definition_by_uid(20).unwrap().values[1].id,
      content="Run",
    )
    let entity = project.levels[0].layer_instances[0].entity_instances[0]
    inspect(entity.field_int("HP").unwrap(), content="3")
    inspect(entity.field_number("Speed").unwrap(), content="1.5")
    inspect(entity.field_vec2("Spawn").unwrap(), content="Vec2D(5, 6)")
    inspect(
      entity.field_int_array("Checkpoints").unwrap().length(),
      content="3",
    )
    inspect(entity.field_string_array("Tags").unwrap()[0], content="a")
    inspect(entity.field_bool_array("Flags").unwrap().length(), content="4")
    inspect(entity.field_bool_array("Flags").unwrap()[2], content="true")
    inspect(entity.field_entity_iid("Target").unwrap(), content="enemy-2")
    inspect(entity.field_entity_iids("Targets").unwrap().length(), content="2")
    inspect(entity.field_entity_iids("Targets").unwrap()[1], content="enemy-3")
  })
}

///|
test "load_ldtk_project parses entity instance tags" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":false,\"defs\":{\"tilesets\":[]},\"levels\":[{\"identifier\":\"Main\",\"iid\":\"level-main\",\"uid\":1,\"worldX\":0,\"worldY\":0,\"pxWid\":64,\"pxHei\":64,\"layerInstances\":[{\"iid\":\"layer-entities\",\"__identifier\":\"Entities\",\"__type\":\"Entities\",\"__gridSize\":16,\"__cWid\":4,\"__cHei\":4,\"visible\":true,\"intGridCsv\":[],\"autoLayerTiles\":[],\"gridTiles\":[],\"entityInstances\":[{\"iid\":\"enemy-1\",\"__identifier\":\"Enemy\",\"defUid\":10,\"width\":16,\"height\":16,\"px\":[16,16],\"__grid\":[1,1],\"__pivot\":[0,0],\"__tags\":[\"Hostile\",\"Flying\"],\"fieldInstances\":[]}]}]}],\"worlds\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    let entity = project.levels[0].layer_instances[0].entity_instances[0]
    inspect(entity.tags.length(), content="2")
    inspect(entity.tags[0], content="Hostile")
    inspect(entity.has_tag("Flying"), content="true")
    inspect(entity.has_tag("Boss"), content="false")
  })
}

///|
test "load_ldtk_project parses advanced field helpers for level and entity" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":false,\"defs\":{\"tilesets\":[],\"layers\":[],\"entities\":[{\"uid\":10,\"identifier\":\"Enemy\",\"fieldDefs\":[{\"uid\":1,\"identifier\":\"Mood\",\"type\":\"LocalEnum.Mood\"}]}],\"enums\":[],\"externalEnums\":[{\"uid\":30,\"identifier\":\"WeatherState\",\"values\":[{\"id\":\"Sunny\",\"color\":\"#ffff00\"},{\"id\":\"Rainy\",\"color\":\"#0099ff\"}]}]},\"levels\":[{\"identifier\":\"Main\",\"iid\":\"level-main\",\"uid\":1,\"worldX\":0,\"worldY\":0,\"pxWid\":64,\"pxHei\":64,\"fieldInstances\":[{\"__identifier\":\"Weather\",\"__type\":\"ExternEnum.WeatherState\",\"defUid\":200,\"__value\":\"Rainy\"},{\"__identifier\":\"Tint\",\"__type\":\"Color\",\"defUid\":201,\"__value\":\"#123456\"},{\"__identifier\":\"Refs\",\"__type\":\"Array<EntityRef>\",\"defUid\":202,\"__value\":[{\"entityIid\":\"enemy-1\",\"levelIid\":\"level-main\"},{\"entityIid\":\"enemy-2\",\"levelIid\":\"level-main\"}]},{\"__identifier\":\"Tiles\",\"__type\":\"Array<Tile>\",\"defUid\":203,\"__value\":[{\"tilesetUid\":7,\"x\":0,\"y\":16,\"w\":16,\"h\":16}]},{\"__identifier\":\"SpawnPoints\",\"__type\":\"Array<Point>\",\"defUid\":204,\"__value\":[[1,2],{\"cx\":3,\"cy\":4}]},{\"__identifier\":\"Weights\",\"__type\":\"Array<Float>\",\"defUid\":205,\"__value\":[1.25,2]}],\"layerInstances\":[{\"iid\":\"layer-entities\",\"__identifier\":\"Entities\",\"__type\":\"Entities\",\"__gridSize\":16,\"__cWid\":4,\"__cHei\":4,\"visible\":true,\"intGridCsv\":[],\"autoLayerTiles\":[],\"gridTiles\":[],\"entityInstances\":[{\"iid\":\"enemy-1\",\"__identifier\":\"Enemy\",\"defUid\":10,\"width\":16,\"height\":16,\"px\":[16,16],\"__grid\":[1,1],\"__pivot\":[0,0],\"fieldInstances\":[{\"__identifier\":\"Mood\",\"__type\":\"LocalEnum.Mood\",\"defUid\":1,\"__value\":\"Happy\"},{\"__identifier\":\"Palette\",\"__type\":\"Array<Color>\",\"defUid\":2,\"__value\":[\"#aabbcc\",\"#112233\"]},{\"__identifier\":\"Asset\",\"__type\":\"FilePath\",\"defUid\":3,\"__value\":\"assets/enemy.png\"},{\"__identifier\":\"Marker\",\"__type\":\"Tile\",\"defUid\":4,\"__value\":{\"tilesetUid\":7,\"x\":32,\"y\":16,\"w\":16,\"h\":16}},{\"__identifier\":\"TargetRef\",\"__type\":\"EntityRef\",\"defUid\":5,\"__value\":{\"entityIid\":\"enemy-2\",\"levelIid\":\"level-main\",\"worldIid\":\"world-1\",\"layerIid\":\"layer-entities\"}},{\"__identifier\":\"FloatList\",\"__type\":\"Array<Float>\",\"defUid\":6,\"__value\":[0.5,2]},{\"__identifier\":\"Path\",\"__type\":\"Array<Point>\",\"defUid\":7,\"__value\":[[4,5],{\"x\":6,\"y\":7}]}]}]}]}],\"worlds\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    inspect(project.defs.external_enums.length(), content="1")
    inspect(
      project.external_enum_definition_by_identifier("WeatherState").unwrap().values[1].id,
      content="Rainy",
    )
    inspect(
      project.external_enum_definition_by_uid(30).unwrap().identifier,
      content="WeatherState",
    )

    let level = project.levels[0]
    inspect(level.field_enum("Weather").unwrap(), content="Rainy")
    inspect(level.field_color("Tint").unwrap(), content="#123456")
    inspect(level.field_entity_iids("Refs").unwrap().length(), content="2")
    inspect(level.field_entity_iids("Refs").unwrap()[1], content="enemy-2")
    inspect(
      level.field_tiles("Tiles").unwrap()[0].tileset_uid.unwrap(),
      content="7",
    )
    inspect(
      level.field_vec2_array("SpawnPoints").unwrap()[1],
      content="Vec2D(3, 4)",
    )
    inspect(level.field_number_array("Weights").unwrap()[0], content="1.25")

    let entity = level.layer_instances[0].entity_instances[0]
    inspect(entity.field("Mood").unwrap().def_uid.unwrap(), content="1")
    inspect(entity.field_enum("Mood").unwrap(), content="Happy")
    inspect(entity.field_color_array("Palette").unwrap()[1], content="#112233")
    inspect(
      entity.field_file_path("Asset").unwrap(),
      content="assets/enemy.png",
    )
    inspect(entity.field_tile("Marker").unwrap().x, content="32")
    inspect(entity.field_tiles("Marker").unwrap()[0].h, content="16")
    inspect(entity.field_number_array("FloatList").unwrap()[1], content="2")
    inspect(entity.field_vec2_array("Path").unwrap()[1], content="Vec2D(6, 7)")
    let target_ref = entity.field_entity_ref("TargetRef").unwrap()
    inspect(target_ref.entity_iid.unwrap(), content="enemy-2")
    inspect(target_ref.level_iid.unwrap(), content="level-main")
    inspect(target_ref.world_iid.unwrap(), content="world-1")
    inspect(target_ref.layer_iid.unwrap(), content="layer-entities")
    inspect(entity.field_entity_iid("TargetRef").unwrap(), content="enemy-2")
    inspect(
      entity.field_entity_refs("TargetRef").unwrap()[0].entity_iid.unwrap(),
      content="enemy-2",
    )
  })
}

///|
test "load_ldtk_project parses level background position" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "levels/world.ldtk",
    ascii_bytes(
      "{\"externalLevels\":false,\"defs\":{\"tilesets\":[]},\"levels\":[{\"identifier\":\"Main\",\"iid\":\"level-main\",\"uid\":1,\"worldX\":0,\"worldY\":0,\"pxWid\":64,\"pxHei\":32,\"__bgPos\":{\"cropRect\":[1,2,30,40],\"scale\":[1.5,2.0],\"topLeftPx\":[7,8]},\"layerInstances\":[]}]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let project = load_ldtk_project("levels/world.ldtk")
    let bg_pos = project.levels[0].bg_pos.unwrap()
    inspect(bg_pos.crop_x, content="1")
    inspect(bg_pos.crop_y, content="2")
    inspect(bg_pos.crop_width, content="30")
    inspect(bg_pos.crop_height, content="40")
    inspect(bg_pos.scale, content="Vec2D(1.5, 2)")
    inspect(bg_pos.top_left_px, content="Vec2D(7, 8)")
  })
}

///|
test "ldtk_world_sync_system updates spawned levels from selection" {
  reset_ldtk_runtime()
  let project : LdtkProject = {
    source_path: None,
    external_levels: false,
    world_layout: None,
    bg_color: None,
    default_level_width: None,
    default_level_height: None,
    defs: empty_ldtk_project_definitions(),
    levels: [
      {
        ..empty_ldtk_level(),
        identifier: "A",
        iid: "iid-a",
        uid: 1,
        world_x: 10,
        world_y: 20,
      },
      {
        ..empty_ldtk_level(),
        identifier: "B",
        iid: "iid-b",
        uid: 2,
        world_x: 110,
        world_y: 220,
      },
    ],
    worlds: [],
  }
  set_ldtk_settings({
    ..default_ldtk_settings(),
    level_spawn_behavior: UseWorldTranslation(false),
  })
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  inspect(ldtk_world_instances().contains(world), content="true")
  let world_instance = ldtk_world_instances().get(world).unwrap()
  inspect(world_instance.spawned_levels.contains("iid-a"), content="true")
  inspect(world_instance.spawned_levels.contains("iid-b"), content="false")
  let spawned_a = world_instance.spawned_levels.get("iid-a").unwrap()
  inspect(spawned_a.get_offset(), content="Vec2D(10, 20)")

  set_ldtk_level_selection(ldtk_level_selection_index(1))
  ldtk_world_sync_system(0.0)
  let updated = ldtk_world_instances().get(world).unwrap()
  inspect(updated.spawned_levels.contains("iid-a"), content="false")
  inspect(updated.spawned_levels.contains("iid-b"), content="true")
  let spawned_b = updated.spawned_levels.get("iid-b").unwrap()
  inspect(spawned_b.get_offset(), content="Vec2D(110, 220)")

  cleanup_ldtk_entity(world)
}

///|
test "spawn_ldtk_world spawns level backgrounds from bg color and image" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("levels/assets/bg.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("levels/world.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: None,
      default_level_height: None,
      defs: empty_ldtk_project_definitions(),
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          px_wid: 64,
          px_hei: 32,
          bg_color: Some("#112233"),
          bg_pos: Some({
            crop_x: 3.0,
            crop_y: 5.0,
            crop_width: 20.0,
            crop_height: 10.0,
            scale: @math.Vec2D(2.0, 3.0),
            top_left_px: @math.Vec2D(3.0, 5.0),
          }),
          bg_rel_path: Some("assets/bg.png"),
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    inspect(level_background_count("level-main"), content="2")
    inspect(level_background_image_count("level-main"), content="1")
    inspect(ldtk_level_backgrounds().to_array().length(), content="2")
    for pair in ldtk_level_backgrounds().to_array() {
      inspect(@sprite.sprites().contains(pair.0), content="true")
    }
    let mut image_background_entity : @entity.Entity? = None
    for pair in ldtk_level_backgrounds().to_array() {
      if pair.1.level_iid == "level-main" && pair.1.rel_path is Some(_) {
        image_background_entity = Some(pair.0)
      }
    }
    let background_entity = image_background_entity.unwrap()
    let background_sprite = @sprite.sprites().get(background_entity).unwrap()
    match background_sprite.sprite_type {
      Animation(animation, frame=_) => {
        inspect(animation.frames[0].offset, content="Vec2D(3, 5)")
        inspect(animation.frames[0].size, content="Vec2D(20, 10)")
        let (scale_x, scale_y) = animation.transform.get_scale()
        inspect(scale_x, content="2")
        inspect(scale_y, content="3")
      }
      _ => fail("expected level background image to use animation sprite")
    }
    cleanup_ldtk_entity(world)
    inspect(ldtk_level_backgrounds().to_array().length(), content="0")
  })
}

///|
test "spawn_ldtk_world spawns layer tiles entities and intgrid cells" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let tile_layer : LdtkLayerInstance = {
      iid: "layer-tiles",
      identifier: "Tiles",
      layer_type: "Tiles",
      level_id: 1,
      layer_def_uid: 0,
      c_wid: 2,
      c_hei: 1,
      grid_size: 16,
      opacity: 1.0,
      visible: true,
      optional_rules: [],
      override_tileset_uid: None,
      px_offset_x: 0,
      px_offset_y: 0,
      px_total_offset_x: 0,
      px_total_offset_y: 0,
      seed: 0,
      tileset_def_uid: Some(1),
      tileset_rel_path: None,
      int_grid_csv: [],
      auto_layer_tiles: [],
      grid_tiles: [
        {
          tile_id: 0,
          src: @math.Vec2D::zero(),
          px: @math.Vec2D::zero(),
          flip_x: false,
          flip_y: false,
          alpha: 1.0,
          data: [],
        },
      ],
      entity_instances: [],
    }
    let int_grid_layer : LdtkLayerInstance = {
      iid: "layer-int",
      identifier: "Collision",
      layer_type: "IntGrid",
      level_id: 1,
      layer_def_uid: 0,
      c_wid: 2,
      c_hei: 1,
      grid_size: 16,
      opacity: 1.0,
      visible: true,
      optional_rules: [],
      override_tileset_uid: None,
      px_offset_x: 0,
      px_offset_y: 0,
      px_total_offset_x: 0,
      px_total_offset_y: 0,
      seed: 0,
      tileset_def_uid: None,
      tileset_rel_path: None,
      int_grid_csv: [1, 0],
      auto_layer_tiles: [],
      grid_tiles: [],
      entity_instances: [],
    }
    let entity_layer : LdtkLayerInstance = {
      iid: "layer-entities",
      identifier: "Entities",
      layer_type: "Entities",
      level_id: 1,
      layer_def_uid: 0,
      c_wid: 2,
      c_hei: 1,
      grid_size: 16,
      opacity: 1.0,
      visible: true,
      optional_rules: [],
      override_tileset_uid: None,
      px_offset_x: 0,
      px_offset_y: 0,
      px_total_offset_x: 0,
      px_total_offset_y: 0,
      seed: 0,
      tileset_def_uid: None,
      tileset_rel_path: None,
      int_grid_csv: [],
      auto_layer_tiles: [],
      grid_tiles: [],
      entity_instances: [
        {
          iid: "entity-1",
          identifier: "Enemy",
          def_uid: 1,
          width: 16,
          height: 16,
          px: @math.Vec2D(32.0, 16.0),
          grid: @math.Vec2D(2.0, 1.0),
          pivot: @math.Vec2D(0.5, 1.0),
          smart_color: Some("#ff0000"),
          tags: [],
          field_instances: [],
        },
      ],
    }
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(2),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 16,
            px_hei: 16,
            spacing: 0,
            padding: 0,
            custom_data: [],
            enum_tags: [],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [
          {
            uid: 10,
            identifier: "Collision",
            layer_type: Some("IntGrid"),
            int_grid_values: [
              { value: 1, color: Some("#00ff00"), identifier: Some("Solid") },
            ],
          },
        ],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [tile_layer, int_grid_layer, entity_layer],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    let world_instance = ldtk_world_instances().get(world).unwrap()
    let level_entity = world_instance.spawned_levels.get("level-main").unwrap()
    inspect(world_instance.spawned_levels.length(), content="1")
    inspect(ldtk_level_iids().contains(level_entity), content="true")
    inspect(
      ldtk_level_entity(world, "level-main").unwrap() == level_entity,
      content="true",
    )
    inspect(ldtk_spawned_layer_instances().to_array().length(), content="3")
    inspect(ldtk_spawned_tile_instances().to_array().length(), content="1")
    inspect(ldtk_spawned_int_grid_cells().to_array().length(), content="1")
    inspect(ldtk_spawned_entity_instances().to_array().length(), content="1")
    inspect(ldtk_entity_iids().to_array().length(), content="1")
    inspect(ldtk_tile_metadata().to_array().length(), content="1")
    inspect(ldtk_int_grid_cells().to_array().length(), content="1")
    inspect(ldtk_int_grid_colliders().to_array().length(), content="0")
    let tile_entity = ldtk_spawned_tile_instances().to_array()[0].0
    inspect(@sprite.sprites().contains(tile_entity), content="true")
    inspect(ldtk_tile_metadata().get(tile_entity).unwrap().tile_id, content="0")
    let int_grid_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
    inspect(@sprite.sprites().contains(int_grid_entity), content="true")
    inspect(
      ldtk_int_grid_cells().get(int_grid_entity).unwrap().value,
      content="1",
    )
    let spawned_enemy = ldtk_entity_by_iid(world, "entity-1").unwrap()
    inspect(
      ldtk_entity_iids().get(spawned_enemy).unwrap().iid,
      content="entity-1",
    )
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk tile source uses tileset spacing and padding" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(1),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 55,
            px_hei: 55,
            spacing: 2,
            padding: 1,
            custom_data: [],
            enum_tags: [],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [
            {
              iid: "layer-tiles",
              identifier: "Tiles",
              layer_type: "Tiles",
              level_id: 1,
              layer_def_uid: 0,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 1.0,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: Some(1),
              tileset_rel_path: None,
              int_grid_csv: [],
              auto_layer_tiles: [],
              grid_tiles: [
                {
                  tile_id: 4,
                  src: @math.Vec2D::zero(),
                  px: @math.Vec2D::zero(),
                  flip_x: false,
                  flip_y: false,
                  alpha: 1.0,
                  data: [],
                },
              ],
              entity_instances: [],
            },
          ],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    let tile_entity = ldtk_spawned_tile_instances().to_array()[0].0
    inspect(
      ldtk_tile_metadata().get(tile_entity).unwrap().src,
      content="Vec2D(19, 19)",
    )
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk tile render alpha multiplies layer opacity and tile alpha" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(1),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 16,
            px_hei: 16,
            spacing: 0,
            padding: 0,
            custom_data: [],
            enum_tags: [],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [
            {
              iid: "layer-tiles",
              identifier: "Tiles",
              layer_type: "Tiles",
              level_id: 1,
              layer_def_uid: 0,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 0.4,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: Some(1),
              tileset_rel_path: None,
              int_grid_csv: [],
              auto_layer_tiles: [],
              grid_tiles: [
                {
                  tile_id: 0,
                  src: @math.Vec2D::zero(),
                  px: @math.Vec2D::zero(),
                  flip_x: false,
                  flip_y: false,
                  alpha: 0.5,
                  data: [],
                },
              ],
              entity_instances: [],
            },
          ],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    let tile_entity = ldtk_spawned_tile_instances().to_array()[0].0
    let sprite = @sprite.sprites().get(tile_entity).unwrap()
    match sprite.sprite_type {
      Animation(animation, frame=_) => inspect(animation.color.a, content="0.2")
      _ => fail("expected animation sprite for LDtk tile")
    }
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk tileset custom data and enum tags resolve by tile id" {
  let project : LdtkProject = {
    source_path: None,
    external_levels: false,
    world_layout: None,
    bg_color: None,
    default_level_width: Some(1),
    default_level_height: Some(1),
    defs: {
      tilesets: [
        {
          uid: 1,
          identifier: "main",
          rel_path: Some("assets/tiles.png"),
          tile_grid_size: 16,
          px_wid: 32,
          px_hei: 32,
          spacing: 0,
          padding: 0,
          custom_data: [{ data: "spawn", tile_id: 4 }],
          enum_tags: [
            { enum_value_id: "Solid", tile_ids: [4, 7] },
            { enum_value_id: "Danger", tile_ids: [7] },
          ],
          tags: [],
          tags_source_enum_uid: None,
        },
      ],
      layers: [],
      entities: [],
      enums: [],
      external_enums: [],
    },
    levels: [],
    worlds: [],
  }
  inspect(project.tileset_tile_custom_data(1, 4).unwrap(), content="spawn")
  inspect(project.tileset_tile_custom_data(1, 3) is None, content="true")
  inspect(project.tileset_tile_enum_tags(1, 4).length(), content="1")
  inspect(project.tileset_tile_enum_tags(1, 4)[0], content="Solid")
  inspect(project.tileset_tile_enum_tags(1, 7).length(), content="2")
  inspect(project.tileset_tile_enum_tags(1, 7)[0], content="Solid")
  inspect(project.tileset_tile_enum_tags(1, 7)[1], content="Danger")
}

///|
test "ldtk spawned tile metadata includes custom data and enum tags" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(1),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 32,
            px_hei: 32,
            spacing: 0,
            padding: 0,
            custom_data: [{ data: "spawn", tile_id: 4 }],
            enum_tags: [{ enum_value_id: "Solid", tile_ids: [4] }],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [
            {
              iid: "layer-tiles",
              identifier: "Tiles",
              layer_type: "Tiles",
              level_id: 1,
              layer_def_uid: 0,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 1.0,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: Some(1),
              tileset_rel_path: None,
              int_grid_csv: [],
              auto_layer_tiles: [],
              grid_tiles: [
                {
                  tile_id: 4,
                  src: @math.Vec2D::zero(),
                  px: @math.Vec2D::zero(),
                  flip_x: false,
                  flip_y: false,
                  alpha: 1.0,
                  data: [],
                },
              ],
              entity_instances: [],
            },
          ],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    let tile_entity = ldtk_spawned_tile_instances().to_array()[0].0
    let metadata = ldtk_tile_metadata().get(tile_entity).unwrap()
    inspect(metadata.custom_data.unwrap(), content="spawn")
    inspect(metadata.enum_tags.length(), content="1")
    inspect(metadata.enum_tags[0], content="Solid")
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk entity spawn hook applies by identifier" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer([
      {
        iid: "entity-enemy",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-npc",
        identifier: "Npc",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 0.0),
        grid: @math.Vec2D(1.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  register_ldtk_entity_spawn_hook("Enemy", fn(event) {
    ldtk_respawns().set(event.entity, { requested: true })
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  let enemy = ldtk_entity_by_iid(world, "entity-enemy").unwrap()
  let npc = ldtk_entity_by_iid(world, "entity-npc").unwrap()
  inspect(ldtk_respawns().contains(enemy), content="true")
  inspect(ldtk_respawns().contains(npc), content="false")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk entity spawn hooks support layer and default scopes" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer_with_identifier("LayerA", [
      {
        iid: "entity-enemy-a",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-npc-a",
        identifier: "Npc",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 0.0),
        grid: @math.Vec2D(1.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
    test_entity_layer_with_identifier("LayerB", [
      {
        iid: "entity-enemy-b",
        identifier: "Enemy",
        def_uid: 3,
        width: 16,
        height: 16,
        px: @math.Vec2D(32.0, 0.0),
        grid: @math.Vec2D(2.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  let layer_identifier_hits = Ref::new(0)
  let layer_hits = Ref::new(0)
  let identifier_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_entity_spawn_hook_for_layer("LayerA", "Enemy", fn(_event) {
    layer_identifier_hits.val += 1
  })
  register_ldtk_entity_layer_spawn_hook("LayerA", fn(_event) {
    layer_hits.val += 1
  })
  register_ldtk_entity_spawn_hook("Enemy", fn(_event) {
    identifier_hits.val += 1
  })
  register_ldtk_entity_default_spawn_hook(fn(_event) { default_hits.val += 1 })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  inspect(layer_identifier_hits.val, content="1")
  inspect(layer_hits.val, content="2")
  inspect(identifier_hits.val, content="2")
  inspect(default_hits.val, content="3")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk entity optional hook registration routes by scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer_with_identifier("LayerA", [
      {
        iid: "entity-enemy-a",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-npc-a",
        identifier: "Npc",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 0.0),
        grid: @math.Vec2D(1.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  let scoped_hits = Ref::new(0)
  let layer_hits = Ref::new(0)
  let identifier_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_entity_spawn_hook_optional(Some("LayerA"), Some("Enemy"), fn(
    _event,
  ) {
    scoped_hits.val += 1
  })
  register_ldtk_entity_spawn_hook_optional(Some("LayerA"), None, fn(_event) {
    layer_hits.val += 1
  })
  register_ldtk_entity_spawn_hook_optional(None, Some("Enemy"), fn(_event) {
    identifier_hits.val += 1
  })
  register_ldtk_entity_spawn_hook_optional(None, None, fn(_event) {
    default_hits.val += 1
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  inspect(scoped_hits.val, content="1")
  inspect(layer_hits.val, content="2")
  inspect(identifier_hits.val, content="1")
  inspect(default_hits.val, content="2")

  unregister_ldtk_entity_spawn_hook_optional(Some("LayerA"), Some("Enemy"))
  unregister_ldtk_entity_spawn_hook_optional(Some("LayerA"), None)
  unregister_ldtk_entity_spawn_hook_optional(None, Some("Enemy"))
  unregister_ldtk_entity_spawn_hook_optional(None, None)
  inspect(
    ldtk_entity_layer_identifier_spawn_hooks().to_array().length(),
    content="0",
  )
  inspect(ldtk_entity_layer_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_entity_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_entity_default_spawn_hook().val is None, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk typed entity registrations use most specific scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer_with_identifier("LayerA", [
      {
        iid: "entity-enemy-a",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-npc-a",
        identifier: "Npc",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 0.0),
        grid: @math.Vec2D(1.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
    test_entity_layer_with_identifier("LayerB", [
      {
        iid: "entity-enemy-b",
        identifier: "Enemy",
        def_uid: 3,
        width: 16,
        height: 16,
        px: @math.Vec2D(32.0, 0.0),
        grid: @math.Vec2D(2.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  let scoped_hits = Ref::new(0)
  let identifier_hits = Ref::new(0)
  let layer_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_entity_for_layer("LayerA", "Enemy", fn(_event) {
    scoped_hits.val += 1
  })
  register_ldtk_entity("Enemy", fn(_event) { identifier_hits.val += 1 })
  register_default_ldtk_entity_for_layer("LayerA", fn(_event) {
    layer_hits.val += 1
  })
  register_default_ldtk_entity(fn(_event) { default_hits.val += 1 })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  inspect(scoped_hits.val, content="1")
  inspect(identifier_hits.val, content="1")
  inspect(layer_hits.val, content="1")
  inspect(default_hits.val, content="0")

  unregister_ldtk_entity_for_layer("LayerA", "Enemy")
  unregister_ldtk_entity("Enemy")
  unregister_default_ldtk_entity_for_layer("LayerA")
  unregister_default_ldtk_entity()
  inspect(ldtk_entity_typed_registrations().to_array().length(), content="0")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk add entity registration composes handlers in same scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer_with_identifier("LayerA", [
      {
        iid: "entity-enemy-a",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  let first_hits = Ref::new(0)
  let second_hits = Ref::new(0)
  add_ldtk_entity_registration_for_layer("LayerA", "Enemy", fn(_event) {
    first_hits.val += 1
  })
  add_ldtk_entity_registration_for_layer("LayerA", "Enemy", fn(_event) {
    second_hits.val += 1
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  inspect(first_hits.val, content="1")
  inspect(second_hits.val, content="1")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk add entity component helpers can build bundle-like sets" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer_with_identifier("LayerA", [
      {
        iid: "entity-enemy-a",
        identifier: "Enemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(0.0, 0.0),
        grid: @math.Vec2D(0.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-npc-a",
        identifier: "Npc",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 0.0),
        grid: @math.Vec2D(1.0, 0.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
    ]),
  ])
  let entity_scores : Map[@entity.Entity, Int] = Map::new()
  let entity_kinds : Map[@entity.Entity, String] = Map::new()

  add_ldtk_entity_component("Enemy", entity_scores, fn(_event) { 99 })
  add_ldtk_entity_component("Enemy", entity_kinds, fn(event) {
    event.instance.identifier
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let enemy = ldtk_entity_by_iid(world, "entity-enemy-a").unwrap()
  let npc = ldtk_entity_by_iid(world, "entity-npc-a").unwrap()
  inspect(entity_scores.get(enemy).unwrap(), content="99")
  inspect(entity_kinds.get(enemy).unwrap(), content="Enemy")
  inspect(entity_scores.get(npc) is None, content="true")
  inspect(entity_kinds.get(npc) is None, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid spawn hooks apply by layer and cell value" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 2, 1, [1, 2]),
  ])
  register_ldtk_int_grid_layer_spawn_hook("Collision", fn(event) {
    ldtk_int_grid_colliders().set(event.cell_entity, { sensor: false })
  })
  register_ldtk_int_grid_cell_spawn_hook("Collision", 2, fn(event) {
    ldtk_int_grid_colliders().set(event.cell_entity, { sensor: true })
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let mut cell_value_1 : @entity.Entity? = None
  let mut cell_value_2 : @entity.Entity? = None
  for pair in ldtk_spawned_int_grid_cells().to_array() {
    let cell_entity = pair.0
    let runtime = pair.1
    if runtime.value == 1 {
      cell_value_1 = Some(cell_entity)
    } else if runtime.value == 2 {
      cell_value_2 = Some(cell_entity)
    }
  }
  let value_1_entity = cell_value_1.unwrap()
  let value_2_entity = cell_value_2.unwrap()
  inspect(
    ldtk_int_grid_colliders().get(value_1_entity).unwrap().sensor,
    content="false",
  )
  inspect(
    ldtk_int_grid_colliders().get(value_2_entity).unwrap().sensor,
    content="true",
  )

  cleanup_ldtk_entity(world)
}

///|
test "ldtk typed int cell registrations use most specific scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 2, 1, [1, 2]),
    test_int_grid_layer("Water", 1, 1, [2]),
  ])
  let scoped_hits = Ref::new(0)
  let value_hits = Ref::new(0)
  let layer_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_int_cell_for_layer("Collision", 2, fn(_event) {
    scoped_hits.val += 1
  })
  register_ldtk_int_cell(2, fn(_event) { value_hits.val += 1 })
  register_default_ldtk_int_cell_for_layer("Collision", fn(_event) {
    layer_hits.val += 1
  })
  register_default_ldtk_int_cell(fn(_event) { default_hits.val += 1 })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  inspect(scoped_hits.val, content="1")
  inspect(value_hits.val, content="1")
  inspect(layer_hits.val, content="1")
  inspect(default_hits.val, content="0")

  unregister_ldtk_int_cell_for_layer("Collision", 2)
  unregister_ldtk_int_cell(2)
  unregister_default_ldtk_int_cell_for_layer("Collision")
  unregister_default_ldtk_int_cell()
  inspect(ldtk_int_cell_typed_registrations().to_array().length(), content="0")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk add int cell component helpers can compose per scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 2, 1, [1, 2]),
  ])
  let cell_labels : Map[@entity.Entity, String] = Map::new()
  let cell_values_x2 : Map[@entity.Entity, Int] = Map::new()

  add_ldtk_int_cell_component(2, cell_labels, fn(_event) { "solid" })
  add_ldtk_int_cell_component(2, cell_values_x2, fn(event) { event.value * 2 })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let mut value_1_entity : @entity.Entity? = None
  let mut value_2_entity : @entity.Entity? = None
  for pair in ldtk_spawned_int_grid_cells().to_array() {
    if pair.1.value == 1 {
      value_1_entity = Some(pair.0)
    } else if pair.1.value == 2 {
      value_2_entity = Some(pair.0)
    }
  }
  let cell_1 = value_1_entity.unwrap()
  let cell_2 = value_2_entity.unwrap()
  inspect(cell_labels.get(cell_2).unwrap(), content="solid")
  inspect(cell_values_x2.get(cell_2).unwrap(), content="4")
  inspect(cell_labels.get(cell_1) is None, content="true")
  inspect(cell_values_x2.get(cell_1) is None, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid optional hook registration routes by scope" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 2, 1, [1, 2]),
  ])
  let scoped_hits = Ref::new(0)
  let layer_hits = Ref::new(0)
  let value_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_int_grid_spawn_hook_optional(Some("Collision"), Some(2), fn(
    _event,
  ) {
    scoped_hits.val += 1
  })
  register_ldtk_int_grid_spawn_hook_optional(Some("Collision"), None, fn(
    _event,
  ) {
    layer_hits.val += 1
  })
  register_ldtk_int_grid_spawn_hook_optional(None, Some(2), fn(_event) {
    value_hits.val += 1
  })
  register_ldtk_int_grid_spawn_hook_optional(None, None, fn(_event) {
    default_hits.val += 1
  })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  inspect(scoped_hits.val, content="1")
  inspect(layer_hits.val, content="2")
  inspect(value_hits.val, content="1")
  inspect(default_hits.val, content="2")

  unregister_ldtk_int_grid_spawn_hook_optional(Some("Collision"), Some(2))
  unregister_ldtk_int_grid_spawn_hook_optional(Some("Collision"), None)
  unregister_ldtk_int_grid_spawn_hook_optional(None, Some(2))
  unregister_ldtk_int_grid_spawn_hook_optional(None, None)
  inspect(ldtk_int_grid_cell_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_layer_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_value_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_default_spawn_hook().val is None, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid spawn hooks support value and default scopes" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 2, 1, [1, 2]),
    test_int_grid_layer("Water", 2, 1, [1, 2]),
  ])
  let layer_hits = Ref::new(0)
  let cell_hits = Ref::new(0)
  let value_hits = Ref::new(0)
  let default_hits = Ref::new(0)

  register_ldtk_int_grid_layer_spawn_hook("Collision", fn(_event) {
    layer_hits.val += 1
  })
  register_ldtk_int_grid_cell_spawn_hook("Collision", 2, fn(_event) {
    cell_hits.val += 1
  })
  register_ldtk_int_grid_value_spawn_hook(2, fn(_event) { value_hits.val += 1 })
  register_ldtk_int_grid_default_spawn_hook(fn(_event) { default_hits.val += 1 })

  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  inspect(layer_hits.val, content="2")
  inspect(cell_hits.val, content="1")
  inspect(value_hits.val, content="2")
  inspect(default_hits.val, content="4")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk layer display order uses LDtk top-most first ordering" {
  reset_ldtk_runtime()
  let project : LdtkProject = {
    source_path: None,
    external_levels: false,
    world_layout: None,
    bg_color: None,
    default_level_width: Some(1),
    default_level_height: Some(1),
    defs: empty_ldtk_project_definitions(),
    levels: [
      {
        ..empty_ldtk_level(),
        identifier: "Main",
        iid: "level-main",
        uid: 1,
        layer_instances: [
          {
            iid: "layer-top",
            identifier: "Top",
            layer_type: "Entities",
            level_id: 1,
            layer_def_uid: 0,
            c_wid: 1,
            c_hei: 1,
            grid_size: 16,
            opacity: 1.0,
            visible: true,
            optional_rules: [],
            override_tileset_uid: None,
            px_offset_x: 0,
            px_offset_y: 0,
            px_total_offset_x: 0,
            px_total_offset_y: 0,
            seed: 0,
            tileset_def_uid: None,
            tileset_rel_path: None,
            int_grid_csv: [],
            auto_layer_tiles: [],
            grid_tiles: [],
            entity_instances: [],
          },
          {
            iid: "layer-bottom",
            identifier: "Bottom",
            layer_type: "Entities",
            level_id: 1,
            layer_def_uid: 0,
            c_wid: 1,
            c_hei: 1,
            grid_size: 16,
            opacity: 1.0,
            visible: true,
            optional_rules: [],
            override_tileset_uid: None,
            px_offset_x: 0,
            px_offset_y: 0,
            px_total_offset_x: 0,
            px_total_offset_y: 0,
            seed: 0,
            tileset_def_uid: None,
            tileset_rel_path: None,
            int_grid_csv: [],
            auto_layer_tiles: [],
            grid_tiles: [],
            entity_instances: [],
          },
        ],
      },
    ],
    worlds: [],
  }
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  let mut top_zindex = 0
  let mut bottom_zindex = 0
  for pair in ldtk_spawned_layer_instances().to_array() {
    let runtime = pair.1
    if runtime.layer.identifier == "Top" {
      top_zindex = runtime.zindex
    } else if runtime.layer.identifier == "Bottom" {
      bottom_zindex = runtime.zindex
    }
  }
  inspect(top_zindex > bottom_zindex, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid with tileset skips colorful fallback sprites" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(1),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 16,
            px_hei: 16,
            spacing: 0,
            padding: 0,
            custom_data: [],
            enum_tags: [],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [
          {
            uid: 10,
            identifier: "Collision",
            layer_type: Some("IntGrid"),
            int_grid_values: [
              { value: 1, color: Some("#00ff00"), identifier: Some("Solid") },
            ],
          },
        ],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [
            {
              iid: "layer-int",
              identifier: "Collision",
              layer_type: "IntGrid",
              level_id: 1,
              layer_def_uid: 10,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 1.0,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: Some(1),
              tileset_rel_path: None,
              int_grid_csv: [1],
              auto_layer_tiles: [
                {
                  tile_id: 0,
                  src: @math.Vec2D::zero(),
                  px: @math.Vec2D::zero(),
                  flip_x: false,
                  flip_y: false,
                  alpha: 1.0,
                  data: [],
                },
              ],
              grid_tiles: [
                {
                  tile_id: 1,
                  src: @math.Vec2D(16.0, 0.0),
                  px: @math.Vec2D::zero(),
                  flip_x: false,
                  flip_y: false,
                  alpha: 1.0,
                  data: [],
                },
              ],
              entity_instances: [],
            },
          ],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings(default_ldtk_settings())
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    let int_grid_cell = ldtk_spawned_int_grid_cells().to_array()[0].0
    inspect(@sprite.sprites().contains(int_grid_cell), content="false")
    inspect(ldtk_spawned_tile_instances().to_array().length(), content="2")
    let mut min_zindex = 999999
    let mut max_zindex = -999999
    for pair in ldtk_spawned_tile_instances().to_array() {
      let visual_tile = pair.0
      inspect(@sprite.sprites().contains(visual_tile), content="true")
      let zindex = pair.1.zindex
      if zindex < min_zindex {
        min_zindex = zindex
      }
      if zindex > max_zindex {
        max_zindex = zindex
      }
    }
    inspect(max_zindex > min_zindex, content="true")
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk settings intgrid invisible and layer exclusion apply at spawn" {
  reset_ldtk_runtime()
  let files : Map[String, Bytes] = Map::new()
  files.set("assets/tiles.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let project : LdtkProject = {
      source_path: Some("project.ldtk"),
      external_levels: false,
      world_layout: None,
      bg_color: None,
      default_level_width: Some(1),
      default_level_height: Some(1),
      defs: {
        tilesets: [
          {
            uid: 1,
            identifier: "main",
            rel_path: Some("assets/tiles.png"),
            tile_grid_size: 16,
            px_wid: 16,
            px_hei: 16,
            spacing: 0,
            padding: 0,
            custom_data: [],
            enum_tags: [],
            tags: [],
            tags_source_enum_uid: None,
          },
        ],
        layers: [
          {
            uid: 10,
            identifier: "Collision",
            layer_type: Some("IntGrid"),
            int_grid_values: [
              { value: 1, color: Some("#00ff00"), identifier: Some("Solid") },
            ],
          },
        ],
        entities: [],
        enums: [],
        external_enums: [],
      },
      levels: [
        {
          ..empty_ldtk_level(),
          identifier: "Main",
          iid: "level-main",
          uid: 1,
          layer_instances: [
            {
              iid: "layer-int",
              identifier: "Collision",
              layer_type: "IntGrid",
              level_id: 1,
              layer_def_uid: 0,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 1.0,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: None,
              tileset_rel_path: None,
              int_grid_csv: [1],
              auto_layer_tiles: [],
              grid_tiles: [],
              entity_instances: [],
            },
            {
              iid: "layer-entities",
              identifier: "Entities",
              layer_type: "Entities",
              level_id: 1,
              layer_def_uid: 0,
              c_wid: 1,
              c_hei: 1,
              grid_size: 16,
              opacity: 1.0,
              visible: true,
              optional_rules: [],
              override_tileset_uid: None,
              px_offset_x: 0,
              px_offset_y: 0,
              px_total_offset_x: 0,
              px_total_offset_y: 0,
              seed: 0,
              tileset_def_uid: None,
              tileset_rel_path: None,
              int_grid_csv: [],
              auto_layer_tiles: [],
              grid_tiles: [],
              entity_instances: [
                {
                  iid: "entity-1",
                  identifier: "Enemy",
                  def_uid: 1,
                  width: 16,
                  height: 16,
                  px: @math.Vec2D(0.0, 0.0),
                  grid: @math.Vec2D(0.0, 0.0),
                  pivot: @math.Vec2D::zero(),
                  smart_color: None,
                  tags: [],
                  field_instances: [],
                },
              ],
            },
          ],
        },
      ],
      worlds: [],
    }
    set_ldtk_settings({
      level_spawn_behavior: UseZeroTranslation,
      int_grid_rendering: Invisible,
      spawn_exclusions: { layer_identifiers: ["Entities"] },
    })
    set_ldtk_level_selection(ldtk_level_selection_index(0))
    let world = spawn_ldtk_world(project)
    inspect(ldtk_spawned_entity_instances().to_array().length(), content="0")
    inspect(ldtk_spawned_int_grid_cells().to_array().length(), content="1")
    let int_grid_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
    inspect(@sprite.sprites().contains(int_grid_entity), content="false")
    cleanup_ldtk_entity(world)
  })
}

///|
test "ldtk transformed event is emitted on next sync tick" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let reader = @event.EventReader::new()
  let world = spawn_ldtk_world(project)

  let immediate = ldtk_level_event_bus.read(reader)
  inspect(count_transformed_events(immediate, "level-main"), content="0")

  ldtk_world_sync_system(0.0)
  let after_sync = ldtk_level_event_bus.read(reader)
  inspect(count_transformed_events(after_sync, "level-main"), content="1")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk level respawn keeps worldly entities and respawns level entities" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer([
      {
        iid: "entity-local",
        identifier: "LocalEnemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(16.0, 16.0),
        grid: @math.Vec2D(1.0, 1.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [],
      },
      {
        iid: "entity-worldly",
        identifier: "WorldlyEnemy",
        def_uid: 2,
        width: 16,
        height: 16,
        px: @math.Vec2D(32.0, 16.0),
        grid: @math.Vec2D(2.0, 1.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [
          {
            identifier: "worldly",
            value_type: "Bool",
            value: Some(json_literal("true")),
            def_uid: None,
          },
        ],
      },
    ]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let world_instance = ldtk_world_instances().get(world).unwrap()
  let level_entity_before = world_instance.spawned_levels
    .get("level-main")
    .unwrap()
  let worldly_before = ldtk_worldly_entity(world, "entity-worldly").unwrap()
  let local_before = spawned_entity_by_iid_in_level(
    "entity-local", level_entity_before,
  ).unwrap()
  inspect(
    ldtk_entity_by_iid(world, "entity-worldly").unwrap() == worldly_before,
    content="true",
  )
  inspect(worldly_count(world), content="1")

  mark_ldtk_respawn(level_entity_before)
  ldtk_world_sync_system(0.0)

  let updated_world_instance = ldtk_world_instances().get(world).unwrap()
  let level_entity_after = updated_world_instance.spawned_levels
    .get("level-main")
    .unwrap()
  inspect(level_entity_after == level_entity_before, content="false")
  inspect(local_before.is_alive(), content="false")
  let local_after = spawned_entity_by_iid_in_level(
    "entity-local", level_entity_after,
  ).unwrap()
  inspect(local_after == local_before, content="false")
  inspect(
    ldtk_entity_by_iid(world, "entity-local").unwrap() == local_after,
    content="true",
  )
  let worldly_after = ldtk_worldly_entity(world, "entity-worldly").unwrap()
  inspect(worldly_after == worldly_before, content="true")
  inspect(
    ldtk_entity_by_iid(world, "entity-worldly").unwrap() == worldly_after,
    content="true",
  )
  inspect(worldly_count(world), content="1")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk world respawn recreates worldly entities" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_entity_layer([
      {
        iid: "entity-worldly",
        identifier: "WorldlyEnemy",
        def_uid: 1,
        width: 16,
        height: 16,
        px: @math.Vec2D(32.0, 16.0),
        grid: @math.Vec2D(2.0, 1.0),
        pivot: @math.Vec2D::zero(),
        smart_color: None,
        tags: [],
        field_instances: [
          {
            identifier: "worldly",
            value_type: "Bool",
            value: Some(json_literal("true")),
            def_uid: None,
          },
        ],
      },
    ]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let worldly_before = ldtk_worldly_entity(world, "entity-worldly").unwrap()
  inspect(worldly_count(world), content="1")

  mark_ldtk_respawn(world)
  ldtk_world_sync_system(0.0)

  let worldly_after = ldtk_worldly_entity(world, "entity-worldly").unwrap()
  inspect(worldly_after == worldly_before, content="false")
  inspect(worldly_before.is_alive(), content="false")
  inspect(
    ldtk_entity_by_iid(world, "entity-worldly").unwrap() == worldly_after,
    content="true",
  )
  inspect(worldly_count(world), content="1")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid physics spawns collider from matching cells" {
  reset_ldtk_runtime()
  let collider_reader = @event.EventReader::new()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 1, 1, [1]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_int_grid_physics_settings({
    ..default_ldtk_int_grid_physics_settings(),
    enabled: true,
    layer_identifiers: ["Collision"],
    values: [1],
  })
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let cell_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
  inspect(ldtk_int_grid_colliders().contains(cell_entity), content="true")
  inspect(@physics2d.colliders().contains(cell_entity), content="true")
  inspect(@physics2d.shapes().contains(cell_entity), content="true")
  inspect(@physics2d.areas().contains(cell_entity), content="false")
  let collider_events = ldtk_int_grid_collider_spawned_event_bus.read(
    collider_reader,
  )
  inspect(collider_events.length(), content="1")
  inspect(collider_events[0].sensor, content="false")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk intgrid physics supports sensor mode" {
  reset_ldtk_runtime()
  let collider_reader = @event.EventReader::new()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 1, 1, [1]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_int_grid_physics_settings({
    ..default_ldtk_int_grid_physics_settings(),
    enabled: true,
    as_sensor: true,
  })
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)

  let cell_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
  inspect(ldtk_int_grid_colliders().contains(cell_entity), content="true")
  inspect(@physics2d.areas().contains(cell_entity), content="true")
  inspect(@physics2d.shapes().contains(cell_entity), content="true")
  inspect(@physics2d.colliders().contains(cell_entity), content="false")
  let collider_events = ldtk_int_grid_collider_spawned_event_bus.read(
    collider_reader,
  )
  inspect(collider_events.length(), content="1")
  inspect(collider_events[0].sensor, content="true")

  cleanup_ldtk_entity(world)
}

///|
test "ldtk transformed remains delayed after level respawn" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let reader = @event.EventReader::new()
  let world = spawn_ldtk_world(project)

  ldtk_world_sync_system(0.0)
  let initial_events = ldtk_level_event_bus.read(reader)
  inspect(count_transformed_events(initial_events, "level-main"), content="1")

  let level_entity = ldtk_level_entity(world, "level-main").unwrap()
  mark_ldtk_respawn(level_entity)
  ldtk_world_sync_system(0.0)
  let respawn_tick_events = ldtk_level_event_bus.read(reader)
  inspect(
    count_transformed_events(respawn_tick_events, "level-main"),
    content="0",
  )

  ldtk_world_sync_system(0.0)
  let next_tick_events = ldtk_level_event_bus.read(reader)
  inspect(count_transformed_events(next_tick_events, "level-main"), content="1")

  cleanup_ldtk_entity(world)
}

///|
test "despawn_ldtk_tree clears pending transformed levels before sync" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let reader = @event.EventReader::new()
  let world = spawn_ldtk_world(project)

  inspect(
    ldtk_pending_transformed_level_iids().contains("level-main"),
    content="true",
  )
  let immediate_events = ldtk_level_event_bus.read(reader)
  inspect(count_transformed_events(immediate_events, "level-main"), content="0")

  despawn_ldtk_tree(world)
  @entity.entity_flush_system(0.0)
  inspect(
    ldtk_pending_transformed_level_iids().contains("level-main"),
    content="false",
  )

  ldtk_world_sync_system(0.0)
  let after_despawn_events = ldtk_level_event_bus.read(reader)
  inspect(
    count_transformed_events(after_despawn_events, "level-main"),
    content="0",
  )

  reset_ldtk_runtime()
}

///|
test "despawn_ldtk_tree clears intgrid runtime maps and physics components" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 1, 1, [1]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_int_grid_physics_settings({
    ..default_ldtk_int_grid_physics_settings(),
    enabled: true,
  })
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  let level_entity = ldtk_level_entity(world, "level-main").unwrap()
  let layer_entity = ldtk_spawned_layer_instances().to_array()[0].0
  let cell_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
  inspect(ldtk_int_grid_colliders().contains(cell_entity), content="true")
  inspect(@physics2d.colliders().contains(cell_entity), content="true")

  despawn_ldtk_tree(world)
  @entity.entity_flush_system(0.0)

  inspect(ldtk_world_instances().contains(world), content="false")
  inspect(ldtk_level_instances().contains(level_entity), content="false")
  inspect(ldtk_level_iids().contains(level_entity), content="false")
  inspect(ldtk_spawned_layer_instances().contains(layer_entity), content="false")
  inspect(ldtk_grid_coords().contains(cell_entity), content="false")
  inspect(ldtk_int_grid_cells().contains(cell_entity), content="false")
  inspect(ldtk_int_grid_colliders().contains(cell_entity), content="false")
  inspect(@physics2d.colliders().contains(cell_entity), content="false")
  inspect(@physics2d.shapes().contains(cell_entity), content="false")
  inspect(@physics2d.areas().contains(cell_entity), content="false")

  reset_ldtk_runtime()
}

///|
test "reset_ldtk_runtime clears runtime maps and intgrid physics components" {
  reset_ldtk_runtime()
  let project = test_project_with_layers("level-main", [
    test_int_grid_layer("Collision", 1, 1, [1]),
  ])
  set_ldtk_settings(default_ldtk_settings())
  set_ldtk_int_grid_physics_settings({
    ..default_ldtk_int_grid_physics_settings(),
    enabled: true,
  })
  set_ldtk_level_selection(ldtk_level_selection_index(0))
  let world = spawn_ldtk_world(project)
  let cell_entity = ldtk_spawned_int_grid_cells().to_array()[0].0
  inspect(@physics2d.colliders().contains(cell_entity), content="true")

  reset_ldtk_runtime()

  inspect(ldtk_world_instances().to_array().length(), content="0")
  inspect(ldtk_level_instances().to_array().length(), content="0")
  inspect(ldtk_layer_metadata().to_array().length(), content="0")
  inspect(ldtk_level_backgrounds().to_array().length(), content="0")
  inspect(ldtk_level_iids().to_array().length(), content="0")
  inspect(ldtk_entity_iids().to_array().length(), content="0")
  inspect(ldtk_grid_coords().to_array().length(), content="0")
  inspect(ldtk_int_grid_cells().to_array().length(), content="0")
  inspect(ldtk_tile_metadata().to_array().length(), content="0")
  inspect(ldtk_int_grid_colliders().to_array().length(), content="0")
  inspect(ldtk_worldly_entities().to_array().length(), content="0")
  inspect(ldtk_respawns().to_array().length(), content="0")
  inspect(ldtk_spawned_layer_instances().to_array().length(), content="0")
  inspect(ldtk_spawned_tile_instances().to_array().length(), content="0")
  inspect(ldtk_spawned_entity_instances().to_array().length(), content="0")
  inspect(ldtk_spawned_int_grid_cells().to_array().length(), content="0")
  inspect(ldtk_entity_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_entity_layer_spawn_hooks().to_array().length(), content="0")
  inspect(
    ldtk_entity_layer_identifier_spawn_hooks().to_array().length(),
    content="0",
  )
  inspect(ldtk_entity_default_spawn_hook().val is None, content="true")
  inspect(ldtk_int_grid_layer_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_cell_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_value_spawn_hooks().to_array().length(), content="0")
  inspect(ldtk_int_grid_default_spawn_hook().val is None, content="true")
  inspect(ldtk_entity_typed_registrations().to_array().length(), content="0")
  inspect(ldtk_int_cell_typed_registrations().to_array().length(), content="0")
  inspect(ldtk_pending_transformed_level_iids().to_array().length(), content="0")
  inspect(@physics2d.colliders().contains(cell_entity), content="false")
  inspect(@physics2d.shapes().contains(cell_entity), content="false")
  inspect(@physics2d.areas().contains(cell_entity), content="false")
  inspect(@physics2d.rigid_bodies().contains(cell_entity), content="false")

  cleanup_ldtk_entity(world)
}
