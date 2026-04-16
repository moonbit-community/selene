///|
pub fn ldtk_level_instances() -> Map[@entity.Entity, LdtkLevelInstance] {
  ldtk_world_store().ldtk_level_instances
}

///|
pub fn ldtk_layer_metadata() -> Map[@entity.Entity, LdtkLayerMetadata] {
  ldtk_world_store().ldtk_layer_metadata
}

///|
pub fn ldtk_level_backgrounds() -> Map[@entity.Entity, LdtkLevelBackground] {
  ldtk_world_store().ldtk_level_backgrounds
}

///|
pub fn ldtk_level_iids() -> Map[@entity.Entity, LdtkLevelIid] {
  ldtk_world_store().ldtk_level_iids
}

///|
pub fn ldtk_entity_iids() -> Map[@entity.Entity, LdtkEntityIid] {
  ldtk_world_store().ldtk_entity_iids
}

///|
pub fn ldtk_grid_coords() -> Map[@entity.Entity, LdtkGridCoords] {
  ldtk_world_store().ldtk_grid_coords
}

///|
pub fn ldtk_int_grid_cells() -> Map[@entity.Entity, LdtkIntGridCell] {
  ldtk_world_store().ldtk_int_grid_cells
}

///|
pub fn ldtk_tile_metadata() -> Map[@entity.Entity, LdtkTileMetadata] {
  ldtk_world_store().ldtk_tile_metadata
}

///|
pub fn ldtk_int_grid_colliders() -> Map[@entity.Entity, LdtkIntGridCollider] {
  ldtk_world_store().ldtk_int_grid_colliders
}

///|
pub fn ldtk_worldly_entities() -> Map[@entity.Entity, LdtkWorldly] {
  ldtk_world_store().ldtk_worldly_entities
}

///|
pub fn ldtk_respawns() -> Map[@entity.Entity, LdtkRespawn] {
  ldtk_world_store().ldtk_respawns
}

///|
pub fn ldtk_spawned_layer_instances() -> Map[
  @entity.Entity,
  LdtkSpawnedLayerInstance,
] {
  ldtk_world_store().ldtk_spawned_layer_instances
}

///|
pub fn ldtk_spawned_tile_instances() -> Map[
  @entity.Entity,
  LdtkSpawnedTileInstance,
] {
  ldtk_world_store().ldtk_spawned_tile_instances
}

///|
pub fn ldtk_spawned_entity_instances() -> Map[
  @entity.Entity,
  LdtkSpawnedEntityInstance,
] {
  ldtk_world_store().ldtk_spawned_entity_instances
}

///|
pub fn ldtk_spawned_int_grid_cells() -> Map[
  @entity.Entity,
  LdtkSpawnedIntGridCell,
] {
  ldtk_world_store().ldtk_spawned_int_grid_cells
}

///|
pub fn ldtk_entity_spawn_hooks() -> Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_entity_spawn_hooks
}

///|
pub fn ldtk_entity_layer_spawn_hooks() -> Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_entity_layer_spawn_hooks
}

///|
pub fn ldtk_entity_layer_identifier_spawn_hooks() -> Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_entity_layer_identifier_spawn_hooks
}

///|
pub fn ldtk_entity_default_spawn_hook() -> Ref[
  ((LdtkEntitySpawnedEvent) -> Unit)?,
] {
  ldtk_world_store().ldtk_entity_default_spawn_hook
}

///|
pub fn ldtk_int_grid_layer_spawn_hooks() -> Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_int_grid_layer_spawn_hooks
}

///|
pub fn ldtk_int_grid_cell_spawn_hooks() -> Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_int_grid_cell_spawn_hooks
}

///|
pub fn ldtk_int_grid_value_spawn_hooks() -> Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_int_grid_value_spawn_hooks
}

///|
pub fn ldtk_int_grid_default_spawn_hook() -> Ref[
  ((LdtkIntGridCellSpawnedEvent) -> Unit)?,
] {
  ldtk_world_store().ldtk_int_grid_default_spawn_hook
}

///|
pub fn ldtk_entity_typed_registrations() -> Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_entity_typed_registrations
}

///|
pub fn ldtk_int_cell_typed_registrations() -> Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] {
  ldtk_world_store().ldtk_int_cell_typed_registrations
}
