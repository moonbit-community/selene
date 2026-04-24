///|
pub fn unregister_ldtk_int_grid_value_spawn_hook(value : Int) -> Unit {
  ldtk_int_grid_value_spawn_hooks().remove(
    ldtk_int_grid_value_spawn_hook_key(value),
  )
}

///|
pub fn clear_ldtk_int_grid_default_spawn_hook() -> Unit {
  ldtk_int_grid_default_spawn_hook().val = None
}

///|
pub fn clear_ldtk_int_grid_layer_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_layer_spawn_hooks().to_array() {
    ldtk_int_grid_layer_spawn_hooks().remove(pair.0)
  }
}

///|
pub fn register_ldtk_int_grid_cell_spawn_hook(
  layer_identifier : String,
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_cell_spawn_hooks().set(
    ldtk_int_grid_cell_spawn_hook_key(layer_identifier, value),
    hook,
  )
}

///|
pub fn unregister_ldtk_int_grid_cell_spawn_hook(
  layer_identifier : String,
  value : Int,
) -> Unit {
  ldtk_int_grid_cell_spawn_hooks().remove(
    ldtk_int_grid_cell_spawn_hook_key(layer_identifier, value),
  )
}

///|
pub fn clear_ldtk_int_grid_cell_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_cell_spawn_hooks().to_array() {
    ldtk_int_grid_cell_spawn_hooks().remove(pair.0)
  }
}

///|
pub fn clear_ldtk_int_grid_value_spawn_hooks() -> Unit {
  for pair in ldtk_int_grid_value_spawn_hooks().to_array() {
    ldtk_int_grid_value_spawn_hooks().remove(pair.0)
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
  let world_entity = @entity.Entity()
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
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  instance.level_set = level_set
  instance.settings = { ..instance.settings, follow_level_selection: false }
}

///|
pub fn set_ldtk_world_follow_level_selection(
  world_entity : @entity.Entity,
  follow : Bool,
) -> Unit {
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  instance.settings = { ..instance.settings, follow_level_selection: follow }
}

///|
pub fn ldtk_level_entity(
  world_entity : @entity.Entity,
  level_iid : String,
) -> @entity.Entity? {
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return None
  }
  instance.spawned_levels.get(level_iid)
}

