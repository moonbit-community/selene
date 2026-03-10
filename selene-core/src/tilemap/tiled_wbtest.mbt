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
fn collect_entity_tree(
  entity : @entity.Entity,
  into : Array[@entity.Entity],
) -> Unit {
  into.push(entity)
  for child in entity.get_children() {
    collect_entity_tree(child, into)
  }
}

///|
fn cleanup_spawned_tiled_tree(root : @entity.Entity) -> Unit {
  let entities : Array[@entity.Entity] = []
  collect_entity_tree(root, entities)
  for entity in entities {
    tiled_image_layer_instances.remove(entity)
    tiled_object_instances.remove(entity)
    tiled_tile_instances.remove(entity)
    tiled_layer_instances.remove(entity)
    tiled_map_instances.remove(entity)
    @sprite.sprites.remove(entity)
    @transform.positions.remove(entity)
    entity.destroy()
  }
  @entity.entity_flush_system(0.0)
}

///|
fn vec2_snapshot(vec : @math.Vec2D) -> String {
  "\{vec[X].to_int()},\{vec[Y].to_int()}"
}

///|
fn animation_image_path(entity : @entity.Entity) -> String? {
  guard @sprite.sprites.get(entity) is Some(sprite) else { return None }
  match sprite.sprite_type {
    Animation(animation, ..) =>
      if animation.frames.length() == 0 {
        None
      } else {
        let expected_image = @asset2.load_image("maps/terrain.png")
        if animation.frames[0].image == expected_image {
          Some("maps/terrain.png")
        } else {
          None
        }
      }
    _ => None
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
test "spawn_tiled_map creates tile object and image layer entities" {
  let files : Map[String, Bytes] = Map::new()
  files.set(
    "maps/level.tmj",
    ascii_bytes(
      "{\"width\":2,\"height\":2,\"tilewidth\":16,\"tileheight\":16,\"layers\":[{\"id\":1,\"name\":\"Ground\",\"type\":\"tilelayer\",\"offsetx\":2,\"offsety\":3,\"width\":2,\"height\":2,\"data\":[1,0,0,1]},{\"id\":2,\"name\":\"Objects\",\"type\":\"objectgroup\",\"objects\":[{\"id\":7,\"name\":\"Spawn\",\"type\":\"spawn\",\"x\":20,\"y\":24},{\"id\":8,\"name\":\"Torch\",\"gid\":1,\"x\":32,\"y\":32,\"width\":16,\"height\":16,\"visible\":true}]},{\"id\":3,\"name\":\"Backdrop\",\"type\":\"imagelayer\",\"image\":\"bg.png\",\"repeatx\":true}],\"tilesets\":[{\"firstgid\":1,\"name\":\"terrain\",\"tilewidth\":16,\"tileheight\":16,\"tilecount\":1,\"columns\":1,\"image\":\"terrain.png\",\"imagewidth\":16,\"imageheight\":16}]}",
    ),
  )
  files.set("maps/terrain.png", ascii_bytes("png"))
  files.set("maps/bg.png", ascii_bytes("png"))
  with_fake_asset_io(files, fn() raise {
    let root = load_and_spawn_tiled_map("maps/level.tmj", settings={
      position: @math.Vec2D(10.0, 20.0),
      zindex: 5,
      layer_z_step: 10,
      spawn_hidden_layers: true,
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      vec2_snapshot(@transform.positions.get(root).unwrap().0),
      content="10,20",
    )

    let layer_entities = tiled_layer_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(layer_entities.length(), content="3")

    let ground_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Ground"
      })[0].0
    inspect(vec2_snapshot(ground_entity.get_offset()), content="2,3")

    let tile_entities = tiled_tile_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    let tile_positions = tile_entities.map(fn(pair) {
      let tile_offset = pair.0.get_offset()
      let layer_offset = pair.0.get_parent().unwrap().get_offset()
      vec2_snapshot(tile_offset + layer_offset)
    })
    tile_positions.sort()
    inspect(tile_positions, content="[\"2,3\", \"18,19\"]")
    inspect(
      animation_image_path(tile_entities[0].0),
      content="Some(\"maps/terrain.png\")",
    )

    let object_entities = tiled_object_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(object_entities.length(), content="2")
    let named_positions = object_entities.map(fn(pair) {
      let name = pair.1.object.name
      let object_offset = pair.0.get_offset()
      let layer_offset = pair.0.get_parent().unwrap().get_offset()
      "\{name}@\{vec2_snapshot(object_offset + layer_offset)}"
    })
    named_positions.sort()
    inspect(named_positions, content="[\"Spawn@20,24\", \"Torch@32,16\"]")

    let backdrop_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Backdrop"
      })[0].0
    inspect(
      tiled_image_layer_instances.get(backdrop_entity).unwrap().resolved_image_path,
      content="Some(\"maps/bg.png\")",
    )
  })
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
      position: @math.Vec2D(10.0, 20.0),
      zindex: 5,
      layer_z_step: 10,
      spawn_hidden_layers: true,
    })
    defer cleanup_spawned_tiled_tree(root)

    inspect(
      vec2_snapshot(@transform.positions.get(root).unwrap().0),
      content="10,20",
    )

    let layer_entities = tiled_layer_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(layer_entities.length(), content="3")

    let ground_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Ground"
      })[0].0
    inspect(vec2_snapshot(ground_entity.get_offset()), content="2,3")

    let tile_entities = tiled_tile_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    let tile_positions = tile_entities.map(fn(pair) {
      let tile_offset = pair.0.get_offset()
      let layer_offset = pair.0.get_parent().unwrap().get_offset()
      vec2_snapshot(tile_offset + layer_offset)
    })
    tile_positions.sort()
    inspect(tile_positions, content="[\"2,3\", \"18,19\"]")
    inspect(
      animation_image_path(tile_entities[0].0),
      content="Some(\"maps/terrain.png\")",
    )

    let object_entities = tiled_object_instances
      .to_array()
      .filter(fn(pair) { pair.1.map_entity == root })
    inspect(object_entities.length(), content="2")
    let named_positions = object_entities.map(fn(pair) {
      let name = pair.1.object.name
      let object_offset = pair.0.get_offset()
      let layer_offset = pair.0.get_parent().unwrap().get_offset()
      "\{name}@\{vec2_snapshot(object_offset + layer_offset)}"
    })
    named_positions.sort()
    inspect(named_positions, content="[\"Spawn@20,24\", \"Torch@32,16\"]")

    let backdrop_entity = layer_entities.filter(fn(pair) {
        pair.1.layer.name == "Backdrop"
      })[0].0
    inspect(
      tiled_image_layer_instances.get(backdrop_entity).unwrap().resolved_image_path,
      content="Some(\"maps/bg.png\")",
    )
  })
}

///|
test "tiled diagonal flip swaps the tile axes before later flips" {
  let transform = tiled_gid_transform(
    decode_tiled_gid(tiled_gid_flip_diagonal_flag | 1),
    @math.Vec2D(16.0, 32.0),
  )
  let (top_right_x, top_right_y) = transform.apply_to_point(16.0, 0.0)
  let (bottom_left_x, bottom_left_y) = transform.apply_to_point(0.0, 32.0)
  inspect(
    "\{top_right_x.to_int()},\{top_right_y.to_int()}|\{bottom_left_x.to_int()},\{bottom_left_y.to_int()}",
    content="0,32|16,0",
  )
}
