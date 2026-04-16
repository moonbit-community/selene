///|
pub fn ldtk_pending_transformed_level_iids() -> Map[String, Bool] {
  ldtk_world_store().ldtk_pending_transformed_level_iids
}

///|
pub fn default_ldtk_world_spawn_settings() -> LdtkWorldSpawnSettings {
  {
    position: @math.Vec2::zero(),
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
  ldtk_respawns().set(entity, { requested: true })
}

///|
pub fn clear_ldtk_respawn(entity : @entity.Entity) -> Unit {
  ldtk_respawns().remove(entity)
}

///|
pub fn register_ldtk_entity_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_typed_registrations().set(
    ldtk_entity_typed_registration_key(layer_identifier, entity_identifier),
    hook,
  )
}

///|
pub fn register_ldtk_entity_for_layer(
  layer_identifier : String,
  entity_identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_entity_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
    hook,
  )
}

///|
pub fn register_ldtk_entity(
  entity_identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_entity_for_layer_optional(None, Some(entity_identifier), hook)
}

///|
pub fn register_default_ldtk_entity_for_layer(
  layer_identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_entity_for_layer_optional(Some(layer_identifier), None, hook)
}

///|
pub fn register_default_ldtk_entity(
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_entity_for_layer_optional(None, None, hook)
}

///|
pub fn unregister_ldtk_entity_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
) -> Unit {
  ldtk_entity_typed_registrations().remove(
    ldtk_entity_typed_registration_key(layer_identifier, entity_identifier),
  )
}

///|
pub fn unregister_ldtk_entity_for_layer(
  layer_identifier : String,
  entity_identifier : String,
) -> Unit {
  unregister_ldtk_entity_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
  )
}

///|
pub fn unregister_ldtk_entity(entity_identifier : String) -> Unit {
  unregister_ldtk_entity_for_layer_optional(None, Some(entity_identifier))
}

///|
pub fn unregister_default_ldtk_entity_for_layer(
  layer_identifier : String,
) -> Unit {
  unregister_ldtk_entity_for_layer_optional(Some(layer_identifier), None)
}

///|
pub fn unregister_default_ldtk_entity() -> Unit {
  unregister_ldtk_entity_for_layer_optional(None, None)
}

///|
pub fn clear_ldtk_entity_registrations() -> Unit {
  for pair in ldtk_entity_typed_registrations().to_array() {
    ldtk_entity_typed_registrations().remove(pair.0)
  }
}

///|
pub fn register_ldtk_int_cell_for_layer_optional(
  layer_identifier : String?,
  value : Int?,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_cell_typed_registrations().set(
    ldtk_int_cell_typed_registration_key(layer_identifier, value),
    hook,
  )
}

///|
pub fn register_ldtk_int_cell_for_layer(
  layer_identifier : String,
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_int_cell_for_layer_optional(
    Some(layer_identifier),
    Some(value),
    hook,
  )
}

///|
pub fn register_ldtk_int_cell(
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_int_cell_for_layer_optional(None, Some(value), hook)
}

///|
pub fn register_default_ldtk_int_cell_for_layer(
  layer_identifier : String,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_int_cell_for_layer_optional(Some(layer_identifier), None, hook)
}

///|
pub fn register_default_ldtk_int_cell(
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  register_ldtk_int_cell_for_layer_optional(None, None, hook)
}

///|
pub fn unregister_ldtk_int_cell_for_layer_optional(
  layer_identifier : String?,
  value : Int?,
) -> Unit {
  ldtk_int_cell_typed_registrations().remove(
    ldtk_int_cell_typed_registration_key(layer_identifier, value),
  )
}

///|
pub fn unregister_ldtk_int_cell_for_layer(
  layer_identifier : String,
  value : Int,
) -> Unit {
  unregister_ldtk_int_cell_for_layer_optional(
    Some(layer_identifier),
    Some(value),
  )
}

///|
pub fn unregister_ldtk_int_cell(value : Int) -> Unit {
  unregister_ldtk_int_cell_for_layer_optional(None, Some(value))
}

///|
pub fn unregister_default_ldtk_int_cell_for_layer(
  layer_identifier : String,
) -> Unit {
  unregister_ldtk_int_cell_for_layer_optional(Some(layer_identifier), None)
}

///|
pub fn unregister_default_ldtk_int_cell() -> Unit {
  unregister_ldtk_int_cell_for_layer_optional(None, None)
}
