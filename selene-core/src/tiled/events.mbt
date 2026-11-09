///|
pub struct TiledWorldSpawnedEvent {
  world_entity : @ecs.Entity
  world : TiledWorld
}

///|
pub struct TiledWorldMapSpawnedEvent {
  world_entity : @ecs.Entity
  map_entity : @ecs.Entity
  world_map : TiledWorldMap
  map : TiledMap
  resolved_map_path : String
}

///|
pub struct TiledMapSpawnedEvent {
  map_entity : @ecs.Entity
  map : TiledMap
}

///|
pub struct TiledLayerSpawnedEvent {
  map_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  layer : TiledLayer
  effective_visible : Bool
  zindex : Int32
}

///|
pub struct TiledTileSpawnedEvent {
  map_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  tile_entity : @ecs.Entity
  layer : TiledLayer
  gid : TiledGid
  tileset : TiledTileset
  cell : TiledCell
}

///|
pub struct TiledObjectSpawnedEvent {
  map_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  object_entity : @ecs.Entity
  layer : TiledLayer
  object : TiledObject
}

///|
pub struct TiledImageLayerSpawnedEvent {
  map_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  layer : TiledLayer
  image_layer : TiledImageLayer
  resolved_image_path : String?
}

///|
pub let tiled_world_spawned_event_bus : @event.Events[TiledWorldSpawnedEvent] = Events()

///|
pub let tiled_world_map_spawned_event_bus : @event.Events[
  TiledWorldMapSpawnedEvent,
] = Events()

///|
pub let tiled_map_spawned_event_bus : @event.Events[TiledMapSpawnedEvent] = Events()

///|
pub let tiled_layer_spawned_event_bus : @event.Events[TiledLayerSpawnedEvent] = Events()

///|
pub let tiled_tile_spawned_event_bus : @event.Events[TiledTileSpawnedEvent] = Events()

///|
pub let tiled_object_spawned_event_bus : @event.Events[TiledObjectSpawnedEvent] = Events()

///|
pub let tiled_image_layer_spawned_event_bus : @event.Events[
  TiledImageLayerSpawnedEvent,
] = Events()
