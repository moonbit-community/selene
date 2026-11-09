///|
fn set_entity_translation_2d(
  entity : @ecs.Entity,
  position : @math.Vec2,
) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: Vec3(position[X], position[Y], current.translation.z),
  })
}

///|
fn set_entity_depth(entity : @ecs.Entity, z : Int32) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: Vec3(
      current.translation.x,
      current.translation.y,
      z.to_double(),
    ),
  })
}

///|
fn set_entity_visibility(entity : @ecs.Entity, visible : Bool) -> Unit {
  @visibility.visibilities().set(entity, if visible { Visible } else { Hidden })
}

///|
fn ldtk_sprite_anchor_for_pixel_offset(
  offset : @math.Vec2,
  size : @math.Vec2,
) -> @sprite.Anchor {
  if size[X].abs() <= 0.000000001 || size[Y].abs() <= 0.000000001 {
    return Anchor(Vec2(-0.5, 0.5))
  }
  Anchor(Vec2(-(offset[X] / size[X]) - 0.5, offset[Y] / size[Y] + 0.5))
}

///|
pub struct LdtkWorldSpawnSettings {
  position : @math.Vec2
  zindex : Int32
  level_z_step : Int32
  layer_z_step : Int32
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
#selene.component
pub struct LdtkWorldInstance {
  project : LdtkProject
  mut settings : LdtkWorldSpawnSettings
  mut level_set : LdtkLevelSet
  spawned_levels : Map[String, @ecs.Entity]
}

///|
#selene.component
pub struct LdtkLevelInstance {
  world_entity : @ecs.Entity
  indices : LdtkLevelIndices
  level : LdtkLevel
}

///|
#selene.component
pub struct LdtkLayerMetadata {
  c_hei : Int32
  c_wid : Int32
  grid_size : Int32
  identifier : String
  opacity : Double
  px_total_offset_x : Int32
  px_total_offset_y : Int32
  tileset_def_uid : Int32?
  tileset_rel_path : String?
  layer_type : String
  iid : String
  layer_def_uid : Int32
  level_id : Int32
  optional_rules : Array[Int32]
  override_tileset_uid : Int32?
  px_offset_x : Int32
  px_offset_y : Int32
  seed : Int32
  visible : Bool
}

///|
#selene.component
pub struct LdtkLevelBackground {
  world_entity : @ecs.Entity
  level_entity : @ecs.Entity
  level_iid : String
  color : String?
  rel_path : String?
  zindex : Int32
}

///|
#selene.component
pub struct LdtkLevelIid {
  iid : String
}

///|
#selene.component
pub struct LdtkEntityIid {
  iid : String
}

///|
#selene.component
pub struct LdtkGridCoords {
  x : Int32
  y : Int32
}

///|
#selene.component
pub struct LdtkIntGridCell {
  value : Int32
}

///|
#selene.component
pub struct LdtkTileMetadata {
  tile_id : Int32
  src : @math.Vec2
  flip_x : Bool
  flip_y : Bool
  alpha : Double
  custom_data : String?
  enum_tags : Array[String]
}

///|
#selene.component
pub struct LdtkIntGridCollider {
  sensor : Bool
}

///|
#selene.component
pub struct LdtkWorldly {
  world_entity : @ecs.Entity
  level_iid : String
  entity_iid : String
}

///|
#selene.component
pub struct LdtkRespawn {
  requested : Bool
}

///|
#selene.component
pub struct LdtkSpawnedLayerInstance {
  world_entity : @ecs.Entity
  level_entity : @ecs.Entity
  layer : LdtkLayerInstance
  effective_visible : Bool
  zindex : Int32
}

///|
#selene.component
pub struct LdtkSpawnedTileInstance {
  world_entity : @ecs.Entity
  level_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  layer : LdtkLayerInstance
  tile : LdtkTileInstance
  zindex : Int32
}

///|
#selene.component
pub struct LdtkSpawnedEntityInstance {
  world_entity : @ecs.Entity
  level_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  layer : LdtkLayerInstance
  instance : LdtkEntityInstance
  zindex : Int32
}

///|
#selene.component
pub struct LdtkSpawnedIntGridCell {
  world_entity : @ecs.Entity
  level_entity : @ecs.Entity
  layer_entity : @ecs.Entity
  layer : LdtkLayerInstance
  value : Int32
  grid_x : Int32
  grid_y : Int32
  zindex : Int32
}

///|
priv struct LdtkWorldStore {
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
let ldtk_world_store_key : @ecs.ResourceKey[LdtkWorldStore] = ResourceKey()

///|
fn new_ldtk_world_store(_ : @ecs.World) -> LdtkWorldStore {
  {
    ldtk_entity_spawn_hooks: Map([]),
    ldtk_entity_layer_spawn_hooks: Map([]),
    ldtk_entity_layer_identifier_spawn_hooks: Map([]),
    ldtk_entity_default_spawn_hook: { val: None, },
    ldtk_int_grid_layer_spawn_hooks: Map([]),
    ldtk_int_grid_cell_spawn_hooks: Map([]),
    ldtk_int_grid_value_spawn_hooks: Map([]),
    ldtk_int_grid_default_spawn_hook: { val: None, },
    ldtk_entity_typed_registrations: Map([]),
    ldtk_int_cell_typed_registrations: Map([]),
    ldtk_pending_transformed_level_iids: Map([]),
  }
}

///|
fn ldtk_world_store() -> LdtkWorldStore {
  ldtk_world_store_key.get_or_insert_with(
    @ecs.require_current_world(),
    new_ldtk_world_store,
  )
}

///|
pub fn ldtk_world_instances() -> @ecs.ComponentStore[LdtkWorldInstance] {
  @ecs.components()
}
