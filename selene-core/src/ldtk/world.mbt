///|
pub struct LdtkWorldSpawnSettings {
  position : @math.Vec2D
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
  src : @math.Vec2D
  flip_x : Bool
  flip_y : Bool
  alpha : Double
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
pub let ldtk_world_instances : Map[@entity.Entity, LdtkWorldInstance] = Map::new()

///|
pub let ldtk_level_instances : Map[@entity.Entity, LdtkLevelInstance] = Map::new()

///|
pub let ldtk_layer_metadata : Map[@entity.Entity, LdtkLayerMetadata] = Map::new()

///|
pub let ldtk_level_backgrounds : Map[@entity.Entity, LdtkLevelBackground] = Map::new()

///|
pub let ldtk_level_iids : Map[@entity.Entity, LdtkLevelIid] = Map::new()

///|
pub let ldtk_entity_iids : Map[@entity.Entity, LdtkEntityIid] = Map::new()

///|
pub let ldtk_grid_coords : Map[@entity.Entity, LdtkGridCoords] = Map::new()

///|
pub let ldtk_int_grid_cells : Map[@entity.Entity, LdtkIntGridCell] = Map::new()

///|
pub let ldtk_tile_metadata : Map[@entity.Entity, LdtkTileMetadata] = Map::new()

///|
pub let ldtk_int_grid_colliders : Map[@entity.Entity, LdtkIntGridCollider] = Map::new()

///|
pub let ldtk_worldly_entities : Map[@entity.Entity, LdtkWorldly] = Map::new()

///|
pub let ldtk_respawns : Map[@entity.Entity, LdtkRespawn] = Map::new()

///|
pub let ldtk_spawned_layer_instances : Map[
  @entity.Entity,
  LdtkSpawnedLayerInstance,
] = Map::new()

///|
pub let ldtk_spawned_tile_instances : Map[
  @entity.Entity,
  LdtkSpawnedTileInstance,
] = Map::new()

///|
pub let ldtk_spawned_entity_instances : Map[
  @entity.Entity,
  LdtkSpawnedEntityInstance,
] = Map::new()

///|
pub let ldtk_spawned_int_grid_cells : Map[
  @entity.Entity,
  LdtkSpawnedIntGridCell,
] = Map::new()

///|
pub let ldtk_entity_spawn_hooks : Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_entity_layer_spawn_hooks : Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_entity_layer_identifier_spawn_hooks : Map[
  String,
  (LdtkEntitySpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_entity_default_spawn_hook : Ref[((LdtkEntitySpawnedEvent) -> Unit)?] = {
  val: None,
}

///|
pub let ldtk_int_grid_layer_spawn_hooks : Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_int_grid_cell_spawn_hooks : Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_int_grid_value_spawn_hooks : Map[
  String,
  (LdtkIntGridCellSpawnedEvent) -> Unit,
] = Map::new()

///|
pub let ldtk_int_grid_default_spawn_hook : Ref[((LdtkIntGridCellSpawnedEvent) -> Unit)?] = {
  val: None,
}

///|
pub let ldtk_pending_transformed_level_iids : Map[String, Bool] = Map::new()

///|
pub fn default_ldtk_world_spawn_settings() -> LdtkWorldSpawnSettings {
  {
    position: @math.Vec2D::zero(),
    zindex: 0,
    level_z_step: 1000,
    layer_z_step: 10,
    spawn_hidden_layers: true,
    follow_level_selection: true,
    initial_level_set: None,
    spawn_behavior_override: None,
    world_hook: None,
    level_hook: None,
    layer_hook: None,
    tile_hook: None,
    entity_hook: None,
    int_grid_cell_hook: None,
  }
}

///|
pub fn mark_ldtk_respawn(entity : @entity.Entity) -> Unit {
  ldtk_respawns.set(entity, { requested: true })
}

///|
pub fn clear_ldtk_respawn(entity : @entity.Entity) -> Unit {
  ldtk_respawns.remove(entity)
}

///|
pub fn register_ldtk_entity_spawn_hook(
  identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_spawn_hooks.set(identifier, hook)
}

///|
pub fn register_ldtk_entity_layer_spawn_hook(
  layer_identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_layer_spawn_hooks.set(layer_identifier, hook)
}

///|
pub fn register_ldtk_entity_spawn_hook_for_layer(
  layer_identifier : String,
  identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_layer_identifier_spawn_hooks.set(
    ldtk_entity_layer_identifier_spawn_hook_key(layer_identifier, identifier),
    hook,
  )
}

///|
pub fn register_ldtk_entity_default_spawn_hook(
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_default_spawn_hook.val = Some(hook)
}

///|
pub fn unregister_ldtk_entity_spawn_hook(identifier : String) -> Unit {
  ldtk_entity_spawn_hooks.remove(identifier)
}

///|
pub fn unregister_ldtk_entity_layer_spawn_hook(layer_identifier : String) -> Unit {
  ldtk_entity_layer_spawn_hooks.remove(layer_identifier)
}

///|
pub fn unregister_ldtk_entity_spawn_hook_for_layer(
  layer_identifier : String,
  identifier : String,
) -> Unit {
  ldtk_entity_layer_identifier_spawn_hooks.remove(
    ldtk_entity_layer_identifier_spawn_hook_key(layer_identifier, identifier),
  )
}

///|
pub fn clear_ldtk_entity_default_spawn_hook() -> Unit {
  ldtk_entity_default_spawn_hook.val = None
}

///|
pub fn clear_ldtk_entity_spawn_hooks() -> Unit {
  for pair in ldtk_entity_spawn_hooks.to_array() {
    ldtk_entity_spawn_hooks.remove(pair.0)
  }
  for pair in ldtk_entity_layer_spawn_hooks.to_array() {
    ldtk_entity_layer_spawn_hooks.remove(pair.0)
  }
  for pair in ldtk_entity_layer_identifier_spawn_hooks.to_array() {
    ldtk_entity_layer_identifier_spawn_hooks.remove(pair.0)
  }
  ldtk_entity_default_spawn_hook.val = None
}

///|
pub fn register_ldtk_int_grid_layer_spawn_hook(
  layer_identifier : String,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_layer_spawn_hooks.set(layer_identifier, hook)
}

///|
pub fn register_ldtk_int_grid_value_spawn_hook(
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_value_spawn_hooks.set(
    ldtk_int_grid_value_spawn_hook_key(value),
    hook,
  )
}

///|
pub fn register_ldtk_int_grid_default_spawn_hook(
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_default_spawn_hook.val = Some(hook)
}

///|
pub fn unregister_ldtk_int_grid_layer_spawn_hook(
  layer_identifier : String,
) -> Unit {
  ldtk_int_grid_layer_spawn_hooks.remove(layer_identifier)
}

///|
pub fn unregister_ldtk_int_grid_value_spawn_hook(value : Int) -> Unit {
  ldtk_int_grid_value_spawn_hooks.remove(ldtk_int_grid_value_spawn_hook_key(value))
}

///|
pub fn clear_ldtk_int_grid_default_spawn_hook() -> Unit {
  ldtk_int_grid_default_spawn_hook.val = None
}

///|
pub fn clear_ldtk_int_grid_layer_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_layer_spawn_hooks.to_array() {
    ldtk_int_grid_layer_spawn_hooks.remove(pair.0)
  }
}

///|
pub fn register_ldtk_int_grid_cell_spawn_hook(
  layer_identifier : String,
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_cell_spawn_hooks.set(
    ldtk_int_grid_cell_spawn_hook_key(layer_identifier, value),
    hook,
  )
}

///|
pub fn unregister_ldtk_int_grid_cell_spawn_hook(
  layer_identifier : String,
  value : Int,
) -> Unit {
  ldtk_int_grid_cell_spawn_hooks.remove(
    ldtk_int_grid_cell_spawn_hook_key(layer_identifier, value),
  )
}

///|
pub fn clear_ldtk_int_grid_cell_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_cell_spawn_hooks.to_array() {
    ldtk_int_grid_cell_spawn_hooks.remove(pair.0)
  }
}

///|
pub fn clear_ldtk_int_grid_value_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_value_spawn_hooks.to_array() {
    ldtk_int_grid_value_spawn_hooks.remove(pair.0)
  }
}

