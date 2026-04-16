///|
fn ldtk_despawn_level(
  world_entity : @entity.Entity,
  level_iid : String,
  level_entity : @entity.Entity,
) -> Unit {
  ldtk_pending_transformed_level_iids().remove(level_iid)
  ldtk_level_event_bus.trigger(Despawned(level_iid), Some(level_entity))
  despawn_ldtk_tree(level_entity)
  ldtk_respawns().remove(level_entity)
  for pair in ldtk_worldly_entities().to_array() {
    if pair.1.world_entity != world_entity {
      continue
    }
    if pair.1.level_iid != level_iid {
      continue
    }
    if !pair.0.is_alive() {
      ldtk_worldly_entities().remove(pair.0)
      continue
    }
    // Keep worldly entities alive across level despawn, matching bevy_ldtk behavior.
  }
}

///|
fn ldtk_force_world_respawn(world_entity : @entity.Entity) -> Unit {
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  for pair in instance.spawned_levels.to_array() {
    ldtk_despawn_level(world_entity, pair.0, pair.1)
    instance.spawned_levels.remove(pair.0)
  }
  for pair in ldtk_worldly_entities().to_array() {
    if pair.1.world_entity != world_entity {
      continue
    }
    if pair.0.is_alive() {
      despawn_ldtk_tree(pair.0)
    }
    ldtk_worldly_entities().remove(pair.0)
  }
}

///|
fn ldtk_force_level_respawns(world_entity : @entity.Entity) -> Unit {
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  for pair in instance.spawned_levels.to_array() {
    let level_iid = pair.0
    let level_entity = pair.1
    if !ldtk_respawns().contains(level_entity) {
      continue
    }
    ldtk_despawn_level(world_entity, level_iid, level_entity)
    instance.spawned_levels.remove(level_iid)
    ldtk_respawns().remove(level_entity)
  }
}

///|
fn ldtk_build_layer_metadata(layer : LdtkLayerInstance) -> LdtkLayerMetadata {
  {
    c_hei: layer.c_hei,
    c_wid: layer.c_wid,
    grid_size: layer.grid_size,
    identifier: layer.identifier,
    opacity: layer.opacity,
    px_total_offset_x: layer.px_total_offset_x,
    px_total_offset_y: layer.px_total_offset_y,
    tileset_def_uid: layer.tileset_def_uid,
    tileset_rel_path: layer.tileset_rel_path,
    layer_type: layer.layer_type,
    iid: layer.iid,
    layer_def_uid: layer.layer_def_uid,
    level_id: layer.level_id,
    optional_rules: layer.optional_rules,
    override_tileset_uid: layer.override_tileset_uid,
    px_offset_x: layer.px_offset_x,
    px_offset_y: layer.px_offset_y,
    seed: layer.seed,
    visible: layer.visible,
  }
}

///|
fn ldtk_entity_position(entity_instance : LdtkEntityInstance) -> @math.Vec2 {
  let width = entity_instance.width.to_double()
  let height = entity_instance.height.to_double()
  let anchor_offset = @math.Vec2(
    width * entity_instance.pivot[X],
    height * entity_instance.pivot[Y],
  )
  entity_instance.px - anchor_offset
}

///|
fn ldtk_layer_grid_size(
  project : LdtkProject,
  layer : LdtkLayerInstance,
) -> Double {
  if layer.grid_size > 0 {
    return layer.grid_size.to_double()
  }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return 16.0 }
  guard project.tileset_by_uid(uid) is Some(tileset) else { return 16.0 }
  if tileset.tile_grid_size > 0 {
    return tileset.tile_grid_size.to_double()
  }
  16.0
}

///|
fn ldtk_layer_tileset_uid(layer : LdtkLayerInstance) -> Int? {
  if layer.override_tileset_uid is Some(uid) {
    return Some(uid)
  }
  layer.tileset_def_uid
}

