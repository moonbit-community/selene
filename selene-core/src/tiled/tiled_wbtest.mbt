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
fn cleanup_spawned_tiled_tree(root : @entity.Entity) -> Unit {
  despawn_tiled_tree(root)
  @entity.entity_flush_system(0.0)
}

///|
fn vec2_snapshot(vec : @math.Vec2) -> String {
  "\{vec[X].to_int()},\{vec[Y].to_int()}"
}

///|
fn tiled_test_set_entity_translation_2d(
  entity : @entity.Entity,
  position : @math.Vec2,
) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3::new(
      position[X],
      position[Y],
      current.translation.z,
    ),
  })
}

///|
fn tiled_test_entity_translation_2d(entity : @entity.Entity) -> @math.Vec2 {
  let transform = @transform.transforms().get(entity).unwrap_or_default()
  @math.Vec2(transform.translation.x, transform.translation.y)
}

///|
fn test_tileset_16x16() -> TiledTileset {
  {
    first_gid: 1,
    source: None,
    name: None,
    class_name: None,
    tile_width: Some(16),
    tile_height: Some(16),
    tile_count: Some(4),
    columns: Some(2),
    spacing: 0,
    margin: 0,
    image: Some("maps/terrain.png"),
    image_width: Some(32),
    image_height: Some(32),
    properties: [],
    tiles: [],
  }
}

///|
fn test_tile_cell(x : Int, y : Int) -> TiledCell {
  { x, y, gid: decode_tiled_gid(1) }
}

///|
fn animation_image_path(entity : @entity.Entity) -> String? {
  guard @sprite.sprites().get(entity) is Some(sprite) else { return None }
  let expected_image = @asset.load_image("maps/terrain.png")
  if sprite.image == Some(expected_image) {
    Some("maps/terrain.png")
  } else {
    None
  }
}

///|
test "load_tiled_map resolves external JSON tilesets" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/demo.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[{\"firstgid\":1,\"source\":\"tiles/terrain.tsj\"}]}",
    ),
  )
  files.set(
    "maps/tiles/terrain.tsj",
    ascii_bytes(
      "{\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":1,\"columns\":1,\"image\":\"terrain.png\",\"imagewidth\":16,\"imageheight\":16}",
    ),
  )
  files.set("maps/tiles/terrain.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/demo.tmj")
    inspect(map.tilesets.length(), content="1")
    inspect(map.tilesets[0].name, content="Some(\"terrain\")")
    inspect(
      map.resolve_tileset_asset_path(
        map.tilesets[0],
        map.tilesets[0].image.unwrap(),
      ),
      content="maps/tiles/terrain.png",
    )
  })
}

///|
test "load_tiled_map resolves external TSX tilesets" {
  let files : Map[String, Bytes] = Map::new()
  let demo_tmx =
    #|<?xml version="1.0" encoding="UTF-8"?>
    #|<map version="1.10" tiledversion="1.10.2" orientation="orthogonal" renderorder="right-down" width="1" height="1" tilewidth="16" tileheight="16">
    #|  <tileset firstgid="1" source="tiles/terrain.tsx"/>
    #|</map>
    #|
  let terrain_tsx =
    #|<?xml version="1.0" encoding="UTF-8"?>
    #|<tileset version="1.10" tiledversion="1.10.2" name="terrain" tilewidth="16" tileheight="16" tilecount="1" columns="1">
    #|  <image source="terrain.png" width="16" height="16"/>
    #|</tileset>
    #|
  files.set("maps/demo.tmx", ascii_bytes(demo_tmx))
  files.set("maps/tiles/terrain.tsx", ascii_bytes(terrain_tsx))
  files.set("maps/tiles/terrain.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/demo.tmx")
    inspect(map.tilesets.length(), content="1")
    inspect(map.tilesets[0].name, content="Some(\"terrain\")")
    inspect(map.tilesets[0].source, content="Some(\"tiles/terrain.tsx\")")
    inspect(
      map.resolve_tileset_asset_path(
        map.tilesets[0],
        map.tilesets[0].image.unwrap(),
      ),
      content="maps/tiles/terrain.png",
    )
  })
}