///|
pub fn load_and_spawn_ldtk_world(
  path : String,
  settings? : LdtkWorldSpawnSettings = default_ldtk_world_spawn_settings(),
) -> @entity.Entity {
  spawn_ldtk_world(load_ldtk_project(path), settings~)
}

///|
pub fn spawn_ldtk_world(
  project : LdtkProject,
  settings? : LdtkWorldSpawnSettings = default_ldtk_world_spawn_settings(),
) -> @entity.Entity {
  let world_entity = @entity.Entity::new()
  spawn_ldtk_world_root(world_entity, project, settings)
  world_entity
}

///|
pub fn spawn_ldtk_world_into_entity(
  root : @entity.Entity,
  project : LdtkProject,
  settings? : LdtkWorldSpawnSettings = default_ldtk_world_spawn_settings(),
) -> Unit {
  spawn_ldtk_world_root(root, project, settings)
}

///|
pub fn respawn_ldtk_world_into_entity(
  root : @entity.Entity,
  project : LdtkProject,
  settings? : LdtkWorldSpawnSettings = default_ldtk_world_spawn_settings(),
) -> Unit {
  clear_ldtk_children(root)
  @entity.entity_flush_system(0.0)
  clear_ldtk_root_components(root)
  spawn_ldtk_world_root(root, project, settings)
}

///|
pub fn set_ldtk_level_set(
  world_entity : @entity.Entity,
  level_set : LdtkLevelSet,
) -> Unit {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else { return }
  instance.level_set = level_set
  instance.settings = { ..instance.settings, follow_level_selection: false }
}

///|
pub fn set_ldtk_world_follow_level_selection(
  world_entity : @entity.Entity,
  follow : Bool,
) -> Unit {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else { return }
  instance.settings = { ..instance.settings, follow_level_selection: follow }
}

///|
pub fn ldtk_level_entity(
  world_entity : @entity.Entity,
  level_iid : String,
) -> @entity.Entity? {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else {
    return None
  }
  instance.spawned_levels.get(level_iid)
}