///|
fn ldtk_layer_tileset_image(
  project : LdtkProject,
  layer : LdtkLayerInstance,
) -> @asset.ImageHandle? {
  if layer.tileset_rel_path is Some(path) {
    return Some(@asset.load_image(project.resolve_path(path)))
  }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return None }
  guard project.tileset_by_uid(uid) is Some(tileset) else { return None }
  guard tileset.rel_path is Some(path) else { return None }
  Some(@asset.load_image(project.resolve_path(path)))
}

///|
fn ldtk_entity_tile_image(
  event : LdtkEntitySpawnedEvent,
  tile : LdtkTilesetRect,
) -> @asset.ImageHandle? {
  guard ldtk_world_instances().get(event.world_entity) is Some(instance) else {
    return None
  }
  if tile.tileset_uid is Some(uid) {
    guard instance.project.tileset_by_uid(uid) is Some(tileset) else {
      return None
    }
    guard tileset.rel_path is Some(path) else { return None }
    return Some(@asset.load_image(instance.project.resolve_path(path)))
  }
  ldtk_layer_tileset_image(instance.project, event.layer)
}

///|
fn ldtk_layered_int_grid_tiles(
  layer : LdtkLayerInstance,
) -> Array[Array[LdtkTileInstance]] {
  let merged_tiles : Array[LdtkTileInstance] = []
  for tile in layer.grid_tiles {
    if ldtk_tile_in_layer_bounds(tile, layer) {
      merged_tiles.push(tile)
    }
  }
  for tile in layer.auto_layer_tiles {
    if ldtk_tile_in_layer_bounds(tile, layer) {
      merged_tiles.push(tile)
    }
  }
  ldtk_layer_grid_tiles(merged_tiles)
}

///|
fn ldtk_layer_grid_tiles(
  tiles : Array[LdtkTileInstance],
) -> Array[Array[LdtkTileInstance]] {
  if tiles.length() == 0 {
    return []
  }
  let layer_tiles : Array[LdtkTileInstance] = []
  let overflow_tiles : Array[LdtkTileInstance] = []
  for tile in tiles {
    if ldtk_tile_exists_at_px(layer_tiles, tile.px) {
      overflow_tiles.push(tile)
    } else {
      layer_tiles.push(tile)
    }
  }
  let layered_tiles : Array[Array[LdtkTileInstance]] = [layer_tiles]
  if overflow_tiles.length() > 0 {
    for overflow_layer in ldtk_layer_grid_tiles(overflow_tiles) {
      layered_tiles.push(overflow_layer)
    }
  }
  layered_tiles
}

///|
fn ldtk_tile_exists_at_px(
  tiles : Array[LdtkTileInstance],
  px : @math.Vec2,
) -> Bool {
  for tile in tiles {
    if tile.px[X] == px[X] && tile.px[Y] == px[Y] {
      return true
    }
  }
  false
}

///|
fn ldtk_tile_in_layer_bounds(
  tile : LdtkTileInstance,
  layer : LdtkLayerInstance,
) -> Bool {
  let max_x = (layer.c_wid * layer.grid_size).to_double()
  let max_y = (layer.c_hei * layer.grid_size).to_double()
  tile.px[X] >= 0.0 &&
  tile.px[Y] >= 0.0 &&
  tile.px[X] < max_x &&
  tile.px[Y] < max_y
}

///|
fn ldtk_tile_source(
  project : LdtkProject,
  layer : LdtkLayerInstance,
  tile : LdtkTileInstance,
) -> @math.Vec2 {
  let fallback = tile.src
  guard tile.tile_id >= 0 else { return fallback }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return fallback }
  guard project.tileset_by_uid(uid) is Some(tileset) else { return fallback }
  if tileset.spacing <= 0 && tileset.padding <= 0 {
    return fallback
  }
  let tile_size = if tileset.tile_grid_size > 0 {
    tileset.tile_grid_size
  } else {
    layer.grid_size
  }
  guard tile_size > 0 else { return fallback }
  let stride = tile_size + tileset.spacing
  guard stride > 0 else { return fallback }
  let available_width = tileset.px_wid - 2 * tileset.padding + tileset.spacing
  guard available_width > 0 else { return fallback }
  let columns = available_width / stride
  guard columns > 0 else { return fallback }
  let tile_x = tile.tile_id % columns
  let tile_y = tile.tile_id / columns
  @math.Vec2(
    (tileset.padding + tile_x * stride).to_double(),
    (tileset.padding + tile_y * stride).to_double(),
  )
}

