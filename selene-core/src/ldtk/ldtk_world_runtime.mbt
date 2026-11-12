///|
pub fn unregister_ldtk_int_grid_value_spawn_hook(value : Int32) -> Unit {
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
  ldtk_int_grid_layer_spawn_hooks().clear()
}

///|
pub fn register_ldtk_int_grid_cell_spawn_hook(
  layer_identifier : String,
  value : Int32,
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
  value : Int32,
) -> Unit {
  ldtk_int_grid_cell_spawn_hooks().remove(
    ldtk_int_grid_cell_spawn_hook_key(layer_identifier, value),
  )
}

///|
pub fn clear_ldtk_int_grid_cell_spawn_hooks() -> Unit {
  ldtk_int_grid_cell_spawn_hooks().clear()
}

///|
pub fn clear_ldtk_int_grid_value_spawn_hooks() -> Unit {
  ldtk_int_grid_value_spawn_hooks().clear()
}

///|
pub fn load_and_spawn_ldtk_world(
  world~ : @ecs.World,
  path : String,
  settings~ : LdtkWorldSpawnSettings = LdtkWorldSpawnSettings(),
) -> @ecs.Entity {
  spawn_ldtk_world(world~, load_ldtk_project(path), settings~)
}

///|
pub fn spawn_ldtk_world(
  world~ : @ecs.World,
  project : LdtkProject,
  settings~ : LdtkWorldSpawnSettings = LdtkWorldSpawnSettings(),
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  spawn_ldtk_world_root(world~, project, settings, parent~)
}

///|
/// Replaces a previously imported world under the same parent.
pub fn replace_ldtk_world(
  world~ : @ecs.World,
  root : @ecs.Entity,
  project : LdtkProject,
  settings~ : LdtkWorldSpawnSettings = LdtkWorldSpawnSettings(),
) -> @ecs.Entity {
  let parent = root.get_parent()
  despawn_ldtk_tree(world~, root)
  spawn_ldtk_world_root(world~, project, settings, parent~)
}

///|
pub fn set_ldtk_level_set(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_set : LdtkLevelSet,
) -> Unit {
  guard (world.get_component(world_entity) : LdtkWorldInstance?)
    is Some(instance) else {
    return
  }
  instance.level_set = level_set
  instance.settings = { ..instance.settings, follow_level_selection: false, }
}

///|
pub fn set_ldtk_world_follow_level_selection(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  follow : Bool,
) -> Unit {
  guard (world.get_component(world_entity) : LdtkWorldInstance?)
    is Some(instance) else {
    return
  }
  instance.settings = { ..instance.settings, follow_level_selection: follow, }
}

///|
pub fn ldtk_level_entity(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_iid : String,
) -> @ecs.Entity? {
  guard (world.get_component(world_entity) : LdtkWorldInstance?)
    is Some(instance) else {
    return None
  }
  instance.spawned_levels.get(level_iid)
}

///|
pub fn ldtk_worldly_entity(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  entity_iid : String,
) -> @ecs.Entity? {
  let query_ldtk_worldly : @ecs.Query[@ecs.Single[LdtkWorldly]] = world.query()
  for (entity, Single(worldly)) in query_ldtk_worldly.to_array() {
    if !entity.is_alive() {
      continue
    }
    if worldly.world_entity == world_entity && worldly.entity_iid == entity_iid {
      return Some(entity)
    }
  }
  None
}

///|
pub fn ldtk_entity_by_iid(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  entity_iid : String,
) -> @ecs.Entity? {
  let query_ldtk_spawned_entity_instance : @ecs.Query[
    @ecs.Single[LdtkSpawnedEntityInstance],
  ] = world.query()
  let query_ldtk_entity_iid : @ecs.Query[@ecs.Single[LdtkEntityIid]] = world.query()
  for (entity, Single(iid_instance)) in query_ldtk_entity_iid.to_array() {
    if !entity.is_alive() {
      continue
    }
    if iid_instance.iid != entity_iid {
      continue
    }
    guard query_ldtk_spawned_entity_instance.get(entity).map(value => value.0)
      is Some(runtime) else {
      continue
    }
    if runtime.world_entity == world_entity {
      return Some(entity)
    }
  }
  None
}