///|
test "load_tiled_map decodes JSON base64 tile layer data" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/base64.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"base64\",\"data\":\"AQAAAAAAAAAAAAAAAQAAAA==\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes JSON csv tile layer string data" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/csv.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"csv\",\"data\":\"1,0,0,1\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/csv.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes base64 with empty compression marker" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/base64-empty-compression.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"base64\",\"compression\":\"\",\"data\":\"AQAAAAAAAAAAAAAAAQAAAA==\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64-empty-compression.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes JSON base64 gzip tile layer data" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/base64-gzip.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"base64\",\"compression\":\"gzip\",\"data\":\"H4sIAAAAAAAAE2NkQABGIAYAob1v+hAAAAA=\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64-gzip.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes JSON base64 zlib tile layer data" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/base64-zlib.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"base64\",\"compression\":\"zlib\",\"data\":\"eJxjZEAARiAGAAAkAAM=\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64-zlib.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes JSON base64 zstd tile layer data" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/base64-zstd.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":2,\"height\":2,\"encoding\":\"base64\",\"compression\":\"zstd\",\"data\":\"KLUv/QRYZQAAMAEAAQAAAAEAG8ACEQP0ng==\"}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64-zstd.tmj")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "load_tiled_map decodes TMX base64 tile layer data" {
  let files : Map[String, Bytes] = Map::new()
  let base64_tmx =
    #|<?xml version="1.0" encoding="UTF-8"?>
    #|<map version="1.10" tiledversion="1.10.2" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="16" tileheight="16">
    #|  <layer id="1" name="Ground" width="2" height="2">
    #|    <data encoding="base64">
    #|      AQAAAAAAAAAAAAAAAQAAAA==
    #|    </data>
    #|  </layer>
    #|</map>
    #|
  files.set("maps/base64.tmx", ascii_bytes(base64_tmx))
  with_fake_asset_io(files, fn() raise {
    let map = load_tiled_map("maps/base64.tmx")
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_gid_at(0, 0).tile_id, content="1")
    inspect(layer.tile_gid_at(1, 0).tile_id, content="0")
    inspect(layer.tile_gid_at(1, 1).tile_id, content="1")
  })
}

///|
test "tiled world pattern expansion derives map position and size" {
  let pattern : TiledWorldPattern = {
    regexp: "ow-p0*(\\d+)-n0*(\\d+)-o0000\\.tmx",
    multiplier_x: 6400,
    multiplier_y: 6400,
    offset_x: -6400,
    offset_y: -6400,
    map_width: 6400,
    map_height: 6400,
  }
  let expanded = tiled_world_expand_pattern(pattern, [
    "ow-p0002-n0003-o0000.tmx", "ow-p0001-n0001-o0000.tmx", "notes.txt",
  ])
  let snapshot = expanded.map(fn(map) {
    "\{map.file_name}@\{map.x},\{map.y},\{map.width.unwrap()},\{map.height.unwrap()}"
  })
  snapshot.sort()
  inspect(
    snapshot,
    content="[\"ow-p0001-n0001-o0000.tmx@0,0,6400,6400\", \"ow-p0002-n0003-o0000.tmx@6400,12800,6400,6400\"]",
  )
}

///|
test "load_tiled_world parses pattern map dimensions defaults" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "worlds/patterns.world",
    ascii_bytes(
      "{\"patterns\":[{\"regexp\":\"a(\\\\d+)b(\\\\d+)\\\\.tmj\",\"multiplierX\":320,\"multiplierY\":160}],\"type\":\"world\"}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let world = load_tiled_world("worlds/patterns.world")
    inspect(world.patterns.length(), content="1")
    inspect(world.patterns[0].map_width, content="320")
    inspect(world.patterns[0].map_height, content="160")
  })
}

///|
test "spawn_tiled_map creates tile object and image layer entities" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/level.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"properties\":[{\"name\":\"world\",\"type\":\"string\",\"value\":\"demo\"}],\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"offsetx\":2,\"offsety\":3,\"width\":2,\"height\":2,\"properties\":[{\"name\":\"speed\",\"type\":\"float\",\"value\":2.0}],\"data\":[1,0,0,1]},{\"id\":2,\"name\":\"Objects\",\"type\":\"objectgroup\",\"objects\":[{\"id\":7,\"name\":\"Spawn\",\"type\":\"spawn\",\"x\":20,\"y\":24,\"properties\":[{\"name\":\"hp\",\"type\":\"int\",\"value\":3}]},{\"id\":8,\"name\":\"Torch\",\"gid\":1,\"x\":32,\"y\":32,\"width\":16,\"height\":16,\"visible\":true,\"properties\":[{\"name\":\"lit\",\"type\":\"bool\",\"value\":true}]}]},{\"id\":3,\"name\":\"Backdrop\",\"type\":\"imagelayer\",\"image\":\"bg.png\",\"repeatx\":true}],\"tilesets\":[{\"firstgid\":1,\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":1,\"columns\":1,\"image\":\"terrain.png\",\"imagewidth\":16,\"imageheight\":16,\"tiles\":[{\"id\":0,\"properties\":[{\"name\":\"solid\",\"type\":\"bool\",\"value\":true}]}]}]}",
    ),
  )
  files.set("maps/terrain.png", ascii_bytes("png"))
  files.set("maps/bg.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/level.tmj", settings={
      ..default_tiled_spawn_settings(),
      position: @math.Vec2(10.0, 20.0),
      zindex: 5,
      layer_z_step: 10,
      spawn_hidden_layers: true,
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(root)),
      content="10,20",
    )
    match tiled_properties().get(root).unwrap().get("world") {
      Some(String(value)) => inspect(value, content="demo")
      _ => inspect("missing", content="demo")
    }
    let storage = tiled_map_storages().get(root).unwrap()

    let layer_entities = tiled_layer_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(layer_entities.length(), content="3")

    let ground_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Ground"
      })[0].0
    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(ground_entity)),
      content="2,3",
    )
    inspect(storage.layer_entity(1).unwrap() == ground_entity, content="true")
    match tiled_properties().get(ground_entity).unwrap().get("speed") {
      Some(Float(value)) => inspect(value.to_int(), content="2")
      _ => inspect("missing", content="2")
    }

    let tile_entities = tiled_tile_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(storage.tile_entities(1).length(), content="2")
    let tile_positions = tile_entities.map(fn(pair) {
      let tile_offset = tiled_test_entity_translation_2d(pair.0)
      let layer_offset = tiled_test_entity_translation_2d(
        pair.0.get_parent().unwrap(),
      )
      vec2_snapshot(tile_offset + layer_offset)
    })
    tile_positions.sort()
    inspect(tile_positions, content="[\"2,3\", \"18,19\"]")
    inspect(
      animation_image_path(tile_entities[0].0),
      content="Some(\"maps/terrain.png\")",
    )
    for pair in tile_entities {
      match tiled_properties().get(pair.0).unwrap().get("solid") {
        Some(Bool(true)) => ()
        _ => inspect("missing", content="missing")
      }
    }

    let object_entities = tiled_object_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(object_entities.length(), content="2")
    inspect(storage.object_entity(7) is Some(_), content="true")
    inspect(storage.object_entity(8) is Some(_), content="true")
    let named_positions = object_entities.map(fn(pair) {
      let name = pair.1.object.name
      let object_offset = tiled_test_entity_translation_2d(pair.0)
      let layer_offset = tiled_test_entity_translation_2d(
        pair.0.get_parent().unwrap(),
      )
      "\{name}@\{vec2_snapshot(object_offset + layer_offset)}"
    })
    named_positions.sort()
    inspect(named_positions, content="[\"Spawn@20,24\", \"Torch@32,16\"]")

    let backdrop_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Backdrop"
      })[0].0
    inspect(
      tiled_image_layer_instances().get(backdrop_entity).unwrap().resolved_image_path,
      content="Some(\"maps/bg.png\")",
    )
  })
}

