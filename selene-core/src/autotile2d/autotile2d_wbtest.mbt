///|
fn mask_rule(mask : Int, name : String) -> AutoTileMaskRule {
  { mask, region_name: name, atlas_index: mask }
}

///|
fn wang_rule(
  north : Int,
  east : Int,
  south : Int,
  west : Int,
  name : String,
  index : Int,
) -> AutoTileWangRule {
  { north, east, south, west, region_name: name, atlas_index: index }
}

///|
fn test_source(
  rule_set : AutoTileRuleSetKind,
  palette : Array[AutoTilePaletteEntry],
  cells : Array[AutoTileCell],
) -> AutoTileLayerSource {
  {
    tile_width: 16.0,
    tile_height: 16.0,
    origin_x: 0.0,
    origin_y: 0.0,
    atlas_asset_path: "assets/atlases/demo.atlas.json",
    rule_set,
    palette,
    cells,
  }
}

///|
fn solved_name_at(
  solved : Array[AutoTileSolvedTile],
  x : Int,
  y : Int,
) -> String {
  for tile in solved {
    if tile.x == x && tile.y == y {
      return tile.region_name
    }
  }
  ""
}

///|
fn solved_index_at(solved : Array[AutoTileSolvedTile], x : Int, y : Int) -> Int {
  for tile in solved {
    if tile.x == x && tile.y == y {
      return tile.atlas_index
    }
  }
  -1
}

///|
test "bitmask4 solves all neighbor directions deterministically" {
  let rules : Array[AutoTileMaskRule] = []
  for mask = 0; mask < 16; mask = mask + 1 {
    rules.push(mask_rule(mask, "m" + mask.to_string()))
  }
  let palette = [
    {
      terrain: 1,
      fallback_region_name: "fallback",
      fallback_atlas_index: 999,
      bitmask4_rules: rules,
      bitmask8_rules: [],
      wang_rules: [],
    },
  ]
  for mask = 0; mask < 16; mask = mask + 1 {
    let cells : Array[AutoTileCell] = [{ x: 0, y: 0, terrain: 1 }]
    if (mask & 1) != 0 {
      cells.push({ x: 0, y: -1, terrain: 1 })
    }
    if (mask & 2) != 0 {
      cells.push({ x: 1, y: 0, terrain: 1 })
    }
    if (mask & 4) != 0 {
      cells.push({ x: 0, y: 1, terrain: 1 })
    }
    if (mask & 8) != 0 {
      cells.push({ x: -1, y: 0, terrain: 1 })
    }
    let source = test_source(Bitmask4, palette, cells)
    let solved = solve_autotile_layer(source)
    inspect(solved_name_at(solved, 0, 0), content="m" + mask.to_string())
  }
}

///|
test "bitmask8 supports corner-aware diagonal masking" {
  let palette = [
    {
      terrain: 2,
      fallback_region_name: "fallback8",
      fallback_atlas_index: 0,
      bitmask4_rules: [],
      bitmask8_rules: [
        mask_rule(0, "m0"),
        mask_rule(7, "m7"),
        mask_rule(255, "m255"),
      ],
      wang_rules: [],
    },
  ]
  let source = test_source(Bitmask8, palette, [
    { x: 0, y: 0, terrain: 2 },
    { x: 0, y: -1, terrain: 2 },
    { x: 1, y: 0, terrain: 2 },
    { x: 1, y: -1, terrain: 2 },
  ])
  let solved = solve_autotile_layer(source)
  inspect(solved_name_at(solved, 0, 0), content="m7")
}

