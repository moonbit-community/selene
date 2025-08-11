// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///| 
/// The `TileMap` struct represents a tile map used in the JSON format produced by 
/// [SpriteFusion](https://www.spritefusion.com/).
/// 
pub struct TileMap {
  tile_size : Int
  map_width : Int
  map_height : Int
  layers : Array[TileLayer]
} derive(@json.FromJson(rename_fields="camelCase"))

///|
pub struct TileLayer {
  name : String
  tiles : Array[Tile]
  collider : Bool
} derive(@json.FromJson(rename_fields="camelCase"))

///|
pub struct Tile {
  id : String
  x : Int
  y : Int
} derive(@json.FromJson(rename_fields="camelCase"))

///|
pub fn TileMap::from_json(json : Json) -> TileMap {
  try! @json.from_json(json)
}

///|
/// Retrieves all tiles from a specified layer in the tile map.
///
/// Parameters:
///
/// * `self` : The tile map to search within.
/// * `layer_name` : The name of the layer from which to retrieve tiles.
///
/// Returns an array of tiles from the specified layer, or an empty array if the
/// layer is not found.
///
pub fn TileMap::get_tiles(self : TileMap, layer_name : String) -> Array[Tile] {
  self.layers
  .filter(fn(layer) { layer.name == layer_name })
  .get(0)
  .map_or([], fn(layer) { layer.tiles })
}

///|
/// Retrieves all tiles with the same ID as the first tile from a specified
/// layer in the tile map.
///
/// Parameters:
///
/// * `self` : The tile map to search within.
/// * `layer_name` : The name of the layer from which to retrieve tiles.
///
/// Returns an array of tiles that share the same ID as the first tile in the
/// specified layer, or an empty array if the layer is not found or contains no
/// tiles.
///
/// Panics if the specified layer exists but contains no tiles, as it attempts
/// to access the first element of an empty array.
/// 
/// Note: Make sure the left-top corner tile is identical to the other tiles.
/// Sprite Fusion will generate the same IDs for the same tiles in the same layer.
///
pub fn TileMap::get_tiles_first(
  self : TileMap,
  layer_name : String,
) -> Array[Tile] {
  let layer = self.layers.filter(fn(layer) { layer.name == layer_name }).get(0)
  guard layer is Some(layer) else { return [] }
  let tiles = layer.tiles
  let all_ids = tiles.map(fn(t) { t.id })
  let leftcorder_id = all_ids[0]
  tiles.filter(fn(t) { t.id == leftcorder_id })
}