///|
test "respawn_tiled_map_into_entity replaces previous tiled children and metadata" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/a.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"properties\":[{\"name\":\"stage\",\"type\":\"string\",\"value\":\"one\"}],\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":1,\"height\":1,\"data\":[0]},{\"id\":2,\"name\":\"Objects\",\"type\":\"objectgroup\",\"objects\":[{\"id\":7,\"name\":\"Spawn\",\"x\":10,\"y\":12}]}],\"tilesets\":[]}",
    ),
  )
  files.set(
    "maps/b.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"properties\":[{\"name\":\"stage\",\"type\":\"string\",\"value\":\"two\"}],\"layers\":[{\"id\":1,\"name\":\"Backdrop\",\"type\":\"imagelayer\",\"image\":\"bg.png\"}],\"tilesets\":[]}",
    ),
  )
  files.set("maps/bg.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = @entity.Entity::new()
    spawn_tiled_map_into_entity(root, load_tiled_map("maps/a.tmj"), settings={
      ..default_tiled_spawn_settings(),
      position: @math.Vec2(1.0, 2.0),
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      root.get_children().filter(fn(child) { child.is_alive() }).length(),
      content="2",
    )
    inspect(
      tiled_map_storages().get(root).unwrap().object_entity(7) is Some(_),
      content="true",
    )

    respawn_tiled_map_into_entity(root, load_tiled_map("maps/b.tmj"), settings={
      ..default_tiled_spawn_settings(),
      position: @math.Vec2(3.0, 4.0),
    })

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(root)),
      content="3,4",
    )
    inspect(
      root.get_children().filter(fn(child) { child.is_alive() }).length(),
      content="1",
    )
    match tiled_properties().get(root).unwrap().get("stage") {
      Some(String(value)) => inspect(value, content="two")
      _ => inspect("missing", content="two")
    }
    let storage = tiled_map_storages().get(root).unwrap()
    inspect(storage.object_entity(7) is None, content="true")
    let layer_names = tiled_layer_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
      .map(fn(pair) { pair.1.layer.name })
    inspect(layer_names, content="[\"Backdrop\"]")
    let image_layers = tiled_image_layer_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(image_layers.length(), content="1")
  })
}