///|
test "bitmask8 reachable mask set is the canonical 47-tiles subset" {
  let rules : Array[AutoTileMaskRule] = []
  for mask = 0; mask < 256; mask = mask + 1 {
    rules.push(mask_rule(mask, "m" + mask.to_string()))
  }
  let palette = [
    autotile_palette_entry(
      7,
      "fallback8",
      fallback_atlas_index=999,
      bitmask8_rules=rules,
    ),
  ]
  let reachable_masks : Map[Int, Bool] = {}
  // Neighbor bit order (for generated input combinations):
  // 0:N, 1:E, 2:S, 3:W, 4:NE, 5:SE, 6:SW, 7:NW
  for combo = 0; combo < 256; combo = combo + 1 {
    let cells : Array[AutoTileCell] = [autotile_cell(0, 0, 7)]
    if (combo & 1) != 0 {
      cells.push(autotile_cell(0, -1, 7))
    }
    if (combo & 2) != 0 {
      cells.push(autotile_cell(1, 0, 7))
    }
    if (combo & 4) != 0 {
      cells.push(autotile_cell(0, 1, 7))
    }
    if (combo & 8) != 0 {
      cells.push(autotile_cell(-1, 0, 7))
    }
    if (combo & 16) != 0 {
      cells.push(autotile_cell(1, -1, 7))
    }
    if (combo & 32) != 0 {
      cells.push(autotile_cell(1, 1, 7))
    }
    if (combo & 64) != 0 {
      cells.push(autotile_cell(-1, 1, 7))
    }
    if (combo & 128) != 0 {
      cells.push(autotile_cell(-1, -1, 7))
    }
    let source = test_source(Bitmask8, palette, cells)
    let solved = solve_autotile_layer(source)
    let resolved_mask = solved_index_at(solved, 0, 0)
    if resolved_mask >= 0 {
      reachable_masks.set(resolved_mask, true)
    }
  }
  inspect(reachable_masks.length(), content="47")
}

///|
test "wang rules are matched by cardinal neighbor terrains" {
  let palette = [
    {
      terrain: 5,
      fallback_region_name: "fallback-wang",
      fallback_atlas_index: 0,
      bitmask4_rules: [],
      bitmask8_rules: [],
      wang_rules: [wang_rule(0, 3, 0, 4, "wang-0-3-0-4", 12)],
    },
  ]
  let source = test_source(Wang, palette, [
    { x: 0, y: 0, terrain: 5 },
    { x: 1, y: 0, terrain: 3 },
    { x: -1, y: 0, terrain: 4 },
  ])
  let solved = solve_autotile_layer(source)
  inspect(solved_name_at(solved, 0, 0), content="wang-0-3-0-4")
}

///|
test "wang rules fallback when no explicit edge tuple matches" {
  let palette = [
    autotile_palette_entry(5, "wang-fallback", wang_rules=[
      wang_rule(1, 1, 1, 1, "never-hit", 2),
    ]),
  ]
  let source = test_source(Wang, palette, [
    autotile_cell(0, 0, 5),
    autotile_cell(1, 0, 3),
  ])
  let solved = solve_autotile_layer(source)
  inspect(solved_name_at(solved, 0, 0), content="wang-fallback")
}

///|
test "update_cell_and_resolve_diff only changes local neighborhood" {
  let palette = [
    {
      terrain: 1,
      fallback_region_name: "base",
      fallback_atlas_index: 0,
      bitmask4_rules: [
        mask_rule(0, "m0"),
        mask_rule(2, "m2"),
        mask_rule(8, "m8"),
        mask_rule(10, "m10"),
      ],
      bitmask8_rules: [],
      wang_rules: [],
    },
  ]
  let source = test_source(Bitmask4, palette, [
    { x: 0, y: 0, terrain: 1 },
    { x: 1, y: 0, terrain: 1 },
  ])
  let diff = update_cell_and_resolve_diff(source, 2, 0, Some(1))
  inspect(diff.source.cells.length(), content="3")
  inspect(diff.changed_tiles.length() >= 1, content="true")
  inspect(diff.removed_tiles.is_empty(), content="true")
  for changed in diff.changed_tiles {
    let dx = (changed.x - 2).abs()
    let dy = (changed.y - 0).abs()
    inspect(dx <= 1 && dy <= 1, content="true")
  }
}

///|
test "runtime layer cell updates keep source state in sync" {
  let source = test_source(
    Bitmask4,
    [autotile_palette_entry(1, "base", bitmask4_rules=[mask_rule(0, "m0")])],
    [autotile_cell(0, 0, 1)],
  )
  let layer = @entity.Entity::new()
  register_runtime_layer(layer, source)
  inspect(runtime_layer_source(layer) is Some(_), content="true")
  set_runtime_cell(layer, 1, 0, 1)
  let source_after_add = runtime_layer_source(layer).unwrap()
  inspect(source_after_add.cells.length(), content="2")
  remove_runtime_cell(layer, 1, 0)
  let source_after_remove = runtime_layer_source(layer).unwrap()
  inspect(source_after_remove.cells.length(), content="1")
  layer.destroy()
}