///|
pub fn ldtk_worldly_entity(
  world_entity : @entity.Entity,
  entity_iid : String,
) -> @entity.Entity? {
  for pair in ldtk_worldly_entities.to_array() {
    if !pair.0.is_alive() {
      continue
    }
    let worldly = pair.1
    if worldly.world_entity == world_entity && worldly.entity_iid == entity_iid {
      return Some(pair.0)
    }
  }
  None
}

///|
pub fn ldtk_entity_by_iid(
  world_entity : @entity.Entity,
  entity_iid : String,
) -> @entity.Entity? {
  for pair in ldtk_entity_iids.to_array() {
    if !pair.0.is_alive() {
      continue
    }
    if pair.1.iid != entity_iid {
      continue
    }
    guard ldtk_spawned_entity_instances.get(pair.0) is Some(runtime) else {
      continue
    }
    if runtime.world_entity == world_entity {
      return Some(pair.0)
    }
  }
  None
}

///|
pub fn ldtk_world_sync_system(_delta : Double) -> Unit {
  ldtk_emit_pending_transformed_events()
  ldtk_cleanup_dead_runtime_entries()
  let world_entities = ldtk_world_instances.to_array().map(pair => pair.0)
  for world_entity in world_entities {
    if !world_entity.is_alive() {
      ldtk_world_instances.remove(world_entity)
      continue
    }
    guard ldtk_world_instances.get(world_entity) is Some(instance) else {
      continue
    }
    ldtk_cleanup_dead_spawned_levels(instance)
    if ldtk_respawns.contains(world_entity) {
      ldtk_force_world_respawn(world_entity)
      ldtk_respawns.remove(world_entity)
    } else {
      ldtk_force_level_respawns(world_entity)
    }
    if instance.settings.follow_level_selection {
      let behavior = ldtk_world_spawn_behavior(instance.settings)
      let computed = instance.project.level_set_for_selection(
        ldtk_level_selection.val,
        behavior,
      )
      if !ldtk_level_set_equals(instance.level_set, computed) {
        instance.level_set = computed
      }
    }
    ldtk_world_apply_level_set(world_entity)
  }
}

///|
fn spawn_ldtk_world_root(
  world_entity : @entity.Entity,
  project : LdtkProject,
  settings : LdtkWorldSpawnSettings,
) -> Unit {
  @transform.positions.set(world_entity, settings.position)
  let level_set = if settings.initial_level_set is Some(initial_level_set) {
    initial_level_set
  } else if settings.follow_level_selection {
    project.level_set_for_selection(
      ldtk_level_selection.val,
      ldtk_world_spawn_behavior(settings),
    )
  } else {
    empty_ldtk_level_set()
  }
  ldtk_world_instances.set(world_entity, {
    project,
    settings,
    level_set,
    spawned_levels: Map::new(),
  })
  let world_event = { world_entity, project }
  ldtk_world_spawned_event_bus.trigger(world_event, Some(world_entity))
  if settings.world_hook is Some(world_hook) {
    world_hook(world_event)
  }
  ldtk_world_apply_level_set(world_entity)
}

///|
fn ldtk_world_apply_level_set(world_entity : @entity.Entity) -> Unit {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else {
    return
  }
  let desired_iids = instance.level_set.iids
  for iid in desired_iids {
    if instance.spawned_levels.contains(iid) {
      continue
    }
    guard ldtk_project_indexed_level_by_iid(instance.project, iid) is Some(indexed) else {
      continue
    }
    ldtk_level_event_bus.trigger(SpawnTriggered(iid), Some(world_entity))
    let level_entity = ldtk_spawn_level_entity(world_entity, indexed, instance)
    instance.spawned_levels.set(iid, level_entity)
  }

  for pair in instance.spawned_levels.to_array() {
    let iid = pair.0
    if desired_iids.contains(iid) {
      continue
    }
    let level_entity = pair.1
    ldtk_despawn_level(world_entity, iid, level_entity)
    instance.spawned_levels.remove(iid)
  }
}

///|
fn ldtk_spawn_level_entity(
  world_entity : @entity.Entity,
  indexed : LdtkIndexedLevel,
  instance : LdtkWorldInstance,
) -> @entity.Entity {
  let level_offset = ldtk_level_offset(
    indexed.level,
    ldtk_world_spawn_behavior(instance.settings),
  )
  let level_entity = world_entity.spawn_child(offset=level_offset)
  @transform.positions.set(level_entity, @math.Vec2D::zero())
  ldtk_level_instances.set(level_entity, {
    world_entity,
    indices: indexed.indices,
    level: indexed.level,
  })
  ldtk_level_iids.set(level_entity, { iid: indexed.level.iid })
  let level_event = {
    world_entity,
    level_entity,
    indices: indexed.indices,
    level: indexed.level,
  }
  ldtk_level_spawned_event_bus.trigger(level_event, Some(level_entity))
  if instance.settings.level_hook is Some(level_hook) {
    level_hook(level_event)
  }
  ldtk_spawn_level_background(world_entity, level_entity, indexed.level, instance)
  ldtk_spawn_level_layers(
    world_entity,
    level_entity,
    indexed.level,
    level_offset,
    instance,
  )
  ldtk_level_event_bus.trigger(Spawned(indexed.level.iid), Some(level_entity))
  ldtk_pending_transformed_level_iids.set(indexed.level.iid, true)
  level_entity
}

