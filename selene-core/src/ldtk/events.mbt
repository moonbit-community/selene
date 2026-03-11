///|
pub struct LdtkWorldSpawnedEvent {
  world_entity : @entity.Entity
  project : LdtkProject
}

///|
pub struct LdtkLevelSpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  indices : LdtkLevelIndices
  level : LdtkLevel
}

///|
pub struct LdtkLayerSpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  level : LdtkLevel
  layer : LdtkLayerInstance
  effective_visible : Bool
  zindex : Int
}

///|
pub struct LdtkTileSpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  tile_entity : @entity.Entity
  level : LdtkLevel
  layer : LdtkLayerInstance
  tile : LdtkTileInstance
  zindex : Int
}

///|
pub struct LdtkEntitySpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  entity : @entity.Entity
  level : LdtkLevel
  layer : LdtkLayerInstance
  instance : LdtkEntityInstance
  zindex : Int
}

///|
pub struct LdtkIntGridCellSpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  cell_entity : @entity.Entity
  level : LdtkLevel
  layer : LdtkLayerInstance
  value : Int
  grid_x : Int
  grid_y : Int
  zindex : Int
}

///|
pub struct LdtkIntGridColliderSpawnedEvent {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  cell_entity : @entity.Entity
  collider_entity : @entity.Entity
  level : LdtkLevel
  layer : LdtkLayerInstance
  value : Int
  grid_x : Int
  grid_y : Int
  zindex : Int
  sensor : Bool
}

///|
pub enum LdtkLevelEvent {
  SpawnTriggered(String)
  Spawned(String)
  Transformed(String)
  Despawned(String)
}

///|
pub let ldtk_world_spawned_event_bus : @event.Events[LdtkWorldSpawnedEvent] = @event.Events::new()

///|
pub let ldtk_level_spawned_event_bus : @event.Events[LdtkLevelSpawnedEvent] = @event.Events::new()

///|
pub let ldtk_layer_spawned_event_bus : @event.Events[LdtkLayerSpawnedEvent] = @event.Events::new()

///|
pub let ldtk_tile_spawned_event_bus : @event.Events[LdtkTileSpawnedEvent] = @event.Events::new()

///|
pub let ldtk_entity_spawned_event_bus : @event.Events[LdtkEntitySpawnedEvent] = @event.Events::new()

///|
pub let ldtk_int_grid_cell_spawned_event_bus : @event.Events[
  LdtkIntGridCellSpawnedEvent,
] = @event.Events::new()

///|
pub let ldtk_int_grid_collider_spawned_event_bus : @event.Events[
  LdtkIntGridColliderSpawnedEvent,
] = @event.Events::new()

///|
pub let ldtk_level_event_bus : @event.Events[LdtkLevelEvent] = @event.Events::new()

///|
fn init {
  ldtk_world_spawned_event_bus.register()
  ldtk_level_spawned_event_bus.register()
  ldtk_layer_spawned_event_bus.register()
  ldtk_tile_spawned_event_bus.register()
  ldtk_entity_spawned_event_bus.register()
  ldtk_int_grid_cell_spawned_event_bus.register()
  ldtk_int_grid_collider_spawned_event_bus.register()
  ldtk_level_event_bus.register()
}