///|
test "spawn_tiled_map attaches full tiled physics coverage" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/physics.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"CollisionTiles\",\"type\":\"tilelayer\",\"width\":2,\"height\":1,\"data\":[1,1]},{\"id\":2,\"name\":\"Objects\",\"type\":\"objectgroup\",\"objects\":[{\"id\":7,\"name\":\"sensor_rect\",\"x\":20,\"y\":5,\"width\":8,\"height\":6,\"properties\":[{\"name\":\"sensor\",\"type\":\"bool\",\"value\":true}]},{\"id\":8,\"name\":\"ellipse\",\"x\":40,\"y\":5,\"width\":10,\"height\":6,\"ellipse\":true},{\"id\":9,\"name\":\"polyline\",\"x\":55,\"y\":5,\"polyline\":[{\"x\":0,\"y\":0},{\"x\":8,\"y\":4},{\"x\":10,\"y\":0}]},{\"id\":10,\"name\":\"polygon\",\"x\":70,\"y\":5,\"polygon\":[{\"x\":0,\"y\":0},{\"x\":10,\"y\":0},{\"x\":4,\"y\":8}]},{\"id\":11,\"name\":\"point\",\"x\":95,\"y\":8,\"point\":true},{\"id\":12,\"name\":\"TileObject\",\"gid\":1,\"x\":112,\"y\":16,\"width\":16,\"height\":16}]}],\"tilesets\":[{\"firstgid\":1,\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":1,\"columns\":1,\"image\":\"terrain.png\",\"imagewidth\":16,\"imageheight\":16,\"tiles\":[{\"id\":0,\"objectgroup\":{\"draworder\":\"topdown\",\"objects\":[{\"id\":1,\"name\":\"solid\",\"x\":0,\"y\":0,\"width\":16,\"height\":16}]}}]}]}",
    ),
  )
  files.set("maps/terrain.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/physics.tmj", settings={
      ..default_tiled_spawn_settings(),
      physics_settings: Some({
        ..default_tiled_physics_settings(),
        objects_filter: TiledNameFilter::names([
          "sensor_rect", "ellipse", "polyline", "polygon", "point", "TileObject",
          "solid",
        ]),
        tiles_layer_filter: TiledNameFilter::names(["CollisionTiles"]),
        ellipse_segments: 12,
        point_radius: 2.0,
      }),
    })
    defer cleanup_spawned_tiled_tree(root)

    let storage = tiled_map_storages().get(root).unwrap()
    let layer_entity = storage.layer_entity(1).unwrap()
    let layer_colliders = tiled_colliders()
      .get(layer_entity)
      .unwrap()
      .alive_entities()
    inspect(layer_colliders.length(), content="1")
    inspect(
      tiled_collider_origins().get(layer_colliders[0]).unwrap().source_kind ==
      TilesLayer,
      content="true",
    )
    match @physics2d.shapes().get(layer_colliders[0]).unwrap() {
      Rect(size=@math.Vec2(width, height), offset=@math.Vec2(x, y)) =>
        inspect(
          "\{width.to_int()},\{height.to_int()}@\{x.to_int()},\{y.to_int()}",
          content="32,16@0,0",
        )
      _ => inspect("wrong-shape", content="32,16@0,0")
    }

    let sensor_object = storage.object_entity(7).unwrap()
    let sensor_colliders = tiled_colliders()
      .get(sensor_object)
      .unwrap()
      .alive_entities()
    inspect(sensor_colliders.length(), content="1")
    inspect(
      @physics2d.areas().get(sensor_colliders[0]) is Some(_),
      content="true",
    )

    let ellipse_object = storage.object_entity(8).unwrap()
    let ellipse_collider = tiled_colliders()
      .get(ellipse_object)
      .unwrap()
      .alive_entities()[0]
    match @physics2d.shapes().get(ellipse_collider).unwrap() {
      Polygon(points~, ..) => inspect(points.length(), content="12")
      _ => inspect("wrong-shape", content="12")
    }

    let polyline_object = storage.object_entity(9).unwrap()
    let polyline_collider = tiled_colliders()
      .get(polyline_object)
      .unwrap()
      .alive_entities()[0]
    match @physics2d.shapes().get(polyline_collider).unwrap() {
      Polyline(points~, closed~, ..) => {
        inspect(points.length(), content="3")
        inspect(closed, content="false")
      }
      _ => {
        inspect("wrong-shape", content="3")
        inspect("wrong-shape", content="false")
      }
    }

    let polygon_object = storage.object_entity(10).unwrap()
    let polygon_collider = tiled_colliders()
      .get(polygon_object)
      .unwrap()
      .alive_entities()[0]
    match @physics2d.shapes().get(polygon_collider).unwrap() {
      Polygon(points~, ..) => inspect(points.length(), content="3")
      _ => inspect("wrong-shape", content="3")
    }

    let point_object = storage.object_entity(11).unwrap()
    let point_collider = tiled_colliders()
      .get(point_object)
      .unwrap()
      .alive_entities()[0]
    match @physics2d.shapes().get(point_collider).unwrap() {
      Ball(radius~, offset~) => {
        inspect(radius.to_int(), content="2")
        inspect(vec2_snapshot(offset), content="0,0")
      }
      _ => {
        inspect("wrong-shape", content="2")
        inspect("wrong-shape", content="0,0")
      }
    }

    let tile_object = storage.object_entity(12).unwrap()
    let tile_object_colliders = tiled_colliders()
      .get(tile_object)
      .unwrap()
      .alive_entities()
    inspect(tile_object_colliders.length(), content="1")
    inspect(
      tiled_collider_origins().get(tile_object_colliders[0]).unwrap().source_kind ==
      Object,
      content="true",
    )
    match @physics2d.shapes().get(tile_object_colliders[0]).unwrap() {
      Rect(size=@math.Vec2(width, height), offset=@math.Vec2(x, y)) =>
        inspect(
          "\{width.to_int()},\{height.to_int()}@\{x.to_int()},\{y.to_int()}",
          content="16,16@0,0",
        )
      _ => inspect("wrong-shape", content="16,16@0,0")
    }
  })
}