///|
fn ldtk_spawn_level_background(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
) -> Unit {
  let width = level.px_wid.to_double()
  let height = level.px_hei.to_double()
  if width <= 0.0 || height <= 0.0 {
    return
  }
  let size = @math.Vec2D(width, height)
  let zindex = ldtk_level_zindex(level_entity, instance.settings) - 1
  if level.bg_color is Some(bg_color) {
    let background_entity = level_entity.spawn_child(offset=@math.Vec2D::zero())
    @transform.positions.set(background_entity, @math.Vec2D::zero())
    let rect = @sprite.ColorRect::new(size, bg_color)
    let sprite = @sprite.Sprite::from_color_rect(rect, zindex)
    sprite.visible = true
    @sprite.sprites.set(background_entity, sprite)
    ldtk_level_backgrounds.set(background_entity, {
      world_entity,
      level_entity,
      level_iid: level.iid,
      color: Some(bg_color),
      rel_path: None,
      zindex,
    })
  }
  if level.bg_rel_path is Some(rel_path) && rel_path.length() > 0 {
    let background_entity = level_entity.spawn_child(offset=@math.Vec2D::zero())
    @transform.positions.set(background_entity, @math.Vec2D::zero())
    let image = @asset2.load_image(instance.project.resolve_path(rel_path))
    let mut image_size = size
    let mut image_offset = @math.Vec2D::zero()
    let mut image_transform = @math.Transform::identity()
    if level.bg_pos is Some(bg_pos) {
      image_offset = bg_pos.top_left_px
      if bg_pos.crop_width > 0.0 && bg_pos.crop_height > 0.0 {
        image_size = @math.Vec2D(bg_pos.crop_width, bg_pos.crop_height)
      }
      image_transform = @math.Transform::from_scale(
        bg_pos.scale[X],
        bg_pos.scale[Y],
      )
    }
    let animation = @sprite.Animation::single_frame_from_image(
      image,
      image_size,
      transform=image_transform,
      offset=image_offset,
    )
    let sprite = @sprite.Sprite::from_animation(animation, zindex)
    sprite.visible = true
    @sprite.sprites.set(background_entity, sprite)
    ldtk_level_backgrounds.set(background_entity, {
      world_entity,
      level_entity,
      level_iid: level.iid,
      color: level.bg_color,
      rel_path: Some(rel_path),
      zindex,
    })
  }
}

///|
fn ldtk_spawn_level_layers(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  level : LdtkLevel,
  level_offset : @math.Vec2D,
  instance : LdtkWorldInstance,
) -> Unit {
  let spawnable_layers : Array[LdtkLayerInstance] = []
  for layer in level.layer_instances {
    let layer_identifier = layer.identifier
    if ldtk_settings.val.spawn_exclusions.excludes_layer(layer_identifier) {
      continue
    }
    let effective_visible = layer.visible
    if !instance.settings.spawn_hidden_layers && !effective_visible {
      continue
    }
    spawnable_layers.push(layer)
  }
  let spawn_count = spawnable_layers.length()
  for layer_index, layer in spawnable_layers {
    let effective_visible = layer.visible
    let z_order = spawn_count - 1 - layer_index
    let layer_zindex = ldtk_level_zindex(level_entity, instance.settings) +
      z_order * instance.settings.layer_z_step
    let layer_offset = @math.Vec2D(
      layer.px_total_offset_x.to_double(),
      layer.px_total_offset_y.to_double(),
    )
    let layer_entity = level_entity.spawn_child(offset=layer_offset)
    @transform.positions.set(layer_entity, @math.Vec2D::zero())
    let layer_runtime : LdtkSpawnedLayerInstance = {
      world_entity,
      level_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    }
    ldtk_spawned_layer_instances.set(layer_entity, layer_runtime)
    ldtk_layer_metadata.set(layer_entity, ldtk_build_layer_metadata(layer))
    let layer_event : LdtkLayerSpawnedEvent = {
      world_entity: layer_runtime.world_entity,
      level_entity,
      layer_entity,
      level,
      layer,
      effective_visible,
      zindex: layer_zindex,
    }
    ldtk_layer_spawned_event_bus.trigger(layer_event, Some(layer_entity))
    if instance.settings.layer_hook is Some(layer_hook) {
      layer_hook(layer_event)
    }
    let layer_type = layer.layer_type.to_lower()
    if layer_type == "tiles" || layer_type == "autolayer" {
      let tiles = if layer_type == "tiles" {
        layer.grid_tiles
      } else {
        layer.auto_layer_tiles
      }
      ldtk_spawn_layer_tiles(
        world_entity,
        level_entity,
        layer_entity,
        level,
        instance,
        layer,
        tiles,
        layer_zindex,
        effective_visible,
      )
    } else if layer_type == "intgrid" {
      ldtk_spawn_int_grid_cells(
        world_entity,
        level_entity,
        layer_entity,
        level,
        instance,
        layer,
        layer_zindex,
        effective_visible,
      )
    } else if layer_type == "entities" {
      ldtk_spawn_layer_entities(
        world_entity,
        level_entity,
        layer_entity,
        level,
        level_offset,
        layer_offset,
        instance,
        layer,
        layer_zindex,
      )
    }
  }
}

