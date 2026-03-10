///|
struct TileMap {
  tile_size : Int
  map_width : Int
  map_height : Int
  layers : Array[TileLayer]
} derive(@json.FromJson(rename_fields="camelCase"))

///|
struct TileLayer {
  name : String
  tiles : Array[Tile]
} derive(@json.FromJson(rename_fields="camelCase"))

///|
struct Tile {
  id : String
  x : Int
  y : Int
} derive(@json.FromJson(rename_fields="camelCase"))

///|
fn TileMap::from_json(json : Json) -> TileMap {
  try! @json.from_json(json)
}

///|
fn TileMap::get_tiles(self : TileMap, layer_name : String) -> Array[Tile] {
  self.layers
  .filter(fn(layer) { layer.name == layer_name })
  .get(0)
  .map_or([], fn(layer) { layer.tiles })
}

///|
fn TileMap::get_tiles_first(self : TileMap, layer_name : String) -> Array[Tile] {
  let layer = self.layers.filter(fn(layer) { layer.name == layer_name }).get(0)
  guard layer is Some(layer) else { return [] }
  let tiles = layer.tiles
  let all_ids = tiles.map(fn(tile) { tile.id })
  let first_id = all_ids[0]
  tiles.filter(fn(tile) { tile.id == first_id })
}
