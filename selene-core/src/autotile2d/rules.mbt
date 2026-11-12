///|
#derive(Debug, Eq, ToJson, FromJson)
pub enum AutoTileRuleSetKind {
  Bitmask4
  Bitmask8
  Wang
}

///|
pub extend AutoTileRuleSetKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileRuleSetKind with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileRuleSetKind with Eq::{not_equal, equal}

///|
pub extend AutoTileRuleSetKind with ToJson::{to_json}

///|
pub fn autotile_rule_set_bitmask4() -> AutoTileRuleSetKind {
  Bitmask4
}

///|
pub fn autotile_rule_set_bitmask8() -> AutoTileRuleSetKind {
  Bitmask8
}

///|
pub fn autotile_rule_set_wang() -> AutoTileRuleSetKind {
  Wang
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileCell {
  x : Int32
  y : Int32
  terrain : Int32
}

///|
pub extend AutoTileCell with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileCell with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileCell with Eq::{not_equal, equal}

///|
pub extend AutoTileCell with ToJson::{to_json}

///|
pub fn AutoTileCell::AutoTileCell(
  x : Int32,
  y : Int32,
  terrain : Int32,
) -> AutoTileCell {
  { x, y, terrain, }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileMaskRule {
  mask : Int32
  region_name : String
  atlas_index : Int32
}

///|
pub extend AutoTileMaskRule with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileMaskRule with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileMaskRule with Eq::{not_equal, equal}

///|
pub extend AutoTileMaskRule with ToJson::{to_json}

///|
pub fn AutoTileMaskRule::AutoTileMaskRule(
  mask : Int32,
  region_name : String,
  atlas_index~ : Int32 = 0,
) -> AutoTileMaskRule {
  { mask, region_name, atlas_index, }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileWangRule {
  north : Int32
  east : Int32
  south : Int32
  west : Int32
  region_name : String
  atlas_index : Int32
}

///|
pub extend AutoTileWangRule with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileWangRule with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileWangRule with Eq::{not_equal, equal}

///|
pub extend AutoTileWangRule with ToJson::{to_json}

///|
pub fn AutoTileWangRule::AutoTileWangRule(
  north : Int32,
  east : Int32,
  south : Int32,
  west : Int32,
  region_name : String,
  atlas_index~ : Int32 = 0,
) -> AutoTileWangRule {
  { north, east, south, west, region_name, atlas_index, }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTilePaletteEntry {
  terrain : Int32
  fallback_region_name : String
  fallback_atlas_index : Int32
  bitmask4_rules : Array[AutoTileMaskRule]
  bitmask8_rules : Array[AutoTileMaskRule]
  wang_rules : Array[AutoTileWangRule]
}

///|
pub extend AutoTilePaletteEntry with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTilePaletteEntry with @moonbitlang/core/json.FromJson::{
  from_json,
}

///|
pub extend AutoTilePaletteEntry with Eq::{not_equal, equal}

///|
pub extend AutoTilePaletteEntry with ToJson::{to_json}

///|
pub fn AutoTilePaletteEntry::AutoTilePaletteEntry(
  terrain : Int32,
  fallback_region_name : String,
  fallback_atlas_index~ : Int32 = 0,
  bitmask4_rules~ : Array[AutoTileMaskRule] = [],
  bitmask8_rules~ : Array[AutoTileMaskRule] = [],
  wang_rules~ : Array[AutoTileWangRule] = [],
) -> AutoTilePaletteEntry {
  {
    terrain,
    fallback_region_name,
    fallback_atlas_index,
    bitmask4_rules,
    bitmask8_rules,
    wang_rules,
  }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileLayerSource {
  tile_width : Double
  tile_height : Double
  origin_x : Double
  origin_y : Double
  atlas_asset_path : String
  rule_set : AutoTileRuleSetKind
  palette : Array[AutoTilePaletteEntry]
  cells : Array[AutoTileCell]
}

///|
pub extend AutoTileLayerSource with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileLayerSource with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileLayerSource with Eq::{not_equal, equal}

///|
pub extend AutoTileLayerSource with ToJson::{to_json}

///|
pub fn AutoTileLayerSource::AutoTileLayerSource(
  tile_width~ : Double = 16.0,
  tile_height~ : Double = 16.0,
  origin_x~ : Double = 0.0,
  origin_y~ : Double = 0.0,
  atlas_asset_path~ : String = "",
  rule_set~ : AutoTileRuleSetKind = Bitmask8,
  palette~ : Array[AutoTilePaletteEntry] = [],
  cells~ : Array[AutoTileCell] = [],
) -> AutoTileLayerSource {
  {
    tile_width,
    tile_height,
    origin_x,
    origin_y,
    atlas_asset_path,
    rule_set,
    palette,
    cells,
  }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileSolvedTile {
  x : Int32
  y : Int32
  region_name : String
  atlas_index : Int32
}

///|
pub extend AutoTileSolvedTile with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileSolvedTile with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileSolvedTile with Eq::{not_equal, equal}

///|
pub extend AutoTileSolvedTile with ToJson::{to_json}

///|
pub fn AutoTileSolvedTile::AutoTileSolvedTile(
  x : Int32,
  y : Int32,
  region_name : String,
  atlas_index~ : Int32 = 0,
) -> AutoTileSolvedTile {
  { x, y, region_name, atlas_index, }
}

///|
#derive(Debug, Eq, Hash, ToJson, FromJson)
pub struct AutoTileGridPos {
  x : Int32
  y : Int32
}

///|
pub extend AutoTileGridPos with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileGridPos with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileGridPos with Eq::{not_equal, equal}

///|
pub extend AutoTileGridPos with ToJson::{to_json}

///|
pub fn AutoTileGridPos::AutoTileGridPos(
  x : Int32,
  y : Int32,
) -> AutoTileGridPos {
  { x, y, }
}

///|
#derive(Debug, Eq, ToJson, FromJson)
pub struct AutoTileDiff {
  source : AutoTileLayerSource
  changed_tiles : Array[AutoTileSolvedTile]
  removed_tiles : Array[AutoTileGridPos]
}

///|
pub extend AutoTileDiff with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AutoTileDiff with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AutoTileDiff with Eq::{not_equal, equal}

///|
pub extend AutoTileDiff with ToJson::{to_json}

///|
pub fn AutoTileDiff::AutoTileDiff(
  source : AutoTileLayerSource,
  changed_tiles~ : Array[AutoTileSolvedTile] = [],
  removed_tiles~ : Array[AutoTileGridPos] = [],
) -> AutoTileDiff {
  { source, changed_tiles, removed_tiles, }
}

///|
pub extend AutoTileGridPos with Hash::{hash, hash_combine}