///|
fn ldtk_spawn_layer_tiles(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  tiles : Array[LdtkTileInstance],
  zindex : Int,
  visible : Bool,
) -> Unit {
  guard ldtk_layer_tileset_image(instance.project, layer) is Some(image) else {
    return
  }
  let tile_size = ldtk_layer_grid_size(instance.project, layer)
  if tile_size <= 0.0 {
    return
  }
  for tile in tiles {
    let render_alpha = ldtk_clamp_alpha(layer.opacity * tile.alpha)
    let tile_src = ldtk_tile_source(instance.project, layer, tile)
    let tile_entity = layer_entity.spawn_child(offset=tile.px)
    @transform.positions.set(tile_entity, @math.Vec2D::zero())
    let runtime : LdtkSpawnedTileInstance = {
      world_entity,
      level_entity,
      layer_entity,
      layer,
      tile,
      zindex,
    }
    ldtk_spawned_tile_instances.set(tile_entity, runtime)
    ldtk_tile_metadata.set(tile_entity, {
      tile_id: tile.tile_id,
      src: tile_src,
      flip_x: tile.flip_x,
      flip_y: tile.flip_y,
      alpha: tile.alpha,
    })
    ldtk_grid_coords.set(
      tile_entity,
      ldtk_grid_coords_from_px(tile.px, tile_size),
    )
    let frame : @sprite.AnimationFrame = {
      image,
      offset: tile_src,
      size: @math.Vec2D(tile_size, tile_size),
    }
    let animation = @sprite.Animation::new(
      [frame],
      loop_=false,
      fps=0.0,
      transform=ldtk_tile_transform(tile, tile_size),
      color={ r: 255U, g: 255U, b: 255U, a: render_alpha },
    )
    let sprite = @sprite.Sprite::from_animation(animation, zindex)
    sprite.visible = visible
    @sprite.sprites.set(tile_entity, sprite)
    let tile_event : LdtkTileSpawnedEvent = {
      world_entity: runtime.world_entity,
      level_entity: runtime.level_entity,
      layer_entity,
      tile_entity,
      level,
      layer,
      tile,
      zindex,
    }
    ldtk_tile_spawned_event_bus.trigger(tile_event, Some(tile_entity))
    if instance.settings.tile_hook is Some(tile_hook) {
      tile_hook(tile_event)
    }
  }
}

///|
fn ldtk_spawn_int_grid_cells(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  zindex : Int,
  visible : Bool,
) -> Unit {
  let width = layer.c_wid
  let grid_size = ldtk_layer_grid_size(instance.project, layer)
  if width <= 0 || grid_size <= 0.0 {
    return
  }
  for index, value in layer.int_grid_csv {
    if value <= 0 {
      continue
    }
    let grid_x = index % width
    let grid_y = index / width
    let cell_entity = layer_entity.spawn_child(
      offset=@math.Vec2D(
        grid_x.to_double() * grid_size,
        grid_y.to_double() * grid_size,
      ),
    )
    @transform.positions.set(cell_entity, @math.Vec2D::zero())
    ldtk_grid_coords.set(cell_entity, { x: grid_x, y: grid_y })
    ldtk_int_grid_cells.set(cell_entity, { value, })
    let runtime : LdtkSpawnedIntGridCell = {
      world_entity,
      level_entity,
      layer_entity,
      layer,
      value,
      grid_x,
      grid_y,
      zindex,
    }
    ldtk_spawned_int_grid_cells.set(cell_entity, runtime)
    let int_grid_event : LdtkIntGridCellSpawnedEvent = {
      world_entity: runtime.world_entity,
      level_entity: runtime.level_entity,
      layer_entity,
      cell_entity,
      level,
      layer,
      value,
      grid_x,
      grid_y,
      zindex,
    }
    ldtk_int_grid_cell_spawned_event_bus.trigger(int_grid_event, Some(cell_entity))
    if instance.settings.int_grid_cell_hook is Some(int_grid_cell_hook) {
      int_grid_cell_hook(int_grid_event)
    }
    if ldtk_int_grid_layer_spawn_hooks.get(layer.identifier) is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_cell_spawn_hooks.get(
      ldtk_int_grid_cell_spawn_hook_key(layer.identifier, value),
    ) is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_value_spawn_hooks.get(
      ldtk_int_grid_value_spawn_hook_key(value),
    ) is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_default_spawn_hook.val is Some(default_hook) {
      default_hook(int_grid_event)
    }
    if ldtk_apply_int_grid_physics(
      cell_entity,
      layer.identifier,
      value,
      grid_size,
    ) is Some(collider) {
      ldtk_int_grid_collider_spawned_event_bus.trigger(
        {
          world_entity: runtime.world_entity,
          level_entity: runtime.level_entity,
          layer_entity: runtime.layer_entity,
          cell_entity,
          collider_entity: cell_entity,
          level,
          layer,
          value,
          grid_x,
          grid_y,
          zindex,
          sensor: collider.sensor,
        },
        Some(cell_entity),
      )
    }
    if ldtk_settings.val.int_grid_rendering == Invisible || !visible {
      continue
    }
    let color = instance.project.int_grid_color(layer.identifier, value).unwrap_or(
      "rgba(255,255,255,0.2)",
    )
    let render_color = ldtk_color_with_alpha(color, layer.opacity)
    let rect = @sprite.ColorRect::new(@math.Vec2D(grid_size, grid_size), render_color)
    let sprite = @sprite.Sprite::from_color_rect(rect, zindex)
    sprite.visible = visible
    @sprite.sprites.set(cell_entity, sprite)
  }
}