///|
pub fn ldtk_worldly_entity(
  world_entity : @entity.Entity,
  entity_iid : String,
) -> @entity.Entity? {
  for pair in ldtk_worldly_entities().to_array() {
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
  for pair in ldtk_entity_iids().to_array() {
    if !pair.0.is_alive() {
      continue
    }
    if pair.1.iid != entity_iid {
      continue
    }
    guard ldtk_spawned_entity_instances().get(pair.0) is Some(runtime) else {
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
  let world_entities = ldtk_world_instances().to_array().map(pair => pair.0)
  for world_entity in world_entities {
    if !world_entity.is_alive() {
      ldtk_world_instances().remove(world_entity)
      continue
    }
    guard ldtk_world_instances().get(world_entity) is Some(instance) else {
      continue
    }
    ldtk_cleanup_dead_spawned_levels(instance)
    if ldtk_respawns().contains(world_entity) {
      ldtk_force_world_respawn(world_entity)
      ldtk_respawns().remove(world_entity)
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
  set_entity_translation_2d(world_entity, settings.position)
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
  ldtk_world_instances().set(world_entity, {
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
  guard ldtk_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  let desired_iids = instance.level_set.iids
  for iid in desired_iids {
    if instance.spawned_levels.contains(iid) {
      continue
    }
    guard ldtk_project_indexed_level_by_iid(instance.project, iid)
      is Some(indexed) else {
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
  let level_entity = world_entity.spawn_child()
  set_entity_translation_2d(level_entity, level_offset)
  ldtk_level_instances().set(level_entity, {
    world_entity,
    indices: indexed.indices,
    level: indexed.level,
  })
  ldtk_level_iids().set(level_entity, { iid: indexed.level.iid })
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
  ldtk_spawn_level_background(
    world_entity,
    level_entity,
    indexed.level,
    instance,
  )
  ldtk_spawn_level_layers(
    world_entity,
    level_entity,
    indexed.level,
    level_offset,
    instance,
  )
  ldtk_level_event_bus.trigger(Spawned(indexed.level.iid), Some(level_entity))
  ldtk_pending_transformed_level_iids().set(indexed.level.iid, true)
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
  let size = @math.Vec2(width, height)
  let zindex = ldtk_level_zindex(level_entity, instance.settings) - 1
  if level.bg_color is Some(bg_color) {
    let background_entity = level_entity.spawn_child()
    set_entity_depth(background_entity, zindex)
    @sprite.sprites().set(
      background_entity,
      @sprite.Sprite(
        color=@sprite.color_from_css(bg_color),
        custom_size=Some(size),
        anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
      ),
    )
    ldtk_level_backgrounds().set(background_entity, {
      world_entity,
      level_entity,
      level_iid: level.iid,
      color: Some(bg_color),
      rel_path: None,
      zindex,
    })
  }
  if level.bg_rel_path is Some(rel_path) && rel_path.length() > 0 {
    let background_entity = level_entity.spawn_child()
    set_entity_depth(background_entity, zindex)
    let image = @asset.load_image(instance.project.resolve_path(rel_path))
    let mut image_size = size
    let mut image_offset = @math.Vec2::zero()
    let mut image_transform = @math.Transform::identity()
    if level.bg_pos is Some(bg_pos) {
      image_offset = bg_pos.top_left_px
      if bg_pos.crop_width > 0.0 && bg_pos.crop_height > 0.0 {
        image_size = @math.Vec2(bg_pos.crop_width, bg_pos.crop_height)
      }
      image_transform = @math.Transform::from_scale(
        bg_pos.scale[X],
        bg_pos.scale[Y],
      )
    }
    let scaled_size = @math.Vec2(
      image_size[X] * image_transform.a.abs(),
      image_size[Y] * image_transform.d.abs(),
    )
    @sprite.sprites().set(
      background_entity,
      @sprite.Sprite(
        image=Some(image),
        rect=Some({ position: image_offset, size: image_size }),
        color=@render.Color::{ r: 255U, g: 255U, b: 255U, a: 1.0 },
        custom_size=Some(scaled_size),
        anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
      ),
    )
    ldtk_level_backgrounds().set(background_entity, {
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
  level_offset : @math.Vec2,
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
    let layer_offset = @math.Vec2(
      layer.px_total_offset_x.to_double(),
      layer.px_total_offset_y.to_double(),
    )
    let layer_entity = level_entity.spawn_child()
    set_entity_translation_2d(layer_entity, layer_offset)
    set_entity_depth(layer_entity, 0)
    set_entity_visibility(layer_entity, effective_visible)
    let layer_runtime : LdtkSpawnedLayerInstance = {
      world_entity,
      level_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    }
    ldtk_spawned_layer_instances().set(layer_entity, layer_runtime)
    ldtk_layer_metadata().set(layer_entity, ldtk_build_layer_metadata(layer))
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
        world_entity, level_entity, layer_entity, level, instance, layer, tiles,
        layer_zindex,
      )
    } else if layer_type == "intgrid" {
      ldtk_spawn_int_grid_cells(
        world_entity, level_entity, layer_entity, level, instance, layer, layer_zindex,
      )
      let layered_int_grid_tiles = ldtk_layered_int_grid_tiles(layer)
      for tile_layer_index, int_grid_tiles in layered_int_grid_tiles {
        if int_grid_tiles.length() == 0 {
          continue
        }
        ldtk_spawn_layer_tiles(
          world_entity,
          level_entity,
          layer_entity,
          level,
          instance,
          layer,
          int_grid_tiles,
          layer_zindex + tile_layer_index,
        )
      }
    } else if layer_type == "entities" {
      ldtk_spawn_layer_entities(
        world_entity, level_entity, layer_entity, level, level_offset, layer_offset,
        instance, layer, layer_zindex,
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
    let tile_custom_data = ldtk_tile_custom_data(instance.project, layer, tile)
    let tile_enum_tags = ldtk_tile_enum_tags(instance.project, layer, tile)
    let tile_entity = layer_entity.spawn_child()
    set_entity_translation_2d(tile_entity, tile.px)
    set_entity_depth(tile_entity, zindex)
    let runtime : LdtkSpawnedTileInstance = {
      world_entity,
      level_entity,
      layer_entity,
      layer,
      tile,
      zindex,
    }
    ldtk_spawned_tile_instances().set(tile_entity, runtime)
    ldtk_tile_metadata().set(tile_entity, {
      tile_id: tile.tile_id,
      src: tile_src,
      flip_x: tile.flip_x,
      flip_y: tile.flip_y,
      alpha: tile.alpha,
      custom_data: tile_custom_data,
      enum_tags: tile_enum_tags,
    })
    ldtk_grid_coords().set(
      tile_entity,
      ldtk_grid_coords_from_px(tile.px, tile_size),
    )
    @sprite.sprites().set(
      tile_entity,
      @sprite.Sprite(
        image=Some(image),
        rect=Some({ position: tile_src, size: @math.Vec2(tile_size, tile_size) }),
        color=@render.Color::{ r: 255U, g: 255U, b: 255U, a: render_alpha },
        custom_size=Some(@math.Vec2(tile_size, tile_size)),
        anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
        flip_x=tile.flip_x,
        flip_y=tile.flip_y,
      ),
    )
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
) -> Unit {
  let width = layer.c_wid
  let grid_size = ldtk_layer_grid_size(instance.project, layer)
  let should_render_color = ldtk_layer_tileset_uid(layer) is None
  if width <= 0 || grid_size <= 0.0 {
    return
  }
  for index, value in layer.int_grid_csv {
    if value <= 0 {
      continue
    }
    let grid_x = index % width
    let grid_y = index / width
    let cell_entity = layer_entity.spawn_child()
    set_entity_translation_2d(
      cell_entity,
      @math.Vec2(grid_x.to_double() * grid_size, grid_y.to_double() * grid_size),
    )
    set_entity_depth(cell_entity, zindex)
    ldtk_grid_coords().set(cell_entity, { x: grid_x, y: grid_y })
    ldtk_int_grid_cells().set(cell_entity, { value, })
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
    ldtk_spawned_int_grid_cells().set(cell_entity, runtime)
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
    ldtk_apply_registered_int_cell(int_grid_event)
    ldtk_int_grid_cell_spawned_event_bus.trigger(
      int_grid_event,
      Some(cell_entity),
    )
    if instance.settings.int_grid_cell_hook is Some(int_grid_cell_hook) {
      int_grid_cell_hook(int_grid_event)
    }
    if ldtk_int_grid_layer_spawn_hooks().get(layer.identifier) is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_cell_spawn_hooks().get(
        ldtk_int_grid_cell_spawn_hook_key(layer.identifier, value),
      )
      is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_value_spawn_hooks().get(
        ldtk_int_grid_value_spawn_hook_key(value),
      )
      is Some(hook) {
      hook(int_grid_event)
    }
    if ldtk_int_grid_default_spawn_hook().val is Some(default_hook) {
      default_hook(int_grid_event)
    }
    if ldtk_apply_int_grid_physics(
        cell_entity,
        layer.identifier,
        value,
        grid_size,
      )
      is Some(collider) {
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
    if !should_render_color ||
      ldtk_settings.val.int_grid_rendering == Invisible ||
      !@visibility.is_visible(cell_entity) {
      continue
    }
    let color = instance.project
      .int_grid_color(layer.identifier, value)
      .unwrap_or("rgba(255,255,255,0.2)")
    let render_color = ldtk_color_with_alpha(color, layer.opacity)
    @sprite.sprites().set(
      cell_entity,
      @sprite.Sprite(
        color=@sprite.color_from_css(render_color),
        custom_size=Some(@math.Vec2(grid_size, grid_size)),
        anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
      ),
    )
  }
}

///|
fn ldtk_spawn_layer_entities(
  world_entity : @entity.Entity,
  level_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  level : LdtkLevel,
  level_offset : @math.Vec2,
  layer_offset : @math.Vec2,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  zindex : Int,
) -> Unit {
  for entity_instance in layer.entity_instances {
    let base_offset = ldtk_entity_position(entity_instance)
    let is_worldly = ldtk_entity_is_worldly(entity_instance)
    if is_worldly &&
      ldtk_worldly_entity(world_entity, entity_instance.iid) is Some(_) {
      continue
    }
    let parent_entity = if is_worldly { world_entity } else { layer_entity }
    let spawn_offset = if is_worldly {
      level_offset + layer_offset + base_offset
    } else {
      base_offset
    }
    let entity = parent_entity.spawn_child()
    set_entity_translation_2d(entity, spawn_offset)
    set_entity_depth(entity, zindex)
    ldtk_grid_coords().set(entity, {
      x: entity_instance.grid[X].to_int(),
      y: entity_instance.grid[Y].to_int(),
    })
    ldtk_entity_iids().set(entity, { iid: entity_instance.iid })
    if is_worldly {
      ldtk_worldly_entities().set(entity, {
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
    ldtk_spawned_entity_instances().set(entity, runtime)
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
    ldtk_apply_registered_entity(entity_event)
    ldtk_entity_spawned_event_bus.trigger(entity_event, Some(entity))
    if instance.settings.entity_hook is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_layer_identifier_spawn_hooks().get(
        ldtk_entity_layer_identifier_spawn_hook_key(
          layer.identifier,
          entity_instance.identifier,
        ),
      )
      is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_layer_spawn_hooks().get(layer.identifier)
      is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_spawn_hooks().get(entity_instance.identifier)
      is Some(entity_hook) {
      entity_hook(entity_event)
    }
    if ldtk_entity_default_spawn_hook().val is Some(default_hook) {
      default_hook(entity_event)
    }
  }
}
