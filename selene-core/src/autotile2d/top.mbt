///|
pub enum AutoTileRuleSetKind {
  Bitmask4
  Bitmask8
  Wang
} derive(Debug, Eq, ToJson, FromJson)

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
pub struct AutoTileCell {
  x : Int
  y : Int
  terrain : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_cell(x : Int, y : Int, terrain : Int) -> AutoTileCell {
  { x, y, terrain }
}

///|
pub struct AutoTileMaskRule {
  mask : Int
  region_name : String
  atlas_index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_mask_rule(
  mask : Int,
  region_name : String,
  atlas_index? : Int = 0,
) -> AutoTileMaskRule {
  { mask, region_name, atlas_index }
}

///|
pub struct AutoTileWangRule {
  north : Int
  east : Int
  south : Int
  west : Int
  region_name : String
  atlas_index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_wang_rule(
  north : Int,
  east : Int,
  south : Int,
  west : Int,
  region_name : String,
  atlas_index? : Int = 0,
) -> AutoTileWangRule {
  { north, east, south, west, region_name, atlas_index }
}

///|
pub struct AutoTilePaletteEntry {
  terrain : Int
  fallback_region_name : String
  fallback_atlas_index : Int
  bitmask4_rules : Array[AutoTileMaskRule]
  bitmask8_rules : Array[AutoTileMaskRule]
  wang_rules : Array[AutoTileWangRule]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_palette_entry(
  terrain : Int,
  fallback_region_name : String,
  fallback_atlas_index? : Int = 0,
  bitmask4_rules? : Array[AutoTileMaskRule] = [],
  bitmask8_rules? : Array[AutoTileMaskRule] = [],
  wang_rules? : Array[AutoTileWangRule] = [],
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
pub struct AutoTileLayerSource {
  tile_width : Double
  tile_height : Double
  origin_x : Double
  origin_y : Double
  atlas_asset_path : String
  rule_set : AutoTileRuleSetKind
  palette : Array[AutoTilePaletteEntry]
  cells : Array[AutoTileCell]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_layer_source(
  tile_width? : Double = 16.0,
  tile_height? : Double = 16.0,
  origin_x? : Double = 0.0,
  origin_y? : Double = 0.0,
  atlas_asset_path? : String = "",
  rule_set? : AutoTileRuleSetKind = Bitmask8,
  palette? : Array[AutoTilePaletteEntry] = [],
  cells? : Array[AutoTileCell] = [],
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
pub struct AutoTileSolvedTile {
  x : Int
  y : Int
  region_name : String
  atlas_index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_solved_tile(
  x : Int,
  y : Int,
  region_name : String,
  atlas_index? : Int = 0,
) -> AutoTileSolvedTile {
  { x, y, region_name, atlas_index }
}

///|
pub struct AutoTileGridPos {
  x : Int
  y : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_grid_pos(x : Int, y : Int) -> AutoTileGridPos {
  { x, y }
}

///|
pub struct AutoTileDiff {
  source : AutoTileLayerSource
  changed_tiles : Array[AutoTileSolvedTile]
  removed_tiles : Array[AutoTileGridPos]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn autotile_diff(
  source : AutoTileLayerSource,
  changed_tiles? : Array[AutoTileSolvedTile] = [],
  removed_tiles? : Array[AutoTileGridPos] = [],
) -> AutoTileDiff {
  { source, changed_tiles, removed_tiles }
}

///|
pub struct AutoTileVisual {
  image_path : String?
  rect : @math.Rect?
  custom_size : @math.Vec2?
  anchor : @sprite.Anchor
}

///|
pub fn autotile_visual(
  image_path? : String? = None,
  rect? : @math.Rect? = None,
  custom_size? : @math.Vec2? = None,
  anchor? : @sprite.Anchor = @sprite.default_anchor(),
) -> AutoTileVisual {
  { image_path, rect, custom_size, anchor }
}

///|
pub type AutoTileVisualResolver = (AutoTileLayerSource, AutoTileSolvedTile) -> AutoTileVisual?

///|
pub struct AutoTileRuntimeContext {
  visual_resolver : AutoTileVisualResolver?
  z : Double
}

///|
pub fn autotile_runtime_context(
  visual_resolver? : AutoTileVisualResolver? = None,
  z? : Double = 0.0,
) -> AutoTileRuntimeContext {
  { visual_resolver, z }
}

///|
fn cell_key(x : Int, y : Int) -> String {
  x.to_string() + "," + y.to_string()
}

///|
fn pos_of_key(key : String) -> AutoTileGridPos {
  let comma = key.find(",").unwrap_or(-1)
  if comma <= 0 || comma + 1 >= key.length() {
    return { x: 0, y: 0 }
  }
  let x = @string.parse_int(key[:comma], base=10) catch { _ => 0 }
  let y = @string.parse_int(key[comma + 1:], base=10) catch { _ => 0 }
  { x, y }
}

///|
fn neighbor_terrain(cells : Map[String, Int], x : Int, y : Int) -> Int? {
  cells.get(cell_key(x, y))
}

///|
fn bitmask4(cells : Map[String, Int], x : Int, y : Int, terrain : Int) -> Int {
  let north = neighbor_terrain(cells, x, y - 1) == Some(terrain)
  let east = neighbor_terrain(cells, x + 1, y) == Some(terrain)
  let south = neighbor_terrain(cells, x, y + 1) == Some(terrain)
  let west = neighbor_terrain(cells, x - 1, y) == Some(terrain)
  (if north { 1 } else { 0 }) |
  (if east { 2 } else { 0 }) |
  (if south { 4 } else { 0 }) |
  (if west { 8 } else { 0 })
}

///|
fn bitmask8(cells : Map[String, Int], x : Int, y : Int, terrain : Int) -> Int {
  let north = neighbor_terrain(cells, x, y - 1) == Some(terrain)
  let east = neighbor_terrain(cells, x + 1, y) == Some(terrain)
  let south = neighbor_terrain(cells, x, y + 1) == Some(terrain)
  let west = neighbor_terrain(cells, x - 1, y) == Some(terrain)
  let north_east = north &&
    east &&
    neighbor_terrain(cells, x + 1, y - 1) == Some(terrain)
  let south_east = south &&
    east &&
    neighbor_terrain(cells, x + 1, y + 1) == Some(terrain)
  let south_west = south &&
    west &&
    neighbor_terrain(cells, x - 1, y + 1) == Some(terrain)
  let north_west = north &&
    west &&
    neighbor_terrain(cells, x - 1, y - 1) == Some(terrain)
  (if north { 1 } else { 0 }) |
  (if north_east { 2 } else { 0 }) |
  (if east { 4 } else { 0 }) |
  (if south_east { 8 } else { 0 }) |
  (if south { 16 } else { 0 }) |
  (if south_west { 32 } else { 0 }) |
  (if west { 64 } else { 0 }) |
  (if north_west { 128 } else { 0 })
}

///|
fn wang_key(cells : Map[String, Int], x : Int, y : Int) -> AutoTileWangRule {
  {
    north: neighbor_terrain(cells, x, y - 1).unwrap_or(0),
    east: neighbor_terrain(cells, x + 1, y).unwrap_or(0),
    south: neighbor_terrain(cells, x, y + 1).unwrap_or(0),
    west: neighbor_terrain(cells, x - 1, y).unwrap_or(0),
    region_name: "",
    atlas_index: 0,
  }
}

///|
fn palette_for_terrain(
  source : AutoTileLayerSource,
  terrain : Int,
) -> AutoTilePaletteEntry? {
  for entry in source.palette {
    if entry.terrain == terrain {
      return Some(entry)
    }
  }
  None
}

///|
fn solved_tile_for(
  source : AutoTileLayerSource,
  cells : Map[String, Int],
  x : Int,
  y : Int,
  terrain : Int,
) -> AutoTileSolvedTile {
  let fallback = { x, y, region_name: "", atlas_index: 0 }
  let palette = match palette_for_terrain(source, terrain) {
    Some(entry) => entry
    None => return fallback
  }
  match source.rule_set {
    Bitmask4 => {
      let mask = bitmask4(cells, x, y, terrain)
      for rule in palette.bitmask4_rules {
        if rule.mask == mask {
          return {
            x,
            y,
            region_name: rule.region_name,
            atlas_index: rule.atlas_index,
          }
        }
      }
    }
    Bitmask8 => {
      let mask = bitmask8(cells, x, y, terrain)
      for rule in palette.bitmask8_rules {
        if rule.mask == mask {
          return {
            x,
            y,
            region_name: rule.region_name,
            atlas_index: rule.atlas_index,
          }
        }
      }
    }
    Wang => {
      let key = wang_key(cells, x, y)
      for rule in palette.wang_rules {
        if rule.north == key.north &&
          rule.east == key.east &&
          rule.south == key.south &&
          rule.west == key.west {
          return {
            x,
            y,
            region_name: rule.region_name,
            atlas_index: rule.atlas_index,
          }
        }
      }
    }
  }
  {
    x,
    y,
    region_name: palette.fallback_region_name,
    atlas_index: palette.fallback_atlas_index,
  }
}

///|
fn sorted_cell_keys(cells : Map[String, Int]) -> Array[String] {
  let keys : Array[String] = []
  for key, _ in cells {
    keys.push(key)
  }
  keys.sort_by(fn(left, right) {
    let l = pos_of_key(left)
    let r = pos_of_key(right)
    if l.y == r.y {
      l.x.compare(r.x)
    } else {
      l.y.compare(r.y)
    }
  })
  keys
}

///|
fn cells_map_of(source : AutoTileLayerSource) -> Map[String, Int] {
  let cells : Map[String, Int] = {}
  for cell in source.cells {
    cells.set(cell_key(cell.x, cell.y), cell.terrain)
  }
  cells
}

///|
fn cells_array_of(map : Map[String, Int]) -> Array[AutoTileCell] {
  let cells : Array[AutoTileCell] = []
  for key in sorted_cell_keys(map) {
    let pos = pos_of_key(key)
    let terrain = map.get(key).unwrap_or(0)
    cells.push({ x: pos.x, y: pos.y, terrain })
  }
  cells
}

///|
fn solve_from_cells(
  source : AutoTileLayerSource,
  cells : Map[String, Int],
) -> Array[AutoTileSolvedTile] {
  let solved : Array[AutoTileSolvedTile] = []
  for key in sorted_cell_keys(cells) {
    let pos = pos_of_key(key)
    let terrain = cells.get(key).unwrap_or(0)
    solved.push(solved_tile_for(source, cells, pos.x, pos.y, terrain))
  }
  solved
}

///|
pub fn solve_autotile_layer(
  source : AutoTileLayerSource,
) -> Array[AutoTileSolvedTile] {
  solve_from_cells(source, cells_map_of(source))
}

///|
fn affected_keys(x : Int, y : Int) -> Array[String] {
  let keys : Array[String] = []
  for dy = -1; dy <= 1; dy = dy + 1 {
    for dx = -1; dx <= 1; dx = dx + 1 {
      keys.push(cell_key(x + dx, y + dy))
    }
  }
  keys
}

///|
fn solved_map_of(
  source : AutoTileLayerSource,
  cells : Map[String, Int],
  keys : Array[String],
) -> Map[String, AutoTileSolvedTile] {
  let solved : Map[String, AutoTileSolvedTile] = {}
  for key in keys {
    if cells.contains(key) {
      let pos = pos_of_key(key)
      let terrain = cells.get(key).unwrap_or(0)
      solved.set(key, solved_tile_for(source, cells, pos.x, pos.y, terrain))
    }
  }
  solved
}

///|
fn sort_solved_tiles(tiles : Array[AutoTileSolvedTile]) -> Unit {
  tiles.sort_by(fn(left, right) {
    if left.y == right.y {
      left.x.compare(right.x)
    } else {
      left.y.compare(right.y)
    }
  })
}

///|
fn sort_grid_positions(positions : Array[AutoTileGridPos]) -> Unit {
  positions.sort_by(fn(left, right) {
    if left.y == right.y {
      left.x.compare(right.x)
    } else {
      left.y.compare(right.y)
    }
  })
}

///|
pub fn update_cell_and_resolve_diff(
  source : AutoTileLayerSource,
  x : Int,
  y : Int,
  terrain : Int?,
) -> AutoTileDiff {
  let before_cells = cells_map_of(source)
  let after_cells : Map[String, Int] = {}
  for key, value in before_cells {
    after_cells.set(key, value)
  }
  let target_key = cell_key(x, y)
  match terrain {
    Some(value) => after_cells.set(target_key, value)
    None => ignore(after_cells.remove(target_key))
  }
  let source_after = { ..source, cells: cells_array_of(after_cells) }
  let keys = affected_keys(x, y)
  let before_solved = solved_map_of(source, before_cells, keys)
  let after_solved = solved_map_of(source_after, after_cells, keys)
  let changed : Array[AutoTileSolvedTile] = []
  let removed : Array[AutoTileGridPos] = []
  for key in keys {
    let before = before_solved.get(key)
    let after = after_solved.get(key)
    match before {
      Some(left) =>
        match after {
          Some(right) => if left != right { changed.push(right) }
          None => removed.push(pos_of_key(key))
        }
      None =>
        match after {
          Some(right) => changed.push(right)
          None => ()
        }
    }
  }
  sort_solved_tiles(changed)
  sort_grid_positions(removed)
  { source: source_after, changed_tiles: changed, removed_tiles: removed }
}

///|
priv struct RuntimeLayerState {
  source : AutoTileLayerSource
  tile_entities : Map[String, @entity.Entity]
  context : AutoTileRuntimeContext
}

///|
priv struct AutoTileWorldStore {
  layers : Map[@entity.Entity, RuntimeLayerState]
}

///|
let autotile_world_stores : Map[UInt, AutoTileWorldStore] = {}

///|
fn autotile_world_store() -> AutoTileWorldStore {
  let world_id = @ecs.require_current_world().id()
  autotile_world_stores.get_or_init(world_id, fn() { { layers: {} } })
}

///|
fn tile_position(source : AutoTileLayerSource, x : Int, y : Int) -> @math.Vec2 {
  @math.Vec2(
    source.origin_x + (x.to_double() + 0.5) * source.tile_width,
    source.origin_y + (y.to_double() + 0.5) * source.tile_height,
  )
}

///|
fn apply_tile_visual(
  layer_entity : @entity.Entity,
  source : AutoTileLayerSource,
  solved : AutoTileSolvedTile,
  context : AutoTileRuntimeContext,
) -> @entity.Entity? {
  let visual = match context.visual_resolver {
    Some(resolve) => resolve(source, solved)
    None => None
  }
  guard visual is Some(visual) else { return None }
  let tile_entity = @entity.Entity()
  tile_entity.set_parent(layer_entity)
  let position = tile_position(source, solved.x, solved.y)
  @transform.transforms().set(
    tile_entity,
    @transform.Transform::from_xyz(position[X], position[Y], context.z),
  )
  @sprite.sprites().set(
    tile_entity,
    @sprite.Sprite(
      image=visual.image_path.map(fn(path) { @asset.load_image(path) }),
      rect=visual.rect,
      custom_size=visual.custom_size,
      anchor=visual.anchor,
    ),
  )
  Some(tile_entity)
}

///|
fn destroy_layer_tiles(state : RuntimeLayerState) -> Unit {
  for _, tile_entity in state.tile_entities {
    tile_entity.destroy()
  }
}

///|
pub fn register_runtime_layer(
  layer_entity : @entity.Entity,
  source : AutoTileLayerSource,
  context? : AutoTileRuntimeContext = autotile_runtime_context(),
) -> Unit {
  let store = autotile_world_store()
  if store.layers.get(layer_entity) is Some(previous) {
    destroy_layer_tiles(previous)
    ignore(store.layers.remove(layer_entity))
  }
  let state : RuntimeLayerState = { source, tile_entities: {}, context }
  for solved in solve_autotile_layer(source) {
    let key = cell_key(solved.x, solved.y)
    if apply_tile_visual(layer_entity, source, solved, context)
      is Some(tile_entity) {
      state.tile_entities.set(key, tile_entity)
    }
  }
  store.layers.set(layer_entity, state)
}

///|
fn apply_diff_to_runtime(
  layer_entity : @entity.Entity,
  state : RuntimeLayerState,
  diff : AutoTileDiff,
) -> RuntimeLayerState {
  let tile_entities : Map[String, @entity.Entity] = {}
  for key, value in state.tile_entities {
    tile_entities.set(key, value)
  }
  for removed in diff.removed_tiles {
    let key = cell_key(removed.x, removed.y)
    if tile_entities.get(key) is Some(entity_) {
      entity_.destroy()
      ignore(tile_entities.remove(key))
    }
  }
  for changed in diff.changed_tiles {
    let key = cell_key(changed.x, changed.y)
    if tile_entities.get(key) is Some(entity_) {
      entity_.destroy()
      ignore(tile_entities.remove(key))
    }
    if apply_tile_visual(layer_entity, diff.source, changed, state.context)
      is Some(entity_) {
      tile_entities.set(key, entity_)
    }
  }
  { source: diff.source, tile_entities, context: state.context }
}

///|
pub fn set_runtime_cell(
  layer_entity : @entity.Entity,
  x : Int,
  y : Int,
  terrain : Int,
) -> Unit {
  let store = autotile_world_store()
  guard store.layers.get(layer_entity) is Some(state) else { return }
  let diff = update_cell_and_resolve_diff(state.source, x, y, Some(terrain))
  store.layers.set(
    layer_entity,
    apply_diff_to_runtime(layer_entity, state, diff),
  )
}

///|
pub fn remove_runtime_cell(
  layer_entity : @entity.Entity,
  x : Int,
  y : Int,
) -> Unit {
  let store = autotile_world_store()
  guard store.layers.get(layer_entity) is Some(state) else { return }
  let diff = update_cell_and_resolve_diff(state.source, x, y, None)
  store.layers.set(
    layer_entity,
    apply_diff_to_runtime(layer_entity, state, diff),
  )
}

///|
pub fn rebuild_runtime_layer(layer_entity : @entity.Entity) -> Unit {
  let store = autotile_world_store()
  guard store.layers.get(layer_entity) is Some(state) else { return }
  register_runtime_layer(layer_entity, state.source, context=state.context)
}

///|
pub fn runtime_layer_source(
  layer_entity : @entity.Entity,
) -> AutoTileLayerSource? {
  autotile_world_store().layers
  .get(layer_entity)
  .map(fn(state) { state.source })
}