///|
fn ldtk_spawn_layer_entities(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  level : LdtkLevel,
  level_offset : @math.Vec2D,
  layer_offset : @math.Vec2D,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  zindex : Int,
) -> Unit {
  for entity_instance in layer.entity_instances {
    let base_offset = ldtk_entity_position(entity_instance)
    let is_worldly = ldtk_entity_is_worldly(entity_instance)
    if is_worldly && ldtk_worldly_entity(world_entity, entity_instance.iid) is Some(_) {
      continue
    }
    let parent_entity = if is_worldly { world_entity } else { layer_entity }
    let spawn_offset = if is_worldly {
      level_offset + layer_offset + base_offset
    } else {
      base_offset
    }
    let entity = parent_entity.spawn_child(offset=spawn_offset)
    @transform.positions.set(entity, @math.Vec2D::zero())
    ldtk_grid_coords.set(entity, {
      x: entity_instance.grid[X].to_int(),
      y: entity_instance.grid[Y].to_int(),
    })
    ldtk_entity_iids.set(entity, { iid: entity_instance.iid })
    if is_worldly {
      ldtk_worldly_entities.set(entity, {
        world_entity,
        level_iid: level.iid,
        entity_iid: entity_instance.iid,
      })
    }
    let runtime : LdtkSpawnedEntityInstance = {
      world_entity,
      level_entity,
      layer_entity,
      layer,
      instance: entity_instance,
      zindex,
    }
    ldtk_spawned_entity_instances.set(entity, runtime)
    let entity_event : LdtkEntitySpawnedEvent = {
      world_entity: runtime.world_entity,
      level_entity: runtime.level_entity,
      layer_entity,
      entity,
      level,
      layer,
      instance: entity_instance,
      zindex,
    }
    ldtk_entity_spawned_event_bus.trigger(entity_event, Some(entity))
    if instance.settings.entity_hook is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_layer_identifier_spawn_hooks.get(
      ldtk_entity_layer_identifier_spawn_hook_key(layer.identifier, entity_instance.identifier),
    ) is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_layer_spawn_hooks.get(layer.identifier) is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_spawn_hooks.get(entity_instance.identifier) is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_default_spawn_hook.val is Some(default_hook) {
      default_hook(entity_event)
    }
  }
}

///|
fn ldtk_despawn_level(
  world_entity : @entity.Entity,
  level_iid : String,
  level_entity : @entity.Entity,
) -> Unit {
  ldtk_pending_transformed_level_iids.remove(level_iid)
  ldtk_level_event_bus.trigger(Despawned(level_iid), Some(level_entity))
  despawn_ldtk_tree(level_entity)
  ldtk_respawns.remove(level_entity)
  for pair in ldtk_worldly_entities.to_array() {
    if pair.1.world_entity != world_entity {
      continue
    }
    if pair.1.level_iid != level_iid {
      continue
    }
    if !pair.0.is_alive() {
      ldtk_worldly_entities.remove(pair.0)
      continue
    }
    // Keep worldly entities alive across level despawn, matching bevy_ldtk behavior.
  }
}

///|
fn ldtk_force_world_respawn(world_entity : @entity.Entity) -> Unit {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else {
    return
  }
  for pair in instance.spawned_levels.to_array() {
    ldtk_despawn_level(world_entity, pair.0, pair.1)
    instance.spawned_levels.remove(pair.0)
  }
  for pair in ldtk_worldly_entities.to_array() {
    if pair.1.world_entity != world_entity {
      continue
    }
    if pair.0.is_alive() {
      despawn_ldtk_tree(pair.0)
    }
    ldtk_worldly_entities.remove(pair.0)
  }
}