///|
pub fn ldtk_world_sync_system(world~ : @ecs.World, _delta : Double) -> Unit {
  let query_ldtk_world_instance : @ecs.Query[@ecs.Single[LdtkWorldInstance]] = world.query()
  ldtk_emit_pending_transformed_events()
  ldtk_cleanup_dead_runtime_entries()
  let world_entities = query_ldtk_world_instance.to_array().map(pair => pair.0)
  for world_entity in world_entities {
    if !world_entity.is_alive() {
      continue
    }
    guard query_ldtk_world_instance.get(world_entity).map(value => value.0)
      is Some(instance) else {
      continue
    }
    ldtk_cleanup_dead_spawned_levels(instance)
    if ldtk_respawns().contains(world_entity) {
      ldtk_force_world_respawn(world~, world_entity)
      ldtk_respawns().remove(world_entity)
    } else {
      ldtk_force_level_respawns(world~, world_entity)
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
    ldtk_world_apply_level_set(world~, world_entity)
  }
}

///|
fn spawn_ldtk_world_root(
  world~ : @ecs.World,
  project : LdtkProject,
  settings : LdtkWorldSpawnSettings,
  parent~ : @ecs.Entity?,
) -> @ecs.Entity {
  let level_set = if settings.initial_level_set is Some(initial_level_set) {
    initial_level_set
  } else if settings.follow_level_selection {
    project.level_set_for_selection(
      ldtk_level_selection.val,
      ldtk_world_spawn_behavior(settings),
    )
  } else {
    LdtkLevelSet([])
  }
  let world_entity = world.spawn(
    (
      ldtk_spatial(settings.position, 0),
      LdtkWorldInstance::{ project, settings, level_set, spawned_levels: {}, },
    ),
    parent?,
  )
  let world_event = { world_entity, project, }
  ldtk_world_spawned_event_bus.trigger(world_event, Some(world_entity))
  if settings.world_hook is Some(world_hook) {
    world_hook(world_event)
  }
  ldtk_world_apply_level_set(world~, world_entity)
  world_entity
}

///|
fn ldtk_world_apply_level_set(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
) -> Unit {
  let query_ldtk_world_instance : @ecs.Query[@ecs.Single[LdtkWorldInstance]] = world.query()
  guard query_ldtk_world_instance.get(world_entity).map(value => value.0)
    is Some(instance) else {
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
    let level_entity = ldtk_spawn_level_entity(
      world~,
      world_entity,
      indexed,
      instance,
    )
    instance.spawned_levels.set(iid, level_entity)
  }

  for (iid, level_entity) in instance.spawned_levels.to_array() {
    if desired_iids.contains(iid) {
      continue
    }
    ldtk_despawn_level(world~, iid, level_entity)
    instance.spawned_levels.remove(iid)
  }
}

///|
fn ldtk_spawn_level_entity(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  indexed : LdtkIndexedLevel,
  instance : LdtkWorldInstance,
) -> @ecs.Entity {
  let level_offset = ldtk_level_offset(
    indexed.level,
    ldtk_world_spawn_behavior(instance.settings),
  )
  let level_entity = world.spawn(
    (
      ldtk_spatial(level_offset, 0),
      LdtkLevelInstance::{
        world_entity,
        indices: indexed.indices,
        level: indexed.level,
      },
      LdtkLevelIid::{ iid: indexed.level.iid, },
    ),
    parent=world_entity,
  )
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
    world~,
    world_entity,
    level_entity,
    indexed.level,
    instance,
  )
  ldtk_spawn_level_layers(
    world~,
    world_entity,
    level_entity,
    indexed.level,
    level_offset,
    instance,
  )
  ldtk_level_event_bus.trigger(Spawned(indexed.level.iid), Some(level_entity))
  ldtk_pending_transformed_level_iids().add(indexed.level.iid)
  level_entity
}

