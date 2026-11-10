///|
test "tiled settings are configurable from external packages" {
  let map_settings = {
    ..@tiled.TiledSpawnSettings(),
    image_layer_hook: Some(fn(_event) { () }),
  }
  let physics_settings = {
    ..@tiled.TiledPhysicsSettings(),
    collider_hook: Some(fn(_event) { () }),
  }
  let world_settings = {
    ..@tiled.TiledWorldSpawnSettings(),
    map_settings,
    world_hook: Some(fn(_event) { () }),
  }
  inspect(map_settings.image_layer_hook is Some(_), content="true")
  inspect(physics_settings.collider_hook is Some(_), content="true")
  inspect(world_settings.world_hook is Some(_), content="true")
}

///|
test "compressed tile layers reject damaged checksums and truncated streams" {
  for
    (compression, data) in [
      ("gzip", "H4sIAAAAAAAAE2NkQABGIAYAoL1v+hAAAAA="),
      ("gzip", "H4sIAAAAAAAAE2NkQABGIAYAob1v+g=="),
      ("zlib", "eJxjZEAARiAGAAAkAAI="),
      ("zlib", "eJxjZEAARiAGAA=="),
    ] {
    let map = @tiled.TiledMap::from_tiled_json({
      "width": 2,
      "height": 2,
      "tilewidth": 16,
      "tileheight": 16,
      "layers": [
        {
          "type": "tilelayer",
          "name": "Ground",
          "width": 2,
          "height": 2,
          "encoding": "base64",
          "compression": compression,
          "data": data,
        },
      ],
      "tilesets": [],
    })
    let layer = map.tile_layer("Ground").unwrap()
    inspect(layer.tile_cells().length(), content="0")
  }
}