///|
fn ldtk_force_level_respawns(world_entity : @entity.Entity) -> Unit {
  guard ldtk_world_instances.get(world_entity) is Some(instance) else {
    return
  }
  for pair in instance.spawned_levels.to_array() {
    let level_iid = pair.0
    let level_entity = pair.1
    if !ldtk_respawns.contains(level_entity) {
      continue
    }
    ldtk_despawn_level(world_entity, level_iid, level_entity)
    instance.spawned_levels.remove(level_iid)
    ldtk_respawns.remove(level_entity)
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
fn ldtk_entity_position(entity_instance : LdtkEntityInstance) -> @math.Vec2D {
  let width = entity_instance.width.to_double()
  let height = entity_instance.height.to_double()
  let anchor_offset = @math.Vec2D(
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
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else {
    return 16.0
  }
  guard project.tileset_by_uid(uid) is Some(tileset) else {
    return 16.0
  }
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
    return Some(@asset2.load_image(project.resolve_path(path)))
  }
  guard ldtk_layer_tileset_uid(layer) is Some(uid) else { return None }
  guard project.tileset_by_uid(uid) is Some(tileset) else { return None }
  guard tileset.rel_path is Some(path) else { return None }
  Some(@asset2.load_image(project.resolve_path(path)))
}

///|
fn ldtk_tile_source(
  project : LdtkProject,
  layer : LdtkLayerInstance,
  tile : LdtkTileInstance,
) -> @math.Vec2D {
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
  @math.Vec2D(
    (tileset.padding + tile_x * stride).to_double(),
    (tileset.padding + tile_y * stride).to_double(),
  )
}

///|
fn ldtk_grid_coords_from_px(px : @math.Vec2D, cell_size : Double) -> LdtkGridCoords {
  if cell_size <= 0.0 {
    return { x: 0, y: 0 }
  }
  {
    x: (px[X] / cell_size).to_int(),
    y: (px[Y] / cell_size).to_int(),
  }
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
  let size = @math.Vec2D(grid_size, grid_size)
  let shape = @physics2d.CollisionShape::Rect(
    size=size,
    offset=@math.Vec2D::zero(),
  )
  if physics_settings.as_sensor {
    @physics2d.areas.set(
      cell_entity,
      @physics2d.new_sensor(physics_settings.sensor_filter),
    )
  } else {
    @physics2d.colliders.set(
      cell_entity,
      @physics2d.Collider::new(physics_settings.collision_filter),
    )
  }
  @physics2d.shapes.set(cell_entity, shape)
  let collider = { sensor: physics_settings.as_sensor }
  ldtk_int_grid_colliders.set(cell_entity, collider)
  Some(collider)
}

///|
fn ldtk_tile_transform(
  tile : LdtkTileInstance,
  tile_size : Double,
) -> @math.Transform {
  let size = if tile_size > 0.0 { tile_size } else { 1.0 }
  let flip_x = if tile.flip_x {
    @math.Transform::flip_x(size)
  } else {
    @math.Transform::identity()
  }
  let flip_y = if tile.flip_y {
    @math.Transform::flip_y(size)
  } else {
    @math.Transform::identity()
  }
  flip_y * flip_x
}

///|
fn ldtk_level_offset(
  level : LdtkLevel,
  behavior : LdtkLevelSpawnBehavior,
) -> @math.Vec2D {
  match behavior {
    UseZeroTranslation => @math.Vec2D::zero()
    UseWorldTranslation(_) =>
      @math.Vec2D(level.world_x.to_double(), level.world_y.to_double())
  }
}

///|
fn ldtk_level_zindex(
  level_entity : @entity.Entity,
  settings : LdtkWorldSpawnSettings,
) -> Int {
  guard ldtk_level_instances.get(level_entity) is Some(level_instance) else {
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
  settings.spawn_behavior_override.unwrap_or(ldtk_settings.val.level_spawn_behavior)
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

///|
fn ldtk_emit_pending_transformed_events() -> Unit {
  for pair in ldtk_pending_transformed_level_iids.to_array() {
    let iid = pair.0
    ldtk_level_event_bus.trigger(Transformed(iid), None)
    ldtk_pending_transformed_level_iids.remove(iid)
  }
}

///|
fn ldtk_cleanup_dead_spawned_levels(instance : LdtkWorldInstance) -> Unit {
  for pair in instance.spawned_levels.to_array() {
    if !pair.1.is_alive() {
      instance.spawned_levels.remove(pair.0)
      ldtk_pending_transformed_level_iids.remove(pair.0)
    }
  }
}

///|
fn ldtk_cleanup_dead_runtime_entries() -> Unit {
  for pair in ldtk_respawns.to_array() {
    if !pair.0.is_alive() {
      ldtk_respawns.remove(pair.0)
    }
  }
  for pair in ldtk_worldly_entities.to_array() {
    if !pair.0.is_alive() {
      ldtk_worldly_entities.remove(pair.0)
    }
  }
  for pair in ldtk_layer_metadata.to_array() {
    if !pair.0.is_alive() {
      ldtk_layer_metadata.remove(pair.0)
    }
  }
  for pair in ldtk_level_backgrounds.to_array() {
    if !pair.0.is_alive() {
      ldtk_level_backgrounds.remove(pair.0)
    }
  }
  for pair in ldtk_level_iids.to_array() {
    if !pair.0.is_alive() {
      ldtk_level_iids.remove(pair.0)
    }
  }
  for pair in ldtk_entity_iids.to_array() {
    if !pair.0.is_alive() {
      ldtk_entity_iids.remove(pair.0)
    }
  }
  for pair in ldtk_grid_coords.to_array() {
    if !pair.0.is_alive() {
      ldtk_grid_coords.remove(pair.0)
    }
  }
  for pair in ldtk_int_grid_cells.to_array() {
    if !pair.0.is_alive() {
      ldtk_int_grid_cells.remove(pair.0)
    }
  }
  for pair in ldtk_tile_metadata.to_array() {
    if !pair.0.is_alive() {
      ldtk_tile_metadata.remove(pair.0)
    }
  }
  for pair in ldtk_int_grid_colliders.to_array() {
    if !pair.0.is_alive() {
      @physics2d.areas.remove(pair.0)
      @physics2d.colliders.remove(pair.0)
      @physics2d.shapes.remove(pair.0)
      @physics2d.rigid_bodies.remove(pair.0)
      ldtk_int_grid_colliders.remove(pair.0)
    }
  }
  for pair in ldtk_spawned_layer_instances.to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_layer_instances.remove(pair.0)
    }
  }
  for pair in ldtk_spawned_tile_instances.to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_tile_instances.remove(pair.0)
    }
  }
  for pair in ldtk_spawned_entity_instances.to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_entity_instances.remove(pair.0)
    }
  }
  for pair in ldtk_spawned_int_grid_cells.to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_int_grid_cells.remove(pair.0)
    }
  }
}

