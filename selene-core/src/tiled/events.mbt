///|
pub struct TiledWorldSpawnedEvent {
  world_entity : @entity.Entity
  world : TiledWorld
}

///|
pub struct TiledWorldMapSpawnedEvent {
  world_entity : @entity.Entity
  map_entity : @entity.Entity
  world_map : TiledWorldMap
  map : TiledMap
  resolved_map_path : String
}

///|
pub struct TiledMapSpawnedEvent {
  map_entity : @entity.Entity
  map : TiledMap
}

///|
pub struct TiledLayerSpawnedEvent {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : TiledLayer
  effective_visible : Bool
  zindex : Int
}

///|
pub struct TiledTileSpawnedEvent {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  tile_entity : @entity.Entity
  layer : TiledLayer
  gid : TiledGid
  tileset : TiledTileset
  cell : TiledCell
}

///|
pub struct TiledObjectSpawnedEvent {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  object_entity : @entity.Entity
  layer : TiledLayer
  object : TiledObject
}

///|
pub struct TiledImageLayerSpawnedEvent {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : TiledLayer
  image_layer : TiledImageLayer
  resolved_image_path : String?
}

///|
pub let tiled_world_spawned_event_bus : @event.Events[TiledWorldSpawnedEvent] = @event.Events()

///|
pub let tiled_world_map_spawned_event_bus : @event.Events[
  TiledWorldMapSpawnedEvent,
] = @event.Events()

///|
pub let tiled_map_spawned_event_bus : @event.Events[TiledMapSpawnedEvent] = @event.Events()

///|
pub let tiled_layer_spawned_event_bus : @event.Events[TiledLayerSpawnedEvent] = @event.Events()

///|
pub let tiled_tile_spawned_event_bus : @event.Events[TiledTileSpawnedEvent] = @event.Events()

///|
pub let tiled_object_spawned_event_bus : @event.Events[TiledObjectSpawnedEvent] = @event.Events()

///|
pub let tiled_image_layer_spawned_event_bus : @event.Events[
  TiledImageLayerSpawnedEvent,
] = @event.Events()
