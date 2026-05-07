///|
fn set_entity_translation_2d(
  entity : @entity.Entity,
  position : @math.Vec2,
) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3(position[X], position[Y], current.translation.z),
  })
}

///|
fn set_entity_depth(entity : @entity.Entity, z : Int) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3(
      current.translation.x,
      current.translation.y,
      z.to_double(),
    ),
  })
}

///|
fn set_entity_visibility(entity : @entity.Entity, visible : Bool) -> Unit {
  @visibility.visibilities().set(entity, if visible { Visible } else { Hidden })
}

///|
fn ldtk_sprite_anchor_for_pixel_offset(
  offset : @math.Vec2,
  size : @math.Vec2,
) -> @sprite.Anchor {
  if size[X].abs() <= 0.000000001 || size[Y].abs() <= 0.000000001 {
    return @sprite.Anchor(@math.Vec2(-0.5, 0.5))
  }
  @sprite.Anchor(
    @math.Vec2(-(offset[X] / size[X]) - 0.5, offset[Y] / size[Y] + 0.5),
  )
}

///|
pub struct LdtkWorldSpawnSettings {
  position : @math.Vec2
  zindex : Int
  level_z_step : Int
  layer_z_step : Int
  spawn_hidden_layers : Bool
  follow_level_selection : Bool
  initial_level_set : LdtkLevelSet?
  spawn_behavior_override : LdtkLevelSpawnBehavior?
  world_hook : ((LdtkWorldSpawnedEvent) -> Unit)?
  level_hook : ((LdtkLevelSpawnedEvent) -> Unit)?
  layer_hook : ((LdtkLayerSpawnedEvent) -> Unit)?
  tile_hook : ((LdtkTileSpawnedEvent) -> Unit)?
  entity_hook : ((LdtkEntitySpawnedEvent) -> Unit)?
  int_grid_cell_hook : ((LdtkIntGridCellSpawnedEvent) -> Unit)?
}

///|
pub struct LdtkWorldInstance {
  project : LdtkProject
  mut settings : LdtkWorldSpawnSettings
  mut level_set : LdtkLevelSet
  spawned_levels : Map[String, @entity.Entity]
}

///|
pub struct LdtkLevelInstance {
  world_entity : @entity.Entity
  indices : LdtkLevelIndices
  level : LdtkLevel
}

///|
pub struct LdtkLayerMetadata {
  c_hei : Int
  c_wid : Int
  grid_size : Int
  identifier : String
  opacity : Double
  px_total_offset_x : Int
  px_total_offset_y : Int
  tileset_def_uid : Int?
  tileset_rel_path : String?
  layer_type : String
  iid : String
  layer_def_uid : Int
  level_id : Int
  optional_rules : Array[Int]
  override_tileset_uid : Int?
  px_offset_x : Int
  px_offset_y : Int
  seed : Int
  visible : Bool
}

///|
pub struct LdtkLevelBackground {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  level_iid : String
  color : String?
  rel_path : String?
  zindex : Int
}

///|
pub struct LdtkLevelIid {
  iid : String
}

///|
pub struct LdtkEntityIid {
  iid : String
}

///|
pub struct LdtkGridCoords {
  x : Int
  y : Int
}

///|
pub struct LdtkIntGridCell {
  value : Int
}

///|
pub struct LdtkTileMetadata {
  tile_id : Int
  src : @math.Vec2
  flip_x : Bool
  flip_y : Bool
  alpha : Double
  custom_data : String?
  enum_tags : Array[String]
}

///|
pub struct LdtkIntGridCollider {
  sensor : Bool
}

///|
pub struct LdtkWorldly {
  world_entity : @entity.Entity
  level_iid : String
  entity_iid : String
}

///|
pub struct LdtkRespawn {
  requested : Bool
}

///|
pub struct LdtkSpawnedLayerInstance {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer : LdtkLayerInstance
  effective_visible : Bool
  zindex : Int
}

///|
pub struct LdtkSpawnedTileInstance {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : LdtkLayerInstance
  tile : LdtkTileInstance
  zindex : Int
}

///|
pub struct LdtkSpawnedEntityInstance {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : LdtkLayerInstance
  instance : LdtkEntityInstance
  zindex : Int
}

///|
pub struct LdtkSpawnedIntGridCell {
  world_entity : @entity.Entity
  level_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : LdtkLayerInstance
  value : Int
  grid_x : Int
  grid_y : Int
  zindex : Int
}