///|
test "spawn_tiled_map applies physics body and material properties" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/physics-properties.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Objects\",\"type\":\"objectgroup\",\"objects\":[{\"id\":7,\"name\":\"dynamic\",\"x\":8,\"y\":10,\"width\":12,\"height\":6,\"properties\":[{\"name\":\"physics_body\",\"type\":\"string\",\"value\":\"dynamic\"},{\"name\":\"physics_gravity_scale\",\"type\":\"float\",\"value\":0.5},{\"name\":\"physics_linear_damping\",\"type\":\"float\",\"value\":1.25},{\"name\":\"physics_angular_damping\",\"type\":\"float\",\"value\":0.75},{\"name\":\"physics_ccd\",\"type\":\"bool\",\"value\":true},{\"name\":\"physics_lock_rotation\",\"type\":\"bool\",\"value\":false},{\"name\":\"physics_friction\",\"type\":\"float\",\"value\":0.2},{\"name\":\"physics_restitution\",\"type\":\"float\",\"value\":0.6},{\"name\":\"physics_active\",\"type\":\"bool\",\"value\":false}]},{\"id\":8,\"name\":\"sensor\",\"x\":30,\"y\":10,\"width\":8,\"height\":8,\"properties\":[{\"name\":\"sensor\",\"type\":\"bool\",\"value\":true},{\"name\":\"physics_active\",\"type\":\"bool\",\"value\":false}]}]}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/physics-properties.tmj", settings={
      ..default_tiled_spawn_settings(),
      physics_settings: Some(default_tiled_physics_settings()),
    })
    defer cleanup_spawned_tiled_tree(root)

    let storage = tiled_map_storages().get(root).unwrap()
    let dynamic_entity = tiled_colliders()
      .get(storage.object_entity(7).unwrap())
      .unwrap()
      .alive_entities()[0]
    let sensor_entity = tiled_colliders()
      .get(storage.object_entity(8).unwrap())
      .unwrap()
      .alive_entities()[0]

    inspect(
      @physics2d.colliders().get(dynamic_entity).unwrap().active,
      content="false",
    )
    inspect(
      @physics2d.colliders().get(dynamic_entity).unwrap().friction == 0.2,
      content="true",
    )
    inspect(
      @physics2d.colliders().get(dynamic_entity).unwrap().restitution == 0.6,
      content="true",
    )
    inspect(
      @physics2d.areas().get(sensor_entity).unwrap().active,
      content="false",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().body_type
      is @physics2d.RigidBodyType::Dynamic,
      content="true",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().gravity_scale ==
      0.5,
      content="true",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().linear_damping ==
      1.25,
      content="true",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().angular_damping ==
      0.75,
      content="true",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().ccd_enabled,
      content="true",
    )
    inspect(
      @physics2d.rigid_bodies().get(dynamic_entity).unwrap().lock_rotation,
      content="false",
    )
  })
}

///|
test "spawn_tiled_world loads adjacent maps and emits world events" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "worlds/demo.world",
    ascii_bytes(
      "{\"onlyShowAdjacentMaps\":true,\"maps\":[{\"fileName\":\"maps/a.tmj\",\"x\":0,\"y\":0,\"width\":32,\"height\":32},{\"fileName\":\"maps/b.tmj\",\"x\":32,\"y\":0,\"width\":32,\"height\":32},{\"fileName\":\"maps/c.tmj\",\"x\":96,\"y\":0,\"width\":32,\"height\":32}]}",
    ),
  )
  files.set(
    "worlds/maps/a.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  files.set(
    "worlds/maps/b.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  files.set(
    "worlds/maps/c.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let world_reader = @event.EventReader::new()
    let world_map_reader = @event.EventReader::new()
    let hooked_paths : Array[String] = []
    let world = load_tiled_world("worlds/demo.world")
    let root = spawn_tiled_world(world, settings={
      ..default_tiled_world_spawn_settings(),
      position: @math.Vec2(5.0, 7.0),
      focus_map_path: Some("maps/a.tmj"),
      world_map_hook: Some(fn(event) {
        hooked_paths.push(event.resolved_map_path)
      }),
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(root)),
      content="5,7",
    )
    inspect(
      @event.read(world_reader, tiled_world_spawned_event_bus).length(),
      content="1",
    )
    let world_map_events = @event.read(
      world_map_reader, tiled_world_map_spawned_event_bus,
    )
    inspect(world_map_events.length(), content="2")
    hooked_paths.sort()
    inspect(
      hooked_paths,
      content="[\"worlds/maps/a.tmj\", \"worlds/maps/b.tmj\"]",
    )

    let map_entities = tiled_world_map_instances()
      .to_array()
      .filter(fn(pair) { pair.1.world_entity == root })
      .map(fn(pair) {
        let path = pair.1.resolved_map_path
        let offset = tiled_test_entity_translation_2d(pair.0)
        "\{path}@\{vec2_snapshot(offset)}"
      })
    map_entities.sort()
    inspect(
      map_entities,
      content="[\"worlds/maps/a.tmj@0,0\", \"worlds/maps/b.tmj@32,0\"]",
    )
  })
}

