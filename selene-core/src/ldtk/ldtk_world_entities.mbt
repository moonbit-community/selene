///|
pub fn add_ldtk_int_cell_registration(
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  add_ldtk_int_cell_registration_for_layer_optional(None, Some(value), hook)
}

///|
pub fn add_default_ldtk_int_cell_registration_for_layer(
  layer_identifier : String,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  add_ldtk_int_cell_registration_for_layer_optional(
    Some(layer_identifier),
    None,
    hook,
  )
}

///|
pub fn add_default_ldtk_int_cell_registration(
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  add_ldtk_int_cell_registration_for_layer_optional(None, None, hook)
}

///|
pub fn[T] add_ldtk_int_cell_component_for_layer_optional(
  layer_identifier : String?,
  value : Int?,
  storage : Map[@entity.Entity, T],
  make : (LdtkIntGridCellSpawnedEvent) -> T,
) -> Unit {
  add_ldtk_int_cell_registration_for_layer_optional(layer_identifier, value, fn(
    event,
  ) {
    storage.set(event.cell_entity, make(event))
  })
}

///|
pub fn[T] add_ldtk_int_cell_component_for_layer(
  layer_identifier : String,
  value : Int,
  storage : Map[@entity.Entity, T],
  make : (LdtkIntGridCellSpawnedEvent) -> T,
) -> Unit {
  add_ldtk_int_cell_component_for_layer_optional(
    Some(layer_identifier),
    Some(value),
    storage,
    make,
  )
}

///|
pub fn[T] add_ldtk_int_cell_component(
  value : Int,
  storage : Map[@entity.Entity, T],
  make : (LdtkIntGridCellSpawnedEvent) -> T,
) -> Unit {
  add_ldtk_int_cell_component_for_layer_optional(
    None,
    Some(value),
    storage,
    make,
  )
}

///|
pub fn[T] add_default_ldtk_int_cell_component_for_layer(
  layer_identifier : String,
  storage : Map[@entity.Entity, T],
  make : (LdtkIntGridCellSpawnedEvent) -> T,
) -> Unit {
  add_ldtk_int_cell_component_for_layer_optional(
    Some(layer_identifier),
    None,
    storage,
    make,
  )
}

///|
pub fn[T] add_default_ldtk_int_cell_component(
  storage : Map[@entity.Entity, T],
  make : (LdtkIntGridCellSpawnedEvent) -> T,
) -> Unit {
  add_ldtk_int_cell_component_for_layer_optional(None, None, storage, make)
}

///|
pub fn register_ldtk_entity_spawn_hook(
  identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_spawn_hooks().set(identifier, hook)
}

///|
pub fn register_ldtk_entity_spawn_hook_optional(
  layer_identifier : String?,
  identifier : String?,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  match (layer_identifier, identifier) {
    (Some(layer), Some(entity_identifier)) =>
      register_ldtk_entity_spawn_hook_for_layer(layer, entity_identifier, hook)
    (Some(layer), None) => register_ldtk_entity_layer_spawn_hook(layer, hook)
    (None, Some(entity_identifier)) =>
      register_ldtk_entity_spawn_hook(entity_identifier, hook)
    (None, None) => register_ldtk_entity_default_spawn_hook(hook)
  }
}

///|
pub fn register_ldtk_entity_layer_spawn_hook(
  layer_identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_layer_spawn_hooks().set(layer_identifier, hook)
}

///|
pub fn register_ldtk_entity_spawn_hook_for_layer(
  layer_identifier : String,
  identifier : String,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_layer_identifier_spawn_hooks().set(
    ldtk_entity_layer_identifier_spawn_hook_key(layer_identifier, identifier),
    hook,
  )
}

///|
pub fn register_ldtk_entity_default_spawn_hook(
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  ldtk_entity_default_spawn_hook().val = Some(hook)
}

///|
pub fn unregister_ldtk_entity_spawn_hook(identifier : String) -> Unit {
  ldtk_entity_spawn_hooks().remove(identifier)
}