///|
priv struct LdtkWorldStore {
  ldtk_world_instances : Map[@entity.Entity, LdtkWorldInstance]
  ldtk_level_instances : Map[@entity.Entity, LdtkLevelInstance]
  ldtk_layer_metadata : Map[@entity.Entity, LdtkLayerMetadata]
  ldtk_level_backgrounds : Map[@entity.Entity, LdtkLevelBackground]
  ldtk_level_iids : Map[@entity.Entity, LdtkLevelIid]
  ldtk_entity_iids : Map[@entity.Entity, LdtkEntityIid]
  ldtk_grid_coords : Map[@entity.Entity, LdtkGridCoords]
  ldtk_int_grid_cells : Map[@entity.Entity, LdtkIntGridCell]
  ldtk_tile_metadata : Map[@entity.Entity, LdtkTileMetadata]
  ldtk_int_grid_colliders : Map[@entity.Entity, LdtkIntGridCollider]
  ldtk_worldly_entities : Map[@entity.Entity, LdtkWorldly]
  ldtk_respawns : Map[@entity.Entity, LdtkRespawn]
  ldtk_spawned_layer_instances : Map[@entity.Entity, LdtkSpawnedLayerInstance]
  ldtk_spawned_tile_instances : Map[@entity.Entity, LdtkSpawnedTileInstance]
  ldtk_spawned_entity_instances : Map[@entity.Entity, LdtkSpawnedEntityInstance]
  ldtk_spawned_int_grid_cells : Map[@entity.Entity, LdtkSpawnedIntGridCell]
  ldtk_entity_spawn_hooks : Map[String, (LdtkEntitySpawnedEvent) -> Unit]
  ldtk_entity_layer_spawn_hooks : Map[String, (LdtkEntitySpawnedEvent) -> Unit]
  ldtk_entity_layer_identifier_spawn_hooks : Map[
    String,
    (LdtkEntitySpawnedEvent) -> Unit,
  ]
  ldtk_entity_default_spawn_hook : Ref[((LdtkEntitySpawnedEvent) -> Unit)?]
  ldtk_int_grid_layer_spawn_hooks : Map[
    String,
    (LdtkIntGridCellSpawnedEvent) -> Unit,
  ]
  ldtk_int_grid_cell_spawn_hooks : Map[
    String,
    (LdtkIntGridCellSpawnedEvent) -> Unit,
  ]
  ldtk_int_grid_value_spawn_hooks : Map[
    String,
    (LdtkIntGridCellSpawnedEvent) -> Unit,
  ]
  ldtk_int_grid_default_spawn_hook : Ref[
    ((LdtkIntGridCellSpawnedEvent) -> Unit)?,
  ]
  ldtk_entity_typed_registrations : Map[
    String,
    (LdtkEntitySpawnedEvent) -> Unit,
  ]
  ldtk_int_cell_typed_registrations : Map[
    String,
    (LdtkIntGridCellSpawnedEvent) -> Unit,
  ]
  ldtk_pending_transformed_level_iids : Map[String, Bool]
}

///|
let ldtk_world_stores : Map[UInt, LdtkWorldStore] = Map::of([])

///|
fn ldtk_world_store() -> LdtkWorldStore {
  let world_id = @ecs.require_current_world().id()
  ldtk_world_stores.get_or_init(world_id, () => {
    ldtk_world_instances: Map::of([]),
    ldtk_level_instances: Map::of([]),
    ldtk_layer_metadata: Map::of([]),
    ldtk_level_backgrounds: Map::of([]),
    ldtk_level_iids: Map::of([]),
    ldtk_entity_iids: Map::of([]),
    ldtk_grid_coords: Map::of([]),
    ldtk_int_grid_cells: Map::of([]),
    ldtk_tile_metadata: Map::of([]),
    ldtk_int_grid_colliders: Map::of([]),
    ldtk_worldly_entities: Map::of([]),
    ldtk_respawns: Map::of([]),
    ldtk_spawned_layer_instances: Map::of([]),
    ldtk_spawned_tile_instances: Map::of([]),
    ldtk_spawned_entity_instances: Map::of([]),
    ldtk_spawned_int_grid_cells: Map::of([]),
    ldtk_entity_spawn_hooks: Map::of([]),
    ldtk_entity_layer_spawn_hooks: Map::of([]),
    ldtk_entity_layer_identifier_spawn_hooks: Map::of([]),
    ldtk_entity_default_spawn_hook: { val: None },
    ldtk_int_grid_layer_spawn_hooks: Map::of([]),
    ldtk_int_grid_cell_spawn_hooks: Map::of([]),
    ldtk_int_grid_value_spawn_hooks: Map::of([]),
    ldtk_int_grid_default_spawn_hook: { val: None },
    ldtk_entity_typed_registrations: Map::of([]),
    ldtk_int_cell_typed_registrations: Map::of([]),
    ldtk_pending_transformed_level_iids: Map::of([]),
  })
}

///|
pub fn ldtk_world_instances() -> Map[@entity.Entity, LdtkWorldInstance] {
  ldtk_world_store().ldtk_world_instances
}