///|
fn ldtk_spawn_level_background(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_entity : @ecs.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
) -> Unit {
  let width = level.px_wid.to_double()
  let height = level.px_hei.to_double()
  if width <= 0.0 || height <= 0.0 {
    return
  }
  let size = @math.Vec2(width, height)
  let zindex = ldtk_level_zindex(world~, level_entity, instance.settings) - 1
  if level.bg_color is Some(bg_color) {
    ignore(
      world.spawn(
        (
          ldtk_spatial(@math.Vec2::zero(), zindex),
          @sprite.Sprite(
            color=@sprite.color_from_css(bg_color),
            custom_size=Some(size),
            anchor=Anchor(Vec2(-0.5, 0.5)),
          ),
          LdtkLevelBackground::{
            world_entity,
            level_entity,
            level_iid: level.iid,
            color: Some(bg_color),
            rel_path: None,
            zindex,
          },
        ),
        parent=level_entity,
      ),
    )
  }
  if level.bg_rel_path is Some(rel_path) && rel_path.length() > 0 {
    let image = @asset.load_image(instance.project.resolve_path(rel_path))
    let mut image_size = size
    let mut image_offset = @math.Vec2::zero()
    let mut image_transform = @math.Affine2::identity()
    if level.bg_pos is Some(bg_pos) {
      image_offset = bg_pos.top_left_px
      if bg_pos.crop_width > 0.0 && bg_pos.crop_height > 0.0 {
        image_size = Vec2(bg_pos.crop_width, bg_pos.crop_height)
      }
      image_transform = @math.Affine2::from_scale(
        Vec2(bg_pos.scale.x, bg_pos.scale.y),
      )
    }
    let scaled_size = @math.Vec2(
      image_size.x * image_transform.a.abs(),
      image_size.y * image_transform.d.abs(),
    )
    ignore(
      world.spawn(
        (
          ldtk_spatial(@math.Vec2::zero(), zindex),
          @sprite.Sprite(
            image=Some(image),
            rect=Some({ position: image_offset, size: image_size, }),
            color={ r: 255U, g: 255U, b: 255U, a: 1.0, },
            custom_size=Some(scaled_size),
            anchor=Anchor(Vec2(-0.5, 0.5)),
          ),
          LdtkLevelBackground::{
            world_entity,
            level_entity,
            level_iid: level.iid,
            color: level.bg_color,
            rel_path: Some(rel_path),
            zindex,
          },
        ),
        parent=level_entity,
      ),
    )
  }
}

