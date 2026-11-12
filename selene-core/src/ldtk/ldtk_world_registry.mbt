///|
fn ldtk_respawns() -> @ecs.EntityTable[LdtkRespawn] {
  ldtk_world_store().respawns
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
