///|
pub fn ldtk_level_instances() -> @ecs.ComponentStore[LdtkLevelInstance] {
  @ecs.components()
}

///|
pub fn ldtk_layer_metadata() -> @ecs.ComponentStore[LdtkLayerMetadata] {
  @ecs.components()
}

///|
pub fn ldtk_level_backgrounds() -> @ecs.ComponentStore[LdtkLevelBackground] {
  @ecs.components()
}

///|
pub fn ldtk_level_iids() -> @ecs.ComponentStore[LdtkLevelIid] {
  @ecs.components()
}

///|
pub fn ldtk_entity_iids() -> @ecs.ComponentStore[LdtkEntityIid] {
  @ecs.components()
}

///|
pub fn ldtk_grid_coords() -> @ecs.ComponentStore[LdtkGridCoords] {
  @ecs.components()
}

///|
pub fn ldtk_int_grid_cells() -> @ecs.ComponentStore[LdtkIntGridCell] {
  @ecs.components()
}

///|
pub fn ldtk_tile_metadata() -> @ecs.ComponentStore[LdtkTileMetadata] {
  @ecs.components()
}

///|
pub fn ldtk_int_grid_colliders() -> @ecs.ComponentStore[LdtkIntGridCollider] {
  @ecs.components()
}

///|
pub fn ldtk_worldly_entities() -> @ecs.ComponentStore[LdtkWorldly] {
  @ecs.components()
}

///|
pub fn ldtk_respawns() -> @ecs.EntityTable[LdtkRespawn] {
  ldtk_world_store().respawns
}

///|
pub fn ldtk_spawned_layer_instances() -> @ecs.ComponentStore[
  LdtkSpawnedLayerInstance,
] {
  @ecs.components()
}

///|
pub fn ldtk_spawned_tile_instances() -> @ecs.ComponentStore[
  LdtkSpawnedTileInstance,
] {
  @ecs.components()
}

///|
pub fn ldtk_spawned_entity_instances() -> @ecs.ComponentStore[
  LdtkSpawnedEntityInstance,
] {
  @ecs.components()
}

///|
pub fn ldtk_spawned_int_grid_cells() -> @ecs.ComponentStore[
  LdtkSpawnedIntGridCell,
] {
  @ecs.components()
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
  (LdtkEntitySpawn) -> Unit,
] {
  ldtk_world_store().ldtk_entity_typed_registrations
}

///|
pub fn ldtk_int_cell_typed_registrations() -> Map[
  String,
  (LdtkIntGridCellSpawn) -> Unit,
] {
  ldtk_world_store().ldtk_int_cell_typed_registrations
}