///|
pub fn unregister_ldtk_entity_spawn_hook_optional(
  layer_identifier : String?,
  identifier : String?,
) -> Unit {
  match (layer_identifier, identifier) {
    (Some(layer), Some(entity_identifier)) =>
      unregister_ldtk_entity_spawn_hook_for_layer(layer, entity_identifier)
    (Some(layer), None) => unregister_ldtk_entity_layer_spawn_hook(layer)
    (None, Some(entity_identifier)) =>
      unregister_ldtk_entity_spawn_hook(entity_identifier)
    (None, None) => clear_ldtk_entity_default_spawn_hook()
  }
}

///|
pub fn unregister_ldtk_entity_layer_spawn_hook(
  layer_identifier : String,
) -> Unit {
  ldtk_entity_layer_spawn_hooks().remove(layer_identifier)
}

///|
pub fn unregister_ldtk_entity_spawn_hook_for_layer(
  layer_identifier : String,
  identifier : String,
) -> Unit {
  ldtk_entity_layer_identifier_spawn_hooks().remove(
    ldtk_entity_layer_identifier_spawn_hook_key(layer_identifier, identifier),
  )
}

///|
pub fn clear_ldtk_entity_default_spawn_hook() -> Unit {
  ldtk_entity_default_spawn_hook().val = None
}

///|
pub fn clear_ldtk_entity_spawn_hooks() -> Unit {
  for pair in ldtk_entity_spawn_hooks().to_array() {
    ldtk_entity_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_entity_layer_spawn_hooks().to_array() {
    ldtk_entity_layer_spawn_hooks().remove(pair.0)
  }
  for pair in ldtk_entity_layer_identifier_spawn_hooks().to_array() {
    ldtk_entity_layer_identifier_spawn_hooks().remove(pair.0)
  }
  ldtk_entity_default_spawn_hook().val = None
}

///|
pub fn register_ldtk_int_grid_layer_spawn_hook(
  layer_identifier : String,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_layer_spawn_hooks().set(layer_identifier, hook)
}

///|
pub fn register_ldtk_int_grid_spawn_hook_optional(
  layer_identifier : String?,
  value : Int?,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  match (layer_identifier, value) {
    (Some(layer), Some(cell_value)) =>
      register_ldtk_int_grid_cell_spawn_hook(layer, cell_value, hook)
    (Some(layer), None) => register_ldtk_int_grid_layer_spawn_hook(layer, hook)
    (None, Some(cell_value)) =>
      register_ldtk_int_grid_value_spawn_hook(cell_value, hook)
    (None, None) => register_ldtk_int_grid_default_spawn_hook(hook)
  }
}

///|
pub fn register_ldtk_int_grid_value_spawn_hook(
  value : Int,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_value_spawn_hooks().set(
    ldtk_int_grid_value_spawn_hook_key(value),
    hook,
  )
}

///|
pub fn register_ldtk_int_grid_default_spawn_hook(
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  ldtk_int_grid_default_spawn_hook().val = Some(hook)
}

///|
pub fn unregister_ldtk_int_grid_layer_spawn_hook(
  layer_identifier : String,
) -> Unit {
  ldtk_int_grid_layer_spawn_hooks().remove(layer_identifier)
}

///|
pub fn unregister_ldtk_int_grid_spawn_hook_optional(
  layer_identifier : String?,
  value : Int?,
) -> Unit {
  match (layer_identifier, value) {
    (Some(layer), Some(cell_value)) =>
      unregister_ldtk_int_grid_cell_spawn_hook(layer, cell_value)
    (Some(layer), None) => unregister_ldtk_int_grid_layer_spawn_hook(layer)
    (None, Some(cell_value)) =>
      unregister_ldtk_int_grid_value_spawn_hook(cell_value)
    (None, None) => clear_ldtk_int_grid_default_spawn_hook()
  }
}