///|
test "respawn_tiled_world_into_entity replaces previous spawned maps" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "worlds/a.world",
    ascii_bytes(
      "{\"maps\":[{\"fileName\":\"maps/a.tmj\",\"x\":0,\"y\":0}],\"type\":\"world\"}",
    ),
  )
  files.set(
    "worlds/b.world",
    ascii_bytes(
      "{\"maps\":[{\"fileName\":\"maps/b.tmj\",\"x\":64,\"y\":0}],\"type\":\"world\"}",
    ),
  )
  files.set(
    "worlds/maps/a.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  files.set(
    "worlds/maps/b.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let root = @entity.Entity::new()
    spawn_tiled_world_into_entity(root, load_tiled_world("worlds/a.world"), settings={
      ..default_tiled_world_spawn_settings(),
      position: @math.Vec2(5.0, 7.0),
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      root.get_children().filter(fn(child) { child.is_alive() }).length(),
      content="1",
    )

    respawn_tiled_world_into_entity(root, load_tiled_world("worlds/b.world"), settings={
      ..default_tiled_world_spawn_settings(),
      position: @math.Vec2(11.0, 13.0),
    })

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(root)),
      content="11,13",
    )
    inspect(
      root.get_children().filter(fn(child) { child.is_alive() }).length(),
      content="1",
    )
    inspect(
      tiled_world_instances().get(root).unwrap().loaded_maps.length(),
      content="1",
    )
    let map_entities = tiled_world_map_instances()
      .to_array()
      .filter(fn(pair) { pair.1.world_entity == root })
      .map(fn(pair) {
        let path = pair.1.resolved_map_path
        let offset = tiled_test_entity_translation_2d(pair.0)
        "\{path}@\{vec2_snapshot(offset)}"
      })
    inspect(map_entities, content="[\"worlds/maps/b.tmj@64,0\"]")
  })
}

///|
test "tiled world chunking spawns maps around camera view" {
  let previous_viewport = @system.get_viewport_size()
  let previous_zoom = @system.get_zoom()
  @system.configure_display(100.0, 100.0, 1.0)

  let camera_entity = @entity.Entity::new()
  defer camera_entity.destroy()
  @camera.cameras().set(camera_entity, @camera.Camera::new())
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @camera.orthographic_projections().set(
    camera_entity,
    @camera.OrthographicProjection::new(),
  )
  tiled_test_set_entity_translation_2d(camera_entity, @math.Vec2(50.0, 50.0))

  let files : Map[String, Bytes] = Map::new()
  files.set(
    "worlds/chunk.world",
    ascii_bytes(
      "{\"maps\":[{\"fileName\":\"maps/a.tmj\",\"x\":0,\"y\":0},{\"fileName\":\"maps/b.tmj\",\"x\":200,\"y\":0}],\"type\":\"world\"}",
    ),
  )
  files.set(
    "worlds/maps/a.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  files.set(
    "worlds/maps/b.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_world("worlds/chunk.world", settings={
      ..default_tiled_world_spawn_settings(),
      chunking: Some(@math.Vec2::zero()),
      map_settings: {
        ..default_tiled_spawn_settings(),
        position: @math.Vec2::zero(),
      },
    })
    defer cleanup_spawned_tiled_tree(root)

    let first_spawned = tiled_world_map_instances()
      .to_array()
      .filter(fn(pair) { pair.1.world_entity == root })
    inspect(first_spawned.length(), content="1")
    inspect(first_spawned[0].1.resolved_map_path, content="worlds/maps/a.tmj")

    tiled_test_set_entity_translation_2d(
      camera_entity,
      @math.Vec2(250.0, 50.0),
    )
    tiled_world_chunking_system(0.0)

    let second_spawned = tiled_world_map_instances()
      .to_array()
      .filter(fn(pair) { pair.1.world_entity == root })
    inspect(second_spawned.length(), content="1")
    inspect(second_spawned[0].1.resolved_map_path, content="worlds/maps/b.tmj")
  })

  @system.configure_display(
    previous_viewport[X],
    previous_viewport[Y],
    previous_zoom,
  )
}