///|
fn ldtk_spawn_level_layers(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_entity : @ecs.Entity,
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
    let layer_zindex = ldtk_level_zindex(
        world~,
        level_entity,
        instance.settings,
      ) +
      z_order * instance.settings.layer_z_step
    let layer_offset = @math.Vec2(
      layer.px_total_offset_x.to_double(),
      layer.px_total_offset_y.to_double(),
    )
    let layer_runtime : LdtkSpawnedLayerInstance = {
      world_entity,
      level_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    }
    let layer_entity = world.spawn(
      (
        ldtk_spatial(layer_offset, 0),
        if effective_visible {
          @visibility.Visibility::Visible
        } else {
          Hidden
        },
        layer_runtime,
        ldtk_build_layer_metadata(layer),
      ),
      parent=level_entity,
    )
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
        world~,
        world_entity,
        level_entity,
        layer_entity,
        level,
        instance,
        layer,
        tiles,
        layer_zindex,
      )
    } else if layer_type == "intgrid" {
      ldtk_spawn_int_grid_cells(
        world~,
        world_entity,
        level_entity,
        layer_entity,
        level,
        instance,
        layer,
        layer_zindex,
      )
      let layered_int_grid_tiles = ldtk_layered_int_grid_tiles(layer)
      for tile_layer_index, int_grid_tiles in layered_int_grid_tiles {
        if int_grid_tiles.length() == 0 {
          continue
        }
        ldtk_spawn_layer_tiles(
          world~,
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
        world~,
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
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_entity : @ecs.Entity,
  layer_entity : @ecs.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  tiles : Array[LdtkTileInstance],
  zindex : Int32,
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
    let runtime : LdtkSpawnedTileInstance = {
      world_entity,
      level_entity,
      layer_entity,
      layer,
      tile,
      zindex,
    }
    let metadata : LdtkTileMetadata = {
      tile_id: tile.tile_id,
      src: tile_src,
      flip_x: tile.flip_x,
      flip_y: tile.flip_y,
      alpha: tile.alpha,
      custom_data: tile_custom_data,
      enum_tags: tile_enum_tags,
    }
    let sprite = @sprite.Sprite(
      image=Some(image),
      rect=Some({ position: tile_src, size: Vec2(tile_size, tile_size), }),
      color={ r: 255U, g: 255U, b: 255U, a: render_alpha, },
      custom_size=Some(Vec2(tile_size, tile_size)),
      anchor=Anchor(Vec2(-0.5, 0.5)),
      flip_x=tile.flip_x,
      flip_y=tile.flip_y,
    )
    let tile_entity = world.spawn(
      (
        ldtk_spatial(tile.px, zindex),
        runtime,
        metadata,
        ldtk_grid_coords_from_px(tile.px, tile_size),
        sprite,
      ),
      parent=layer_entity,
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
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_entity : @ecs.Entity,
  layer_entity : @ecs.Entity,
  level : LdtkLevel,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  zindex : Int32,
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
    let draft = world.spawn_draft()
    draft.add(
      ldtk_spatial(
        Vec2(grid_x.to_double() * grid_size, grid_y.to_double() * grid_size),
        zindex,
      ),
    )
    draft.add(LdtkGridCoords::{ x: grid_x, y: grid_y, })
    draft.add(LdtkIntGridCell::{ value, })
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
    draft.add(runtime)
    ldtk_apply_registered_int_cell({
      draft,
      world_entity,
      level_entity,
      layer_entity,
      level,
      layer,
      value,
      grid_x,
      grid_y,
      zindex,
    })
    let collider = ldtk_add_int_grid_physics(
      draft,
      layer.identifier,
      value,
      grid_size,
    )
    if should_render_color && ldtk_settings.val.int_grid_rendering != Invisible {
      let color = instance.project
        .int_grid_color(layer.identifier, value)
        .unwrap_or("rgba(255,255,255,0.2)")
      let render_color = ldtk_color_with_alpha(color, layer.opacity)
      draft.add(
        @sprite.Sprite(
          color=@sprite.color_from_css(render_color),
          custom_size=Some(Vec2(grid_size, grid_size)),
          anchor=Anchor(Vec2(-0.5, 0.5)),
        ),
      )
    }
    let cell_entity = draft.spawn(parent=layer_entity)
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
    if collider is Some(collider) {
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
  }
}

///|
fn ldtk_spawn_layer_entities(
  world~ : @ecs.World,
  world_entity : @ecs.Entity,
  level_entity : @ecs.Entity,
  layer_entity : @ecs.Entity,
  level : LdtkLevel,
  level_offset : @math.Vec2,
  layer_offset : @math.Vec2,
  instance : LdtkWorldInstance,
  layer : LdtkLayerInstance,
  zindex : Int32,
) -> Unit {
  for entity_instance in layer.entity_instances {
    let base_offset = ldtk_entity_position(entity_instance)
    let is_worldly = ldtk_entity_is_worldly(entity_instance)
    if is_worldly &&
      ldtk_worldly_entity(world~, world_entity, entity_instance.iid) is Some(_) {
      continue
    }
    let parent_entity = if is_worldly { world_entity } else { layer_entity }
    let spawn_offset = if is_worldly {
      level_offset + layer_offset + base_offset
    } else {
      base_offset
    }
    let draft = world.spawn_draft()
    let spatial = ldtk_spatial(spawn_offset, zindex)
    draft.add(spatial)
    draft.add(LdtkGridCoords::{
      x: entity_instance.grid.x.to_int(),
      y: entity_instance.grid.y.to_int(),
    })
    draft.add(LdtkEntityIid::{ iid: entity_instance.iid, })
    if is_worldly {
      draft.add(LdtkWorldly::{
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
    draft.add(runtime)
    ldtk_apply_registered_entity({
      draft,
      spatial,
      world_entity,
      level_entity,
      layer_entity,
      level,
      layer,
      instance: entity_instance,
      zindex,
    })
    let entity = draft.spawn(parent=parent_entity)
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