///|
fn ldtk_tile_custom_data(
  project : LdtkProject,
  layer : LdtkLayerInstance,
  tile : LdtkTileInstance,
) -> String? {
  guard tile.tile_id >= 0 else { return None }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return None }
  project.tileset_tile_custom_data(uid, tile.tile_id)
}

///|
fn ldtk_tile_enum_tags(
  project : LdtkProject,
  layer : LdtkLayerInstance,
  tile : LdtkTileInstance,
) -> Array[String] {
  guard tile.tile_id >= 0 else { return [] }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return [] }
  project.tileset_tile_enum_tags(uid, tile.tile_id)
}

///|
fn ldtk_grid_coords_from_px(
  px : @math.Vec2,
  cell_size : Double,
) -> LdtkGridCoords {
  if cell_size <= 0.0 {
    return { x: 0, y: 0 }
  }
  { x: (px[X] / cell_size).to_int(), y: (px[Y] / cell_size).to_int() }
}

///|
fn ldtk_entity_is_worldly(entity_instance : LdtkEntityInstance) -> Bool {
  ldtk_field_bool(entity_instance.field_instances, "worldly").unwrap_or(
    ldtk_field_bool(entity_instance.field_instances, "Worldly").unwrap_or(false),
  )
}

///|
fn ldtk_apply_int_grid_physics(
  cell_entity : @entity.Entity,
  layer_identifier : String,
  value : Int,
  grid_size : Double,
) -> LdtkIntGridCollider? {
  let physics_settings = ldtk_int_grid_physics_settings.val
  if !physics_settings.matches(layer_identifier, value) {
    return None
  }
  if grid_size <= 0.0 {
    return None
  }
  let size = @math.Vec2(grid_size, grid_size)
  let shape = @physics2d.CollisionShape::Rect(size~, offset=@math.Vec2::zero())
  if physics_settings.as_sensor {
    @physics2d.areas().set(
      cell_entity,
      @physics2d.new_sensor(physics_settings.sensor_filter),
    )
  } else {
    @physics2d.colliders().set(
      cell_entity,
      @physics2d.Collider::new(physics_settings.collision_filter),
    )
  }
  @physics2d.shapes().set(cell_entity, shape)
  let collider = { sensor: physics_settings.as_sensor }
  ldtk_int_grid_colliders().set(cell_entity, collider)
  Some(collider)
}

///|
fn ldtk_level_offset(
  level : LdtkLevel,
  behavior : LdtkLevelSpawnBehavior,
) -> @math.Vec2 {
  match behavior {
    UseZeroTranslation => @math.Vec2::zero()
    UseWorldTranslation(_) =>
      @math.Vec2(level.world_x.to_double(), level.world_y.to_double())
  }
}

///|
fn ldtk_level_zindex(
  level_entity : @entity.Entity,
  settings : LdtkWorldSpawnSettings,
) -> Int {
  guard ldtk_level_instances().get(level_entity) is Some(level_instance) else {
    return settings.zindex
  }
  settings.zindex +
  ldtk_level_order_key(level_instance.indices) * settings.level_z_step
}

///|
fn ldtk_level_order_key(indices : LdtkLevelIndices) -> Int {
  match indices.world {
    Some(world_index) => world_index * 100000 + indices.level
    None => indices.level
  }
}

///|
fn ldtk_world_spawn_behavior(
  settings : LdtkWorldSpawnSettings,
) -> LdtkLevelSpawnBehavior {
  settings.spawn_behavior_override.unwrap_or(
    ldtk_settings.val.level_spawn_behavior,
  )
}

///|
fn ldtk_project_indexed_level_by_iid(
  project : LdtkProject,
  iid : String,
) -> LdtkIndexedLevel? {
  for indexed in project.indexed_levels() {
    if indexed.level.iid == iid {
      return Some(indexed)
    }
  }
  None
}