///|
test "tiled parallax system adjusts layer offsets" {
  let previous_viewport = @system.get_viewport_size()
  let previous_zoom = @system.get_zoom()
  @system.configure_display(100.0, 100.0, 1.0)

  let camera_entity = @entity.Entity::new()
  defer camera_entity.destroy()
  @camera.cameras().set(camera_entity, @camera.Camera::new())
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @camera.orthographic_projections().set(
    camera_entity,
    @camera.OrthographicProjection::new(),
  )
  tiled_test_set_entity_translation_2d(camera_entity, @math.Vec2(50.0, 50.0))

  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/parallax.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Background\",\"type\":\"tilelayer\",\"offsetx\":2,\"offsety\":3,\"parallaxx\":0.5,\"parallaxy\":0.0,\"width\":1,\"height\":1,\"data\":[0]}],\"tilesets\":[]}",
    ),
  )
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/parallax.tmj")
    defer cleanup_spawned_tiled_tree(root)

    let layer_entity = tiled_layer_instances()
      .to_array()
      .filter(fn(pair) {
        pair.1.map_entity == root && pair.1.layer.name == "Background"
      })[0].0
    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(layer_entity)),
      content="2,3",
    )

    tiled_test_set_entity_translation_2d(
      camera_entity,
      @math.Vec2(250.0, 150.0),
    )
    tiled_parallax_system(0.0)

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(layer_entity)),
      content="102,103",
    )
  })

  @system.configure_display(
    previous_viewport[X],
    previous_viewport[Y],
    previous_zoom,
  )
}

///|
test "spawn_tiled_map reads TMX tile object and image layers" {
  let files : Map[String, Bytes] = Map::new()
  let level_tmx =
    #|<?xml version="1.0" encoding="UTF-8"?>
    #|<map version="1.10" tiledversion="1.10.2" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="16" tileheight="16">
    #|  <tileset firstgid="1" name="terrain" tilewidth="16" tileheight="16" tilecount="1" columns="1">
    #|    <image source="terrain.png" width="16" height="16"/>
    #|  </tileset>
    #|  <layer id="1" name="Ground" width="2" height="2" offsetx="2" offsety="3">
    #|    <data encoding="csv">1,0,0,1</data>
    #|  </layer>
    #|  <objectgroup id="2" name="Objects">
    #|    <object id="7" name="Spawn" type="spawn" x="20" y="24"/>
    #|    <object id="8" name="Torch" gid="1" x="32" y="32" width="16" height="16" visible="1"/>
    #|  </objectgroup>
    #|  <imagelayer id="3" name="Backdrop" repeatx="1">
    #|    <image source="bg.png"/>
    #|  </imagelayer>
    #|</map>
    #|
  files.set("maps/level.tmx", ascii_bytes(level_tmx))
  files.set("maps/terrain.png", ascii_bytes("png"))
  files.set("maps/bg.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/level.tmx", settings={
      ..default_tiled_spawn_settings(),
      position: @math.Vec2(10.0, 20.0),
      zindex: 5,
      layer_z_step: 10,
      spawn_hidden_layers: true,
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(root)),
      content="10,20",
    )

    let layer_entities = tiled_layer_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(layer_entities.length(), content="3")

    let ground_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Ground"
      })[0].0
    inspect(
      vec2_snapshot(tiled_test_entity_translation_2d(ground_entity)),
      content="2,3",
    )

    let tile_entities = tiled_tile_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    let tile_positions = tile_entities.map(fn(pair) {
      let tile_offset = tiled_test_entity_translation_2d(pair.0)
      let layer_offset = tiled_test_entity_translation_2d(
        pair.0.get_parent().unwrap(),
      )
      vec2_snapshot(tile_offset + layer_offset)
    })
    tile_positions.sort()
    inspect(tile_positions, content="[\"2,3\", \"18,19\"]")
    inspect(
      animation_image_path(tile_entities[0].0),
      content="Some(\"maps/terrain.png\")",
    )

    let object_entities = tiled_object_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(object_entities.length(), content="2")
    let named_positions = object_entities.map(fn(pair) {
      let name = pair.1.object.name
      let object_offset = tiled_test_entity_translation_2d(pair.0)
      let layer_offset = tiled_test_entity_translation_2d(
        pair.0.get_parent().unwrap(),
      )
      "\{name}@\{vec2_snapshot(object_offset + layer_offset)}"
    })
    named_positions.sort()
    inspect(named_positions, content="[\"Spawn@20,24\", \"Torch@32,16\"]")

    let backdrop_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Backdrop"
      })[0].0
    inspect(
      tiled_image_layer_instances().get(backdrop_entity).unwrap().resolved_image_path,
      content="Some(\"maps/bg.png\")",
    )
  })
}

///|
test "spawn_tiled_map expands tiled animated tiles into frame timelines" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/animated.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":1,\"height\":1,\"data\":[1]}],\"tilesets\":[{\"firstgid\":1,\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":2,\"columns\":2,\"image\":\"terrain.png\",\"imagewidth\":32,\"imageheight\":16,\"tiles\":[{\"id\":0,\"animation\":[{\"tileid\":0,\"duration\":100},{\"tileid\":1,\"duration\":200}]}]}]}",
    ),
  )
  files.set("maps/terrain.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/animated.tmj")
    defer cleanup_spawned_tiled_tree(root)

    let tile_entities = tiled_tile_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(tile_entities.length(), content="1")

    guard @sprite.sprites().get(tile_entities[0].0) is Some(sprite) else {
      inspect("missing-sprite", content="missing-sprite")
      return
    }
    inspect(sprite.image is Some(_), content="true")
    inspect(sprite.texture_atlas is Some(_), content="true")
    match sprite.texture_atlas {
      Some(atlas) =>
        match @sprite.texture_atlas_layout(atlas.layout) {
          Some(layout) => {
            inspect(layout.rects.length(), content="3")
            let offsets = layout.rects.map(fn(rect) {
              rect.position[X].to_int().to_string()
            })
            inspect(offsets, content="[\"0\", \"16\", \"16\"]")
          }
          None => inspect("missing-layout", content="missing-layout")
        }
      None => inspect("not-atlas", content="not-atlas")
    }
  })
}