///|
fn ldtk_int_grid_cell_spawn_hook_key(
  layer_identifier : String,
  value : Int,
) -> String {
  "\{layer_identifier}#\{value}"
}

///|
fn ldtk_int_grid_value_spawn_hook_key(value : Int) -> String {
  value.to_string()
}

///|
fn ldtk_entity_layer_identifier_spawn_hook_key(
  layer_identifier : String,
  identifier : String,
) -> String {
  "\{layer_identifier}#\{identifier}"
}

///|
fn ldtk_clamp_alpha(alpha : Double) -> Double {
  if alpha < 0.0 {
    0.0
  } else if alpha > 1.0 {
    1.0
  } else {
    alpha
  }
}

///|
fn ldtk_color_with_alpha(color : String, alpha : Double) -> String {
  let clamped_alpha = ldtk_clamp_alpha(alpha)
  if clamped_alpha >= 0.999999 {
    return color
  }
  let normalized = color.trim().to_string()
  if normalized.has_prefix("#") {
    return ldtk_hex_color_with_alpha(normalized, clamped_alpha).unwrap_or(color)
  }
  if normalized.has_prefix("rgba(") && normalized.has_suffix(")") {
    return ldtk_rgba_color_with_alpha(normalized, clamped_alpha).unwrap_or(color)
  }
  if normalized.has_prefix("rgb(") && normalized.has_suffix(")") {
    return ldtk_rgb_color_with_alpha(normalized, clamped_alpha).unwrap_or(color)
  }
  color
}

///|
fn ldtk_hex_color_with_alpha(color : String, alpha : Double) -> String? {
  let hex = color.unsafe_substring(start=1, end=color.length())
  if hex.length() != 6 && hex.length() != 8 {
    return None
  }
  guard ldtk_hex_pair_to_int(hex, 0) is Some(red) else { return None }
  guard ldtk_hex_pair_to_int(hex, 2) is Some(green) else { return None }
  guard ldtk_hex_pair_to_int(hex, 4) is Some(blue) else { return None }
  let base_alpha = if hex.length() == 8 {
    ldtk_hex_pair_to_int(hex, 6).map(value => value.to_double() / 255.0).unwrap_or(1.0)
  } else {
    1.0
  }
  let final_alpha = ldtk_clamp_alpha(alpha * base_alpha)
  Some("rgba(\{red},\{green},\{blue},\{final_alpha})")
}

///|
fn ldtk_rgb_color_with_alpha(color : String, alpha : Double) -> String? {
  let body = color.unsafe_substring(start=4, end=color.length() - 1)
  let values = body.split(",").to_array()
  if values.length() != 3 {
    return None
  }
  guard ldtk_parse_color_channel(values[0]) is Some(red) else { return None }
  guard ldtk_parse_color_channel(values[1]) is Some(green) else { return None }
  guard ldtk_parse_color_channel(values[2]) is Some(blue) else { return None }
  Some("rgba(\{red},\{green},\{blue},\{ldtk_clamp_alpha(alpha)})")
}

///|
fn ldtk_rgba_color_with_alpha(color : String, alpha : Double) -> String? {
  let body = color.unsafe_substring(start=5, end=color.length() - 1)
  let values = body.split(",").to_array()
  if values.length() != 4 {
    return None
  }
  guard ldtk_parse_color_channel(values[0]) is Some(red) else { return None }
  guard ldtk_parse_color_channel(values[1]) is Some(green) else { return None }
  guard ldtk_parse_color_channel(values[2]) is Some(blue) else { return None }
  guard ldtk_parse_alpha_channel(values[3]) is Some(base_alpha) else { return None }
  Some("rgba(\{red},\{green},\{blue},\{ldtk_clamp_alpha(alpha * base_alpha)})")
}

///|
fn ldtk_parse_color_channel(source : StringView) -> Int? {
  let trimmed = source.trim()
  let parsed : Result[Int, Error] = try? @strconv.parse_int(trimmed, base=10)
  match parsed {
    Ok(value) =>
      Some(if value < 0 {
        0
      } else if value > 255 {
        255
      } else {
        value
      })
    Err(_) => None
  }
}

///|
fn ldtk_parse_alpha_channel(source : StringView) -> Double? {
  let trimmed = source.trim()
  let parsed : Result[Double, Error] = try? @strconv.parse_double(trimmed)
  match parsed {
    Ok(value) => Some(ldtk_clamp_alpha(value))
    Err(_) => None
  }
}

///|
fn ldtk_hex_pair_to_int(hex : String, index : Int) -> Int? {
  if index < 0 || index + 2 > hex.length() {
    return None
  }
  let pair = hex.unsafe_substring(start=index, end=index + 2)
  let parsed : Result[Int, Error] = try? @strconv.parse_int(pair, base=16)
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}
