///|
fn neighbor_terrain(
  cells : Map[AutoTileGridPos, Int32],
  x : Int32,
  y : Int32,
) -> Int32? {
  cells.get({ x, y, })
}

///|
fn bitmask4(
  cells : Map[AutoTileGridPos, Int32],
  x : Int32,
  y : Int32,
  terrain : Int32,
) -> Int32 {
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
fn bitmask8(
  cells : Map[AutoTileGridPos, Int32],
  x : Int32,
  y : Int32,
  terrain : Int32,
) -> Int32 {
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
fn wang_key(
  cells : Map[AutoTileGridPos, Int32],
  x : Int32,
  y : Int32,
) -> AutoTileWangRule {
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
  terrain : Int32,
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
  cells : Map[AutoTileGridPos, Int32],
  x : Int32,
  y : Int32,
  terrain : Int32,
) -> AutoTileSolvedTile {
  let fallback = { x, y, region_name: "", atlas_index: 0, }
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
fn sorted_cell_keys(
  cells : Map[AutoTileGridPos, Int32],
) -> Array[AutoTileGridPos] {
  let keys : Array[AutoTileGridPos] = []
  for key, _ in cells {
    keys.push(key)
  }
  keys.sort_by(fn(left, right) {
    if left.y == right.y {
      left.x.compare(right.x)
    } else {
      left.y.compare(right.y)
    }
  })
  keys
}

///|
fn cells_map_of(source : AutoTileLayerSource) -> Map[AutoTileGridPos, Int32] {
  let cells : Map[AutoTileGridPos, Int32] = Map([])
  for cell in source.cells {
    cells.set({ x: cell.x, y: cell.y, }, cell.terrain)
  }
  cells
}

///|
fn cells_array_of(map : Map[AutoTileGridPos, Int32]) -> Array[AutoTileCell] {
  let cells : Array[AutoTileCell] = []
  for pos in sorted_cell_keys(map) {
    let terrain = map.get(pos).unwrap_or(0)
    cells.push({ x: pos.x, y: pos.y, terrain, })
  }
  cells
}

///|
fn solve_from_cells(
  source : AutoTileLayerSource,
  cells : Map[AutoTileGridPos, Int32],
) -> Array[AutoTileSolvedTile] {
  let solved : Array[AutoTileSolvedTile] = []
  for pos in sorted_cell_keys(cells) {
    let terrain = cells.get(pos).unwrap_or(0)
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
fn affected_keys(x : Int32, y : Int32) -> Array[AutoTileGridPos] {
  let keys : Array[AutoTileGridPos] = []
  for dy in -1..<=1 {
    for dx in -1..<=1 {
      keys.push({ x: x + dx, y: y + dy, })
    }
  }
  keys
}

///|
fn solved_map_of(
  source : AutoTileLayerSource,
  cells : Map[AutoTileGridPos, Int32],
  keys : Array[AutoTileGridPos],
) -> Map[AutoTileGridPos, AutoTileSolvedTile] {
  let solved : Map[AutoTileGridPos, AutoTileSolvedTile] = Map([])
  for key in keys {
    if cells.contains(key) {
      let terrain = cells.get(key).unwrap_or(0)
      solved.set(key, solved_tile_for(source, cells, key.x, key.y, terrain))
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
  x : Int32,
  y : Int32,
  terrain : Int32?,
) -> AutoTileDiff {
  let before_cells = cells_map_of(source)
  let after_cells : Map[AutoTileGridPos, Int32] = Map([])
  for key, value in before_cells {
    after_cells.set(key, value)
  }
  let target_key = AutoTileGridPos::{ x, y, }
  match terrain {
    Some(value) => after_cells.set(target_key, value)
    None => ignore(after_cells.remove(target_key))
  }
  let source_after = { ..source, cells: cells_array_of(after_cells), }
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
          None => removed.push(key)
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
  { source: source_after, changed_tiles: changed, removed_tiles: removed, }
}