///|
test "spawn_tiled_map creates tile entities for isometric maps" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/isometric.tmj",
    ascii_bytes(
      "{\"width\":1,\"height\":1,\"tilewidth\":16,\"tileheight\":16,\"orientation\":\"isometric\",\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"width\":1,\"height\":1,\"data\":[1]}],\"tilesets\":[{\"firstgid\":1,\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":1,\"columns\":1,\"image\":\"terrain.png\",\"imagewidth\":16,\"imageheight\":16}]}",
    ),
  )
  files.set("maps/terrain.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/isometric.tmj")
    defer cleanup_spawned_tiled_tree(root)

    let tile_entities = tiled_tile_instances()
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(tile_entities.length(), content="1")
  })
}

///|
test "tiled_cell_position supports isometric hexagonal and staggered layouts" {
  let tileset = test_tileset_16x16()

  let iso_map = {
    ..empty_tiled_map(),
    width: 2,
    height: 2,
    tile_width: 16,
    tile_height: 16,
    orientation: "isometric",
  }
  let iso_cells = [
    test_tile_cell(0, 0),
    test_tile_cell(1, 0),
    test_tile_cell(0, 1),
  ]
  let iso_snapshot = iso_cells.map(fn(cell) {
    vec2_snapshot(tiled_cell_position(iso_map, tileset, cell))
  })
  inspect(iso_snapshot, content="[\"8,0\", \"16,8\", \"0,8\"]")

  let hex_map = {
    ..empty_tiled_map(),
    width: 2,
    height: 2,
    tile_width: 16,
    tile_height: 16,
    orientation: "hexagonal",
    hex_side_length: Some(8),
    stagger_axis: Some("y"),
    stagger_index: Some("odd"),
  }
  let hex_cells = [
    test_tile_cell(0, 0),
    test_tile_cell(0, 1),
    test_tile_cell(1, 1),
  ]
  let hex_snapshot = hex_cells.map(fn(cell) {
    vec2_snapshot(tiled_cell_position(hex_map, tileset, cell))
  })
  inspect(hex_snapshot, content="[\"0,0\", \"8,12\", \"24,12\"]")

  let staggered_map = {
    ..empty_tiled_map(),
    width: 2,
    height: 2,
    tile_width: 16,
    tile_height: 16,
    orientation: "staggered",
    stagger_axis: Some("x"),
    stagger_index: Some("even"),
  }
  let staggered_cells = [
    test_tile_cell(0, 0),
    test_tile_cell(1, 0),
    test_tile_cell(0, 1),
  ]
  let staggered_snapshot = staggered_cells.map(fn(cell) {
    vec2_snapshot(tiled_cell_position(staggered_map, tileset, cell))
  })
  inspect(staggered_snapshot, content="[\"0,8\", \"8,0\", \"0,24\"]")
}

///|
test "tiled tile object origin shifts on isometric maps" {
  let tileset = test_tileset_16x16()
  let object : TiledObject = {
    id: 1,
    name: "Tile",
    object_type: "",
    class_name: None,
    gid: Some(decode_tiled_gid(1)),
    x: 32.0,
    y: 32.0,
    width: 16.0,
    height: 16.0,
    rotation: 0.0,
    visible: true,
    point: false,
    ellipse: false,
    polygon: [],
    polyline: [],
    text: None,
    properties: [],
  }

  let ortho_map = {
    ..empty_tiled_map(),
    tile_width: 16,
    tile_height: 16,
    orientation: "orthogonal",
  }
  inspect(
    vec2_snapshot(tiled_tile_object_position(ortho_map, tileset, object)),
    content="32,16",
  )

  let iso_map = {
    ..empty_tiled_map(),
    tile_width: 16,
    tile_height: 16,
    orientation: "isometric",
  }
  inspect(
    vec2_snapshot(tiled_tile_object_position(iso_map, tileset, object)),
    content="24,16",
  )
}

///|
test "tiled diagonal flip swaps the tile axes before later flips" {
  let transform = tiled_gid_transform(
    decode_tiled_gid(tiled_gid_flip_diagonal_flag | 1),
    @math.Vec2(16.0, 32.0),
  )
  let (top_right_x, top_right_y) = transform.apply_to_point(16.0, 0.0)
  let (bottom_left_x, bottom_left_y) = transform.apply_to_point(0.0, 32.0)
  inspect(
    "\{top_right_x.to_int()},\{top_right_y.to_int()}|\{bottom_left_x.to_int()},\{bottom_left_y.to_int()}",
    content="0,32|16,0",
  )
}
